#include "hip/hip_runtime.h"
#include "iostream"

__global__ void kernel() {
    printf("hello world\n");
}

int main() {
    hipLaunchKernelGGL(kernel, dim3(1), dim3(1), 0, 0);
    hipDeviceSynchronize();
    return 0;
}
