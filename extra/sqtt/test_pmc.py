import unittest
import numpy as np
from functools import partial
import contextlib
from tinygrad import Tensor, Device, Context
from tinygrad.uop.ops import UOp, AxisType, KernelInfo

# use CPU for input tensors for simpler tracing
@contextlib.contextmanager
def copy_from_cpu(dname:str):
  Device.DEFAULT = "CPU"
  tensors:list[Tensor] = []
  yield tensors
  Device.DEFAULT = dname
  Tensor.realize(*[t.replace(t.contiguous().realize().to(dname)) for t in tensors])

def custom_add(C, A, B, stride=1):
  assert C.size == A.size == B.size
  g = UOp.range(C.size//2, 0, AxisType.GLOBAL)
  l = UOp.range(C.size//2, 1, AxisType.LOCAL)
  i = l+g*C.size//2
  return C[i].store(A[i]+B[i]).end(i).sink(arg=KernelInfo(name="custom_add", opts_to_apply=()))

class TestPMC(unittest.TestCase):
  def test_add(self):
    N = 1024
    with copy_from_cpu(Device.DEFAULT) as t:
      t.append(Tensor.full(N, 0.))
      t.append(Tensor.full(N, 1.))
      t.append(Tensor.full(N, 2.))
    out = Tensor.custom_kernel(*t, fxn=custom_add)[0]
    out.realize()
    with Context(DEBUG=0):
      np.testing.assert_allclose(out.numpy(), t[1].numpy()+t[2].numpy())

if __name__ == "__main__":
  unittest.main()
