import unittest
from tinygrad import Tensor, Device, dtypes, Context
from tinygrad.helpers import getenv
from examples.mlperf.models.flat_llama import FP8_DTYPE, quantize_fp8
from extra.llama_kernels.cast_amax import fused_quantize_fp8_w13
from extra.llama_kernels.fused_ce import fused_ce_loss
from extra.llama_kernels.fused_rmsnorm_mul_quantize_fp8 import fused_rmsnorm_mul_quantize_fp8, fused_add_rmsnorm_mul_quantize_fp8
from extra.llama_kernels.quantize_fp8_delayed import quantize_fp8_delayed, quantize_fp8_scalar
from test.helpers import needs_second_gpu

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

class TestFusedCE(unittest.TestCase):
  def setUp(self):
    if dtypes.bfloat16 not in Device[Device.DEFAULT].renderer.supported_dtypes(): self.skipTest("need bfloat16")

  def test_fused_ce_1_2_16(self): run_fused_ce(1, 2, 16, label_smoothing=0.2)
  def test_fused_ce_2_16_128(self): run_fused_ce(2, 16, 128)
  def test_fused_ce_4_128_1024(self): run_fused_ce(4, 128, 1024, label_smoothing=0.2)

  # note: this is the shape used in llama 8b
  #def test_fused_ce_smoothing_16_1024_128256(self): run_fused_ce(16, 1024, 128256, label_smoothing=0.2)

def run_quantize_fp8(shape:tuple[int, ...], delayed:bool=True) -> None:
  Tensor.manual_seed(0)
  x = Tensor.randn(*shape).cast(dtypes.bfloat16).contiguous()
  amax_state = Tensor.full((), 2.0, dtype=dtypes.float32).contiguous()
  with Context(DEBUG=0): Tensor.realize(x, amax_state)

  if delayed:
    fp8, inv_scale, new_amax, _ = quantize_fp8_delayed(x, amax_state, FP8_DTYPE)
    ref_fp8, ref_inv_scale, ref_new_amax = quantize_fp8(x, amax_state=amax_state)
    Tensor.realize(fp8, inv_scale, new_amax)
    Tensor.realize(ref_fp8, ref_inv_scale, ref_new_amax)
  else:
    fp8 = quantize_fp8_scalar(x, amax_state, FP8_DTYPE)
    ref_fp8, _, _ = quantize_fp8(x, amax_state=amax_state)
    Tensor.realize(fp8)
    Tensor.realize(ref_fp8)

  with Context(DEBUG=0):
    assert fp8.cast(dtypes.float).allclose(ref_fp8.cast(dtypes.float), atol=0, rtol=0).item(), "fp8 mismatch"
    if delayed:
      assert inv_scale.allclose(ref_inv_scale, atol=0, rtol=0).item(), "inv_scale mismatch"
      assert new_amax.allclose(ref_new_amax, atol=0, rtol=0).item(), \
        f"amax mismatch: got={new_amax.item()} ref={ref_new_amax.item()} diff={abs(new_amax.item()-ref_new_amax.item())}"

class TestQuantizeFP8(unittest.TestCase):
  def setUp(self):
    ren = Device[Device.DEFAULT].renderer
    if dtypes.bfloat16 not in ren.supported_dtypes(): self.skipTest("need bfloat16")
    if not ren.has_local or not ren.has_shared: self.skipTest("need local/shared")

  def test_scalar(self): run_quantize_fp8((getenv("N", 1024), 32), delayed=False)
  def test_delayed(self): run_quantize_fp8((getenv("N", 2048), 1024))

  @needs_second_gpu
  def test_multi(self):
    devs = tuple(f"{Device.DEFAULT}:{i}" for i in range(8))
    x = Tensor.empty(2048*8, 1024, dtype=dtypes.bfloat16, device=devs).uop.multi(0)
    x = Tensor(x, device=devs)
    amax_state = Tensor.full((), 2.0, dtype=dtypes.float32, device=devs).contiguous()
    fp8, _, new_amax, _ = quantize_fp8_delayed(x, amax_state, FP8_DTYPE)
    Tensor.realize(fp8, new_amax)
    assert fp8.uop.shape == x.uop.shape
    assert new_amax.shape == ()

def _assert_fused_rmsnorm_quantize_matches_ref(x:Tensor, weight:Tensor, amax_state:Tensor, eps:float,
                                               residual:Tensor|None=None) -> tuple[Tensor, Tensor, Tensor|None, Tensor|None]:
  if residual is None:
    fp8, inv_scale, new_amax, x_normed, rrms = fused_rmsnorm_mul_quantize_fp8(x, weight, amax_state, eps, FP8_DTYPE)
    h = None
    ref_x = x.float()
  else:
    fp8, inv_scale, new_amax, h, x_normed, rrms = fused_add_rmsnorm_mul_quantize_fp8(x, residual, weight, amax_state, eps, FP8_DTYPE)
    ref_x = x.float() + residual.float()
  ref_rrms = (ref_x.square().mean(-1, keepdim=True) + eps).rsqrt()
  ref_x_normed_f = ref_x * ref_rrms
  ref_x_normed = ref_x_normed_f.cast(dtypes.bfloat16)
  ref_fp8, ref_inv_scale, ref_new_amax = quantize_fp8(ref_x_normed_f * weight.float(), amax_state=amax_state)

  Tensor.realize(fp8, inv_scale, new_amax, x_normed, rrms, ref_fp8, ref_inv_scale, ref_new_amax, ref_x_normed, ref_rrms)
  if residual is not None: Tensor.realize(h, ref_x)

  with Context(DEBUG=0):
    assert fp8.cast(dtypes.float).allclose(ref_fp8.cast(dtypes.float), atol=0, rtol=0).item(), "fp8 mismatch"
    assert inv_scale.allclose(ref_inv_scale, atol=0, rtol=0).item(), "inv_scale mismatch"
    assert new_amax.allclose(ref_new_amax, atol=1e-2, rtol=1e-3).item(), "amax mismatch"
    assert x_normed.allclose(ref_x_normed, atol=1e-2, rtol=1e-2).item(), "x_normed mismatch"
    assert rrms.allclose(ref_rrms.squeeze(-1), atol=1e-4, rtol=1e-4).item(), "rrms mismatch"
    if residual is not None: assert h.allclose(ref_x.cast(dtypes.bfloat16), atol=0, rtol=0).item(), "residual add mismatch"
  return fp8, ref_fp8, x_normed, rrms

class TestFusedRMSNormMulQuantizeFP8(unittest.TestCase):
  def setUp(self):
    if Device.DEFAULT != "AMD": self.skipTest("only runs on AMD for now")
    ren = Device[Device.DEFAULT].renderer
    if dtypes.bfloat16 not in ren.supported_dtypes(): self.skipTest("need bfloat16")

  def _inputs(self, shape:tuple[int, int, int]|None=None):
    Tensor.manual_seed(0)
    x = Tensor.randn(*(shape or (1, 2, getenv("HIDDEN", 2048)))).cast(dtypes.bfloat16).contiguous()
    residual = Tensor.randn(*x.shape).cast(dtypes.bfloat16).contiguous()
    weight = Tensor.randn(x.shape[-1]).cast(dtypes.bfloat16).contiguous()
    amax_state = Tensor.full((), 2.0, dtype=dtypes.float32).contiguous()
    with Context(DEBUG=0): Tensor.realize(x, residual, weight, amax_state)
    return x, residual, weight, amax_state

  def _const_inputs(self, shape:tuple[int, int, int]):
    x = Tensor.ones(*shape).cast(dtypes.bfloat16).contiguous()
    residual = Tensor.ones(*shape).cast(dtypes.bfloat16).contiguous()
    weight = Tensor.ones(shape[-1]).cast(dtypes.bfloat16).contiguous()
    amax_state = Tensor.full((), 2.0, dtype=dtypes.float32).contiguous()
    with Context(DEBUG=0): Tensor.realize(x, residual, weight, amax_state)
    return x, residual, weight, amax_state

  def test_fwd(self):
    x, _, weight, amax_state = self._inputs()
    _assert_fused_rmsnorm_quantize_matches_ref(x, weight, amax_state, eps=1e-5)

  def test_add_fwd(self):
    x, residual, weight, amax_state = self._inputs()
    _assert_fused_rmsnorm_quantize_matches_ref(x, weight, amax_state, eps=1e-5, residual=residual)

  def _test_graph_shape_fwd(self, shape:tuple[int, int, int]):
    x, _, weight, amax_state = self._const_inputs(shape)
    fp8, inv_scale, new_amax, x_normed, rrms = fused_rmsnorm_mul_quantize_fp8(x, weight, amax_state, 1e-5, FP8_DTYPE)
    Tensor.realize(fp8, inv_scale, new_amax, x_normed, rrms)
    assert fp8.shape == shape and fp8.dtype == FP8_DTYPE
    assert x_normed.shape == shape and x_normed.dtype == dtypes.bfloat16
    assert rrms.shape == shape[:2] and rrms.dtype == dtypes.float32
    assert inv_scale.shape == () and new_amax.shape == ()
    with Context(DEBUG=0):
      assert fp8.cast(dtypes.float).min().allclose(Tensor(224.0), atol=0, rtol=0).item(), "fp8 min mismatch"
      assert fp8.cast(dtypes.float).max().allclose(Tensor(224.0), atol=0, rtol=0).item(), "fp8 max mismatch"
      assert x_normed.min().allclose(Tensor(1.0, dtype=dtypes.bfloat16), atol=0, rtol=0).item(), "x_normed min mismatch"
      assert x_normed.max().allclose(Tensor(1.0, dtype=dtypes.bfloat16), atol=0, rtol=0).item(), "x_normed max mismatch"
      assert rrms.min().allclose(Tensor(1.0), atol=1e-5, rtol=1e-5).item(), "rrms min mismatch"
      assert rrms.max().allclose(Tensor(1.0), atol=1e-5, rtol=1e-5).item(), "rrms max mismatch"
      assert new_amax.allclose(Tensor(1.0), atol=1e-5, rtol=1e-5).item(), "amax mismatch"

  def _test_graph_shape_add_fwd(self, shape:tuple[int, int, int]):
    x, residual, weight, amax_state = self._const_inputs(shape)
    fp8, inv_scale, new_amax, h, x_normed, rrms = fused_add_rmsnorm_mul_quantize_fp8(x, residual, weight, amax_state, 1e-5, FP8_DTYPE)
    Tensor.realize(fp8, inv_scale, new_amax, h, x_normed, rrms)
    assert fp8.shape == shape and fp8.dtype == FP8_DTYPE
    assert h.shape == shape and h.dtype == dtypes.bfloat16
    assert x_normed.shape == shape and x_normed.dtype == dtypes.bfloat16
    assert rrms.shape == shape[:2] and rrms.dtype == dtypes.float32
    assert inv_scale.shape == () and new_amax.shape == ()
    with Context(DEBUG=0):
      assert fp8.cast(dtypes.float).min().allclose(Tensor(224.0), atol=0, rtol=0).item(), "fp8 min mismatch"
      assert fp8.cast(dtypes.float).max().allclose(Tensor(224.0), atol=0, rtol=0).item(), "fp8 max mismatch"
      assert h.min().allclose(Tensor(2.0, dtype=dtypes.bfloat16), atol=0, rtol=0).item(), "h min mismatch"
      assert h.max().allclose(Tensor(2.0, dtype=dtypes.bfloat16), atol=0, rtol=0).item(), "h max mismatch"
      assert x_normed.min().allclose(Tensor(1.0, dtype=dtypes.bfloat16), atol=0, rtol=0).item(), "x_normed min mismatch"
      assert x_normed.max().allclose(Tensor(1.0, dtype=dtypes.bfloat16), atol=0, rtol=0).item(), "x_normed max mismatch"
      assert rrms.min().allclose(Tensor(0.5), atol=1e-5, rtol=1e-5).item(), "rrms min mismatch"
      assert rrms.max().allclose(Tensor(0.5), atol=1e-5, rtol=1e-5).item(), "rrms max mismatch"
      assert new_amax.allclose(Tensor(1.0), atol=1e-5, rtol=1e-5).item(), "amax mismatch"

  def _test_graph_shape_bwd(self, shape:tuple[int, int, int]):
    if getenv("FORWARD_ONLY", 0): self.skipTest("FORWARD_ONLY")
    x, _, weight, amax_state = self._const_inputs(shape)
    x.is_param_(True)
    weight.is_param_(True)
    fp8, _, _, _, _ = fused_rmsnorm_mul_quantize_fp8(x, weight, amax_state, 1e-5, FP8_DTYPE)
    fp8.cast(dtypes.float).sum().backward()
    Tensor.realize(x.grad, weight.grad)
    assert x.grad.shape == shape and x.grad.dtype == dtypes.bfloat16
    assert weight.grad.shape == (shape[-1],) and weight.grad.dtype == dtypes.bfloat16
    with Context(DEBUG=0):
      assert x.grad.min().allclose(Tensor(0.0, dtype=dtypes.bfloat16), atol=0, rtol=0).item(), "x grad min mismatch"
      assert x.grad.max().allclose(Tensor(0.0, dtype=dtypes.bfloat16), atol=0, rtol=0).item(), "x grad max mismatch"
      assert weight.grad.min().cast(dtypes.float).allclose(Tensor(float(shape[0] * shape[1] * 224)), atol=2e4, rtol=1e-2).item(), "weight grad min mismatch"
      assert weight.grad.max().cast(dtypes.float).allclose(Tensor(float(shape[0] * shape[1] * 224)), atol=2e4, rtol=1e-2).item(), "weight grad max mismatch"

  def _test_graph_shape_add_bwd(self, shape:tuple[int, int, int]):
    if getenv("FORWARD_ONLY", 0): self.skipTest("FORWARD_ONLY")
    x, residual, weight, amax_state = self._const_inputs(shape)
    x.is_param_(True)
    residual.is_param_(True)
    weight.is_param_(True)
    fp8, _, _, h, _, _ = fused_add_rmsnorm_mul_quantize_fp8(x, residual, weight, amax_state, 1e-5, FP8_DTYPE)
    (fp8.cast(dtypes.float).sum() + h.float().sum()).backward()
    Tensor.realize(x.grad, residual.grad, weight.grad)
    assert x.grad.shape == shape and x.grad.dtype == dtypes.bfloat16
    assert residual.grad.shape == shape and residual.grad.dtype == dtypes.bfloat16
    assert weight.grad.shape == (shape[-1],) and weight.grad.dtype == dtypes.bfloat16
    with Context(DEBUG=0):
      assert x.grad.min().allclose(Tensor(1.0, dtype=dtypes.bfloat16), atol=0, rtol=0).item(), "x grad min mismatch"
      assert x.grad.max().allclose(Tensor(1.0, dtype=dtypes.bfloat16), atol=0, rtol=0).item(), "x grad max mismatch"
      assert residual.grad.min().allclose(Tensor(1.0, dtype=dtypes.bfloat16), atol=0, rtol=0).item(), "residual grad min mismatch"
      assert residual.grad.max().allclose(Tensor(1.0, dtype=dtypes.bfloat16), atol=0, rtol=0).item(), "residual grad max mismatch"
      assert weight.grad.min().cast(dtypes.float).allclose(Tensor(float(shape[0] * shape[1] * 224)), atol=2e4, rtol=1e-2).item(), "weight grad min mismatch"
      assert weight.grad.max().cast(dtypes.float).allclose(Tensor(float(shape[0] * shape[1] * 224)), atol=2e4, rtol=1e-2).item(), "weight grad max mismatch"

  def test_fwd_2_8192_4096(self): self._test_graph_shape_fwd((2, 8192, 4096))
  def test_add_fwd_2_8192_4096(self): self._test_graph_shape_add_fwd((2, 8192, 4096))
  def test_bwd_2_8192_4096(self): self._test_graph_shape_bwd((2, 8192, 4096))
  def test_add_bwd_2_8192_4096(self): self._test_graph_shape_add_bwd((2, 8192, 4096))

  def test_bwd(self):
    if getenv("FORWARD_ONLY", 0): self.skipTest("FORWARD_ONLY")
    x, _, weight, amax_state = self._inputs()
    x.is_param_(True)
    weight.is_param_(True)
    fp8, _, _, _, _ = fused_rmsnorm_mul_quantize_fp8(x, weight, amax_state, 1e-5, FP8_DTYPE)
    fp8.cast(dtypes.float).sum().backward()

    x_ref = x.detach().contiguous().is_param_(True)
    weight_ref = weight.detach().contiguous().is_param_(True)
    ref_rrms = (x_ref.float().square().mean(-1, keepdim=True) + 1e-5).rsqrt()
    ref_fp8, _, _ = quantize_fp8((x_ref.float() * ref_rrms) * weight_ref.float(), amax_state=amax_state)
    ref_fp8.cast(dtypes.float).sum().backward()
    Tensor.realize(x.grad, weight.grad, x_ref.grad, weight_ref.grad)

    with Context(DEBUG=0):
      assert x.grad.allclose(x_ref.grad, atol=4e-1, rtol=2e-2).item(), "x grad mismatch"
      assert weight.grad.allclose(weight_ref.grad, atol=4, rtol=1e-1).item(), "weight grad mismatch"

def _run_fused_quantize_fp8_w13(use_uop:int, xw13:Tensor, amax_state:Tensor, grad_amax_state:Tensor):
  with Context(USE_UOP=use_uop): return fused_quantize_fp8_w13(xw13, amax_state, FP8_DTYPE, grad_amax_state)

class TestFusedQuantizeFP8W13(unittest.TestCase):
  def setUp(self):
    if Device.DEFAULT != "AMD": self.skipTest("only runs on AMD for now")
    ren = Device[Device.DEFAULT].renderer
    if dtypes.bfloat16 not in ren.supported_dtypes(): self.skipTest("need bfloat16")

  def test_use_uop_matches_c(self):
    Tensor.manual_seed(1)
    xw13 = Tensor.randn(1, 512, 8192).cast(dtypes.bfloat16).contiguous()
    amax_state = Tensor.full((), 2.0, dtype=dtypes.float32).contiguous()
    grad_amax_state = Tensor.full((), 2.0, dtype=dtypes.float32).contiguous()
    with Context(DEBUG=0): Tensor.realize(xw13, amax_state, grad_amax_state)

    c_fp8, c_inv_scale, c_amax = _run_fused_quantize_fp8_w13(0, xw13, amax_state, grad_amax_state)
    u_fp8, u_inv_scale, u_amax = _run_fused_quantize_fp8_w13(1, xw13, amax_state, grad_amax_state)
    Tensor.realize(c_fp8, c_inv_scale, c_amax, u_fp8, u_inv_scale, u_amax)

    with Context(DEBUG=0):
      assert u_fp8.cast(dtypes.float).allclose(c_fp8.cast(dtypes.float), atol=0, rtol=0).item(), "fp8 mismatch"
      assert u_inv_scale.allclose(c_inv_scale, atol=0, rtol=0).item(), "inv_scale mismatch"
      assert u_amax.allclose(c_amax, atol=1e-6, rtol=1e-6).item(), "amax mismatch"

if __name__ == '__main__':
  unittest.main()
