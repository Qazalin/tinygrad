from pathlib import Path
from tinygrad import Tensor, dtypes, Context, Device
from tinygrad.uop.ops import UOp, KernelInfo, Ops
from tinygrad.renderer import Estimates
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
import numpy as np

def kitten_copy(C:UOp, A:UOp, B:UOp):
  # 4 warps * 64 threads/warp = 256 threads per workgroup
  num_threads = 4 * 64
  # tile the NxN matrix into (N/TILE)^2 workgroups
  num_wg = (N // TILE) * (N // TILE)
  threads = UOp.special(num_threads, "lidx0")
  workgroups = UOp.special(num_wg, "gidx0")
  sink = UOp.sink(C.base, A.base, B.base, threads, workgroups,
                  arg=KernelInfo("kitten", estimates=Estimates()))
  src = Path("kitten.cpp").read_text()
  kittens_path = Path("extra")/"thunder"/"amd"
  lib = HIPCCCompiler("gfx950", [f"-I{(kittens_path/'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math",
                                 "-DHIP_ENABLE_WARP_SYNC_BUILTINS", f"-DGEMM_N={N}",]).compile_cached(src)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=src),
                               UOp(Ops.BINARY, arg=lib)))

if __name__ == "__main__":
  N = 8192
  TILE = 64
  dtype = dtypes.bfloat16
  Tensor.manual_seed(0)
  a_rand = Tensor.randn(N, N, dtype=dtypes.float).sub(0.5).cast(dtype)
  b_rand = Tensor.randn(N, N, dtype=dtypes.float).sub(0.5).cast(dtype)  # unused but kept for signature
  with Context(DEBUG=0):
    Tensor.realize(a_rand, b_rand)

  c_custom = Tensor.empty(N, N, dtype=dtype)
  c_custom = Tensor.custom_kernel(c_custom, a_rand, b_rand, fxn=kitten_copy)[0].realize()

  # verify: the kernel just copies A -> C, so C should equal A
  a_np = a_rand.numpy()
  c_np = c_custom.numpy()
  print(f"A[:4,:4]:\n{a_np[:4,:4]}")
  print(f"C[:4,:4]:\n{c_np[:4,:4]}")
  print(f"match: {np.allclose(a_np, c_np, atol=0, rtol=0)}")
  if not np.allclose(a_np, c_np, atol=0, rtol=0):
    diff = np.abs(a_np.astype(np.float32) - c_np.astype(np.float32))
    print(f"max diff: {diff.max()}, num nonzero: {np.count_nonzero(diff)}/{diff.size}")
