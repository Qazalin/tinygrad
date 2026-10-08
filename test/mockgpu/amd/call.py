import ctypes, itertools, functools, hashlib
from tinygrad.viz.serve import amd_decode, get_cfg, COND_NOT_TAKEN, UNCOND
from tinygrad.uop.ops import UOp, sint, Ops, KernelInfo, PatternMatcher, UPat, graph_rewrite, rewrite_group, uopfunc
from tinygrad.codegen import to_program, to_program_config
from tinygrad.device import Device
from tinygrad.dtype import AddrSpace, Invalid, dtypes
from tinygrad.helpers import Context, getenv, TracingKey, dedup, unwrap
from tinygrad.runtime.autogen import hsa
from tinygrad.renderer.amd.dsl import Inst, EXEC_LO, ttmp
from test.mockgpu.amd.emu import (_Ctx, _get_handler, _wave_size, _canonical_info, _is_barrier, PC_LO_IDX, PC_HI_IDX, ENDPGM_PC,
                                  SGPR_COUNT, SCRATCH_STRIDE_IDX, F32_INLINE)

lift_cache:dict[tuple, UOp] = {}
InstructionCall = tuple[UOp, list[UOp], tuple[int, ...], UOp|None]
instruction_cache:dict[tuple, list[tuple[int, int, InstructionCall]]] = {}

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
  indexes = [u for u in call.body.toposort() if u.op is Ops.INDEX and u.src[0].op is Ops.PARAM and u.src[0].arg.name == "vmem"
             and u.src[1].op is Ops.CONST]
  idxs = dedup(u.src[1] for u in indexes)
  if not idxs: return None
  rep = {idx:UOp.param(len(call.src)-1+i, dtypes.uint64, name=f"inst_{i}", addrspace=AddrSpace.ALU) for i,idx in enumerate(idxs)}
  body = call.body.substitute({u:u.replace(src=(u.src[0], rep[u.src[1]], *u.src[2:])) for u in indexes}, walk=True)
  return call.replace(src=(body, *call.src[1:], *(idx.cast(dtypes.uint64) for idx in idxs)))

pm_asm_call = PatternMatcher([
  # remove PC from CALL body
  (UPat((Ops.LOAD, Ops.STORE), src=(UPat(Ops.PARAM, name="buf").index(UPat.any(pc_index(PC_LO_IDX), pc_index(PC_HI_IDX))),), allow_any_len=True),
   lambda buf: UOp(Ops.NOOP) if buf.arg.name == "sgpr" else None),
  # move CONST outside CALL body
  (UPat(Ops.CALL, src=(UPat(Ops.SINK),), allow_any_len=True, name="call"), move_const_idxs),
])

def instruction_call(inst:Inst, arch:str) -> InstructionCall:
  entries = instruction_cache.setdefault((arch, type(inst), inst.size()), [])
  inst_bytes = inst.to_bytes()
  bits = int.from_bytes(inst_bytes, "little")
  for base, mask, ret in entries:
    if bits & mask == base: return ret
  # Dynamic operand fields share one body; construct and rewrite it only on a canonical cache miss.
  ctx = _Ctx(inst.size(), _wave_size(arch), inst_addr=0)
  sink = _get_handler(inst)(inst, ctx)
  base, mask, _, name = _canonical_info(inst, ctx, inst_bytes)
  bufs = sorted((u for u in sink.toposort() if u.op is Ops.PARAM), key=lambda u: u.arg.slot)
  body = sink.substitute({b:b.param_like(i, name=b.arg.name) for i,b in enumerate(bufs)})
  call = graph_rewrite(body.call(*bufs, name=name), pm_asm_call,
                       name="instruction call", bottom_up=True, enter_calls=True)
  ret = call, bufs, tuple(int(x) for x in call.src[len(bufs)+1:]), ctx.branch_cond
  entries.append((base, mask, ret))
  return ret

def merge_branches(insts, blocks:dict[int, list[int]], paths:dict[int, dict[int, int]]):
  # Thread jump-only blocks, then share identical conditional branches with the same destinations.
  def target(pc:int) -> int:
    seen:set[int] = set()
    while pc not in seen and len(blocks[pc]) == 1 and getattr(insts[blocks[pc][0]], "op_name", "") == "S_BRANCH":
      seen.add(pc)
      pc = next(iter(paths[pc]))
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

def lift_dispatch(lib:int, lib_sz:int, gx:int, gy:int, gz:int, lx:int, ly:int, lz:int, rsrc2:int, scratch_size:int, arch:str,
                  user_data:list[int]|None, backend:str) -> UOp|None:
  lib_bytes = ctypes.string_at(lib, lib_sz)
  dispatch = (gx, gy, gz, lx, ly, lz, rsrc2, scratch_size, tuple(user_data) if user_data else None)
  renderer = Device[backend].renderer
  key = (lib_bytes, arch, backend, dispatch, type(renderer), renderer.target, *(x.value for x in to_program_config))
  if key not in dispatch_cache:
    # The region scheduler is still needed when barriers synchronize multiple waves.
    if lx*ly*lz > _wave_size(arch) and any(_is_barrier(inst) for inst in amd_decode(lib_bytes, arch).values()):
      dispatch_cache[key] = None
    else: dispatch_cache[key] = _lift(lib_bytes, arch, backend, 0, dispatch)
  return dispatch_cache[key]

dispatch_cache:dict[tuple, UOp|None] = {}

@rewrite_group(name=lambda *args,ret,**_: TracingKey(f"Lift {(k:=ret.src[0].arg).name}", (("lift", k.function_name),)))
def lift(lib: int, lib_sz: int, arch: str = "rdna3", backend: str|None = None, entry: int = 0) -> UOp:
  backend = getenv("ASM_CALL_BACKEND", "CPU") if backend is None else backend
  lib_bytes = ctypes.string_at(lib, lib_sz)
  renderer = Device[backend].renderer
  # Code addresses are runtime arguments, so identical bytes can share a program across allocations.
  key = (lib_bytes, arch, backend, entry, type(renderer), renderer.target, *(x.value for x in to_program_config))
  if key not in lift_cache: lift_cache[key] = _lift(lib_bytes, arch, backend, entry)
  return lift_cache[key]

def _lift(lib_bytes:bytes, arch:str, backend:str, entry:int, dispatch:tuple|None=None) -> UOp:
  lib_sz = len(lib_bytes)
  # decode
  insts = amd_decode(lib_bytes, arch)
  barriers = {off:off+inst.size() for off,inst in insts.items() if _is_barrier(inst)}
  cfg = get_cfg(insts)["data"]
  # A lifted region returns at a barrier. The scheduler resumes each wave at the following instruction.
  resumes = {pc:barriers[pcs[-1]] for pc,pcs in cfg["blocks"].items() if pcs[-1] in barriers}
  if dispatch is None:
    for pc in resumes: cfg["paths"][pc] = {}
  merge_branches(insts, cfg["blocks"], cfg["paths"])
  loops = cfg_loops(cfg["paths"], entry)
  members:set[int] = set()
  pending = [entry]
  while pending:
    if (pc:=pending.pop()) in members: continue
    members.add(pc)
    pending.extend(cfg["paths"][pc])
  afters: dict[UOp, UOp] = {}
  axes = itertools.count(lib_sz)
  resume = UOp.param(6, dtypes.uint64, 1, name="resume")
  code_addr = UOp.param(7, dtypes.uint64, name="code_addr", addrspace=AddrSpace.ALU)

  if dispatch is not None:
    gx, gy, gz, lx, ly, lz, rsrc2, scratch_size, user_data = dispatch
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
    code_addr = UOp.variable("lib", 0, dtypes.uint64.max, dtypes.uint64)
    init = init_wave(wg, wave, sgpr, vgpr, lds, args_ptr, gx, gy, lx, ly, total_threads, wave_size, lds_size, scratch_size, rsrc2, arch,
                     user_data, *([accvgpr] if wave_size == 64 else []))
    ctx = _Ctx(4, wave_size)
    afters = {ctx.sgpr:sgpr.after(init), ctx.vgpr:vgpr.after(init), ctx.vmem:ctx.vmem,
                              ctx.lds:lds.after(init), ctx.scratch:scratch.index(wave*scratch_size*wave_size).after(init)}
    if wave_size == 64: afters[ctx.accvgpr] = accvgpr.after(init)

  def finish(end:UOp):
    afters.update((b, arg.without_after.after(end)) for b, arg in afters.items())

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
      template, bufs, word_offsets, branch_cond = instruction_call(inst, arch)
      if branch_cond is not None: cond = branch_cond
      args = [afters.get(b, b).after(*scopes) for b in bufs]
      call = template.replace(src=(template.body, *args, *((code_addr>>2)+(off//4+i) for i in word_offsets)))
      # CALL consumes argument ranges; restore the enclosing control-flow scopes.
      afters.update((b, arg.after(call).after(*scopes)) for b, arg in zip(bufs, args))
    if dispatch is None and not cfg["paths"][block_pc]:
      ptr = resume.after(*afters.values()).after(*scopes)
      afters[resume] = ptr.after(ptr[0].store(code_addr+resumes[block_pc] if block_pc in resumes else ENDPGM_PC))
    return cond.substitute(afters, walk=True)
  emit_region(entry, members, (wg, wave) if dispatch is not None else ())
  name = f"asm_call_{arch}_{hashlib.sha256(lib_bytes).hexdigest()[:16]}_{entry}"
  body = UOp.group(*afters.values())
  if dispatch is not None: body = body.end(wave).end(wg)
  sink = UOp.sink(body, arg=KernelInfo(name=name, opts_to_apply=()))
  with Context(NOOPT=1, CHECK_OOB=0, TUPLE_ORDER=0, EMULATED_DTYPES="", CAPTURE_PROCESS_REPLAY=0):
    return to_program(sink, Device[backend].renderer)
