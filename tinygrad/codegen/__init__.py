from typing import cast
from dataclasses import replace
import itertools, atexit
from tinygrad.helpers import DISABLE_FAST_IDIV, TRANSCENDENTAL, SPEC, DEBUG, VIZ, IMAGE, NOOPT, EMULATED_DTYPES, NOLOCALS, USE_TC, FAST_TRANSPOSE
from tinygrad.helpers import ALLOW_TF32, TracingKey, Context, panic, getenv
from tinygrad.uop.ops import PatternMatcher, graph_rewrite, UOp, pm_lower_index_dtype, Ops, UPat, track_rewrites, KernelInfo, ProgramInfo
from tinygrad.uop.render import pyrender
from tinygrad.uop.spec import type_verify, spec_tensor, spec_program
from tinygrad.renderer import Renderer, Estimates
from tinygrad.renderer.isa import ISARenderer, IselContext, PreRegAllocContext
from tinygrad.dtype import dtypes

fast_gather_counter = {"used": 0, "todos": []}
def _fast_gather_report():
  print(f"fast_gather: {fast_gather_counter['used']} used, {len(fast_gather_counter['todos'])} not used")
  if (DEBUG >= 2 or getenv("PRINT_TODOS")) and fast_gather_counter["todos"]:
    from collections import Counter
    for msg, cnt in Counter(fast_gather_counter["todos"]).most_common(): print(f"  {cnt:3d}x {msg}")
atexit.register(_fast_gather_report)
def _fast_gather_no(msg:str) -> None: fast_gather_counter["todos"].append(msg)

fast_transpose_counter = {"used": 0, "todos": []}
def _fast_transpose_report():
  print(f"fast_transpose: {fast_transpose_counter['used']} used, {len(fast_transpose_counter['todos'])} not used")
  if (DEBUG >= 2 or getenv("PRINT_TODOS")) and fast_transpose_counter["todos"]:
    from collections import Counter
    for msg, cnt in Counter(fast_transpose_counter["todos"]).most_common(): print(f"  {cnt:3d}x {msg}")
atexit.register(_fast_transpose_report)
def _fast_transpose_no(msg:str) -> None: fast_transpose_counter["todos"].append(msg)

def fp8_transpose_config(rows:int, cols:int) -> tuple[int, tuple[int, int, int]]:
  tile = 256 if (rows, cols) in {(4096, 4096), (6144, 4096)} else 512
  local_size = (16, 16, 4) if tile == 512 else (16, 16, 1)
  return tile, local_size

def fp8_transpose_source(name:str, rows:int, cols:int, tile:int) -> str:
  threads = 1024 if tile == 512 else 256
  r_expr = "g0*512 + l2*128 + (l0>>1)*16" if tile == 512 else "g0*256 + (l1>>3)*128 + (l0>>1)*16"
  c_expr = "g1*512 + l1*32 + (l0&1)*16" if tile == 512 else "g1*256 + (l1&7)*32 + (l0&1)*16"
  args = ", ".join(f"hip_fp8 a{i}" for i in range(16))
  vals = ",".join(f"a{i}" for i in range(16))
  lines = [f'''typedef long unsigned int size_t;
typedef unsigned char hip_fp8;
typedef hip_fp8 hip_fp816 __attribute__((ext_vector_type(16)));
extern "C" __attribute__((device, const)) size_t __ockl_get_local_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_group_id(unsigned int);
static inline __attribute__((device)) hip_fp816 make_hip_fp816({args}) {{ return {{{vals}}}; }}
extern "C" __attribute__((global)) void __attribute__((amdgpu_flat_work_group_size({threads}, {threads}))) {name}(hip_fp8* __restrict__ out, const hip_fp8* __restrict__ in) {{
  int g0 = __ockl_get_group_id(0);
  int g1 = __ockl_get_group_id(1);
  int l0 = __ockl_get_local_id(0);
  int l1 = __ockl_get_local_id(1);
  int l2 = __ockl_get_local_id(2);
  int r = {r_expr};
  int c = {c_expr};
  int base_in = r * {cols} + c;
  int base_out = c * {rows} + r;''']
  for r in range(16): lines.append(f"  hip_fp816 v{r} = *((const hip_fp816*)(in + base_in + {r}*{cols}));")
  for c in range(16):
    vals = ", ".join(f"v{i}[{c}]" for i in range(16))
    lines.append(f"  *((hip_fp816*)(out + base_out + {c}*{rows})) = make_hip_fp816({vals});")
  lines.append("}")
  return "\n".join(lines)

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
  if not getenv("FAST_GATHER"): return None
  if renderer.target.device not in {"AMD","NULL"}: _fast_gather_no(f"only AMD/NULL, got {renderer.target.device}"); return None
  if ast.op is not Ops.SINK or len(ast.src) != 1: _fast_gather_no("ast must be single SINK"); return None
  end = ast.src[0]
  if end.op is not Ops.END or len(end.src) < 1 or (store:=end.src[0]).op is not Ops.STORE or len(store.src) != 2: _fast_gather_no("sink must contain one store"); return None
  idx, val = store.src
  if idx.op is not Ops.INDEX or idx.src[0].op is not Ops.RESHAPE or (out:=idx.src[0].src[0]).op is not Ops.PARAM: _fast_gather_no("output must be reshaped param index"); return None
  if out.dtype.base is not dtypes.bfloat16: _fast_gather_no(f"output must be bf16, got {out.dtype.base}"); return None

  inps: list[UOp] = []
  for term in _flatten_adds(val):
    if term.op is not Ops.WHERE or len(term.src) != 3: _fast_gather_no("terms must be where gates"); return None
    load = zero = None
    if term.src[1].op is Ops.CONST and term.src[1].arg == 0: zero, load = term.src[1], term.src[2]
    elif term.src[2].op is Ops.CONST and term.src[2].arg == 0: load, zero = term.src[1], term.src[2]
    else: _fast_gather_no("where gates must select load or zero"); return None
    if load.op is not Ops.INDEX or len(load.src) < 2: _fast_gather_no("gated value must be index load"); return None
    inp, load_idx = load.src[0], load.src[1]
    if inp.op is not Ops.PARAM or inp.dtype.base != out.dtype.base: _fast_gather_no("input must be matching param"); return None
    if load_idx.op is not Ops.WHERE: _fast_gather_no("load index must be gated"); return None
    inps.append(inp)

  if not inps or sorted(x.arg.slot for x in inps) != list(range(1, len(inps)+1)): _fast_gather_no("input slots must be dense from 1"); return None
  in_size, out_size = inps[0].max_numel(), out.max_numel()
  if any(x.max_numel() != in_size for x in inps) or out_size != in_size * len(inps): _fast_gather_no("output size must equal concat input sizes"); return None
  elems_per_thread, threads = 16, 256
  if in_size % (elems_per_thread * threads) != 0: _fast_gather_no("input size must align to vectorized copy"); return None

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

def _try_fast_transpose_program(ast:UOp, renderer:Renderer) -> UOp|None:
  if not FAST_TRANSPOSE: return None
  if renderer.target.device not in {"AMD","NULL"}: _fast_transpose_no(f"only AMD/NULL, got {renderer.target.device}"); return None
  if ast.op is not Ops.SINK or len(ast.src) != 1: _fast_transpose_no("ast must be single SINK"); return None
  end = ast.src[0]
  if end.op is not Ops.END or len(end.src) < 1 or (store:=end.src[0]).op is not Ops.STORE or len(store.src) != 2: _fast_transpose_no("sink must contain one store"); return None
  idx, val = store.src
  if idx.op is not Ops.INDEX or val.op is not Ops.INDEX: _fast_transpose_no("store must be index to index"); return None
  out, inp = idx.src[0], val.src[0]
  if out.op is not Ops.PARAM or inp.op is not Ops.PARAM or (out.arg.slot, inp.arg.slot) != (0, 1): _fast_transpose_no("params must be output slot 0 and input slot 1"); return None
  if out.dtype.base is not dtypes.fp8e4m3 or inp.dtype.base is not dtypes.fp8e4m3: _fast_transpose_no(f"transpose dtype not included {inp.dtype.base}->{out.dtype.base}"); return None
  ranges = end.src[1:]
  if len(ranges) != 2 or any(r.op is not Ops.RANGE for r in ranges): _fast_transpose_no("transpose must have two ranges"); return None
  rows, cols = ranges[1].src[0].arg, ranges[0].src[0].arg
  def _is_linear_index(u:UOp, outer:UOp, stride:int, inner:UOp) -> bool:
    if u.op is not Ops.ADD or len(u.src) != 2: return False
    a, b = u.src
    if b is not inner: return False
    return a.op is Ops.MUL and len(a.src) == 2 and a.src[0] is outer and a.src[1].op is Ops.CONST and a.src[1].arg == stride
  if not _is_linear_index(idx.src[1], ranges[0], rows, ranges[1]) or not _is_linear_index(val.src[1], ranges[1], cols, ranges[0]):
    _fast_transpose_no("not a pure 2D transpose"); return None
  allowed_shapes = {(16384, 28672), (4096, 14336), (28672, 4096), (4096, 4096), (6144, 4096), (16384, 4096), (16384, 6144)}
  if (rows, cols) not in allowed_shapes or out.max_numel() != rows*cols or inp.max_numel() != rows*cols:
    _fast_transpose_no(f"transpose shape not included ({rows},{cols})->({cols},{rows})"); return None

  name = f"custom_fp8_transpose_{rows}_{cols}"
  fast_transpose_counter["used"] += 1
  tile, local_size = fp8_transpose_config(rows, cols)
  source = fp8_transpose_source(name, rows, cols, tile)
  sink = ast.replace(arg=replace(ast.arg, name=name, estimates=Estimates(ops=0, mem=rows*cols*2)))
  info = ProgramInfo(name=name, global_size=(rows//tile, cols//tile, 1), local_size=local_size, globals=(0, 1), outs=(0,), ins=(1,))
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
    fast_prg = _try_fast_transpose_program(ast, renderer)
    if fast_prg is None: fast_prg = _try_fast_gather_program(ast, renderer)
    if fast_prg is not None:
      if VIZ:
        graph_rewrite(ast, PatternMatcher([]), name="View Base AST")
        graph_rewrite(fast_prg, PatternMatcher([]), name="View Program")
      return fast_prg
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
  config = (NOOPT, EMULATED_DTYPES, NOLOCALS, USE_TC, IMAGE, DISABLE_FAST_IDIV, TRANSCENDENTAL, ALLOW_TF32, FAST_TRANSPOSE)
  key = (ast.key, type(renderer), renderer.target, *[x.value for x in config])
  if (prg:=to_program_cache.get(key)) is None: to_program_cache[key] = prg = do_to_program(ast, renderer)
  return prg
