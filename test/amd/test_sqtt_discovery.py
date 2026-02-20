import unittest
import tinygrad.runtime.autogen.amd.rdna4.ins as rdna4
from extra.gemm.amd_asm_matmul import Kernel
from tinygrad import Device, Tensor
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.renderer.amd.dsl import s, NULL

def sop1_test(op):
  def test(self):
    dev = Device["AMD"]
    k = Kernel(dev.arch)
    regs = rdna4.SOP1(op=op, sdst=NULL, ssrc0=NULL).op_regs
    dst = s[0:regs["sdst"]-1] if regs["sdst"] > 1 else s[0]
    src = s[2:2+regs["ssrc0"]-1] if regs["ssrc0"] > 1 else s[2]
    k.emit(rdna4.SOP1(op=op, sdst=dst, ssrc0=src))
    k.emit(rdna4.s_endpgm())
    insts = k.finalize()
    def fxn(A:UOp) -> UOp:
      lidx = UOp.special(1, "lidx0")
      gidx = UOp.special(1, "gidx0")
      sink = UOp.sink(A.base, lidx, gidx, arg=KernelInfo(name=f"sop1_{op.name.lower()}"))
      return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in insts]))))
    a = Tensor.empty(1)
    a = Tensor.custom_kernel(a, fxn=fxn)[0]
    a.realize()
  return test

class TestSQTTDiscovery(unittest.TestCase): pass

for op in rdna4.SOP1.op.allowed:
  # skip wave control instructions
  if op.name.lower() in {"s_setpc_b64", "s_getpc_b64", "s_swappc_b64", "s_rfe_b64", "s_alloc_vgpr", "s_sleep_var", "s_barrier_init", "s_barrier_join",
                         "s_barrier_signal", "s_barrier_signal_isfirst", "s_get_barrier_state"}: continue
  setattr(TestSQTTDiscovery, f"test_sop1_{op.name.lower()}", sop1_test(op))

if __name__ == "__main__":
  unittest.main()
