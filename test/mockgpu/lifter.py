"""Architecture-neutral helpers for instruction emulators lowered to tinygrad UOps."""
from collections.abc import Callable, Iterator
from tinygrad.dtype import dtypes
from tinygrad.engine.realize import compile_linear, link_linear, run_linear
from tinygrad.uop.ops import UOp, Ops, KernelInfo, PatternMatcher, UPat, uopfunc

@uopfunc
def emu_loop_active(routes:UOp, active:UOp, header:UOp, waves:UOp):
  w = UOp.range(waves, 0, dtype=dtypes.int)
  return active[0].store(routes[w].load().eq(header).cast(dtypes.u32).reduce(w, arg=Ops.MAX).ne(0)).sink()

def lower_body(sink:UOp) -> UOp:
  bufs = sorted((u for u in sink.toposort() if u.op is Ops.PARAM), key=lambda u: u.arg.slot)
  body = sink.substitute({b:UOp.param(i, b.dtype, b.shape, name=b.arg.name, addrspace=b.addrspace) for i,b in enumerate(bufs)}, walk=True)
  return body.call(*bufs)

def instruction_block(instructions:list[UOp]) -> tuple[UOp, list[UOp]]:
  bufs = sorted({b for call in instructions for b in call.src[1:] if b.op is Ops.PARAM}, key=lambda b: b.arg.slot)
  params = {b:UOp.param(i, b.dtype, b.shape, name=b.arg.name, addrspace=b.addrspace) for i,b in enumerate(bufs)}
  linear = list(UOp.sink(*params.values()).toposort())[:-1]
  seen = set(linear)
  for call in instructions:
    args = [params.get(b, b) for b in call.src[1:]]
    inputs = UOp.sink(*args)
    nodes = inputs.toposort(lambda u:u not in seen)
    nodes.pop(inputs)
    seen.update(nodes)
    linear.extend(nodes)
    linear.append(call.replace(src=(call.body, *args)))
  return UOp(Ops.PROGRAM, src=(sink:=UOp.sink(*linear, arg=KernelInfo("emu_block", optimized=True)),
                              UOp(Ops.LINEAR, src=(*linear, sink)))), bufs

# a block has an empty body; a loop contains its header block and the rest of its iteration.
CFGRegion = tuple[int, list["CFGRegion"]]

def cfg_regions(paths:dict[int, dict[int, int]], entry:int) -> list[CFGRegion]:
  # number the reachable blocks in DFS postorder, without recursion on long instruction streams.
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
    # reverse postorder and predecessor walks partition this region into SCCs in execution order.
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
        # Bourdoncle WTO: removing the max-postorder head exposes nested loops; the original DFS order still applies,
        # and after one pass through body every wave still in component is guaranteed to be at pc.
        body = [(pc, [])] + build(component - {pc})
      regions.append((pc, body))
    return regions
  return build(set(order))

def emit_cfg(regions:list[CFGRegion], routes:UOp, active:UOp, waves:UOp, axes:Iterator[int],
             emit_block:Callable[[int, UOp, tuple[UOp, ...]], UOp], end:UOp, scopes:tuple[UOp, ...]=()) -> UOp:
  def emit_dispatch(regions:list[CFGRegion], scopes:tuple[UOp, ...], end:UOp) -> UOp:
    for pc, body in regions:
      if body:
        loop = UOp.loop(next(axes)).replace(src=(UOp(Ops.NOOP).after(end),))
        end = emit_dispatch(body, scopes+(loop,), loop)
        # lanes that exited keep their route while the remaining lanes repeat the loop.
        check = emu_loop_active(routes.after(end, *scopes, loop), active, UOp.const(pc, routes.dtype), waves)
        end = end.backedge(loop, active.after(check, *scopes, loop)[0].load())
      else:
        # complete the block for every participating lane before entering its successors, including barrier successors.
        end = emit_block(pc, end, scopes)
    return end
  return emit_dispatch(regions, scopes, end)

pm_remove_native = PatternMatcher([
  (UPat(Ops.NATIVE, name="native"), lambda native: native.src[0]),
])

def run_program(prg:UOp, args:list[UOp], inputs:list[UOp]) -> None:
  linear = compile_linear(UOp(Ops.LINEAR, src=(prg.call(*args),)), cache=True)
  run_linear(link_linear(linear, inputs), input_uops=inputs, update_stats=False)
