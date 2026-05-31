import statistics, unittest
import numpy as np

from tinygrad import Device, Tensor, dtypes
from tinygrad.helpers import Context
from tinygrad.engine.realize import compile_linear, time_call

FP8_TRANSPOSE_SHAPES = ((16384, 28672), (4096, 14336), (28672, 4096), (4096, 4096), (6144, 4096), (16384, 4096), (16384, 6144))

def make_fp8_input(rows:int, cols:int) -> Tensor:
  r = Tensor.arange(rows, device=Device.DEFAULT, dtype=dtypes.int32).reshape(rows, 1)
  c = Tensor.arange(cols, device=Device.DEFAULT, dtype=dtypes.int32).reshape(1, cols)
  return ((r + c) % 16).cast(dtypes.float32).cast(dtypes.fp8e4m3).realize()

def tensor_transpose(x:Tensor, fast:int) -> Tensor:
  with Context(FAST_TRANSPOSE=fast, BEAM=0, DEBUG=0): return x.T.contiguous()

def time_tensor_transpose(x:Tensor, fast:int) -> float:
  with Context(FAST_TRANSPOSE=fast, BEAM=0, DEBUG=0):
    linear, var_vals = tensor_transpose(x, fast).linear_with_vars()
    linear = compile_linear(linear, beam=0)
  assert len(linear.src) == 1
  return statistics.median(time_call(linear.src[0], var_vals) for _ in range(5))

class TestFastFP8Transpose(unittest.TestCase):
  @classmethod
  def setUpClass(cls):
    if Device.DEFAULT != "AMD": raise unittest.SkipTest("requires AMD as the default device")
    try: Device[Device.DEFAULT]
    except Exception as e: raise unittest.SkipTest(f"requires available AMD runtime: {e}")

  def test_supported_shapes_correct_and_faster_than_baseline(self):
    for rows, cols in FP8_TRANSPOSE_SHAPES:
      with self.subTest(rows=rows, cols=cols):
        x = make_fp8_input(rows, cols)
        ref = tensor_transpose(x, 0).realize()
        out = tensor_transpose(x, 1).realize()
        np.testing.assert_allclose(out.numpy(), ref.numpy(), rtol=0, atol=0)

        baseline_tm = time_tensor_transpose(x, 0)
        fast_tm = time_tensor_transpose(x, 1)
        self.assertLessEqual(fast_tm, baseline_tm * 1.10)

if __name__ == "__main__": unittest.main()
