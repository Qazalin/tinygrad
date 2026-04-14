#include "kittens.cuh"
using namespace kittens;

#ifndef QFP8_N
constexpr unsigned int QFP8_N = 1;
#endif

#ifndef QFP8_FP8_MAX
constexpr float QFP8_FP8_MAX = 448.0f;
#endif

__global__ void custom_quantize_fp8_cast(fp8e4m3 *out_ptr, float *inv_scale_ptr, const bf16 *x_ptr, const float *amax_ptr) {
  float scale = QFP8_FP8_MAX / (amax_ptr[0] + 1e-8f);
  if (blockIdx.x == 0 && threadIdx.x == 0) inv_scale_ptr[0] = 1.0f / scale;

  unsigned int gid = blockIdx.x * blockDim.x + threadIdx.x;
  if (gid >= QFP8_N) return;

  float v = static_cast<float>(x_ptr[gid]) * scale;
  v = fminf(QFP8_FP8_MAX, fmaxf(-QFP8_FP8_MAX, v));
  out_ptr[gid] = fp8e4m3(v);
}
