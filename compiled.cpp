#include <hip/hip_runtime.h>
#define half _Float16

__global__ void kernel(int *data0, int *data1, int *data2) {
    int gidx0 = blockIdx.x;
    int data = *(data1+gidx0);
    *(data0+gidx0) = data;
}

int main()
{
    int c;
    int *dev_c;
    hipMalloc((void**)&dev_c, sizeof(int));
    hipMemcpy(&c, dev_c, sizeof(int), hipMemcpyDeviceToHost);
    hipFree(dev_c);
    return 0;
}
