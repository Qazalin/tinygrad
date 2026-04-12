// stub: writes zeros to out_fp8, 1.0f to inv_scale
#include <hip/hip_runtime.h>
#include <hip/hip_bf16.h>

__global__ __launch_bounds__(256)
void kitten_cast(unsigned char *out_fp8, float *inv_scale,
                 const __hip_bfloat16 *x, const float *amax) {
  const int tid = blockIdx.x * blockDim.x + threadIdx.x;
  const int stride = gridDim.x * blockDim.x;
  for (int i = tid; i < PARAM_N; i += stride) out_fp8[i] = 0;
  if (blockIdx.x == 0 && threadIdx.x == 0) *inv_scale = 1.0f;
}
