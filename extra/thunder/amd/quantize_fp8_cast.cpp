#include "kittens.cuh"
using namespace kittens;

extern "C" __global__ void custom_quantize_fp8_cast(fp8e4m3 *out_ptr, float *inv_scale_ptr, const bf16 *x_ptr, const float *amax_ptr) {
}
