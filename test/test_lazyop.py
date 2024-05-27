import unittest
from tinygrad.tensor import Tensor
from tinygrad.engine.schedule import create_schedule

# stuff needed to unpack a kernel
# ruff: noqa: F401
from tinygrad.ops import LazyOp, TernaryOps, BinaryOps, UnaryOps, ReduceOps, BufferOps, MemBuffer, ConstBuffer
from tinygrad.lazy import LazyBuffer
from tinygrad import dtypes
from tinygrad.shape.shapetracker import ShapeTracker
from tinygrad.shape.view import View
from tinygrad.shape.symbolic import Variable
import numpy as np
import time
inf, nan = float('inf'), float('nan')

class TestLazyOp(unittest.TestCase):
  def test_lazyop_str(self):
    t = Tensor.rand(10) + Tensor.rand(10)
    s = create_schedule([t.lazydata])
    ast = s[-1].ast
    ast_remade = eval(str(ast))
    self.assertEqual(ast, ast_remade)

  def test_selfreferential_speed(self):
    st = time.monotonic()
    for i in range(25):
      p = Tensor([1]).lazydata
      for _ in range(i): p = p.e(BinaryOps.ADD, p)
      # sanity check if caching works this should be way faster
      assert time.monotonic() -st < 0.5, f"{i}"

  def test_lazyop_dtype_image_alu(self):
    img0 = LazyOp(BufferOps.LOAD, (), MemBuffer(1, dtypes.imagef((32, 128, 4)), ShapeTracker(views=(View(shape=(1, 32, 32, 1, 1, 4, 4, 4, 4, 1, 1), strides=(0, 512, 16, 0, 0, 0, 0, 4, 1, 0, 0), offset=0, mask=None, contiguous=False),)))) # noqa: E501
    img1 = LazyOp(BufferOps.LOAD, (), MemBuffer(2, dtypes.imagef((32, 128, 4)), ShapeTracker(views=(View(shape=(1, 32, 32, 1, 1, 4, 4, 4, 4, 1, 1), strides=(0, 32, 1, 0, 0, 4096, 1024, 0, 0, 0, 0), offset=0, mask=None, contiguous=False),)))) # noqa: E501
    op = LazyOp(BinaryOps.MUL, (img0, img1))
    assert op.dtype == dtypes.float

if __name__ == '__main__':
  unittest.main()
