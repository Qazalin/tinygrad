import statistics, unittest
import numpy as np

from tinygrad import Device, Tensor, dtypes
from tinygrad.helpers import Context
from tinygrad.engine.realize import compile_linear, time_call
from extra.llama_kernels.fp8_optimizer_cast import fp8_optimizer_cast

FP8_MAX = 448.0

# Local per-device shapes observed in /tmp/kernel_graph.txt for llama fp8 optimizer params.
FP8_OPTIMIZER_CAST_SHAPES = ((32, 6144, 4096), (32, 4096, 4096), (32, 28672, 4096), (32, 4096, 14336))

def make_inputs(shape:tuple[int, int, int]) -> tuple[Tensor, Tensor]:
  n0, n1, n2 = shape
  r0 = Tensor.arange(n0, device=Device.DEFAULT, dtype=dtypes.int32).reshape(n0, 1, 1)
  r1 = Tensor.arange(n1, device=Device.DEFAULT, dtype=dtypes.int32).reshape(1, n1, 1)
  r2 = Tensor.arange(n2, device=Device.DEFAULT, dtype=dtypes.int32).reshape(1, 1, n2)
  # Keep values comfortably inside fp8 range after scaling so exact fp8 comparisons are stable.
  new_w = (((r0 * 3 + r1 * 5 + r2) % 127).cast(dtypes.float32) - 63.0) / 16.0
  inv_scale = (Tensor.arange(n0, device=Device.DEFAULT, dtype=dtypes.float32) % 7 + 1.0) / 8.0
  return new_w.realize(), inv_scale.realize()

def baseline_cast(new_w:Tensor, inv_scale:Tensor) -> Tensor:
  scale = inv_scale.reciprocal().reshape(-1, 1, 1)
  return (new_w * scale).clamp(-FP8_MAX, FP8_MAX).cast(dtypes.fp8e4m3).contiguous()

def time_tensor(t:Tensor) -> float:
  with Context(BEAM=0, DEBUG=0):
    linear, var_vals = t.linear_with_vars()
    linear = compile_linear(linear, beam=0)
  assert len(linear.src) == 1
  return statistics.median(time_call(linear.src[0], var_vals) for _ in range(5))

@unittest.skipUnless(Device.DEFAULT == "AMD", "requires AMD as the default device")
class TestFP8OptimizerCast(unittest.TestCase):
  @classmethod
  def setUpClass(cls):
    try: Device[Device.DEFAULT]
    except Exception as e: raise unittest.SkipTest(f"requires available AMD runtime: {e}")

  def test_llama_shapes_correct_and_faster_than_baseline(self):
    for shape in FP8_OPTIMIZER_CAST_SHAPES:
      with self.subTest(shape=shape):
        new_w, inv_scale = make_inputs(shape)
        ref = baseline_cast(new_w, inv_scale).realize()
        out = fp8_optimizer_cast(new_w, inv_scale, ref).realize()

        max_diff = (out.float() - ref.float()).abs().max().numpy()
        np.testing.assert_allclose(max_diff, np.array(0, dtype=max_diff.dtype), rtol=0, atol=0)

        baseline_tm = time_tensor(baseline_cast(new_w, inv_scale))
        fast_tm = time_tensor(fp8_optimizer_cast(new_w, inv_scale, ref))
        self.assertLessEqual(fast_tm, baseline_tm * 1.10)

if __name__ == "__main__": unittest.main()
