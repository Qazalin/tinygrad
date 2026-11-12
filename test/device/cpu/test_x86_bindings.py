import unittest
from dataclasses import replace
from tinygrad.dtype import dtypes, AddrSpace
from tinygrad.renderer.x86 import UOp, Ops, X86Ops, Register, RAX, RCX, RBX, RDX, XMM, WGPR, RFLAGS, with_regs, valid_asm_call, regs
from tinygrad.renderer.x86 import X86Renderer, X86LinearContext, use_flags, encodings, imm, imm_value, asm_inputs
from tinygrad.renderer.x86 import two_address, rreg, rdef, regbuf_reg, IselContext, idiv, flag_reg, pre_regalloc_matcher
from tinygrad.codegen import line_rewrite, linearize_cleanups
from tinygrad.codegen.late.regalloc import retag, read_src, LinearScanRegallocContext, pm_regalloc_rewrite

class TestAssemblyBindings(unittest.TestCase):
  def alloc(self, r=RAX):
    return UOp.alloc((r.size,), dtypes.u8, slot=-1, addrspace=AddrSpace.REG, reg=r)

  def store(self, slot, r=RAX):
    return UOp.param(slot, dtypes.int32, addrspace=AddrSpace.REG, reg=r).store(0)

  def test_bad_output_slot(self):
    body = UOp.asm(X86Ops.REG, dtype=dtypes.int32).replace(src=(self.store(100),))
    call = body.call(self.alloc())
    self.assertFalse(valid_asm_call(call))
    with self.assertRaises(AssertionError): regs(call)

  def test_duplicate_output_storage(self):
    dst = self.alloc()
    body = UOp.asm(X86Ops.REG, dtype=dtypes.int32).replace(src=(self.store(0), self.store(1, RDX)))
    self.assertFalse(valid_asm_call(body.call(dst, dst)))

  def test_missing_output_storage(self):
    body = UOp.asm(X86Ops.REG, dtype=dtypes.int32).replace(src=(self.store(0),))
    self.assertFalse(valid_asm_call(body.call()))

  def test_output_alias_rejected(self):
    dst = self.alloc()
    alias = dst.bitcast(dtypes.uint64)
    body = UOp.asm(X86Ops.REG, dtype=dtypes.int32).replace(src=(self.store(0), self.store(1, RDX)))
    self.assertFalse(valid_asm_call(body.call(dst, alias)))
    with self.assertRaises(AssertionError): with_regs(UOp.asm("pair", dtype=dtypes.int32).call(), (dst, alias))

  def test_definition_must_fit_storage(self):
    dst = UOp.alloc((1,), dtypes.u8, slot=-1, addrspace=AddrSpace.REG, reg=Register("byte", 0, (RAX,), 1))
    call = UOp.asm(X86Ops.MOV, dtype=dtypes.int32).call(UOp.cconst(1, dtypes.int32))
    with self.assertRaises(AssertionError): with_regs(call, (dst,))
    # Partial register writes may expose a narrower logical value from larger byte-backed storage.
    xmm = UOp.alloc((16,), dtypes.u8, slot=-1, addrspace=AddrSpace.REG, reg=Register("xmm", 0, XMM, 16))
    partial = with_regs(UOp.asm(X86Ops.VPINSRW, dtype=dtypes.float16).call(), (xmm,))
    self.assertEqual(regs(partial)[0].max_numel(), 16)

  def test_storage_width_matches_register(self):
    dst = UOp.alloc((4,), dtypes.u8, slot=-1, addrspace=AddrSpace.REG, reg=RAX)
    call = UOp.asm(X86Ops.MOV, dtype=dtypes.int32).call(UOp.cconst(1, dtypes.int32))
    with self.assertRaises(AssertionError): with_regs(call, (dst,))

  def test_float_register_buffer_uses_scalar_storage_width(self):
    buf = UOp.alloc((), dtypes.float32, slot=-1, addrspace=AddrSpace.REG, reg=None)
    self.assertEqual(regbuf_reg(buf).cons, XMM)
    self.assertEqual(regbuf_reg(buf).size, 4)
    copy = with_regs(UOp.asm(X86Ops.VMOVSS, dtype=dtypes.float32).call(UOp(Ops.NOOP)), (buf,))
    self.assertEqual(regs(copy)[0].arg.reg.size, 4)

  def test_scalar_xmm_spill_and_fill(self):
    r = Register("xmm", 1, size=4)
    dst = UOp.alloc((4,), dtypes.u8, slot=-1, addrspace=AddrSpace.REG, reg=r)
    value = dst.bitcast(dtypes.float32)
    ren = object.__new__(X86Renderer)
    spill = ren.spill(0, value)
    fill = ren.fill(0, value, r)
    self.assertTrue(valid_asm_call(spill))
    self.assertTrue(valid_asm_call(fill))
    self.assertEqual(encodings[X86Ops.VMOVSSm](spill), bytes.fromhex("c5fa110c24"))
    self.assertEqual(encodings[X86Ops.VMOVSS](fill), bytes.fromhex("c5fa100c24"))
    self.assertEqual([imm_value(asm_inputs(x)[3 if x is spill else 3]) for x in (spill, fill)], [4, 4])

  def test_spill_width_and_register_class(self):
    ren = object.__new__(X86Renderer)
    for sz, sp_op, ld_op, sp_bytes, ld_bytes, dtype in [
        (2, 'VPEXTRW', 'VPINSRW', "c4e379150c2400", "c5f1c40c2400", dtypes.uint16),
        (4, 'VMOVSSm', 'VMOVSS', "c5fa110c24", "c5fa100c24", dtypes.float32),
        (8, 'VMOVSDm', 'VMOVSD', "c5fb110c24", "c5fb100c24", dtypes.float64),
        (16, 'VMOVUPSm', 'VMOVUPS', "c5f8110c24", "c5f8100c24", dtypes.uint64)]:
      with self.subTest(width=sz, cls='xmm'):
        reg = replace(XMM[1], size=sz)
        val = self.alloc(reg).bitcast(dtype)
        spill, fill = ren.spill(0, val), ren.fill(0, val, reg)
        self.assertEqual([spill.body.arg[0].name, fill.body.arg[0].name], [sp_op, ld_op])
        self.assertEqual((encodings[spill.body.arg[0]](spill), encodings[fill.body.arg[0]](fill)),
                         (bytes.fromhex(sp_bytes), bytes.fromhex(ld_bytes)))
        for op in (spill, fill):
          self.assertTrue(valid_asm_call(op))
          self.assertEqual(imm_value(asm_inputs(op)[4 if op.body.arg[0] is X86Ops.VPINSRW else 3]), sz)
    for sz, sp_bytes, ld_bytes in [(2, "66890424", "668b0424"), (8, "48890424", "488b0424")]:
      with self.subTest(width=sz, cls='gpr'):
        reg = replace(RAX, size=sz)
        val = self.alloc(reg).bitcast(dtypes.uint16 if sz == 2 else dtypes.uint64)
        sp, ld = ren.spill(0, val), ren.fill(0, val, reg)
        self.assertEqual(encodings[X86Ops.MOVm](sp), bytes.fromhex(sp_bytes))
        self.assertEqual(encodings[X86Ops.MOV](ld), bytes.fromhex(ld_bytes))
  def test_spill_slots_respect_each_allocation_width(self):
    ctx = X86LinearContext(object.__new__(X86Renderer))
    regs_by_size = [replace(RAX, size=2), replace(XMM[0], size=4), replace(RAX, size=8), replace(XMM[0], size=16)]
    allocations = [ctx.assign_spill_slot(r, UOp(Ops.NOOP)) for r in regs_by_size]
    self.assertEqual(list(zip(allocations, [2, 4, 8, 16])), [(0, 2), (4, 4), (8, 8), (16, 16)])
    self.assertEqual(ctx.stack_size, 32)

  def test_partial_register_view_rejected(self):
    storage = self.alloc()
    dst = storage.reshape((2, 4))
    self.assertIs(rdef(dst), storage)
    with self.assertRaisesRegex(RuntimeError, "unsupported partial or aliased register view"): rdef(dst.permute((1, 0)))

  def test_division_declares_rdx_clobber(self):
    dividend, remainder, divisor = self.alloc(RAX), self.alloc(RDX), self.alloc(RBX)
    div = with_regs(UOp.asm(X86Ops.DIV, dtype=dtypes.uint64).call(dividend.bitcast(dtypes.uint64), divisor.bitcast(dtypes.uint64)),
                    (dividend, remainder))
    self.assertEqual(tuple(x.arg.reg for x in regs(div)), (RAX, RDX))
    lowered = two_address(X86LinearContext(object.__new__(X86Renderer)), div)[1][0]
    self.assertEqual(encodings[X86Ops.DIV](lowered), bytes([0x48, 0xf7, 0xf3])) # div rbx; quotient RAX, remainder RDX

  def test_i8_div_declares_widened_ax_storage(self):
    dt = dtypes.int8
    inputs = self.alloc(RAX).bitcast(dt), self.alloc(RCX).bitcast(dt)
    quotient_mov = idiv(IselContext(UOp.sink()), UOp(Ops.TRUNCDIV, inputs, dt))
    div = asm_inputs(quotient_mov)[0].src[1]
    self.assertEqual(len(regs(div)), 1)
    # This must use the same full-width constraint identity as the pinned dividend so regalloc tracks the aliasing clobber.
    self.assertEqual(regs(div)[0].arg.reg.cons, rdef(asm_inputs(div)[0]).arg.reg.cons)
    self.assertEqual(regs(div)[0].arg.reg.size, 2)  # the output storage contains AL/AH, not the full RAX register
    self.assertIsNot(regs(div)[0], rdef(asm_inputs(div)[0]))

  def test_conditional_definitions_rejected(self):
    gate = UOp.cconst(True, dtypes.bool)
    conditional = UOp(Ops.IF, (gate,))
    definition = with_regs(UOp.asm(X86Ops.REG, dtype=dtypes.int32).call(), (self.alloc(),))
    with self.assertRaisesRegex(RuntimeError, "if not allowed in graph"):
      linearize_cleanups([conditional, definition, UOp(Ops.ENDIF, (conditional,))])

  def test_rebinding_preserves_symbolic_inputs(self):
    call = UOp.asm(X86Ops.IMM, dtype=dtypes.int32).call(UOp.cconst(42, dtypes.int32))
    rebound = with_regs(call, (self.alloc(),))
    self.assertEqual(rebound.body.src[:-1], call.body.src)
    self.assertEqual(asm_inputs(rebound), call.src[1:])
    self.assertEqual(regs(rebound), (rebound.src[-1],))

  def test_retag_applies_to_wrapped_definition(self):
    call = with_regs(UOp.asm(X86Ops.MOV, dtype=dtypes.int32).call(UOp.cconst(1, dtypes.int32)), (self.alloc(),))
    result = retag(call.bitcast(dtypes.float32), RBX)
    self.assertEqual(result.op, Ops.BITCAST)
    self.assertEqual(regs(result.src[0])[0].arg.reg, RBX)
    self.assertEqual(asm_inputs(result.src[0]), asm_inputs(call))

  def test_retag_preserves_other_outputs(self):
    a, b = self.alloc(), self.alloc(RDX)
    call = with_regs(UOp.asm("pair", dtype=dtypes.int32).call(UOp.cconst(1, dtypes.int32)), (a, b))
    result = retag(call, RBX)
    out = regs(result)
    self.assertEqual(out[0].arg.reg, RBX)
    self.assertIs(out[1], b)
    self.assertEqual(result.src[1:-2], call.src[1:-2])

class TestX86Operands(unittest.TestCase):
  def alloc(self, r:Register, size:int=4) -> UOp:
    return UOp.alloc((size,), dtypes.uint8, device="CPU", addrspace=AddrSpace.REG, slot=-1, reg=replace(r, size=size))

  def verify(self, asm:UOp) -> UOp:
    self.assertTrue(valid_asm_call(asm))
    return asm

  def memory(self, base:UOp, displacement:int=0) -> tuple[UOp, UOp, UOp, UOp]:
    return base, UOp(Ops.NOOP), imm(dtypes.int32, displacement), imm(dtypes.uint32, 4)

  def test_memory_layout(self):
    base, src, dst = self.alloc(RAX, 8), self.alloc(RBX), self.alloc(RDX)
    load = with_regs(UOp.asm(X86Ops.MOV, dtype=dtypes.int32).call(*self.memory(base)), (dst,))
    add = with_regs(UOp.asm(X86Ops.ADD, dtype=dtypes.int32).call(src, *self.memory(base)), (dst,))
    store = UOp.asm(X86Ops.MOVm, dtype=dtypes.void).call(*self.memory(base), src)
    for asm in (load, add, store): self.verify(asm)
    self.assertEqual(encodings[X86Ops.MOV](load), bytes([0x8b, 0x10])) # mov edx, [rax]
    self.assertEqual(encodings[X86Ops.ADD](add), bytes([0x03, 0x10]))  # add edx, [rax]
    self.assertEqual(encodings[X86Ops.MOVm](store), bytes([0x89, 0x18])) # mov [rax], ebx

  def test_memory_form_keeps_other_rm_operands(self):
    vt = dtypes.float32
    left, right, mask = (self.alloc(x, 16).bitcast(vt) for x in (XMM[0], XMM[3], XMM[4]))
    dst = self.alloc(XMM[2], 16)
    register_form = with_regs(UOp.asm(X86Ops.VBLENDVPS, dtype=vt).call(left, right, mask), (dst,))
    address = self.memory(self.alloc(RAX, 8))[:2] + (imm(dtypes.int8, 0), imm(dtypes.uint32, 16))
    memory_form = with_regs(UOp.asm(X86Ops.VBLENDVPS, dtype=vt).call(left, *address, mask), (dst,))
    self.verify(register_form)
    self.verify(memory_form)
    mb = encodings[X86Ops.VBLENDVPS](memory_form)
    self.assertEqual(mb[4], (dst.arg.reg.index << 3) | rreg(address[0]).index)
    self.assertEqual(mb[-1], 0x40) # the mask is xmm4, not an address field

  def test_nonmemory_operand_is_not_a_memory_address(self):
    value, dst = self.alloc(RBX), self.alloc(RDX)
    add = with_regs(UOp.asm(X86Ops.ADD, dtype=dtypes.int32).call(value, value, value), (dst,))
    self.verify(add)
    self.assertEqual(encodings[X86Ops.ADD](add), bytes([0x03, 0xd3])) # add edx, ebx; the extra source is not a memory address

  def test_named_flag_dependency(self):
    left, right, dst = self.alloc(RAX).bitcast(dtypes.int32), self.alloc(RBX).bitcast(dtypes.int32), self.alloc(RDX)
    compare = UOp.asm(X86Ops.CMP, dtype=dtypes.void).call(left, right)
    flags = with_regs(compare, (flag_reg(IselContext(UOp.sink())),))
    cmov = with_regs(use_flags(UOp.asm(X86Ops.CMOVNE, dtype=dtypes.int32).call(left, right), flags), (dst,))
    flags = asm_inputs(cmov)[-1]
    self.assertEqual(asm_inputs(cmov), (left, right, flags))
    self.assertEqual(encodings[X86Ops.CMP](flags), bytes([0x3b, 0xc3])) # cmp eax, ebx
    self.assertEqual(rdef(flags).arg.reg.cons, (RFLAGS,))
    self.assertIs(regs(flags)[0], flags.src[-1])
    self.assertFalse(RFLAGS.can_spill)
    copy, lowered = two_address(X86LinearContext(object.__new__(X86Renderer)), cmov)[1]
    self.assertEqual(encodings[X86Ops.MOV](copy), bytes([0x8b, 0xd0])) # copy left (eax) into edx
    self.assertEqual(asm_inputs(lowered), (right, flags))
    self.assertEqual(rdef(asm_inputs(lowered)[-1]).arg.reg.cons, (RFLAGS,))

  def test_flag_rematerialization_fresh_storage(self):
    ctx = X86LinearContext(object.__new__(X86Renderer))
    left, right = self.alloc(RAX).bitcast(dtypes.int32), self.alloc(RBX).bitcast(dtypes.int32)
    compare = with_regs(UOp.asm(X86Ops.CMP, dtype=dtypes.void).call(left, right), (flag_reg(ctx),))
    sete = with_regs(use_flags(UOp.asm(X86Ops.SETE, dtype=dtypes.bool).call(), compare), (self.alloc(RDX, 1),))
    writer = with_regs(UOp.asm(X86Ops.ADD, dtype=dtypes.int32).call(left, right), (self.alloc(RCX), flag_reg(ctx)))
    dst = self.alloc(RBX, 1)
    setne = with_regs(use_flags(UOp.asm(X86Ops.SETNE, dtype=dtypes.bool).call(), compare), (dst,))
    lowered = line_rewrite([compare, sete, writer, setne], pre_regalloc_matcher, ctx)
    rebuilt = next(u for u in reversed(lowered) if u.body.arg[0] is X86Ops.CMP)
    consumer = next(u for u in reversed(lowered) if u.body.arg[0] is X86Ops.SETNE)
    self.assertIsNot(regs(rebuilt)[0], regs(compare)[0])
    self.assertFalse(regs(rebuilt)[0].arg.reg.cons[0].can_spill)
    self.assertIs(asm_inputs(consumer)[-1], rebuilt)
    self.assertIs(regs(consumer)[0], dst)
    self.assertIs(consumer.src[-1], dst)
    self.assertEqual(asm_inputs(rebuilt), asm_inputs(compare))
    for u in (rebuilt, consumer): self.verify(u)

  def test_memory_fields_have_independent_lifetimes(self):
    a = self.alloc(Register("a", 0, WGPR), 8)
    b = self.alloc(Register("b", 0, WGPR), 8)
    dst = self.alloc(Register("dst", 0, WGPR))
    a_def = with_regs(UOp.asm(X86Ops.REG, dtype=dtypes.uint64).call(), (a,))
    b_def = with_regs(UOp.asm(X86Ops.REG, dtype=dtypes.uint64).call(), (b,))
    address = a, b, imm(dtypes.int32, 0), imm(dtypes.uint32, 4)
    load = with_regs(UOp.asm(X86Ops.MOV, dtype=dtypes.int32).call(*address), (dst,))
    self.verify(load)
    self.assertEqual(read_src(load), address)
    ren = object.__new__(X86Renderer)
    ctx = LinearScanRegallocContext(X86LinearContext(ren), [a_def, b_def, load], ren)
    self.assertIsNotNone(ctx.reals[2].get(a))
    self.assertIsNotNone(ctx.reals[2].get(b))
    self.assertNotEqual(ctx.reals[2][a], ctx.reals[2][b])

  def test_memory_spill_rewrite(self):
    a, b, c = [self.alloc(Register(name, 0, (RAX, RBX)), 8) for name in ("a", "b", "c")]
    definitions = [with_regs(UOp.asm(X86Ops.REG, dtype=dtypes.uint64).call(), (v,)) for v in (a, b, c)]
    dst = self.alloc(Register("dst", 0, (RAX, RBX)))
    address = a, b, imm(dtypes.int32, 0), imm(dtypes.uint32, 4)
    load = with_regs(UOp.asm("load", dtype=dtypes.int32).call(*address, c), (dst,))
    tail = UOp.asm("use").call(c)
    uops = [*definitions, load, tail]
    ren = object.__new__(X86Renderer)
    ctx = LinearScanRegallocContext(X86LinearContext(ren), uops, ren)
    self.assertTrue(ctx.spills)
    rewritten = next(u for u in line_rewrite(uops, pm_regalloc_rewrite, ctx) if u.op is Ops.CALL and u.body.arg[0] == "load")
    address = asm_inputs(rewritten)
    self.assertEqual(tuple(rreg(field) for field in address[:2]), (ctx.reals[3][a], ctx.reals[3][b]))
    self.assertNotEqual(rreg(address[0]), rreg(address[1]))

if __name__ == "__main__": unittest.main()
