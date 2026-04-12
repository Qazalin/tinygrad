// kitten_amax_reduce: two-pass amax stage 2
// reduce float partial maxima to one scalar max (single block)
#include <hip/hip_runtime.h>

extern "C" __global__ void kitten_amax_reduce(float *amax_out, const float *partials_in) {
  constexpr unsigned int VALID = PARAM_VALID;
  constexpr unsigned int BLOCK = 256;
  __shared__ float smax[BLOCK];

  const unsigned int tid = threadIdx.x;
  float v = 0.0f;
  for (unsigned int i = tid; i < VALID; i += BLOCK) v = fmaxf(v, partials_in[i]);
  smax[tid] = v;
  __syncthreads();

  for (unsigned int s = BLOCK >> 1; s > 0; s >>= 1) {
    if (tid < s) smax[tid] = fmaxf(smax[tid], smax[tid + s]);
    __syncthreads();
  }

  if (tid == 0) amax_out[0] = smax[0];
}
