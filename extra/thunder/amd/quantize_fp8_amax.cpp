#include "kittens.cuh"
#include <math.h>
using namespace kittens;

extern "C" __global__ void custom_quantize_fp8_amax(float *amax_ptr, const bf16 *x_ptr) {
  if (blockIdx.x != 0 || threadIdx.x != 0) return;
  float amax = 0.0f;
  for (int i = 0; i < NUMEL; i++) amax = fmaxf(amax, fabsf(float(x_ptr[i])));
  amax_ptr[0] = amax;
}
