from tinygrad import Tensor, Device
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from extra.assembly.amd.test.test_custom_kernel import assemble_insts
from extra.assembly.amd.autogen.cdna.ins import *

arch = Device[Device.DEFAULT].arch

def my_nop(A):
  gidx = UOp.special(706_560, "gidx0")
  insts = [s_nop(100), s_endpgm()]
  sink = UOp.sink(A, gidx, arg=KernelInfo(name="test"))
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=(sink, *sink.src)), *assemble_insts(insts, "test", arch)))

A = Tensor.empty(3)
A = Tensor.custom_kernel(A, fxn=my_nop)[0]
A.realize()
