import metalcompute as mc
mc.init()

code = """
#include <metal_stdlib>
using namespace metal;

kernel void kkl(
    const device float* in [[ buffer(0) ]],
    device float* out [[ buffer(1) ]],
    uint id [[ thread_position_in_grid ]]) {
    out[id] = in[0] / in[1];
}
"""
mc.compile(code, "kkl")
import numpy as np
input = np.array([4,3], dtype=np.float32)
output = np.zeros_like(input)
c = 250000000
mc.run(input, output, c)
print(output)
