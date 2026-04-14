#include "kittens.cuh"
using namespace kittens;

extern "C" __global__ void custom_quantize_fp8_amax(float *amax_ptr, const bf16 *x_ptr) {
}
