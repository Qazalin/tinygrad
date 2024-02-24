from panic import panic
import unittest, math, functools
import numpy as np
from dataclasses import dataclass
from graphlib import TopologicalSorter
from typing import Any, Dict, List, Optional, Tuple, Union, cast
from tinygrad.codegen.linearizer import expand_node
from tinygrad.codegen.uops import UOp, UOps
from tinygrad.device import Buffer, BufferCopy, Device, JITRunner
from tinygrad.dtype import DType, PtrDType, dtypes
from tinygrad.lazy import LazyBuffer
from tinygrad.ops import BinaryOps, BufferOps, ConstBuffer, LazyOp, LoadOps, MemBuffer, Op, ReduceOps
from tinygrad.shape.symbolic import MulNode, Node, NumNode, SumNode, Variable
from tinygrad.tensor import Tensor
from tinygrad.helpers import DEBUG, getenv

class ASTRunner(JITRunner):
  def __init__(self, ast: Tuple[LazyOp,...]):
    self.ast = ast
    self.device, self.compiler = Device[Device.DEFAULT], Device[Device.DEFAULT].compiler
    super().__init__()
  def __call__(self, rawbufs: List[Buffer], var_vals, wait=False, jit=False):
    assert self.compiler
    lin = MiniLinearizer(self.ast)
    lin.linearize()
    code = self.compiler.render("new_linearizer", lin.uops)
    if DEBUG >= 4: print(code)
    lib = self.compiler.compile(code)
    prg = self.device.runtime("new_linearizer", lib)
    prg(*[x._buf for x in rawbufs])

@dataclass(frozen=True)
class MiniScheduleItem:
  runner: JITRunner
  rawbufs: List[Buffer]

class Scheduler:
  def __init__(self) -> None:
    self.sched: List[MiniScheduleItem] = []
    self.rawbufs: List[Buffer] = []
    self.copy_cache: Dict[Buffer, int] = {}
    self.ast: TopologicalSorter = TopologicalSorter()

  def store_output(self, lb: LazyBuffer, src:LazyOp):
    op = LazyOp(BufferOps.STORE, (src, ), MemBuffer(len(self.rawbufs), lb.dtype, lb.st.simplify().unbind()[0]))
    store_buf = Buffer(lb.device, lb.size, lb.dtype)
    lb.base.realized = store_buf
    self.rawbufs.append(store_buf)
    self.ast.add(op, src)

  def create_schedule(self, lazy_buffers:List[LazyBuffer]):
    for lb in lazy_buffers:
      src = self._recursive_lazyop(lb, out_shape=lb.shape)
      self.store_output(lb, src)
    self.sched.append(MiniScheduleItem(ASTRunner(tuple(self.ast.static_order())), self.rawbufs))

  def _recursive_lazyop(self, lb:LazyBuffer, out_shape) -> LazyOp:
    # LoadOps have special sources
    if lb.base.op == LoadOps.CONST: # Consts are always generated
      return LazyOp(BufferOps.CONST, src=(), arg=ConstBuffer(val=lb.base.arg, dtype=lb.base.dtype, st=lb.st.simplify().unbind()[0]))
    if lb.base.op == LoadOps.COPY:
      host_buf = cast(Buffer,lb.base.srcs[0].realized)

      if host_buf in self.copy_cache:
        idx = self.copy_cache[host_buf]
        device_buf = self.rawbufs[idx]
      else:
        device_buf = Buffer(lb.device, lb.size, lb.dtype)
        self.sched.append(MiniScheduleItem(BufferCopy(), [device_buf, host_buf]))
        idx = len(self.rawbufs)
        self.copy_cache[host_buf] = len(self.rawbufs)
        self.rawbufs.append(device_buf)

      unbound_st, st_var_vals = lb.st.simplify().unbind()
      assert st_var_vals == {}, "variables not supported yet"
      return LazyOp(BufferOps.LOAD, (), MemBuffer(idx, lb.dtype, unbound_st))

    srcs = tuple([self._recursive_lazyop(src, out_shape) for src in lb.base.srcs])
    op = LazyOp(cast(Op,lb.base.op), src=srcs)
    self.ast.add(op, *srcs)
    return op


class MiniLinearizer:
  def __init__(self, ast):
    self.ast = ast
    self.uops: List[UOp] = []
    self.buf_pointers: Dict[int, UOp] = {}
    self.loaded_bufs: Dict[Tuple[MemBuffer,UOp], UOp] = {}
    self.loops_map: Dict[str, UOp] = {}
    self.alu_cache: Dict[Any, UOp] = {}

  def const(self, val, dtype=dtypes.int):
    existing = [u for u in self.uops if u.uop == UOps.CONST and u.arg == val]
    if len(existing) != 0: return existing[0]
    return self.uop(UOps.CONST, dtype=dtype, arg=val)

  def uop(self, u:UOps, dtype:Optional[DType]=None, vin:Tuple[UOp,...]=(), arg=()):
    uop = UOp(u, dtype, vin, arg)
    self.uops.append(uop)
    return uop

  def get_reduce_acc(self, dtype, op):
    if op == ReduceOps.SUM: return 0.0 if dtypes.is_float(dtype) else 0
    if op == ReduceOps.MAX:
      if dtypes.is_int(dtype): return 0 if dtypes.is_unsigned(dtype) else -2**(dtype.itemsize*8-1)
      return -math.inf if dtypes.is_float(dtype) else False

  def _lower_sym(self, n:Union[UOp,Node,int]) -> UOp:
    if isinstance(n,UOp): return n
    if isinstance(n,Variable):
      self.loops_map[n.expr] = self.uop(UOps.LOOP, dtypes.int, (self.const(n.min),self.const(n.max+1)))
      return self.loops_map[n.expr]
    if isinstance(n,SumNode):
      return functools.reduce(lambda a,b: self.uop(UOps.ALU, dtypes.int, (self._lower_sym(a),self._lower_sym(b)), BinaryOps.ADD), n.nodes[1:], self._lower_sym(n.nodes[0]))
    if isinstance(n,MulNode):
      return self.uop(UOps.ALU, dtypes.int, (self._lower_sym(n.a),self._lower_sym(n.b)), BinaryOps.MUL)
    if isinstance(n,int): return self.const(n,dtypes.int)
    raise Exception(f"TODO sym {type(n)}")

  def _lower_op(self, op:LazyOp) -> UOp:
    if op.op == BufferOps.LOAD: return self.load_buf(op.arg, [])
    if op.op == BufferOps.CONST: return self.const(op.arg.val, op.arg.dtype)
    if op.op in ReduceOps:
      buf: MemBuffer = op.src[0].arg
      acc = self.uop(UOps.DEFINE_ACC, dtype=buf.dtype, arg=self.get_reduce_acc(buf.dtype,op.op))
      reduce_idxs = cast(List[Variable],[Variable(f"ridx{i}",0,dim-1) for i,dim in enumerate(buf.st.shape)])
      src = self.load_buf(buf, reduce_idxs)
      alu = self.uop(UOps.ALU, dtype=src.dtype, vin=(acc,src), arg=BinaryOps.ADD if op.op == ReduceOps.SUM else BinaryOps.MAX)
      ret = self.uop(UOps.PHI, dtype=src.dtype, vin=(acc,alu,*(loops:=[self.loops_map[n.expr] for n in reduce_idxs])))
      for l in loops: self.uop(UOps.ENDLOOP, vin=(l,))
      return ret
    srcs = tuple(self._lower_op(src) for src in op.src)
    ret = self.uop(UOps.ALU, vin=srcs, dtype=srcs[-1].dtype, arg=op.op)
    key = (ret.vin, ret.arg)
    if key in self.alu_cache: return self.alu_cache[key]
    self.alu_cache[key] = ret
    return ret

  def load_buf(self, buf:MemBuffer, idxs:List[Variable]) -> UOp:
    if buf.st.shape == (1,): idx = self.const(0)
    else: idx = self._lower_sym(buf.st.expr_idxs(idxs)[0])
    if (buf,idx) in self.loaded_bufs: return self.loaded_bufs[buf,idx]
    u = self.uop(UOps.LOAD, dtype=buf.dtype, vin=(self.buf_pointers[buf.idx],idx))
    self.loaded_bufs[buf,idx] = u
    return u

  def linearize(self) -> List[UOp]:
    for op in self.ast:
      if not (op.op in BufferOps and isinstance(buf:=op.arg, MemBuffer)): continue
      if buf not in self.buf_pointers:
        self.buf_pointers[buf.idx] = self.uop(UOps.DEFINE_GLOBAL, dtype=PtrDType(buf.dtype), arg=f"data{buf.idx}")
      if op.op == BufferOps.STORE:
        ret = self._lower_op(op.src[0])
        self.uop(UOps.STORE, dtype=ret.dtype, vin=(self.buf_pointers[buf.idx],self.const(0),ret))
    return self.uops

class TestLinearizer2(unittest.TestCase):
  assert getenv("LINEARIZER2"), "please use LINEARIZER2=1 to render the bufs correctly in cstyle"
  def _new_realize(self, vals):
    scheduler = Scheduler()
    scheduler.create_schedule([x.lazydata for x in vals])
    for si in scheduler.sched:
      si.runner(si.rawbufs, var_vals={})
    ret = [np.frombuffer(x.lazydata.base.realized.as_buffer(), dtype=x.dtype.np).reshape(x.shape) for x in vals]
    for x in vals: x.lazydata.base.realized = None # reset values for the comparison
    return ret

  def test_multi_output_simple(self):
    a = Tensor([2])
    b = Tensor([6])
    out0 = a - b
    out1 = a * b
    outputs = [out0, out1]

    ret = self._new_realize(outputs)
    expected = [x.numpy() for x in outputs]
    np.testing.assert_equal(ret, expected)

  def test_multi_output_multi_reduce(self):
    a = Tensor([1,2,3,4])
    out0 = a.sum()
    out2 = a.max()
    outputs = [out0, out2]

    ret = self._new_realize(outputs)
    expected = [x.numpy() for x in outputs]
    np.testing.assert_equal(ret, expected)

  def test_nested_reduce(self):
    x = Tensor([[1,2,3],[4,5,6]]).sum()
    y = Tensor([[2,3,5],[4,5,4]]).sum()
    outputs = [x, y]
    ret = self._new_realize(outputs)
    expected = [x.numpy() for x in outputs]
    np.testing.assert_equal(ret, expected)

  def test_tiny(self):
    x = Tensor([1,2,3,4]).sum()
    outputs = [x]
    ret = self._new_realize(outputs)
    expected = [x.numpy() for x in outputs]
    np.testing.assert_equal(ret, expected)

  @unittest.skip("TODO - needs a good scheduler infra")
  def test_batchnorm(self):
    x_data = np.random.randn(2, 4, 3, 3)
    weight_data, bias_data = np.ones(4), np.zeros(4)
    x, weight, bias = [Tensor(data, dtype=dtypes.float) for data in [x_data,weight_data,bias_data]]
    batch_mean = x.mean(axis=(0,2,3))
    y = (x - batch_mean.reshape(shape=[1, -1, 1, 1]))
    batch_var = (y*y).mean(axis=(0,2,3))
    batch_invstd = batch_var.add(1e-5).pow(-0.5)
    out = x.batchnorm(weight, bias, batch_mean, batch_invstd)

    scheduler = Scheduler()
    scheduler.create_schedule([cast(LazyBuffer,out.lazydata)])
    """
    #ast = scheduler.sched[-1].runner.ast
    #for si in scheduler.sched: print(si)
    for op in ast:
      if op.op == BufferOps.LOAD:
        print(op.op)
    print(len(scheduler.rawbufs))
    """
