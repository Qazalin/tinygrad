from pathlib import Path
from tinygrad import Tensor, dtypes, Context, Device
from tinygrad.uop.ops import UOp, KernelInfo, Ops
from tinygrad.renderer import Estimates
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler

N = 4096
a_shape = (N, N)
b_shape = (N, N)
dtype = dtypes.bfloat16
Tensor.manual_seed(0)
a_rand = Tensor.randn(a_shape, dtype=dtypes.float).sub(0.5).cast(dtype)
b_rand = Tensor.randn(b_shape, dtype=dtypes.float).sub(0.5).cast(dtype)
with Context(DEBUG=0):
  Tensor.realize(a_rand, b_rand)

def kitten_gemm(C:UOp, A:UOp, B:UOp):
  num_threads = 1
  num_wg = 1
  threads = UOp.special(num_threads, "lidx0")
  workgroups = UOp.special(num_wg, "gidx0")
  sink = UOp.sink(C.base, A.base, B.base, threads, workgroups,
                  arg=KernelInfo("kitten_gemm", estimates=Estimates()))
  src = Path("gemm_fp8.cpp").read_text()
  kittens_path = Path("extra")/"thunder"/"amd"
  lib = HIPCCCompiler("gfx950", [f"-I{(kittens_path/'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math",
                                 "-DHIP_ENABLE_WARP_SYNC_BUILTINS", f"-DGEMM_N={N}",]).compile_cached(src)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=src),
                               UOp(Ops.BINARY, arg=lib)))
c_custom = Tensor.empty(N, N)
c_custom = Tensor.custom_kernel(c_custom, a_rand, b_rand, fxn=kitten_gemm)[0].realize()
c_ref = a_rand @ b_rand
print(c_ref.numpy())
print(c_custom.numpy())
