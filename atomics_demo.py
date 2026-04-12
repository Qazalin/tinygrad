from tinygrad import Tensor, UOp, Device
from tinygrad.dtype import dtypes
from tinygrad.helpers import Context, DEBUG, getenv
from tinygrad.uop.ops import KernelInfo, Ops


def build_atomic_amax_kernel(global_size:int, local_size:int, n:int):
  code = f"""
#include <hip/hip_runtime.h>

constexpr unsigned int GRID = {global_size};
constexpr unsigned int BLOCK = {local_size};

__device__ __forceinline__ void atomicMaxFloatNonNeg(float* addr, float value) {{
  atomicMax(reinterpret_cast<int*>(addr), __float_as_int(value));
}}

extern "C" __global__ void atomic_amax_abs_kernel(float* out, const float* x) {{
  __shared__ float smax[BLOCK];

  const unsigned int tid = threadIdx.x;
  const unsigned int gid = blockIdx.x * BLOCK + tid;
  const unsigned int stride = GRID * BLOCK;

  float local_max = 0.0f;
  for (unsigned int i = gid; i < {n}; i += stride) {{
    local_max = fmaxf(local_max, fabsf(x[i]));
  }}

  smax[tid] = local_max;
  __syncthreads();

  for (unsigned int s = BLOCK >> 1; s > 0; s >>= 1) {{
    if (tid < s) smax[tid] = fmaxf(smax[tid], smax[tid + s]);
    __syncthreads();
  }}

  if (tid == 0) atomicMaxFloatNonNeg(out, smax[0]);
}}
"""

  def runner(out:UOp, buf:UOp) -> UOp:
    from tinygrad.runtime.support.compiler_amd import HIPCCCompiler

    lib = HIPCCCompiler(Device[Device.DEFAULT].renderer.target.arch, []).compile_cached(code)
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
  global_size = getenv("GLOBALS", 1024)
  local_size = getenv("LOCALS", 256)

  x = (Tensor.randn(n) * 1000).cast(dtypes.float).contiguous().realize()
  expected = x.abs().max().item()

  out = Tensor.zeros(1, dtype=dtypes.float).contiguous().realize()
  fxn = build_atomic_amax_kernel(global_size, local_size, n)

  with Context(DEBUG=max(DEBUG.value, 2)):
    got = out.custom_kernel(x, fxn=fxn)[0].item()

  rel = abs(got - expected) / max(abs(expected), 1e-12)
  print(f"expected={expected:.6f}")
  print(f"atomic_max={got:.6f}")
  print(f"rel_err={rel:.3e}")
