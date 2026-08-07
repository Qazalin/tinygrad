from __future__ import annotations
import functools, pathlib
from tinygrad import Tensor, dtypes
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.renderer import Estimates
from extra.llama_kernels import alloc_like, alloc_local, compile_hip

NUM_WG_FWD, NUM_WG_BWD, THREADS = 2048, 1024, 128

def _src(name:str) -> str: return (pathlib.Path(__file__).parent/name).read_text()

@functools.cache
def _custom_rmsnorm_mul_fwd(out:UOp, rrms:UOp, x:UOp, weight:UOp, eps:float) -> UOp:
  rows, hidden = x.numel() // x.shape[-1], x.shape[-1]
  threads, groups = UOp.special(THREADS, "lidx0"), UOp.special(NUM_WG_FWD, "gidx0")
  sink = UOp.sink(out.base, rrms.base, x.base, weight.base, threads, groups,
                  arg=KernelInfo(f"rmsnorm_mul_fwd_{rows}_{hidden}", estimates=Estimates(ops=6*x.numel(), mem=4*x.numel()+4*rows)))
  src = _src("rmsnorm_mul.hip")
  defines = [f"-DROWS={rows}", f"-DHIDDEN={hidden}", f"-DNUM_WG={NUM_WG_FWD}", f"-DTHREADS={THREADS}", f"-DEPS={eps}f"]
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=src),
                               UOp(Ops.BINARY, arg=compile_hip(src, defines))))

@functools.cache
def _custom_rmsnorm_mul_bwd(dx:UOp, dweight_partial:UOp, dout:UOp, x:UOp, rrms:UOp, weight:UOp) -> UOp:
  rows, hidden = x.numel() // x.shape[-1], x.shape[-1]
  threads, groups = UOp.special(THREADS, "lidx0"), UOp.special(NUM_WG_BWD, "gidx0")
  mem = 6*x.numel() + 4*NUM_WG_BWD*hidden + 4*rows + 2*hidden
  sink = UOp.sink(dx.base, dweight_partial.base, dout.base, x.base, rrms.base, weight.base, threads, groups,
                  arg=KernelInfo(f"rmsnorm_mul_bwd_{rows}_{hidden}", estimates=Estimates(ops=10*x.numel(), mem=mem)))
  src = _src("rmsnorm_mul_bwd.hip")
  defines = [f"-DROWS={rows}", f"-DHIDDEN={hidden}", f"-DNUM_WG={NUM_WG_BWD}", f"-DTHREADS={THREADS}"]
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=src),
                               UOp(Ops.BINARY, arg=compile_hip(src, defines))))

def _rmsnorm_mul_bwd(gradient:UOp, call:UOp) -> tuple:
  _, rrms_u, x_u, weight_u = call.src[1:]
  device, axis = x_u.device, x_u.axis if isinstance(x_u.device, tuple) else None
  dx = alloc_like(x_u.shape, dtypes.bfloat16, device, axis)
  partial = alloc_local((NUM_WG_BWD, x_u.shape[-1]), dtypes.float32, device, axis)
  dx, partial, *_ = Tensor.custom_kernel(dx, partial, Tensor(gradient, device=device).cast(dtypes.bfloat16),
                                          Tensor(x_u, device=device), Tensor(rrms_u.after(call), device=device),
                                          Tensor(weight_u, device=device), fxn=_custom_rmsnorm_mul_bwd, contiguous=True)
  return (None, None, dx.uop, partial.sum(axis=0).cast(dtypes.bfloat16).uop)

def rmsnorm_mul(x:Tensor, weight:Tensor, eps:float) -> tuple[Tensor, Tensor]:
  assert x.dtype == weight.dtype == dtypes.bfloat16 and x.shape[-1] == weight.shape[-1] == 4096
  axis = x.uop.axis if isinstance(x.device, tuple) else None
  out = alloc_like(x.shape, dtypes.bfloat16, x.device, axis)
  rrms_axis = axis if axis is None or axis < x.ndim-1 else None
  rrms = alloc_like(x.shape[:-1], dtypes.float32, x.device, rrms_axis)
  out, rrms, *_ = Tensor.custom_kernel(out, rrms, x, weight,
                                        fxn=functools.partial(_custom_rmsnorm_mul_fwd, eps=eps), grad_fxn=_rmsnorm_mul_bwd, contiguous=True)
  return out, rrms

def rmsnorm_fwd(x_in:Tensor, eps:float) -> tuple[Tensor, Tensor]:
  x = x_in.float()
  rrms = (x.square().mean(-1, keepdim=True) + eps).rsqrt()
  return (x * rrms).cast(x_in.dtype), rrms

@functools.cache
def _rmsnorm_fwd_fxn(x_in_p, eps, device):
  return rmsnorm_fwd(Tensor(x_in_p, device=device), eps)

def _rmsnorm_bwd(grad:UOp, call:UOp) -> tuple:
  x_normed = Tensor(call.gettuple(0)).float()
  do_float = Tensor(grad).float()
  d_x = Tensor(call.gettuple(1)) * (do_float - x_normed * (do_float * x_normed).mean(-1, keepdim=True))
  return (d_x.cast(call.src[1].dtype).uop,)

def rmsnorm(x_in:Tensor, eps:float) -> tuple[Tensor, Tensor]:
  fxn = _rmsnorm_fwd_fxn(x_in.as_param(0).uop, eps, x_in.device)
  call = UOp.maketuple(fxn[0].uop, fxn[1].uop).call(x_in.uop, grad_fxn=_rmsnorm_bwd)
  return Tensor(call.gettuple(0)), Tensor(call.gettuple(1))
