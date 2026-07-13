import functools, unittest

import numpy as np

from tinygrad import Device, Tensor, dtypes
from extra.gemm.cdna_asm_gemm import custom_hk_fp8_atb_gemm, custom_hk_fp8_gemm


class TestCDNAAsmGemm(unittest.TestCase):
  def setUp(self):
    if Device[Device.DEFAULT].renderer.target.arch != "gfx950": self.skipTest("CDNA4 only")

  def test_fp8_gemm_wide_output(self):
    # N > M selects the grouped XCD work mapping used by Llama's 16384x28672x4096 GEMM.
    M, N, K = 256, 512, 512
    Tensor.manual_seed(7)
    a = (Tensor.randn(1, M, K) * 0.25).cast(dtypes.fp8e4m3).contiguous().realize()
    b = (Tensor.randn(N, K) * 0.25).cast(dtypes.fp8e4m3).contiguous().realize()
    out = Tensor.empty(1, M, N, dtype=dtypes.bfloat16)
    out = Tensor.custom_kernel(out, a, b, fxn=functools.partial(custom_hk_fp8_gemm, dname=Device.DEFAULT,
                                                               scale_mode=0, layer_scale=False))[0].realize()
    ref = (a.float() @ b.float().T).cast(dtypes.bfloat16).realize()
    np.testing.assert_allclose(out.numpy(), ref.numpy(), atol=0.125, rtol=0.02)

  def test_fp8_atb_gemm(self):
    M, N, K = 512, 256, 512
    Tensor.manual_seed(8)
    a = (Tensor.randn(1, K, M) * 0.25).cast(dtypes.fp8e4m3).contiguous().realize()
    b = (Tensor.randn(1, K, N) * 0.25).cast(dtypes.fp8e4m3).contiguous().realize()
    out = Tensor.empty(1, M, N, dtype=dtypes.bfloat16)
    out = Tensor.custom_kernel(out, a, b, fxn=functools.partial(custom_hk_fp8_atb_gemm, dname=Device.DEFAULT,
                                                               scale_mode=0, layer_scale=False))[0].realize()
    ref = (a.squeeze(0).float().T @ b.squeeze(0).float()).cast(dtypes.bfloat16).realize()
    np.testing.assert_allclose(out.squeeze(0).numpy(), ref.numpy(), atol=0.125, rtol=0.02)


if __name__ == "__main__": unittest.main()
