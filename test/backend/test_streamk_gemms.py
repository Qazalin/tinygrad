import unittest
from tinygrad import Tensor, Device, dtypes, Context
from tinygrad.helpers import DEV
from extra.gemm.cdna_asm_gemm import asm_gemm, asm_gemm_a_bt_dt
from test.helpers import needs_second_gpu

def is_cdna4():
  try: return Device[Device.DEFAULT].renderer.target.arch.startswith("gfx950")
  except Exception: return False

def run_streamk_gemm(a_shape, b_shape, fxn, ref_fxn, rtol=1e-2) -> None:
  Tensor.manual_seed(0)
  a = Tensor.randn(a_shape, dtype=dtypes.float).sub(0.5).cast(dtypes.bfloat16)
  b = Tensor.randn(b_shape, dtype=dtypes.float).sub(0.5).cast(dtypes.bfloat16)
  with Context(DEBUG=0): Tensor.realize(a, b)

  y = fxn(a, b)
  y.realize()
  with Context(DEBUG=0):
    ref = ref_fxn(a, b)
    passed = y.allclose(ref, atol=2e-1, rtol=rtol).item()
  assert passed, "forward mismatch"

def run_streamk_gemm_bw(a_shape, b_shape, fxn, ref_fxn, ref_bw_fxn, rtol=1e-2) -> None:
  Tensor.manual_seed(0)
  a0 = Tensor.randn(a_shape, dtype=dtypes.float).sub(0.5).cast(dtypes.bfloat16)
  b0 = Tensor.randn(b_shape, dtype=dtypes.float).sub(0.5).cast(dtypes.bfloat16)
  with Context(DEBUG=0): Tensor.realize(a0, b0)

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
    assert y.allclose(ref, atol=2e-1, rtol=rtol).item(), "forward mismatch"
    assert a.grad.allclose(ref_ga, atol=0.0, rtol=0.0).item(), "grad_a mismatch"
    assert b.grad.allclose(ref_gb, atol=0.0, rtol=0.0).item(), "grad_b mismatch"

def ref_bw_a_bt_dt(a:Tensor, b:Tensor, g:Tensor) -> tuple[Tensor, Tensor]: return asm_gemm(g.T, b), asm_gemm(g, a)

class TestStreamKGEMMs(unittest.TestCase):
  def setUp(self):
    if not is_cdna4() or Device.DEFAULT.startswith(("MOCK", "NULL")) or DEV.interface.startswith("MOCK"):
      self.skipTest("stream-k gemms are only for real cdna4")

  def test_a_bt_dt(self):
    run_streamk_gemm((128256, 4096), (16384, 4096), asm_gemm_a_bt_dt, lambda a, b: (a @ b.T).T)

  @needs_second_gpu
  def test_a_bt_dt_multi_b_axis0(self):
    Tensor.manual_seed(0)
    devs = tuple(f"{Device.DEFAULT}:{i}" for i in range(2))
    a0 = Tensor.randn((128256, 4096), dtype=dtypes.float).sub(0.5).cast(dtypes.bfloat16)
    b0 = Tensor.randn((2 * 16384, 4096), dtype=dtypes.float).sub(0.5).cast(dtypes.bfloat16)
    with Context(DEBUG=0): Tensor.realize(a0, b0)
    a, b = a0.shard(devs, axis=None), b0.shard(devs, axis=0)
    y = asm_gemm_a_bt_dt(a, b)
    ref = asm_gemm(b, a.T)
    Tensor.realize(y, ref)
    assert y.allclose(ref, atol=2e-1, rtol=1e-2).item()

  def test_a_bt_dt_bw(self):
    run_streamk_gemm_bw((128256, 4096), (16384, 4096), asm_gemm_a_bt_dt, lambda a, b: (a @ b.T).T, ref_bw_a_bt_dt)

if __name__ == "__main__":
  unittest.main()
