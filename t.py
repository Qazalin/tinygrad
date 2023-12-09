import numpy as np
from tinygrad.helpers import dtypes
from tinygrad.tensor import Tensor

a0 = 8.507061647788125e+27
b0 = 8.507060187143942e+37
d = dtypes.float32

print("------------------ tinygrad ------------------")

a = Tensor([a0], dtype=d)
b = Tensor([b0], dtype=d)
out = a / b
print(out.numpy())

print("------------------ numpy ------------------")
a = np.array([a0], dtype=d.np)
b = np.array([b0], dtype=d.np)
out = a / b
print(out)

print("------------------ metal ------------------")
import metalcompute as mc
mc.init()

code = """
#include <metal_stdlib>
using namespace metal;

kernel void kkl(
    const device float* in [[ buffer(0) ]],
    device float* out [[ buffer(1) ]],
    uint id [[ thread_position_in_grid ]]) {
    float a = 8.507061647788125e+27;
    float b = 8.507060187143942e+37;
    out[0] = a / b;
    float a1 = in[0];
    float b1 = in[1];
    out[1] = precise::divide(a1, b1);
    out[2] = in[0];
    out[3] = in[1];
}
"""
a0 = 8.507061647788125e+27
b0 = 8.507060187143942e+37
input = np.array([a0, b0], dtype=d.np)
mc.compile(code, "kkl")
import numpy as np
output = np.zeros(4, dtype=d.np)
c = 250000000
mc.run(input, output, c)
print(output)
