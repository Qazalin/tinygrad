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

  def test_forward(self):
    B, H, S, D = 8, 8, 8192, 128
    Tensor.manual_seed(0)
    q = Tensor.randn(B, H, S, D, dtype=dtypes.bfloat16)
    k = Tensor.randn(B, H, S, D, dtype=dtypes.bfloat16)
    v = Tensor.randn(B, H, S, D, dtype=dtypes.bfloat16)
    with Context(DEBUG=0): Tensor.realize(q, k, v)

    out_ref = Tensor.scaled_dot_product_attention(q, k, v, is_causal=True)
    out_asm = asm_atn(q, k, v)
    Tensor.realize(out_ref, out_asm)

  def test_backward(self):
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

  @needs_second_gpu
  def test_forward_multi(self):
    B, S, D = 8, 8192, 128
    H_q, H_kv = 32, 8
    GPUS = tuple(f"{Device.DEFAULT}:{i}" for i in range(B))

    Tensor.manual_seed(0)
    with Context(DEBUG=0):
      base_q = Tensor.randn(B, H_q, S, D, dtype=dtypes.bfloat16).contiguous()
      base_k = Tensor.randn(B, H_kv, S, D, dtype=dtypes.bfloat16).contiguous()
      base_v = Tensor.randn(B, H_kv, S, D, dtype=dtypes.bfloat16).contiguous()
      Tensor.realize(base_q, base_k, base_v)

    q = base_q.shard(GPUS, axis=0)
    k = base_k.shard(GPUS, axis=0)
    v = base_v.shard(GPUS, axis=0)

    out_asm = asm_atn(q, k, v)
    out_ref = Tensor.scaled_dot_product_attention(base_q, base_k, base_v, is_causal=True)
    Tensor.realize(out_asm, out_ref)

    atol, rtol = 2e-2, 2e-2
    np.testing.assert_allclose(out_asm.numpy(), out_ref.numpy(), atol=atol, rtol=rtol)

  @needs_second_gpu
  def test_backward_multi(self):
    """Test exact shapes from LLaMA 8B trainer - backward with reference."""
    B, S, D = 8, 8192, 128
    H_q, H_kv = 32, 8
    GPUS = tuple(f"{Device.DEFAULT}:{i}" for i in range(B))

    Tensor.manual_seed(0)
    with Context(DEBUG=0):
      base_q = Tensor.randn(B, H_q, S, D, dtype=dtypes.bfloat16).contiguous()
      base_k = Tensor.randn(B, H_kv, S, D, dtype=dtypes.bfloat16).contiguous()
      base_v = Tensor.randn(B, H_kv, S, D, dtype=dtypes.bfloat16).contiguous()
      base_dout = Tensor.ones(B, H_q, S, D, dtype=dtypes.bfloat16).contiguous()
      Tensor.realize(base_q, base_k, base_v, base_dout)

    q = base_q.clone().requires_grad_(True).shard(GPUS, axis=0)
    k = base_k.clone().requires_grad_(True).shard(GPUS, axis=0)
    v = base_v.clone().requires_grad_(True).shard(GPUS, axis=0)
    dout = base_dout.shard(GPUS, axis=0)

    out_asm = asm_atn(q, k, v)
    dq_asm, dk_asm, dv_asm = Tensor.gradient(out_asm, q, k, v, gradient=dout)

    q_ref = base_q.clone().requires_grad_(True)
    k_ref = base_k.clone().requires_grad_(True)
    v_ref = base_v.clone().requires_grad_(True)
    out_ref = Tensor.scaled_dot_product_attention(q_ref, k_ref, v_ref, is_causal=True)
    dq_ref, dk_ref, dv_ref = Tensor.gradient(out_ref, q_ref, k_ref, v_ref, gradient=base_dout)

    Tensor.realize(out_asm, out_ref, dq_asm, dk_asm, dv_asm, dq_ref, dk_ref, dv_ref)

    atol, rtol = 2e-2, 2e-2
    np.testing.assert_allclose(out_asm.numpy(), out_ref.numpy(), atol=atol, rtol=rtol)
    np.testing.assert_allclose(dq_asm.numpy(), dq_ref.numpy(), atol=atol, rtol=rtol)
    np.testing.assert_allclose(dk_asm.numpy(), dk_ref.numpy(), atol=atol, rtol=rtol)
    np.testing.assert_allclose(dv_asm.numpy(), dv_ref.numpy(), atol=atol, rtol=rtol)

if __name__ == "__main__":
  unittest.main()
