import sys
from collections import defaultdict, deque
from dataclasses import dataclass
from typing import Tuple, List, Dict, Optional, Set, DefaultDict
from tinygrad.ops import LoadOps, ScheduleItem, BufferOps, LazyOp, ReduceOps, ConstBuffer, MemBuffer, BinaryOps, UnaryOps
from tinygrad.features.graph import log_lazybuffer, realized_lazybuffer
from tinygrad.helpers import GRAPH, DEBUG, GlobalCounters, merge_dicts, prod, dedup, all_int
from tinygrad.shape.symbolic import Variable
from tinygrad.dtype import ImageDType, dtypes
from tinygrad.lazy import LazyBuffer
from tinygrad.shape.shapetracker import ShapeTracker

# creation can recurse a lot
sys.setrecursionlimit(10000)

# recursively create a lazyop
def _recursive_lazyop(buf:LazyBuffer, membufs:List[LazyBuffer], var_vals:Dict[Variable, int], st:ShapeTracker,
                      realizes:Dict[LazyBuffer, None], cache, first=True, assign_to:Optional[LazyBuffer]=None, assign_idx:Optional[int]=None) -> LazyOp:
  if (buf, st) in cache: return cache[(buf, st)]
  if buf != buf.base:
    st = buf.st + st
    buf = buf.base
  # all buffers here are base now
  assert buf.op is not None

  # consts are always fused and generated
  if buf.op is LoadOps.CONST:
    unbound_st, st_var_vals = st.simplify().unbind()
    var_vals.update(st_var_vals)
    return LazyOp(BufferOps.CONST, (), ConstBuffer(buf.arg, buf.dtype, unbound_st))

  # if we aren't fusing it, it's a load and we add it to the inputs
  if buf.realized or (buf in realizes and not first):
    unbound_st, st_var_vals = st.simplify().unbind()
    var_vals.update(st_var_vals)
    if assign_to is not None and buf is assign_to:
      assert assign_idx is not None
      if not unbound_st.contiguous:
        # we also allow masked views. if it has a single view and it's equal when you shrink a contig, it's fine
        if not (len(unbound_st.views) == 1 and unbound_st.views[0].mask is not None and
            ShapeTracker.from_shape(unbound_st.shape).shrink(unbound_st.views[0].mask) == unbound_st.shrink(unbound_st.views[0].mask)):
          raise RuntimeError(f"must be contiguous for assign {unbound_st}")
      return LazyOp(BufferOps.LOAD, (), MemBuffer(assign_idx, buf.dtype, unbound_st))
    if buf not in membufs: membufs.append(buf)
    return LazyOp(BufferOps.LOAD, (), MemBuffer(membufs.index(buf), buf.dtype, unbound_st))

  # if a CONTIGUOUS or ASSIGN made it all the way here, just skip it
  if buf.op is LoadOps.CONTIGUOUS:
    assert first
    return _recursive_lazyop(buf.srcs[0], membufs, var_vals, st, realizes, cache, False)
  if buf.op is LoadOps.ASSIGN:
    assert first
    assert buf.srcs[1].base is buf.srcs[1], "assign must be to base"
    assert buf.srcs[1].realized is not None, f"assign must be already realized to schedule {buf.srcs[1]}"
    return _recursive_lazyop(buf.srcs[0], membufs, var_vals, st, realizes, cache, False, assign_to=buf.srcs[1], assign_idx=membufs.index(buf))

  # if it's a reduce, we have to change the shapetracker
  if buf.op in ReduceOps:
    assert st.contiguous, "ReduceOps late fusion must be contiguous"
    st = ShapeTracker.from_shape(buf.srcs[0].shape)

  # otherwise we fuse it like normal
  cache[(buf, st)] = ret = \
    LazyOp(buf.op, tuple(_recursive_lazyop(x, membufs, var_vals, st, realizes, cache, False, assign_to, assign_idx) for x in buf.srcs), buf.arg)
  return ret

def _schedule_group(outputs:List[LazyBuffer], realizes:Dict[LazyBuffer, None]) -> ScheduleItem:
  var_vals = merge_dicts([out.st.var_vals.copy() for out in outputs])
  if outputs[0].op in {LoadOps.CUSTOM, LoadOps.SYNC, LoadOps.COPY, LoadOps.EMPTY}:
    ast, inputs = [LazyOp(outputs[0].op, (), outputs[0].arg)], outputs[0].srcs
  else:
    membufs, ast = [*outputs], []
    for i, out in enumerate(outputs):
      output_st = ShapeTracker.from_shape(out.shape)
      op = _recursive_lazyop(out, membufs, var_vals, output_st, realizes, {})
      ast.append(LazyOp(BufferOps.STORE, (op,), MemBuffer(i, out.dtype, output_st.simplify().unbind()[0])))
    inputs = tuple(x for x in membufs if x not in outputs)
  return ScheduleItem(tuple(ast), tuple(x.buffer for x in outputs), tuple(x.buffer for x in inputs), var_vals)

# recursively search the entire graph for all LazyBuffers, insert realizes after expands
def _recurse_lb(buf:LazyBuffer, realizes:Set[LazyBuffer], allbufs:Dict[LazyBuffer, None],
                simple_pads:Set[LazyBuffer], children:DefaultDict[LazyBuffer, Dict[LazyBuffer, None]], scheduled=False):
  if buf in allbufs or buf.base.realized: return
  if GRAPH: log_lazybuffer(buf, scheduled)
  if isinstance(buf.dtype, ImageDType) and (prod(buf.shape) != prod(buf.dtype.shape) or
                                            not any(buf.shape[x]%4 == 0 for x in buf.st.unit_stride_axes())):
    if DEBUG >= 3: print(f"forcing image {buf.dtype} with shape {buf.shape} to float32")
    buf.dtype = dtypes.float32  # NOTE: this is what makes the dtype above not match
    # hack the underlying buffer too
    if buf.base is buf:
      assert not hasattr(buf.buffer, '_buf'), "can't fixup allocated buffer"
      buf.buffer.dtype = dtypes.float32
      buf.buffer.options = None
  if buf.base != buf:
    # realize all places where the buffer is expanded
    if prod(buf.base.st.shape) < prod(buf.st.shape):
      if len(buf.st.views) == 1 and buf.st.views[-1].mask and all_int(buf.base.st.shape) and \
          prod(buf.base.st.shape) >= prod([y-x for x,y in buf.st.views[-1].mask]):
        simple_pads.add(buf.base)
      else:
        realizes.add(buf.base)
    return _recurse_lb(buf.base, realizes, allbufs, simple_pads, children)
  if buf.forced_realize: realizes.add(buf)
  allbufs[buf] = None
  if buf.op in LoadOps: realizes.add(buf.base)
  if buf.op is LoadOps.COPY:
    assert buf.srcs[0].st.contiguous and buf.srcs[0].size == buf.srcs[0].base.size, "can only copy contig"
    realizes.add(buf.srcs[0].base)
  for x in buf.srcs:
    children[x.base][buf] = None
    _recurse_lb(x, realizes, allbufs, simple_pads, children)

UNSAFE_PAD_OPS = {BinaryOps.DIV, BinaryOps.CMPLT, BinaryOps.CMPEQ, UnaryOps.LOG2, UnaryOps.EXP2}
def _is_padding_okay(buf:LazyBuffer, realizes:Set[LazyBuffer]) -> bool:
  if buf in realizes or buf.realized: return True
  # NOTE: this broke to_image_idx and coder with JIT
  if buf.op in UNSAFE_PAD_OPS: return False
  return all(_is_padding_okay(x.base, realizes) for x in buf.srcs)

def create_schedule(outs:List[LazyBuffer], seen:Optional[Set[LazyBuffer]]=None) -> List[ScheduleItem]:
  # recursively create a graph of all the lazybuffers
  graph: DefaultDict[LazyBuffer, List[LazyBuffer]] = defaultdict(list)
  in_degree: DefaultDict[LazyBuffer, int] = defaultdict(int)
  for out in outs:
    for x in out.srcs:
      graph[x.base].append(out.base)
      in_degree[out.base] += 1

  # toposort the entire graph
  queue = deque(buf for buf in graph if in_degree[buf] == 0)
  sorted_bufs: List[LazyBuffer] = []
  while queue:
    sorted_bufs.append(buf:=queue.pop())
    for child in graph[buf]:
      in_degree[child] -= 1
      if in_degree[child] == 0: queue.append(child)

  # find points of realizes
  realizes: Dict[LazyBuffer, None] = {}
  for buf in graph:
    if buf.realized: continue
    if buf.op in LoadOps or buf.forced_realize or buf in outs: realizes[buf] = None
    if buf.op is LoadOps.COPY:
      assert buf.srcs[0].st.contiguous and buf.srcs[0].size == buf.srcs[0].base.size, "can only copy contig"
      if not buf.srcs[0].realized: realizes[buf.srcs[0].base] = None

  # group the realizes
  out_groups: DefaultDict[Tuple, List[LazyBuffer]] = defaultdict(list)
  for out in realizes:
    if (out.op in LoadOps and out.op is not LoadOps.ASSIGN): key:Tuple = (out,)
    else: key = (out.shape, out.device)
    out_groups[key].append(out)

  # create kernels in a straight line.
  schedule: List[ScheduleItem] = []
  for group in out_groups.values():
    schedule.append(_schedule_group(group, realizes))
    for out in group: del out.srcs # can only schedule once
  return schedule
