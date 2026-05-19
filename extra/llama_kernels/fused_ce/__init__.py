from __future__ import annotations
import functools, math, pathlib
from tinygrad import Tensor, dtypes, Device
from tinygrad.helpers import getenv
from tinygrad.uop.ops import UOp, Ops, KernelInfo, AxisType
from tinygrad.dtype import AddrSpace
from tinygrad.renderer import Estimates
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler

THREADS_PER_WG = 256

def _metal_compile(src:str, vocab:int, label_smoothing:float) -> bytes:
  defines = f"#define VOCAB {vocab}\n#define THREADS_PER_WG {THREADS_PER_WG}\n#define LABEL_SMOOTHING {label_smoothing}f\n"
  return Device["METAL"].renderer.compiler.compile(defines + src)

@functools.cache
def _custom_fused_ce_loss_fwd_c(loss_out:UOp, max_out:UOp, lse_out:UOp, logits:UOp, targets:UOp,
                                dname:str, vocab:int, rows:int, label_smoothing:float) -> UOp:
  threads, workgroups = UOp.special(THREADS_PER_WG, "lidx0"), UOp.special(rows, "gidx0")
  mem = rows * vocab * 2 + rows * 12 + rows * 4
  sink = UOp.sink(loss_out.base, max_out.base, lse_out.base, logits.base, targets.base,
                  threads, workgroups,
                  arg=KernelInfo(f"fused_ce_loss_fwd", estimates=Estimates(ops=6*rows*vocab, mem=mem)))
  src = (pathlib.Path(__file__).parent/"fused_ce_loss.cpp").read_text()
  defines = [f"-DVOCAB={vocab}", f"-DTHREADS_PER_WG={THREADS_PER_WG}",
             f"-DLABEL_SMOOTHING={label_smoothing}f"]
  lib = HIPCCCompiler("gfx950", ["-std=c++20", "-ffast-math", *defines]).compile_cached(src)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=dname), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                               UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=lib)))

@functools.cache
def _custom_fused_ce_loss_bwd_c(d_logits:UOp, logits:UOp, lse:UOp, targets:UOp, scale:UOp,
                                dname:str, vocab:int, rows:int, label_smoothing:float) -> UOp:
  threads, workgroups = UOp.special(THREADS_PER_WG, "lidx0"), UOp.special(rows, "gidx0")
  mem = rows * vocab * 4 + rows * 8 + 4
  sink = UOp.sink(d_logits.base, logits.base, lse.base, targets.base, scale.base,
                  threads, workgroups,
                  arg=KernelInfo(f"fused_ce_loss_bwd", estimates=Estimates(ops=4*rows*vocab, mem=mem)))
  src = (pathlib.Path(__file__).parent/"fused_ce_loss_bwd.cpp").read_text()
  defines = [f"-DVOCAB={vocab}", f"-DTHREADS_PER_WG={THREADS_PER_WG}",
             f"-DLABEL_SMOOTHING={label_smoothing}f"]
  lib = HIPCCCompiler("gfx950", ["-std=c++20", "-ffast-math", *defines]).compile_cached(src)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=dname), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                                UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=lib)))

@functools.cache
def _custom_fused_ce_loss_fwd_metal(loss_out:UOp, max_out:UOp, lse_out:UOp, logits:UOp, targets:UOp,
                                    vocab:int, rows:int, label_smoothing:float) -> UOp:
  threads, workgroups = UOp.special(THREADS_PER_WG, "lidx0"), UOp.special(rows, "gidx0")
  mem = rows * vocab * 2 + rows * 12 + rows * 4
  sink = UOp.sink(loss_out.base, max_out.base, lse_out.base, logits.base, targets.base,
                  threads, workgroups,
                  arg=KernelInfo(f"fused_ce_loss_fwd_metal", estimates=Estimates(ops=6*rows*vocab, mem=mem)))
  src = (pathlib.Path(__file__).parent/"fused_ce_loss.metal").read_text()
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="METAL"), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                                UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=_metal_compile(src, vocab, label_smoothing))))

@functools.cache
def _custom_fused_ce_loss_bwd_metal(d_logits:UOp, logits:UOp, lse:UOp, targets:UOp, scale:UOp,
                                    vocab:int, rows:int, label_smoothing:float) -> UOp:
  threads, workgroups = UOp.special(THREADS_PER_WG, "lidx0"), UOp.special(rows, "gidx0")
  mem = rows * vocab * 4 + rows * 8 + 4
  sink = UOp.sink(d_logits.base, logits.base, lse.base, targets.base, scale.base,
                  threads, workgroups,
                  arg=KernelInfo(f"fused_ce_loss_bwd_metal", estimates=Estimates(ops=4*rows*vocab, mem=mem)))
  src = (pathlib.Path(__file__).parent/"fused_ce_loss_bwd.metal").read_text()
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="METAL"), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                                UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=_metal_compile(src, vocab, label_smoothing))))

@functools.cache
def _custom_fused_ce_loss_fwd(loss_out:UOp, max_out:UOp, lse_out:UOp, logits:UOp, targets:UOp,
                              vocab:int, rows:int, label_smoothing:float) -> UOp:
  VEC = 8 if vocab >= THREADS_PER_WG * 8 and vocab % 8 == 0 else 1
  chunks = vocab // (THREADS_PER_WG * VEC)
  tail_lanes = (vocab - chunks * THREADS_PER_WG * VEC) // VEC
  assert vocab % (THREADS_PER_WG * VEC) == 0 or VEC == 8, f"unsupported vocab={vocab} for VEC={VEC}"
  row = UOp.range(rows, 0, AxisType.GLOBAL)
  lane = UOp.range(THREADS_PER_WG, 1, AxisType.LOCAL)

  target_idx = targets[row].cast(dtypes.weakint)

  # Per-lane online softmax state, followed by an explicit local-memory lane reduction.
  chunk = UOp.range(chunks, 2, AxisType.REDUCE)
  lane_max = UOp.placeholder((1,), dtypes.float, slot=0, addrspace=AddrSpace.REG)
  lane_sum_exp = UOp.placeholder((1,), dtypes.float, slot=2, addrspace=AddrSpace.REG)
  lane_sum_x = UOp.placeholder((1,), dtypes.float, slot=4, addrspace=AddrSpace.REG)
  lane_target = UOp.placeholder((1,), dtypes.float, slot=5, addrspace=AddrSpace.REG)
  init = UOp.group(lane_max[0].store(-math.inf), lane_sum_exp[0].store(0.0),
                   lane_sum_x[0].store(0.0), lane_target[0].store(0.0))
  lane_max, lane_sum_exp = lane_max.after(init), lane_sum_exp.after(init)
  lane_sum_x, lane_target = lane_sum_x.after(init), lane_target.after(init)

  vec_base = (chunk * THREADS_PER_WG + lane) * VEC
  old_max, old_sum_exp = lane_max.after(chunk)[0], lane_sum_exp.after(chunk)[0]
  if VEC == 1:
    idx = vec_base
    x = logits[row, idx].cast(dtypes.float)
    new_max = old_max.maximum(x)
    new_sum_exp = (old_sum_exp * (old_max - new_max).exp()) + (x - new_max).exp()
    sum_exp_store = lane_sum_exp[0].store(new_sum_exp)
    chunk_update = UOp.group(sum_exp_store,
                             lane_max.after(sum_exp_store)[0].store(new_max),
                             lane_sum_x[0].store(lane_sum_x.after(chunk)[0] + x),
                             lane_target[0].store(idx.eq(target_idx).where(x, lane_target.after(chunk)[0])))
  else:
    vec = UOp.range(VEC, 3, AxisType.UPCAST)
    idx = vec_base + vec
    x = logits[row, idx].cast(dtypes.float)
    block_max = x.reduce(vec, arg=Ops.MAX)
    new_max = old_max.maximum(block_max)
    block_sum_exp = (x - new_max).exp().reduce(vec, arg=Ops.ADD)
    block_sum_x = x.reduce(vec, arg=Ops.ADD)
    block_target = idx.eq(target_idx).where(x, x.const_like(0)).reduce(vec, arg=Ops.ADD)
    sum_exp_store = lane_sum_exp[0].store(old_sum_exp * (old_max - new_max).exp() + block_sum_exp)
    chunk_update = UOp.group(sum_exp_store,
                             lane_max.after(sum_exp_store)[0].store(new_max),
                             lane_sum_x[0].store(lane_sum_x.after(chunk)[0] + block_sum_x),
                             lane_target[0].store(lane_target.after(chunk)[0] + block_target))
  chunk_update = chunk_update.end(chunk)
  lane_max, lane_sum_exp = lane_max.after(chunk_update), lane_sum_exp.after(chunk_update)
  lane_sum_x, lane_target = lane_sum_x.after(chunk_update), lane_target.after(chunk_update)

  if tail_lanes:
    active = lane < tail_lanes
    tail_vec = UOp.range(VEC, 3, AxisType.UPCAST)
    tail_idx = chunks * THREADS_PER_WG * VEC + lane * VEC + tail_vec
    tail_x_raw = logits[row, active.where(tail_idx, tail_idx.const_like(0))].cast(dtypes.float)
    tail_x = active.where(tail_x_raw, tail_x_raw.const_like(-math.inf))
    tail_x_for_sum = active.where(tail_x_raw, tail_x_raw.const_like(0))
    old_max, old_sum_exp = lane_max[0], lane_sum_exp[0]
    new_max = old_max.maximum(tail_x.reduce(tail_vec, arg=Ops.MAX))
    tail_sum_exp = (tail_x - new_max).exp().reduce(tail_vec, arg=Ops.ADD)
    tail_sum_x = tail_x_for_sum.reduce(tail_vec, arg=Ops.ADD)
    tail_target = (active & tail_idx.eq(target_idx)).where(tail_x_raw, tail_x_raw.const_like(0)).reduce(tail_vec, arg=Ops.ADD)
    sum_exp_store = lane_sum_exp[0].store(old_sum_exp * (old_max - new_max).exp() + tail_sum_exp)
    tail_update = UOp.group(sum_exp_store,
                            lane_max.after(sum_exp_store)[0].store(new_max),
                            lane_sum_x[0].store(lane_sum_x[0] + tail_sum_x),
                            lane_target[0].store(lane_target[0] + tail_target))
    lane_max, lane_sum_exp = lane_max.after(tail_update), lane_sum_exp.after(tail_update)
    lane_sum_x, lane_target = lane_sum_x.after(tail_update), lane_target.after(tail_update)

  smem_max = UOp.placeholder((THREADS_PER_WG,), dtypes.float, slot=0, addrspace=AddrSpace.LOCAL)
  smem_sum_exp = UOp.placeholder((THREADS_PER_WG,), dtypes.float, slot=1, addrspace=AddrSpace.LOCAL)
  smem_sum_x = UOp.placeholder((THREADS_PER_WG,), dtypes.float, slot=2, addrspace=AddrSpace.LOCAL)
  smem_target = UOp.placeholder((THREADS_PER_WG,), dtypes.float, slot=3, addrspace=AddrSpace.LOCAL)
  to_smem = UOp.group(smem_max[lane].store(lane_max[0]), smem_sum_exp[lane].store(lane_sum_exp[0]),
                      smem_sum_x[lane].store(lane_sum_x[0]), smem_target[lane].store(lane_target[0])).barrier()
  smem_max, smem_sum_exp = smem_max.after(to_smem), smem_sum_exp.after(to_smem)
  smem_sum_x, smem_target = smem_sum_x.after(to_smem), smem_target.after(to_smem)

  for step in [128, 64, 32, 16, 8, 4, 2, 1]:
    active = lane < step
    other = active.where(lane + step, lane)
    m1p, s1p = smem_max.index(lane, ptr=True), smem_sum_exp.index(lane, ptr=True)
    sx1p, tgt1p = smem_sum_x.index(lane, ptr=True), smem_target.index(lane, ptr=True)
    m1, m2 = smem_max[lane], smem_max[other]
    s1, s2 = smem_sum_exp[lane], smem_sum_exp[other]
    new_m = m1.maximum(m2)
    new_s = s1 * (m1 - new_m).exp() + s2 * (m2 - new_m).exp()
    reduce_step = UOp.group(s1p.store(new_s, gate=active), m1p.store(new_m, gate=active),
                            sx1p.store(smem_sum_x[lane] + smem_sum_x[other], gate=active),
                            tgt1p.store(smem_target[lane] + smem_target[other], gate=active)).barrier()
    smem_max, smem_sum_exp = smem_max.after(reduce_step), smem_sum_exp.after(reduce_step)
    smem_sum_x, smem_target = smem_sum_x.after(reduce_step), smem_target.after(reduce_step)

  row_max = smem_max[0]
  row_sum_exp = smem_sum_exp[0]
  mean_logits = smem_sum_x[0] / vocab
  target = smem_target[0]
  row_lse = row_sum_exp.log() + row_max
  loss = row_lse - (1.0 - label_smoothing) * target - label_smoothing * mean_logits
  out_row = row.valid(lane.eq(0))
  stores = UOp.group(loss_out[out_row].store(loss), max_out[out_row].store(row_max), lse_out[out_row].store(row_lse))

  return stores.end(lane, row).sink(arg=KernelInfo(f"fused_ce_loss_fwd_{rows}_{vocab}", opts_to_apply=()))

@functools.cache
def _custom_fused_ce_loss_bwd(d_logits:UOp, logits:UOp, lse:UOp, targets:UOp, scale:UOp,
                              vocab:int, rows:int, label_smoothing:float) -> UOp:
  row = UOp.range(rows, 0)
  v = UOp.range(vocab, 1)

  prob = (logits[row, v].cast(dtypes.float) - lse[row]).exp()
  target = v.eq(targets[row].cast(dtypes.weakint)).where(1.0 - label_smoothing, 0.0)
  smooth = label_smoothing / vocab
  grad = (prob - target - smooth) * scale[0]

  return d_logits[row, v].store(grad.cast(d_logits.dtype.base)).end(v, row).sink(arg=KernelInfo(f"fused_ce_loss_bwd_{rows}_{vocab}"))

def _fused_ce_loss_bwd(gradient:UOp, kernel:UOp, label_smoothing:float):
  # NOTE: forward inputs are (loss_out, max_out, lse_out, logits, targets)
  # gradient is the upstream grad w.r.t. per-row loss (shape: (rows,) fp32)
  _, _, lse_u, logits_u, targets_u = kernel.src[1:]
  device = logits_u.device
  rows, VOCAB = logits_u.shape  # (rows, VOCAB) after reshape
  if isinstance(device, tuple):
    axis = logits_u.axis
    ndev = len(device)
    d_logits = Tensor(Tensor.invalids(rows // ndev, VOCAB, dtype=dtypes.bfloat16, device=device).uop.multi(axis), device=device)
    dname = device[0].split(":")[0]
    rows_per_dev = rows // ndev
  else:
    d_logits = Tensor.invalids(rows, VOCAB, dtype=dtypes.bfloat16, device=device)
    dname = device.split(":")[0] if isinstance(device, str) else device
    rows_per_dev = rows
  # NOTE: .mean() backward gives same grad per row (1/N), so broadcast is safe; take scalar
  scale = Tensor(gradient, device=device).float().reshape(-1)[0:1].contiguous()
  logits_t = Tensor(logits_u.after(kernel), device=device)
  lse_t = Tensor(lse_u.after(kernel), device=device)
  targets_t = Tensor(targets_u, device=device)
  if getenv("FUSED_CE_C"):
    fxn = functools.partial(_custom_fused_ce_loss_bwd_metal if dname == "METAL" else _custom_fused_ce_loss_bwd_c,
                            **({} if dname == "METAL" else {"dname": dname}), vocab=VOCAB, rows=rows_per_dev, label_smoothing=label_smoothing)
  else:
    fxn = functools.partial(_custom_fused_ce_loss_bwd, vocab=VOCAB, rows=rows_per_dev, label_smoothing=label_smoothing)
  d_logits, *_ = Tensor.custom_kernel(d_logits, logits_t, lse_t, targets_t, scale, fxn=fxn)
  return (None, None, None, d_logits.uop, None)

def fused_ce_loss(logits:Tensor, targets:Tensor, label_smoothing:float=0.1) -> Tensor:
  # NOTE: fused sparse_categorical_crossentropy with label smoothing, returns mean loss scalar
  assert logits.dtype == dtypes.bfloat16, f"expected bf16, got {logits.dtype}"
  assert logits.ndim == 3, f"expected (MBS, SEQ, VOCAB), got {logits.shape}"
  MBS, SEQ, VOCAB = logits.shape
  rows = MBS * SEQ
  if isinstance(logits.device, tuple):
    axis = logits.uop.axis
    assert axis in (0, 1), f"unsupported sharding axis={axis} for CE loss"
    ndev = len(logits.device)
    loss_out = Tensor(Tensor.invalids(rows // ndev, dtype=dtypes.float32, device=logits.device).uop.multi(0),
                      device=logits.device)
    max_out  = Tensor(Tensor.invalids(rows // ndev, dtype=dtypes.float32, device=logits.device).uop.multi(0),
                      device=logits.device)
    lse_out  = Tensor(Tensor.invalids(rows // ndev, dtype=dtypes.float32, device=logits.device).uop.multi(0),
                      device=logits.device)
    dname = logits.device[0].split(":")[0]
    rows_per_dev = rows // ndev
  else:
    loss_out = Tensor.invalids(rows, dtype=dtypes.float32, device=logits.device)
    max_out  = Tensor.invalids(rows, dtype=dtypes.float32, device=logits.device)
    lse_out  = Tensor.invalids(rows, dtype=dtypes.float32, device=logits.device)
    dname = logits.device.split(":")[0] if isinstance(logits.device, str) else logits.device
    rows_per_dev = rows
  logits_flat = logits.reshape(rows, VOCAB)
  targets_flat = targets.reshape(-1).cast(dtypes.int32)
  if getenv("FUSED_CE_C"):
    fxn = functools.partial(_custom_fused_ce_loss_fwd_metal if dname == "METAL" else _custom_fused_ce_loss_fwd_c,
                            **({} if dname == "METAL" else {"dname": dname}), vocab=VOCAB, rows=rows_per_dev,
                            label_smoothing=label_smoothing)
  else:
    fxn = functools.partial(_custom_fused_ce_loss_fwd, vocab=VOCAB, rows=rows_per_dev,
                            label_smoothing=label_smoothing)
  loss_out, max_out, lse_out, *_ = Tensor.custom_kernel(
    loss_out, max_out, lse_out, logits_flat, targets_flat,
    fxn=fxn, grad_fxn=functools.partial(_fused_ce_loss_bwd, label_smoothing=label_smoothing))
  return loss_out.mean()
