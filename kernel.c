#include <hip/hip_common.h>

#define INFINITY (__builtin_inff())
#define NAN (__builtin_nanf(""))

extern "C" __global__ void __launch_bounds__ (16, 1) r_256_16_16(int* data0) {
  __shared__ int temp[16];
  int gidx0 = 1; /* 256 */
  int lidx1 = threadIdx.x; /* 16 */
  int acc0 = 0;
  for (int ridx0 = 0; ridx0 < 16; ridx0++) {
    acc0 = (((((gidx0*(-1))+(lidx1*(-16))+(ridx0*(-1)))<(-254))?1:0)+acc0);
  }

  *(temp+lidx1) = acc0;
  __syncthreads();
  if ((lidx1<1)) {
    int acc1 = 0;
    for (int ridx1 = 0; ridx1 < 16; ridx1++) {
      int val0 = *(temp+ridx1);
      acc1 = (val0+acc1);
      // printf("gid=%d lid=%d rid=%d val0=%d acc=%d\n", gidx0, lidx1, ridx1, val0, acc1);
    }
    *(data0+gidx0) = acc1;
  }
}
