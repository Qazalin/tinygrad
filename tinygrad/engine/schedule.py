import sys, atexit, pickle
from collections import defaultdict, deque
from dataclasses import dataclass
from tinygrad.ops import UOp, Variable, Ops, GroupOp, PatternMatcher, UPat, graph_rewrite, graph_rewrite_map, track_rewrites, buffers
from tinygrad.ops import can_pad, identity_element, resolve, merge_views
from tinygrad.codegen.symbolic import symbolic_simple
from tinygrad.helpers import Context, ContextVar, Metadata, all_int, all_same, colored, diskcache_put, prod, dedup, unwrap, flatten, getenv, pluralize
from tinygrad.helpers import FUSE_CONV_BW, FUSE_ARANGE, DEBUG, CAPTURE_PROCESS_REPLAY, DONT_REALIZE_EXPAND, SPLIT_REDUCEOP
from tinygrad.dtype import ImageDType
from tinygrad.shape.shapetracker import ShapeTracker
from tinygrad.shape.view import View, strides_for_shape
from tinygrad.device import Buffer
from tinygrad.spec import type_verify, kernel_spec

# creation can recurse a lot
sys.setrecursionlimit(10000)

# **** schedule simplifier

def simplify_stride0_reduce(reduce:UOp, x:UOp):
  # must be unmasked (NOTE: can be relaxed if not masked on stride 0 axis)
  if any(v.mask is not None for v in unwrap(x.st).views): return None
  # must have all stride 0 in the relevant axis (NOTE: can do partial)
  if not all(unwrap(x.st).views[-1].strides[axis] == 0 for axis in reduce.arg[1]) or not all_int(x.shape): return None
  prshape = prod(x.shape[i] for i in reduce.arg[1])
  ret = x.shrink(tuple((0,s) if i not in reduce.arg[1] else (0,1) for i,s in enumerate(x.shape)))
  match reduce.arg[0]:
    case Ops.ADD: return ret*prshape
    case Ops.MUL: return ret.pow(prshape)
    case Ops.MAX: return ret # NOTE: Ops.MAX is passthrough

def split_reduceop(reduce:UOp, x:UOp):
  if not SPLIT_REDUCEOP or not all_int(x.shape) or (prod(x.shape)//prod(reduce.shape))<getenv("REDUCEOP_SPLIT_THRESHOLD", 32768): return None
  # if there are few globals, make some reduces into globals by splitting into two kernels
  # cap output buffer to 2**22: heuristic number of global outputs to achieve max occupancy with enough locals+upcasts for gemm
  #   ~2**10 should be enough if GROUP is used
  # 256 split maximum should be "negligible reduce" for low prod(reduce.shape), 8 split minimum.
  # split is moved to the end to provide maximum locality for the second phase reduce.
  real_strides = unwrap(x.st).real_strides(ignore_valid=True)
  if not (split_candidates:=[(i,d) for i in reduce.arg[1] for d in range(min(256,2**getenv("REDUCEOP_SPLIT_SIZE",22)//prod(reduce.shape)),8-1,-1)
                             if x.shape[i]%d==0 and real_strides[i]!=0]): return None
  dim_to_split, divisor = split_candidates[0]
  splitted_shape = x.shape[:dim_to_split]+(divisor,)+(x.shape[dim_to_split]//divisor,)+x.shape[dim_to_split+1:]
  splitted = x.reshape(splitted_shape).permute(tuple([d for d in range(len(splitted_shape)) if d!=dim_to_split]+[dim_to_split]))
  if DEBUG >= 3: print(f"split {divisor}: {x.shape} -> {splitted.shape} -> {reduce.shape}")
  # reduce original axes, then split
  return splitted.r(*reduce.arg).r(reduce.arg[0], (len(reduce.shape),)).reshape(reduce.shape)

def found_contiguous(ctx:dict[UOp, UOp], contig:UOp, src:UOp):
  if (sti:=unwrap(src.st).invert(src.base.shape)) is not None: ctx[src.base] = contig.view(sti)
def replace_contiguous(ctx:dict[UOp, UOp], alu:UOp):
  new_src = list(alu.src)
  for i,s in enumerate(alu.src):
    if (replace_src:=ctx.get(s, None)) is not None: new_src[i] = replace_src
  if tuple(new_src) != alu.src: return alu.replace(src=tuple(new_src))

def create_buffer_view(tr:UOp, x:UOp):
  assert isinstance(tr.device, str), "device must be string"
  if not tr.device.startswith("DISK"): return None
  return UOp(Ops.BUFFER_VIEW, tr.dtype, (x.base,), (tr.size, unwrap(x.st).views[0].offset)).reshape(tr.shape)

sym = symbolic_simple+PatternMatcher([
  # UOp with size 0 is zero
  (UPat(GroupOp.All-{Ops.SINK}, name="root"), lambda root: root.const_like(0) if root.base.st is not None and root.size == 0 \
   and not (root.base.op is Ops.CONST and root.base.arg == 0) else None),
  # DETACH and CONTIGUOUS_BACKWARD are NOOPs here
  (UPat((Ops.DETACH, Ops.CONTIGUOUS_BACKWARD), name="x"), lambda x: x.src[0]),
  # reduce of size 0 is the identity element
  (UPat(Ops.REDUCE_AXIS, name="reduce", src=(UPat.var("x"),)),
   lambda reduce,x: reduce.const_like(identity_element(reduce.arg[0], reduce.dtype)) if x.size == 0 and reduce.size != 0 else None),
  # reduce on stride 0 is collapsed
  (UPat(Ops.REDUCE_AXIS, name="reduce", src=(UPat.var("x"),)), simplify_stride0_reduce),
  # split_reduceop
  (UPat(Ops.REDUCE_AXIS, name="reduce", src=(UPat.var("x"),)), split_reduceop),
  # COPY(CONST) creates a new CONST on the destination device
  (UPat(Ops.COPY, name="root", src=(UPat(), UPat.cvar("x"),)), lambda root,x: root.const_like(x.arg)),
  # no COPY to same device, except clone (arg is True)
  (UPat(Ops.COPY, src=(UPat(), UPat.var("copyin")), name="copy"),
   lambda copyin,copy: copyin if copyin.device == copy.device and copy.arg is not True else None),
  # copyin must be base
  (UPat(Ops.COPY, src=(UPat(), UPat(Ops.VIEW, name="v")), name="copy"), lambda copy,v: v.contiguous().copy_to_device(copy.device) \
    if prod(v.shape) < prod(v.base.shape) else v.base.copy_to_device(copy.device, clone=copy.arg).view(v.st)),
  # remove cast to image when it's already a contiguous image
  (UPat(Ops.CAST, name="cast", src=(UPat(Ops.VIEW, name="vm", src=(UPat(Ops.CONTIGUOUS, name="base"))),)),
   lambda cast,base,vm: base.view(vm.st) if isinstance(cast.dtype, ImageDType) and isinstance(base.dtype, ImageDType) else None),
  # put CAST to smaller dtype before EXPAND
  (UPat(Ops.CAST, name="cast", src=(UPat(Ops.VIEW, name="vm"),)), lambda cast,vm: vm.base.cast(cast.dtype).view(vm.st)
     if (not getenv("CAST_AFTER_EXPAND") or vm.base.op is not Ops.BUFFER) and cast.dtype.itemsize <= vm.dtype.itemsize
     and resolve(prod(vm.shape) > vm.st.real_size()) else None),
  # make things that can't be images not images
  (UPat(GroupOp.All-{Ops.BUFFER, Ops.VIEW, Ops.CONST, Ops.DEVICE}, name="u"), lambda u: u.replace(dtype=dt.base) if isinstance(dt:=u.dtype,ImageDType)
   and (prod(u.shape) != prod(dt.shape) or not any(u.shape[x]%4 == 0 for x in u.st.unit_stride_axes())) else None),
  # remove contiguous if we can just view the buffer
  (UPat(Ops.CONTIGUOUS, name="root", src=(UPat(Ops.VIEW, name="view", src=(UPat(Ops.BUFFER, name="buf"),)),)),
   lambda root,view,buf: view if view.st.contiguous and view.size == buf.size else None),
  # contiguous/buffer/copy is already contiguous
  (UPat(Ops.CONTIGUOUS, name="root", src=(UPat((Ops.CONTIGUOUS, Ops.BUFFER, Ops.COPY)),)), lambda root: root.src[0]),
  # support for using a contiguous permuted view instead of the parent view if one exists
  (UPat(Ops.CONTIGUOUS, name="contig", src=(UPat(Ops.VIEW, name="src"),)), found_contiguous),
  (UPat(GroupOp.ALU, name="alu"), replace_contiguous),
  # substitute BITCAST/CONTIGUOUS with BUFFER_VIEW on DISK
  (UPat((Ops.BITCAST, Ops.CONTIGUOUS), src=(UPat.var("x"),), name="tr"), create_buffer_view),
  # put UnaryOps before EXPANDs
  (UPat(GroupOp.Unary, src=UPat(Ops.VIEW, src=(UPat.var("inp"),), name="v"), name="alu"),
   lambda inp,v,alu: inp.alu(alu.op).view(v.st) if resolve(prod(alu.shape) > v.st.real_size()) else None),
  # put CAST after expanding BUFFER
  (UPat(Ops.VIEW, src=(UPat(Ops.CAST, src=(UPat.var("x"),)),), name="v"), lambda x,v: x.view(x.st+v.st).cast(v.dtype) if getenv("CAST_AFTER_EXPAND")
    and x.base.op is Ops.BUFFER and resolve(prod(v.shape) > prod(x.shape)) else None),
])

remove_movement_ops = merge_views+PatternMatcher([
  # NOTE: movement ops are always applied to base
  (UPat(GroupOp.Movement, name="mov", src=(UPat.var("x"),)), lambda x,mov: x.view(unwrap(mov.st))),
  # some masked views can collapse to 0, VIEW(x) -> CONST(VIEW)
  (UPat(Ops.VIEW, name="view"),
   lambda view: view.const_like(0) if (vm:=view.st.views[-1].mask) is not None and any((x[1]-x[0]) == 0 for x in vm) else None),
])

def do_sink(sink:UOp):
  new_src: list[UOp] = []
  for s in sink.src:
    if s.base.op in {Ops.CONTIGUOUS, Ops.COPY, Ops.ASSIGN}: new_src.append(s)
    else:
      new_src.append(s.base.contiguous())
  return sink.replace(src=n) if (n:=tuple(dedup(new_src))) != sink.src else None

view_left = merge_views+PatternMatcher([
  (UPat(Ops.VIEW, name="vm", src=(UPat(Ops.LOAD, src=(UPat(), UPat.var("st")), name="ld"),)),
   lambda ld,st,vm: UOp(Ops.LOAD, ld.dtype, (ld.src[0], (st.arg+vm.arg).to_uop()))),
  (UPat(Ops.VIEW, name="vm", src=(UPat(GroupOp.All-{Ops.DEVICE, Ops.ASSIGN, Ops.COPY, Ops.CONTIGUOUS, Ops.CONST, Ops.BUFFER, Ops.REDUCE_AXIS}, name="x"),)),
   lambda x,vm: x.replace(src=tuple(s.view(vm.arg) for s in x.src))),
])

insert_contigs = view_left+PatternMatcher([
  (UPat(Ops.SINK, name="sink"), do_sink),
])

@dataclass(frozen=True)
class Kernel:
  ast: UOp
  metadata: tuple[Metadata, ...] = ()
  def __repr__(self): return f"<Kernel {len(list(self.ast.toposort))} {self.ast.op} {self.metadata}>"

def load_buf(ctx:tuple[UOp, ...], x:UOp):
  return UOp.load(UOp(Ops.DEFINE_GLOBAL, x.dtype.ptr(size=x.size), (), ctx.index(x)), unwrap(x.st).to_uop(), dtype=x.dtype)

add_buffer_ops = view_left+PatternMatcher([
  # LOAD
  (UPat(Ops.BUFFER, name="x"), load_buf),
  (UPat(Ops.COPY, src=(UPat(Ops.BUFFER, name="x"), UPat())), load_buf),
  (UPat(Ops.ASSIGN, src=(UPat(Ops.BUFFER, name="x"), UPat())), load_buf),
  # STORE
  (UPat(Ops.SINK, src=UPat(GroupOp.All-{Ops.STORE}), name="x"),
   lambda x: UOp.sink(*[UOp.store(UOp(Ops.DEFINE_GLOBAL, s.dtype.ptr(size=s.size), (), i), unwrap(s.st).to_uop(), s) for i,s in enumerate(x.src)])),
])

DONT_PLACE_IN_KERNEL = {Ops.BUFFER, Ops.COPY, Ops.ASSIGN}

def append_to_kernel(x:UOp):
  new_src: list[UOp] = []
  for s in x.src:
    if s.op in DONT_PLACE_IN_KERNEL: new_src.append(s)
    else: new_src.extend(s.src)
  if (n:=tuple(new_src)) != x.src: return x.replace(src=n)
  ast = graph_rewrite(x.arg.ast, add_buffer_ops, ctx=tuple(s.buf_uop for s in x.src), bottom_up=True)
  return x.replace(arg=Kernel(ast, x.arg.metadata)) if ast is not x.arg.ast else None

create_kernels = merge_views+PatternMatcher([
  (UPat(Ops.CONTIGUOUS, src=(UPat.var("x"),)),
   lambda x: UOp(Ops.ASSIGN, x.dtype, (b:=UOp.new_buffer(x.device, x.size, x.dtype), UOp(Ops.KERNEL, src=(b,)+x.src, arg=Kernel(x.sink()))))),
  (UPat(Ops.ASSIGN, src=(UPat(Ops.BUFFER, name="b"), UPat(GroupOp.All-{Ops.KERNEL}, name="x"))),
   lambda b,x: UOp(Ops.ASSIGN, x.dtype, (b, UOp(Ops.KERNEL, src=(b,)+x.src, arg=Kernel(x.sink()))))),
  (UPat(Ops.COPY, src=(UPat(Ops.DEVICE, name="d"), UPat.var("y"))),
   lambda d,y: UOp(Ops.COPY, y.dtype, src=(UOp.new_buffer(d.arg, y.size, y.dtype), y))),
  # walk back the local graph until we reach BUFFER/COPY/ASSIGN
  (UPat(Ops.KERNEL, name="x"), append_to_kernel),
])

def get_becomes_map(big_sink:UOp) -> dict[UOp, UOp]:
  # remove_movement_ops + sym
  tensor_map = graph_rewrite_map(big_sink, remove_movement_ops+sym, ctx={})

  # display the cleaned up tensor graph
  if getenv("VIZ"): graph_rewrite(tensor_map[big_sink], PatternMatcher([]), name="View Tensor Graph")

  simple_sink = tensor_map[big_sink]
  children: dict[UOp, dict[UOp, None]] = {}
  for u in simple_sink.toposort:
    children[u] = {}
    if u is not simple_sink:
      for s in u.src: children[s][u] = None

  contig_map = graph_rewrite_map(simple_sink, insert_contigs, ctx=children)
  for k,v in contig_map.items():
    if k is v: continue
    if v.op is Ops.CONTIGUOUS:
      tensors = [x for x,y in tensor_map.items() if y is k]
      for t in tensors: tensor_map[t] = v
    if all(s.op is Ops.CONTIGUOUS for s in v.src):
      for s,s2 in zip(k.src, v.src):
        tensors = [x for x,y in tensor_map.items() if y is s]
        for t in tensors: tensor_map[t] = s2
  tensor_map[big_sink] = simple_sink = contig_map[simple_sink]

  # display the contiguous graph
  if getenv("VIZ"): graph_rewrite(simple_sink, PatternMatcher([]), name="View Contiguous Graph")

  kernel_map = graph_rewrite_map(simple_sink, create_kernels)
  sched_sink = kernel_map[simple_sink]

  # display the cleaned up tensor graph
  if getenv("VIZ"): graph_rewrite(sched_sink, PatternMatcher([]), name="View Kernel Graph")

  becomes_map = {big_sink:sched_sink}
  for k,v in tensor_map.items():
    if (a:=kernel_map.get(v.base)) is not None and a.op in {Ops.ASSIGN, Ops.COPY}:
      becomes_map[k] = a.buf_uop.view(unwrap(v.st))
    if k is v: continue
    if v.base.op in {Ops.BUFFER, Ops.CONST}: becomes_map[k] = v
  return becomes_map

# **** schedule creation and toposort

@dataclass(frozen=True)
class ScheduleItem:
  ast: UOp
  bufs: tuple[Buffer, ...]
  metadata: tuple[Metadata, ...]

@track_rewrites(name_fxn=lambda r: f"Schedule {pluralize('Kernel', len(r[0]))}"+(f" (with_{pluralize('Var', len(r[1]))})" if len(r[1]) != 0 else ""))
def create_schedule_with_vars(big_sink:UOp) -> tuple[list[ScheduleItem], dict[Variable, int], dict[UOp, UOp]]:
  becomes_map = get_becomes_map(big_sink)
  sched_sink = becomes_map[big_sink]
  schedule: list[ScheduleItem] = []
  var_vals: dict[Variable, int] = {}
  for u in sched_sink.toposort:
    if u.op is Ops.KERNEL:
      schedule.append(ScheduleItem(u.arg.ast, tuple(s.buf_uop.buffer for s in u.src), u.arg.metadata))
      u.src[0].buffer.ref(1)
    if u.op is Ops.COPY:
      schedule.append(ScheduleItem(u.replace(src=()), tuple(s.buf_uop.buffer for s in u.src), ()))
      u.src[0].buffer.ref(1)
  del becomes_map[big_sink]
  return schedule, var_vals, becomes_map
