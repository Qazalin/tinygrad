import unittest
import numpy as np
from tinygrad import Tensor, Device, dtypes, Context
from tinygrad.device import is_dtype_supported

def is_cdna4(): return getattr(Device[Device.DEFAULT].renderer, "arch", "").startswith("gfx950")

def run_hk_fp8_gemm(M:int, N:int, K:int):
  """Test HK FP8 GEMM: C(M,N) = A(M,K) @ B(K,N), compare against float reference."""
  from extra.thunder.amd.gemm import hk_fp8_gemm
  Tensor.manual_seed(42)

  # create fp8 inputs via float -> cast (values clamped to fp8 range)
  a_float = Tensor.randn(M, K, dtype=dtypes.float).contiguous()
  b_float = Tensor.randn(K, N, dtype=dtypes.float).contiguous()
  with Context(DEBUG=0): Tensor.realize(a_float, b_float)

  a_fp8 = a_float.cast(dtypes.fp8e4m3).contiguous()
  b_fp8 = b_float.cast(dtypes.fp8e4m3).contiguous()
  with Context(DEBUG=0): Tensor.realize(a_fp8, b_fp8)

  # HK GEMM
  result = hk_fp8_gemm(a_fp8, b_fp8)
  assert result is not None, f"hk_fp8_gemm returned None for shape ({M},{N},{K})"

  # reference: cast fp8 back to float, matmul in float, then compare
  ref = a_fp8.float() @ b_fp8.float()

  result_np = result.float().numpy()
  ref_np = ref.numpy()

  # bf16 accumulation loses precision for large K; scale tolerance accordingly
  atol = max(2.0, K * 0.1)
  np.testing.assert_allclose(result_np, ref_np, atol=atol, rtol=0.1,
    err_msg=f"HK FP8 GEMM mismatch for ({M},{N},{K})")

@unittest.skipUnless(is_dtype_supported(dtypes.fp8e4m3), "fp8 not supported")
@unittest.skipUnless(is_cdna4(), "HK FP8 GEMM requires CDNA4 (gfx950)")
class TestHKFP8Gemm(unittest.TestCase):
  def test_square_1024(self): run_hk_fp8_gemm(1024, 1024, 1024)
  def test_square_2048(self): run_hk_fp8_gemm(2048, 2048, 2048)
  def test_square_4096(self): run_hk_fp8_gemm(4096, 4096, 4096)
  def test_square_8192(self): run_hk_fp8_gemm(8192, 8192, 8192)
  def test_rect_4096_4096_8192(self): run_hk_fp8_gemm(4096, 4096, 8192)
  def test_rect_8192_4096_4096(self): run_hk_fp8_gemm(8192, 4096, 4096)

if __name__ == "__main__":
  unittest.main()
