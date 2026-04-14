#include "kittens.cuh"
#include <math.h>
using namespace kittens;

extern "C" __global__ void custom_quantize_fp8_amax_pass1(float *partial_amax_ptr, const bf16 *x_ptr) {
  if (threadIdx.x != 0) return;
  float local_max = 0.0f;
  for (int i = blockIdx.x; i < NUMEL; i += gridDim.x) {
    float v = fabsf(float(x_ptr[i]));
    local_max = fmaxf(local_max, v);
  }
  partial_amax_ptr[blockIdx.x] = local_max;
}
