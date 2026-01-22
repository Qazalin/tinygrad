import pathlib, struct, atexit
from tinygrad import Tensor, Device, dtypes
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.engine.realize import Estimates

# MT128x128x64 kernel constants
MT0, MT1, KT, WORKGROUP_SIZE = 128, 128, 64, 256

# Global counters for fast_gemm usage
_fast_gemm_stats = {"checked": 0, "used": 0, "reasons": {}}
def _print_fast_gemm_stats():
  if _fast_gemm_stats["checked"] > 0:
    print(f"fast_gemm: {_fast_gemm_stats['used']}/{_fast_gemm_stats['checked']} used")
    if _fast_gemm_stats["reasons"]:
      print("fast_gemm skip reason:")
      for reason, lst in _fast_gemm_stats["reasons"].items(): print(f"{reason} - {len(lst)} times")
atexit.register(_print_fast_gemm_stats)

def _reject(reason: str) -> bool:
  reason_key = reason.split(":")[0]
  _fast_gemm_stats["reasons"].setdefault(reason_key, []).append(reason)
  return False

def can_use_fast_gemm(A: Tensor, B: Tensor, track_stats=True) -> bool:
  if track_stats: _fast_gemm_stats["checked"] += 1
  if not Device.DEFAULT.startswith(("AMD", "HIP", "NULL")): return _reject("DEVICE: not AMD/HIP")
  if A.dtype != dtypes.half or B.dtype != dtypes.half: return _reject(f"dtype must be half: dtype {A.dtype} {B.dtype} not half")
  if A.ndim < 2 or B.ndim != 2: return _reject(f"ndim 2: {A.ndim} < 2 or {B.ndim} != 2")
  K, K2 = A.shape[-1], B.shape[0]
  if K != K2: return _reject(f"wrong K?: {K} != {K2}")
  if K % KT != 0 or K < KT * 3: return _reject(f"K must be divisible by {KT}: {K}")
  return True

def _ceildiv(a, b): return -(-a // b)
def _magic(d): return 0xFFFFFFFF if d <= 1 else min(((1 << 32) + d - 1) // d, 0xFFFFFFFF)
def _f32(f): return struct.unpack('I', struct.pack('f', f))[0]
def _u32(u): return u & 0xFFFFFFFF

def fast_gemm(A: Tensor, B: Tensor) -> Tensor:
  assert can_use_fast_gemm(A, B, track_stats=False)
  _fast_gemm_stats["used"] += 1
  # Handle 2D input (add batch dim)
  squeeze = A.ndim == 2
  if squeeze:
    A = A.unsqueeze(0)

  # Check for multi-device
  is_multi = isinstance(A.device, tuple)
  devs = A.device if is_multi else None
  axis = A.uop.axis if is_multi else None

  # Extract dimensions: A=(batch,M,K), B=(K,N), out=(batch,M,N)
  batch, M, K = A.shape
  N = B.shape[1]

  # For multi, compute per-shard dimensions
  if is_multi:
    num_devs = len(devs)
    shard_batch = batch // num_devs if axis == 0 else batch
    shard_M = M // num_devs if axis == 1 else M
    shard_BM = shard_batch * shard_M
  else:
    shard_batch, shard_M, shard_BM = batch, M, batch * M

  # Calculate kernel parameters (use per-shard dimensions for multi)
  BM = shard_BM
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

  def custom_gemm(out_uop: UOp, A_uop: UOp, B_uop: UOp, ws_uop: UOp, flags_uop: UOp, params_uop: UOp) -> UOp:
    lidx = UOp.special(WORKGROUP_SIZE, "lidx0")
    gidx = UOp.special(numWG, "gidx0")
    src = (pathlib.Path(__file__).parent / "kernel.s").read_text()
    # Sink: out, A, B, ws, flags, params (6 buffers)
    # outs/ins for dependency tracking: out(0), ws(3), flags(4) are written; A(1), B(2), ws(3), flags(4), params(5) are read
    sink = UOp.sink(out_uop.base, A_uop.base, B_uop.base, ws_uop.base, flags_uop.base, params_uop.base,
                    lidx, gidx, arg=KernelInfo(name="gemm", estimates=Estimates(ops=2*BM*N*K, mem=(BM*K + K*N + BM*N)*2),
                                               outs=(0, 3, 4), ins=(1, 2, 3, 4, 5)))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=src)))

  def custom_backward_gemm(gradient:UOp, kernel:UOp):
    out, a, b, ws, flags, params = kernel.src
    grad_tensor, a_tensor, b_tensor = Tensor(gradient), Tensor(a), Tensor(b)
    grad_a = (grad_tensor @ b_tensor.T).uop
    grad_b = (a_tensor.transpose(-2, -1) @ grad_tensor).sum(tuple(range(a_tensor.ndim - 2))).uop
    return (None, grad_a, grad_b, None, None, None)

  if is_multi:
    out = Tensor(Tensor.empty((shard_batch, shard_M, N), device=devs, dtype=dtypes.half).uop.multi(axis), device=devs)
    ws = Tensor.empty(1024*1024, dtype=dtypes.float32).to(devs)
    # flags must be zeroed - kernel uses them for stream-k synchronization (wait for flag==1, reset to 0)
    flags = Tensor.zeros(1024*1024, dtype=dtypes.int32).to(devs)
    params = params.to(devs)
  else:
    out = Tensor.empty((batch, M, N), dtype=dtypes.half)
    ws = Tensor.empty(1024*1024, dtype=dtypes.float32)
    # flags must be zeroed - kernel uses them for stream-k synchronization (wait for flag==1, reset to 0)
    flags = Tensor.zeros(1024*1024, dtype=dtypes.int32)
  out = Tensor.custom_kernel(out, A, B, ws, flags, params, fxn=custom_gemm, grad_fxn=custom_backward_gemm)[0]

  return out.squeeze(0) if squeeze else out

if __name__ == "__main__":
  from tinygrad.helpers import getenv
  import numpy as np

  M, N, K, batch = getenv("M", 612), getenv("N", 1024), getenv("K", 1024), getenv("B", 6)

  rng = np.random.default_rng(0)
  A = Tensor(rng.random((batch, M, K), dtype=np.float32) - 0.5, dtype=dtypes.half)
  B = Tensor(rng.random((K, N), dtype=np.float32) - 0.5, dtype=dtypes.half)
  Tensor.realize(A, B)

  C_asm = fast_gemm(A, B)
  C_tiny = A @ B

  Tensor.realize(C_asm, C_tiny)
  print(f"M={M} N={N} K={K} batch={batch}")
  np.testing.assert_allclose(C_asm.numpy(), C_tiny.numpy(), rtol=1e-2, atol=1e-2)
  print("PASS")
