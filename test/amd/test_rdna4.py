import unittest
import numpy as np
from tinygrad import Tensor, Device, dtypes
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.renderer import Estimates
from tinygrad.dtype import AddrSpace
from tinygrad.runtime.autogen.amd.rdna4.ins import *
from tinygrad.renderer.amd.dsl import s, v, ttmp
from test.amd.helpers import TARGET_TO_ARCH
from extra.gemm.amd_asm_matmul import Kernel

ARCH = "gfx1201"

@unittest.skipUnless(Device.DEFAULT == "AMD", "requires AMD device")
class TestCustomKernel(unittest.TestCase):
  def test_nop(self):
    def test(A:UOp) -> UOp:
      threads = UOp.special(A.size, "lidx0")
      k = Kernel(ARCH); e = k.emit
      e(s_nop(1))
      e(s_endpgm())
      sink = UOp.sink(A.base, threads, arg=KernelInfo("test_nop"))
      return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in k.finalize()]))))
    a = Tensor([1]).realize()
    a = Tensor.custom_kernel(a, fxn=test)[0].realize()
    np.testing.assert_equal(a.numpy(), [1])

  def test_copy(self):
    def test(B:UOp, A:UOp) -> UOp:
      threads = UOp.special(A.size, "lidx0")
      k = Kernel(ARCH); e = k.emit
      # your turn!
      e(s_endpgm())
      sink = UOp.sink(A.base, threads, arg=KernelInfo("test_copy"))
      return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in k.finalize()]))))
    a = Tensor([10]).realize()
    b = Tensor([0]).realize()
    b = Tensor.custom_kernel(b, a, fxn=test)[0].realize()
    np.testing.assert_equal(b.numpy(), [10])

if __name__ == "__main__":
  unittest.main()
