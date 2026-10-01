#!/usr/bin/env python3
"""Smoke-test the smallest supported 256x256 MXFP4 assembly GEMM.

Run with:
  DEV=MOCK+AMD::gfx950 python build/test_gemm_mxfp4_min_shape.py

The explicit gfx950 target is required because bare MOCK+AMD emulates gfx1100,
which cannot execute the CDNA4 instructions emitted by gemm_mxfp4.py.
"""

import pathlib, sys, unittest

import numpy as np

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))

from tinygrad import Device, Tensor, dtypes  # noqa: E402
from extra.gemm.cdna_asm_gemm import _mxfp4_gemm_quantized, select_mxfp4_tile  # noqa: E402


M = N = K = 256

H4 = np.array([[1, 1, 1, 1], [1, -1, 1, -1], [1, 1, -1, -1], [1, -1, -1, 1]], dtype=np.float32)
FP4_POSITIVE = np.array([0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0], dtype=np.float32)


def to_bf16_float(x:np.ndarray) -> np.ndarray:
  bits = x.astype(np.float32, copy=False).view(np.uint32)
  rounded = bits + np.uint32(0x7fff) + ((bits >> 16) & 1)
  return (rounded & np.uint32(0xffff0000)).view(np.float32)


def store_scales(scales:np.ndarray) -> np.ndarray:
  rows, cols = scales.shape
  output = np.empty(rows * cols, dtype=np.uint8)
  for row in range(rows):
    for col in range(cols):
      tile = ((row >> 5) * (cols >> 3) + (col >> 3)) << 8
      offset = ((col & 3) << 6) + ((row & 15) << 2) + (((col >> 2) & 1) << 1) + ((row >> 4) & 1)
      output[tile + offset] = scales[row, col]
  return output.reshape(rows, cols)


def shuffle_rowwise_fp4(packed:np.ndarray) -> np.ndarray:
  rows, packed_cols = packed.shape
  output = np.empty_like(packed).reshape(-1)
  for row in range(rows):
    for col in range(0, packed_cols, 2):
      tile = (row >> 4) * (packed_cols << 4) + (col >> 5) * 512
      offset = ((col >> 4) & 1) * 256 + (row & 15) * 16 + (col & 15)
      output[tile + offset:tile + offset + 2] = packed[row, col:col + 2]
  return output.reshape(rows, packed_cols)


def quantize_mxfp4_cpu(x:np.ndarray, *, shuffle:bool) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
  rows, cols = x.shape
  blocks = x.reshape(rows, cols // 32, 2, 4, 4)
  transformed = np.matmul(np.matmul(H4, blocks), H4) * np.float32(0.25)
  transformed = transformed.reshape(rows, cols // 32, 32)

  amax = np.max(np.abs(transformed), axis=-1).astype(np.float32)
  rounded_bits = (amax.view(np.uint32) + np.uint32(0x200000)) & np.uint32(0xff800000)
  exponent = ((rounded_bits >> 23) & 0xff).astype(np.int32) - 129
  exponent = np.where(amax == 0, 0, np.clip(exponent, -127, 127))
  scale = np.exp2(exponent).astype(np.float32)

  scaled = transformed / scale[..., None]
  nearest = np.abs(np.abs(scaled)[..., None] - FP4_POSITIVE).argmin(axis=-1).astype(np.uint8)
  codes = nearest | (np.signbit(scaled).astype(np.uint8) << 3)
  packed = (codes[..., 0::2] | (codes[..., 1::2] << 4)).reshape(rows, cols // 2)
  dequantized = (FP4_POSITIVE[nearest] * np.where(np.signbit(scaled), -1.0, 1.0) * scale[..., None]).reshape(rows, cols)
  stored_scales = store_scales((exponent + 127).astype(np.uint8))
  return (shuffle_rowwise_fp4(packed) if shuffle else packed), stored_scales, dequantized


class TestMinimumMXFP4GEMM(unittest.TestCase):
  def test_256x256_tile(self):
    target = Device[Device.DEFAULT].renderer.target
    self.assertEqual(target.arch, "gfx950", f"MXFP4 assembly needs CDNA4; use DEV=MOCK+AMD::gfx950, got {target}")

    rng = np.random.default_rng(1)
    a_np = to_bf16_float(rng.standard_normal((M, K), dtype=np.float32))
    b_np = to_bf16_float(rng.standard_normal((N, K), dtype=np.float32))
    a_q_np, scale_a_np, a_dequant = quantize_mxfp4_cpu(a_np, shuffle=False)
    b_q_np, scale_b_np, b_dequant = quantize_mxfp4_cpu(b_np, shuffle=True)
    self.assertTrue(a_q_np.any() and b_q_np.any())

    a_q, b_q = Tensor(a_q_np), Tensor(b_q_np)
    scale_a, scale_b = Tensor(scale_a_np), Tensor(scale_b_np)
    self.assertEqual(select_mxfp4_tile(a_q, b_q), (256, 256))
    out = _mxfp4_gemm_quantized(a_q, b_q, scale_a, scale_b).realize()

    self.assertEqual(out.shape, (M, N))
    self.assertEqual(out.dtype, dtypes.bfloat16)
    out_np = out.numpy().astype(np.float32)
    ref = a_dequant @ b_dequant.T
    relative_error = np.linalg.norm(out_np - ref) / np.linalg.norm(ref)
    self.assertLess(relative_error, 0.2, f"relative error {relative_error:.6f}")


if __name__ == "__main__":
  unittest.main(verbosity=2)
