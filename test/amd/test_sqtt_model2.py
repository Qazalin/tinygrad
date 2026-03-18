import os
os.environ["VIZ"] = "-2"
import unittest, functools
from extra.gemm.amd_asm_matmul import Kernel
from tinygrad.runtime.autogen.amd.rdna3.ins import *
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad import Tensor, Device
from tinygrad.helpers import DEBUG, getenv
from tinygrad.renderer.amd.sqtt import *

def asm_fxn(*args:tuple[UOp, ...], k:Kernel, lx=None, gx=None, name:str="asm_fxn") -> UOp:
  if lx is None: lx = getenv("LX", 1)
  if gx is None: gx = getenv("GX", 1)
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
    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    a.realize()
    mapped = load_sqtt()
    assert len(mapped) == 2
    assert {type(p) for p,_ in mapped} == {IMMEDIATE, WAVEEND}

  def test_salu(self):
    k = Kernel(self.arch)
    k.emit(s_add_u32(s[0], s[1], s[0]))
    k.emit(s_endpgm())
    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    mapped = load_sqtt()

  def test_valu(self):
    k = Kernel(self.arch)
    k.emit(v_add_f32_e32(v[0], v[1], v[0]))
    k.emit(s_endpgm())
    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    mapped = load_sqtt()

  def test_valu_salu(self):
    k = Kernel(self.arch)
    k.emit(v_add_f32_e32(v[0], v[1], v[0]))
    k.emit(s_add_u32(s[0], s[1], s[0]))
    k.emit(v_add_f32_e32(v[2], v[3], v[4]))
    k.emit(s_endpgm())
    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    mapped = load_sqtt()

if __name__ == "__main__":
  unittest.main()
