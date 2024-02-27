from collections.abc import Iterable
from panic import panic
import unittest, math, functools
import numpy as np
from dataclasses import dataclass
from graphlib import TopologicalSorter
from typing import Any, Dict, List, Optional, Tuple, Union, cast
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
  def __call__(self, rawbufs, var_vals, wait=False, jit=False):
    assert self.compiler
    blueprint = Blueprint(self.ast)
    lin = MiniLinearizer(self.ast, blueprint.launch_idxs)
    lin.linearize()
    code = self.compiler.render("new_linearizer", lin.uops)
    if DEBUG >= 4: print(code)
    lib = self.compiler.compile(code)
    prg = self.device.runtime("new_linearizer", lib)
    global_size, local_size = blueprint.launch_dims
    prg(*[x._buf for x in rawbufs], global_size=global_size, local_size=local_size)

Kernel = Tuple[Tuple[LazyOp,...], List[Buffer]]
class Graph:
  def __init__(self, bufs:TopologicalSorter) -> None:
    self.bufs = bufs
    # You can use intermediate buffers, be they local or global, to do less compute.
    self.global_bufs: Dict[Buffer,MemBuffer] = {}
    self.asts: List[Tuple[LazyOp,...]] = []
    self.ops_map: Dict[LazyBuffer,LazyOp] = {}

  def create_kernels(self) -> Iterable[Kernel]:
    ast: List[LazyOp] = []
    for lb in self.bufs.static_order():
      self.ops_map[lb] = self.create_lazyop(lb)
      if lb.realized is not None and lb.op not in LoadOps: ast.append(LazyOp(BufferOps.STORE, (self.ops_map[lb], ), self.create_membuffer(lb)))
    self.asts.append(tuple(ast))
    return [(ast, list(self.global_bufs.keys())) for ast in self.asts]

  def create_lazyop(self, lb:LazyBuffer) -> LazyOp:
    if lb.op == LoadOps.COPY: return LazyOp(BufferOps.LOAD, (), self.create_membuffer(lb))
    assert lb.op is not None
    return LazyOp(lb.op, src=tuple(self.ops_map[src] for src in lb.base.srcs))

  def create_membuffer(self, lb:LazyBuffer) -> MemBuffer:
    assert (buf:=lb.realized) is not None
    if buf not in self.global_bufs: self.global_bufs[buf] = MemBuffer(len(self.global_bufs.keys()), lb.dtype, lb.st)
    return self.global_bufs[buf]

@dataclass(frozen=True)
class MiniScheduleItem:
  runner: JITRunner
  rawbufs: List[Buffer]

# NOTE: currently reduce splitting is done in lazy.py and it shouldn't be
class Scheduler:
  def __init__(self) -> None:
    self.sched: List[MiniScheduleItem] = []
    self.bufs: TopologicalSorter[LazyBuffer] = TopologicalSorter()

  def create_schedule(self, lb:LazyBuffer):
    src = self._recursive_lazybuffer(lb)
    src.realized = Buffer(lb.device, lb.size, lb.dtype)
    graph = Graph(self.bufs)
    kernels = graph.create_kernels()
    for ast, rawbufs in kernels: self.sched.append(MiniScheduleItem(ASTRunner(ast), rawbufs))

  def _recursive_lazybuffer(self, lb:LazyBuffer) -> LazyBuffer:
    if lb.base.op == LoadOps.COPY:
      host_buf = cast(Buffer,lb.base.srcs[0].realized)
      device_buf = Buffer(lb.device, lb.size, lb.dtype)
      self.sched.append(MiniScheduleItem(BufferCopy(), [device_buf, host_buf]))
      lb.base.realized = device_buf
      return lb

    srcs = [self._recursive_lazybuffer(buf) for buf in lb.base.srcs]
    self.bufs.add(lb, *srcs)
    return lb

Dim3 = Tuple[int,int,int]
class Blueprint:
  def __init__(self, ast):
    self.ast = ast
    self.shape = ast[-1].arg.st.shape

  @property
  def launch_dims(self) -> Tuple[Dim3,Dim3]:
    global_size,local_size = [1,1,1],[1,1,1]
    for i, dim in enumerate(self.shape):
      global_size[i] = dim
    return cast(Dim3,tuple(global_size)), cast(Dim3,tuple(local_size))

  @property
  def launch_idxs(self) -> List[Variable]:
    idxs = []
    global_size,_ = self.launch_dims
    for i, dim in enumerate(global_size):
      if dim != 1: idxs.append(Variable(f"gidx{i}", 0, dim-1))
    return idxs

class MiniLinearizer:
  def __init__(self, ast, launch_idxs:List[Variable]):
    self.ast = ast
    self.uops: List[UOp] = []

    self.buf_pointers: Dict[int, UOp] = {}
    self.loaded_bufs: Dict[Tuple[MemBuffer,UOp], UOp] = {}
    self.alu_cache: Dict[Any, UOp] = {}

    self.launch_idxs = launch_idxs
    self.idx_map: Dict[str, UOp] = {i.expr:self.uop(UOps.SPECIAL, dtype=dtypes.int, arg=(i.min,i.expr,i.max+1)) for i in self.launch_idxs}

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
    if isinstance(n,Variable): return self.idx_map[n.expr]
    if isinstance(n,SumNode):
      return functools.reduce(lambda a,b: self.uop(UOps.ALU, dtypes.int, (self._lower_sym(a),self._lower_sym(b)), BinaryOps.ADD), n.nodes[1:], self._lower_sym(n.nodes[0]))
    if isinstance(n,MulNode):
      return self.uop(UOps.ALU, dtypes.int, (self._lower_sym(n.a),self._lower_sym(n.b)), BinaryOps.MUL)
    if isinstance(n,int): return self.const(n,dtypes.int)
    if isinstance(n,NumNode): return self.const(n.b,dtypes.int)
    raise Exception(f"TODO sym {type(n)}")

  def _lower_op(self, op:LazyOp) -> UOp:
    if op.op == BufferOps.LOAD: return self.load_buf(op.arg)
    if op.op == BufferOps.CONST: return self.const(op.arg.val, op.arg.dtype)
    if op.op in ReduceOps:
      buf: MemBuffer = op.src[0].arg
      acc = self.uop(UOps.DEFINE_ACC, dtype=buf.dtype, arg=self.get_reduce_acc(buf.dtype,op.op))
      reduce_idxs = cast(List[Variable],[Variable(f"ridx{i}",0,dim-1) for i,dim in enumerate(buf.st.shape[len(self.launch_idxs):])])
      for n in reduce_idxs: self.idx_map[n.expr] = self.uop(UOps.LOOP, dtypes.int, (self.const(n.min),self.const(n.max+1)))
      src = self.load_buf(buf, reduce_idxs)
      alu = self.uop(UOps.ALU, dtype=src.dtype, vin=(acc,src), arg=BinaryOps.ADD if op.op == ReduceOps.SUM else BinaryOps.MAX)
      ret = self.uop(UOps.PHI, dtype=src.dtype, vin=(acc,alu,*(loops:=[self.idx_map[n.expr] for n in reduce_idxs])))
      for l in loops: self.uop(UOps.ENDLOOP, vin=(l,))
      return ret
    srcs = tuple(self._lower_op(src) for src in op.src)
    ret = self.uop(UOps.ALU, vin=srcs, dtype=srcs[-1].dtype, arg=op.op)
    key = (ret.vin, ret.arg)
    if key in self.alu_cache: return self.alu_cache[key]
    self.alu_cache[key] = ret
    return ret

  def load_buf(self, buf:MemBuffer, reduce_idxs:List[Variable]=[]) -> UOp:
    if buf not in self.buf_pointers: self.buf_pointers[buf.idx] = self.uop(UOps.DEFINE_GLOBAL, dtype=PtrDType(buf.dtype), arg=f"data{buf.idx}")
    if (buf,idx:=self.buf_idx(buf, reduce_idxs)) in self.loaded_bufs: return self.loaded_bufs[buf,idx]
    u = self.uop(UOps.LOAD, dtype=buf.dtype, vin=(self.buf_pointers[buf.idx],idx))
    self.loaded_bufs[buf,idx] = u
    return u

  def buf_idx(self, buf:MemBuffer, reduce_idxs:List[Variable]=[]):
    if buf.st.shape == (1,): return self.const(0)
    return self._lower_sym(buf.st.expr_idxs(self.launch_idxs+reduce_idxs)[0])

  def linearize(self) -> List[UOp]:
    for op in self.ast:
      assert op.op == BufferOps.STORE and isinstance(buf:=op.arg, MemBuffer)
      ret = self._lower_op(op.src[0])
      ptr = self.uop(UOps.DEFINE_GLOBAL, dtype=PtrDType(buf.dtype), arg=f"data{buf.idx}")
      self.uop(UOps.STORE, dtype=ret.dtype, vin=(ptr,self.buf_idx(buf),ret))
    return self.uops

class TestLinearizer2(unittest.TestCase):
  assert getenv("LINEARIZER2"), "please use LINEARIZER2=1 to render the bufs correctly in cstyle"
  def _new_realize(self, x):
    scheduler = Scheduler()
    scheduler.create_schedule(x.lazydata)
    for si in scheduler.sched: si.runner(si.rawbufs, var_vals={})
    ret = np.frombuffer(x.lazydata.base.realized.as_buffer(), dtype=x.dtype.np)
    x.lazydata.base.realized = None # reset values for the comparison
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

  def test_globals(self):
    x = Tensor([1,2,3,4]) + Tensor([1,2,3,4])
    outputs = [x]
    ret = self._new_realize(outputs)
    expected = [x.numpy() for x in outputs]
    np.testing.assert_equal(ret, expected)

  def test_batchmean(self):
    batch_mean = Tensor(np.random.randn(2, 4, 3, 3), dtype=dtypes.float).mean(axis=(0,2,3))
    outputs = [batch_mean]
    ret = self._new_realize(outputs)
    expected = [x.numpy() for x in outputs]
    np.testing.assert_equal(ret, expected)

  def test_tiny(self):
    x = Tensor([1]) + Tensor([2])
    self._new_realize(x)

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
