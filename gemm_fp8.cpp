#include "kittens.cuh"

using namespace kittens;

__global__ __launch_bounds__(512, 2) void hk_fp8_gemm(bf16 *C_ptr, fp8e4m3 *A_ptr, fp8e4m3 *B_ptr) {
}
