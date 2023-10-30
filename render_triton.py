from tinygrad.codegen.kernel import LinearizerOptions
from tinygrad.codegen.linearizer import Linearizer
from tinygrad.renderer.triton import uops_to_triton
from tinygrad.ops import Device, LoadOps
from tinygrad.tensor import Tensor
from tinygrad.helpers import dtypes

Device.DEFAULT = "CPU"
a = Tensor([1,2,3,4], dtype=dtypes.float32).cast(dtypes.half)
for si in a.lazydata.schedule():
  if si.ast.op in LoadOps: continue
  lin = Linearizer(si.ast, LinearizerOptions(supports_float4=False, supports_float4_alu=False, global_max = [65535, 65535, 2147483647], local_max = [64, 1024, 1024], has_shared=False))
  lin.hand_coded_optimizations()
  lin.linearize()
  prg = uops_to_triton(lin.function_name, lin.uops)
  print(prg[0])


