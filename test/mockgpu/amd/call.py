import ctypes, itertools, functools
from tinygrad.viz.serve import amd_decode, get_cfg, COND_NOT_TAKEN
from tinygrad.uop.ops import UOp, Ops, KernelInfo, PatternMatcher, UPat, graph_rewrite, rewrite_group
from tinygrad.codegen import to_program
from tinygrad.device import Device
from tinygrad.dtype import AddrSpace, Invalid, dtypes
from tinygrad.helpers import Context, getenv, TracingKey
from test.mockgpu.amd.emu import _Ctx, _get_handler, _wave_size, _canonical_info, PC_LO_IDX, PC_HI_IDX

asm_call_counter = itertools.count(1)

def pc_index(idx:int) -> UPat:
  reg, null = UPat.const(idx).cast(), UPat.const(124).cast()
  return UPat.any(reg, reg.ne(null).where(reg, UPat.const(Invalid)))

pm_asm_call = PatternMatcher([
  (UPat((Ops.LOAD, Ops.STORE), src=(UPat(Ops.PARAM, name="buf").index(UPat.any(pc_index(PC_LO_IDX), pc_index(PC_HI_IDX))),), allow_any_len=True),
   lambda buf: UOp(Ops.NOOP) if buf.arg.name == "sgpr" else None),
])

def cfg_loops(paths:dict[int, dict[int, int]], entry:int) -> dict[int, set[int]]:
  # Dominance is independent of the order of blocks in the instruction stream.
  nodes:set[int] = set()
  pending = [entry]
  while pending:
    if (pc:=pending.pop()) in nodes: continue
    nodes.add(pc)
    pending.extend(paths[pc])
  preds = {pc:{src for src in nodes if pc in paths[src]} for pc in nodes}
  dom = {pc:({entry} if pc == entry else set(nodes)) for pc in nodes}
  changed = True
  while changed:
    changed = False
    for pc in nodes - {entry}:
      new = {pc} | set.intersection(*(dom[src] for src in preds[pc]))
      if new != dom[pc]: dom[pc], changed = new, True
  loops:dict[int, set[int]] = {}
  for src in nodes:
    for header in paths[src]:
      if header not in dom[src]: continue
      body = loops.setdefault(header, {header})
      pending = [src]
      while pending:
        if (pc:=pending.pop()) in body: continue
        body.add(pc)
        pending.extend(preds[pc])
  # Removing natural backedges must leave a DAG. Otherwise the CFG is irreducible.
  visited:set[int] = set()
  active:set[int] = set()
  def visit(pc:int):
    assert pc not in active, "irreducible control flow is not supported in ASM_CALL"
    if pc in visited: return
    active.add(pc)
    for dst in paths[pc]:
      if dst not in dom[pc]: visit(dst)
    active.remove(pc)
    visited.add(pc)
  visit(entry)
  return loops

@rewrite_group(name=lambda *args,ret,**_: TracingKey(f"Lift {(k:=ret.src[0].arg).name}", (("lift", k.function_name),)))
def lift(lib: int, lib_sz: int, arch: str = "rdna3", backend: str|None = None) -> UOp:
  backend = getenv("ASM_CALL_BACKEND", "CPU") if backend is None else backend
  # decode
  lib_bytes = ctypes.string_at(lib, lib_sz)
  insts = amd_decode(lib_bytes, arch)
  cfg = get_cfg(insts)["data"]
  entry = next(iter(cfg["blocks"]))
  loops = cfg_loops(cfg["paths"], entry)
  afters: dict[UOp, UOp] = {}
  axes = itertools.count(lib_sz)
  inst_addr = UOp.param(6, dtypes.uint64, name="inst_addr", addrspace=AddrSpace.ALU)

  def finish(end:UOp):
    afters.update((b, b.after(end)) for b in afters)

  def emit_region(start:int, members:set[int], scopes:tuple[UOp, ...]=(), route:UOp|None=None):
    nested = {h:body for h,body in loops.items() if body <= members and (route is None or h != start)}
    children = {h:body for h,body in nested.items() if not any(body < outer for outer in nested.values())}
    exits = {h:sorted({dst for pc in body for dst in cfg["paths"][pc] if dst not in body}) for h,body in children.items()}
    def target(pc:int): return -pc-3 if pc not in members or (route is not None and pc == start) else pc
    edges = {pc:[target(dst) for dst in (exits[pc] if pc in children else cfg["paths"][pc])] or [-2]
             for pc in members if not any(pc in body and pc != h for h,body in children.items())}
    # -pc-3 represents an edge leaving this region for pc; -2 ends the program, -1 joins all exits.
    @functools.cache
    def postdom(pc:int) -> set[int]:
      if pc == -1: return {-1}
      return {pc} | set.intersection(*(postdom(dst) for dst in (edges[pc] if pc >= 0 else [-1])))

    def emit(block_pc:int, stop:int=-1, scopes:tuple[UOp, ...]=scopes):
      while block_pc != stop:
        if block_pc < 0:
          if route is not None:
            buf = afters.get(route, route).after(*scopes)
            afters[route] = buf.after(buf.store(-block_pc-3))
          return
        if block_pc in children:
          loop = UOp.loop(next(axes)).replace(src=(UOp(Ops.NOOP).after(UOp.sink(*afters.values())),))
          # Record the header to repeat, or the selected exit to leave this loop.
          selector = UOp.alloc((1,), dtypes.int, addrspace=AddrSpace.REG)
          emit_region(block_pc, children[block_pc], scopes+(loop,), selector)
          choice = afters[selector][0].load()
          finish(UOp.sink(*afters.values()).backedge(loop, choice.eq(block_pc)))
          choice = afters[selector][0].load()
          predicates = [choice.eq(dst) for dst in exits[block_pc]]
        else:
          cond = emit_block(block_pc, scopes)
          predicates = [cond.logical_not() if kind == COND_NOT_TAKEN else cond for kind in cfg["paths"][block_pc].values()]
        targets = edges[block_pc]
        if len(targets) == 1:
          block_pc = targets[0]
          continue
        join = max(set.intersection(*(postdom(dst) for dst in targets)), key=lambda pc:len(postdom(pc)))
        for dst, pred in zip(targets, predicates):
          if dst == join: continue
          deps = UOp.sink(*afters.values())
          gate = UOp.range(pred.cast(dtypes.int).after(deps).after(*scopes), next(axes))
          emit(dst, join, scopes+(gate,))
          finish(UOp.sink(*afters.values()).end(gate))
        block_pc = join
    emit(start)

  def emit_block(block_pc:int, scopes:tuple[UOp, ...]) -> UOp:
    cond = UOp.const(True)
    for off in cfg["blocks"][block_pc]:
      inst = insts[off]
      inst_st = str(inst)
      if inst_st.startswith("s_code_end"): continue
      if inst_st.startswith(("s_getpc", "s_setpc")): raise AssertionError("getpc and setpc are not allowed in ASM_CALL")
      ctx = _Ctx(inst.size(), _wave_size(arch), inst_addr=inst_addr)
      sink = _get_handler(inst)(inst, ctx)
      if ctx.branch_cond is not None: cond = ctx.branch_cond
      *_, canonical_name = _canonical_info(inst, ctx, lib_bytes[off:])
      bufs = sorted((u for u in sink.toposort() if u.op is Ops.PARAM), key=lambda u: u.arg.slot)
      body = sink.substitute({b:b.param_like(i, name=b.arg.name) for i,b in enumerate(bufs)})
      args = [UOp.const(lib+off, dtypes.uint64) if b is inst_addr else afters.get(b, b).after(*scopes) for b in bufs]
      call = body.call(*args, name=canonical_name)
      # CALL consumes argument ranges; restore the enclosing control-flow scopes.
      afters.update((b, arg.after(call).after(*scopes)) for b, arg in zip(bufs, args) if b is not inst_addr)
    return cond.substitute(afters, walk=True)
  emit_region(entry, set(cfg["blocks"]))
  sink = UOp.sink(*afters.values(), arg=KernelInfo(name=f"asm_call n{next(asm_call_counter)}", opts_to_apply=()))
  sink = graph_rewrite(sink, pm_asm_call, name="pm_asm_call", bottom_up=True, enter_calls=True)
  with Context(NOOPT=1, CHECK_OOB=0, TUPLE_ORDER=0, EMULATED_DTYPES="", CAPTURE_PROCESS_REPLAY=0):
    return to_program(sink, Device[backend].renderer)
