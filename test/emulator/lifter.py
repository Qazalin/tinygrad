"""Architecture-neutral helpers for instruction emulators lowered to tinygrad UOps."""
from collections.abc import Callable, Iterator
from dataclasses import replace
from tinygrad.dtype import dtypes
from tinygrad.engine.realize import run_linear
from tinygrad.uop.ops import UOp, Ops, KernelInfo, uopfunc


def _param_like(u:UOp, slot:int) -> UOp:
  ret = u.param_like(slot, name=u.arg.name)
  return ret.replace(arg=replace(ret.arg, volatile=True)) if u.op is Ops.PARAM and u.arg.volatile and not ret.arg.volatile else ret

def lower_body(sink:UOp, name:str) -> UOp:
  """Turn an instruction/body SINK into a CALL with its PARAMs collected and renumbered."""
  bufs = sorted((u for u in sink.toposort() if u.op is Ops.PARAM), key=lambda u:u.arg.slot)
  body = sink.substitute({b:_param_like(b, i) for i,b in enumerate(bufs)}, walk=True)
  return body.replace(arg=KernelInfo(name)).call(*bufs)


def instruction_block(instructions:list[UOp], ordering_buffers:tuple[UOp, ...]=()) -> tuple[UOp, list[UOp]]:
  """Compose instruction CALLs into an explicitly ordered PROGRAM and return its external buffers."""
  bufs = sorted({buf for call in instructions for b in call.src[1:] if (buf:=b.buf_uop).op is Ops.PARAM}, key=lambda b:b.arg.slot)
  params = {b:_param_like(b, i) for i,b in enumerate(bufs)}
  linear = list(UOp.sink(*params.values()).toposort())[:-1]
  seen:set[UOp] = set()
  for call in instructions:
    args = [params.get(b, b) for b in call.src[1:]]
    inputs = UOp.sink(*args)
    nodes = inputs.toposort(lambda u:u.op is not Ops.PARAM and u not in seen)
    nodes.pop(inputs)
    seen.update(nodes)
    linear.extend(nodes)
    linear.append(call.replace(src=(call.body, *args)))
    if any(b in call.src[1:] for b in ordering_buffers): seen.clear()
  return UOp(Ops.PROGRAM, src=(sink:=UOp.sink(*linear, arg=KernelInfo("emu_block", optimized=True)),
                              UOp(Ops.LINEAR, src=(*linear, sink)))), bufs

@uopfunc
def emu_loop_active(routes:UOp, active:UOp, header:UOp, waves:UOp):
  w = UOp.range(waves, 0, dtype=dtypes.int)
  return active[0].store(routes[w].load().eq(header).cast(dtypes.uint32).reduce(w, arg=Ops.MAX).ne(0)).sink()

def emit_cfg(regions:list["CFGRegion"], routes:UOp, active:UOp, waves:UOp, axes:Iterator[int],
             emit_block:Callable[[int, UOp, tuple[UOp, ...]], UOp], end:UOp, scopes:tuple[UOp, ...]=()) -> UOp:
  """Emit structured CFG regions with per-route loopback and exit checks."""
  def emit_dispatch(regions:list["CFGRegion"], scopes:tuple[UOp, ...], end:UOp) -> UOp:
    for pc, body in regions:
      if body:
        loop = UOp.loop(next(axes)).replace(src=(UOp(Ops.NOOP).after(end),))
        end = emit_dispatch(body, scopes+(loop,), loop)
        check = emu_loop_active(routes.after(end, *scopes, loop), active, UOp.const(pc, routes.dtype), waves)
        end = end.backedge(loop, active.after(check, *scopes, loop)[0].load())
      else: end = emit_block(pc, end, scopes)
    return end
  return emit_dispatch(regions, scopes, end)

def run_program(prg:UOp, args:list[UOp]) -> None:
  run_linear(UOp(Ops.LINEAR, src=(prg.call(*args),)), update_stats=False)

# a block has an empty body; a loop contains its header block and the rest of its iteration.
CFGRegion = tuple[int, list["CFGRegion"]]
class IrreducibleCFG(RuntimeError): pass

def cfg_regions(paths:dict[int, dict[int, int]], entry:int) -> list[CFGRegion]:
  """Partition a reducible CFG into sequential regions and nested loops in execution order."""
  order:dict[int, int] = {}
  seen, pending = set(), [(entry, False)]
  while pending:
    pc, visited = pending.pop()
    if visited: order[pc] = len(order)
    elif pc not in seen:
      seen.add(pc)
      pending.append((pc, True))
      pending.extend((dst, False) for dst in sorted(paths[pc], reverse=True))
  preds:dict[int, set[int]] = {pc:set() for pc in order}
  for pc in order:
    for dst in paths[pc]: preds[dst].add(pc)
  def build(remaining:set[int]) -> list[CFGRegion]:
    regions:list[CFGRegion] = []
    for pc in sorted(remaining, key=order.__getitem__, reverse=True):
      if pc not in remaining: continue
      component, todo = set(), [pc]
      while todo:
        if (dst:=todo.pop()) not in remaining: continue
        remaining.remove(dst)
        component.add(dst)
        todo.extend(preds[dst])
      body:list[CFGRegion] = []
      if len(component) > 1 or pc in paths[pc]:
        if any(preds[dst] - component for dst in component if dst != pc):
          raise IrreducibleCFG("irreducible control flow is not supported by the emulator lifter")
        body = [(pc, [])] + build(component - {pc})
      regions.append((pc, body))
    return regions
  return build(set(order))
