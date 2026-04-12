from tinygrad import Tensor, UOp, Device
from tinygrad.dtype import dtypes
from tinygrad.helpers import Context, DEBUG, getenv
from tinygrad.uop.ops import KernelInfo, Ops
from pathlib import Path


def build_atomic_amax_kernel(global_size:int, local_size:int, n:int):
  assert local_size == 64, "HipKittens demo uses one 64-thread warp per block"
  assert n % 512 == 0, "N must be divisible by 512 (one 16x32 tile per block)"
  code = f"""
#include <hip/hip_runtime.h>
#include "kittens.cuh"

using namespace kittens;

constexpr unsigned int GRID = {global_size};
constexpr unsigned int BLOCK = WARP_THREADS;
constexpr unsigned int TILE_R = 16;
constexpr unsigned int TILE_C = 32;
constexpr unsigned int ELEMS_PER_TILE = TILE_R * TILE_C;
constexpr unsigned int N = {n};

using ST = st_bf<TILE_R, TILE_C, st_16x32_s>;
using RT = rt_bf<TILE_R, TILE_C, row_l, rt_16x32_s>;
using G = group<1>;

__device__ __forceinline__ void atomicMaxFloatNonNeg(float* addr, float value) {{
  atomicMax(reinterpret_cast<int*>(addr), __float_as_int(value));
}}

extern "C" __global__ void atomic_amax_abs_kernel(float* out, const bf16* x) {{
  gl<bf16, 1, 1, -1, -1> X{{const_cast<bf16*>(x), nullptr, nullptr, (size_t)(N / TILE_C), (size_t)TILE_C}};

  const int tile_idx = blockIdx.x;
  __shared__ ST smem;
  RT reg;
  typename RT::col_vec row_max_vec;

  G::load(smem, X, {{0, 0, tile_idx, 0}});
  __builtin_amdgcn_s_waitcnt(0);
  __syncthreads();

  load(reg, smem);
  abs(reg, reg);
  row_max(row_max_vec, reg);

  bf16 tile_max_bf = bf16(0.0f);
  max(tile_max_bf, row_max_vec);
  float tile_max = (float)tile_max_bf;
  if (laneid() == 0) atomicMaxFloatNonNeg(out, tile_max);
}}
"""

  def runner(out:UOp, buf:UOp) -> UOp:
    from tinygrad.runtime.support.compiler_amd import HIPCCCompiler

    kittens_path = Path("extra") / "thunder" / "amd"
    lib = HIPCCCompiler(Device[Device.DEFAULT].renderer.target.arch, [f"-I{(kittens_path/'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math", "-DHIP_ENABLE_WARP_SYNC_BUILTINS"]).compile_cached(code)
    sink = UOp.sink(
      UOp.special(global_size, "gidx0"),
      UOp.special(local_size, "lidx0"),
      out,
      buf,
      arg=KernelInfo(name="atomic_amax_abs_kernel"),
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
  global_size = getenv("GLOBALS", n // 512)
  local_size = getenv("LOCALS", 64)
  assert global_size * 512 == n, "GLOBALS must be N/512 for this tiled demo"

  x = (Tensor.randn(n) * 1000).cast(dtypes.bfloat16).contiguous().realize()
  expected = x.float().abs().max().item()

  out = Tensor.zeros(1, dtype=dtypes.float).contiguous().realize()
  fxn = build_atomic_amax_kernel(global_size, local_size, n)

  with Context(DEBUG=max(DEBUG.value, 2)):
    got = out.custom_kernel(x, fxn=fxn)[0].item()

  rel = abs(got - expected) / max(abs(expected), 1e-12)
  print(f"expected={expected:.6f}")
  print(f"atomic_max={got:.6f}")
  print(f"rel_err={rel:.3e}")
