import struct, unittest

import numpy as np

from tinygrad import Tensor, dtypes
from tinygrad.device import Device
from tinygrad.uop.ops import UOp, KernelInfo
from extra.gemm.mxfp4 import (MXFP4_VALUES, dequantize_mxfp4, hadamard16, mxfp4_gemm, mxfp4_gemm_preshuffled,
                              mxfp4_gemm_program_info, mxfp4_linear, quantize_mxfp4_ref, shuffle_mxfp4_scales,
                              shuffle_mxfp4_weight, unshuffle_mxfp4_scales, unshuffle_mxfp4_weight,
                              _aiter_f4_kernargs, _aiter_f4_program_info, _custom_mxfp4_dispatch)
from extra.llama_kernels.quantize_mxfp4 import quantize_mxfp4, quantize_mxfp4_program_info


def numpy_quantize_mxfp4(x:np.ndarray, use_hadamard:bool=False) -> tuple[np.ndarray, np.ndarray]:
  rows, K = x.shape
  if use_hadamard:
    h = np.array([[1.0]], dtype=np.float32)
    while h.shape[0] < 16: h = np.block([[h, h], [h, -h]])
    x = np.einsum("...j,jk->...k", x.reshape(rows, K // 32, 2, 16), h * 0.25).reshape(rows, K)
  blocks = x.reshape(rows, K // 32, 32)
  amax = np.max(np.abs(blocks), axis=-1)
  rounded = ((amax.view(np.uint32) + 0x200000) & 0xFF800000).view(np.float32)
  with np.errstate(divide="ignore"):
    unbiased = np.clip(np.floor(np.log2(np.maximum(rounded, 1e-45))) - 2, -127, 127)
  scales = np.where(amax == 0, 127, unbiased + 127).astype(np.uint8)
  scaled = blocks * np.exp2(127.0 - scales.astype(np.float32))[..., None]
  code = np.zeros_like(scaled, dtype=np.uint8)
  for threshold in (0.25, 0.75, 1.25, 1.75, 2.5, 3.5, 5.0): code += scaled.__abs__() >= threshold
  nibbles = code | ((scaled < 0).astype(np.uint8) << 3)
  nibbles = nibbles.reshape(rows, K)
  return nibbles[:, 0::2] | (nibbles[:, 1::2] << 4), scales


class TestMXFP4Reference(unittest.TestCase):
  def test_opaque_program_buffer_bindings(self):
    q, e8, x = (UOp.param(i, dtypes.uint8, (16,), "NULL") for i in range(3))
    qinfo = quantize_mxfp4_program_info(UOp.sink(q, e8, x, arg=KernelInfo("quantize_mxfp4")))
    self.assertEqual((qinfo.globals, qinfo.outs, qinfo.ins), ((0, 1, 2), (0, 1), (2,)))

    c, a, b, sa, sb, orig_a, orig_b = (UOp.param(i, dtypes.uint8, (16,), "NULL") for i in range(7))
    ginfo = mxfp4_gemm_program_info(UOp.sink(c, a, b, sa, sb, orig_a, orig_b, arg=KernelInfo("mxfp4_gemm")))
    self.assertEqual((ginfo.globals, ginfo.outs, ginfo.ins), ((0, 1, 2, 3, 4, 5, 6), (0,), (1, 2, 3, 4, 5, 6)))

  def test_aiter_f4_packed_abi(self):
    M, N, K = 16384, 4096, 14336
    args = _aiter_f4_kernargs(M, N, K)
    self.assertEqual(len(args), 384)
    self.assertEqual(struct.unpack_from("<f", args, 64)[0], 1.0)
    self.assertEqual(struct.unpack_from("<f", args, 80)[0], 0.0)
    self.assertEqual(tuple(struct.unpack_from("<I", args, off)[0] for off in (224, 240, 256)), (M, N, K))
    self.assertEqual(tuple(struct.unpack_from("<I", args, off)[0] for off in (304, 336)), (K // 32, K // 32))
    self.assertEqual(struct.unpack_from("<I", args, 368)[0], 0)

    bufs = [UOp.param(i, dtypes.uint8, (16,), "NULL") for i in range(7)]
    info = _aiter_f4_program_info(UOp.sink(*bufs, arg=KernelInfo("aiter_f4")), M, N, K, 256, 256)
    self.assertEqual(info.global_size, (16, 64, 1))
    self.assertEqual(info.local_size, (256, 1, 1))
    self.assertEqual(info.aux[0], "packed")
    self.assertEqual(info.aux[2], (0, 32, 48, 272, 288, None, None))

  def test_aiter_selection_uses_local_shard_shape(self):
    M, N, K = 16384, 4096, 4096
    c = UOp.param(0, dtypes.bfloat16, (M, N), "AMD")
    a, b = UOp.param(1, dtypes.uint8, (M, K // 2), "AMD"), UOp.param(2, dtypes.uint8, (N, K // 2), "AMD")
    sa, sb = UOp.param(3, dtypes.uint8, (M, K // 32), "AMD"), UOp.param(4, dtypes.uint8, (N, K // 32), "AMD")
    orig_a, orig_b = UOp.param(5, dtypes.bfloat16, (M, K), "AMD"), UOp.param(6, dtypes.bfloat16, (N, K), "AMD")
    prg = _custom_mxfp4_dispatch(c, a, b, sa, sb, orig_a, orig_b, "AMD", b_preshuffled=True, use_aiter=True)
    self.assertEqual(prg.arg.name, "aiter_f4gemm_16384_4096_4096")

  def test_hadamard_is_normalized_and_self_inverse(self):
    Tensor.manual_seed(0)
    x = Tensor.randn(3, 64)
    np.testing.assert_allclose(hadamard16(hadamard16(x)).numpy(), x.numpy(), atol=2e-6, rtol=2e-6)

  def test_official_transformer_engine_vectors(self):
    x = ((((Tensor.arange(128).reshape(2, 64) * 13) % 37) - 18) / 4).float()
    expected = {
      False: (
        [190, 228, 90, 158, 213, 97, 45, 198, 99, 75, 174, 228, 89, 13, 213, 97,
         44, 198, 227, 75, 174, 229, 89, 29, 214, 98, 60, 182, 228, 74, 158, 213,
         80, 29, 198, 98, 60, 190, 228, 90, 158, 213, 97, 45, 198, 99, 75, 174,
         228, 89, 13, 213, 97, 44, 198, 227, 75, 174, 229, 89, 29, 214, 98, 60],
        [127, 127, 127, 127]),
      True: (
        [27, 203, 73, 76, 205, 196, 76, 252, 194, 2, 228, 6, 10, 224, 6, 96,
         10, 169, 41, 218, 33, 42, 162, 162, 49, 12, 2, 96, 4, 0, 0, 0,
         193, 98, 237, 230, 6, 0, 0, 0, 193, 2, 100, 14, 10, 224, 14, 224,
         80, 2, 228, 96, 10, 14, 96, 96, 192, 2, 13, 224, 10, 96, 224, 6],
        [127, 128, 127, 127]),
    }
    for use_hadamard, (data, scales) in expected.items():
      with self.subTest(use_hadamard=use_hadamard):
        q, s = quantize_mxfp4_ref(x, use_hadamard)
        self.assertEqual(q.flatten().tolist(), data)
        self.assertEqual(s.flatten().tolist(), scales)

  def test_random_matches_independent_numpy(self):
    rng = np.random.default_rng(4)
    for use_hadamard in (False, True):
      with self.subTest(use_hadamard=use_hadamard):
        x = rng.normal(size=(7, 96)).astype(np.float32)
        expected_q, expected_s = numpy_quantize_mxfp4(x, use_hadamard)
        q, s = quantize_mxfp4_ref(Tensor(x), use_hadamard)
        np.testing.assert_array_equal(q.numpy(), expected_q)
        np.testing.assert_array_equal(s.numpy(), expected_s)

  def test_decode_known_codes_and_scales(self):
    nibbles = np.arange(32, dtype=np.uint8) % 16
    packed = nibbles[0::2] | (nibbles[1::2] << 4)
    decoded = dequantize_mxfp4(Tensor(packed.reshape(1, 16)), Tensor([[126]], dtype=dtypes.uint8))
    expected = np.tile(np.array(MXFP4_VALUES, dtype=np.float32) * 0.5, (2, 1))
    np.testing.assert_array_equal(decoded.numpy().reshape(2, 16), expected)

  def test_zeros(self):
    q, s = quantize_mxfp4_ref(Tensor.zeros(2, 64))
    self.assertEqual(q.tolist(), [[0] * 32, [0] * 32])
    self.assertEqual(s.tolist(), [[127, 127], [127, 127]])

  def test_amd_weight_shuffle_layout_and_inverse(self):
    x = Tensor(np.arange(16 * 32, dtype=np.uint16).astype(np.uint8).reshape(16, 32))
    shuffled = shuffle_mxfp4_weight(x)
    expected = x.numpy().reshape(1, 16, 1, 2, 16).transpose(0, 2, 3, 1, 4).reshape(16, 32)
    np.testing.assert_array_equal(shuffled.numpy(), expected)
    np.testing.assert_array_equal(unshuffle_mxfp4_weight(shuffled).numpy(), x.numpy())

  def test_amd_scale_shuffle_layout_and_inverse(self):
    x = Tensor(np.arange(32 * 16, dtype=np.uint16).astype(np.uint8).reshape(32, 16))
    shuffled = shuffle_mxfp4_scales(x)
    expected = x.numpy().reshape(1, 2, 16, 2, 2, 4).transpose(0, 3, 5, 2, 4, 1).reshape(32, 16)
    np.testing.assert_array_equal(shuffled.numpy(), expected)
    np.testing.assert_array_equal(unshuffle_mxfp4_scales(shuffled).numpy(), x.numpy())


class TestMXFP4HIP(unittest.TestCase):
  def test_native_matches_reference(self):
    if Device.DEFAULT.split(":")[0] != "AMD": self.skipTest("native MXFP4 quantizer requires AMD")
    Tensor.manual_seed(5)
    x = (Tensor.randn(257, 96) * 2).cast(dtypes.bfloat16).realize()
    for use_hadamard in (False, True):
      with self.subTest(use_hadamard=use_hadamard):
        expected_q, expected_s = quantize_mxfp4_ref(x, use_hadamard)
        q, s = quantize_mxfp4(x, use_hadamard)
        Tensor.realize(q, s, expected_q, expected_s)
        np.testing.assert_array_equal(q.numpy(), expected_q.numpy())
        np.testing.assert_array_equal(s.numpy(), expected_s.numpy())

  def test_native_gemm_matches_dequantized_reference(self):
    if Device.DEFAULT.split(":")[0] != "AMD": self.skipTest("native MXFP4 GEMM requires AMD")
    Tensor.manual_seed(7)
    for M, N, K, use_hadamard in ((16, 16, 128, False), (32, 48, 256, False), (16, 32, 128, True), (256, 256, 256, False)):
      with self.subTest(shape=(M, N, K), use_hadamard=use_hadamard):
        a = (Tensor.randn(M, K) * 0.5).cast(dtypes.bfloat16).realize()
        b = (Tensor.randn(N, K) * 0.5).cast(dtypes.bfloat16).realize()
        aq, ae = quantize_mxfp4(a, use_hadamard)
        bq, be = quantize_mxfp4(b, use_hadamard)
        out = mxfp4_gemm(aq, bq, ae, be)
        ref = dequantize_mxfp4(aq, ae) @ dequantize_mxfp4(bq, be).T
        Tensor.realize(out, ref)
        np.testing.assert_allclose(out.float().numpy(), ref.numpy(), atol=0.25, rtol=0.01)

  def test_native_gemm_uses_each_block_scale(self):
    if Device.DEFAULT.split(":")[0] != "AMD": self.skipTest("native MXFP4 GEMM requires AMD")
    q = Tensor(np.full((16, 64), 0x22, dtype=np.uint8), device="AMD")
    sa = Tensor(np.tile(np.array([127, 128, 129, 130], dtype=np.uint8), (16, 1)), device="AMD")
    sb = Tensor(np.tile(np.array([130, 129, 128, 127], dtype=np.uint8), (16, 1)), device="AMD")
    out = mxfp4_gemm(q, q, sa, sb).realize().float().numpy()
    np.testing.assert_array_equal(out, np.full((16, 16), 1024.0, dtype=np.float32))

  def test_preshuffled_weight_gemm_matches_plain_layout(self):
    if Device.DEFAULT.split(":")[0] != "AMD": self.skipTest("native MXFP4 GEMM requires AMD")
    Tensor.manual_seed(17)
    M = N = K = 256
    a = (Tensor.randn(M, K) * 0.5).cast(dtypes.bfloat16).realize()
    b = (Tensor.randn(N, K) * 0.5).cast(dtypes.bfloat16).realize()
    aq, ae = quantize_mxfp4(a)
    bq, be = quantize_mxfp4(b)
    plain = mxfp4_gemm(aq, bq, ae, be)
    shuffled = mxfp4_gemm_preshuffled(aq, shuffle_mxfp4_weight(bq), shuffle_mxfp4_scales(ae), shuffle_mxfp4_scales(be))
    Tensor.realize(plain, shuffled)
    np.testing.assert_array_equal(shuffled.numpy(), plain.numpy())

  def test_a4w4_backward_matches_dequantized_reference(self):
    if Device.DEFAULT.split(":")[0] != "AMD": self.skipTest("native MXFP4 GEMM requires AMD")
    Tensor.manual_seed(11)
    a = (Tensor.randn(256, 256) * 0.25).cast(dtypes.bfloat16).realize()
    b = (Tensor.randn(256, 256) * 0.25).cast(dtypes.bfloat16).realize()
    a.requires_grad = b.requires_grad = True
    gradient = (Tensor.randn(256, 256) * 0.25).cast(dtypes.bfloat16).realize()
    mxfp4_linear(a, b, use_hadamard=True).backward(gradient)
    assert a.grad is not None and b.grad is not None

    gq, ge = quantize_mxfp4(gradient, True)
    btq, bte = quantize_mxfp4(b.detach().T.contiguous(), True)
    gtq, gte = quantize_mxfp4(gradient.T.contiguous(), True)
    atq, ate = quantize_mxfp4(a.detach().T.contiguous(), True)
    ref_a = dequantize_mxfp4(gq, ge) @ dequantize_mxfp4(btq, bte).T
    ref_b = dequantize_mxfp4(gtq, gte) @ dequantize_mxfp4(atq, ate).T
    Tensor.realize(a.grad, b.grad, ref_a, ref_b)
    np.testing.assert_allclose(a.grad.float().numpy(), ref_a.numpy(), atol=0.25, rtol=0.01)
    np.testing.assert_allclose(b.grad.float().numpy(), ref_b.numpy(), atol=0.25, rtol=0.01)


if __name__ == "__main__":
  unittest.main()
