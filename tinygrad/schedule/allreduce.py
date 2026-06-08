import functools, itertools
from tinygrad.helpers import all_int, prod, DEBUG, RING, ALL2ALL, ALLREDUCE_CAST, getenv
from tinygrad.dtype import dtypes
from tinygrad.uop.ops import UOp, Invalid, Ops, KernelInfo

# *** allreduce implementation ***
def _slice_flat(buf:UOp, start:int, end:int) -> UOp:
  return UOp(Ops.SLICE, buf.dtype, (buf, UOp.const(dtypes.weakint, start)), end-start).reshape((end-start,))

def _allreduce_chunks(buf:UOp, red:UOp) -> tuple[tuple[int, ...], int, list[tuple[int, int]], list[UOp], bool]|None:
  if not isinstance(buf.device, tuple): return None
  assert all_int(buf.shape), f"does not support symbolic shape {buf.shape}"
  ndev, shape, numel = len(buf.device), buf.shape, prod(buf.shape)

  # ring allreduce doesn't provide a benefit with only 2 nodes or where number of elements is less than 256k (empirically)
  # fallback to naive allreduce to save on kernel dispatch, chunking and reassembling chunks.
  use_all2all = (ALL2ALL >= 2 or (ndev > 2 and numel > getenv("RING_ALLREDUCE_THRESHOLD", 256_000) and ALL2ALL >= 1))
  use_ring = not use_all2all and (RING >= 2 or (ndev > 2 and numel > getenv("RING_ALLREDUCE_THRESHOLD", 256_000) and RING >= 1))
  if DEBUG >= 2: print(f"{'ALL2ALL' if use_all2all else 'RING' if use_ring else 'NAIVE'} ALLREDUCE {ndev}x{numel} | {buf.dtype}")

  # contiguous before we copy it
  buf = buf.contiguous()

  # naive: copy to all devices. if you shrink later, that'll be handled
  if not use_ring and not use_all2all:
    return shape, numel, [(0, numel)], [functools.reduce(lambda x,y: x.alu(red.arg, y), [buf.mselect(i).copy_to_device(red.src[1]) for i in range(ndev)])], use_all2all

  # chunk data into ndev pieces
  factor = next((f for f in [32, 16, 8, 4, 2] if numel % f == 0), 1)
  base, left = divmod(numel // factor,  ndev)
  chunks = list(itertools.pairwise(itertools.accumulate([(base + 1) * factor] * left + [base * factor] * (ndev - left), initial=0)))

  # reduce-scatter
  reduced_chunks:list[UOp] = []
  for i,(s,e) in enumerate(chunks):
    if use_all2all:
      chunks_on_i = [_slice_flat(buf.mselect(j), s, e).copy_to_device(buf.device[i]) for j in range(ndev)]
      reduced_chunks.append(functools.reduce(lambda x,y: x.alu(red.arg, y), chunks_on_i))
    else:
      chunk, reduced = buf.reshape((numel,)).shrink(((s,e),)), buf.reshape((numel,)).shrink(((s,e),))
      for step in range(ndev-1):
        src, dest = (i+step)%ndev, (i+step+1)%ndev
        cp = reduced.copy_to_device(buf.device[dest], src if isinstance(reduced.device, tuple) else None)
        reduced = cp.alu(red.arg, chunk.copy_to_device(buf.device[dest], dest))
      reduced_chunks.append(reduced)

  # allgather
  copied_chunks:list[UOp] = []
  for i,rc in enumerate(reduced_chunks):
    if isinstance(red.src[1].arg, str): copied_chunks.append(rc.copy_to_device(red.src[1].arg))
    elif use_all2all: copied_chunks.append(UOp.mstack(*(rc if j == i else rc.copy_to_device(buf.device[j]) for j in range(ndev))))
    else:
      chain:list[UOp] = [rc]
      for step in range(ndev-1):
        chain.append(rc := rc.copy_to_device(buf.device[(i+step)%ndev]))
      copied_chunks.append(UOp.mstack(*(chain[(j-i+1)%ndev] for j in range(ndev))))

  return shape, numel, chunks, copied_chunks, use_all2all

def _accumulate_allreduce(dst:UOp, red:UOp, cast_dtype=None) -> UOp|None:
  if (ret:=_allreduce_chunks(red.src[0], red)) is None: return None
  shape, numel, chunks, copied_chunks, use_all2all = ret
  if not use_all2all or prod(dst.shape) != numel or len(chunks) <= 1: return None
  if not all(e-s == chunks[0][1]-chunks[0][0] for s,e in chunks): return None
  chunk_len = chunks[0][1] - chunks[0][0]

  def accumulate_call(out:UOp, srcs:list[UOp], suffix:str) -> UOp:
    srcs = [x.contiguous() if x.op is not Ops.AFTER else x for x in srcs]
    params = [UOp.placeholder_like(x, i) for i,x in enumerate((out, *srcs))]
    flat_out = params[0].reshape((numel,))
    flats = [x.reshape((chunk_len,)) for x in params[1:]]
    i = UOp.range(chunk_len, 0)
    stores = []
    for (s,_),c in zip(chunks, flats):
      cur = flat_out[s+i]
      val = c[i].cast(cast_dtype) if cast_dtype is not None else c[i]
      stores.append(flat_out[s+i].store(cur + val.cast(cur.dtype)))
    sink = UOp.group(*stores).end(i).sink(arg=KernelInfo(name=f"allreduce_accumulate_{numel}_{len(chunks)}{suffix}", opts_to_apply=()))
    return sink.call(out, *srcs)

  if isinstance(dst.device, tuple):
    calls = [accumulate_call(dst.mselect(j), [c.src[j] if c.op is Ops.MSTACK else c for c in copied_chunks], f"_{j}") for j in range(len(dst.device))]
    return dst.after(*calls)
  return dst.after(accumulate_call(dst, copied_chunks, ""))

def handle_reduce_multi_accumulate(dst:UOp, new_grad:UOp) -> UOp|None:
  cast_dtype = None
  if new_grad.op is Ops.CAST: new_grad, cast_dtype = new_grad.src[0], new_grad.dtype
  while new_grad.op is Ops.RESHAPE and prod(new_grad.shape) == prod(new_grad.src[0].shape): new_grad = new_grad.src[0]
  if new_grad.op is not Ops.REDUCE or new_grad.src[0].op is not Ops.MULTI: return None
  multi = new_grad.src[0]
  op, axis = new_grad.arg
  if multi.axis is None or multi.axis not in axis: return None
  local = multi.src[0]._rop(op, axis)
  if ALLREDUCE_CAST and multi.src[0].op is Ops.CAST and multi.src[0].src[0].dtype.scalar() in (dtypes.bfloat16, dtypes.half):
    red = local.cast(multi.src[0].src[0].dtype).allreduce(op, multi.device)
    cast_dtype = local.dtype
  else:
    red = local.allreduce(op, multi.device)
  return _accumulate_allreduce(dst, red, cast_dtype)

def handle_allreduce(buf:UOp, red:UOp) -> UOp|None:
  if (ret:=_allreduce_chunks(buf, red)) is None: return None
  shape, numel, chunks, copied_chunks, _ = ret
  if len(chunks) == 1: return copied_chunks[0].reshape(shape)

  # reassemble
  return UOp.usum(*[c.pad(((s,numel-e),)) for (s,e),c in zip(chunks, copied_chunks)]).reshape(shape)

def create_allreduce_function(buf:UOp, red:UOp, output:UOp|None=None) -> UOp|None:
  if output is None: output = UOp.const(red.dtype, Invalid, shape=red.shape).clone(device=red.device)
  to = red.param_like(0)
  src = buf.param_like(1)
  red = src.allreduce(red.arg, red.src[1])
  return output.after(to.after(to.store(handle_allreduce(src, red))).sink().call(output, buf.contiguous(), name="allreduce", precompile=True))
