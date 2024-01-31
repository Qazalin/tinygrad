import os
import numpy as np
from tinygrad.device import Buffer, Device
from tinygrad.helpers import getenv, prod
from tinygrad.realize import run_schedule
from extra.models.resnet import ResNet50
from test.models.test_efficientnet import _infer, chicken_img
from tinygrad.codegen.linearizer import Linearizer
from tinygrad.ops import LoadOps
from tinygrad.tensor import Tensor

model = ResNet50()
model.load_from_pretrained()
out = _infer(model, chicken_img)

sched = [si for si in out.lazydata.schedule() if si.ast.op not in LoadOps][0]
sidx = out.lazydata.schedule().index(sched)

def helper_realized_ast(r:Tensor):
  s = r.lazydata.schedule()[:getenv("SI")]
  run_schedule(s[:-1])  # run all kernels except the last one
  # now all input LazyBuffers buffers in s[-1] should be realized
  # allocate an output buffer
  output_buffer = Buffer(s[-1].out.device, prod((s if isinstance(s, int) else s.max for s in s[-1].out.shape)), s[-1].out.dtype)
  return s[-1].ast, [output_buffer] + [l.realized for l in s[-1].inputs]

ast, real_bufs = helper_realized_ast(out)
print(len(real_bufs))
real_bufs[0].copyin(np.zeros((real_bufs[0].size, ), dtype=real_bufs[0].dtype.np).data) # Zero to check that all values are filled
lin = Linearizer(sched.ast)
lin.hand_coded_optimizations()
lin.linearize()
fxn = Device[Device.DEFAULT].to_program(lin)
fxn.exec(real_bufs)
arr = np.frombuffer(real_bufs[0].as_buffer(), real_bufs[0].dtype.np)
arr.tofile(open(f"/tmp/{Device.DEFAULT}.pkl", "wb"))
