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
      # Kernel arg layout: B (dest) at ioffset 0, A (source) at ioffset 8
      e(s_load_b64(sdata=s[4:5], sbase=s[0:1], ioffset=0x0, soffset=NULL))  # B
      e(s_load_b64(sdata=s[6:7], sbase=s[0:1], ioffset=0x8, soffset=NULL))  # A
      e(s_wait_kmcnt(simm16=0))
      # Load from A (source)
      e(global_load_b32(vdst=v[10], vaddr=v[0:1], saddr=s[6:7]))
      e(s_wait_loadcnt(simm16=0))
      # Store to B (dest)
      e(global_store_b32(vaddr=v[0:1], vsrc=v[10], saddr=s[4:5]))
      e(s_wait_storecnt(simm16=0))
      e(s_endpgm())
      sink = UOp.sink(B.base, A.base, threads, arg=KernelInfo("test_copy"))
      return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in k.finalize()]))))
    a = Tensor([10]).realize()
    b = Tensor([0]).realize()
    b = Tensor.custom_kernel(b, a, fxn=test)[0].realize()
    np.testing.assert_equal(b.numpy(), [10])

if __name__ == "__main__":
  unittest.main()
