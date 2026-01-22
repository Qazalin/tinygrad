import pathlib, struct
import numpy as np
from tinygrad import Tensor, Device, dtypes
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.engine.realize import Estimates
from tinygrad.helpers import getenv, time_to_str, colored, Context

# MT128x128x64 kernel constants
MT0, MT1, KT, WORKGROUP_SIZE = 128, 128, 64, 256

def _ceildiv(a, b): return -(-a // b)
def _magic(d): return 0xFFFFFFFF if d <= 1 else min(((1 << 32) + d - 1) // d, 0xFFFFFFFF)
def _f32(f): return struct.unpack('I', struct.pack('f', f))[0]
def _u32(u): return u & 0xFFFFFFFF

def fast_matmul(A: Tensor, B: Tensor) -> Tensor:
  # Handle 2D input (add batch dim)
  squeeze = A.ndim == 2
  if squeeze:
    A = A.unsqueeze(0)

  # Extract dimensions: A=(batch,M,K), B=(K,N), out=(batch,M,N)
  batch, M, K = A.shape
  K2, N = B.shape

  # Input validation
  assert A.dtype == dtypes.half and B.dtype == dtypes.half
  assert K == K2 and K % KT == 0 and K >= KT * 3

  # Calculate kernel parameters
  BM = batch * M
  tiles_N, tiles_BM = _ceildiv(N, MT0), _ceildiv(BM, MT1)
  numWG = tiles_N * tiles_BM
  iters = K // KT

  # Build params tensor with all 25 scalar values as uint32
  params = Tensor([
    1, 0, _u32((((tiles_N << 11) + 1) << 16) | 0x0006), numWG, N, BM, 1, K, 
    N, 0, N, 0, N, 0, K, 0,
    _f32(1.0), _f32(0.0),
    iters, _u32(_magic(iters)), 0, numWG * iters, iters, numWG, numWG,
  ], dtype=dtypes.uint32)
  with Context(DEBUG=0): params.realize()

  def custom_gemm(out_uop: UOp, A_uop: UOp, B_uop: UOp, ws_uop: UOp, flags_uop: UOp, params_uop: UOp) -> UOp:
    lidx = UOp.special(WORKGROUP_SIZE, "lidx0")
    gidx = UOp.special(numWG, "gidx0")
    src = (pathlib.Path(__file__).parent / "kernel.s").read_text()
    # Sink: out, A, B, ws, flags, params (6 buffers)
    sink = UOp.sink(out_uop.base, A_uop.base, B_uop.base, ws_uop.base, flags_uop.base, params_uop.base,
                    lidx, gidx, arg=KernelInfo(name="gemm", estimates=Estimates(ops=2*BM*N*K, mem=(BM*K + K*N + BM*N)*2)))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=src)))

  out = Tensor.empty((batch, M, N), dtype=dtypes.half)
  # what are these two?
  ws = Tensor.empty(1024*1024, dtype=dtypes.float32)
  flags = Tensor.empty(1024*1024, dtype=dtypes.half)
  out = Tensor.custom_kernel(out, A, B, ws, flags, params, fxn=custom_gemm)[0]

  return out.squeeze(0) if squeeze else out

if __name__ == "__main__":
  M, N, K, batch = getenv("M", 612), getenv("N", 1024), getenv("K", 1024), getenv("B", 6)

  rng = np.random.default_rng(0)
  A = Tensor(rng.random((batch, M, K), dtype=np.float32) - 0.5, dtype=dtypes.half)
  B = Tensor(rng.random((K, N), dtype=np.float32) - 0.5, dtype=dtypes.half)
  Tensor.realize(A, B)

  C_asm = fast_matmul(A, B)
  C_tiny = A @ B

  Tensor.realize(C_asm, C_tiny)
  print(f"M={M} N={N} K={K} batch={B}")
  np.testing.assert_allclose(C_asm.numpy(), C_tiny.numpy(), rtol=1e-2, atol=1e-2)
  print("PASS")
