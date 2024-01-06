import subprocess
from tinygrad.runtime.ops_hip import compile_hip

lib = compile_hip("""
#include <hip/hip_common.h>
#define INFINITY (__builtin_inff())
#define NAN (__builtin_nanf(""))
  typedef float float8 __attribute__((ext_vector_type(8)));
  __device__ float8 make_float8(float x, float y, float z, float w, float a, float b, float c, float d) { return {x, y, z, w, a, b, c, d}; }
  extern "C" __global__
  void __launch_bounds__ (1, 1) r_10_10(int* data0) {
  int gidx0 = blockIdx.x; /* 10 */
  int acc0 = 0;
  for (int ridx0 = 0; ridx0 < 3; ridx0++) {
    acc0 = acc0 + ridx0;
  }
  *(data0+gidx0) = (acc0+(-1));
}
""")
asm = subprocess.check_output(["/opt/rocm/llvm/bin/llvm-objdump", '-d', '-'], input=lib)
instructions = [x for x in asm.decode('utf-8').split("\n") if 's_code_end' not in x]
cndm = 0
for i in instructions:
  if "v_add_co_ci_u32_e32" in i:
    cndm += 1
asm = '\n'.join(instructions)
print(asm)
print(len(instructions), cndm)
