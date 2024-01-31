#include "hip/hip_runtime.h"
#include "iostream"

__global__ void kernel() {
    asm volatile (
        "s_mov_b32_e32 s69 42\n"
        "v_mov_b32_e32 v10 10\n"
        "s_add_i32 s10 s20 s69\n"
    );
}

int main() {
    hipLaunchKernelGGL(kernel, dim3(1), dim3(1), 0, 0);
    hipDeviceSynchronize();
    return 0;
}
