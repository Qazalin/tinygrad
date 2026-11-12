import unittest
from tinygrad.dtype import dtypes, AddrSpace
from tinygrad.renderer.x86 import UOp, Ops, X86Ops, RAX, RBX, RDX, with_regs, valid_asm_call, regs, call_src, X86Renderer
from tinygrad.codegen.late.regalloc import retag

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

  def test_rebinding_preserves_symbolic_inputs(self):
    call = UOp.asm(X86Ops.IMM, dtype=dtypes.int32).call(UOp.cconst(42, dtypes.int32))
    rebound = with_regs(call, (self.alloc(),))
    self.assertEqual(rebound.body.src[:-1], call.body.src)
    self.assertEqual(call_src(rebound), call.src[1:])
    self.assertEqual(regs(rebound), (rebound.src[-1],))

  def test_retag_applies_to_wrapped_definition(self):
    call = with_regs(UOp.asm(X86Ops.MOV, dtype=dtypes.int32).call(UOp.cconst(1, dtypes.int32)), (self.alloc(),))
    result = retag(call.bitcast(dtypes.float32), RBX)
    self.assertEqual(result.op, Ops.BITCAST)
    self.assertEqual(regs(result.src[0])[0].arg.reg, RBX)
    self.assertEqual(call_src(result.src[0]), call_src(call))

  def test_retag_preserves_other_outputs(self):
    a, b = self.alloc(), self.alloc(RDX)
    call = with_regs(UOp.asm("pair", dtype=dtypes.int32).call(UOp.cconst(1, dtypes.int32)), (a, b))
    result = retag(call, RBX)
    out = regs(result)
    self.assertEqual(out[0].arg.reg, RBX)
    self.assertIs(out[1], b)
    self.assertEqual(result.src[1:-2], call.src[1:-2])

  def test_input_register_is_an_instruction_property(self):
    ren = object.__new__(X86Renderer)
    result = with_regs(UOp.asm(X86Ops.REG, dtype=dtypes.int32).call(), (self.alloc(),))
    self.assertTrue(ren.is_input_register(result))
    zero_input = with_regs(UOp.asm("new_value", dtype=dtypes.int32).call(), (self.alloc(),))
    self.assertFalse(ren.is_input_register(zero_input))

if __name__ == "__main__": unittest.main()
