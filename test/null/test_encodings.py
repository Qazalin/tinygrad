import unittest
from tinygrad.helpers import Target
from tinygrad.uop import Ops
from tinygrad.uop.ops import UOp
from tinygrad.dtype import dtypes
from tinygrad.renderer.x86 import (X86Renderer, RBP, RDI, RSP, RSI, RAX, RDX, XMM, GPR, fold_address, move_native, load_native,
                                   cast_native, alu_native, blend_native, store_native, cmov_native, cmp_native, with_native_defs)

class TestEncodingsX86(unittest.TestCase):
  # NOTE: x86 supports a single displacement as memory address and index without base memory address
  # these have no use cases so they aren't supported
  def encode(self, u:UOp): return X86Renderer(Target(device="CPU", arch="x86_64")).render([u])

  def test_large_offset(self):
    base = RDI.cast(dtypes.u32)
    address = fold_address(base.index(UOp.cconst(1 << 29, dtypes.i32)))
    index = move_native("MOVABS", UOp.cconst(1 << 29, dtypes.u64))
    self.assertEqual(address, (base, index, UOp.cconst(0, dtypes.i8), UOp.cconst(4, dtypes.u32)))

  # displacement of 0 isn't emitted
  def test_base_address(self):
    address = (RDI, UOp.cconst(0, dtypes.u64), UOp.cconst(0, dtypes.i8), UOp.cconst(4, dtypes.u8))
    load = with_native_defs(load_native("MOV", *address, value_dtype=dtypes.i32), (RDI,))
    # mov edi, dword ptr [rdi]
    self.assertEqual(bytes.fromhex(self.encode(load)), bytes.fromhex("8B 3F"))

  # rsp/r12 require a sib byte when used as base memory address
  def test_rsp_base_address(self):
    address = (RSP, UOp.cconst(0, dtypes.u64), UOp.cconst(0, dtypes.i8), UOp.cconst(4, dtypes.u8))
    load = with_native_defs(load_native("MOV", *address, value_dtype=dtypes.i32), (RSP,))
    # mov esp, dword ptr [rsp]
    self.assertEqual(bytes.fromhex(self.encode(load)), bytes.fromhex("8B 24 24"))

  # rbp/r13 require a displacement when used as base memory address
  def test_rbp_base_address(self):
    address = (RBP, UOp.cconst(0, dtypes.u64), UOp.cconst(0, dtypes.i8), UOp.cconst(4, dtypes.u8))
    load = with_native_defs(load_native("MOV", *address, value_dtype=dtypes.i32), (RBP,))
    # mov ebp, dword ptr [rbp + 0]
    self.assertEqual(bytes.fromhex(self.encode(load)), bytes.fromhex("8B 6D 00"))

  # test [base + index*scale]
  def test_base_index_address(self):
    address = (RAX, RDX, UOp.cconst(0, dtypes.i8), UOp.cconst(4, dtypes.u8))
    load = with_native_defs(load_native("MOV", *address, value_dtype=dtypes.i32), (RAX,))
    # mov eax, dword ptr [rax + rdx*4]
    self.assertEqual(bytes.fromhex(self.encode(load)), bytes.fromhex("8B 04 90"))

  # rsp as index means no index
  def test_rsp_index_address(self):
    address = (RAX, RSP, UOp.cconst(0, dtypes.i8), UOp.cconst(4, dtypes.u8))
    load = with_native_defs(load_native("MOV", *address, value_dtype=dtypes.i32), (RAX,))
    # mov eax, dword ptr [rax]
    self.assertEqual(bytes.fromhex(self.encode(load)), bytes.fromhex("8B 00"))

  # however r12 is a valid index
  def test_r12_index_address(self):
    address = (RAX, GPR[12], UOp.cconst(0, dtypes.i8), UOp.cconst(4, dtypes.u8))
    load = with_native_defs(load_native("MOV", *address, value_dtype=dtypes.i32), (RAX,))
    # mov eax, dword ptr [rax + r12*4]
    self.assertEqual(bytes.fromhex(self.encode(load)), bytes.fromhex("42 8B 04 A0"))

  # test [base + index*scale + 8bit disp]
  def test_complex_address_8bit_disp(self):
    address = (RDI, RSI, UOp.cconst(10, dtypes.i8), UOp.cconst(4, dtypes.u8))
    load = with_native_defs(load_native("MOV", *address, value_dtype=dtypes.i32), (RDI,))
    # mov edi, dword ptr [rdi + rsi*4 + 0xa]
    self.assertEqual(bytes.fromhex(self.encode(load)), bytes.fromhex("8B 7C B7 0A"))

  # test [base + index*scale + 32bit disp]
  def test_complex_address_32bit_disp(self):
    address = (RDI, RSI, UOp.cconst(10000, dtypes.i32), UOp.cconst(4, dtypes.u8))
    load = with_native_defs(load_native("MOV", *address, value_dtype=dtypes.i32), (RDI,))
    # mov edi, dword ptr [rdi + rsi*4 + 0x2710]
    self.assertEqual(bytes.fromhex(self.encode(load)), bytes.fromhex("8B BC B7 10 27 00 00"))

  # 8bit variants of legacy instructions subtract 1 from opcode
  def test_8bit_legacy_encoding(self):
    cast = with_native_defs(cast_native("MOVSX", dtypes.i32, RDX.cast(dtypes.u8)), (RAX,))
    # movsx eax, dl
    self.assertEqual(bytes.fromhex(self.encode(cast)), bytes.fromhex("0F BE C2"))

  # accessing lower 8 bits of rsp, rbp, rsi, rdi requires rex prefix
  def test_lower_8bits_reg(self):
    cast = with_native_defs(cast_native("MOVSX", dtypes.i32, RDI.cast(dtypes.u8)), (RAX,))
    # movsx eax, dil
    self.assertEqual(bytes.fromhex(self.encode(cast)), bytes.fromhex("40 0F BE C7"))

  # test 16 bit variant of legacy instruction
  def test_16bit_legacy_encoding(self):
    cast = with_native_defs(cast_native("MOVSX", dtypes.i16, RDX.cast(dtypes.u8)), (RAX,))
    # movsx ax, dl
    self.assertEqual(bytes.fromhex(self.encode(cast)), bytes.fromhex("66 0F BE C2"))

  # test 64 bit variant of legacy instruction
  def test_64bit_legacy_encoding(self):
    cast = with_native_defs(cast_native("MOVSX", dtypes.i64, RDX.cast(dtypes.u8)), (RAX,))
    # movsx rax, dl
    self.assertEqual(bytes.fromhex(self.encode(cast)), bytes.fromhex("48 0F BE C2"))

  # the operand dtype determines the register width
  def test_width_from_dtype(self):
    for dt, expected in ((dtypes.u8, "8A C2"), (dtypes.u16, "66 8B C2"), (dtypes.u32, "8B C2"), (dtypes.u64, "48 8B C2")):
      mov = with_native_defs(move_native("MOV", RDX.cast(dt)), (RAX,))
      self.assertEqual(bytes.fromhex(self.encode(mov)), bytes.fromhex(expected))

  # test compact vex encoding
  def test_compact_vex_encoding(self):
    xmm0, xmm1 = XMM[0].cast(dtypes.f32), XMM[1].cast(dtypes.f32)
    add = with_native_defs(alu_native("VADDSS", Ops.ADD, xmm0, xmm1), (XMM[0],))
    # vaddss xmm0, xmm0, xmm1
    self.assertEqual(bytes.fromhex(self.encode(add)), bytes.fromhex("C5 FA 58 C1"))

  # test long vex encoding
  def test_long_vex_encoding(self):
    xmm0, xmm8 = XMM[0].cast(dtypes.f32), XMM[8].cast(dtypes.f32)
    add = with_native_defs(alu_native("VADDSS", Ops.ADD, xmm0, xmm8), (XMM[0],))
    # vaddss xmm0, xmm0, xmm8
    self.assertEqual(bytes.fromhex(self.encode(add)), bytes.fromhex("C4 C1 7A 58 C0"))

  # test encoding where register is in the immediate field
  def test_reg_in_imm_field(self):
    xmm0, xmm1, xmm2 = XMM[0].cast(dtypes.f32), XMM[1].cast(dtypes.f32), XMM[2].cast(dtypes.f32)
    blend = with_native_defs(blend_native("VBLENDVPS", xmm0, xmm1, xmm2), (XMM[0],))
    # vblendvps xmm0, xmm0, xmm1, xmm2
    self.assertEqual(bytes.fromhex(self.encode(blend)), bytes.fromhex("C4 E3 79 4A C1 20"))

  # when writting to mem the uop takes the store form where dtype is void and there's no definition
  def test_write_mem(self):
    address = (RDI, RSI, UOp.cconst(10, dtypes.i8), UOp.cconst(4, dtypes.u8))
    xmm0 = XMM[0].cast(dtypes.i32)
    extr = store_native("VPEXTRD", *address, xmm0, UOp.cconst(0, dtypes.u8))
    # vpextrd dword ptr [rdi + rsi*4 + 0xa], xmm0, 0
    self.assertEqual(bytes.fromhex(self.encode(extr)), bytes.fromhex("C4 E3 79 16 44 B7 0A 00"))

  # test two address instruction with fused load works
  def test_two_address_load(self):
    address = (RDI, RSI, UOp.cconst(10, dtypes.i8), UOp.cconst(4, dtypes.u8))
    gate = cmp_native("CMP", Ops.CMPNE, RAX.cast(dtypes.i32), RDX.cast(dtypes.i32))
    cmove = with_native_defs(cmov_native(RDI.cast(dtypes.i32), RSI.cast(dtypes.i32), gate), (RAX,))
    cmove = cmove.replace(src=(cmove.body, *address))
    # cmovne eax, dword ptr [rdi + rsi*4 + 0xa]
    self.assertEqual(bytes.fromhex(self.encode(cmove)), bytes.fromhex("0F 45 44 B7 0A"))

  # test instruction where displacement and imm have the same value
  def test_disp_imm_same_value(self):
    address = (RDI, RSI, UOp.cconst(10, dtypes.i8), UOp.cconst(1, dtypes.u8))
    mov = store_native("MOVi", *address, UOp.cconst(10, dtypes.i8))
    # mov byte ptr [rdi + rsi + 0xa], 0xa
    self.assertEqual(bytes.fromhex(self.encode(mov)), bytes.fromhex("40 C6 44 37 0A 0A"))

    address = (RDI, RSI, UOp.cconst(10, dtypes.i32), UOp.cconst(4, dtypes.u8))
    value, imm = RDI.cast(dtypes.i32), UOp.cconst(10, dtypes.i32)
    imul = with_native_defs(alu_native("IMULi", Ops.MUL, value, imm), (RDI,))
    imul = imul.replace(src=(imul.body, *address, imm))
    # imul edi, dword ptr [rdi + rsi*4 + 0xa], 0xa
    self.assertEqual(bytes.fromhex(self.encode(imul)), bytes.fromhex("69 BC B7 0A 00 00 00 0A 00 00 00"))

  # cmoves have the cmp as the last src even though it is not explicitly used, the cmp doesn't define a reg and is ignored in the encoding
  def test_cmove_ignore_cmp(self):
    a, b = RAX.cast(dtypes.i32), RDX.cast(dtypes.i32)
    cmove = with_native_defs(cmov_native(b, a, cmp_native("CMP", Ops.CMPNE, a, b)), (RDX,))
    cmove = cmove.replace(src=(cmove.body, cmove.src[2], cmove.src[3]))
    # cmovne edx, eax
    self.assertEqual(bytes.fromhex(self.encode(cmove)), bytes.fromhex("0F 45 D0"))

if __name__ == "__main__":
  unittest.main()
