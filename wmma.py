import numpy as np, time
from tinygrad import Tensor, dtypes
from tinygrad.codegen.linearizer import Linearizer
from test.test_linearizer import helper_realized_ast
from tinygrad.graph import print_globalcounters
from tinygrad.device import Compiled, Device
from tinygrad.helpers import ansistrip
from tinygrad.renderer.cstyle import HIPRenderer

def pretty_hip(st): print('\n'.join(st.splitlines()[48:]))
def timeit(fxn):
  st = time.perf_counter()
  et = fxn()
  ret = time.perf_counter() - st # NOTE: et doesn't contain the launch overhead
  return ret

Tensor.manual_seed(42)
Device.DEFAULT = "HIP"
N = 2048
FLOPS = N*N*N*2
BW = N*N*3*4
a, b = Tensor.rand(N, N, dtype=dtypes.half), Tensor.rand(N, N, dtype=dtypes.half)
r = a.matmul(b, acc_dtype=dtypes.float)
print(r.numpy())

"""
sched = r.lazydata.schedule()
realized_ast, real_bufs = helper_realized_ast(r)
k = Linearizer(realized_ast)
k.apply_tensor_cores(1)
k.linearize()
code = HIPRenderer(ansistrip(k.name), k.uops)
prg = Device[Device.DEFAULT].to_program(k)
real_bufs[0].copyin(np.zeros((real_bufs[0].size, ), dtype=real_bufs[0].dtype.np).data) # Zero to check that all values are filled
tm = timeit(lambda: prg.exec(real_bufs))
data0 = np.frombuffer(real_bufs[0].as_buffer(), real_bufs[0].dtype.np)
print(f"{N*N:10d} {tm*1e6:9.2f} us, would be {FLOPS*1e-9/tm:9.2f} GFLOPS matmul, {BW*1e-9/tm:.2f} GB/s")
print(a.numpy())
print_globalcounters()
"""
