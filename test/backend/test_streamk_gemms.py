import unittest
from tinygrad import Tensor, Device, dtypes, Context
from tinygrad.helpers import DEV
from extra.gemm.cdna_asm_gemm import asm_gemm_a_bt_dt, asm_gemm_at_bt_dt, asm_gemm_at_b_dt

def is_cdna4():
  try: return Device[Device.DEFAULT].renderer.target.arch.startswith("gfx950")
  except Exception: return False

def run_streamk_gemm(a_shape, b_shape, fxn, ref_fxn, rtol=1e-2) -> None:
  Tensor.manual_seed(0)
  a = Tensor.randn(a_shape, dtype=dtypes.float).sub(0.5).cast(dtypes.bfloat16)
  b = Tensor.randn(b_shape, dtype=dtypes.float).sub(0.5).cast(dtypes.bfloat16)
  with Context(DEBUG=0):
    Tensor.realize(a, b)

  y = fxn(a, b)
  y.realize()
  with Context(DEBUG=0):
    ref = ref_fxn(a, b)
    passed = y.allclose(ref, atol=2e-1, rtol=rtol).item()
  if not passed:
    print(y.numpy())
    print(ref.numpy())
  assert passed

def matmul_chunks(a:Tensor, b:Tensor, chunk=8192) -> Tensor:
  ret = a[:, :chunk] @ b[:chunk, :]
  for st in range(chunk, a.shape[1], chunk):
    ret = (ret + a[:, st:st+chunk] @ b[st:st+chunk, :]).realize()
  return ret

def run_streamk_gemm_bw(a_shape, b_shape, fxn, ref_fxn, ref_bw_fxn, rtol=1e-2, grad_atol=1.0) -> None:
  Tensor.manual_seed(0)
  a0 = Tensor.randn(a_shape, dtype=dtypes.float).sub(0.5).cast(dtypes.bfloat16)
  b0 = Tensor.randn(b_shape, dtype=dtypes.float).sub(0.5).cast(dtypes.bfloat16)
  with Context(DEBUG=0):
    Tensor.realize(a0, b0)

  a, b = a0.clone(), b0.clone()
  y = fxn(a, b)
  grad = Tensor.randn(y.shape, dtype=dtypes.float).cast(dtypes.bfloat16)
  with Context(DEBUG=0): grad.realize()
  y.backward(grad)
  Tensor.realize(y, a.grad, b.grad)

  with Context(DEBUG=0):
    ref = ref_fxn(a0, b0)
    ref_ga, ref_gb = ref_bw_fxn(a0, b0, grad)
    Tensor.realize(ref, ref_ga, ref_gb)
    forward_ok = y.allclose(ref, atol=2e-1, rtol=rtol).item()
    grad_a_ok = a.grad.allclose(ref_ga, atol=grad_atol, rtol=5e-2).item()
    grad_b_ok = b.grad.allclose(ref_gb, atol=grad_atol, rtol=5e-2).item()
  assert forward_ok, "forward mismatch"
  assert grad_a_ok, "grad_a mismatch"
  assert grad_b_ok, "grad_b mismatch"

def ref_at_bt_dt(a:Tensor, b:Tensor) -> Tensor:
  # Chunk the reference over K to avoid one very large tinygrad matmul hitting the HCQ wait timeout.
  ret = b[:, :8192] @ a[:8192, :]
  for st in range(8192, a.shape[0], 8192):
    ret = (ret + b[:, st:st+8192] @ a[st:st+8192, :]).realize()
  return ret

def ref_at_b_dt(a:Tensor, b:Tensor) -> Tensor:
  # Chunk the reference over K to avoid one very large tinygrad matmul hitting the HCQ wait timeout.
  ret = b[:8192, :].T @ a[:8192, :]
  for st in range(8192, a.shape[0], 8192):
    ret = (ret + b[st:st+8192, :].T @ a[st:st+8192, :]).realize()
  return ret

def ref_bw_a_bt_dt(a:Tensor, b:Tensor, g:Tensor) -> tuple[Tensor, Tensor]:
  return matmul_chunks(g.T, b), matmul_chunks(g, a)

def ref_bw_at_bt_dt(a:Tensor, b:Tensor, g:Tensor) -> tuple[Tensor, Tensor]:
  return matmul_chunks(b.T, g), g @ a.T

def ref_bw_at_b_dt(a:Tensor, b:Tensor, g:Tensor) -> tuple[Tensor, Tensor]:
  return matmul_chunks(b, g), a @ g.T

class TestStreamKGEMMs(unittest.TestCase):
  def setUp(self):
    if not is_cdna4() or Device.DEFAULT.startswith(("MOCK", "NULL")) or DEV.interface.startswith("MOCK"):
      self.skipTest("stream-k gemms are only for real cdna4")

  def test_a_bt_dt(self):
    run_streamk_gemm((128256, 4096), (16384, 4096), asm_gemm_a_bt_dt, lambda a, b: (a @ b.T).T)

  def test_a_bt_dt_bw(self):
    run_streamk_gemm_bw((128256, 4096), (16384, 4096), asm_gemm_a_bt_dt, lambda a, b: (a @ b.T).T, ref_bw_a_bt_dt, grad_atol=32.0)

  def test_at_bt_dt(self):
    run_streamk_gemm((128256, 4096), (16384, 128256), asm_gemm_at_bt_dt, ref_at_bt_dt, rtol=5e-2)

  def test_at_bt_dt_bw(self):
    run_streamk_gemm_bw((128256, 4096), (16384, 128256), asm_gemm_at_bt_dt, ref_at_bt_dt, ref_bw_at_bt_dt, rtol=5e-2, grad_atol=4.0)

  def test_at_b_dt(self):
    run_streamk_gemm((16384, 4096), (16384, 128256), asm_gemm_at_b_dt, ref_at_b_dt)

  def test_at_b_dt_bw(self):
    run_streamk_gemm_bw((16384, 4096), (16384, 128256), asm_gemm_at_b_dt, ref_at_b_dt, ref_bw_at_b_dt, grad_atol=32.0)

if __name__ == "__main__":
  unittest.main()
