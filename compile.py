import subprocess
from tinygrad.runtime.ops_hip import compile_hip

lib = compile_hip("""
  #include <hip/hip_common.h>
#define INFINITY (__builtin_inff())
#define NAN (__builtin_nanf(""))
  typedef float float8 __attribute__((ext_vector_type(8)));
  __device__ float8 make_float8(float x, float y, float z, float w, float a, float b, float c, float d) { return {x, y, z, w, a, b, c, d}; }
  extern "C" __global__
void __launch_bounds__ (2, 1) r_5_2_10(int* data0) {
  int gidx0 = blockIdx.x; // 5
  int lidx1 = threadIdx.x; // 2
  int acc0 = 0;

  // Calculate alu0
  int alu0 = ((gidx0 * (-2)) + (lidx1 * (-1)));

  // Break down the complex assignment into multiple steps
  int condition0 = (alu0 < 0) ? 1 : 0;
  int condition1 = (alu0 < -1) ? 1 : 0;
  int condition2 = (alu0 < -2) ? 1 : 0;
  int condition3 = (alu0 < -3) ? 1 : 0;
  int condition4 = (alu0 < -4) ? 1 : 0;
  int condition5 = (alu0 < -5) ? 1 : 0;
  int condition6 = (alu0 < -6) ? 1 : 0;
  int condition7 = (alu0 < -7) ? 1 : 0;
  int condition8 = (alu0 < -8) ? 1 : 0;

  // Sum all conditions
  int sumOfConditions = condition0 + condition1 + condition2 + condition3 + condition4 + condition5 + condition6 + condition7 + condition8 + acc0;

  // Final assignment to the data array
  *(data0 + (gidx0 * 2) + lidx1) = 1 + sumOfConditions - 1;
}
""")
asm = subprocess.check_output(["/opt/rocm/llvm/bin/llvm-objdump", '-d', '-'], input=lib)
instructions = [x for x in asm.decode('utf-8').split("\n") if 's_code_end' not in x]
cndm = 0
for i in instructions:
  if "v_add_co_ci_u32_e32" in i:
    cndm += 1
asm = '\n'.join(instructions)
print(len(instructions))
