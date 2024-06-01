#!/usr/bin/env python
import gc
import unittest
import numpy as np
from tinygrad.tensor import Tensor

def tensors_allocated():
  return sum([isinstance(x, Tensor) for x in gc.get_objects()])

class TestGC(unittest.TestCase):
  # test gc in isolation for this TestCase
  def setUp(self):
    gc.disable()
    gc.collect()
    self.init_cnt = tensors_allocated()

  def tearDown(self):
    gc.enable()

  def test_gc(self):
    a = Tensor.rand(4, 4, requires_grad=True)
    b = Tensor.zeros(4, 4, requires_grad=True)
    (a*b).mean().backward()
    assert((tensors_allocated()-self.init_cnt) > 0)
    del a,b
    gc.collect()
    assert((tensors_allocated()-self.init_cnt) == 1) # one for Tensor._rng_counter

  def test_gc_complex(self):
    a = Tensor(np.zeros((4, 4), dtype=np.float32), requires_grad=True)
    b = Tensor.rand(4, 4, requires_grad=True)
    assert((tensors_allocated()-self.init_cnt) == 2)
    (a*b).mean().backward()
    assert((tensors_allocated()-self.init_cnt) == 4)
    del b
    gc.collect()
    assert((tensors_allocated()-self.init_cnt) == 2)
    b = Tensor(np.zeros((4, 4), dtype=np.float32), requires_grad=True)
    print((tensors_allocated()-self.init_cnt))
    (a*b).mean().backward()
    print((tensors_allocated()-self.init_cnt))
    assert((tensors_allocated()-self.init_cnt) == 4)
    del b
    gc.collect()
    assert((tensors_allocated()-self.init_cnt) == 2)

if __name__ == '__main__':
  unittest.main()
