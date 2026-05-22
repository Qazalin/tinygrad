from __future__ import annotations
import functools, pathlib
from tinygrad import Tensor, dtypes
from tinygrad.dtype import AddrSpace
from tinygrad.helpers import prod
from tinygrad.uop.ops import UOp, Ops, KernelInfo, AxisType
from tinygrad.renderer import Estimates
from extra.llama_kernels import FP8_MAX, NUM_WG, THREADS_PER_WG, alloc_like, alloc_local, scalar_amax, dname_of, compile_hip

def _src() -> str: return (pathlib.Path(__file__).parent/"fused_rmsnorm_mul_quantize_fp8.cpp").read_text()
def _src_bwd() -> str: return (pathlib.Path(__file__).parent/"fused_rmsnorm_mul_quantize_fp8_bwd.cpp").read_text()

@functools.cache
def _custom_fwd(fp8_out:UOp, x_normed_out:UOp, rrms_out:UOp, amax_buf:UOp,
                x:UOp, weight:UOp, amax_state:UOp, dname:str, eps_val:float) -> UOp:
  MBS, SEQ, HIDDEN = x.shape
  n_elems = MBS * SEQ * HIDDEN
  threads, workgroups = UOp.special(THREADS_PER_WG, "lidx0"), UOp.special(NUM_WG, "gidx0")
  mem = n_elems * 2 + n_elems + MBS * SEQ * 4 + n_elems + HIDDEN * 2 + NUM_WG * 4 + 4
  sink = UOp.sink(fp8_out.base, x_normed_out.base, rrms_out.base, amax_buf.base,
                  x.base, weight.base, amax_state.base, threads, workgroups,
                  arg=KernelInfo(f"fused_rmsnorm_mul_quantize_fp8_{n_elems}_h{HIDDEN}_eps{eps_val:.0e}",
                                 estimates=Estimates(ops=6*n_elems, mem=mem)))
  defines = [f"-DN_ELEMS={n_elems}", f"-DHIDDEN={HIDDEN}", f"-DNUM_WG={NUM_WG}", f"-DTHREADS_PER_WG={THREADS_PER_WG}",
             f"-DEPS_LITERAL={eps_val}f"]
  src = _src()
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=dname), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                               UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=compile_hip(src, defines))))

@functools.cache
def _custom_fwd_add(fp8_out:UOp, h_out:UOp, x_normed_out:UOp, rrms_out:UOp, amax_buf:UOp,
                    x:UOp, residual:UOp, weight:UOp, amax_state:UOp, dname:str, eps_val:float) -> UOp:
  MBS, SEQ, HIDDEN = x.shape
  n_elems = MBS * SEQ * HIDDEN
  threads, workgroups = UOp.special(THREADS_PER_WG, "lidx0"), UOp.special(NUM_WG, "gidx0")
  mem = n_elems * 2 * 4 + MBS * SEQ * 4 + HIDDEN * 2 + NUM_WG * 4 + 4
  sink = UOp.sink(fp8_out.base, h_out.base, x_normed_out.base, rrms_out.base, amax_buf.base,
                  x.base, residual.base, weight.base, amax_state.base, threads, workgroups,
                  arg=KernelInfo(f"fused_add_rmsnorm_mul_quantize_fp8_{n_elems}_h{HIDDEN}_eps{eps_val:.0e}",
                                 estimates=Estimates(ops=7*n_elems, mem=mem)))
  defines = [f"-DN_ELEMS={n_elems}", f"-DHIDDEN={HIDDEN}", f"-DNUM_WG={NUM_WG}", f"-DTHREADS_PER_WG={THREADS_PER_WG}",
             f"-DEPS_LITERAL={eps_val}f", f"-DHAS_RESIDUAL=1"]
  src = _src()
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=dname), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                               UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=compile_hip(src, defines))))

@functools.cache
def _custom_bwd(grad_x:UOp, grad_weight_partial:UOp,
                grad_fp8:UOp, x_normed:UOp, rrms:UOp, weight:UOp, amax_state:UOp, dname:str) -> UOp:
  VEC = 8
  MBS, SEQ, HIDDEN = x_normed.shape
  n_elems = MBS * SEQ * HIDDEN
  rows = MBS * SEQ
  elems_per_thread = HIDDEN // THREADS_PER_WG
  vecs_per_thread = elems_per_thread // VEC

  assert n_elems % HIDDEN == 0
  assert HIDDEN % (THREADS_PER_WG * VEC) == 0
  assert rows % NUM_WG == 0
  assert prod(grad_x.shape) == n_elems
  assert prod(grad_fp8.shape) == n_elems
  assert prod(x_normed.shape) == n_elems
  assert prod(rrms.shape) == rows
  assert prod(weight.shape) == HIDDEN
  assert prod(grad_weight_partial.shape) == NUM_WG * HIDDEN

  grad_x = grad_x.reshape(n_elems)
  grad_weight_partial = grad_weight_partial.reshape(NUM_WG, vecs_per_thread, THREADS_PER_WG, VEC)
  grad_fp8 = grad_fp8.reshape(n_elems)
  x_normed = x_normed.reshape(n_elems)
  rrms = rrms.reshape(rows)
  weight = weight.reshape(HIDDEN)

  wg = UOp.range(NUM_WG, 0, AxisType.GLOBAL)
  tid = UOp.range(THREADS_PER_WG, 1, AxisType.LOCAL)
  row_it = UOp.range(rows // NUM_WG, 2, AxisType.LOOP)

  scale = FP8_MAX / (amax_state[0].cast(dtypes.float) + 1e-8)
  inv_hidden = 1.0 / HIDDEN

  w_regs = UOp.placeholder((elems_per_thread,), dtypes.float, slot=1, addrspace=AddrSpace.REG)
  w_store = None
  for i in range(elems_per_thread):
    hidx = tid * VEC + (i // VEC) * THREADS_PER_WG * VEC + (i % VEC)
    target = w_regs if w_store is None else w_regs.after(w_store)
    w_store = target[i].store(weight[hidx].cast(dtypes.float))
  w_regs = w_regs.after(w_store)

  gw_accum = UOp.placeholder((elems_per_thread,), dtypes.float, slot=2, addrspace=AddrSpace.REG)
  gw_init = None
  for i in range(elems_per_thread):
    target = gw_accum.after(w_store) if gw_init is None else gw_accum.after(gw_init)
    gw_init = target[i].store(0.0)

  xn_regs = UOp.placeholder((elems_per_thread,), dtypes.float, slot=3, addrspace=AddrSpace.REG)
  g_xn_regs = UOp.placeholder((elems_per_thread,), dtypes.float, slot=4, addrspace=AddrSpace.REG)

  row = wg + row_it * NUM_WG
  row_off = row * HIDDEN
  rrms_v = rrms[row].cast(dtypes.float)

  local_dot = UOp.const(dtypes.float, 0.0)
  row_store = None
  for i in range(elems_per_thread):
    hidx = tid * VEC + (i // VEC) * THREADS_PER_WG * VEC + (i % VEC)
    idx = row_off + hidx

    g_y = grad_fp8[idx].cast(dtypes.float) * scale
    xn = x_normed[idx].cast(dtypes.float)
    g_xn = g_y * w_regs[i]

    local_dot = local_dot + g_xn * xn

    target_xn = xn_regs if row_store is None else xn_regs.after(row_store)
    row_store = target_xn[i].store(xn)

    target_gxn = g_xn_regs.after(row_store)
    row_store = target_gxn[i].store(g_xn)

    target_gw = gw_accum.after(row_store)
    row_store = target_gw[i].store(gw_accum.after(gw_init, row_it)[i] + g_y * xn)

  lds = UOp.placeholder((THREADS_PER_WG,), dtypes.float, slot=0, addrspace=AddrSpace.LOCAL)
  lds = lds.after(row_store, lds[tid].store(local_dot).barrier())

  step = THREADS_PER_WG // 2
  while step:
    active = tid < step
    other = lds[tid + step].load(UOp.const(dtypes.float, 0.0), active)
    lds = lds.after(lds[tid].store(lds[tid] + other, gate=active).barrier())
    step //= 2

  mean_term = lds[0] * inv_hidden

  grad_x_store = None
  for i in range(elems_per_thread):
    hidx = tid * VEC + (i // VEC) * THREADS_PER_WG * VEC + (i % VEC)
    idx = row_off + hidx
    dx = rrms_v * (g_xn_regs.after(row_store)[i] - xn_regs.after(row_store)[i] * mean_term)

    target = grad_x if grad_x_store is None else grad_x.after(grad_x_store)
    grad_x_store = target[idx].store(dx.cast(grad_x.dtype.base))

  gw_accum = gw_accum.after(grad_x_store.barrier().end(row_it))

  gw_partial_store = grad_weight_partial[wg, :, tid, :].store(gw_accum.reshape(vecs_per_thread, VEC))

  mem = n_elems * 2 * 3 + NUM_WG * HIDDEN * 4 + MBS * SEQ * 4 + HIDDEN * 2 + 4
  return gw_partial_store.end(tid, wg).sink(
    arg=KernelInfo(f"fused_rmsnorm_mul_quantize_fp8_bwd_{n_elems}_h{HIDDEN}",
                   estimates=Estimates(ops=8*n_elems, mem=mem), opts_to_apply=()))

def _bwd_common(fp8_grad_u, h_grad_u, x_u, x_normed_u, rrms_u, weight_u, amax_state_u, kernel:UOp):
  device = x_u.device
  MBS, SEQ, HIDDEN = x_normed_u.shape
  axis = x_normed_u.axis if isinstance(device, tuple) else None
  grad_x = alloc_like((MBS, SEQ, HIDDEN), dtypes.bfloat16, device, axis)
  grad_weight_partial = alloc_local((NUM_WG, HIDDEN), dtypes.float32, device, axis)
  grad_h_from_fp8 = None
  grad_weight_uop = None
  if fp8_grad_u is not None:
    fxn = functools.partial(_custom_bwd, dname=dname_of(device))
    grad_x_t, grad_weight_partial_t, *_ = Tensor.custom_kernel(
      grad_x, grad_weight_partial,
      Tensor(fp8_grad_u, device=device).cast(dtypes.bfloat16),
      Tensor(x_normed_u.after(kernel), device=device),
      Tensor(rrms_u.after(kernel), device=device),
      Tensor(weight_u, device=device),
      Tensor(amax_state_u, device=device), fxn=fxn)
    grad_h_from_fp8 = grad_x_t
    grad_weight_uop = grad_weight_partial_t.sum(axis=0).cast(dtypes.bfloat16).uop
  if h_grad_u is not None:
    h_grad_t = Tensor(h_grad_u, device=device).cast(dtypes.bfloat16)
    grad_total = (grad_h_from_fp8 + h_grad_t) if grad_h_from_fp8 is not None else h_grad_t
  else:
    grad_total = grad_h_from_fp8
  return grad_total.uop, grad_weight_uop

def _fused_bwd(gradient:UOp, kernel:UOp):
  # NOTE: fwd inputs (fp8_out, x_normed_out, rrms_out, amax_buf, x, weight, amax_state)
  _, x_normed_u, rrms_u, _, x_u, weight_u, amax_state_u = kernel.src[1:]
  grad_x, grad_w = _bwd_common(gradient, None, x_u, x_normed_u, rrms_u, weight_u, amax_state_u, kernel)
  return (None, None, None, None, grad_x, grad_w, None)

def _fused_add_bwd(*args, **kwargs):
  # Two invocation modes: 1 grad => positional; >1 grads => kwarg `call=`.
  # Outputs: (fp8_out, h_out, x_normed_out, rrms_out, amax_buf). Both fp8 and h may be consumed
  # downstream — TUPLE order in gradient.py preserves kernel-output slot order.
  # Don't dispatch by dtype: matmul's bwd emits fp8 grad as bf16 (no explicit cast), so
  # dtype-detection collapses both into h_grad and silently drops the rmsnorm-bwd path.
  if 'call' in kwargs:
    kernel, all_grads = kwargs['call'], list(args)
  else:
    gradient, kernel = args
    all_grads = [gradient]
  fp8_grad_u = h_grad_u = None
  if len(all_grads) >= 2:
    fp8_grad_u, h_grad_u = all_grads[0], all_grads[1]
  elif len(all_grads) == 1:
    g = all_grads[0]
    if g.dtype == dtypes.bfloat16: h_grad_u = g
    else: fp8_grad_u = g
  _, _, x_normed_u, rrms_u, _, x_u, _, weight_u, amax_state_u = kernel.src[1:]
  grad_h, grad_w = _bwd_common(fp8_grad_u, h_grad_u, x_u, x_normed_u, rrms_u, weight_u, amax_state_u, kernel)
  return (None, None, None, None, None, grad_h, grad_h, grad_w, None)

def fused_rmsnorm_mul_quantize_fp8(x:Tensor, weight:Tensor, amax_state:Tensor, eps:float, fp8_dtype) -> tuple[Tensor, Tensor, Tensor, Tensor, Tensor]:
  # NOTE: rmsnorm(x) * weight -> fp8 + amax. Returns (fp8, inv_scale, new_amax, x_normed, rrms).
  # x_normed + rrms are saved for the rmsnorm backward (also recomputed here from x regs).
  assert x.dtype == dtypes.bfloat16 and weight.dtype == dtypes.bfloat16
  assert x.shape[-1] == weight.shape[-1], f"HIDDEN mismatch: x={x.shape}, weight={weight.shape}"
  MBS, SEQ, HIDDEN = x.shape
  axis = x.uop.axis if isinstance(x.device, tuple) else None
  if isinstance(x.device, tuple): assert axis in (None, 0, 1), f"unsupported sharding axis={axis}"
  fp8_out      = alloc_like((MBS, SEQ, HIDDEN), fp8_dtype,       x.device, axis)
  x_normed_out = alloc_like((MBS, SEQ, HIDDEN), dtypes.bfloat16, x.device, axis)
  rrms_out     = alloc_like((MBS, SEQ),         dtypes.float32,  x.device, axis)
  amax_buf     = alloc_local((NUM_WG,),         dtypes.float32,  x.device, axis)
  fxn = functools.partial(_custom_fwd, dname=dname_of(x.device), eps_val=eps)
  fp8_out, x_normed_out, rrms_out, amax_buf, *_ = Tensor.custom_kernel(
    fp8_out, x_normed_out, rrms_out, amax_buf, x, weight, amax_state, fxn=fxn, grad_fxn=_fused_bwd)
  inv_scale = (amax_state.float() + 1e-8) / FP8_MAX
  return fp8_out, inv_scale, scalar_amax(amax_buf), x_normed_out, rrms_out

def fused_add_rmsnorm_mul_quantize_fp8(x:Tensor, residual:Tensor, weight:Tensor, amax_state:Tensor,
                                       eps:float, fp8_dtype) -> tuple[Tensor, Tensor, Tensor, Tensor, Tensor, Tensor]:
  # NOTE: h = x + residual; y_normed = rmsnorm(h); fp8 = quantize(y_normed * weight).
  # Returns (fp8, inv_scale, new_amax, h, x_normed, rrms). h is also written so downstream can
  # reuse it without recomputing x+residual — eliminates the separate residual-add kernel.
  assert x.dtype == dtypes.bfloat16 and residual.dtype == dtypes.bfloat16 and weight.dtype == dtypes.bfloat16
  assert x.shape == residual.shape
  MBS, SEQ, HIDDEN = x.shape
  axis = x.uop.axis if isinstance(x.device, tuple) else None
  if isinstance(x.device, tuple): assert axis in (None, 0, 1), f"unsupported sharding axis={axis}"
  fp8_out      = alloc_like((MBS, SEQ, HIDDEN), fp8_dtype,       x.device, axis)
  h_out        = alloc_like((MBS, SEQ, HIDDEN), dtypes.bfloat16, x.device, axis)
  x_normed_out = alloc_like((MBS, SEQ, HIDDEN), dtypes.bfloat16, x.device, axis)
  rrms_out     = alloc_like((MBS, SEQ),         dtypes.float32,  x.device, axis)
  amax_buf     = alloc_local((NUM_WG,),         dtypes.float32,  x.device, axis)
  fxn = functools.partial(_custom_fwd_add, dname=dname_of(x.device), eps_val=eps)
  fp8_out, h_out, x_normed_out, rrms_out, amax_buf, *_ = Tensor.custom_kernel(
    fp8_out, h_out, x_normed_out, rrms_out, amax_buf, x, residual, weight, amax_state,
    fxn=fxn, grad_fxn=_fused_add_bwd)
  inv_scale = (amax_state.float() + 1e-8) / FP8_MAX
  return fp8_out, inv_scale, scalar_amax(amax_buf), h_out, x_normed_out, rrms_out
