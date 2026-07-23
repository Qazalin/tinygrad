from __future__ import annotations
import functools, pathlib
from dataclasses import replace
from tinygrad import Tensor, dtypes
from tinygrad.renderer import Estimates
from tinygrad.uop.ops import UOp, Ops, KernelInfo, ProgramInfo
from extra.llama_kernels import THREADS_PER_WG, alloc_like, compile_hip, dname_of

BLK = 32


def quantize_mxfp4_program_info(sink:UOp) -> ProgramInfo:
  info = ProgramInfo.from_sink(sink)
  return replace(info, outs=info.globals[:2], ins=info.globals[2:])


@functools.cache
def _custom_quantize_mxfp4(q:UOp, e8:UOp, x:UOp, use_hadamard:bool, shuffle_data:bool, shuffle_scales:bool, dname:str) -> UOp:
  rows, K = x.shape
  n_blocks = rows * (K // BLK)
  num_wg = (n_blocks + THREADS_PER_WG - 1) // THREADS_PER_WG
  threads, workgroups = UOp.special(THREADS_PER_WG, "lidx0"), UOp.special(num_wg, "gidx0")
  sink = UOp.sink(q.base, e8.base, x.base, threads, workgroups,
                  arg=KernelInfo(f"quantize_mxfp4_{rows}_{K}_h{int(use_hadamard)}",
                                 estimates=Estimates(ops=rows*K*(9 if use_hadamard else 1),
                                                     mem=rows*K*2 + rows*K//2 + n_blocks)))
  src = (pathlib.Path(__file__).parent/"quantize_mxfp4.cpp").read_text()
  defines = [f"-DROWS={rows}", f"-DK_DIM={K}", f"-DTHREADS_PER_WG={THREADS_PER_WG}", f"-DUSE_HADAMARD={int(use_hadamard)}",
             f"-DSHUFFLE_DATA={int(shuffle_data)}", f"-DSHUFFLE_SCALES={int(shuffle_scales)}"]
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.LINEAR, src=(*sink.src, sink)),
                               UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=compile_hip(src, defines))),
             arg=quantize_mxfp4_program_info(sink))


def quantize_mxfp4(x:Tensor, use_hadamard:bool=False, shuffle_data:bool=False, shuffle_scales:bool=False) -> tuple[Tensor, Tensor]:
  """Native HIP BF16 -> packed E2M1 + E8M0 rowwise quantization."""
  assert x.ndim == 2 and x.dtype == dtypes.bfloat16, f"expected 2D BF16, got {x.shape} {x.dtype}"
  rows, K = x.shape
  assert K % BLK == 0, f"K={K} must be divisible by {BLK}"
  axis = x.uop.axis if isinstance(x.device, tuple) else None
  q = alloc_like((rows, K // 2), dtypes.uint8, x.device, axis)
  e8 = alloc_like((rows, K // BLK), dtypes.uint8, x.device, axis)
  assert not shuffle_data or rows % 16 == 0
  assert not shuffle_scales or rows % 32 == 0 and (K // BLK) % 8 == 0
  fxn = functools.partial(_custom_quantize_mxfp4, use_hadamard=use_hadamard, shuffle_data=shuffle_data,
                          shuffle_scales=shuffle_scales, dname=dname_of(x.device))
  q, e8, *_ = Tensor.custom_kernel(q, e8, x, fxn=fxn)
  return q, e8
