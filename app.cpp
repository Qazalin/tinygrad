#include <hip/hip_runtime.h>
#define half _Float16

__global__ void kernel(half *data0, half *data1, half *data2) {
    int gidx0 = blockIdx.x;
    half data = *(data1+gidx0);
    *(data0+gidx0) = data;
}

int main()
{
    int c;
    int *dev_c;
    hipMalloc((void**)&dev_c, sizeof(int));
    hipMemcpy(&c, dev_c, sizeof(int), hipMemcpyDeviceToHost);
    printf("data0=%d\n", c);
    hipFree(dev_c);
    return 0;
}
