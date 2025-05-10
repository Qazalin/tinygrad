import numpy as np
from tinygrad.engine.schedule import ScheduleItem
from tinygrad.ops import UOp, Ops
from dataclasses import replace
from tinygrad.dtype import dtypes
from tinygrad.shape.shapetracker import ShapeTracker, View
from tinygrad.codegen.kernel import Kernel
from tinygrad import Tensor
from tinygrad import Device
from tinygrad.engine.search import bufs_from_lin
from tinygrad.helpers import to_function_name
from tinygrad.ops import KernelInfo
Device.DEFAULT = "DSP"

from tinygrad.codegen.linearize import linearize_uop
from tinygrad.codegen.devectorizer import full_graph_rewrite
from tinygrad.codegen.lowerer import rewrite_shapetracker_with_index, get_contraction
from tinygrad.codegen.kernel import Kernel
from tinygrad.engine.realize import CompiledRunner, ExecItem, lower_schedule_item
from tinygrad.renderer import ProgramSpec
from tinygrad.ops import track_rewrites
from tinygrad.helpers import Context

@track_rewrites()
def lower(k:Kernel, bufs=None) -> ProgramSpec:
  uops = linearize_uop(full_graph_rewrite(rewrite_shapetracker_with_index(k.ast, k.opts), k.opts, True))
  k.uops = uops
  src = k.opts.render(uops)
  prg = ProgramSpec("test", src, k.opts.device, ast, uops, [], 0, global_size=None, local_size=None)
  return ExecItem(CompiledRunner(prg), bufs or bufs_from_lin(k))

a = Tensor(np.random.randint(0, 256, size=(150528,), dtype=np.uint8), dtype=dtypes.uchar).realize().lazydata
b = Tensor(np.random.randint(0, 256, size=(1152,), dtype=np.uint8), dtype=dtypes.uchar).realize().lazydata
a = a.view(ShapeTracker(views=(View(shape=(1, 1, 1, 3, 4, 226, 4, 226), strides=(0, 0, 0, 1, 0, 672, 0, 3), offset=-675, mask=((0, 1), (0, 1), (0, 1), (0, 3), (0, 4), (1, 225), (0, 4), (1, 225)), contiguous=False), View(shape=(112, 28, 3, 3, 3, 32, 4), strides=(1808, 8, 817216, 227, 205208, 0, 2), offset=0, mask=None, contiguous=False))))
b = b.view(ShapeTracker(views=(View(shape=(112, 28, 3, 3, 3, 32, 4), strides=(0, 0, 384, 1, 128, 4, 0), offset=0, mask=None, contiguous=False),)))

out = (a*b).cast(dtypes.float)
r = out.r(Ops.ADD, axis=(2, 3, 4)).cast(dtypes.uchar)
out = Tensor(r)
si = out.schedule()[-1]

ast = si.ast.replace(arg=KernelInfo(name='test', local_dims=0, upcasted=4, dont_use_locals=False))
with Context(QUANTIZE=1, DEVECTORIZE=0): ei = lower(Kernel(ast, opts=Device["DSP"].renderer), bufs=si.bufs)

# copy in allocated buffers from the GPU
from tinygrad.device import Buffer
nb: tuple[Buffer, ...] = tuple(Buffer("CPU", b.size, b.dtype) for b in si.bufs)
for cpu_b, gpu_b in zip(nb, si.bufs):
  if gpu_b.is_allocated(): cpu_b.ensure_allocated().copyin(gpu_b.as_buffer())

# run on GPU
ei.run()

# validate the output buffers match (NOTE: this is assuming the output is buffer 0)
lower_schedule_item(ScheduleItem(si.ast, nb, si.metadata)).run()
import numpy as np
np.testing.assert_allclose(nb[0].numpy(), si.bufs[0].numpy(), rtol=1e-3, atol=1e-3)
