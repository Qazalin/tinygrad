#include <hip/hip_common.h>
extern "C" __global__ void __launch_bounds__ (128, 1) test(float* data0, __half* data1, __half* data2) {
    int gidx0 = blockIdx.y; // 2
    int gidx1 = blockIdx.x; // 2

    float acc0 = 0.0;
  int alu0 = (gidx0*2);
  for (int ridx0 = 0; ridx0 < 2; ridx0++) {
    half val0 = *(data1+alu0+ridx0);
    half val1 = *(data2+gidx1+(ridx0*2));
    printf("%d %d [%d] %f %f %f\n", gidx0, gidx1, ridx0, (float)val0, (float)val1, acc0);
    acc0 = (((float)(val0)*(float)(val1))+acc0);
  }
  *(data0+alu0+gidx1) = acc0;
}
