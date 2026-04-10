#!/usr/bin/env python3
import os, unittest

os.environ["ASM_GEMM"] = "1"

from tinygrad import Tensor, dtypes, Context, getenv
from examples.mlperf.models.flat_llama import matmul as ref_matmul, quantize_fp8 as flat_fp8_quantize

FP8 = getenv("FP8", 0)
FP8_DTYPE = dtypes.fp8e4m3
FP8_MAX = 448.0


# note: you can replace this function's body with a custom kernel!
def quantize_fp8(x:Tensor, amax_state:Tensor|None=None):
  new_amax = x.abs().max().detach()
  scale = FP8_MAX / ((amax_state if amax_state is not None else new_amax) + 1e-8)
  x_scaled = x * scale
  x_scaled_det = x_scaled.detach()
  x_clamped = x_scaled + (x_scaled_det.clamp(-FP8_MAX, FP8_MAX) - x_scaled_det)
  return x_clamped.cast(FP8_DTYPE), scale.float().reciprocal(), new_amax


def new_matmul(x:Tensor, w:Tensor, fp8=FP8, amax_x:Tensor|None=None, amax_w:Tensor|None=None) -> tuple[Tensor, ...]:
  assert fp8, "new_matmul harness only supports fp8 path"
  assert getenv("ASM_GEMM"), "new_matmul harness requires ASM_GEMM=1"
  from extra.gemm.cdna_asm_gemm import can_use_asm_gemm, asm_gemm
  x_fp8, x_scale, x_new_amax = quantize_fp8(x, amax_state=amax_x)
  w_fp8, w_scale, w_new_amax = quantize_fp8(w, amax_state=amax_w)
  combined_scale = x_scale * w_scale
  assert can_use_asm_gemm(x_fp8, w_fp8.T), "shape not supported by asm_gemm"
  return asm_gemm(x_fp8, w_fp8.T, combined_scale=combined_scale, fused=True), x_new_amax, w_new_amax


class TestFP8Flat(unittest.TestCase):
  def test_quantize_fp8_simple(self):
    Tensor.manual_seed(0)
    x = Tensor.randn(1, 256, 512, dtype=dtypes.bfloat16).contiguous()
    amax_state = Tensor.full((), FP8_MAX, dtype=dtypes.float, device=x.device).contiguous().requires_grad_(False)
    with Context(DEBUG=0):
      Tensor.realize(x, amax_state)

    q_new, s_new, a_new = quantize_fp8(x, amax_state=amax_state)
    print("** q_new")
    Tensor.realize(q_new, s_new, a_new)

    q_ref, s_ref, a_ref = flat_fp8_quantize(x, amax_state=amax_state)
    print("** q_ref")
    Tensor.realize(q_ref, s_ref, a_ref)

    with Context(DEBUG=0):
      assert q_new.allclose(q_ref, atol=0, rtol=0), "quantized fp8 mismatch"
      assert s_new.allclose(s_ref, atol=0, rtol=0), "inverse scale mismatch"
      assert a_new.allclose(a_ref, atol=0, rtol=0), "new_amax mismatch"

  def test_gemm(self):
    Tensor.manual_seed(0)
    x_rand = Tensor.randn(1, 8192, 14336, dtype=dtypes.bfloat16).contiguous()
    w_rand = Tensor.randn(4096, 14336, dtype=dtypes.bfloat16).contiguous()
    with Context(DEBUG=0):
      Tensor.realize(x_rand, w_rand)

    # match flat_llama _amax() buffer construction exactly
    def _amax(dev): return Tensor.full((), FP8_MAX, dtype=dtypes.float, device=dev).contiguous().requires_grad_(False)
    amax_x_state = _amax(x_rand.device)
    amax_w_state = _amax(w_rand.device)
    with Context(DEBUG=0):
      Tensor.realize(amax_x_state, amax_w_state)

    x_new, w_new = x_rand.clone().requires_grad_(), w_rand.clone().requires_grad_()
    y_new, x_amax_new, w_amax_new = new_matmul(x_new, w_new, fp8=True, amax_x=amax_x_state, amax_w=amax_w_state)
    loss_new = y_new.float().sum()
    loss_new.backward()
    assert x_new.grad is not None and w_new.grad is not None
    Tensor.realize(y_new, x_amax_new, w_amax_new, loss_new, x_new.grad, w_new.grad)

    x_ref, w_ref = x_rand.clone().requires_grad_(), w_rand.clone().requires_grad_()
    y_ref, x_amax_ref, w_amax_ref = ref_matmul(x_ref, w_ref, fp8=True, amax_x=amax_x_state, amax_w=amax_w_state)
    loss_ref = y_ref.float().sum()
    loss_ref.backward()
    assert x_ref.grad is not None and w_ref.grad is not None
    with Context(DEBUG=0):
      Tensor.realize(y_ref, x_amax_ref, w_amax_ref, loss_ref, x_ref.grad, w_ref.grad)

    assert y_new.allclose(y_ref, atol=2e-1, rtol=1e-2), "forward mismatch"
    assert x_new.grad.allclose(x_ref.grad, atol=2e-1, rtol=1e-2), "grad_x mismatch"
    assert w_new.grad.allclose(w_ref.grad, atol=2e-1, rtol=1e-2), "grad_w mismatch"

if __name__ == "__main__":
  unittest.main()
