import os
os.environ["VIZ"] = "-2"
import unittest
import functools
from tinygrad.runtime.autogen.amd.rdna3.ins import *
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad import Tensor, Device
from tinygrad.renderer.amd.sqtt import map_insts, VALUINST, ALUEXEC
from tinygrad.renderer.amd.dsl import v
from extra.gemm.amd_asm_matmul import Kernel

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
  return sqtt, prg

class TestSQTTModel(unittest.TestCase):
  def setUp(self):
    self.arch = getattr(Device[Device.DEFAULT].renderer, "arch", "")
    if not self.arch.startswith("gfx11"): self.skipTest("only rdna3")
    self.target = f"gfx{Device[Device.DEFAULT].device_props()['gfx_target_version']//1000}"
    Device[Device.DEFAULT].profile_events.clear()

  def test_delay_alu(self):
    """s_delay_alu inserts cycles between dependent VALU instructions."""
    k = Kernel(self.arch)
    # A. v_mov_b32 v3, v0
    # B. v_lshl_b32 v30, v31, #1
    # C. v_lshl_b32 v24, v25, #1
    # D. s_delay_alu instID0=3, skip=2, instID1=1
    # E. v_add_f32 v0, v1, v3    (depends on A)
    # F. v_sub_f32 v11, v9, v9
    # G. v_mul_f32 v10, v13, v11 (depends on F)
    k.emit(v_mov_b32_e32(v[3], v[0]))
    k.emit(v_lshlrev_b32_e32(v[30], 1, v[31]))
    k.emit(v_lshlrev_b32_e32(v[24], 1, v[25]))
    k.emit(s_delay_alu(0x00A3))  # instID0=3, skip=2, instID1=1
    k.emit(v_add_f32_e32(v[0], v[1], v[3]))
    k.emit(v_sub_f32_e32(v[11], v[9], v[9]))
    k.emit(v_mul_f32_e32(v[10], v[13], v[11]))
    k.emit(s_endpgm())

    a = Tensor.empty(1)
    a = a.custom_kernel(a, fxn=functools.partial(asm_fxn, k=k))[0]
    a.realize()

    sqtt, prg = load_sqtt()
    mapped = list(map_insts(sqtt.blob, prg.lib, self.target))
    issues = [(pkt._time, info.inst) for pkt, info in mapped if info and isinstance(pkt, VALUINST)]
    base = issues[0][0]

    print("\nIssue times:")
    for t, inst in issues:
      print(f"  {t - base:>3}: {inst}")

    # with s_delay_alu: gaps between C->E and F->G should be > 1
    gaps = [issues[i][0] - issues[i-1][0] for i in range(1, len(issues))]
    print(f"\nGaps: {gaps}")
    assert gaps[2] > 1, f"expected delay before E, got gap={gaps[2]}"
    assert gaps[4] > 1, f"expected delay before G, got gap={gaps[4]}"

  def test_no_delay_alu(self):
    """without s_delay_alu, all VALU instructions issue back-to-back."""
    k = Kernel(self.arch)
    k.emit(v_mov_b32_e32(v[3], v[0]))
    k.emit(v_lshlrev_b32_e32(v[30], 1, v[31]))
    k.emit(v_lshlrev_b32_e32(v[24], 1, v[25]))
    # no s_delay_alu
    k.emit(v_add_f32_e32(v[0], v[1], v[3]))
    k.emit(v_sub_f32_e32(v[11], v[9], v[9]))
    k.emit(v_mul_f32_e32(v[10], v[13], v[11]))
    k.emit(s_endpgm())

    a = Tensor.empty(1)
    a = a.custom_kernel(a, fxn=functools.partial(asm_fxn, k=k))[0]
    a.realize()

    sqtt, prg = load_sqtt()
    mapped = list(map_insts(sqtt.blob, prg.lib, self.target))
    issues = [(pkt._time, info.inst) for pkt, info in mapped if info and isinstance(pkt, VALUINST)]
    base = issues[0][0]

    print("\nIssue times:")
    for t, inst in issues:
      print(f"  {t - base:>3}: {inst}")

    # without s_delay_alu: all gaps should be 1
    gaps = [issues[i][0] - issues[i-1][0] for i in range(1, len(issues))]
    print(f"\nGaps: {gaps}")
    assert all(g == 1 for g in gaps), f"expected all gaps=1, got {gaps}"

  def test_exec_zero_skipping(self):
    """VALU with EXEC=0 produces IMMEDIATE packet, not VALUINST."""
    from tinygrad.renderer.amd.sqtt import IMMEDIATE
    from tinygrad.renderer.amd.dsl import EXEC, s

    k = Kernel(self.arch)
    k.emit(v_mov_b32_e32(v[0], 42))       # EXEC=all ones -> VALUINST
    k.emit(s_mov_b64(s[2:3], EXEC))       # save EXEC
    k.emit(s_mov_b64(EXEC, 0))            # EXEC=0
    k.emit(v_mov_b32_e32(v[1], 99))       # EXEC=0 -> IMMEDIATE (skipped)
    k.emit(s_mov_b64(EXEC, s[2:3]))       # restore EXEC
    k.emit(v_mov_b32_e32(v[2], 100))      # EXEC restored -> VALUINST
    k.emit(s_endpgm())

    a = Tensor.empty(1)
    a = a.custom_kernel(a, fxn=functools.partial(asm_fxn, k=k))[0]
    a.realize()

    sqtt, prg = load_sqtt()
    mapped = list(map_insts(sqtt.blob, prg.lib, self.target))

    valuinsts = [info.inst for pkt, info in mapped if info and isinstance(pkt, VALUINST)]
    immediates = [info.inst for pkt, info in mapped if info and isinstance(pkt, IMMEDIATE) and "v_mov" in str(info.inst).lower()]

    print(f"\nVALUINST: {valuinsts}")
    print(f"IMMEDIATE (skipped v_mov): {immediates}")

    assert len(valuinsts) == 2, f"expected 2 VALUINST, got {len(valuinsts)}"
    assert len(immediates) == 1, f"expected 1 skipped v_mov, got {len(immediates)}"

  def test_readlane(self):
    """v_readlane writes to SGPR but still produces VALUINST + ALUEXEC."""
    k = Kernel(self.arch)
    k.emit(v_mov_b32_e32(v[0], 42))
    k.emit(v_readlane_b32(s[0], v[0], 0))
    k.emit(v_readfirstlane_b32_e32(s[1], v[0]))
    k.emit(v_writelane_b32(v[1], s[0], 0))
    k.emit(s_endpgm())

    a = Tensor.empty(1)
    a = a.custom_kernel(a, fxn=functools.partial(asm_fxn, k=k))[0]
    a.realize()

    sqtt, prg = load_sqtt()
    mapped = list(map_insts(sqtt.blob, prg.lib, self.target))

    valuinsts = [info.inst for pkt, info in mapped if info and isinstance(pkt, VALUINST)]
    aluexecs = [info.inst for pkt, info in mapped if info and isinstance(pkt, ALUEXEC)]

    print(f"\nVALUINST: {valuinsts}")
    print(f"ALUEXEC: {aluexecs}")

    assert len(valuinsts) == 4, f"expected 4 VALUINST, got {len(valuinsts)}"
    assert len(aluexecs) == 4, f"expected 4 ALUEXEC, got {len(aluexecs)}"

if __name__ == "__main__":
  unittest.main()
