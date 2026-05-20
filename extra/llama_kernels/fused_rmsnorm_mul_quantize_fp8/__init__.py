from __future__ import annotations
import functools
from tinygrad import Tensor, dtypes
from tinygrad.uop.ops import UOp, Ops, KernelInfo, AxisType
from extra.llama_kernels import FP8_MAX, NUM_WG, alloc_like, alloc_local, local_abs_max

@functools.cache
def _custom_fwd(fp8_out:UOp, x_normed_out:UOp, rrms_out:UOp, amax_buf:UOp,
                x:UOp, weight:UOp, amax_state:UOp, eps_val:float) -> UOp:
  MBS, SEQ, HIDDEN = x.shape
  m, s, h = UOp.range(MBS, 0), UOp.range(SEQ, 1), UOp.range(HIDDEN, 2)
  hr = UOp.range(HIDDEN, 3, axis_type=AxisType.REDUCE)
  x_sq = x[m, s, hr].cast(dtypes.float).square().reduce(hr, arg=Ops.ADD) / HIDDEN
  rrms = (x_sq + eps_val).rsqrt()
  x_normed = (x[m, s, h].cast(dtypes.float) * rrms).cast(dtypes.bfloat16)
  y = x_normed.cast(dtypes.float) * weight[h].cast(dtypes.float)
  scaled = (y * (FP8_MAX / (amax_state[0] + 1e-8))).maximum(-FP8_MAX).minimum(FP8_MAX)

  rows, rows_per_wg = MBS * SEQ, (MBS * SEQ + NUM_WG - 1) // NUM_WG
  wg, kr, ha = UOp.range(NUM_WG, 4), UOp.range(rows_per_wg, 5, axis_type=AxisType.REDUCE), UOp.range(HIDDEN, 6, axis_type=AxisType.REDUCE)
  row = wg + kr * NUM_WG
  ma, sa = row // SEQ, row % SEQ
  x_sq_a = x[ma, sa, ha].cast(dtypes.float).square().reduce(ha, arg=Ops.ADD) / HIDDEN
  rrms_a = (x_sq_a + eps_val).rsqrt()
  x_normed_a = (x[ma, sa, ha].cast(dtypes.float) * rrms_a).cast(dtypes.bfloat16)
  y_abs = (row < rows).where((x_normed_a.cast(dtypes.float) * weight[ha].cast(dtypes.float)).abs(), 0.0).reduce(ha, kr, arg=Ops.MAX)

  elem_stores = UOp.group(fp8_out[m, s, h].store(scaled.cast(fp8_out.dtype.base)), x_normed_out[m, s, h].store(x_normed),
                          rrms_out[m, s].store(rrms)).end(h, s, m)
  amax_store = amax_buf[wg].store(y_abs).end(wg)
  return UOp.sink(elem_stores, amax_store, arg=KernelInfo(f"fused_rmsnorm_mul_quantize_fp8_{MBS * SEQ * HIDDEN}_h{HIDDEN}_eps{eps_val:.0e}"))

@functools.cache
def _custom_fwd_add(fp8_out:UOp, h_out:UOp, x_normed_out:UOp, rrms_out:UOp, amax_buf:UOp,
                    x:UOp, residual:UOp, weight:UOp, amax_state:UOp, eps_val:float) -> UOp:
  MBS, SEQ, HIDDEN = x.shape
  m, s, h = UOp.range(MBS, 0), UOp.range(SEQ, 1), UOp.range(HIDDEN, 2)
  hr = UOp.range(HIDDEN, 3, axis_type=AxisType.REDUCE)
  h_red = (x[m, s, hr].cast(dtypes.float) + residual[m, s, hr].cast(dtypes.float)).cast(dtypes.bfloat16).cast(dtypes.float)
  rrms = ((h_red.square().reduce(hr, arg=Ops.ADD) / HIDDEN) + eps_val).rsqrt()
  h_val = (x[m, s, h].cast(dtypes.float) + residual[m, s, h].cast(dtypes.float)).cast(dtypes.bfloat16)
  x_normed = (h_val.cast(dtypes.float) * rrms).cast(dtypes.bfloat16)
  y = x_normed.cast(dtypes.float) * weight[h].cast(dtypes.float)
  scaled = (y * (FP8_MAX / (amax_state[0] + 1e-8))).maximum(-FP8_MAX).minimum(FP8_MAX)

  rows, rows_per_wg = MBS * SEQ, (MBS * SEQ + NUM_WG - 1) // NUM_WG
  wg, kr, ha = UOp.range(NUM_WG, 4), UOp.range(rows_per_wg, 5, axis_type=AxisType.REDUCE), UOp.range(HIDDEN, 6, axis_type=AxisType.REDUCE)
  row = wg + kr * NUM_WG
  ma, sa = row // SEQ, row % SEQ
  h_red_a = (x[ma, sa, ha].cast(dtypes.float) + residual[ma, sa, ha].cast(dtypes.float)).cast(dtypes.bfloat16).cast(dtypes.float)
  rrms_a = ((h_red_a.square().reduce(ha, arg=Ops.ADD) / HIDDEN) + eps_val).rsqrt()
  h_val_a = (x[ma, sa, ha].cast(dtypes.float) + residual[ma, sa, ha].cast(dtypes.float)).cast(dtypes.bfloat16)
  x_normed_a = (h_val_a.cast(dtypes.float) * rrms_a).cast(dtypes.bfloat16)
  y_abs = (row < rows).where((x_normed_a.cast(dtypes.float) * weight[ha].cast(dtypes.float)).abs(), 0.0).reduce(ha, kr, arg=Ops.MAX)

  elem_stores = UOp.group(fp8_out[m, s, h].store(scaled.cast(fp8_out.dtype.base)), h_out[m, s, h].store(h_val),
                          x_normed_out[m, s, h].store(x_normed), rrms_out[m, s].store(rrms)).end(h, s, m)
  amax_store = amax_buf[wg].store(y_abs).end(wg)
  return UOp.sink(elem_stores, amax_store, arg=KernelInfo(f"fused_add_rmsnorm_mul_quantize_fp8_{MBS * SEQ * HIDDEN}_h{HIDDEN}_eps{eps_val:.0e}"))

@functools.cache
def _custom_bwd(grad_x:UOp, grad_weight_partial:UOp,
                grad_fp8:UOp, x_normed:UOp, rrms:UOp, weight:UOp, amax_state:UOp) -> UOp:
  MBS, SEQ, HIDDEN = x_normed.shape
  scale = FP8_MAX / (amax_state[0] + 1e-8)

  m, s, h = UOp.range(MBS, 0), UOp.range(SEQ, 1), UOp.range(HIDDEN, 2)
  hr = UOp.range(HIDDEN, 3, axis_type=AxisType.REDUCE)
  grad_y = grad_fp8[m, s, h].cast(dtypes.float) * scale
  grad_x_normed = grad_y * weight[h].cast(dtypes.float)
  grad_y_r = grad_fp8[m, s, hr].cast(dtypes.float) * scale
  grad_x_normed_r = grad_y_r * weight[hr].cast(dtypes.float)
  mean_term = (grad_x_normed_r * x_normed[m, s, hr].cast(dtypes.float)).reduce(hr, arg=Ops.ADD) / HIDDEN
  dx = rrms[m, s] * (grad_x_normed - x_normed[m, s, h].cast(dtypes.float) * mean_term)

  hg = UOp.range(HIDDEN, 4)
  rows, rows_per_wg = MBS * SEQ, (MBS * SEQ + NUM_WG - 1) // NUM_WG
  wg, kr = UOp.range(NUM_WG, 5), UOp.range(rows_per_wg, 6, axis_type=AxisType.REDUCE)
  row = wg + kr * NUM_WG
  mr, sr = row // SEQ, row % SEQ
  gw = (row < rows).where(grad_fp8[mr, sr, hg].cast(dtypes.float) * scale * x_normed[mr, sr, hg].cast(dtypes.float), 0.0).reduce(kr, arg=Ops.ADD)

  grad_x_store = grad_x[m, s, h].store(dx.cast(grad_x.dtype.base)).end(h, s, m)
  grad_w_store = grad_weight_partial[wg, hg].store(gw).end(hg, wg)
  return UOp.sink(grad_x_store, grad_w_store, arg=KernelInfo(f"fused_rmsnorm_mul_quantize_fp8_bwd_{MBS * SEQ * HIDDEN}_h{HIDDEN}"))

def _bwd_common(fp8_grad_u, h_grad_u, x_u, x_normed_u, rrms_u, weight_u, amax_state_u, kernel:UOp):
  device = x_u.device
  MBS, SEQ, HIDDEN = x_normed_u.shape
  axis = x_normed_u.axis if isinstance(device, tuple) else None
  grad_x = alloc_like((MBS, SEQ, HIDDEN), dtypes.bfloat16, device, axis)
  grad_weight_partial = alloc_local((NUM_WG, HIDDEN), dtypes.float32, device, axis)
  grad_h_from_fp8 = None
  grad_weight_uop = None
  if fp8_grad_u is not None:
    fxn = _custom_bwd
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
  fxn = functools.partial(_custom_fwd, eps_val=eps)
  fp8_out, x_normed_out, rrms_out, amax_buf, *_ = Tensor.custom_kernel(
    fp8_out, x_normed_out, rrms_out, amax_buf, x, weight, amax_state, fxn=fxn, grad_fxn=_fused_bwd)
  inv_scale = (amax_state.float() + 1e-8) / FP8_MAX
  return fp8_out, inv_scale, (local_abs_max(amax_buf) if isinstance(amax_buf.device, tuple) else amax_buf.max()).detach(), x_normed_out, rrms_out

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
  fxn = functools.partial(_custom_fwd_add, eps_val=eps)
  fp8_out, h_out, x_normed_out, rrms_out, amax_buf, *_ = Tensor.custom_kernel(
    fp8_out, h_out, x_normed_out, rrms_out, amax_buf, x, residual, weight, amax_state,
    fxn=fxn, grad_fxn=_fused_add_bwd)
  inv_scale = (amax_state.float() + 1e-8) / FP8_MAX
  return fp8_out, inv_scale, (local_abs_max(amax_buf) if isinstance(amax_buf.device, tuple) else amax_buf.max()).detach(), h_out, x_normed_out, rrms_out
