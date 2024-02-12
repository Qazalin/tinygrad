import time
import numpy as np
from tinygrad import dtypes
from tinygrad.helpers import getenv, prod, flat_mv
from tinygrad.runtime.ops_hip import HIPAllocator, HIPDevice, HIPProgram
from tinygrad.runtime.compiler.hip_comgr import  compile_hip as c, compile_hipold as h, get_rdna3

N = 2048
KX = 4;
KY = 4;
FLOPS = N*N*N*2
BW = N*N*3*4
kernel = "a"
CONFIG = {
    "a": (([N//(KX*16*2), N//(KY*16*2), 1], [32, 2, 2]), h),
    "b": (([8, 32, 1], [16, 2, 4]), c),
}

# Can HIPAllocator initialized as device=0 by default?
device = HIPDevice()
hipallocator = HIPAllocator(device)
a = hipallocator.alloc(N*N*4)
b = hipallocator.alloc(N*N*2)
c = hipallocator.alloc(N*N*2)
na = np.empty(N*N, np.float32)
nb = np.random.default_rng().standard_normal(size=(N,N), dtype=np.float32).astype(np.float16)
nc = np.random.default_rng().standard_normal(size=(N,N), dtype=np.float32).astype(np.float16)
hipallocator.copyin(b, bytearray(nb))
hipallocator.copyin(c, bytearray(nc))

with open (f"./kernels/{kernel}.c") as f: code = f.read()
lib = CONFIG[kernel][1](code)
prog = HIPProgram(device.device, "test", lib)
def timeit(fxn):
  st = time.perf_counter()
  et = fxn()
  ret = time.perf_counter() - st # NOTE: et doesn't contain the launch overhead
  return et

global_size, local_size = CONFIG[kernel][0]
print("global/local size", global_size, local_size, f"local_size:{prod(local_size)} total_size:{prod(global_size+local_size)}")
tm = min([timeit(lambda: prog(a, b, c, global_size=global_size, local_size=local_size, wait=True)) for _ in range(10)])
hipallocator.copyout(flat_mv(na.data),a)
na = na.reshape(N,N)
comp = nb.astype(np.float32) @ nc.astype(np.float32)
print(f"{N*N:10d} {tm*1e6:9.2f} us, would be {FLOPS*1e-9/tm:9.2f} GFLOPS matmul, {BW*1e-9/tm:.2f} GB/s")
np.testing.assert_allclose(na, comp, atol=1e-2, rtol=1e-2)
hipallocator._free(a); hipallocator._free(b); hipallocator._free(c)
with open(f"./asm/{kernel}.s", "w") as f: f.write(get_rdna3(lib))
