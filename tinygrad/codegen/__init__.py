from typing import cast
from dataclasses import replace
import itertools, atexit
from tinygrad.helpers import DISABLE_FAST_IDIV, TRANSCENDENTAL, SPEC, DEBUG, VIZ, IMAGE, NOOPT, EMULATED_DTYPES, NOLOCALS, USE_TC
from tinygrad.helpers import ALLOW_TF32, TracingKey, Context, panic
from tinygrad.uop.ops import PatternMatcher, graph_rewrite, UOp, pm_lower_index_dtype, Ops, UPat, track_rewrites, KernelInfo, ProgramInfo
from tinygrad.uop.render import pyrender
from tinygrad.uop.spec import type_verify, spec_tensor, spec_program
from tinygrad.renderer import Renderer, Estimates
from tinygrad.renderer.isa import ISARenderer, IselContext, PreRegAllocContext
from tinygrad.dtype import dtypes

fast_gather_counter = {"used": 0}
def _fast_gather_report():
  if fast_gather_counter["used"]: print(f"fast_gather: {fast_gather_counter['used']} used")
atexit.register(_fast_gather_report)

# import all pattern matchers here
from tinygrad.codegen.gpudims import pm_add_gpudims
from tinygrad.uop.symbolic import sym, symbolic_simple, gep_pushing, symbolic, pm_move_where_on_load
from tinygrad.uop.decompositions import get_late_rewrite_patterns, get_transcendental_patterns, pm_dtype_decomps
from tinygrad.codegen.late.expander import expander, pm_pre_expander, pm_group_for_reduce
from tinygrad.codegen.late.devectorizer import load_store_folding, load_store_indexing, devectorize_buf_and_index, devectorize_alu, pm_reduce, \
  ReduceContext, correct_load_store, pm_render, pm_add_loads, pm_make_images
from tinygrad.codegen.opt.postrange import apply_opts
from tinygrad.codegen.late.gater import pm_move_gates_from_index
from tinygrad.codegen.simplify import pm_simplify_ranges, pm_flatten_range, pm_split_ranges, pm_load_collapse
from tinygrad.schedule.rangeify import pm_add_buffers_local, rangeify_codegen, pm_mops, pm_syntactic_sugar, pm_store_ranges
from tinygrad.codegen.late.linearizer import CFGContext, pm_split_ends, pm_add_control_flow, linearize
from tinygrad.codegen.late.regalloc import LinearScanRegallocContext, pm_regalloc_rewrite

def full_rewrite_to_sink(ast:UOp, ren:Renderer, optimize:bool=True) -> UOp:
  if VIZ: graph_rewrite(ast, PatternMatcher([]), name="View Base AST")
  if DEBUG >= 5: print(pyrender(ast))
  if SPEC: type_verify(ast, spec_tensor)

  # preprocess
  sink = graph_rewrite(ast, pm_mops+pm_syntactic_sugar+pm_store_ranges, ctx=itertools.count(1000), name="early movement ops", bottom_up=True)

  # first we optimize
  if optimize:
    # collapse loads reduce (indexing by a tensor)
    sink = graph_rewrite(sink, pm_load_collapse, name="load collapse")

    # split ranges
    sink = graph_rewrite(sink, pm_split_ranges+pm_flatten_range, ctx={}, name="split ranges")

    # symbolic (NOTE: this is a requirement for pm_simplify_ranges to be correct)
    sink = graph_rewrite(sink, sym+pm_flatten_range, name="initial symbolic")

    # optimize (schedule) the AST
    sink = graph_rewrite(sink, pm_flatten_range+pm_simplify_ranges, ctx={}, name="simplify ranges")

    # do postrange optimization, BEAM or hand_coded_optimizations
    sink = apply_opts(sink, ren, beam=ast.arg.beam)

  # ** expander (expand_rewrite) **
  sink = graph_rewrite(sink, sym+pm_move_where_on_load, name="postopt symbolic")

  # expand
  sink = graph_rewrite(sink, sym+pm_pre_expander+pm_group_for_reduce+expander, name="expander")

  # add locals
  sink = graph_rewrite(sink, pm_add_buffers_local+rangeify_codegen, ctx=itertools.count(0), name="add local buffers")

  # ** devectorizer (full_graph_rewrite) **
  # remove reduce
  sink = graph_rewrite(sink, pm_reduce+gep_pushing, ctx=ReduceContext(), name="remove_reduce")

  # add gpu dims (late). this works after devectorize, but it's faster here
  sink = graph_rewrite(sink, pm_add_gpudims, ctx=ren, name="add gpudims")

  # **** optimizations are done, now we lower to actual code ****

  # add loads
  sink = graph_rewrite(sink, pm_add_loads, name="** add loads (code)")

  # create image buffers
  if IMAGE and ren.target.device in {"QCOM", "CL", "PYTHON", "NULL"}:
    sink = graph_rewrite(sink, pm_make_images, name="create image buffers", bottom_up=True, ctx=ren.target.arch)

  # devectorize
  sink = graph_rewrite(sink, sym+devectorize_alu+devectorize_buf_and_index+load_store_folding+correct_load_store+load_store_indexing,
                       ctx=ren, name="devectorize")

  # lower the index dtype to a concrete int
  sink = graph_rewrite(sink, pm_lower_index_dtype+load_store_indexing+gep_pushing, name="lower all index dtypes")
  sink = graph_rewrite(sink, symbolic, name="post index symbolic")

  # optional pre matcher
  if ren.pre_matcher is not None: sink = graph_rewrite(sink, ren.pre_matcher, name="pre_matcher")

  # decompositions
  supported_ops = tuple(ren.code_for_op.keys())
  pm_decomp = symbolic_simple+get_late_rewrite_patterns(supported_ops, bool(DISABLE_FAST_IDIV))
  pm_transcendental = symbolic_simple+get_transcendental_patterns(supported_ops, TRANSCENDENTAL>=2)
  sink = graph_rewrite(sink, pm_decomp, ctx=ren, name="decompositions")
  sink = graph_rewrite(sink, pm_dtype_decomps, ctx=(set(), ren), name="decomp dtypes")
  sink = graph_rewrite(sink, pm_transcendental, name="transcendental")

  # move gates from unrenderable INVALID where
  sink = graph_rewrite(sink, pm_move_gates_from_index, name="move gates from index")

  # final rules for the renderer (without sym)
  extra_matcher = ren.extra_matcher if ren.extra_matcher is not None else PatternMatcher([])
  pm_final_rewrite = pm_decomp+pm_render+extra_matcher+pm_split_ends
  sink = graph_rewrite(sink, pm_final_rewrite, ctx=ren, name="final rewrite")

  # this was the linearizer
  sink = graph_rewrite(sink, pm_add_control_flow, ctx=CFGContext(sink), name="add control flow", bottom_up=True)

  if VIZ: graph_rewrite(sink, PatternMatcher([]), name="View Output AST")
  if SPEC: type_verify(sink, spec_program)

  # return the rewritten sink
  return sink

# inject IF/ENDIF. only needed if device doesn't support gated stores
pm_linearize_cleanups = PatternMatcher([
  # if statements are not allowed in the graph
  (UPat((Ops.IF, Ops.ENDIF)), lambda: panic(RuntimeError, "if not allowed in graph")),
  # gated STORE becomes IF-STORE-ENDIF. this is the only use of IF-ENDIF
  (UPat(Ops.STORE, name="u", src=(UPat(Ops.INDEX).or_casted(), UPat(), UPat(name="gate", dtype=dtypes.bool))),
   lambda u, gate: ((st:=u.replace(src=u.src[0:2])), [mif:=UOp(Ops.IF, src=(gate, u.src[0])), st, UOp(Ops.ENDIF, src=(mif,))]))
])

# requires lst be toposorted. like graph rewrite, but for lines
def line_rewrite(lst:list[UOp], pm:PatternMatcher, ctx=None) -> list[UOp]:
  newlst = []
  replaced: dict[UOp, UOp] = {}
  for u in lst:
    nu = u.replace(src=tuple([replaced.get(x, x) for x in u.src]))
    ret: tuple[UOp, list[UOp]] = cast(tuple[UOp, list[UOp]]|None, pm.rewrite(nu, ctx)) or (nu, [nu])
    replaced[u] = ret[0]
    newlst.extend(ret[1])
  return newlst

def do_linearize(ctx:Renderer, prg:UOp, sink:UOp) -> UOp:
  if DEBUG >= 3 and sink.arg.applied_opts: print(f"{sink.arg.function_name:<25} opts: {sink.arg.applied_opts}")
  lst = line_rewrite(linearize(sink), pm_linearize_cleanups)
  # isa renderers need to allocate registers
  if isinstance(ctx, ISARenderer):
    if ctx.pre_regalloc_matcher is not None: lst = line_rewrite(lst, ctx.pre_regalloc_matcher, PreRegAllocContext())
    regalloc_ctx = LinearScanRegallocContext(lst, ctx)
    lst = line_rewrite(lst, pm_regalloc_rewrite, regalloc_ctx)
    lst = line_rewrite(lst, ctx.post_regalloc_matcher, regalloc_ctx)
    if DEBUG >= 4: print(ctx.asm_str(lst, sink.arg.function_name))
  return prg.replace(src=prg.src + (UOp(Ops.LINEAR, src=tuple(lst)),))

def do_estimates(prg:UOp, sink:UOp, lin:UOp) -> UOp|None:
  if sink.arg.estimates is not None: return None
  return prg.replace(src=(sink.replace(arg=replace(sink.arg, estimates=Estimates.from_uops(lin.src, ignore_indexing=True))),)+prg.src[1:])

def do_assemble(ctx:Renderer, prg:UOp, lin:UOp) -> UOp:
  src = "\n".join(str(u.arg) for u in lin.src)
  if DEBUG >= 4: print(src)
  binary = ctx.asm(prg, lin)
  return prg.replace(src=prg.src[:3]+(UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=binary)))

def do_render(ctx:Renderer, prg:UOp, lin:UOp) -> UOp:
  src = ctx.render(list(lin.src))
  new_arg = replace(prg.arg, aux=tuple(ctx.aux(list(lin.src)))) if ctx.has_aux else prg.arg
  return prg.replace(src=prg.src + (UOp(Ops.SOURCE, arg=src),), arg=new_arg)

def do_compile(ctx:Renderer, prg:UOp, source:UOp) -> UOp|None:
  if DEBUG >= 4: print(source.arg)
  lib = ctx.compiler.compile_cached(source.arg)
  if DEBUG >= 7: ctx.compiler.disassemble(lib)
  return prg.replace(src=prg.src + (UOp(Ops.BINARY, arg=lib),))

pm_to_program = PatternMatcher([
  (UPat(Ops.PROGRAM, src=(UPat(Ops.SINK, name="sink"), UPat(Ops.DEVICE)), name="prg"), do_linearize),
  (UPat(Ops.PROGRAM, src=(UPat(Ops.SINK, name="sink"), UPat(Ops.DEVICE), UPat(Ops.LINEAR, name="lin")), name="prg"), do_estimates),
  (UPat(Ops.PROGRAM, src=(UPat(), UPat(Ops.DEVICE), UPat(Ops.LINEAR, src=UPat(Ops.INS), name="lin")), name="prg"), do_assemble),
  (UPat(Ops.PROGRAM, src=(UPat(), UPat(Ops.DEVICE), UPat(Ops.LINEAR, name="lin")), name="prg"), do_render),
  (UPat(Ops.PROGRAM, src=(UPat(), UPat(Ops.DEVICE), UPat(Ops.LINEAR), UPat(Ops.SOURCE, name="source")), name="prg"), do_compile),
])

def _flatten_adds(u:UOp) -> list[UOp]:
  return _flatten_adds(u.src[0]) + _flatten_adds(u.src[1]) if u.op is Ops.ADD else [u]

def _try_fast_gather_program(ast:UOp, renderer:Renderer) -> UOp|None:
  if renderer.target.device not in {"AMD","NULL"} or ast.op is not Ops.SINK or len(ast.src) != 1: return None
  end = ast.src[0]
  if end.op is not Ops.END or len(end.src) < 1 or (store:=end.src[0]).op is not Ops.STORE or len(store.src) != 2: return None
  idx, val = store.src
  if idx.op is not Ops.INDEX or idx.src[0].op is not Ops.RESHAPE or (out:=idx.src[0].src[0]).op is not Ops.PARAM: return None
  if out.dtype.base is not dtypes.bfloat16: return None

  inps: list[UOp] = []
  for term in _flatten_adds(val):
    if term.op is not Ops.WHERE or len(term.src) != 3: return None
    load = zero = None
    if term.src[1].op is Ops.CONST and term.src[1].arg == 0: zero, load = term.src[1], term.src[2]
    elif term.src[2].op is Ops.CONST and term.src[2].arg == 0: load, zero = term.src[1], term.src[2]
    else: return None
    if load.op is not Ops.INDEX or len(load.src) < 2: return None
    inp, load_idx = load.src[0], load.src[1]
    if inp.op is not Ops.PARAM or inp.dtype.base != out.dtype.base: return None
    if load_idx.op is not Ops.WHERE: return None
    inps.append(inp)

  if not inps or sorted(x.arg.slot for x in inps) != list(range(1, len(inps)+1)): return None
  in_size, out_size = inps[0].max_numel(), out.max_numel()
  if any(x.max_numel() != in_size for x in inps) or out_size != in_size * len(inps): return None
  elems_per_thread, threads = 16, 256
  if in_size % (elems_per_thread * threads) != 0: return None

  name = f"custom_gather_{out_size}_{in_size}"
  fast_gather_counter["used"] += 1
  args = ",\n    ".join([f"hip_bfloat16* data0_{out_size}"] + [f"hip_bfloat16* data{i}_{in_size}" for i in range(1, len(inps)+1)])
  srcs = ", ".join(f"(u32x4*)data{i}_{in_size}" for i in range(1, len(inps)+1))
  vecs_per_input = in_size // 8
  groups_per_input = in_size // (elems_per_thread * threads)
  source = f'''typedef long unsigned int size_t;
typedef __bf16 hip_bfloat16;
typedef unsigned int u32x4 __attribute__((ext_vector_type(4)));
extern "C" __attribute__((device, const)) size_t __ockl_get_local_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_group_id(unsigned int);
extern "C" __attribute__((global)) void __attribute__((amdgpu_flat_work_group_size(1, {threads}))) {name}(
    {args}) {{
  int tid = __ockl_get_local_id(0);
  int gid = __ockl_get_group_id(0);
  int shard = __ockl_get_group_id(1);
  int local_v = (gid * {threads} + tid) * 2;
  int v = shard * {vecs_per_input} + local_v;
  u32x4 *dst = (u32x4*)data0_{out_size};
  u32x4 *srcs[{len(inps)}] = {{{srcs}}};
  u32x4 *src = srcs[shard];
  dst[v] = src[local_v];
  dst[v+1] = src[local_v+1];
}}'''
  sink = ast.replace(arg=replace(ast.arg, name=name, estimates=Estimates(ops=0, mem=out_size*out.dtype.itemsize*2)))
  info = ProgramInfo(name=name, global_size=(groups_per_input, len(inps), 1), local_size=(threads, 1, 1), globals=tuple(range(len(inps)+1)),
                     outs=(0,), ins=tuple(range(1, len(inps)+1)))
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=renderer.target.device), UOp(Ops.LINEAR, dtypes.void), UOp(Ops.SOURCE, arg=source),
                             UOp(Ops.BINARY, arg=renderer.compiler.compile_cached(source))), arg=info)

@track_rewrites(name=lambda ast,renderer,ret,**kwargs: TracingKey(ret.src[0].arg.name,(ret.src[0].arg.function_name, ast), ret=renderer), replay=True)
@Context(ALLOW_DEVICE_USAGE=0)
def do_to_program(ast:UOp, renderer:Renderer) -> UOp:
  """
  Transform an AST into a compiled PROGRAM. May trigger BEAM search.

  Args:
    ast: The Ops.SINK/Ops.PROGRAM rooted AST
    renderer: The renderer used to generate the code

  Returns:
    The Ops.PROGRAM with SINK/DEVICE/LINEAR/SOURCE/BINARY.
  """
  if ast.op is Ops.PROGRAM: prg = ast
  elif ast.op is Ops.SINK:
    assert isinstance(ast.arg, KernelInfo), "requires KernelInfo on arg to to_program"
    if (fast_prg:=_try_fast_gather_program(ast, renderer)) is not None: return fast_prg
    full_sink = full_rewrite_to_sink(ast, renderer, optimize=ast.tag is None)
    prog_info = ProgramInfo.from_sink(full_sink)
    # instruction selection
    if isinstance(renderer, ISARenderer):
      full_sink = graph_rewrite(full_sink, renderer.pre_isel_matcher, ctx=itertools.count(-1, -1), name="pre instruction selection", bottom_up=True)
      full_sink = graph_rewrite(full_sink, renderer.isel_matcher, ctx=IselContext(full_sink), name="instruction selection", bottom_up=True)
    prg = UOp(Ops.PROGRAM, src=(full_sink, UOp(Ops.DEVICE, arg=renderer.target.device)), arg=prog_info)
  else: raise RuntimeError(f"can't call to_program on {ast.op}")
  if not isinstance(prg.arg, ProgramInfo): prg = prg.replace(arg=ProgramInfo.from_sink(prg.src[0]))
  prg = graph_rewrite(prg, pm_to_program, ctx=renderer, name="linearize/render")
  if VIZ: graph_rewrite(prg, PatternMatcher([]), name="View Program")
  return prg

to_program_cache: dict[tuple, UOp] = {}
def to_program(ast:UOp, renderer:Renderer) -> UOp:
  config = (NOOPT, EMULATED_DTYPES, NOLOCALS, USE_TC, IMAGE, DISABLE_FAST_IDIV, TRANSCENDENTAL, ALLOW_TF32)
  key = (ast.key, type(renderer), renderer.target, *[x.value for x in config])
  if (prg:=to_program_cache.get(key)) is None: to_program_cache[key] = prg = do_to_program(ast, renderer)
  return prg
