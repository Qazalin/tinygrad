import ctypes, itertools, functools
from collections.abc import Iterator
from tinygrad.viz.serve import amd_decode, get_cfg, COND_NOT_TAKEN, UNCOND
from tinygrad.uop.ops import UOp, sint, Ops, KernelInfo, ProgramInfo, PatternMatcher, UPat, graph_rewrite, rewrite_group, uopfunc
from tinygrad.codegen import to_program, to_program_config
import tinygrad.codegen as codegen
from tinygrad.device import Device
from tinygrad.renderer import Renderer
from tinygrad.renderer.llvmir import CPULLVMRenderer
from tinygrad.engine.realize import get_runtime
from tinygrad.runtime.support.c import DLL
from tinygrad.runtime.support.compiler_llvm import CPULLVMCompiler
from tinygrad.dtype import AddrSpace, Invalid, dtypes
from tinygrad.helpers import Context, getenv, TracingKey, dedup, unwrap, Target
from tinygrad.runtime.autogen import hsa, llvm
from tinygrad.renderer.amd.dsl import Inst, EXEC_LO, ttmp
from test.mockgpu.amd.emu import (_Ctx, _get_handler, _wave_size, _canonical_info, _is_barrier, PC_LO_IDX, PC_HI_IDX, ENDPGM_PC,
                                  SGPR_COUNT, SCRATCH_STRIDE_IDX, F32_INLINE)

class CallLLVMRenderer(CPULLVMRenderer):
  def __init__(self, target:Target):
    super().__init__(target)
    assert isinstance(self.compiler, CPULLVMCompiler)
    # Call wrappers handle control flow and offsets; instruction bodies are optimized separately.
    self.compiler.passes = b'default<O0>'
    tm = self.compiler.target_machine
    triple, cpu, features = llvm.LLVMGetTargetMachineTriple(tm), llvm.LLVMGetTargetMachineCPU(tm), llvm.LLVMGetTargetMachineFeatureString(tm)
    self.compiler.target_machine = llvm.LLVMCreateTargetMachine(llvm.LLVMGetTargetMachineTarget(tm), triple, cpu, features,
      llvm.LLVMCodeGenLevelNone, llvm.LLVMRelocPIC, llvm.LLVMCodeModelDefault)
    llvm.LLVMDisposeTargetMachine(tm)
    for message in (triple, cpu, features): llvm.LLVMDisposeMessage(message)
    if self.compiler.cachekey is not None: self.compiler.cachekey += "_asm_call_control"

@functools.cache
def llvm_renderer(arch:str, fast_compile:bool=False):
  return (CallLLVMRenderer if fast_compile else CPULLVMRenderer)(Target("CPU", "LLVM", arch))

def backend_renderer(backend:str, fast_compile:bool=False):
  return llvm_renderer(Device["CPU"].renderer.target.arch, fast_compile) if backend == "LLVM" else Device[backend].renderer

lift_cache:dict[tuple, UOp] = {}
InstructionCall = tuple[UOp, list[UOp], tuple[int, ...], UOp|None]
instruction_cache:dict[tuple, list[tuple[int, int, InstructionCall]]] = {}

# this is meant to replace the old emulator
@uopfunc
def init_wave(wg:UOp, wave:UOp, sgpr:UOp, vgpr:UOp, lds:UOp, args_ptr:UOp, gx:sint, gy:sint, lx:sint, ly:sint, total_threads:sint, wave_size:int,
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
  initial += [(0, args_ptr.cast(dtypes.uint32)), (1, (args_ptr>>32).cast(dtypes.uint32))][:min(len(user_data), 2) if user_data else 2]
  if user_data: initial += [(i+2,v) for i,v in enumerate(user_data[2:])]
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

external_calls:dict[tuple, tuple[UOp, tuple[int, ...], object]] = {}

def call_program(sink:UOp, renderer:Renderer, flat:bool=False) -> UOp:
  # These graphs contain scalar control flow and already-compiled calls, with no tensor reductions or dtype emulation.
  extra = renderer.extra_matcher or PatternMatcher([])
  # Straight-line instruction blocks already contain typed pointers, offsets, and external calls.
  if not flat:
    sink = graph_rewrite(sink, codegen.pm_mops+codegen.symbolic_simple, name="call movements", bottom_up=True)
    sink = graph_rewrite(sink, codegen.sym+codegen.pm_add_loads, name="call simplify")
    sink = graph_rewrite(sink, codegen.symbolic_simple+codegen.pm_expand_broadcast+codegen.pm_add_loads+
                        codegen.devectorizer2+codegen.indexing_simplify, name="call scalarize")
    sink = graph_rewrite(sink, codegen.pm_lower_weak+codegen.indexing_simplify, name="call indexes")
    supported = tuple(renderer.code_for_op)
    decomp = codegen.symbolic_simple+codegen.get_simplifying_rewrite_patterns(supported)+\
             codegen.get_late_rewrite_patterns(supported, bool(codegen.DISABLE_FAST_IDIV))
    sink = graph_rewrite(sink, decomp, ctx=renderer, name="call decompositions")
    sink = graph_rewrite(sink, codegen.pm_move_gates_from_index, name="call gates")
    sink = graph_rewrite(sink, codegen.pm_commit_weak+decomp+extra+codegen.pm_split_ends+codegen.pm_remove_invalid,
                        ctx=renderer, name="call final")
    sink = graph_rewrite(sink, codegen.pm_cast_const, name="call constants")
    sink = graph_rewrite(sink, codegen.pm_add_control_flow, ctx=codegen.CFGContext(sink), bottom_up=True, name="call control flow")
  else:
    # Calls already form a dependency chain; no loop scheduling or tensor linearization is needed.
    nodes = sink.toposort(enter_calls=False)
    params = sorted((u for u in nodes if u.op is Ops.PARAM), key=lambda u:u.arg.slot)
    header = UOp.sink(*params)
    prefix = header.toposort()
    del prefix[header]
    linear = UOp(Ops.LINEAR, src=tuple(prefix)+tuple(u for u in nodes if u not in prefix))
    if codegen.SPEC: codegen.type_verify(sink, codegen.spec_program)
    return to_program(UOp(Ops.PROGRAM, src=(sink, linear), arg=ProgramInfo.from_sink(sink, renderer.target)), renderer)
  slots = max((u.arg.slot+1 for u in sink.toposort() if u.op is Ops.PARAM and not u.is_variable), default=0)
  sink = graph_rewrite(sink, codegen.pm_number_params, ctx=(slots, {}), walk=True, name="call variables")
  if codegen.SPEC: codegen.type_verify(sink, codegen.spec_program)
  return to_program(UOp(Ops.PROGRAM, src=(sink,), arg=ProgramInfo.from_sink(sink, renderer.target)), renderer)

def external_call(call:UOp, backend:str, flat:bool=False, after:UOp|None=None) -> UOp:
  if backend not in {"CPU", "LLVM"} or not getenv("ASM_CALL_EXTERN", 1): return call
  renderer = backend_renderer(backend, flat)
  key = (call.body, type(renderer), renderer.target, *(x.value for x in to_program_config))
  if key not in external_calls:
    name = "asm_inst_"+call.body.key.hex()[:24]
    params = sorted((u for u in call.body.toposort() if u.op is Ops.PARAM), key=lambda u:(u.addrspace is AddrSpace.ALU, u.arg.slot))
    body = call.body.substitute({u:u.param_like(i, name=u.arg.name)
                                 for i,u in enumerate(params)})
    with Context(NOOPT=1, CHECK_OOB=0, TUPLE_ORDER=0, EMULATED_DTYPES="", CAPTURE_PROCESS_REPLAY=0):
      sink = body.replace(arg=KernelInfo(name=name)).rtag(1)
      # Wave reductions and transcendental instructions still need the tensor/decomposition pipeline.
      full = not flat and any(u.op in {Ops.REDUCE, Ops.SIN, Ops.EXP2, Ops.LOG2} for u in sink.toposort())
      prg = to_program(sink, renderer) if full else call_program(sink, renderer, flat=flat)
    runtime = get_runtime("CPU" if backend == "LLVM" else backend, prg)
    setattr(DLL._loaded_.setdefault("asm_call", ctypes.CDLL(None)), name, runtime.fxn)
    # Lowering renumbers scalar parameters by first use, so recover their original slots by name.
    scalar_slots = {p.arg.name:p.arg.slot for p in params if p.addrspace is AddrSpace.ALU}
    slots = tuple(params[i].arg.slot for i in prg.arg.globals) + tuple(scalar_slots[v.arg.name] for v in prg.arg.vars)
    external_calls[key] = UOp.custom_function(name), slots, runtime
  body, slots, _ = external_calls[key]
  args = [call.src[i+1] for i in slots]
  if after is not None and args: args[-1] = args[-1].after(after)
  invoke = body.call(*(arg.index(UOp.const(0, dtypes.int)) if arg.addrspace is not AddrSpace.ALU and arg.shape else arg for arg in args))
  # Compiling a body can remove unused parameters; retain their incoming effects even then.
  return UOp.group(invoke, *(arg for i,arg in enumerate(call.src[1:]) if i not in slots), *([after] if after is not None and not args else []))

block_cache:dict[tuple, tuple[UOp, list[UOp]]] = {}

def instruction_chunks(instructions:list[tuple[int, InstructionCall]], size:int) -> Iterator[list[tuple[int, InstructionCall]]]:
  # Choose boundaries from instruction bodies, so an insertion needn't invalidate every following block.
  start = code_hash = 0
  for i,(_,info) in enumerate(instructions):
    code_hash = ((code_hash << 1) + int.from_bytes(info[0].body.key[:4], "little")) & (size-1)
    length = i-start+1
    if length >= max(size//4, 1) and (code_hash == 0 or length >= size*2):
      yield instructions[start:i+1]
      start = i+1
  if start < len(instructions): yield instructions[start:]

@functools.cache
def has_effects(body:UOp) -> bool:
  return any(u.op in (Ops.STORE, Ops.CALL) for u in body.toposort())

def instruction_block(instructions:list[tuple[int, InstructionCall]], backend:str) -> tuple[UOp, list[UOp]]:
  key = (backend, tuple((off, template, tuple(bufs), offsets) for off,(template,bufs,offsets,_) in instructions))
  if key not in block_cache:
    bufs = sorted({b for _,(_,bs,_,_) in instructions for b in bs}, key=lambda b:b.arg.slot)
    base = UOp.param(len(bufs), dtypes.uint64, name="code_base", addrspace=AddrSpace.ALU)
    params = {b:b.param_like(i, name=b.arg.name) for i,b in enumerate(bufs)}
    inst = None
    for off,(template,bs,offsets,_) in instructions:
      args = [params[b] for b in bs]
      inst = external_call(template.replace(src=(template.body, *args,
                           *(base+UOp.const(off+i, dtypes.uint64) if off+i else base for i in offsets))), backend, after=inst)
    body = UOp.sink(inst)
    block_cache[key] = body, bufs
  return block_cache[key]

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

@functools.cache
def decode_cfg(lib_bytes:bytes, arch:str):
  insts = amd_decode(lib_bytes, arch)
  return insts, get_cfg(insts, render=False)["data"]

def lift_dispatch(lib:int, lib_sz:int, gx:int, gy:int, gz:int, lx:int, ly:int, lz:int, rsrc2:int, scratch_size:int, arch:str,
                  user_data:list[int]|None, backend:str) -> UOp|None:
  lib_bytes = ctypes.string_at(lib, lib_sz)
  dispatch = (gx, gy, gz, lx, ly, lz, rsrc2, scratch_size, tuple(0 if i < 2 else v for i,v in enumerate(user_data)) if user_data else None)
  renderer = backend_renderer(backend)
  key = (lib_bytes, arch, backend, dispatch[3:], type(renderer), renderer.target, *(x.value for x in to_program_config))
  if key not in dispatch_cache:
    # The region scheduler is still needed when barriers synchronize multiple waves.
    if lx*ly*lz > _wave_size(arch) and any(_is_barrier(inst) for inst in decode_cfg(lib_bytes, arch)[0].values()):
      dispatch_cache[key] = None
    else: dispatch_cache[key] = _lift(lib_bytes, arch, backend, 0, dispatch)
  return dispatch_cache[key]

dispatch_cache:dict[tuple, UOp|None] = {}

@rewrite_group(name=lambda *args,ret,**_: TracingKey(f"Lift {(k:=ret.src[0].arg).name}", (("lift", k.function_name),)))
def lift(lib: int, lib_sz: int, arch: str = "rdna3", backend: str|None = None, entry: int = 0) -> UOp:
  backend = getenv("ASM_CALL_BACKEND", "LLVM") if backend is None else backend
  lib_bytes = ctypes.string_at(lib, lib_sz)
  renderer = backend_renderer(backend)
  # Code addresses are runtime arguments, so identical bytes can share a program across allocations.
  key = (lib_bytes, arch, backend, entry, type(renderer), renderer.target, *(x.value for x in to_program_config))
  if key not in lift_cache: lift_cache[key] = _lift(lib_bytes, arch, backend, entry)
  return lift_cache[key]

def _lift(lib_bytes:bytes, arch:str, backend:str, entry:int, dispatch:tuple|None=None) -> UOp:
  lib_sz = len(lib_bytes)
  # decode
  insts, cached_cfg = decode_cfg(lib_bytes, arch)
  barriers = {off:off+inst.size() for off,inst in insts.items() if _is_barrier(inst)}
  cfg:dict[str, dict] = {"blocks":{pc:list(block) for pc,block in cached_cfg["blocks"].items()},
         "paths":{pc:dict(paths) for pc,paths in cached_cfg["paths"].items()}}
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
  temporaries = itertools.count(6)  # reserve 0..5 for the register, LDS, and scratch allocations
  resume = UOp.param(6, dtypes.uint64, 1, name="resume")
  code_addr = UOp.param(7, dtypes.uint64, name="code_addr", addrspace=AddrSpace.ALU)

  if dispatch is not None:
    gx, gy, gz, lx, ly, lz, rsrc2, scratch_size, user_data = dispatch
    # construct CALL graph
    wave_size, total_threads = _wave_size(arch), lx*ly*lz
    n_waves = (total_threads+wave_size-1)//wave_size
    gx = UOp.variable("groups_x", 1, dtypes.uint32.max, dtypes.uint32)
    gy = UOp.variable("groups_y", 1, dtypes.uint32.max, dtypes.uint32)
    wg = UOp.range(UOp.variable("groups", 0, dtypes.uint64.max, dtypes.uint64), 0)
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
    # Keep grid dimensions unsigned: mixing the uint64 workgroup index with int32 promotes division/modulo to floats.
    dims = [gx, gy, lx, ly, total_threads]
    if getenv("ASM_CALL_EXTERN", 1): dims = [gx, gy, *(UOp.const(x, dtypes.int) for x in dims[2:])]
    init = init_wave(wg, wave, sgpr, vgpr, lds, args_ptr, *dims, wave_size, lds_size, scratch_size, rsrc2, arch,
                     user_data, *([accvgpr] if wave_size == 64 else []))
    init = external_call(init, backend)
    ctx = _Ctx(4, wave_size)
    afters = {ctx.sgpr:sgpr.after(init), ctx.vgpr:vgpr.after(init), ctx.vmem:ctx.vmem,
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

  @functools.cache
  def block_instructions(block_pc:int):
    cond = UOp.const(True)
    instructions = []
    for off in cfg["blocks"][block_pc]:
      inst = insts[off]
      inst_st = str(inst)
      if inst_st.startswith("s_code_end"): continue
      if inst_st.startswith(("s_getpc", "s_setpc")): raise AssertionError("getpc and setpc are not allowed in ASM_CALL")
      template, bufs, word_offsets, branch_cond = instruction_call(inst, arch)
      if branch_cond is not None: cond = branch_cond
      if branch_cond is None and not has_effects(template.body): continue
      instructions.append((off, (template, bufs, word_offsets, branch_cond)))
    return instructions, cond

  chunk_size = getenv("ASM_CALL_BLOCK", 128) if getenv("ASM_CALL_EXTERN", 1) and backend in {"CPU", "LLVM"} else 1

  def emit_block(block_pc:int, scopes:tuple[UOp, ...]) -> UOp:
    instructions, cond = block_instructions(block_pc)
    for chunk in instruction_chunks(instructions, chunk_size):
      off, (template, bufs, word_offsets, _) = chunk[0]
      if chunk_size > 1:
        body, bufs = instruction_block([((pc-off)//4, info) for pc,info in chunk], backend)
        template, word_offsets = body.call(*bufs, UOp.const(0, dtypes.uint64)), (0,)
      args = [afters.get(b, b).after(*scopes) for b in bufs]
      call = template.replace(src=(template.body, *args, *((code_addr>>2)+(off//4+i) for i in word_offsets)))
      call = external_call(call, backend, flat=chunk_size > 1)
      # CALL consumes argument ranges; restore the enclosing control-flow scopes.
      afters.update((b, arg.without_after.after(call, *scopes)) for b, arg in zip(bufs, args))
    if dispatch is None and not cfg["paths"][block_pc]:
      ptr = resume.after(*afters.values()).after(*scopes)
      afters[resume] = ptr.after(ptr[0].store(code_addr+resumes[block_pc] if block_pc in resumes else ENDPGM_PC))
    return cond.substitute(afters, walk=True)
  emit_region(entry, members, (wg, wave) if dispatch is not None else ())
  body = UOp.group(*afters.values())
  if dispatch is not None: body = body.end(wave).end(wg)
  # Operand bits are read from the runtime code pointer; identical call graphs can share machine code.
  name = f"asm_call_{arch}_{body.key.hex()[:16]}_{entry}"
  sink = UOp.sink(body, arg=KernelInfo(name=name, opts_to_apply=())).rtag(1)
  with Context(NOOPT=1, CHECK_OOB=0, TUPLE_ORDER=0, EMULATED_DTYPES="", CAPTURE_PROCESS_REPLAY=0):
    renderer = backend_renderer(backend, fast_compile=True)
    return call_program(sink, renderer) if getenv("ASM_CALL_EXTERN", 1) and backend in {"CPU", "LLVM"} else to_program(sink, renderer)
