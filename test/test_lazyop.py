import unittest
from hypothesis import given, strategies as st
from tinygrad.tensor import Tensor

# stuff needed to unpack a kernel
# ruff: noqa: F401
from tinygrad.ops import LazyOp, TernaryOps, BinaryOps, UnaryOps, ReduceOps, BufferOps, MemBuffer, ConstBuffer, get_lazyop_info
from tinygrad.lazy import LazyBuffer
from tinygrad.helpers import DTYPES_DICT, dtypes
from tinygrad.shape.shapetracker import ShapeTracker
from tinygrad.shape.view import View
from tinygrad.shape.symbolic import Variable
import numpy as np
import time
inf, nan = float('inf'), float('nan')

class TestLazyOp(unittest.TestCase):
  def test_lazyop_str(self):
    t = Tensor.rand(10) + Tensor.rand(10)
    s = t.lazydata.schedule()
    ast = s[-1].ast
    ast_remade = eval(str(ast))
    self.assertEqual(ast, ast_remade)

  def test_selfreferential_speed(self):
    st = time.monotonic()
    for i in range(25):
      p = LazyBuffer.fromCPU(np.array([1]))
      for _ in range(i): p = p.e(BinaryOps.ADD, p)
      # sanity check if caching works this should be way faster
      assert time.monotonic() -st < 0.5, f"{i}"

  @given(st.sampled_from([dtype for dtype in DTYPES_DICT.values() if dtypes.is_float(dtype)]))
  def test_mulacc_fusion(self, d):
    x = Tensor.rand(1024,1024, dtype=d)
    w = Tensor.rand(1024,1024, dtype=d)
    out = (x*w).sum(-1)
    reduceop = [op for op in out.lazydata.schedule()[-1].ast.get_lazyops() if op.op in ReduceOps][0]
    assert reduceop.op == ReduceOps.SUM and reduceop.src[0].op == TernaryOps.MULACC and len(reduceop.src[0].src) == 2
    assert get_lazyop_info(reduceop).dtype == d

  @given(st.sampled_from([dtype for dtype in DTYPES_DICT.values() if dtypes.is_float(dtype)]), st.sampled_from([dtype for dtype in DTYPES_DICT.values() if dtypes.is_float(dtype)]))
  def test_mulacc_fusion_midcast(self, d1, d2):
    x = Tensor.rand(1024,1024, dtype=d1)
    w = Tensor.rand(1024,1024, dtype=d1)
    out = (x*w).cast(d2).sum(-1)
    reduceop = [op for op in out.lazydata.schedule()[-1].ast.get_lazyops() if op.op in ReduceOps][0]
    #assert reduceop.op == ReduceOps.SUM and reduceop.src[0].op == TernaryOps.MULACC and len(reduceop.src[0].src) == 2
    # assert get_lazyop_info(reduceop).dtype == d2 TODO what do we expect here? max(d1, d2)? d2? d1?

if __name__ == '__main__':
  unittest.main()
