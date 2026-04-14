#include "kittens.cuh"
using namespace kittens;

extern "C" __global__ void custom_quantize_fp8_amax(float *amax, const __bf16 *x) {
}
