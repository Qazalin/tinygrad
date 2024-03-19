from typing import List
import numpy as np
import unittest
from test.helpers import assert_jit_cache_len
from tinygrad.device import Device
from tinygrad.nn import optim
from tinygrad.nn.state import get_parameters
from tinygrad.ops import GlobalCounters
from tinygrad.tensor import Tensor
from tinygrad.features.jit import TinyJit

def helper_test_corealize(outs: List[Tensor], kernel_count: int):
  GlobalCounters.reset()
  Tensor.corealize(outs)
  assert GlobalCounters.kernel_count == kernel_count

@unittest.skipIf(Device.DEFAULT == "METAL", "grouping is skipped for METAL due to the buffer count limit")
class TestCorealize(unittest.TestCase):
  def test_simple_group(self):
    a, b = Tensor([1,2]).realize(), Tensor([3,4]).realize()
    helper_test_corealize(outs:=[a+b, a*b], 1)
    np.testing.assert_equal(outs[0].numpy(), a.numpy()+b.numpy())
    np.testing.assert_equal(outs[1].numpy(), a.numpy()*b.numpy())

  def test_ungroup_reduce(self):
    a, b = Tensor([1]).realize(), Tensor([3,4]).realize()
    helper_test_corealize([a.float(), b.sum()+1], 2)

  def test_simple_jit_group(self):
    @TinyJit
    def fxn(a, b): return a + b, a * b
    for i in range(3):
      a, b = Tensor([i, 1, 2]), Tensor([i])
      outs = fxn(a, b)
      np.testing.assert_equal(outs[0].numpy(), a.numpy()+b.numpy())
      np.testing.assert_equal(outs[1].numpy(), a.numpy()*b.numpy())
    assert_jit_cache_len(fxn, 1)

  def test_jit_ungroup_reduce(self):
    @TinyJit
    def fxn(a, b): return a + b, a.sum()
    for i in range(3):
      a, b = Tensor([i, 1, 2]), Tensor([i])
      fxn(a, b)
    assert_jit_cache_len(fxn, 2)

  def test_realize_ordering(self):
    a, b, c = Tensor([1,2,3,4]).realize(), Tensor([1,2,3,4]).realize(), Tensor([1,2,3,4]).realize()
    out0, out1 = a + b, a * c # these two will group
    out2 = out0.sum() # reduce is always one kernel
    out3 = out0 - a # runs after out0/out1's kernel
    outs = [out0, out1, out2, out3]
    helper_test_corealize(outs, 3)
    np.testing.assert_equal(outs[0].numpy(), a.numpy()+b.numpy())
    np.testing.assert_equal(outs[1].numpy(), a.numpy()*c.numpy())

  def test_group_midgraph(self):
    a, b = Tensor([1,2]).realize(), Tensor([3,4]).realize()
    out0 = (a + b).sum()
    out1, out2 = a + out0, b + out0
    helper_test_corealize([out0, out1, out2], 2)
    np.testing.assert_equal(out1.numpy(), a.numpy()+(a.numpy()+b.numpy()).sum())
    np.testing.assert_equal(out2.numpy(), b.numpy()+(a.numpy()+b.numpy()).sum())

  def test_ungroup_contiguous(self):
    a, b = Tensor([1,2]).realize(), Tensor([3,4]).realize()
    out0 = (a + b).contiguous()
    out1 = out0 + (a * b)
    helper_test_corealize([out1], 2)

  def test_simplify_shape_key(self):
    # 1s in the output shape are removed in kernel.py
    a, b = Tensor.arange(32).reshape(32,1).realize(), Tensor.arange(32).realize()
    out0, out1 = a * 2, b * 2
    helper_test_corealize([out0, out1], 1)
    np.testing.assert_equal(out0.numpy(), a.numpy()*2)
    np.testing.assert_equal(out1.numpy(), b.numpy()*2)

  def test_e2e_adam_multioutput(self):
    from examples.beautiful_mnist import Model
    model = Model()
    optimizer = optim.Adam(get_parameters(model))
    BS = 32

    def train(X):
      out = model(X)
      loss = out.mean()
      optimizer.zero_grad()
      loss.backward()
      optimizer.step()

    with Tensor.train():
      X = Tensor.randn(BS, 1, 28, 28).realize()
      GlobalCounters.reset()
      train(X)
      assert GlobalCounters.kernel_count == 76

  # multioutput limitations:

  def test_unsupported_grouped_assign(self):
    a, b, c = Tensor([1,2]).realize(), Tensor([3,4]).realize(), Tensor([5,6]).realize()
    a += c
    b += c
    helper_test_corealize([a, b], 2)

  def test_unsupported_cross_level_grouping(self):
    a, b, c = Tensor.randn(4,4).realize(), Tensor.randn(4,4).realize(), Tensor.randn(4,4).realize()
    out0 = a + b
    out1 = out0 + c
    helper_test_corealize([out0, out1], 2)
