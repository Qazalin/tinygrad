import unittest
import numpy as np
from tinygrad import Tensor, Context
from tinygrad.uop.ops import Ops

class TestCopySlice(unittest.TestCase):
  def test_cross_device_shrink_copy_uses_slice(self):
    x = Tensor([1, 2, 3], device="CPU:1").realize()
    y = x[1:].to("CPU:2")
    linear = y.linear_with_vars()[0]
    self.assertEqual([si.src[0].op for si in linear.src], [Ops.SLICE, Ops.COPY])
    self.assertEqual(linear.src[0].src[0].op, Ops.SLICE)
    self.assertListEqual(x[1:].to("CPU:2").tolist(), [2, 3])

  def test_cross_device_strided_copy_stages(self):
    x = Tensor([1, 2, 3, 4], device="CPU:1").realize()
    y = x[::2].to("CPU:2")
    linear = y.linear_with_vars()[0]
    self.assertEqual([si.src[0].op for si in linear.src], [Ops.SINK, Ops.COPY])
    self.assertListEqual(x[::2].to("CPU:2").tolist(), [1, 3])

  def test_shard_arange_preserves_values(self):
    vals = np.arange(8, dtype=np.float32).reshape(2, 4)
    y = Tensor(vals).contiguous().shard(("CPU:0", "CPU:1"), axis=0).realize()
    np.testing.assert_equal(y.numpy(), vals)

  def test_allreduce_arange_preserves_values(self):
    vals = np.arange(8, dtype=np.float32).reshape(2, 4)
    with Context(RING=0, ALL2ALL=0):
      y = Tensor(vals).contiguous().shard(("CPU:0", "CPU:1"), axis=0).realize()
      np.testing.assert_equal(y.sum(0).numpy(), vals.sum(0))

if __name__ == "__main__":
  unittest.main()
