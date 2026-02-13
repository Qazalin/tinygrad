import unittest
import numpy as np
from tinygrad import Tensor, Device, dtypes, Context
from extra.gemm.asm.cdna.atn import asm_atn, can_use_asm_atn
from test.helpers import needs_second_gpu

def is_cdna4(): return getattr(Device[Device.DEFAULT].renderer, "arch", "").startswith("gfx950")

class TestAsmAtn(unittest.TestCase):
  def setUp(self):
    if not is_cdna4():
      self.skipTest("ASM ATN only works on CDNA4 (MI350X)")

  def test_sdpa_forward(self):
    B, H, S, D = 8, 8, 8192, 128
    Tensor.manual_seed(0)
    q = Tensor.randn(B, H, S, D, dtype=dtypes.bfloat16)
    k = Tensor.randn(B, H, S, D, dtype=dtypes.bfloat16)
    v = Tensor.randn(B, H, S, D, dtype=dtypes.bfloat16)
    with Context(DEBUG=0): Tensor.realize(q, k, v)

    out_ref = Tensor.scaled_dot_product_attention(q, k, v, is_causal=True)
    out_asm = asm_atn(q, k, v)
    Tensor.realize(out_ref, out_asm)

  def test_sdpa_backward(self):
    B, H, S, D = 8, 8, 8192, 128
    Tensor.manual_seed(0)
    q = Tensor.randn(B, H, S, D, dtype=dtypes.bfloat16, requires_grad=True)
    k = Tensor.randn(B, H, S, D, dtype=dtypes.bfloat16, requires_grad=True)
    v = Tensor.randn(B, H, S, D, dtype=dtypes.bfloat16, requires_grad=True)
    with Context(DEBUG=0): Tensor.realize(q, k, v)

    dout = Tensor.empty(B, H, S, D, dtype=dtypes.bfloat16)
    with Context(DEBUG=0): Tensor.realize(dout)

    q_ref, k_ref, v_ref = [t.clone().requires_grad_() for t in [q, k, v]]
    out_ref = Tensor.scaled_dot_product_attention(q_ref, k_ref, v_ref, is_causal=True)
    dq_ref, dk_ref, dv_ref = Tensor.gradient(out_ref, q_ref, k_ref, v_ref, gradient=dout.clone())

    q_asm, k_asm, v_asm = [t.clone().requires_grad_() for t in [q, k, v]]
    out_asm = asm_atn(q_asm, k_asm, v_asm)
    dq_asm, dk_asm, dv_asm = Tensor.gradient(out_asm, q_asm, k_asm, v_asm, gradient=dout.clone())

    Tensor.realize(out_asm, out_ref, dq_asm, dk_asm, dv_asm, dq_ref, dk_ref, dv_ref)

    atol, rtol = 2e-2, 2e-2
    np.testing.assert_allclose(out_asm.numpy(), out_ref.numpy(), atol=atol, rtol=rtol)
    np.testing.assert_allclose(dq_asm.numpy(), dq_ref.numpy(), atol=atol, rtol=rtol)
    np.testing.assert_allclose(dk_asm.numpy(), dk_ref.numpy(), atol=atol, rtol=rtol)
    np.testing.assert_allclose(dv_asm.numpy(), dv_ref.numpy(), atol=atol, rtol=rtol)

if __name__ == "__main__":
  unittest.main()
