#include <hip/hip_runtime.h>

#ifndef NUM_PARTIALS
constexpr unsigned int NUM_PARTIALS = 1;
#endif

#ifndef BLOCK
constexpr unsigned int BLOCK = 256;
#endif

__global__ void custom_quantize_fp8_amax_reduce(float *amax_ptr, const float *partials_ptr) {
  __shared__ float smax[BLOCK];

  unsigned int tid = threadIdx.x;
  float v = 0.0f;
  for (unsigned int i = tid; i < NUM_PARTIALS; i += BLOCK) v = fmaxf(v, partials_ptr[i]);

  smax[tid] = v;
  __syncthreads();

  for (unsigned int s = BLOCK >> 1; s > 0; s >>= 1) {
    if (tid < s) smax[tid] = fmaxf(smax[tid], smax[tid + s]);
    __syncthreads();
  }

  if (tid == 0) amax_ptr[0] = smax[0];
}
