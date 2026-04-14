#!/usr/bin/env python
import os, time, unittest
import numpy as np

from tinygrad import Tensor, dtypes, Device
from tinygrad.helpers import Context
from extra.thunder.amd import fp8_quant
from extra.thunder.amd.fp8_quant import custom_quantize_fp8, ref_quantize_fp8


@unittest.skipUnless(Device.DEFAULT == "AMD", "HK fp8 quantize kernels are AMD-only")
class TestHKFp8Quantize(unittest.TestCase):
  def setUp(self):
    Tensor.manual_seed(0)
    self._ctx = Context(HK_FP8_QUANTIZE=1)
    self._ctx.__enter__()

  def tearDown(self):
    self._ctx.__exit__(None, None, None)

  def _assert_forward_close(self, x: Tensor, amax_state: Tensor | None = None):
    x_ref = x.clone()
    x_cst = x.clone()
    amax_ref = amax_state.clone() if amax_state is not None else None
    amax_cst = amax_state.clone() if amax_state is not None else None

    y_ref, s_ref, a_ref = ref_quantize_fp8(x_ref, amax_ref)
    y_cst, s_cst, a_cst = custom_quantize_fp8(x_cst, amax_cst)
    Tensor.realize(y_ref, s_ref, a_ref, y_cst, s_cst, a_cst)

    np.testing.assert_allclose(y_ref.cast(dtypes.float32).numpy(), y_cst.cast(dtypes.float32).numpy(), rtol=0, atol=0)
    np.testing.assert_allclose(s_ref.numpy(), s_cst.numpy(), rtol=0, atol=0)
    np.testing.assert_allclose(a_ref.cast(dtypes.float32).numpy(), a_cst.cast(dtypes.float32).numpy(), rtol=0, atol=0)

  def test_forward_no_amax_state(self):
    self._assert_forward_close(Tensor.randn(64, 128, dtype=dtypes.bfloat16))

  def test_forward_no_amax_state_uses_custom_kernel(self):
    before = fp8_quant._COUNTERS["used_no_amax_state"]
    y, s, a = custom_quantize_fp8(Tensor.randn(64, 128, dtype=dtypes.bfloat16), amax_state=None)
    Tensor.realize(y, s, a)
    self.assertEqual(fp8_quant._COUNTERS["used_no_amax_state"], before + 1)

  def test_forward_with_amax_state(self):
    self._assert_forward_close(Tensor.randn(64, 128, dtype=dtypes.bfloat16), Tensor(3.0, dtype=dtypes.bfloat16))

  def test_forward_with_amax_state_fused_off(self):
    with Context(HK_FP8_CAST_AMAX_FUSED=0):
      self._assert_forward_close(Tensor.randn(64, 128, dtype=dtypes.bfloat16), Tensor(3.0, dtype=dtypes.bfloat16))

  def test_backward_ste(self):
    self._assert_backward_ste()

  def _assert_backward_ste(self):
    amax = Tensor(2.5, dtype=dtypes.bfloat16)
    x_ref = Tensor.randn(64, 128, dtype=dtypes.bfloat16).requires_grad_(True)
    x_cst = x_ref.detach().requires_grad_(True)

    y_ref = ref_quantize_fp8(x_ref, amax_state=amax)[0].cast(dtypes.bfloat16).sum()
    y_cst = custom_quantize_fp8(x_cst, amax_state=amax)[0].cast(dtypes.bfloat16).sum()
    (g_ref,) = y_ref.gradient(x_ref)
    (g_cst,) = y_cst.gradient(x_cst)
    Tensor.realize(g_ref, g_cst)
    np.testing.assert_allclose(g_ref.cast(dtypes.float32).numpy(), g_cst.cast(dtypes.float32).numpy(), rtol=0, atol=0)

  def test_backward_ste_fused_off(self):
    with Context(HK_FP8_CAST_AMAX_FUSED=0):
      self._assert_backward_ste()

@unittest.skipUnless(Device.DEFAULT == "AMD", "HK fp8 quantize kernels are AMD-only")
@unittest.skipUnless(int(os.getenv("RUN_BENCH", "0")), "set RUN_BENCH=1 to run benchmarks")
class TestHKFp8QuantizeBench(unittest.TestCase):
  HOT_SHAPES = [(8192, 14336), (4096, 14336), (4096, 8192)]
  BIG_KERNEL_SHAPES = [(8192, 8192), (8192, 14336), (16384, 14336)]

  def setUp(self):
    self._ctx = Context(HK_FP8_QUANTIZE=1, HK_FP8_CAST_AMAX_FUSED=1)
    self._ctx.__enter__()

  def tearDown(self):
    self._ctx.__exit__(None, None, None)

  @staticmethod
  def _bench_one(fn, x: Tensor, amax: Tensor, iters: int = 5) -> tuple[float, float]:
    times = []
    for _ in range(iters):
      st = time.perf_counter()
      y, s, a = fn(x, amax)
      Tensor.realize(y, s, a)
      times.append((time.perf_counter() - st) * 1e3)
    return min(times), sum(times) / len(times)

  def test_bench_hot_shapes(self):
    for shape in self.HOT_SHAPES:
      x = Tensor.randn(*shape, dtype=dtypes.bfloat16)
      amax = Tensor(3.0, dtype=dtypes.bfloat16)
      Tensor.realize(x, amax)

      for _ in range(2):
        y, s, a = custom_quantize_fp8(x, amax)
        Tensor.realize(y, s, a)
        y, s, a = ref_quantize_fp8(x, amax)
        Tensor.realize(y, s, a)

      c_best, c_avg = self._bench_one(custom_quantize_fp8, x, amax)
      r_best, r_avg = self._bench_one(ref_quantize_fp8, x, amax)
      print(f"bench shape={shape} custom_best_ms={c_best:.3f} custom_avg_ms={c_avg:.3f} ref_best_ms={r_best:.3f} ref_avg_ms={r_avg:.3f}")
      self.assertLessEqual(c_best, r_best * 1.20)

  def test_bench_fused_toggle_big_shapes(self):
    for shape in self.BIG_KERNEL_SHAPES:
      x = Tensor.randn(*shape, dtype=dtypes.bfloat16)
      amax = Tensor(3.0, dtype=dtypes.bfloat16)
      Tensor.realize(x, amax)

      modes = {}
      for fused in (1, 0):
        with Context(HK_FP8_CAST_AMAX_FUSED=fused):
          for _ in range(2):
            y, s, a = custom_quantize_fp8(x, amax)
            Tensor.realize(y, s, a)
          modes[fused] = self._bench_one(custom_quantize_fp8, x, amax)

      print(f"fused_toggle shape={shape} fused1_best_ms={modes[1][0]:.3f} fused1_avg_ms={modes[1][1]:.3f} fused0_best_ms={modes[0][0]:.3f} fused0_avg_ms={modes[0][1]:.3f}")


if __name__ == "__main__":
  unittest.main()
