from __future__ import annotations
import functools
from tinygrad import Tensor, dtypes
from tinygrad.uop.ops import UOp, KernelInfo, AxisType
from tinygrad.renderer import Estimates
from extra.llama_kernels import THREADS_PER_WG

ELEMS_PER_THREAD = 8  # vectorized 16-byte load (uint4 = 8 bf16)

@functools.cache
def _custom_fused_pad_grad_accum(grad_buf:UOp, *chunk_uops, n_chunks:int, chunk_size:int) -> UOp:
  total = n_chunks * chunk_size
  elems_per_block = THREADS_PER_WG * ELEMS_PER_THREAD
  assert chunk_size % elems_per_block == 0, f"chunk_size {chunk_size} must be multiple of {elems_per_block}"
  blocks_per_chunk = chunk_size // elems_per_block
  mem = total * 2 * 3
  chunks = [c.flatten() for c in chunk_uops]
  grad_buf = grad_buf.flatten()
  chunk = UOp.range(n_chunks, 0, AxisType.GLOBAL)
  block = UOp.range(blocks_per_chunk, 1, AxisType.GLOBAL)
  tid = UOp.range(THREADS_PER_WG, 2, AxisType.LOCAL)
  elem = UOp.range(ELEMS_PER_THREAD, 3, AxisType.LOOP)
  local_offset = block * elems_per_block + tid * ELEMS_PER_THREAD + elem
  global_offset = chunk * chunk_size + local_offset
  stores = [grad_buf.index(global_offset, ptr=True).store(grad_buf[global_offset] + c[local_offset], gate=chunk.eq(i)) for i,c in enumerate(chunks)]
  return UOp.group(*stores).end(elem, tid, block, chunk).sink(arg=KernelInfo(f"fused_pad_grad_accum_n{n_chunks}_c{chunk_size}",
                                                                            opts_to_apply=(),
                                                                            estimates=Estimates(ops=2*total, mem=mem)))

def can_fused_pad_grad_accum(grad_buf:Tensor, chunks:list[Tensor]) -> bool:
  if not chunks or grad_buf.dtype != dtypes.bfloat16: return False
  if any(c.dtype != dtypes.bfloat16 for c in chunks): return False
  chunk_shape = chunks[0].shape
  if any(c.shape != chunk_shape for c in chunks): return False
  chunk_size, total = 1, 1
  for d in chunk_shape: chunk_size *= d
  for d in grad_buf.shape: total *= d
  return total == len(chunks) * chunk_size and chunk_size % (THREADS_PER_WG * ELEMS_PER_THREAD) == 0

def fused_pad_grad_accum(grad_buf:Tensor, chunks:list[Tensor]) -> Tensor:
  # NOTE: grad_buf += cat(*chunks, dim=0) in one HBM pass (in-place add). Returns new grad_buf Tensor.
  # Requires uniform chunk shapes and chunk_size % (THREADS_PER_WG*ELEMS_PER_THREAD) == 0.
  assert chunks and grad_buf.dtype == dtypes.bfloat16
  for c in chunks: assert c.dtype == dtypes.bfloat16, f"chunk dtype must be bf16, got {c.dtype}"
  chunk_size, total = 1, 1
  for d in chunks[0].shape: chunk_size *= d
  for d in grad_buf.shape: total *= d
  assert total == len(chunks) * chunk_size, f"grad_buf size {total} != n_chunks {len(chunks)} * chunk_size {chunk_size}"
  fxn = functools.partial(_custom_fused_pad_grad_accum, n_chunks=len(chunks), chunk_size=chunk_size)
  out, *_ = Tensor.custom_kernel(grad_buf, *chunks, fxn=fxn)
  return out

@functools.cache
def _highlevel_fused_pad_grad_accum(grad_buf:UOp, *chunk_uops, n_chunks:int, chunk_size:int) -> UOp:
  grad_buf = grad_buf.flatten()
  chunks = [c.flatten() for c in chunk_uops]
  chunk = UOp.range(n_chunks, 0)
  elem = UOp.range(chunk_size, 1)
  global_offset = chunk * chunk_size + elem
  selected = sum(chunk.eq(i).where(c[elem], 0) for i,c in enumerate(chunks))
  return grad_buf[global_offset].store(grad_buf[global_offset] + selected).end(elem, chunk).sink(
    arg=KernelInfo(f"highlevel_fused_pad_grad_accum_n{n_chunks}_c{chunk_size}"))

def fused_pad_grad_accum_highlevel(grad_buf:Tensor, chunks:list[Tensor]) -> Tensor:
  assert chunks and grad_buf.dtype == dtypes.bfloat16
  for c in chunks: assert c.dtype == dtypes.bfloat16, f"chunk dtype must be bf16, got {c.dtype}"
  chunk_size, total = 1, 1
  for d in chunks[0].shape: chunk_size *= d
  for d in grad_buf.shape: total *= d
  assert total == len(chunks) * chunk_size, f"grad_buf size {total} != n_chunks {len(chunks)} * chunk_size {chunk_size}"
  fxn = functools.partial(_highlevel_fused_pad_grad_accum, n_chunks=len(chunks), chunk_size=chunk_size)
  out, *_ = Tensor.custom_kernel(grad_buf, *chunks, fxn=fxn)
  return out
