// kitten_amax_reduce: two-pass amax stage 2
// reduce float partial maxima to one scalar max (single block)
#include <hip/hip_runtime.h>

extern "C" __global__ void kitten_amax_reduce(float *amax_out, const float *partials_in) {
  constexpr unsigned int VALID = PARAM_VALID;
  constexpr unsigned int BLOCK = 64;
  const unsigned int tid = threadIdx.x;

  float v = 0.0f;
  #pragma unroll 4
  for (unsigned int i = tid; i < VALID; i += BLOCK) v = fmaxf(v, partials_in[i]);

  for (int ofs = 32; ofs > 0; ofs >>= 1) v = fmaxf(v, __shfl_xor(v, ofs, 64));
  if (tid == 0) amax_out[0] = v;
}
