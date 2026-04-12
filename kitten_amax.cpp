// stub: writes 1.0f to amax_out
#include <hip/hip_runtime.h>
#include <hip/hip_bf16.h>

__global__ __launch_bounds__(256)
void kitten_amax(float *amax_out, const __hip_bfloat16 *x) {
  if (blockIdx.x == 0 && threadIdx.x == 0) *amax_out = 1.0f;
}
