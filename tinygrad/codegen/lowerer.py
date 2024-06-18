import functools
from typing import List, Tuple
from tinygrad.codegen.kernel import Kernel
from tinygrad.codegen.linearizer import get_grouped_dims
from tinygrad.codegen.uops import UOp, UOpGraph, UOps
from tinygrad.dtype import PtrDType, dtypes
from tinygrad.helpers import colored, getenv, to_function_name
from tinygrad.ops import BufferOps, LazyOp, MemBuffer
from tinygrad.renderer import Program
from tinygrad.shape.shapetracker import ShapeTracker
from tinygrad.shape.symbolic import Variable

# TODO: this needs to be replaced, there shouldn't be variables in the shapetracker
from tinygrad.shape.symbolic import Variable, NumNode, SumNode, MulNode, DivNode, ModNode, LtNode, AndNode
render_ops = {
  NumNode: lambda self, ops, ctx: UOp.const(dtypes.int, self.b),
  MulNode: lambda self, ops, ctx: self.a.render(ops, ctx)*self.b,
  DivNode: lambda self, ops, ctx: self.a.render(ops, ctx)//self.b,
  ModNode: lambda self, ops, ctx: self.a.render(ops, ctx)%self.b,
  LtNode: lambda self, ops, ctx: self.a.render(ops, ctx).lt(self.b),
  Variable: lambda self, ops, ctx: ctx[self] if self in ctx else UOp(UOps.DEFINE_VAR, dtypes.int32, (), self),
  SumNode: lambda self,ops,ctx: functools.reduce(lambda a,b: a+b.render(ops, ctx), self.nodes[1:], self.nodes[0].render(ops,ctx)),
  AndNode: lambda self,ops,ctx: functools.reduce(lambda a,b: a*b.render(ops, ctx), self.nodes[1:], self.nodes[0].render(ops,ctx)) }
def variable_to_uop(x) -> UOp:
  if isinstance(x, int): return UOp.const(dtypes.int32, x)
  return x.render(render_ops)
def st_to_uops(st:ShapeTracker, idxs:List[UOp]) -> Tuple[UOp, UOp]:
  fake_idxs = [Variable(f"idx{i}", 0, s-1) for i,s in enumerate(st.shape)]
  idx, valid = st.expr_idxs(fake_idxs)
  ctx = dict(zip(fake_idxs, idxs))
  return idx.render(render_ops, ctx), valid.render(render_ops, ctx)

class Lowerer(Kernel):
  def to_uop(self, x:LazyOp) -> UOp:
    if x.op in BufferOps:
      idx, _ = st_to_uops(x.arg.st, self.idxs)
      # ConstBuffer
      if x.op is BufferOps.CONST: return UOp(UOps.CONST, x.arg.dtype, (), x.arg.val)
      # MemBuffer (global and TODO: local)
      assert isinstance(x.arg, MemBuffer)
      src = UOp(UOps.DEFINE_GLOBAL, PtrDType((buf:=x.arg).dtype), (), (self.bufs.index(buf), buf in self.outbufs))
      if x.op is BufferOps.LOAD: return UOp(UOps.LOAD, buf.dtype, (src, idx, ))
      return UOp(UOps.STORE, buf.dtype, (src, idx, self.to_uop(x.src[0])))
    src = tuple(self.to_uop(s) for s in x.src)
    return UOp.alu(x.op, *src)

  def linearize(self):
    # kernel name (before late upcast)
    self.name = ("r" if self.reduceop else ("C" if all(x.op in BufferOps for x in self.lazyops) else "E")) + \
                 (f"{len(self.outbufs)}_" if len(self.outbufs) > 1 else "_") + \
                 colored('_', 'BLACK').join([colored(str(x), c) for x,c in zip(self.full_shape, self.colors())])

    # define indexes
    self.idxs: List[UOp] = []
    gl_dims = self.full_shape[:self.first_reduce+self.group_for_reduces]
    _, loop_global_idxs, self.global_size = get_grouped_dims("idx" if self.dont_use_locals else "gidx", 0, gl_dims[:self.global_dims],
                                                                       self.opts.global_max, self.opts.has_local)
    _, loop_local_idxs, self.local_size = get_grouped_dims("lidx", self.global_dims, gl_dims[self.global_dims:],
                                                                    self.opts.local_max if self.opts.has_local else (), False)
    if self.opts.has_local:
      grouped_dims_idxs = loop_global_idxs+(loop_local_idxs if not self.dont_use_locals else [])
      self.idxs.extend(UOp(UOps.SPECIAL, dtypes.int32, (), (i, x.expr, x.max+1)) for i,x in enumerate(grouped_dims_idxs))
    else: raise Exception("todo!")

    # lower AST
    self.uops = UOpGraph(list(map(self.to_uop, self.ast)))
    return self

  def to_program(self) -> Program:
    self.linearize()
    src = self.opts.render(to_function_name(self.name), self.uops)
    if getenv("PRINT_KERNEL"): print(src)
    return Program(self.name, src, self.opts.device, self.global_size, self.local_size, self.uops, 0, 0)
