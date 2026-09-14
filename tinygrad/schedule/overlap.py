import functools, heapq
from dataclasses import dataclass
from tinygrad.device import DepsTracker, MultiBuffer
from tinygrad.uop.ops import UOp, Ops, ProgramInfo

@dataclass(frozen=True)
class _Region:
  base: object
  offset: int
  nbytes: int
  exact: bool = True

def _regions(buf:UOp) -> list[_Region]|None:
  # Work on symbolic storage only: scheduling must not instantiate a device or allocate memory.
  if buf.op is Ops.MSTACK:
    parts = [_regions(x) for x in buf.src]
    return None if any(x is None for x in parts) else [r for part in parts if part is not None for r in part]
  if buf.op is Ops.MSELECT:
    if buf.src[0].op is Ops.MSTACK: return _regions(buf.src[0].src[buf.arg])
    if (lanes:=_regions(buf.src[0])) is None: return None
    return [lanes[buf.arg]]
  if buf.op in (Ops.RESHAPE, Ops.BITCAST): return _regions(buf.src[0])
  if buf.op is Ops.SHRINK:
    if (slices:=_regions(buf.src[0])) is None: return None
    if buf.tag != ("allreduce",) or buf.src[1].op is not Ops.CONST or buf.src[2].op is not Ops.CONST:
      return [_Region(r.base,r.offset,r.nbytes,False) for r in slices]
    return [_Region(r.base,r.offset+buf.src[1].val*buf.dtype.itemsize,buf.src[2].val*buf.dtype.itemsize) if r.exact else r for r in slices]
  if buf.op in (Ops.BUFFER, Ops.PARAM):
    if buf.op is Ops.BUFFER and (bound:=buf.arg.buffer) is not None:
      return [_Region(b.base,b.offset,b.nbytes) for b in (bound.bufs if isinstance(bound,MultiBuffer) else [bound])]
    if isinstance(buf.device,tuple):
      return [_Region(b,0,b.max_numel()*b.dtype.itemsize) for i in range(len(buf.device)) for b in (buf.mselect(i),)]
    return [_Region(buf,0,buf.max_numel()*buf.dtype.itemsize)]
  # In particular, preserve explicit AFTER ordering and unknown/custom side effects as barriers.
  return None

@functools.cache
def _outs(ast:UOp) -> tuple[int, ...]|None:
  if ast.op is Ops.COPY: return (0,)
  if ast.op not in (Ops.SINK, Ops.PROGRAM): return None
  return (ast.arg if isinstance(ast.arg,ProgramInfo) else ProgramInfo.from_sink(ast.src[0] if ast.op is Ops.PROGRAM else ast)).outs

def _compute_bound(call:UOp) -> bool:
  ast = call.src[0]
  info = ast.src[0].arg if ast.op is Ops.PROGRAM else ast.arg
  est = getattr(info,"estimates",None)
  return est is not None and isinstance(est.ops,int) and isinstance(est.mem,int) and est.ops > 32*max(1,est.mem)

def overlap_copies(linear:UOp) -> UOp:
  """Preserve early copies, but let independent compute cover a copy consumer's wait.

  This is a bounded, stable reschedule, not a latency model: issuing a COPY is not proof it has completed.
  Only an already-ready compute-bound kernel can cover a wait. Stop after that one kernel,
  avoiding prep-chain advancement and retention of every collective's scratch until the end.
  Intensity is a heuristic, not a timing model.
  RAW, WAR and WAW edges are reconstructed before memory planning, including physical slice aliases.
  Keep unrelated copies in their original order instead of flooding SDMA with future collectives.
  """
  calls = linear.src
  if not any(c.op is Ops.CALL and c.src[0].op is Ops.COPY for c in calls): return linear
  deps, tracker, barrier = [], DepsTracker(), None
  # DepsTracker keys storage by id; keep synthetic per-device UOps alive throughout the pass.
  storage:set[object] = set()
  for i,call in enumerate(calls):
    args = tuple(s for s in call.src[1:] if not s.is_bound_var) if call.op is Ops.CALL else ()
    parts = [_regions(s) for s in args]
    outs = _outs(call.src[0]) if call.op is Ops.CALL else None
    if outs is None or any(p is None for p in parts):
      deps.append(set(range(i)))
      barrier = i
      continue
    regions:list[_Region] = []
    writes:list[int] = []
    for slot,part in enumerate(parts):
      assert part is not None
      if slot in outs: writes.extend(range(len(regions),len(regions)+len(part)))
      regions.extend(part)
    storage.update(r.base for r in regions)
    # Treat every argument as read; this is conservative for metadata-only and write-only parameters.
    deps.append(set(tracker.access_resources(regions,writes,i)))
    if barrier is not None: deps[-1].add(barrier)
  children:list[list[int]] = [[] for _ in calls]
  for i,parents in enumerate(deps):
    for p in parents: children[p].append(i)
  degree = [len(p) for p in deps]
  copies = [c.op is Ops.CALL and c.src[0].op is Ops.COPY for c in calls]
  heavy = [c.op is Ops.CALL and not copies[i] and _compute_bound(c) for i,c in enumerate(calls)]
  ancestors:list[int] = []
  pending = [sum(copies[p] for p in parents) for parents in deps]
  waiters:list[list[int]] = [[] for _ in calls]
  for i,parents in enumerate(deps):
    bits = 0
    for p in parents:
      bits |= ancestors[p]
      if copies[p]:
        bits |= 1 << p
        waiters[p].append(i)
    ancestors.append(bits)
  ready_copies:list[int] = []
  ready_compute:list[int] = []
  independent:list[int] = []
  done:set[int] = set()
  def push(i:int):
    heapq.heappush(ready_copies if copies[i] else ready_compute,i)
    if heavy[i] and not pending[i]: heapq.heappush(independent,i)
  for i,d in enumerate(degree):
    if not d: push(i)
  order:list[int] = []
  deferred, covered = None, 0
  while len(order) < len(calls):
    while ready_compute and ready_compute[0] in done: heapq.heappop(ready_compute)
    while independent and independent[0] in done: heapq.heappop(independent)
    if deferred is not None:
      i, deferred = deferred, None
    elif ready_copies and (not ready_compute or ready_copies[0] < ready_compute[0]): i = heapq.heappop(ready_copies)
    else:
      assert ready_compute, "cycle in copy overlap dependencies"
      i = ready_compute[0]
      if pending[i] and independent:
        deferred, i = i, independent[0]
    order.append(i)
    done.add(i)
    if not copies[i]:
      # A preceding compute already waits for its copy ancestors. Those old copies must not
      # classify every later kernel as newly copy-blocked (e.g. FA's saved Q/K/V inputs).
      newly_covered = ancestors[i] & ~covered
      covered |= newly_covered
      while newly_covered:
        bit = newly_covered & -newly_covered
        newly_covered ^= bit
        for c in waiters[bit.bit_length()-1]:
          pending[c] -= 1
          if not pending[c] and not degree[c] and c not in done and heavy[c]: heapq.heappush(independent,c)
    for c in children[i]:
      degree[c] -= 1
      if not degree[c]: push(c)
  assert len(order) == len(calls)
  return linear.replace(src=tuple(calls[i] for i in order))

def overlap_copies_once(ctx:set[UOp], linear:UOp) -> UOp|None:
  if linear in ctx: return None
  result = overlap_copies(linear)
  ctx.add(result)
  return result if result is not linear else None
