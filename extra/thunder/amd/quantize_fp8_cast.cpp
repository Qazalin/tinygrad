#include "kittens.cuh"
#include <math.h>
using namespace kittens;

extern "C" __global__ void custom_quantize_fp8_cast(fp8e4m3 *out_ptr, float *inv_scale_ptr, const bf16 *x_ptr, const float *amax_ptr) {
  float scale = FP8_MAX / (amax_ptr[0] + 1e-8f);
  if (blockIdx.x == 0 && threadIdx.x == 0) inv_scale_ptr[0] = 1.0f / scale;

  int gid = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for (int i = gid; i < NUMEL; i += stride) {
    float v = float(x_ptr[i]) * scale;
    v = fmaxf(-FP8_MAX, fminf(FP8_MAX, v));
    out_ptr[i] = base_types::convertor<fp8e4m3, float>::convert(v);
  }
}
