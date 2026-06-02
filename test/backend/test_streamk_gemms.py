import unittest
from tinygrad import Tensor, Device, dtypes, Context
from tinygrad.helpers import DEV
from extra.gemm.cdna_asm_gemm import asm_gemm_a_bt_dt, asm_gemm_at_bt_dt, asm_gemm_at_b_dt

def is_cdna4(): return Device[Device.DEFAULT].renderer.target.arch.startswith("gfx950")

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

class TestStreamKGEMMs(unittest.TestCase):
  def setUp(self):
    if not is_cdna4() or DEV.interface.startswith("MOCK"):
      self.skipTest("stream-k gemms are only for real cdna4")

  def test_a_bt_dt(self):
    run_streamk_gemm((128256, 4096), (16384, 4096), asm_gemm_a_bt_dt, lambda a, b: (a @ b.T).T)

  def test_at_bt_dt(self):
    run_streamk_gemm((128256, 4096), (16384, 128256), asm_gemm_at_bt_dt, ref_at_bt_dt, rtol=5e-2)

  def test_at_b_dt(self):
    run_streamk_gemm((16384, 4096), (16384, 128256), asm_gemm_at_b_dt, ref_at_b_dt)

if __name__ == "__main__":
  unittest.main()
