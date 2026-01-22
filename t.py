import pathlib, struct
from tinygrad import Tensor, Device, dtypes
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.engine.realize import Estimates
from tinygrad.helpers import getenv, time_to_str, colored

# MT128x128x64 kernel constants
MT0, MT1, KT, WORKGROUP_SIZE = 128, 128, 64, 256

# Lazy-initialized workspace tensors
ws, flags = None, None

def _init_buffers():
  global ws, flags
  if ws is None:
    ws = Tensor.empty(1024*1024, dtype=dtypes.float32).realize()
    flags = Tensor.empty(1024*1024, dtype=dtypes.half).realize()

def _ceildiv(a, b): return -(-a // b)
def _magic(d): return 0xFFFFFFFF if d <= 1 else min(((1 << 32) + d - 1) // d, 0xFFFFFFFF)
def _f32(f): return struct.unpack('i', struct.pack('f', f))[0]
def _u32(u): return struct.unpack('i', struct.pack('I', u & 0xFFFFFFFF))[0]

def fast_matmul(A: Tensor, B: Tensor) -> Tensor:
  _init_buffers()

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

  # Build var_vals dict (variable name -> value), prefixed to control sort order
  var_vals = {
    "A_gemm_info": 1, "B_kernel_info0": 0, "C_kernel_info1": _u32((((tiles_N << 11) + 1) << 16) | 0x0006),
    "D_numWG": numWG, "E_sizesFree0": N, "F_sizesFree1": BM, "G_sizesFree2": 1, "H_sizesSum0": K,
    "I_strideD0": N, "J_strideD1": 0, "K_strideC0": N, "L_strideC1": 0,
    "M_strideA0": N, "N_strideA1": 0, "O_strideB0": K, "P_strideB1": 0,
    "Q_alpha": _f32(1.0), "R_beta": _f32(0.0),
    "S_itersPerTile": iters, "T_magicIters": _u32(_magic(iters)), "U_magicShift": 0,
    "V_totalIters": numWG * iters, "W_skItersPerWG": iters, "X_skGrid": numWG, "Y_skTiles": numWG,
  }

  def custom_gemm(out_uop: UOp, A_uop: UOp, B_uop: UOp, ws_uop: UOp, flags_uop: UOp) -> UOp:
    lidx = UOp.special(WORKGROUP_SIZE, "lidx0")
    gidx = UOp.special(numWG, "gidx0")
    src = (pathlib.Path(__file__).parent / "kernel.s").read_text()

    # Create variables for scalar kernel args (prefixed to control sort order)
    all_vars = tuple(UOp.variable(name, 0, 0xFFFFFFFF) for name in sorted(var_vals.keys()))

    # Sink: out, A, B, ws, flags, then all scalar vars (matches kernel arg order)
    sink = UOp.sink(out_uop.base, A_uop.base, B_uop.base, ws_uop.base, flags_uop.base,
                    *all_vars, lidx, gidx, arg=KernelInfo(name="gemm", estimates=Estimates(ops=2*BM*N*K, mem=(BM*K + K*N + BM*N)*2)))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=src)))

  # Create output and run custom kernel
  out = Tensor.empty((batch, M, N), dtype=dtypes.half)
  A, B = A.contiguous().realize(), B.contiguous().realize()
  out = Tensor.custom_kernel(out, A, B, ws, flags, fxn=custom_gemm)[0]

  # Schedule and run
  sched = out.schedule()
  ei = sched[-1].lower()
  et = ei.run(var_vals, wait=True)

  if et is not None:
    flops = 2 * BM * N * K / et
    print(f"tm {colored(time_to_str(et, w=9), 'yellow' if et > 0.01 else None)} ({colored(f'{flops*1e-12:7.2f} TFLOPS', 'green')})")

  return out.squeeze(0) if squeeze else out

if __name__ == "__main__":
  import numpy as np

  M, N, K, B = getenv("M", 612), getenv("N", 1024), getenv("K", 1024), getenv("B", 6)

  rng = np.random.default_rng(0)
  A = Tensor(rng.random((B, M, K), dtype=np.float32) - 0.5, dtype=dtypes.half)
  B_mat = Tensor(rng.random((K, N), dtype=np.float32) - 0.5, dtype=dtypes.half)
  Tensor.realize(A, B_mat)

  out = fast_matmul(A, B_mat)
  expected = A @ B_mat

  print(f"M={M} N={N} K={K} B={B}")
  np.testing.assert_allclose(out.numpy(), expected.numpy(), rtol=1e-2, atol=1e-2)
  print("PASS")
