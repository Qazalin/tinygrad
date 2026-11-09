import unittest
from tinygrad import Tensor
from tinygrad.helpers import Target, Context
from tinygrad.codegen import to_program
from tinygrad.uop import Ops
from tinygrad.uop.ops import UOp, dtypes, graph_rewrite
from tinygrad.renderer.x86 import X86Renderer, X86Ops, IselContext

# INDEX on a register value with a constant index extracts a single element (the old GEP)
def lane(y:UOp, i:int) -> UOp: return y.index(UOp.cconst(i, dtypes.int))

class TestIselX86(unittest.TestCase):
  def selected_call(self, x:UOp):
    return next(u for u in reversed(x.toposort()) if u.op is Ops.CALL and u.body.op is Ops.INS)
  def selected_ins(self, x:UOp):
    call = self.selected_call(x)
    return next(u for u in call.body.toposort() if u.op is Ops.INS and u is not call.body)
  def isel_rewrite(self, x:UOp):
    return graph_rewrite(x, X86Renderer(Target(device="CPU", arch="x86_64")).isel_matcher, IselContext(x), bottom_up=True)

  def test_call_arguments_are_storage(self):
    a = UOp.variable("a", 0, 0, dtypes.int32)
    for u in self.isel_rewrite((a + UOp.cconst(1, dtypes.int32)) * UOp.cconst(2, dtypes.int32)).toposort():
      if u.op is Ops.CALL: self.assertTrue(all(s.op is not Ops.LOAD for s in u.src_without_body))

  def _check_op(self, dt_op, expr):
    nargs = expr.__code__.co_argcount
    for dt,op in dt_op:
      with self.subTest(dtype=dt):
        v = [UOp.variable(str(i), 0, 0, dt) for i in range(nargs)]
        n = self.isel_rewrite(expr(*v))
        self.assertIs(self.selected_ins(n).arg[0], op)

  def test_cmove(self):
    a = UOp.variable("a", 0, 0, dtypes.int32)
    b = UOp.variable("b", 0, 0, dtypes.int32)
    c = (a < b).where(a, b)
    d = a.alu(Ops.CMPNE, b).where(a, b)
    f = c + d
    n = self.selected_call(self.isel_rewrite(f))
    cmovs = [self.selected_call(s) for s in n.src[2:]]
    self.assertTrue(all(c.body.arg[0] is op for c,op in zip(cmovs, (X86Ops.CMOVL, X86Ops.CMOVNE))))
    # both comparisons become the same instruction
    self.assertTrue(cmovs[0].src[-1] == cmovs[1].src[-1] and cmovs[0].src[-1].body.arg[0] is X86Ops.CMP)

  def test_vinsertps(self):
    a = UOp.variable("a", 0, 0, dtypes.float32)
    b = UOp.variable("b", 0, 0, dtypes.float32)
    c = UOp.variable("c", 0, 0, dtypes.float32)
    d = UOp.variable("e", 0, 0, dtypes.float32)

    valid = [UOp.stack(lane(a, 0), lane(b, 1), lane(a, 2), lane(b, 3)),
             UOp.stack(lane(a, 3), lane(b, 2), lane(c, 1), d)]
    for shuf in valid: self.assertIs(self.selected_ins(self.isel_rewrite(shuf)).arg[0], X86Ops.VINSERTPS)

  # complex address is [base + index*scale + displacement]
  def test_complex_address(self):
    a = UOp.variable("a", 0, 0, dtypes.int32)
    load = UOp.param(0, dtypes.int32, 16).index(a + UOp.cconst(1, dtypes.int32)).load()
    n = self.selected_call(self.isel_rewrite(load))
    # displacement is the constant in "a" scaled to the buffer element size, dtype is int8 when the value fits otherwise int32
    disp = n.src[1+self.selected_ins(n).src[2].arg.slot]
    self.assertTrue(disp.dtype is dtypes.int8 and disp.src[0].op is Ops.CONST and disp.src[0].val == 4)

  @Context(SPEC=2, NOOPT=1)
  def test_register_store_is_effect(self):
    to_program(Tensor.empty(16, 16).sum(1).schedule_linear().src[-1].src[0], X86Renderer(Target(device="CPU", arch="x86_64")))

if __name__ == "__main__":
  unittest.main()
