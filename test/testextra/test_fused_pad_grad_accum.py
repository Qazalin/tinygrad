#!/usr/bin/env python3
import unittest
from tinygrad import Tensor, Device, dtypes, Context
from extra.llama_kernels.fused_pad_grad_accum import fused_pad_grad_accum

def _is_gfx950() -> bool:
  return Device[Device.DEFAULT].renderer.target.arch.startswith("gfx950")

def _run_fused_pad_grad_accum(n_chunks:int, chunk_size:int):
  total = n_chunks * chunk_size
  Tensor.manual_seed(0)

  grad_data = Tensor.randn(total, dtype=dtypes.float32).cast(dtypes.bfloat16).contiguous()
  chunks = [Tensor.randn(chunk_size, dtype=dtypes.float32).cast(dtypes.bfloat16).contiguous() for _ in range(n_chunks)]
  grad = grad_data.clone().contiguous()
  grad_ref = grad_data.clone().contiguous()
  with Context(DEBUG=0, TRACK_MATCH_STATS=0):
    Tensor.realize(grad, grad_ref, *chunks)

  out = fused_pad_grad_accum(grad, chunks).realize()
  ref = (grad_ref + chunks[0].cat(*chunks[1:], dim=0)).realize()

  assert out.shape == ref.shape == (total,)
  assert out.dtype == ref.dtype == dtypes.bfloat16
  with Context(DEBUG=0, TRACK_MATCH_STATS=0):
    assert (out.float() - ref.float()).abs().max().item() == 0.0, f"mismatch for n_chunks={n_chunks} chunk_size={chunk_size}"

@unittest.skipUnless(_is_gfx950(), "fused_pad_grad_accum is compiled for gfx950")
class TestFusedPadGradAccum(unittest.TestCase):
  def test_profile_shape_4096(self):
    _run_fused_pad_grad_accum(32, 4096)

  def test_profile_shape_2097152(self):
    _run_fused_pad_grad_accum(32, 2097152)

  def test_profile_shape_3145728(self):
    _run_fused_pad_grad_accum(32, 3145728)

  def test_profile_shape_7340032(self):
    _run_fused_pad_grad_accum(32, 7340032)

if __name__ == "__main__":
  unittest.main()
