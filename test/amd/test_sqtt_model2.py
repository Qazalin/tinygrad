import os
os.environ["VIZ"] = "-2"
import unittest, functools
from extra.gemm.amd_asm_matmul import Kernel
from tinygrad.runtime.autogen.amd.rdna3.ins import *
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad import Tensor, Device
from tinygrad.helpers import DEBUG
from tinygrad.renderer.amd.sqtt import *

def asm_fxn(*args:tuple[UOp, ...], k:Kernel, lx=1, gx=1, name:str="asm_fxn") -> UOp:
  lidx = UOp.special(lx, "lidx0")
  gidx = UOp.special(gx, "gidx0")
  sink = UOp.sink(*[t.base for t in args], lidx, gidx, arg=KernelInfo(name=name))
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in k.finalize()]))))

def load_sqtt():
  sqtt, prg = None, None
  for e in Device[Device.DEFAULT].profile_events:
    if type(e).__name__ == "ProfileSQTTEvent" and e.se == 1: sqtt = e
    if type(e).__name__ == "ProfileProgramEvent": prg = e
  target = f"gfx{Device[Device.DEFAULT].device_props()['gfx_target_version']//1000}"
  ret = []
  for p in map_insts(sqtt.blob, prg.lib, target):
    if type(p[0]).__name__.replace("_RDNA4", "") in skip: continue
    if DEBUG >= 2: print_packets([p])
    ret.append(p)
  return ret

class TestSQTTModel(unittest.TestCase):
  def setUp(self):
    self.arch = getattr(Device[Device.DEFAULT].renderer, "arch", "")
    if not self.arch.startswith("gfx11"): self.skipTest("only rdna3")
    Device[Device.DEFAULT].profile_events.clear()

  def test_nop(self):
    k = Kernel(self.arch)
    k.emit(s_nop(0))
    k.emit(s_endpgm())
    a = Tensor.empty(1)
    a = a.custom_kernel(a, fxn=functools.partial(asm_fxn, k=k))[0]
    a.realize()
    mapped = load_sqtt()
    assert len(mapped) == 2
    assert {type(p) for p,_ in mapped} == {IMMEDIATE, WAVEEND}

if __name__ == "__main__":
  unittest.main()
