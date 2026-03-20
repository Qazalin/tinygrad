import pathlib, functools

from tinygrad import Device, Tensor
from tinygrad.dtype import dtypes
from tinygrad.helpers import DEBUG, getenv
from tinygrad.renderer import Estimates
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
from tinygrad.uop.ops import UOp, Ops, KernelInfo

HK_4WAVE = getenv("HK_4WAVE", 0)
BLOCK_SIZE = 256
BLOCK_K = 128

def can_use_hk_gemm(M:int, N:int, K:int) -> bool:
  return M % BLOCK_SIZE == 0 and N % BLOCK_SIZE == 0 and K % BLOCK_K == 0 and K >= 2 * BLOCK_K

@functools.cache
def custom_hk_fp8_gemm(C:UOp, A:UOp, B:UOp, device:str, arch:str, M:int, N:int, K:int, four_wave:int=0):
  cpp_file = "gemm_fp8_4wave.cpp" if four_wave else "gemm_fp8.cpp"
  code = (pathlib.Path(__file__).parent / cpp_file).read_text()
  compile_args = [f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-DHIP_ENABLE_WARP_SYNC_BUILTINS", "-ffast-math",
                  f"-DGEMM_M={M}", f"-DGEMM_N={N}", f"-DGEMM_K={K}"]

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
             src=(sink, UOp(Ops.DEVICE, arg=device), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=code), UOp(Ops.BINARY, arg=lib)))

def hk_fp8_gemm(a:Tensor, b:Tensor) -> Tensor:
  """FP8 GEMM: C(M,N) = A(M,K) @ B(K,N), output bf16. B is passed as (K,N) and transposed internally for the HK kernel which expects (N,K)."""
  assert a.dtype == dtypes.fp8e4m3 and b.dtype == dtypes.fp8e4m3, f"inputs must be fp8e4m3, got {a.dtype}, {b.dtype}"
  squeeze = a.ndim == 2
  if squeeze: a = a.unsqueeze(0)
  batch, M, K = a.shape
  # b is (K, N) from tinygrad's dot convention
  K2, N = b.shape[-2], b.shape[-1]
  assert K == K2, f"K mismatch: {K} vs {K2}"

  # fold batch into M
  BM = batch * M
  device = a.device[0] if isinstance(a.device, tuple) else a.device
  arch = Device[device].renderer.arch

  if not can_use_hk_gemm(BM, N, K):
    if DEBUG >= 1: print(f"hk_fp8_gemm: shape ({BM},{N},{K}) not supported, falling back")
    return None

  # HK kernel expects B as (N, K) — transpose and make contiguous
  b_t = b.T.contiguous()
  a_flat = a.reshape(BM, K) if batch > 1 else a.squeeze(0)

  out = Tensor.invalid(BM, N, dtype=dtypes.bfloat16, device=a.device)
  out = Tensor.custom_kernel(out, a_flat, b_t, fxn=functools.partial(custom_hk_fp8_gemm, device=device, arch=arch, M=BM, N=N, K=K, four_wave=HK_4WAVE))[0]
  if not squeeze: out = out.reshape(batch, M, N)
  if squeeze: out = out.squeeze(0)
  return out
