#include <hip/hip_common.h>
#define INFINITY (__builtin_inff())
#define NAN (__builtin_nanf(""))
  #define launch_bounds_impl0(requiredMaxThreadsPerBlock)                                           __attribute__((amdgpu_flat_work_group_size(1, requiredMaxThreadsPerBlock)))
  #define launch_bounds_impl1(requiredMaxThreadsPerBlock, minBlocksPerMultiprocessor)               __attribute__((amdgpu_flat_work_group_size(1, requiredMaxThreadsPerBlock), amdgpu_waves_per_eu(minBlocksPerMultiprocessor)))
  #define select_impl_(_1, _2, impl_, ...) impl_
  #define __launch_bounds__(...) select_impl_(__VA_ARGS__, launch_bounds_impl1, launch_bounds_impl0)(__VA_ARGS__)
  typedef long unsigned int size_t;
  #define half _Float16
  struct hip_bfloat16 { unsigned short data; };

  extern "C" __attribute__((device)) __attribute__((const)) size_t __ockl_get_local_id(unsigned int);
  extern "C" __attribute__((device)) __attribute__((const)) size_t __ockl_get_group_id(unsigned int);
  extern "C" __attribute__((device)) __attribute__((const)) size_t __ockl_get_local_size(unsigned int);

  extern "C" {
  __attribute__((device)) __attribute__((const)) float __ocml_fmax_f32(float, float);
  __attribute__((device)) __attribute__((pure)) float __ocml_exp2_f32(float);
  __attribute__((device)) __attribute__((pure)) float __ocml_log2_f32(float);
  __attribute__((device)) float __ocml_sin_f32(float);
  __attribute__((device)) __attribute__((const)) float __ocml_sqrt_f32(float);
  __attribute__((device)) __attribute__((const)) _Float16 __ocml_fmax_f16(_Float16, _Float16);
  __attribute__((device)) __attribute__((pure)) _Float16 __ocml_exp2_f16(_Float16);
  __attribute__((device)) __attribute__((pure)) _Float16 __ocml_log2_f16(_Float16);
  __attribute__((device)) _Float16 __ocml_sin_f16(_Float16);
  __attribute__((device)) __attribute__((const)) _Float16 __ocml_sqrt_f16(_Float16);
  }
typedef signed int int2 __attribute__((ext_vector_type(2)));
static inline __attribute__((device)) int2 make_int2(signed int x, signed int y) { return {x, y}; }
typedef _Float16 half2 __attribute__((ext_vector_type(2)));
static inline __attribute__((device)) half2 make_half2(_Float16 x, _Float16 y) { return {x, y}; }
typedef _Float16 half4 __attribute__((ext_vector_type(4)));
static inline __attribute__((device)) half4 make_half4(_Float16 x, _Float16 y, _Float16 z, _Float16 w) { return {x, y, z, w}; }
typedef _Float16 half8 __attribute__((ext_vector_type(8)));
static inline __attribute__((device)) half8 make_half8(_Float16 x, _Float16 y, _Float16 z, _Float16 w, _Float16 a, _Float16 b, _Float16 c, _Float16 d) { return {x, y, z, w, a, b, c, d}; }
typedef _Float16 half16 __attribute__((ext_vector_type(16)));
static inline __attribute__((device)) half16 make_half16(_Float16 x, _Float16 y, _Float16 z, _Float16 w, _Float16 a, _Float16 b, _Float16 c, _Float16 d, _Float16 e, _Float16 f, _Float16 g, _Float16 h, _Float16 i, _Float16 j, _Float16 k, _Float16 l) { return {x, y, z, w, a, b, c, d, e, f, g, h, i, j, k, l}; }
typedef float float2 __attribute__((ext_vector_type(2)));
static inline __attribute__((device)) float2 make_float2(float x, float y) { return {x, y}; }
typedef float float4 __attribute__((ext_vector_type(4)));
static inline __attribute__((device)) float4 make_float4(float x, float y, float z, float w) { return {x, y, z, w}; }
typedef float float8 __attribute__((ext_vector_type(8)));
static inline __attribute__((device)) float8 make_float8(float x, float y, float z, float w, float a, float b, float c, float d) { return {x, y, z, w, a, b, c, d}; }extern "C" __attribute__((global))void __launch_bounds__ (128, 1) E_5_1024_4_2_8_16_4(half* data0, const half* data1, const half* data2, const half* data3) {
  int gidx0 = __ockl_get_group_id(2); /* 5 */
  int gidx1 = __ockl_get_group_id(1); /* 1024 */
  int gidx2 = __ockl_get_group_id(0); /* 8 */
  int lidx4 = __ockl_get_local_id(1); /* 8 */
  int lidx5 = __ockl_get_local_id(0); /* 16 */
  int alu0 = ((gidx1*2048)%51200);
  int alu1 = (gidx2/2);
  int alu2 = (gidx2%2);
  int alu3 = (alu2*32);
  int alu4 = (lidx5*2);
  int alu5 = ((gidx0*10240)+alu0+(alu1*512)+alu3+(lidx4*64)+alu4);
  int alu6 = ((alu5%51200)*2);
  bool alu7 = (gidx1<5);
  half val0 = (alu7?*(data1+alu6):(half)(0.0f));
  int alu8 = (((alu5+1)%51200)*2);
  half val1 = (alu7?*(data1+alu8):(half)(0.0f));
  half alu9 = (alu7?(half)(1.5707963267948966f):(half)(0.0f));
  half val2 = (alu7?*(data2+((alu1+((lidx4+((alu2+((lidx5+((gidx1*1024)%25600))/16))/2))/8))/4)%5):(half)(0.0f));
  half val3 = (alu7?*(data2+((alu1+((lidx4+((alu2+((lidx5+((alu0+1)/2))/16))/2))/8))/4)%5):(half)(0.0f));
  int alu10 = (alu0+alu3+alu4);
  half val4 = (alu7?*(data3+alu10%64):(half)(0.0f));
  half val5 = (alu7?*(data3+(alu10+1)%64):(half)(0.0f));
  half val6 = (alu7?*(data1+alu6+1):(half)(0.0f));
  half val7 = (alu7?*(data1+alu8+1):(half)(0.0f));
  half alu11 = (val2*val4);
  half alu12 = (val3*val5);
  half alu13 = __ocml_sin_f16((half)(0.0f));
  half alu14 = (__ocml_sin_f16((alu9-alu11))+alu13);
  half alu15 = (__ocml_sin_f16((alu9-alu12))+alu13);
  half alu16 = (alu13+__ocml_sin_f16(alu11));
  half alu17 = (alu13+__ocml_sin_f16(alu12));
  *((half4*)(data0+(gidx0*4194304)+(gidx1*4096)+(alu1*1024)+(alu2*64)+(lidx4*128)+(lidx5*4))) = (half4)make_half4(((val0*alu14)-(val6*alu16)),((val0*alu16)+(val6*alu14)),((val1*alu15)-(val7*alu17)),((val1*alu17)+(val7*alu15)));
}