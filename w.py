import numpy as np, time
from tinygrad import Tensor, dtypes
from tinygrad.codegen.linearizer import Linearizer
from test.test_linearizer import helper_realized_ast
from tinygrad.device import Compiled, Device
from tinygrad.helpers import ansistrip
from tinygrad.graph import print_globalcounters
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
r.realize()
