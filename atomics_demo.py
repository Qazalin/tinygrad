from pathlib import Path

from tinygrad import Device, Tensor, UOp
from tinygrad.dtype import dtypes
from tinygrad.helpers import Context, DEBUG, getenv
from tinygrad.uop.ops import KernelInfo, Ops


def build_partial_amax_kernel(global_size:int, local_size:int, n:int):
  assert local_size == 64, "HipKittens demo uses one 64-thread warp per block"
  assert n % 512 == 0, "N must be divisible by 512 (one 16x32 tile per block)"
  num_tiles = n // 512
  assert 1 <= global_size <= num_tiles, "GLOBALS must be in [1, N/512]"
  code = f"""
#include <hip/hip_runtime.h>
#include "kittens.cuh"

using namespace kittens;

constexpr unsigned int GRID = {global_size};
constexpr unsigned int TILE_R = 16;
constexpr unsigned int TILE_C = 32;
constexpr unsigned int ELEMS_PER_TILE = TILE_R * TILE_C;
constexpr unsigned int N = {n};
constexpr unsigned int NUM_TILES = N / ELEMS_PER_TILE;

using ST = st_bf<TILE_R, TILE_C, st_16x32_s>;
using G = group<1>;

extern "C" __global__ void kitten_partial_amax_kernel(float* partials, const bf16* x) {{
  gl<bf16, 1, 1, -1, -1> X{{const_cast<bf16*>(x), nullptr, nullptr, (size_t)(N / TILE_C), (size_t)TILE_C}};

  __shared__ ST smem;
  float block_max = 0.0f;

  for (unsigned int tile_idx = blockIdx.x; tile_idx < NUM_TILES; tile_idx += GRID) {{
    G::load(smem, X, {{0, 0, (int)tile_idx, 0}});
    __builtin_amdgcn_s_waitcnt(0);
    __syncthreads();
    if (laneid() == 0) {{
      float tile_max = 0.0f;
      #pragma unroll
      for (int i = 0; i < ELEMS_PER_TILE; i++) tile_max = fmaxf(tile_max, fabsf((float)smem.data[i]));
      block_max = fmaxf(block_max, tile_max);
    }}
    __syncthreads();
  }}
  if (laneid() == 0) partials[blockIdx.x] = block_max;
}}
"""

  def runner(partials:UOp, buf:UOp) -> UOp:
    from tinygrad.runtime.support.compiler_amd import HIPCCCompiler

    kittens_path = Path("extra") / "thunder" / "amd"
    lib = HIPCCCompiler(Device[Device.DEFAULT].renderer.target.arch, [f"-I{(kittens_path/'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math", "-DHIP_ENABLE_WARP_SYNC_BUILTINS"]).compile_cached(code)
    sink = UOp.sink(
      UOp.special(global_size, "gidx0"),
      UOp.special(local_size, "lidx0"),
      partials,
      buf,
      arg=KernelInfo(name="kitten_partial_amax_kernel"),
    )
    return UOp(
      Ops.PROGRAM,
      src=(
        sink,
        UOp(Ops.DEVICE, arg=Device.DEFAULT),
        UOp(Ops.LINEAR, src=(*sink.src, sink)),
        UOp(Ops.SOURCE, arg=code),
        UOp(Ops.BINARY, arg=lib),
      ),
    )

  return runner


def build_final_reduce_kernel(num_partials:int, local_size:int=256):
  assert num_partials >= 1
  code = f"""
#include <hip/hip_runtime.h>

constexpr unsigned int N = {num_partials};
constexpr unsigned int BLOCK = {local_size};

extern "C" __global__ void reduce_partials_max_kernel(float* out, const float* partials) {{
  __shared__ float smax[BLOCK];
  unsigned int tid = threadIdx.x;
  float v = 0.0f;
  for (unsigned int i = tid; i < N; i += BLOCK) v = fmaxf(v, partials[i]);
  smax[tid] = v;
  __syncthreads();
  for (unsigned int s = BLOCK >> 1; s > 0; s >>= 1) {{
    if (tid < s) smax[tid] = fmaxf(smax[tid], smax[tid + s]);
    __syncthreads();
  }}
  if (tid == 0) out[0] = smax[0];
}}
"""

  def runner(out:UOp, partials:UOp) -> UOp:
    from tinygrad.runtime.support.compiler_amd import HIPCCCompiler

    lib = HIPCCCompiler(Device[Device.DEFAULT].renderer.target.arch, []).compile_cached(code)
    sink = UOp.sink(
      UOp.special(1, "gidx0"),
      UOp.special(local_size, "lidx0"),
      out,
      partials,
      arg=KernelInfo(name="reduce_partials_max_kernel"),
    )
    return UOp(
      Ops.PROGRAM,
      src=(
        sink,
        UOp(Ops.DEVICE, arg=Device.DEFAULT),
        UOp(Ops.LINEAR, src=(*sink.src, sink)),
        UOp(Ops.SOURCE, arg=code),
        UOp(Ops.BINARY, arg=lib),
      ),
    )

  return runner


if __name__ == "__main__":
  # defaults: DEV=AMD python atomics_demo.py
  n = getenv("N", 8 * 1024 * 1024)
  num_tiles = n // 512
  global_size = getenv("GLOBALS", min(131072, num_tiles))
  local_size = getenv("LOCALS", 64)
  assert 1 <= global_size <= num_tiles, "GLOBALS must be in [1, N/512]"

  x = (Tensor.randn(n) * 1000).cast(dtypes.bfloat16).contiguous().realize()
  expected = x.float().abs().max().item()

  partials = Tensor.zeros(global_size, dtype=dtypes.float).contiguous().realize()
  out = Tensor.zeros(1, dtype=dtypes.float).contiguous().realize()

  fxn1 = build_partial_amax_kernel(global_size, local_size, n)
  fxn2 = build_final_reduce_kernel(global_size)

  with Context(DEBUG=max(DEBUG.value, 2)):
    tmp = partials.custom_kernel(x, fxn=fxn1)[0]
    got = out.custom_kernel(tmp, fxn=fxn2)[0].item()

  rel = abs(got - expected) / max(abs(expected), 1e-12)
  print(f"expected={expected:.6f}")
  print(f"atomic_max={got:.6f}")
  print(f"rel_err={rel:.3e}")
