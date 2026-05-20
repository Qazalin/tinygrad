import unittest
from tinygrad import Tensor, dtypes, Context, Device
from tinygrad.device import is_dtype_supported
from extra.llama_kernels.fused_ce import fused_ce_loss
from extra.llama_kernels.fused_rmsnorm_mul_quantize_fp8 import fused_rmsnorm_mul_quantize_fp8, fused_add_rmsnorm_mul_quantize_fp8
from extra.llama_kernels import FP8_MAX

def run_fused_ce(bs:int, seqlen:int, vocab:int, label_smoothing:float=0.0) -> None:
  Tensor.manual_seed(0)
  logits_rand = Tensor.randn(bs, seqlen, vocab).cast(dtypes.bfloat16)
  targets = Tensor.randint(bs, seqlen, high=vocab, dtype=dtypes.int32)
  logits, logits_ref = logits_rand.clone(), logits_rand.detach().float().contiguous()
  with Context(DEBUG=0):
    Tensor.realize(logits, logits_ref, targets)

  loss = fused_ce_loss(logits, targets, label_smoothing=label_smoothing)
  loss.backward()
  Tensor.realize(loss, logits.grad)

  ref = logits_ref.sparse_categorical_crossentropy(targets, label_smoothing=label_smoothing)
  ref.backward()
  Tensor.realize(ref, logits_ref.grad)

  assert logits.grad.shape == (bs, seqlen, vocab)
  with Context(DEBUG=0):
    assert loss.allclose(ref, atol=2e-3, rtol=2e-3).item(), "forward mismatch"
    assert logits.grad.allclose(logits_ref.grad, atol=2e-3, rtol=2e-3).item(), "grad mismatch"

@unittest.skipUnless(is_dtype_supported(dtypes.bfloat16), "need bfloat16")
class TestFusedCE(unittest.TestCase):
  def test_fused_ce_1_2_16(self): run_fused_ce(1, 2, 16, label_smoothing=0.2)
  def test_fused_ce_2_16_128(self): run_fused_ce(2, 16, 128)
  def test_fused_ce_4_128_1024(self): run_fused_ce(4, 128, 1024, label_smoothing=0.2)

  # note: this is the shape used in llama 8b
  #def test_fused_ce_smoothing_16_1024_128256(self): run_fused_ce(16, 1024, 128256, label_smoothing=0.2)

def run_fused_rmsnorm_mul_quantize_fp8(bs:int, seqlen:int, hidden:int, with_residual:bool=False) -> None:
  Tensor.manual_seed(0)
  eps = 1e-5
  x_rand = (Tensor.randn(bs, seqlen, hidden) * 0.2).cast(dtypes.bfloat16)
  weight_rand = (Tensor.randn(hidden) * 0.1 + 0.7).cast(dtypes.bfloat16)
  amax_state = Tensor([64.0], dtype=dtypes.float32, requires_grad=False)
  x, x_ref = x_rand.clone().requires_grad_(), x_rand.detach().clone().requires_grad_()
  weight, weight_ref = weight_rand.clone().requires_grad_(), weight_rand.detach().clone().requires_grad_()
  if with_residual:
    residual_rand = (Tensor.randn(bs, seqlen, hidden) * 0.2).cast(dtypes.bfloat16)
    residual, residual_ref = residual_rand.clone().requires_grad_(), residual_rand.detach().clone().requires_grad_()
  with Context(DEBUG=0):
    Tensor.realize(x, weight, amax_state, *([residual] if with_residual else []))
    Tensor.realize(x_ref, weight_ref, *([residual_ref] if with_residual else []))

  if with_residual:
    fp8, inv_scale, new_amax, h, x_normed, rrms = fused_add_rmsnorm_mul_quantize_fp8(x, residual, weight, amax_state, eps, dtypes.fp8e4m3)
  else:
    fp8, inv_scale, new_amax, x_normed, rrms = fused_rmsnorm_mul_quantize_fp8(x, weight, amax_state, eps, dtypes.fp8e4m3)
  Tensor.realize(fp8, inv_scale, new_amax, x_normed, rrms, *([h] if with_residual else []))
  loss = fp8.float().sum()
  if with_residual: loss = loss + h.float().sum()
  loss.backward()
  Tensor.realize(loss, x.grad, weight.grad, *([residual.grad] if with_residual else []))

  h_ref = x_ref + residual_ref if with_residual else x_ref
  h_ref_float = h_ref.float()
  rrms_ref = ((h_ref_float * h_ref_float).mean(axis=-1) + eps).rsqrt()
  x_normed_ref = (h_ref_float * rrms_ref.reshape(bs, seqlen, 1)).cast(dtypes.bfloat16)
  y_ref = x_normed_ref.float() * weight_ref.float()
  fp8_ref = (y_ref * (FP8_MAX / (amax_state.float() + 1e-8))).clip(-FP8_MAX, FP8_MAX).cast(dtypes.fp8e4m3)
  inv_scale_ref = (amax_state.float() + 1e-8) / FP8_MAX
  new_amax_ref = y_ref.abs().max()
  Tensor.realize(fp8_ref, inv_scale_ref, new_amax_ref, x_normed_ref, rrms_ref, *([h_ref] if with_residual else []))
  loss_ref = (y_ref * (FP8_MAX / (amax_state.float() + 1e-8))).sum()
  if with_residual: loss_ref = loss_ref + h_ref.float().sum()
  loss_ref.backward()
  Tensor.realize(loss_ref, x_ref.grad, weight_ref.grad, *([residual_ref.grad] if with_residual else []))

  with Context(DEBUG=0):
    assert x_normed.allclose(x_normed_ref, atol=2e-3, rtol=2e-3).item(), "x_normed mismatch"
    assert rrms.allclose(rrms_ref, atol=2e-4, rtol=2e-4).item(), "rrms mismatch"
    assert new_amax.allclose(new_amax_ref, atol=2e-3, rtol=2e-3).item(), "amax mismatch"
    assert inv_scale.allclose(inv_scale_ref, atol=1e-6, rtol=1e-6).item(), "inv_scale mismatch"
    assert (fp8.float() * inv_scale).allclose(fp8_ref.float() * inv_scale_ref, atol=2e-1, rtol=2e-1).item(), "fp8 mismatch"
    assert x.grad.allclose(x_ref.grad.cast(dtypes.bfloat16), atol=5e-2, rtol=5e-2).item(), "x grad mismatch"
    assert weight.grad.allclose(weight_ref.grad.cast(dtypes.bfloat16), atol=5e-2, rtol=5e-2).item(), "weight grad mismatch"
    if with_residual:
      assert h.allclose(h_ref, atol=2e-3, rtol=2e-3).item(), "h mismatch"
      assert residual.grad.allclose(residual_ref.grad.cast(dtypes.bfloat16), atol=5e-2, rtol=5e-2).item(), "residual grad mismatch"

class TestFusedRMSNormMulQuantizeFP8(unittest.TestCase):
  def setUp(self):
    target = Device[Device.DEFAULT].renderer.target
    if not (is_dtype_supported(dtypes.bfloat16, target) and is_dtype_supported(dtypes.fp8e4m3, target)): self.skipTest("need bfloat16/fp8e4m3")

  def test_fused_rmsnorm_mul_quantize_fp8_1_2_2048(self): run_fused_rmsnorm_mul_quantize_fp8(1, 2, 2048)
  def test_fused_add_rmsnorm_mul_quantize_fp8_1_2_2048(self): run_fused_rmsnorm_mul_quantize_fp8(1, 2, 2048, with_residual=True)

if __name__ == '__main__':
  unittest.main()
