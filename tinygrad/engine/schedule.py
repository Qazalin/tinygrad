from dataclasses import dataclass
from tinygrad.ops import UOp, Variable, track_rewrites, merge_views, PatternMatcher, UPat, graph_rewrite_map, graph_rewrite, GroupOp, Ops
from tinygrad.dtype import ImageDType
from tinygrad.codegen.symbolic import symbolic_simple
from tinygrad.device import Buffer
from tinygrad.helpers import Metadata, pluralize, getenv, prod

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

DONT_PLACE_IN_KERNEL = {Ops.KERNEL, Ops.ASSIGN, Ops.COPY, Ops.BUFFER_VIEW, Ops.BUFFER}

@dataclass(frozen=True)
class Kernel:
  ast: UOp
  metadata: tuple[Metadata, ...] = ()
  def __repr__(self): return f"<Kernel {len(list(self.ast.toposort))} {self.ast.op} {self.metadata}>"

def append_to_kernel(x:UOp):
  new_src: list[UOp] = []
  for s in x.src:
    if s.op in DONT_PLACE_IN_KERNEL: new_src.append(s)
    else: new_src.extend(s.src)
  if tuple(new_src) != x.src: return x.replace(src=tuple(new_src))

create_kernels = PatternMatcher([
  (UPat(Ops.CONTIGUOUS, name="x"),
   lambda x: (b:=UOp.new_buffer(x.device, x.size, x.dtype)).assign(UOp(Ops.KERNEL, src=x.src, arg=Kernel(x)))),
  (UPat(Ops.COPY, src=(UPat(Ops.DEVICE, name="d"), UPat.var("x"))), lambda d,x: UOp(Ops.COPY, x.dtype, (UOp.new_buffer(d.arg, x.size, x.dtype), x))),
  (UPat(Ops.SINK, name="x"), lambda x: x.replace(src=new_src)
    if (new_src:=tuple(s if s.base.op in {*DONT_PLACE_IN_KERNEL, Ops.CONST} else s.base.contiguous().view(s.st) for s in x.src)) != x.src else None),
  (UPat(Ops.KERNEL, name="x"), append_to_kernel),
])

@dataclass(frozen=True)
class ScheduleItem:
  ast: UOp
  bufs: tuple[Buffer, ...]
  metadata: tuple[Metadata, ...]

@track_rewrites(name_fxn=lambda r: f"Schedule {pluralize('Kernel', len(r[0]))}"+(f" (with_{pluralize('Var', len(r[1]))})" if len(r[1]) != 0 else ""))
def create_schedule_with_vars(big_sink:UOp) -> tuple[list[ScheduleItem], dict[Variable, int], dict[UOp, UOp]]:
  tensor_map = graph_rewrite_map(big_sink, merge_views+sym, ctx={})
  if getenv("VIZ"): graph_rewrite(tensor_map[big_sink], PatternMatcher([]), name="View Tensor Graph")
  kernel_map = graph_rewrite_map(tensor_map[big_sink], merge_views+create_kernels)

  becomes_map: dict[UOp, UOp] = {}

  for k,v in kernel_map.items():
    if k is v: continue
    if v.op in {Ops.ASSIGN, Ops.COPY}: becomes_map[k] = v.buf_uop

  for k,v in tensor_map.items():
    if (a:=kernel_map.get(v.base)) is not None and a is not k: becomes_map[k] = a.view(v.st)
    if k is v: continue
    if v.op in {Ops.BUFFER, Ops.CONST}: becomes_map[k] = v

  schedule: list[UOp] = []
  var_vals: dict[Variable, int] = {}
  return schedule, var_vals, becomes_map
