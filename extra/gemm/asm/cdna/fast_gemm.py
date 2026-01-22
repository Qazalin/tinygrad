import pathlib, struct, atexit
from tinygrad import Tensor, Device, dtypes
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.engine.realize import Estimates
from tinygrad.helpers import Context

# MT128x128x64 kernel constants
MT0, MT1, KT, WORKGROUP_SIZE = 128, 128, 64, 256

# Global counters for fast_gemm usage
_fast_gemm_stats = {"checked": 0, "used": 0, "reasons": {}}

def _print_fast_gemm_stats():
  if _fast_gemm_stats["checked"] > 0:
    print(f"fast_gemm: {_fast_gemm_stats['used']}/{_fast_gemm_stats['checked']} used")
    if _fast_gemm_stats["reasons"]:
      for reason, count in sorted(_fast_gemm_stats["reasons"].items(), key=lambda x: -x[1]):
        print(f"  {reason}: {count}")

atexit.register(_print_fast_gemm_stats)

def _reject(reason: str) -> bool:
  _fast_gemm_stats["reasons"][reason] = _fast_gemm_stats["reasons"].get(reason, 0) + 1
  return False

def _ceildiv(a, b): return -(-a // b)
def _magic(d): return 0xFFFFFFFF if d <= 1 else min(((1 << 32) + d - 1) // d, 0xFFFFFFFF)
def _f32(f): return struct.unpack('I', struct.pack('f', f))[0]
def _u32(u): return u & 0xFFFFFFFF

def can_use_fast_gemm(A: Tensor, B: Tensor) -> bool:
  """Check if fast_gemm can be used for this matmul."""
  _fast_gemm_stats["checked"] += 1
  if not Device.DEFAULT.startswith(("AMD", "HIP", "NULL")): return _reject("not AMD/HIP")
  if A.dtype != dtypes.half or B.dtype != dtypes.half: return _reject(f"dtype {A.dtype} {B.dtype} not half")
  if A.ndim < 2 or B.ndim != 2: return _reject(f"ndim {A.ndim}/{B.ndim}")
  K, N = A.shape[-1], B.shape[1]
  if K != B.shape[0]: return _reject(f"K mismatch {K} vs {B.shape[0]}")
  if K % KT != 0: return _reject(f"K={K} not divisible by {KT}")
  if K < KT * 3: return _reject(f"K={K} < {KT*3}")
  # Kernel uses 128x128 tiles, need reasonable M and N
  M = A.shape[-2] if A.ndim >= 2 else 1
  batch = int(A.shape[0]) if A.ndim == 3 else 1
  BM = batch * M
  if BM < MT1: return _reject(f"BM={BM} < {MT1}")
  if N < MT0: return _reject(f"N={N} < {MT0}")
  return True

def fast_gemm(A: Tensor, B: Tensor) -> Tensor:
  """Fast batched matmul using AMD's Tensile GEMM kernel (MT128x128x64)."""
  if not can_use_fast_gemm(A, B):
    raise AssertionError(list(_fast_gemm_stats["reasons"].keys())[0])
  _fast_gemm_stats["used"] += 1
  # Handle 2D input (add batch dim)
  squeeze = A.ndim == 2
  if squeeze:
    A = A.unsqueeze(0)

  # Extract dimensions: A=(batch,M,K), B=(K,N), out=(batch,M,N)
  batch, M, K = A.shape
  N = B.shape[1]

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
  ws = Tensor.empty(1024*1024, dtype=dtypes.float32)
  flags = Tensor.empty(1024*1024, dtype=dtypes.half)
  out = Tensor.custom_kernel(out, A, B, ws, flags, params, fxn=custom_gemm)[0]

  return out.squeeze(0) if squeeze else out
