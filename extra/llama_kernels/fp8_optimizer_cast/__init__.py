from __future__ import annotations
import functools, pathlib

from tinygrad import Tensor, dtypes
from tinygrad.helpers import ceildiv
from tinygrad.uop.ops import UOp, Ops, KernelInfo, ProgramInfo
from tinygrad.renderer import Estimates
from extra.llama_kernels import alloc_like, compile_hip, dname_of

@functools.cache
def _fp8_optimizer_cast_kernel(out:UOp, new_w:UOp, inv_scale:UOp, dname:str) -> UOp:
  local_shape = out.shape
  assert len(local_shape) == 3 and new_w.dtype.base is dtypes.float and out.dtype.base is dtypes.fp8e4m3
  n_elems, rowsz = local_shape[0] * local_shape[1] * local_shape[2], local_shape[1] * local_shape[2]
  threads, vec = 256, 4
  groups = ceildiv(ceildiv(n_elems, vec), threads)
  name = f"fp8_optimizer_cast_{n_elems}"
  src = (pathlib.Path(__file__).parent / "fp8_optimizer_cast.cpp").read_text()
  lib = compile_hip(src, [f"-DN_ELEMS={n_elems}", f"-DROWSZ={rowsz}", f"-DTHREADS_PER_WG={threads}", f"-DVEC={vec}"])
  sink = UOp.sink(out.base, new_w.base, inv_scale.base, arg=KernelInfo(name, estimates=Estimates(ops=3*n_elems, mem=n_elems*5)))
  info = ProgramInfo(name=name, global_size=(groups, 1, 1), local_size=(threads, 1, 1), globals=(0, 1, 2), outs=(0,), ins=(1, 2))
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=dname), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=src),
                               UOp(Ops.BINARY, arg=lib)), arg=info)

def fp8_optimizer_cast(new_w:Tensor, inv_scale:Tensor, out_like:Tensor) -> Tensor:
  axis = out_like.uop.axis if isinstance(out_like.device, tuple) else None
  out = alloc_like(out_like.shape, out_like.dtype, out_like.device, axis)
  fxn = functools.partial(_fp8_optimizer_cast_kernel, dname=dname_of(out_like.device))
  out, *_ = Tensor.custom_kernel(out, new_w, inv_scale, fxn=fxn)
  return out
