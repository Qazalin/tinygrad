#include "kittens.cuh"
#include <math.h>
using namespace kittens;

extern "C" __global__ void custom_quantize_fp8_amax_pass2(float *amax_ptr, const float *partial_amax_ptr) {
  if (blockIdx.x != 0 || threadIdx.x != 0) return;
  float amax = 0.0f;
  for (int i = 0; i < PARTIAL_NUMEL; i++) amax = fmaxf(amax, partial_amax_ptr[i]);
  amax_ptr[0] = amax;
}
