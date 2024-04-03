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

# TODO: it's unfortunate this needs to exist, but because of ASSIGN, we have to retain the LazyBuffer structure until post toposort
@dataclass(frozen=True)
class _LBScheduleItem:
  ast: Tuple[LazyOp, ...]
  outputs: Tuple[LazyBuffer, ...]
  inputs: Tuple[LazyBuffer, ...]
  var_vals: Dict[Variable, int]

# recursively create a lazyop
def _recursive_lazyop(buf:LazyBuffer, membufs:List[LazyBuffer], var_vals:Dict[Variable, int], st:ShapeTracker,
                      realizes:Set[LazyBuffer], cache, first=True, assign_to:Optional[LazyBuffer]=None, assign_idx:Optional[int]=None) -> LazyOp:
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

def _schedule_group(outs:Tuple[LazyBuffer,...], realizes:Set[LazyBuffer], reduce_for_op: Dict[LazyBuffer, LazyBuffer]) -> _LBScheduleItem:
  if outs[0].op in {LoadOps.CUSTOM, LoadOps.COPY, LoadOps.EMPTY}:
    return _LBScheduleItem((LazyOp(outs[0].op, (), outs[0].arg),), outs, outs[0].srcs, outs[0].st.var_vals.copy())
  ast: List[LazyOp] = []
  membufs, var_vals = [*outs], merge_dicts([out.st.var_vals.copy() for out in outs])
  for i, out in enumerate(outs):
    output_st = ShapeTracker.from_shape(reduce_for_op[out].shape if out in reduce_for_op else out.shape)
    op = _recursive_lazyop(out, membufs, var_vals, output_st, realizes, cache={})
    ast.append(LazyOp(BufferOps.STORE, (op, ), MemBuffer(i, out.dtype, output_st.simplify().unbind()[0])))
  return _LBScheduleItem(tuple(ast), outs, tuple(membufs[len(outs):]), var_vals)

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

# walk back the LazyBuffer graph to find realized parents
def _gather_parents(out:LazyBuffer, realizes:Set[LazyBuffer], realized_parents:DefaultDict[LazyBuffer, Set[LazyBuffer]]) -> Set[LazyBuffer]:
  def _deepwalk(buf:LazyBuffer):
    if buf.realized or buf.op is LoadOps.CONST: return
    if buf is not out and buf in realizes: return realized_parents[out].add(buf)
    for x in buf.srcs: _deepwalk(x.base)
  if out not in realized_parents: _deepwalk(out)
  return realized_parents[out]

def create_schedule(outs:List[LazyBuffer], seen:Optional[Set[LazyBuffer]]=None) -> List[ScheduleItem]:
  if seen is None: seen = set()

  # start by just realizing the buffers passed in
  realizes: Set[LazyBuffer] = set([x.base for x in outs if not x.base.realized])
  allbufs: Dict[LazyBuffer, None] = {}
  simple_pads: Set[LazyBuffer] = set()
  children: DefaultDict[LazyBuffer, Dict[LazyBuffer, None]] = defaultdict(dict)
  realized_parents: DefaultDict[LazyBuffer, Set[LazyBuffer]] = defaultdict(set)
  for out in outs: _recurse_lb(out.base, realizes, allbufs, simple_pads, children, scheduled=True)

  # check if we have to realize pads
  for p in simple_pads:
    if not _is_padding_okay(p, realizes):
      realizes.add(p)

  # find all reduces, try to cleanly pair with as many contig realized children as possible. Otherwise, force realize the reduce
  reduce_for_op: Dict[LazyBuffer, LazyBuffer] = {}
  for r in allbufs.keys():
    if r != r.base or r.op not in ReduceOps or r in realizes: continue

    # follow the reduce down
    child_set: Dict[LazyBuffer, ShapeTracker] = {r: r.st}
    realized_children: Dict[LazyBuffer, ShapeTracker] = {}
    forced_realize = False
    can_chase = True
    while not forced_realize and len(child_set):
      next_child_set = {}
      for tr,st in child_set.items():
        if tr in realizes:
          realized_children[tr] = st
          # can only reduce contiguous
          # max one reduceop per kernel
          if not st.contiguous or st.size != r.st.size or (tr in reduce_for_op and reduce_for_op[tr] != r):
            can_chase = tr not in reduce_for_op or reduce_for_op[tr] == r
            forced_realize = True
            break
          # can only fuse multi output realized_children wih no self dependencies
          if len(realized_children) > 1:
            for rc in realized_children:
              parents_set = _gather_parents(rc, realizes, realized_parents)
              while parents_set and not forced_realize:
                next_parents_set: Set[LazyBuffer] = set()
                for next_buf in parents_set:
                  if next_buf in realized_children:
                    forced_realize = True
                    break
                  for p in _gather_parents(next_buf, realizes, realized_parents): next_parents_set.add(p)
                  parents_set = next_parents_set
          continue
        for tr_next in children[tr].keys():
          if not tr_next.realized:
            # max one reduceop per kernel
            if tr_next.op in ReduceOps:
              forced_realize = True
              break
            st_childs = dedup([s for s in tr_next.srcs if s.base == tr])
            if len(st_childs) > 1:
              forced_realize = True
              break
            next_child_set[tr_next] = st + st_childs[0].st
      child_set = next_child_set
    if forced_realize:
      tr = r
      if can_chase:
        # can chase this down to contiguous children
        st = tr.st
        while len(children[tr]) == 1:
          tr_next = next(iter(children[tr].keys()))
          st_childs = dedup([s for s in tr_next.srcs if s.base == tr])
          if len(st_childs) > 1: break
          if st.size != st_childs[0].st.size: break
          st = st + st_childs[0].st
          if not st.contiguous or tr_next.op in ReduceOps: break
          tr = tr_next
        reduce_for_op[tr] = r
      realizes.add(tr)
    else: reduce_for_op.update((tr, r) for tr in realized_children)

  # group the realizes into multi output kernels
  output_groups: DefaultDict[Tuple, List[LazyBuffer]] = defaultdict(list)
  for out in realizes:
    if out.realized is not None or out.op is LoadOps.CONST or out in seen: continue
    # multi output reduce pairs
    if out in reduce_for_op: key = (reduce_for_op[out],)
    # single output
    else: key = (out,)
    output_groups[key].append(out)

  # preschedule all buffers in realizes
  prescheduled = {outputs[0]:_schedule_group(tuple(outputs), realizes, reduce_for_op) for outputs in output_groups.values()}
  assign_targets = {x.srcs[1]:x for x in realizes if x.op is LoadOps.ASSIGN and x not in seen and x.realized is None}

  # breadth first ordering
  graph: DefaultDict[LazyBuffer, List[LazyBuffer]] = defaultdict(list)
  in_degree: DefaultDict[LazyBuffer, int] = defaultdict(int)
  for k, si in prescheduled.items():
    for x in si.inputs:
      graph[x].append(k)
      if x in assign_targets:
        graph[k].append(assign_targets[x])
        in_degree[assign_targets[x]] += 1
      if x in prescheduled: in_degree[k] += 1
    for out in si.outputs: del out.srcs  # can only schedule once

  queue = deque(ps for k, ps in prescheduled.items() if in_degree[k] == 0)
  schedule: List[ScheduleItem] = []
  kernel_number = GlobalCounters.kernel_count
  while queue:
    ps = queue.popleft()
    for out in ps.outputs: seen.add(out)
    if GRAPH:
      kernel_number += 1
      for out in ps.outputs: realized_lazybuffer(out, kernel_number)
    schedule.append(ScheduleItem(ps.ast, tuple(x.buffer for x in ps.outputs if x.size != 0),
                                 tuple(x.buffer for x in ps.inputs if x.size != 0), ps.var_vals))
    for x in graph[ps.outputs[0]]:
      in_degree[x] -= 1
      if in_degree[x] == 0: queue.append(prescheduled[x])

  # confirm everything was scheduled correctly
  if not all(degree == 0 for degree in in_degree.values()) or len(prescheduled) != len(schedule):
    raise RuntimeError(f"cycle detected in graph, prescheduled {len(prescheduled)} but only scheduled {len(schedule)}")
  return schedule
