import time
from typing import cast
from tinygrad import Tensor
from tinygrad.codegen.linearizer import Linearizer
from tinygrad.device import Buffer, Device
from tinygrad.lazy import LazyBuffer
from tinygrad.realize import create_schedule

x = Tensor.arange(256).realize()
device = Device[Device.DEFAULT]
assert device.compiler is not None
x_buf = cast(Buffer,cast(LazyBuffer,x.lazydata).realized)

def timeit(fxn):
  st = time.perf_counter()
  fxn()
  return time.perf_counter() - st

lin = Linearizer(create_schedule([x.sum().lazydata])[-1].ast)
#lin.hand_coded_optimizations()
lin.linearize()
out_buf = Buffer(Device.DEFAULT, 1, x.dtype)
prg = device.to_program(lin)
baseline = prg.exec([out_buf, x_buf])
expected = out_buf.as_buffer().cast("I").tolist()[0]

code = """
#include <metal_stdlib>
using namespace metal;
kernel void r_(device int* data0, device int* data1, uint3 gid [[threadgroup_position_in_grid]], uint3 lid [[thread_position_in_threadgroup]]) {
    threadgroup int temp[256];
    int lidx0 = lid.x; /* 256 */
    int val0 = *(data1+lidx0);
    *(temp+lidx0) = val0;
    threadgroup_barrier(mem_flags::mem_threadgroup);

    for (int ridx0 = 1; ridx0 < 256; ridx0 *= 2) {
      if (lidx0 % (ridx0*2) == 0) {
        temp[lidx0] += temp[lidx0+ridx0];
      }
      threadgroup_barrier(mem_flags::mem_threadgroup);
    }

    if (lidx0 == 0) {
      *(data0+0) = temp[0];
    }
}
"""
global_size = (1,1,1)
local_size = (256,1,1)
lib = device.compiler.compile(code)
out_buf = Buffer(Device.DEFAULT, 1, x.dtype)
prg = device.runtime("r_", lib)
tm = prg(out_buf._buf, x_buf._buf, global_size=global_size, local_size=local_size, wait=True)
ret = out_buf.as_buffer().cast("I").tolist()[0]

assert ret == expected
print(baseline)
print(tm)
