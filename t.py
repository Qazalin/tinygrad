import os
os.environ["NULL"] = "1"
os.environ["EMULATE"] = "AMD_CDNA4"
os.environ["VIZ"] = "-1"
from tinygrad import Tensor, dtypes

grads = [Tensor.empty(256) for _ in range(225)] + [Tensor.empty(4096, dtype=dtypes.bfloat16) for _ in range(65)]
total_norm = Tensor.stack(*[g.float().square().sum() for g in grads]).sum().sqrt().contiguous()
total_norm.realize()

from tinygrad.uop.ops import tracked_keys, tracked_ctxs, uop_fields, RewriteTrace, UOp
import functools
@functools.cache
def _reconstruct(a:int):
  op, dtype, src, arg, *rest = uop_fields[a]
  return UOp(op, dtype, tuple(_reconstruct(s) for s in src), arg, *rest)

_reconstruct(tracked_ctxs[-1][-1].sink)
