from tinygrad import Tensor, dtypes
from tinygrad.engine.realize import ProgramSpec, CompiledRunner

sw = 1024
sh = 1024
src = kernel = f"""
extern "C" __global__ void test(int* C, const int* A, const int* B) {{
  size_t gidx0 = (threadIdx.x + (blockDim.x * (size_t)blockIdx.x));
  size_t gidx1 = (threadIdx.y + (blockDim.y * (size_t)blockIdx.y));
  if ((gidx0 < {sh}) && (gidx1 < {sw})) {{
    size_t lin = (gidx0 * {sw}) + gidx1;
    *(C + lin) = (*(A + lin)) + (*(B + lin));
  }}
}}
"""
a = Tensor.full((sw, sh), 1, dtype=dtypes.int32).contiguous().realize()
b = Tensor.full((sw, sh), 2, dtype=dtypes.int32).contiguous().realize()
c = Tensor.full((sw, sh), 0, dtype=dtypes.int32).contiguous().realize()
prg = ProgramSpec("test", src, "CUDA", None, global_size=[32, 32, 1], local_size=[32, 32, 1])
car = CompiledRunner(prg)
car([t.uop.base.buffer for t in (a, b, c)], {}, wait=True)
print(a.numpy())
