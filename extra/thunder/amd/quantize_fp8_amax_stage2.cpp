#include "kittens.cuh"
using namespace kittens;

extern "C" __global__ void custom_quantize_fp8_amax_stage2(float *amax_ptr, const float *partial_amax_ptr) {
}
