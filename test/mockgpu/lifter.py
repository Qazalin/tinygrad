"""Architecture-neutral helpers for instruction emulators lowered to tinygrad UOps."""
from collections.abc import Callable, Iterator
import itertools
from typing import Any
from tinygrad.codegen import to_program, to_program_config
from tinygrad.device import Buffer, BufferSpec, Device
from tinygrad.dtype import AddrSpace, dtypes
from tinygrad.engine.realize import compile_linear, link_linear, run_linear
from tinygrad.helpers import Context, DEV
from tinygrad.renderer import Renderer
from tinygrad.uop.ops import KernelInfo, Ops, PatternMatcher, UOp, UPat, graph_rewrite, uopfunc
from tinygrad.viz.serve import COND_NOT_TAKEN, COND_TAKEN

VMEM = UOp.param(2, dtypes.uint32, (1 << 46,), name="vmem", addrspace=AddrSpace.GLOBAL)

def vmem_buf() -> UOp: return UOp.from_buffer(Buffer("CPU", 1 << 48, options=BufferSpec(external_ptr=0), opaque=0), dtypes.uint32)

def emu_context(**extra:Any) -> Context:
  return Context(DEV=DEV.target("CPU", renderer="LLVM"), NOOPT=1, CHECK_OOB=0, TUPLE_ORDER=0, EMULATED_DTYPES="",
                 DEFAULT_FLOAT="float32", DEFAULT_INT="int32", TRANSCENDENTAL=1, **extra)

class InstCtx:
  """Base instruction lifting context: extracts dynamic bitfields from instruction words and tracks the canonical mask."""
  __slots__ = ("dyn_mask",)
  def __init__(self): self.dyn_mask = 0

  @staticmethod
  def inst_word(dword_idx:int) -> UOp: return UOp.param(-2 - dword_idx, dtypes.uint32, name=f"inst_w{dword_idx}", addrspace=AddrSpace.ALU)

  def extract_bits(self, lo:int, hi:int, signed:bool=False) -> UOp:
    width = hi - lo + 1
    self.dyn_mask |= ((1 << width) - 1) << lo
    dword_idx, lo_in_dword, hi_in_dword = lo // 32, lo % 32, hi % 32
    word = self.inst_word(dword_idx)
    if lo // 32 == hi // 32:
      shifted = word if lo_in_dword == 0 else word >> UOp.const(lo_in_dword, dtypes.uint32)
      val = shifted if width == 32 else shifted & UOp.const((1 << width) - 1, dtypes.uint32)
    else:
      lo_bits = 32 - lo_in_dword
      lo_part = (word >> UOp.const(lo_in_dword, dtypes.uint32)) & UOp.const((1 << lo_bits) - 1, dtypes.uint32)
      hi_part = self.inst_word(dword_idx + 1) & UOp.const((1 << (hi_in_dword + 1)) - 1, dtypes.uint32)
      val = lo_part | (hi_part << UOp.const(lo_bits, dtypes.uint32))
    if signed:
      if width == 32: return val.cast(dtypes.int)
      sign_bit = 1 << (width - 1)
      return (val.cast(dtypes.int) ^ UOp.const(sign_bit, dtypes.int)) - UOp.const(sign_bit, dtypes.int)
    return val

  def canonical_mask(self, inst_bytes:bytes|memoryview) -> tuple[int, int]:
    """Compute canonical (base, mask) for cache lookup: 1s for static bits, 0s for dynamic bits."""
    mask = ((1 << (len(inst_bytes) * 8)) - 1) & ~self.dyn_mask
    return int.from_bytes(inst_bytes, "little") & mask, mask

@uopfunc
def emu_loop_active(routes:UOp, active:UOp, header:UOp, waves:UOp):
  w = UOp.range(waves, 0, dtype=dtypes.int)
  return active[0].store(routes[w].load().eq(header).cast(dtypes.u32).reduce(w, arg=Ops.MAX).ne(0)).sink()

def lower_body(sink:UOp) -> UOp:
  bufs = sorted((u for u in sink.toposort() if u.op is Ops.PARAM), key=lambda u: u.arg.slot)
  body = sink.substitute({b:UOp.param(i, b.dtype, b.shape, name=b.arg.name, addrspace=b.addrspace) for i,b in enumerate(bufs)}, walk=True)
  return body.call(*bufs)

InstCache = dict[tuple, list[tuple[int, int, tuple[UOp|None, UOp|None]]]]

def cached_inst_call(cache:InstCache, key:tuple, inst:Any, inst_bytes:bytes,
                     lower_fn:Callable[[], tuple[UOp|None, UOp|None, int, int]],
                     max_entries:int=0) -> tuple[UOp|None, UOp|None]:
  entries = cache.setdefault(key, [])
  bits = int.from_bytes(inst_bytes, "little")
  for base, mask, ret in entries:
    if (bits & mask) == base: break
  else:
    call, cond, base, mask = lower_fn()
    ret = (call, cond)
    if not max_entries or len(entries) < max_entries: entries.append((base, mask, ret))
  call, cond = ret
  words = {InstCtx.inst_word(i): UOp.const((bits >> (32 * i)) & 0xffffffff, dtypes.uint32) for i in range(len(inst_bytes) // 4)}
  if call is not None: call = call.replace(src=(UOp.native(inst, call.body), *(words.get(b, b) for b in call.src[1:])))
  return call, cond.substitute(words) if cond is not None else None

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

def lift_cfg(blocks:dict[int, list[int]], paths:dict[int, dict[int, int]], lower_inst:Callable[[int], tuple[UOp|None, UOp|None]],
             buffers:dict[UOp, tuple[UOp, int]], values:dict[UOp, UOp], wg:UOp, worker:UOp, n_workers:int, init:UOp,
             vmem:UOp, name:str, axes:Iterator[int]|None=None, entry:int=0, block_name:str="emu_workers") -> UOp:
  regions = cfg_regions(paths, entry)
  routed = any(body or len(paths[pc]) > 1 for pc, body in regions)
  if axes is None: axes = itertools.count(100)
  slot_base = max((u.arg.slot for u in (*buffers, *values)), default=0) + 1
  alloc_base = max((buf.arg.slot for buf, _ in buffers.values() if buf.op is Ops.ALLOC), default=0) + 1
  routes = UOp.alloc((n_workers,), dtypes.int, alloc_base, AddrSpace.REG)
  active = UOp.alloc((1,), dtypes.bool, alloc_base + 1, AddrSpace.REG)
  route = UOp.param(slot_base, dtypes.int, (1,), name="route", addrspace=AddrSpace.REG)
  taken = UOp.param(slot_base + 1, dtypes.int, name="taken", addrspace=AddrSpace.ALU)
  fallthrough = UOp.param(slot_base + 2, dtypes.int, name="fallthrough", addrspace=AddrSpace.ALU)
  all_buffers = {**buffers, route: (routes, 1)}
  initialized = (routes.after(init).index(worker).store(UOp.const(entry, dtypes.int)) if routed else UOp.group(init, worker)).end(worker)

  def emit_block(block_pc:int, end:UOp, scopes:tuple[UOp, ...]) -> UOp:
    cond, instructions = UOp.const(True), []
    for pc in blocks[block_pc]:
      call, bcond = lower_inst(pc)
      if bcond is not None: cond = bcond
      if call is not None: instructions.append(call)
    block_values = dict(values)
    if routed:
      dsts = {kind: dst for dst, kind in paths[block_pc].items()}
      target = cond.where(taken, fallthrough) if len(dsts) == 2 else taken
      block_values |= ({taken: UOp.const(dsts[COND_TAKEN], dtypes.int), fallthrough: UOp.const(dsts[COND_NOT_TAKEN], dtypes.int)}
                       if len(dsts) == 2 else {taken: UOp.const(next(iter(dsts.values()), -1), dtypes.int)})
      instructions.append(lower_body(route[0].store(target).sink(arg=KernelInfo("emu_branch"))))
    if not instructions: return end
    body, bufs = instruction_block(instructions)
    args = [block_values[b] if b.addrspace is AddrSpace.ALU else all_buffers[b][0] for b in bufs]
    args += [UOp.const(block_pc, dtypes.int).after(end, *scopes)]
    params = [UOp.param(i, a.dtype, a.shape, name=b.arg.name, addrspace=b.addrspace) for i, (a, b) in enumerate(zip(args, bufs))]
    params.append(UOp.param(len(bufs), dtypes.int, addrspace=AddrSpace.ALU))
    # lower the worker loop with the block, so repeated blocks share its indexing and route check too.
    w = UOp.range(n_workers, 0, dtype=dtypes.int)
    gates = (UOp.range(params[bufs.index(route)][w].load().eq(params[-1]).cast(dtypes.int), 1, dtype=dtypes.int),) if routed else ()
    call_args = [p if b.addrspace is AddrSpace.ALU else p.after(*gates, w).shrink(((w * s, (w + 1) * s),))
                 if (s := all_buffers[b][1]) else p.after(*gates, w) for b, p in zip(bufs, params)]
    return UOp.group(body.call(*call_args), *gates, w).end(*gates).end(w).sink(arg=KernelInfo(block_name)).call(*args)

  ret = emit_cfg(regions, routes, active, UOp.const(n_workers, dtypes.int), axes, emit_block, initialized, (wg,)).end(wg).sink(
    vmem, arg=KernelInfo(name=name, optimized=True))
  return graph_rewrite(ret, pm_remove_native, name="remove native", enter_calls=True)

def compile_program(cache:dict[tuple, UOp], key:tuple, lift_fn:Callable[[Renderer], UOp]) -> tuple[UOp, bool]:
  renderer = Device["CPU"].renderer
  full_key = (*key, type(renderer), renderer.target, *(x.value for x in to_program_config))
  if (prg := cache.get(full_key)) is not None: return prg, False
  cache[full_key] = prg = to_program(lift_fn(renderer), renderer)
  return prg, True

def run_program(prg:UOp, buffers:dict[str, UOp], var_vals:dict[str, int]|None=None) -> None:
  inputs = list(buffers.values())
  by_name = {name: u.as_extern(i) for i, (name, u) in enumerate(buffers.items())}
  args = [by_name["vmem"]] * (max((p.arg.slot for p in prg.kernel_params), default=0) + 1)
  for p in prg.kernel_params:
    if p.addrspace is AddrSpace.ALU:
      assert var_vals is not None and p.arg.name in var_vals, f"missing ALU var {p.arg.name!r}"
      args[p.arg.slot] = p.bind(var_vals[p.arg.name])
    else: args[p.arg.slot] = by_name[p.arg.name]
  linear = compile_linear(UOp(Ops.LINEAR, src=(prg.call(*args),)), cache=True)
  run_linear(link_linear(linear, inputs), input_uops=inputs, update_stats=False)
