#include "kittens.cuh"
using namespace kittens;

extern "C" __global__ void custom_quantize_fp8_cast(unsigned char *out, float *inv_scale, const __bf16 *x, const float *amax) {
}
