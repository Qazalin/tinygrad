from typing import List
import numpy as np
import unittest
from test.helpers import assert_jit_cache_len
from tinygrad.device import Device
from tinygrad.helpers import getenv
from tinygrad.ops import GlobalCounters
from tinygrad.tensor import Tensor
from tinygrad.features.jit import TinyJit

def helper_test_corealize(outs: List[Tensor], kernel_count: int):
  GlobalCounters.reset()
  Tensor.corealize(outs)

  assert GlobalCounters.kernel_count == kernel_count

@unittest.skipIf(getenv("PTX") or Device.DEFAULT == "METAL", "multioutput is disabled for METAL and PTX")
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
