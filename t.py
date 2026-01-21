import pathlib, ctypes
from tinygrad import Tensor, Device, dtypes
from tinygrad.helpers import getenv, time_to_str, colored

class KernArgs(ctypes.Structure):
  _pack_ = 1
  _fields_ = [
    ("Gemm_info", ctypes.c_uint32), ("kernel_info0", ctypes.c_uint32), ("kernel_info1", ctypes.c_uint32),
    ("numWG", ctypes.c_uint32), ("SizesFree0", ctypes.c_uint32), ("SizesFree1", ctypes.c_uint32),
    ("SizesFree2", ctypes.c_uint32), ("SizesSum0", ctypes.c_uint32),
    ("D", ctypes.c_void_p), ("C", ctypes.c_void_p), ("A", ctypes.c_void_p), ("B", ctypes.c_void_p),
    ("AddressWS", ctypes.c_void_p), ("AddressFlags", ctypes.c_void_p),
    ("strideD0", ctypes.c_uint32), ("strideD1", ctypes.c_uint32), ("strideC0", ctypes.c_uint32), ("strideC1", ctypes.c_uint32),
    ("strideA0", ctypes.c_uint32), ("strideA1", ctypes.c_uint32), ("strideB0", ctypes.c_uint32), ("strideB1", ctypes.c_uint32),
    ("alpha", ctypes.c_float), ("beta", ctypes.c_float),
    ("ItersPerTile", ctypes.c_uint32), ("MagicNumberItersPerTile", ctypes.c_uint32), ("MagicShiftItersPerTile", ctypes.c_uint32),
    ("TotalIters", ctypes.c_uint32), ("SKItersPerWG", ctypes.c_uint32), ("skGrid", ctypes.c_uint32), ("skTiles", ctypes.c_uint32),
    ("AddressScaleAlphaVec", ctypes.c_void_p), ("bias", ctypes.c_void_p), ("biasType", ctypes.c_uint32), ("StrideBias", ctypes.c_uint32),
    ("activationAlpha", ctypes.c_float), ("activationBeta", ctypes.c_float), ("activationType", ctypes.c_uint32),
  ]

# MT128x128x64 kernel constants
MT0, MT1, KT, WORKGROUP_SIZE = 128, 128, 64, 256

# Lazy-initialized globals
_dev, _lib, _prg, _ws_buf, _flags_buf = None, None, None, None, None

def _init():
  global _dev, _lib, _prg, _ws_buf, _flags_buf
  if _dev is None:
    Device.DEFAULT = "HIP"
    _dev = Device[Device.DEFAULT]
    _lib = _dev.compiler.compile((pathlib.Path(__file__).parent / "kernel.s").read_text())
    _prg = _dev.runtime("gemm", _lib)
    _ws_buf = Tensor.empty(1024*1024, dtype=dtypes.float32).uop.buffer.allocate()
    _flags_buf = Tensor.empty(1024*1024, dtype=dtypes.half).uop.buffer.allocate()

def _ceildiv(a, b): return -(-a // b)

def _magic(d): return 0xFFFFFFFF if d <= 1 else min(((1 << 32) + d - 1) // d, 0xFFFFFFFF)

def fast_matmul(A: Tensor, B: Tensor) -> Tensor:
  """
  Fast batched matmul using torch's Tensile GEMM kernel (MT128x128x64).
  A: (batch, M, K) or (M, K)
  B: (K, N)
  Returns: (batch, M, N) or (M, N)

  Constraints:
  - A and B must be float16
  - K must be multiple of 64 (K-tile size)
  - K must be >= 192 (minimum 3 iterations)
  - N should be multiple of 128 for best performance
  """
  _init()

  # Handle 2D input (add batch dim)
  squeeze = A.ndim == 2
  if squeeze:
    A = A.unsqueeze(0)

  # Extract dimensions: A=(batch,M,K), B=(K,N), out=(batch,M,N)
  batch, M, K = A.shape
  K2, N = B.shape

  # Input validation
  assert A.dtype == dtypes.half and B.dtype == dtypes.half, \
    f"inputs must be float16, got A.dtype={A.dtype}, B.dtype={B.dtype}"
  assert K == K2, \
    f"K dimension mismatch: A has K={K}, B has K={K2}"
  assert K % KT == 0, \
    f"K must be multiple of {KT} (K-tile size), got K={K}"
  assert K >= KT * 3, \
    f"K must be >= {KT * 3} (minimum 3 iterations), got K={K}"

  # Realize inputs and allocate output
  Tensor.realize(A, B)
  out = Tensor.empty((batch, M, N), dtype=dtypes.half)

  # Calculate kernel parameters
  BM = batch * M
  tiles_N, tiles_BM = _ceildiv(N, MT0), _ceildiv(BM, MT1)
  numWG = tiles_N * tiles_BM
  iters = K // KT

  # Build kernel args
  args = KernArgs()
  args.Gemm_info, args.kernel_info0 = 1, 0
  args.kernel_info1 = (((tiles_N << 11) + 1) << 16) | 0x0006
  args.numWG, args.SizesFree0, args.SizesFree1, args.SizesFree2, args.SizesSum0 = numWG, N, BM, 1, K

  bufs = [out.uop.buffer.allocate()._buf, A.uop.buffer.ensure_allocated()._buf, B.uop.buffer.ensure_allocated()._buf]
  args.D = args.C = bufs[0].value
  args.A, args.B = bufs[2].value, bufs[1].value
  args.AddressWS, args.AddressFlags = _ws_buf._buf, _flags_buf._buf

  args.strideD0 = args.strideC0 = args.strideA0 = N
  args.strideD1 = args.strideC1 = args.strideA1 = 0
  args.strideB0, args.strideB1 = K, 0
  args.alpha, args.beta = 1.0, 0.0

  args.ItersPerTile = args.SKItersPerWG = iters
  args.MagicNumberItersPerTile, args.MagicShiftItersPerTile = _magic(iters), 0
  args.TotalIters = numWG * iters
  args.skGrid = args.skTiles = numWG

  # Pack args and run
  arg_size = ctypes.c_size_t(ctypes.sizeof(args))
  blob = (ctypes.c_ubyte * ctypes.sizeof(args)).from_buffer_copy(
    ctypes.string_at(ctypes.addressof(args), ctypes.sizeof(args)))
  extra = (ctypes.c_void_p * 5)(1, ctypes.cast(ctypes.byref(blob), ctypes.c_void_p), 2,
                                 ctypes.cast(ctypes.pointer(arg_size), ctypes.c_void_p), 3)

  _prg.vargs = extra
  et = _prg(global_size=[numWG * WORKGROUP_SIZE, 1, 1], local_size=[WORKGROUP_SIZE, 1, 1], wait=True)
  flops = 2 * BM * N * K / et
  print(f"tm {colored(time_to_str(et, w=9), 'yellow' if et > 0.01 else None)} ({colored(f'{flops*1e-12:7.2f} TFLOPS', 'green')})")

  return out.squeeze(0) if squeeze else out

if __name__ == "__main__":
  import numpy as np

  M = getenv("M", 612)
  N = getenv("N", 1024)
  K = getenv("K", 1024)
  B = getenv("B", 6)

  rng = np.random.default_rng(0)
  A = Tensor(rng.random((B, M, K), dtype=np.float32) - 0.5, dtype=dtypes.half)
  B_mat = Tensor(rng.random((K, N), dtype=np.float32) - 0.5, dtype=dtypes.half)

  out = fast_matmul(A, B_mat)
  expected = A @ B_mat

  print(f"M={M} N={N} K={K} B={B}")
  np.testing.assert_allclose(out.numpy(), expected.numpy(), rtol=1e-2, atol=1e-2)
  print("PASS")
  #print(f"out: {out.flatten().numpy()[:8]}")
  #print(f"exp: {expected.flatten().numpy()[:8]}")
