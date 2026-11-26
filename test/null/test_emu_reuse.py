import unittest
from tinygrad import Device
from tinygrad.codegen import to_program
from tinygrad.helpers import Target
from tinygrad.renderer.amd.dsl import v, s, NULL
from tinygrad.renderer.cstyle import ClangRenderer
from tinygrad.runtime.autogen.amd.rdna3 import ins as ir3
from tinygrad.runtime.autogen.amd.rdna4 import ins as ir4
from tinygrad.runtime.autogen.amd.cdna import ins as irc
from tinygrad.uop.ops import Ops
from test.mockgpu.amd.emu import lift, instruction_call

DISPATCH = (1, 1, 1, 32, 1, 1, 0x19c, 0)
DISPATCH_2W = (1, 1, 1, 64, 1, 1, 0x19c, 0)
DISPATCH64_2W = (1, 1, 1, 128, 1, 1, 0x19c, 0)

def _asm(*insts) -> bytes: return b"".join(i.to_bytes() for i in insts)

def _waves_and_blocks(uop):
  waves = [u.body for u in uop.toposort() if u.op is Ops.CALL and u.body.op is Ops.SINK and u.body.arg.name == "emu_waves"]
  blocks = [u.body for w in waves for u in w.toposort() if u.op is Ops.CALL and u.body.src[0].arg.name == "emu_block"]
  blocks += [u.body for u in uop.toposort() if u.op is Ops.CALL and u.body.op is Ops.PROGRAM and u.body.src[0].arg.name == "emu_block"]
  return waves, blocks

class TestEmuReuse(unittest.TestCase):
  def test_inst_reuse_different_regs(self):
    pairs = [
      ("rdna3", ir3.VOP2(ir3.VOP2Op.V_ADD_F32_E32, vdst=v[2], src0=v[0], vsrc1=v[1]),
                ir3.VOP2(ir3.VOP2Op.V_ADD_F32_E32, vdst=v[10], src0=v[7], vsrc1=v[3])),
      ("rdna3", ir3.SOP2(ir3.SOP2Op.S_ADD_U32, sdst=s[4], ssrc0=s[2], ssrc1=s[3]),
                ir3.SOP2(ir3.SOP2Op.S_ADD_U32, sdst=s[12], ssrc0=s[9], ssrc1=s[6])),
      ("rdna4", ir4.VOP2(ir4.VOP2Op.V_ADD_F32_E32, vdst=v[2], src0=v[0], vsrc1=v[1]),
                ir4.VOP2(ir4.VOP2Op.V_ADD_F32_E32, vdst=v[11], src0=v[4], vsrc1=v[8])),
      ("cdna",  irc.VOP2(irc.VOP2Op.V_ADD_F32_E32, vdst=v[2], src0=v[0], vsrc1=v[1]),
                irc.VOP2(irc.VOP2Op.V_ADD_F32_E32, vdst=v[14], src0=v[5], vsrc1=v[9])),
    ]
    for arch, i1, i2 in pairs:
      c1, _ = instruction_call(i1, arch)
      c2, _ = instruction_call(i2, arch)
      self.assertIs(c1.body.src[0], c2.body.src[0], f"{arch} {i1} vs {i2} should share instruction body")

  def test_inst_reuse_different_imms(self):
    pairs = [
      (ir3.VOP1(ir3.VOP1Op.V_MOV_B32_E32, vdst=v[0], src0=1),
       ir3.VOP1(ir3.VOP1Op.V_MOV_B32_E32, vdst=v[5], src0=42)),
      (ir3.VOP1(ir3.VOP1Op.V_MOV_B32_E32, vdst=v[0], src0=1),
       ir3.VOP1_LIT(ir3.VOP1Op.V_MOV_B32_E32, vdst=v[5], src0=255, literal=0x12345678)),
      (ir3.SOP2(ir3.SOP2Op.S_ADD_U32, sdst=s[2], ssrc0=s[1], ssrc1=10),
       ir3.SOP2(ir3.SOP2Op.S_ADD_U32, sdst=s[8], ssrc0=s[4], ssrc1=60)),
      (ir3.GLOBAL(ir3.GLOBALOp.GLOBAL_LOAD_B32, vdst=v[0], addr=v[2:3], saddr=NULL, offset=0),
       ir3.GLOBAL(ir3.GLOBALOp.GLOBAL_LOAD_B32, vdst=v[4], addr=v[6:7], saddr=NULL, offset=64)),
    ]
    for i1, i2 in pairs:
      c1, _ = instruction_call(i1, "rdna3")
      c2, _ = instruction_call(i2, "rdna3")
      self.assertIs(c1.body.src[0], c2.body.src[0], f"{i1} vs {i2} should share instruction body")

  def test_inst_aliasing_distinct(self):
    # aliased ops share with each other, but not with non-aliased (restrict pointer safety)
    a1, _ = instruction_call(ir3.VOP2(ir3.VOP2Op.V_ADD_F32_E32, vdst=v[0], src0=v[0], vsrc1=v[1]), "rdna3")
    a2, _ = instruction_call(ir3.VOP2(ir3.VOP2Op.V_ADD_F32_E32, vdst=v[5], src0=v[5], vsrc1=v[2]), "rdna3")
    na, _ = instruction_call(ir3.VOP2(ir3.VOP2Op.V_ADD_F32_E32, vdst=v[2], src0=v[0], vsrc1=v[1]), "rdna3")
    self.assertIs(a1.body.src[0], a2.body.src[0])
    self.assertIsNot(a1.body.src[0], na.body.src[0])

  def test_block_and_waves_reuse_different_regs(self):
    r = Device["NULL"].renderer
    cases = [
      ("rdna3", DISPATCH_2W,
       _asm(ir3.VOP2(ir3.VOP2Op.V_ADD_F32_E32, vdst=v[2], src0=v[0], vsrc1=v[1]),
            ir3.VOP2(ir3.VOP2Op.V_MUL_F32_E32, vdst=v[3], src0=v[2], vsrc1=v[0]),
            ir3.SOP2(ir3.SOP2Op.S_ADD_U32, sdst=s[4], ssrc0=s[2], ssrc1=s[3]),
            ir3.SOPP(ir3.SOPPOp.S_ENDPGM)),
       _asm(ir3.VOP2(ir3.VOP2Op.V_ADD_F32_E32, vdst=v[10], src0=v[5], vsrc1=v[2]),
            ir3.VOP2(ir3.VOP2Op.V_MUL_F32_E32, vdst=v[1], src0=v[10], vsrc1=v[5]),
            ir3.SOP2(ir3.SOP2Op.S_ADD_U32, sdst=s[9], ssrc0=s[7], ssrc1=s[4]),
            ir3.SOPP(ir3.SOPPOp.S_ENDPGM))),
      ("rdna4", DISPATCH_2W,
       _asm(ir4.VOP2(ir4.VOP2Op.V_ADD_F32_E32, vdst=v[2], src0=v[0], vsrc1=v[1]),
            ir4.VOP2(ir4.VOP2Op.V_MUL_F32_E32, vdst=v[3], src0=v[2], vsrc1=v[0]),
            ir4.SOPP(ir4.SOPPOp.S_ENDPGM)),
       _asm(ir4.VOP2(ir4.VOP2Op.V_ADD_F32_E32, vdst=v[12], src0=v[8], vsrc1=v[3]),
            ir4.VOP2(ir4.VOP2Op.V_MUL_F32_E32, vdst=v[1], src0=v[12], vsrc1=v[8]),
            ir4.SOPP(ir4.SOPPOp.S_ENDPGM))),
      ("cdna", DISPATCH64_2W,
       _asm(irc.VOP2(irc.VOP2Op.V_ADD_F32_E32, vdst=v[2], src0=v[0], vsrc1=v[1]),
            irc.VOP2(irc.VOP2Op.V_MUL_F32_E32, vdst=v[3], src0=v[2], vsrc1=v[0]),
            irc.SOPP(irc.SOPPOp.S_ENDPGM)),
       _asm(irc.VOP2(irc.VOP2Op.V_ADD_F32_E32, vdst=v[15], src0=v[6], vsrc1=v[1]),
            irc.VOP2(irc.VOP2Op.V_MUL_F32_E32, vdst=v[2], src0=v[15], vsrc1=v[6]),
            irc.SOPP(irc.SOPPOp.S_ENDPGM))),
    ]
    for arch, disp, c1, c2 in cases:
      w1, b1 = _waves_and_blocks(lift(c1, arch, r, disp, "p1"))
      w2, b2 = _waves_and_blocks(lift(c2, arch, r, disp, "p2"))
      self.assertEqual(len(w1), 1)
      self.assertEqual(len(b1), 1)
      self.assertIs(b1[0], b2[0], f"{arch}: same instruction stream with different regs must share emu_block")
      self.assertIs(w1[0], w2[0], f"{arch}: same instruction stream with different regs must share emu_waves")
    # Single-wave unconditional blocks call emu_block directly and still share emu_block
    _, b1 = _waves_and_blocks(lift(cases[0][2], "rdna3", r, DISPATCH, "p1_1w"))
    _, b2 = _waves_and_blocks(lift(cases[0][3], "rdna3", r, DISPATCH, "p2_1w"))
    self.assertEqual(len(b1), 1)
    self.assertIs(b1[0], b2[0])

  def test_diamond_cfg_block_reuse(self):
    # Two branches at different PCs with the same instruction stream on different registers
    # must share the exact same emu_block and emu_waves bodies.
    code = _asm(
      # block 0 (PC 0): branch to block 2 (PC 20, +3 dwords from PC 8)
      ir3.SOPC(ir3.SOPCOp.S_CMP_EQ_U32, ssrc0=s[4], ssrc1=0),
      ir3.SOPP(ir3.SOPPOp.S_CBRANCH_SCC0, simm16=3),
      # block 1 (PC 8): v2 = v0 + v1; v3 = v2 * v0; branch to done (+3 dwords from PC 20)
      ir3.VOP2(ir3.VOP2Op.V_ADD_F32_E32, vdst=v[2], src0=v[0], vsrc1=v[1]),
      ir3.VOP2(ir3.VOP2Op.V_MUL_F32_E32, vdst=v[3], src0=v[2], vsrc1=v[0]),
      ir3.SOPP(ir3.SOPPOp.S_BRANCH, simm16=3),
      # block 2 (PC 20): v10 = v5 + v2; v1 = v10 * v5; branch to done (0 dwords from PC 32)
      ir3.VOP2(ir3.VOP2Op.V_ADD_F32_E32, vdst=v[10], src0=v[5], vsrc1=v[2]),
      ir3.VOP2(ir3.VOP2Op.V_MUL_F32_E32, vdst=v[1], src0=v[10], vsrc1=v[5]),
      ir3.SOPP(ir3.SOPPOp.S_BRANCH, simm16=0),
      # block 3 (PC 32): done
      ir3.SOPP(ir3.SOPPOp.S_ENDPGM),
    )
    uop = lift(code, "rdna3", Device["NULL"].renderer, DISPATCH_2W, "diamond")
    waves, blocks = _waves_and_blocks(uop)
    self.assertEqual(len(waves), 4)
    self.assertEqual(len(blocks), 4)
    # 4 blocks total, but block 1 and block 2 share both emu_block and emu_waves
    self.assertEqual(len(set(blocks)), 3)
    self.assertEqual(len(set(waves)), 3)

    # Also verify codegen deduplication through to_program with ClangRenderer (no execution)
    renderer = ClangRenderer(Target("CPU", arch="x86_64,x86-64"))
    prg = to_program(lift(code, "rdna3", renderer, DISPATCH_2W, "diamond_c"), renderer)
    wave_calls = [u.body for u in prg.toposort() if u.op is Ops.CALL and u.body.src[0].arg.name.startswith("emu_waves")]
    self.assertEqual(len(wave_calls), 4)
    self.assertEqual(len(set(wave_calls)), 3)

if __name__ == "__main__":
  unittest.main()
