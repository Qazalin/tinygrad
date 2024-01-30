#include <metal_stdlib>
using namespace metal;
template<typename T, typename S, typename U> U __metal_wmma(T m, T n, U o) {
  S a,b,c; a.thread_elements()[0] = m.x; a.thread_elements()[1] = m.y; b.thread_elements()[0] = n.x; b.thread_elements()[1] = n.y;
  c.thread_elements()[0] = o.x; c.thread_elements()[1] = o.y; simdgroup_multiply_accumulate(c, a, b, c);
  return U(c.thread_elements()[0], c.thread_elements()[1]);
}
kernel void r_256_2(device half* data0, const device float* data1, uint3 gid [[threadgroup_position_in_grid]], uint3 lid [[thread_position_in_threadgroup]]) {
  threadgroup float temp[256];
  int lidx0 = lid.x; /* 256 */
  float acc0 = 0.0f;
  for (int ridx0 = 0; ridx0 < 2; ridx0++) {
    float val0 = *(data1+(lidx0*2)+ridx0);
    acc0 = (val0+acc0);
  }
  *(temp+lidx0) = acc0;
  threadgroup_barrier(mem_flags::mem_threadgroup);
  if ((lidx0<1)) {
    float acc1 = 0.0f;
    for (int ridx1 = 0; ridx1 < 256; ridx1++) {
      float val1 = *(temp+ridx1);
      acc1 = (val1+acc1);
    }
    *(data0+0) = ((half)(acc1)*(half)(128.0f));
  }
}