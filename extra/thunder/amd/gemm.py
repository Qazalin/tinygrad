import pathlib, functools

from tinygrad.helpers import getenv
from tinygrad.renderer import Estimates
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
from tinygrad.uop.ops import UOp, Ops, KernelInfo

HK_4WAVE = getenv("HK_4WAVE", 0)
BLOCK_SIZE = 256
BLOCK_K = 128

@functools.cache
def custom_hk_fp8_gemm(C:UOp, A:UOp, B:UOp, dname:str, arch:str):
  # A is (batch, M, K), B is (N, K) transposed — kernel sees flat pointers
  M = A.shape[0] * A.shape[1] if A.ndim == 3 else A.shape[0]  # fold batch into M
  N, K = B.shape[(1 if B.ndim == 3 else 0):]

  four_wave = HK_4WAVE
  cpp_file = "gemm_fp8_4wave.cpp" if four_wave else "gemm_fp8.cpp"
  code = (pathlib.Path(__file__).parent / cpp_file).read_text()

  compile_args = [f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-DHIP_ENABLE_WARP_SYNC_BUILTINS",
                  "-ffast-math", f"-DGEMM_M={M}", f"-DGEMM_N={N}", f"-DGEMM_K={K}"]

  NUM_WARPS = 4 if four_wave else 8
  NUM_THREADS = 64 * NUM_WARPS
  num_blocks = (M // BLOCK_SIZE) * (N // BLOCK_SIZE)
  threadIdx_x = UOp.special(NUM_THREADS, "lidx0")
  blockIdx_x = UOp.special(num_blocks, "gidx0")

  mem = (M*K + N*K) * A.dtype.itemsize + M*N * C.dtype.itemsize
  estimates = Estimates(ops=2*M*N*K, lds=mem, mem=mem)
  sink = UOp.sink(C.base, A.base, B.base,
                  threadIdx_x, blockIdx_x,
                  arg=KernelInfo(name=f"hk_fp8_gemm_{M}_{N}_{K}", estimates=estimates))

  lib = HIPCCCompiler(arch, compile_args).compile_cached(code)

  return UOp(Ops.PROGRAM,
             src=(sink, UOp(Ops.DEVICE, arg=dname), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=code), UOp(Ops.BINARY, arg=lib)))
