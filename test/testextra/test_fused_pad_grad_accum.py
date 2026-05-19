#!/usr/bin/env python3
import unittest

from tinygrad import Tensor, Device, dtypes
from tinygrad.helpers import getenv
from extra.llama_kernels.fused_pad_grad_accum import fused_pad_grad_accum

PROFILE_SHAPES = (
  # (n_chunks, chunk_size) from the saved LLaMA 3.1 8B profile.
  (32, 4096),
  (32, 16777216),
  (32, 25165824),
  (32, 58720256),
)

def _is_gfx950() -> bool:
  return Device[Device.DEFAULT].renderer.target.arch.startswith("gfx950")

def _profile_devices():
  return tuple(f"{Device.DEFAULT}:{i}" for i in range(getenv("GPUS", 8)))

def _run_fused_pad_grad_accum(n_chunks:int, chunk_size:int):
  devs = _profile_devices()
  total = n_chunks * chunk_size

  grad = Tensor.full((total,), 1, dtype=dtypes.bfloat16, device=devs).contiguous()
  grad_ref = Tensor.full((total,), 1, dtype=dtypes.bfloat16, device=devs).contiguous()
  chunks = [Tensor.full((chunk_size,), i + 2, dtype=dtypes.bfloat16, device=devs).contiguous() for i in range(n_chunks)]
  Tensor.realize(grad, grad_ref, *chunks)

  out = fused_pad_grad_accum(grad, chunks).realize()
  ref = (grad_ref + chunks[0].cat(*chunks[1:], dim=0)).realize()

  assert out.shape == ref.shape == (total,)
  assert out.dtype == ref.dtype == dtypes.bfloat16
  assert out.allclose(ref, atol=0, rtol=0).item(), f"mismatch for n_chunks={n_chunks} chunk_size={chunk_size}"

@unittest.skipUnless(_is_gfx950(), "fused_pad_grad_accum is compiled for gfx950")
class TestFusedPadGradAccum(unittest.TestCase):
  def test_profile_shape_4096(self):
    _run_fused_pad_grad_accum(*PROFILE_SHAPES[0])

  def test_profile_shape_16777216(self):
    _run_fused_pad_grad_accum(*PROFILE_SHAPES[1])

  def test_profile_shape_25165824(self):
    _run_fused_pad_grad_accum(*PROFILE_SHAPES[2])

  def test_profile_shape_58720256(self):
    _run_fused_pad_grad_accum(*PROFILE_SHAPES[3])

if __name__ == "__main__":
  unittest.main()
