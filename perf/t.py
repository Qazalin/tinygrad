from typing import cast
from tinygrad import Tensor
from tinygrad.device import Buffer, Device
from tinygrad.lazy import LazyBuffer

x = Tensor.arange(256).realize()
device = Device[Device.DEFAULT]
x_buf = cast(Buffer,cast(LazyBuffer,x.lazydata).realized)

def run(code, global_size, local_size):
  assert device.compiler is not None
  lib = device.compiler.compile(code)
  out_buf = Buffer(Device.DEFAULT, 1, x.dtype)
  prg = device.runtime("r_256", lib)
  tm = prg(out_buf._buf, x_buf._buf, global_size=global_size, local_size=local_size, wait=True)

  expected = x.sum().numpy()
  out = out_buf.as_buffer().cast("I").tolist()[0]
  assert out == expected, f"{out}"
  print(tm)

# Interleaved Addressing 1
code = """
#include <metal_stdlib>
using namespace metal;
kernel void r_256(device int* data0, device int* data1, uint3 gid [[threadgroup_position_in_grid]], uint3 lid [[thread_position_in_threadgroup]]) {
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

# Interleaved Addressing 2
code = """
#include <metal_stdlib>
using namespace metal;
kernel void r_256(device int* data0, device int* data1, uint3 gid [[threadgroup_position_in_grid]], uint3 lid [[thread_position_in_threadgroup]]) {
    threadgroup int temp[256];
    int lidx0 = lid.x; /* 256 */
    int val0 = *(data1+lidx0);
    *(temp+lidx0) = val0;
    threadgroup_barrier(mem_flags::mem_threadgroup);

    for (int ridx0 = 1; ridx0 < 256; ridx0 *= 2) {
      int idx = 2 * ridx0 * lidx0;
      if (idx < 256) {
        temp[idx] += temp[idx+ridx0];
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

# Sequential Addressing
code = """
#include <metal_stdlib>
using namespace metal;
kernel void r_256(device int* data0, device int* data1, uint3 gid [[threadgroup_position_in_grid]], uint3 lid [[thread_position_in_threadgroup]]) {
    threadgroup int temp[256];
    int lidx0 = lid.x; /* 256 */
    int val0 = *(data1+lidx0);
    *(temp+lidx0) = val0;
    threadgroup_barrier(mem_flags::mem_threadgroup);

    for (int ridx0 = 256/2; ridx0 > 0; ridx0/=2) {
      if (lidx0 < ridx0) {
        temp[lidx0] += temp[lidx0 + ridx0];
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

# Unroll the Last Warp + first add then reduce
code = """
#include <metal_stdlib>
using namespace metal;
kernel void r_256(device int* data0, device int* data1, uint3 gid [[threadgroup_position_in_grid]], uint3 lid [[thread_position_in_threadgroup]]) {
    threadgroup int temp[256];
    int lidx0 = lid.x; /* 128 */
    int val0 = *(data1+lidx0);
    int val1 = *(data1+lidx0+128);
    *(temp+lidx0) = val0 + val1;
    threadgroup_barrier(mem_flags::mem_threadgroup);

    for (int ridx0 = 256/4; ridx0 > 32; ridx0/=2) {
      if (lidx0 < ridx0) {
        temp[lidx0] += temp[lidx0 + ridx0];
      }
      threadgroup_barrier(mem_flags::mem_threadgroup);
    }

    // no volatile in metal
    if (lidx0 < 32) {
      temp[lidx0] += temp[lidx0 + 32];
      threadgroup_barrier(mem_flags::mem_threadgroup);
      temp[lidx0] += temp[lidx0 + 16];
      threadgroup_barrier(mem_flags::mem_threadgroup);
      temp[lidx0] += temp[lidx0 + 8];
      threadgroup_barrier(mem_flags::mem_threadgroup);
      temp[lidx0] += temp[lidx0 + 4];
      threadgroup_barrier(mem_flags::mem_threadgroup);
      temp[lidx0] += temp[lidx0 + 2];
      threadgroup_barrier(mem_flags::mem_threadgroup);
      temp[lidx0] += temp[lidx0 + 1];
    }

    if (lidx0 == 0) {
      *(data0+0) = temp[0];
    }
}
"""
global_size = (1,1,1)
local_size = (128,1,1)
run(code, global_size, local_size)
