import ctypes, itertools, functools
from tinygrad.viz.serve import amd_decode, get_cfg, COND_NOT_TAKEN, UNCOND
from tinygrad.uop.ops import UOp, sint, Ops, KernelInfo, PatternMatcher, UPat, graph_rewrite, rewrite_group, uopfunc
from tinygrad.codegen import to_program
from tinygrad.device import Device
from tinygrad.dtype import Invalid, AddrSpace, dtypes
from tinygrad.helpers import Context, getenv, TracingKey, dedup, unwrap
from tinygrad.runtime.autogen import hsa
from tinygrad.renderer.amd.dsl import EXEC_LO, ttmp
from test.mockgpu.amd.emu import _Ctx, _get_handler, _wave_size, _canonical_info, PC_LO_IDX, PC_HI_IDX, SGPR_COUNT, SCRATCH_STRIDE_IDX, F32_INLINE

asm_call_counter = itertools.count(1)

# this is meant to replace the old emulator
@uopfunc
def init_wave(wg:UOp, wave:UOp, sgpr:UOp, vgpr:UOp, lds:UOp, args_ptr:UOp, gx:int, gy:int, lx:int, ly:int, total_threads:int, wave_size:int,
              lds_size:int, scratch_size:int, rsrc2:int, arch:str="rdna3", user_data:list[int]|None=None, accvgpr:UOp|None=None):
  # define ranges inside a wave
  li = UOp.range((wave.eq(0)).where(max(lds_size//4, 1), 0), 2, dtype=dtypes.int)
  si = UOp.range(SGPR_COUNT, 3, dtype=dtypes.int)
  vi = UOp.range(256*wave_size, 4, dtype=dtypes.int)
  # zero ALLOCs
  zero_lds = lds.index(li).store(0).end(li)
  zero_sgpr = sgpr.after(zero_lds).index(si).store(0).end(si)
  zero_vgpr = vgpr.after(zero_sgpr).index(vi).store(0)
  zero_agpr = unwrap(accvgpr).after(zero_sgpr).index(vi).store(0) if wave_size == 64 else UOp(Ops.NOOP)
  clear_vgpr = UOp.group(zero_vgpr, zero_agpr).end(vi)
  # set RANGE registers
  gidx, gidy, gidz = wg%gx, (wg//gx)%gy, wg//(gx*gy)
  n_lanes = (total_threads-wave*wave_size).minimum(wave_size)
  initial:list[tuple[int, sint]] = [*((128+i, i) for i in range(65)), *((193+i, (-i-1)&0xFFFFFFFF) for i in range(16)), *F32_INLINE.items()]
  initial += [(i,v) for i,v in enumerate(user_data)] if user_data else [(0, args_ptr.cast(dtypes.uint32)), (1, (args_ptr>>32).cast(dtypes.uint32))]
  if arch == "rdna4": initial += [(ttmp[7].offset, (gidy&0xFFFF)|((gidz&0xFFFF)<<16)), (ttmp[9].offset, gidx)]
  else:
    sgpr_id = (rsrc2 & hsa.AMD_COMPUTE_PGM_RSRC_TWO_USER_SGPR_COUNT) >> hsa.AMD_COMPUTE_PGM_RSRC_TWO_USER_SGPR_COUNT_SHIFT
    for enabled, gid in [(hsa.AMD_COMPUTE_PGM_RSRC_TWO_ENABLE_SGPR_WORKGROUP_ID_X, gidx),
                         (hsa.AMD_COMPUTE_PGM_RSRC_TWO_ENABLE_SGPR_WORKGROUP_ID_Y, gidy),
                         (hsa.AMD_COMPUTE_PGM_RSRC_TWO_ENABLE_SGPR_WORKGROUP_ID_Z, gidz)]:
      if rsrc2 & enabled:
        initial.append((sgpr_id, gid))
        sgpr_id += 1
  initial += [(EXEC_LO.offset, ((UOp.const(1, dtypes.uint64)<<n_lanes.minimum(32).cast(dtypes.uint64))-1).cast(dtypes.uint32)),
              (SCRATCH_STRIDE_IDX, scratch_size), (SGPR_COUNT-16+4, (wave&15)|((wave&3)<<4))]
  if wave_size == 64: initial.append((EXEC_LO.offset+1,
                                     ((UOp.const(1, dtypes.uint64)<<(n_lanes-32).maximum(0).cast(dtypes.uint64))-1).cast(dtypes.uint32)))
  lane = UOp.range(wave_size, 5, dtype=dtypes.int)
  tid = wave*wave_size+lane
  init_vgpr = vgpr.after(clear_vgpr).index(lane.valid(tid<total_threads)).store(
      (((tid//(lx*ly))<<20)|(((tid//lx)%ly)<<10)|(tid%lx)).cast(dtypes.uint32)).end(lane)
  return UOp.sink(init_vgpr, *(sgpr.after(clear_vgpr).index(i).store(UOp.const(v, dtypes.uint32)) for i,v in dict(initial).items()))

def pc_index(idx:int) -> UPat:
  reg, null = UPat.const(idx).cast(), UPat.const(124).cast()
  return UPat.any(reg, reg.ne(null).where(reg, UPat.const(Invalid)))

def move_const_idxs(call:UOp) -> UOp|None:
  idxs = dedup(u.src[1] for u in call.body.toposort() if u.op is Ops.INDEX and u.src[0].op is Ops.PARAM and u.src[0].arg.name == "vmem"
               and u.src[1].op is Ops.CONST)
  if not idxs: return None
  rep = {idx:UOp.param(len(call.src)-1+i, idx.commit_dtype(), name=f"inst_{i}", addrspace=AddrSpace.ALU) for i,idx in enumerate(idxs)}
  return call.replace(src=(call.body.substitute(rep, walk=True), *call.src[1:], *idxs))

pm_asm_call = PatternMatcher([
  # remove PC from CALL body
  (UPat((Ops.LOAD, Ops.STORE), src=(UPat(Ops.PARAM, name="buf").index(UPat.any(pc_index(PC_LO_IDX), pc_index(PC_HI_IDX))),), allow_any_len=True),
   lambda buf: UOp(Ops.NOOP) if buf.arg.name == "sgpr" else None),
  # move CONST outside CALL body
  (UPat(Ops.CALL, src=(UPat(Ops.SINK),), allow_any_len=True, name="call"), move_const_idxs),
])

def merge_branches(insts, blocks:dict[int, list[int]], paths:dict[int, dict[int, int]]):
  # Thread jump-only blocks, then share identical conditional branches with the same destinations.
  targets:dict[int, int] = {}
  def target(pc:int) -> int:
    seen:set[int] = set()
    while pc not in targets and pc not in seen and len(blocks[pc]) == 1 and getattr(insts[blocks[pc][0]], "op_name", "") == "S_BRANCH":
      seen.add(pc)
      pc = next(iter(paths[pc]))
    pc = targets.get(pc, pc)
    targets.update((src, pc) for src in seen)
    return pc
  for pc, dsts in list(paths.items()): paths[pc] = {target(dst):kind for dst,kind in dsts.items()}
  groups:dict[tuple, list[int]] = {}
  opposite = {"S_CBRANCH_SCC1":"S_CBRANCH_SCC0", "S_CBRANCH_VCCNZ":"S_CBRANCH_VCCZ", "S_CBRANCH_EXECNZ":"S_CBRANCH_EXECZ"}
  for pc, pcs in blocks.items():
    if len(paths[pc]) != 2: continue
    inst = insts[pcs[-1]]
    # Complementary tests with reversed destinations are the same branch.
    branch_dests = tuple(sorted((dst, kind ^ (inst.op_name in opposite)) for dst,kind in paths[pc].items()))
    key = (type(inst), opposite.get(inst.op_name, inst.op_name),
           tuple((n, getattr(inst, n)) for n,_ in inst._fields if n not in {"op", "simm16"}), branch_dests)
    groups.setdefault(key, []).append(pc)
  for group in groups.values():
    if len(group) < 2: continue
    header = blocks[group[0]][-1]
    dests = paths[group[0]]
    for pc in group:
      blocks[pc] = blocks[pc][:-1]
      paths[pc] = {header:UNCOND}
    blocks[header], paths[header] = [header], dests

def dominators(paths:dict[int, dict[int, int]], entry:int) -> dict[int, int]:
  # Lengauer-Tarjan: predecessor lists and a compressed forest avoid all-pairs dominance sets.
  order, parent = [entry], {entry:entry}
  preds:dict[int, list[int]] = {entry:[]}
  stack = [(entry, iter(paths[entry]))]
  while stack:
    pc, edges = stack[-1]
    if (dst:=next(edges, None)) is None:
      stack.pop()
      continue
    preds.setdefault(dst, []).append(pc)
    if dst not in parent:
      parent[dst] = pc
      order.append(dst)
      stack.append((dst, iter(paths[dst])))
  semi = {pc:i for i,pc in enumerate(order)}
  label = {pc:pc for pc in order}
  ancestor:dict[int, int] = {}
  buckets:dict[int, list[int]] = {pc:[] for pc in order}
  idom = {entry:entry}
  def evaluate(pc:int) -> int:
    trail = []
    at = pc
    while at in ancestor and ancestor[at] in ancestor:
      trail.append(at)
      at = ancestor[at]
    for at in reversed(trail):
      par = ancestor[at]
      if semi[label[par]] < semi[label[at]]: label[at] = label[par]
      ancestor[at] = ancestor[par]
    return label[pc]
  for pc in reversed(order[1:]):
    semi[pc] = min(semi[evaluate(src)] for src in preds[pc])
    buckets[order[semi[pc]]].append(pc)
    ancestor[pc] = par = parent[pc]
    for node in buckets[par]:
      other = evaluate(node)
      idom[node] = other if semi[other] < semi[node] else par
    buckets[par].clear()
  for pc in order[1:]:
    if idom[pc] != order[semi[pc]]: idom[pc] = idom[idom[pc]]
  return idom

def cfg_loops(paths:dict[int, dict[int, int]], entry:int) -> dict[int, set[int]]:
  idom = dominators(paths, entry)
  children:dict[int, list[int]] = {pc:[] for pc in idom}
  preds:dict[int, list[int]] = {pc:[] for pc in idom}
  for pc, par in idom.items():
    if pc != entry: children[par].append(pc)
    for dst in paths[pc]: preds[dst].append(pc)
  # Euler intervals answer dominance queries in constant time.
  starts:dict[int, int] = {}
  ends:dict[int, int] = {}
  stack = [(entry, False)]
  while stack:
    pc, finish = stack.pop()
    if finish: ends[pc] = len(starts)
    else:
      starts[pc] = len(starts)
      stack.append((pc, True))
      stack.extend((child, False) for child in children[pc])
  backedges = {(src, dst) for src in idom for dst in paths[src] if starts[dst] <= starts[src] < ends[dst]}
  loops:dict[int, set[int]] = {}
  for src, header in backedges:
    body = loops.setdefault(header, {header})
    pending = [src]
    while pending:
      if (pc:=pending.pop()) in body: continue
      body.add(pc)
      pending.extend(preds[pc])
  # A topological traversal after removing backedges also detects irreducible control flow.
  incoming = {pc:sum((src, pc) not in backedges for src in preds[pc]) for pc in idom}
  pending = [pc for pc,n in incoming.items() if n == 0]
  seen = 0
  while pending:
    pc = pending.pop()
    seen += 1
    for dst in paths[pc]:
      if (pc, dst) in backedges: continue
      incoming[dst] -= 1
      if incoming[dst] == 0: pending.append(dst)
  assert seen == len(idom), "irreducible control flow is not supported in ASM_CALL"
  return loops

@rewrite_group(name=lambda *args,ret,**_: TracingKey(f"Lift {(k:=ret.src[0].arg).name}", (("lift", k.function_name),)))
def lift(lib:int, lib_sz:int, gx:int, gy:int, gz:int, lx:int, ly:int, lz:int, rsrc2:int, scratch_size:int, arch:str="rdna3",
         user_data:list[int]|None=None, backend:str|None=None) -> UOp:
  backend = getenv("ASM_CALL_BACKEND", "CPU") if backend is None else backend
  # decode
  lib_bytes = ctypes.string_at(lib, lib_sz)
  insts = amd_decode(lib_bytes, arch)
  cfg = get_cfg(insts)["data"]
  entry = 0
  merge_branches(insts, cfg["blocks"], cfg["paths"])
  loops = cfg_loops(cfg["paths"], entry)
  members:set[int] = set()
  pending = [entry]
  while pending:
    if (pc:=pending.pop()) in members: continue
    members.add(pc)
    pending.extend(cfg["paths"][pc])
  axes = itertools.count(lib_sz)
  temporaries = itertools.count(6)  # reserve 0..5 for the register, LDS, and scratch allocations
  # construct CALL graph
  wave_size, total_threads = _wave_size(arch), lx*ly*lz
  n_waves = (total_threads+wave_size-1)//wave_size
  wg = UOp.range(gx*gy*gz, 0)
  wave = UOp.range(n_waves, 1)
  # alloc register and LDS buffers
  sgpr = UOp.alloc((SGPR_COUNT,), dtypes.uint32, 0, AddrSpace.REG)
  vgpr = UOp.alloc((256*wave_size,), dtypes.uint32, 1, AddrSpace.REG)
  lds_size = ((rsrc2 & hsa.AMD_COMPUTE_PGM_RSRC_TWO_GRANULATED_LDS_SIZE) >> hsa.AMD_COMPUTE_PGM_RSRC_TWO_GRANULATED_LDS_SIZE_SHIFT)*512
  lds = UOp.alloc((max(lds_size//4, 1),), dtypes.uint32, 3, AddrSpace.REG)
  scratch = UOp.alloc((max(scratch_size*wave_size*n_waves, 1),), dtypes.uint8, 4, AddrSpace.REG)
  accvgpr = UOp.alloc((256*wave_size,), dtypes.uint32, 5, AddrSpace.REG) if wave_size == 64 else vgpr
  args_ptr = UOp.variable("args_ptr", 0, dtypes.uint64.max, dtypes.uint64)
  lib_addr = UOp.variable("lib", 0, dtypes.uint64.max, dtypes.uint64)
  inst_addr = UOp.param(-1, dtypes.uint64, name="inst", addrspace=AddrSpace.ALU)
  init = init_wave(wg, wave, sgpr, vgpr, lds, args_ptr, gx, gy, lx, ly, total_threads, wave_size, lds_size, scratch_size, rsrc2, arch,
                   user_data, *([accvgpr] if wave_size == 64 else []))
  ctx = _Ctx(4, wave_size)
  afters: dict[UOp, UOp] = {ctx.sgpr:sgpr.after(init), ctx.vgpr:vgpr.after(init), ctx.vmem:ctx.vmem,
                            ctx.lds:lds.after(init), ctx.scratch:scratch.index(wave*scratch_size*wave_size).after(init)}
  if wave_size == 64: afters[ctx.accvgpr] = accvgpr.after(init)
  def finish(end:UOp):
    afters.update((b, arg.without_after.after(end)) for b, arg in afters.items())

  loop_parents:dict[int, int|None] = dict.fromkeys(loops)
  for outer, body in sorted(loops.items(), key=lambda kv:len(kv[1])):
    for inner in body:
      if inner != outer and inner in loops and loop_parents[inner] is None: loop_parents[inner] = outer
  loop_children:dict[int|None, dict[int, set[int]]] = {}
  for header, parent in loop_parents.items(): loop_children.setdefault(parent, {})[header] = loops[header]

  def emit_region(start:int, members:set[int], scopes:tuple[UOp, ...]=(), route:UOp|None=None):
    children = loop_children.get(start if route is not None else None, {})
    exits = {h:sorted({dst for pc in body for dst in cfg["paths"][pc] if dst not in body}) for h,body in children.items()}
    def target(pc:int): return -pc-3 if pc not in members or (route is not None and pc == start) else pc
    enclosed = {pc for h,body in children.items() for pc in body if pc != h}
    edges = {pc:[target(dst) for dst in (exits[pc] if pc in children else cfg["paths"][pc])] or [-2]
             for pc in members if pc not in enclosed}
    # -pc-3 represents an edge leaving this region for pc; -2 ends the program, -1 joins all exits.
    reverse:dict[int, dict[int, int]] = {-1:{}}
    for pc, dsts in edges.items():
      reverse.setdefault(pc, {})
      for dst in dsts: reverse.setdefault(dst, {})[pc] = UNCOND
    for pc in list(reverse):
      if pc < -1: reverse[-1][pc] = UNCOND
    parents = dominators(reverse, -1)
    tree:dict[int, list[int]] = {}
    for pc, par in parents.items():
      if pc != -1: tree.setdefault(par, []).append(pc)
    depth = {-1:0}
    ancestors:dict[int, tuple[int, ...]] = {-1:(-1,)}
    pending = [-1]
    while pending:
      par = pending.pop()
      for pc in tree.get(par, []):
        depth[pc] = depth[par]+1
        row = [par]
        while 1 << len(row) <= depth[pc]: row.append(ancestors[row[-1]][len(row)-1])
        ancestors[pc] = tuple(row)
        pending.append(pc)
    def join(a:int, b:int) -> int:
      if depth[a] < depth[b]: a, b = b, a
      diff = depth[a]-depth[b]
      while diff:
        bit = diff.bit_length()-1
        a, diff = ancestors[a][bit], diff-(1<<bit)
      if a == b: return a
      for bit in reversed(range(len(ancestors[a]))):
        if bit < len(ancestors[a]) and ancestors[a][bit] != ancestors[b][bit]: a, b = ancestors[a][bit], ancestors[b][bit]
      return ancestors[a][0]

    def emit(block_pc:int, stop:int=-1, scopes:tuple[UOp, ...]=scopes):
      while block_pc != stop:
        if block_pc < 0:
          if route is not None:
            buf = afters.get(route, route).after(*scopes)
            afters[route] = buf.after(buf.store(-block_pc-3))
          return
        if block_pc in children:
          loop = UOp.loop(next(axes)).replace(src=(UOp(Ops.NOOP).after(UOp.group(*afters.values())),))
          # Record the header to repeat, or the selected exit to leave this loop.
          selector = UOp.alloc((1,), dtypes.int, slot=next(temporaries), addrspace=AddrSpace.REG)
          emit_region(block_pc, children[block_pc], scopes+(loop,), selector)
          choice = afters[selector][0].load()
          finish(UOp.group(*afters.values()).backedge(loop, choice.eq(block_pc)))
          choice = afters[selector][0].load()
          predicates = [choice.eq(dst) for dst in exits[block_pc]]
        else:
          cond = emit_block(block_pc, scopes)
          predicates = [cond.logical_not() if kind == COND_NOT_TAKEN else cond for kind in cfg["paths"][block_pc].values()]
        targets = edges[block_pc]
        if len(targets) == 1:
          block_pc = targets[0]
          continue
        merge = functools.reduce(join, targets)
        for dst, pred in zip(targets, predicates):
          if dst == merge: continue
          deps = UOp.group(*afters.values())
          gate = UOp.range(pred.cast(dtypes.int).after(deps).after(*scopes), next(axes))
          emit(dst, merge, scopes+(gate,))
          finish(UOp.group(*afters.values()).end(gate))
        block_pc = merge
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
      *_, canonical_name = _canonical_info(inst, ctx, lib_bytes[off:])
      bufs = sorted((u for u in sink.toposort() if u.op is Ops.PARAM), key=lambda u: u.arg.slot)
      args = [lib_addr+off if b is inst_addr else afters.get(b, b).after(*scopes) for b in bufs]
      if ctx.branch_cond is not None:
        cond = ctx.branch_cond
      body = sink.substitute({b:b.param_like(i, name=b.arg.name) for i,b in enumerate(bufs)})
      call = body.call(*args, name=canonical_name)
      afters.update((b, arg.without_after.after(call, *scopes)) for b, arg in zip(bufs, args) if b is not inst_addr)
    return cond.substitute(afters, walk=True)
  emit_region(entry, members, (wg, wave))
  sink = UOp.sink(UOp.group(*afters.values()).end(wave).end(wg), arg=KernelInfo(name=f"asm_call n{next(asm_call_counter)}", opts_to_apply=()))
  sink = graph_rewrite(sink, pm_asm_call, name="pm_asm_call", bottom_up=True, enter_calls=True)
  with Context(NOOPT=1, CHECK_OOB=0, TUPLE_ORDER=0, EMULATED_DTYPES="", CAPTURE_PROCESS_REPLAY=0):
    return to_program(sink, Device[backend].renderer)
