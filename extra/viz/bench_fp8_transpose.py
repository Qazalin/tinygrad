#!/usr/bin/env python3
import argparse, pathlib, statistics
from dataclasses import dataclass

from tinygrad import Device
from tinygrad.device import Buffer
from tinygrad.dtype import dtypes
from tinygrad.helpers import Context, GlobalCounters, ansistrip, temp
from tinygrad.uop.ops import Ops
from tinygrad.viz.serve import VizData, _reconstruct, load_pickle

ROWS, COLS = 16384, 28672
NUMEL = ROWS * COLS

@dataclass(frozen=True)
class KernelSpec:
  label: str
  source: str
  name: str
  global_size: tuple[int, int, int]
  local_size: tuple[int, int, int]
  hipcc_opts: tuple[str, ...] = ()

def traced_spec(kernel_name:str, pickle_path:str|None) -> KernelSpec:
  data = VizData(load_pickle(pickle_path or temp("rewrites.pkl", append_user=True), []))
  for i,k in enumerate(data.trace.keys):
    if ansistrip(k.display_name).endswith(kernel_name): break
  else: raise RuntimeError(f"kernel {kernel_name!r} not found in rewrites")
  prg = _reconstruct(data, data.trace.rewrites[i][-1].sink)
  assert prg.op is Ops.PROGRAM and prg.src[3].op is Ops.SOURCE
  return KernelSpec("trace", prg.src[3].arg, prg.arg.name, prg.arg.global_size, prg.arg.local_size)

def te_v2_spec(load_size:int, store_size:int, threads_per_warp:int, warps_per_tile:int) -> KernelSpec:
  src_path = pathlib.Path(__file__).parents[1] / "llama_kernels/fp8_fast_transpose_v2/fp8_fast_transpose_v2.cpp"
  tile_rows, tile_cols = threads_per_warp * store_size, threads_per_warp * load_size
  if ROWS % tile_rows or COLS % tile_cols: raise ValueError(f"unaligned TE tile {(tile_rows, tile_cols)} for {(ROWS, COLS)}")
  opts = ("-std=c++20", "-ffast-math", f"-DROWS_DIM={ROWS}", f"-DCOLS_DIM={COLS}", f"-DLOAD_SIZE={load_size}",
          f"-DSTORE_SIZE={store_size}", f"-DTHREADS_PER_WARP={threads_per_warp}", f"-DWARPS_PER_TILE={warps_per_tile}")
  return KernelSpec(f"te_v2_l{load_size}_s{store_size}_w{threads_per_warp}x{warps_per_tile}", src_path.read_text(),
                    "fp8_fast_transpose_v2", ((ROWS//tile_rows) * (COLS//tile_cols), 1, 1),
                    (threads_per_warp*warps_per_tile, 1, 1), opts)

def lds64_spec() -> KernelSpec:
  src_path = pathlib.Path(__file__).parents[1] / "llama_kernels/fp8_transpose/fp8_transpose.cpp"
  opts = ("-std=c++20", "-ffast-math", f"-DM_DIM={ROWS}", f"-DN_DIM={COLS}")
  return KernelSpec("lds64", src_path.read_text(), "fp8_transpose", ((ROWS//64)*(COLS//64), 1, 1), (256, 1, 1), opts)

def amd_like_lds128_spec() -> KernelSpec:
  # Inspired by AMD's 0058 transpose object: 128 threads, 128x128 fp8 tile, LDS staged, dword load/store.
  src = f'''typedef long unsigned int size_t;
typedef unsigned char uint8_t;
typedef unsigned int uint32_t;
#define __shared__ __attribute__((shared, aligned(16)))
extern "C" __attribute__((device, const)) size_t __ockl_get_local_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_group_id(unsigned int);
static inline __attribute__((device)) void wg_barrier() {{
  __builtin_amdgcn_fence(__ATOMIC_RELEASE, "workgroup");
  __builtin_amdgcn_s_barrier();
  __builtin_amdgcn_fence(__ATOMIC_ACQUIRE, "workgroup");
}}
union Vec4 {{ uint32_t u; uint8_t b[4]; }};
extern "C" __attribute__((global)) void __attribute__((amdgpu_flat_work_group_size(1, 128))) fp8_amd_like_lds128(uint8_t* out, uint8_t* in) {{
  __shared__ uint32_t lds[32][33];
  int tid = __ockl_get_local_id(0);
  int lane = tid & 31;
  int warp = tid >> 5;
  int tile = __ockl_get_group_id(0);
  int tiles_m = {ROWS//128};
  int tile_r = tile % tiles_m;
  int tile_c = tile / tiles_m;
  int row0 = tile_r * 128;
  int col0 = tile_c * 128;
  Vec4 acc[4][8];
  #pragma unroll
  for (int it = 0; it < 8; it++) {{
    int i1 = warp + it * 4;
    int col = col0 + lane * 4;
    #pragma unroll
    for (int i2 = 0; i2 < 4; i2++) {{
      Vec4 v; v.u = *((uint32_t*)(in + (row0 + i1*4 + i2) * {COLS} + col));
      acc[0][it].b[i2] = v.b[0];
      acc[1][it].b[i2] = v.b[1];
      acc[2][it].b[i2] = v.b[2];
      acc[3][it].b[i2] = v.b[3];
    }}
  }}
  #pragma unroll
  for (int j2 = 0; j2 < 4; j2++) {{
    #pragma unroll
    for (int it = 0; it < 8; it++) lds[lane][warp + it*4] = acc[j2][it].u;
    wg_barrier();
    #pragma unroll
    for (int it = 0; it < 8; it++) {{
      int dst_row = col0 + (warp + it*4) * 4 + j2;
      int dst_col = row0 + lane * 4;
      *((uint32_t*)(out + dst_row * {ROWS} + dst_col)) = lds[warp + it*4][lane];
    }}
    wg_barrier();
  }}
}}'''
  return KernelSpec("amd_like_lds128", src, "fp8_amd_like_lds128", ((ROWS//128)*(COLS//128), 1, 1), (128, 1, 1))

def reg16_grid_spec(local_y:int=8, local_z:int=8) -> KernelSpec:
  assert 16 * local_y * local_z <= 1024 and ROWS % (local_z*128) == 0 and COLS % (local_y*32) == 0
  # Same 16x16 register tile shape as tinygrad's generated kernel, but emitted from a concise source template.
  comps = "xyzw"
  lines = [f'''typedef long unsigned int size_t;
typedef unsigned char hip_fp8;
typedef hip_fp8 hip_fp84 __attribute__((ext_vector_type(4)));
extern "C" __attribute__((device, const)) size_t __ockl_get_local_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_group_id(unsigned int);
static inline __attribute__((device)) hip_fp84 make_hip_fp84(hip_fp8 a, hip_fp8 b, hip_fp8 c, hip_fp8 d) {{ return {{a,b,c,d}}; }}
extern "C" __attribute__((global)) void __attribute__((amdgpu_flat_work_group_size(1, 1024))) fp8_reg16_grid(hip_fp8* out, hip_fp8* in) {{
  int g0 = __ockl_get_group_id(0);
  int g1 = __ockl_get_group_id(1);
  int l0 = __ockl_get_local_id(0);
  int l1 = __ockl_get_local_id(1);
  int l2 = __ockl_get_local_id(2);
  int r = g0*{local_z*128} + l2*128 + (l0>>1)*16;
  int c = g1*{local_y*32} + l1*32 + (l0&1)*16;
  int base_in = r * {COLS} + c;
  int base_out = c * {ROWS} + r;''']
  for r in range(16):
    for g in range(4): lines.append(f"  hip_fp84 v{r}_{g} = *((hip_fp84*)(in + base_in + {r}*{COLS} + {g*4}));")
  for c in range(16):
    g, comp = divmod(c, 4)
    for rg in range(4):
      vals = ", ".join(f"v{rg*4+i}_{g}.{comps[comp]}" for i in range(4))
      lines.append(f"  *((hip_fp84*)(out + base_out + {c}*{ROWS} + {rg*4})) = make_hip_fp84({vals});")
  lines.append("}")
  return KernelSpec(f"reg16_grid_y{local_y}_z{local_z}", "\n".join(lines), "fp8_reg16_grid", (ROWS//(local_z*128), COLS//(local_y*32), 1), (16, local_y, local_z))

def reg16_perm_spec() -> KernelSpec:
  lines = [f'''typedef long unsigned int size_t;
typedef unsigned char uint8_t;
typedef unsigned int uint32_t;
extern "C" __attribute__((device, const)) size_t __ockl_get_local_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_group_id(unsigned int);
static inline __attribute__((device)) uint32_t pack_col(uint32_t a, uint32_t b, uint32_t c, uint32_t d, unsigned int i) {{
  uint32_t ab = __builtin_amdgcn_perm(a, b, i | ((i+4) << 8) | (i << 16) | ((i+4) << 24));
  uint32_t cd = __builtin_amdgcn_perm(c, d, i | ((i+4) << 8) | (i << 16) | ((i+4) << 24));
  return __builtin_amdgcn_perm(ab, cd, 0x05040100);
}}
extern "C" __attribute__((global)) void __attribute__((amdgpu_flat_work_group_size(1, 1024))) fp8_reg16_perm(uint8_t* out, uint8_t* in) {{
  int g0 = __ockl_get_group_id(0);
  int g1 = __ockl_get_group_id(1);
  int l0 = __ockl_get_local_id(0);
  int l1 = __ockl_get_local_id(1);
  int l2 = __ockl_get_local_id(2);
  int r = g0*1024 + l2*128 + (l0>>1)*16;
  int c = g1*256 + l1*32 + (l0&1)*16;
  int base_in = r * {COLS} + c;
  int base_out = c * {ROWS} + r;''']
  for r in range(16):
    for g in range(4): lines.append(f"  uint32_t v{r}_{g} = *((uint32_t*)(in + base_in + {r}*{COLS} + {g*4}));")
  for c in range(16):
    g, comp = divmod(c, 4)
    for rg in range(4):
      rows = ", ".join(f"v{rg*4+i}_{g}" for i in range(4))
      lines.append(f"  *((uint32_t*)(out + base_out + {c}*{ROWS} + {rg*4})) = pack_col({rows}, {comp});")
  lines.append("}")
  return KernelSpec("reg16_perm", "\n".join(lines), "fp8_reg16_perm", (ROWS//1024, COLS//256, 1), (16, 8, 8))

def compile_spec(device:str, spec:KernelSpec):
  dev = Device[device]
  if spec.label.startswith("amd_dump_"):
    lib = spec.source.encode('latin1')
  elif spec.hipcc_opts:
    from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
    lib = HIPCCCompiler(dev.renderer.target.arch, list(spec.hipcc_opts)).compile_cached(spec.source)
  else: lib = dev.compiler.compile_cached(spec.source)
  return dev.runtime(spec.name, lib)

def make_buffers(device:str) -> tuple[Buffer, Buffer, Buffer]:
  inp = Buffer(device, NUMEL, dtypes.uint8).allocate()
  ref = Buffer(device, NUMEL, dtypes.uint8).allocate()
  out = Buffer(device, NUMEL, dtypes.uint8).allocate()
  Device[device].synchronize()
  return inp, ref, out

def run(prg, out:Buffer, inp:Buffer, spec:KernelSpec, warmup:int, iters:int, noop:Buffer|None=None) -> list[float]:
  times = []
  for i in range(warmup + iters):
    tm = prg(out._buf, inp._buf, global_size=spec.global_size, local_size=spec.local_size, wait=True)
    if i >= warmup: times.append(tm)
  return times

def report(label:str, times:list[float]) -> None:
  us = [x*1e6 for x in times]
  gbps = (NUMEL*2) / statistics.median(times) / 1e9
  print(f"{label:28s} median {statistics.median(us):9.2f} us  mean {statistics.mean(us):9.2f} us  min {min(us):9.2f} us  {gbps:8.1f} GB/s")

def main():
  p = argparse.ArgumentParser(description="Benchmark fp8 transpose kernels for the W13 backward shape")
  p.add_argument("--device", default=Device.DEFAULT)
  p.add_argument("--kernel", default="E_112_16_2_8_8_8_16_4_4")
  p.add_argument("--pickle", default=None)
  p.add_argument("--iters", type=int, default=20)
  p.add_argument("--warmup", type=int, default=5)
  p.add_argument("--check", action="store_true", help="copy outputs back and compare each variant against trace")
  p.add_argument("--variant", choices=("te_v2", "lds64", "amd_like_lds128", "reg16_grid", "reg16_perm"), action="append", default=[])
  p.add_argument("--load-size", type=int, default=4)
  p.add_argument("--store-size", type=int, default=4)
  p.add_argument("--threads-per-warp", type=int, default=32)
  p.add_argument("--warps-per-tile", type=int, default=4)
  p.add_argument("--local-y", type=int, default=16)
  p.add_argument("--local-z", type=int, default=4)
  args = p.parse_args()

  with Context(DEBUG=0):
    GlobalCounters.reset()
    inp, ref, out = make_buffers(args.device)
    specs = [traced_spec(args.kernel, args.pickle)]
    for variant in args.variant or ["te_v2", "lds64", "amd_like_lds128", "reg16_grid", "reg16_perm"]:
      if variant == "te_v2": specs.append(te_v2_spec(args.load_size, args.store_size, args.threads_per_warp, args.warps_per_tile))
      elif variant == "lds64": specs.append(lds64_spec())
      elif variant == "amd_like_lds128": specs.append(amd_like_lds128_spec())
      elif variant == "reg16_grid": specs.append(reg16_grid_spec(args.local_y, args.local_z))
      elif variant == "reg16_perm": specs.append(reg16_perm_spec())

    print(f"fp8 transpose ({ROWS},{COLS}) -> ({COLS},{ROWS}), {NUMEL/1e6:.1f} MB")
    for spec in specs:
      prg = compile_spec(args.device, spec)
      times = run(prg, ref if spec.label == "trace" else out, inp, spec, args.warmup, args.iters)
      report(spec.label, times)
      if args.check and spec.label != "trace":
        got, exp = bytearray(NUMEL), bytearray(NUMEL)
        out.copyout(memoryview(got)); ref.copyout(memoryview(exp))
        assert got == exp, f"{spec.label} mismatch"
        print(f"{spec.label:28s} byte check passed")

if __name__ == "__main__": main()
