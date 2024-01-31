#include "hip/hip_runtime.h"
#include "iostream"
#include "helpers.hpp"
#include <math.h>
#include <rocblas/rocblas.h>
#include <stdio.h>
#include <stdlib.h>
#include <vector>

__global__ void kernel() {
    
}

int main() {
    hipError_t     herror  = hipSuccess;
    rocblas_status rstatus = rocblas_status_success;

    rocblas_int incx = 10;
    rocblas_int incy = 2;
    rocblas_int n    = 4;

    rocblas_int nSize = n * std::max(incx, incy);
    std::vector<float> hostVecA(nSize);
    helpers::fillVectorNormRand(hostVecA, incx);
    std::vector<float> hostVecB(nSize);
    helpers::fillVectorNormRand(hostVecB, incy);

    std::cout << "Input Vectors" << std::endl;
    helpers::printVector(hostVecA, n, incx);
    helpers::printVector(hostVecB, n, incy);

    size_t vectorBytes = nSize * sizeof(float);

    float* deviceVecA;
    herror = hipMalloc(&deviceVecA, vectorBytes);
    CHECK_HIP_ERROR(herror);
    rstatus = rocblas_set_vector(nSize, sizeof(float), hostVecA.data(), incx, deviceVecA, incx);
    CHECK_ROCBLAS_STATUS(rstatus);
    float* deviceVecB;
    herror = hipMalloc(&deviceVecB, vectorBytes);
    CHECK_HIP_ERROR(herror);
    rstatus = rocblas_set_vector(nSize, sizeof(float), hostVecB.data(), incy, deviceVecB, incy);
    CHECK_ROCBLAS_STATUS(rstatus);

    rocblas_handle handle;
    rstatus = rocblas_create_handle(&handle);
    CHECK_ROCBLAS_STATUS(rstatus);
    rstatus = rocblas_sswap(handle, n, deviceVecA, incx, deviceVecB, incy);
    CHECK_ROCBLAS_STATUS(rstatus);

    rstatus = rocblas_get_vector(nSize, sizeof(float), deviceVecA, incx, hostVecA.data(), incx);
    CHECK_ROCBLAS_STATUS(rstatus);
    rstatus = rocblas_get_vector(nSize, sizeof(float), deviceVecB, incy, hostVecB.data(), incy);
    CHECK_ROCBLAS_STATUS(rstatus);

    std::cout << "Output Vectors" << std::endl;
    helpers::printVector(hostVecA, n, incx);
    helpers::printVector(hostVecB, n, incy);

    herror = hipFree(deviceVecA);
    CHECK_HIP_ERROR(herror);
    herror = hipFree(deviceVecB);
    CHECK_HIP_ERROR(herror);
    rstatus = rocblas_destroy_handle(handle);
    CHECK_ROCBLAS_STATUS(rstatus);

    return 0;
}
