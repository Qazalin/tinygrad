// fuse fp8 cast with atomic amax update
#include <hip/hip_runtime.h>
#include "kittens.cuh"
using namespace kittens;

#ifndef PARAM_TILE
#define PARAM_TILE 2048
#endif
constexpr unsigned int TILE_ELEMS = PARAM_TILE;

__device__ __forceinline__ void atomicMaxFloatNonNeg(float *addr, float value) {
  atomicMax(reinterpret_cast<int*>(addr), __float_as_int(value));
}

extern "C" __global__ void kitten_cast_amax_fused(unsigned char *out_fp8, float *inv_scale, float *amax_out,
                                                    const bf16 *x, const float *amax_in) {
  bf16 eps = bf16(1e-8f);
  bf16 one = bf16(1.0f);
  bf16 fp8_max = bf16(448.0f);
  bf16 denom = bf16((float)(*amax_in) + (float)eps);
  bf16 rcp = bf16((float)one / (float)denom);

  int base = blockIdx.x * TILE_ELEMS;
  int tid = threadIdx.x;
  fp8e4m3_4 *out4 = reinterpret_cast<fp8e4m3_4*>(out_fp8 + base);
  float local_max = 0.0f;

#pragma unroll 4
  for (int i4 = tid; i4 < (int)(TILE_ELEMS / 4); i4 += 64) {
    int i = i4 << 2;
    bf16_2 a = *reinterpret_cast<const bf16_2*>(x + base + i + 0);
    bf16_2 b = *reinterpret_cast<const bf16_2*>(x + base + i + 2);
    float2 fa = __bfloat1622float2((__hip_bfloat162)a);
    float2 fb = __bfloat1622float2((__hip_bfloat162)b);
    local_max = fmaxf(local_max, fmaxf(fabsf(fa.x), fabsf(fa.y)));
    local_max = fmaxf(local_max, fmaxf(fabsf(fb.x), fabsf(fb.y)));

    bf16 q0 = bf16((float)bf16((float)rcp * fa.x) * (float)fp8_max);
    bf16 q1 = bf16((float)bf16((float)rcp * fa.y) * (float)fp8_max);
    bf16 q2 = bf16((float)bf16((float)rcp * fb.x) * (float)fp8_max);
    bf16 q3 = bf16((float)bf16((float)rcp * fb.y) * (float)fp8_max);
    float4 v = make_float4((float)q0, (float)q1, (float)q2, (float)q3);
    v.x = fmaxf(-448.0f, fminf(448.0f, v.x));
    v.y = fmaxf(-448.0f, fminf(448.0f, v.y));
    v.z = fmaxf(-448.0f, fminf(448.0f, v.z));
    v.w = fmaxf(-448.0f, fminf(448.0f, v.w));
    out4[i4] = base_types::convertor<fp8e4m3_4, float4>::convert(v);
  }

  for (int ofs = 32; ofs > 0; ofs >>= 1) local_max = fmaxf(local_max, __shfl_xor(local_max, ofs, 64));
  if (tid == 0) atomicMaxFloatNonNeg(amax_out, local_max);

  if (blockIdx.x == 0 && tid == 0) {
    bf16 scale = bf16((float)fp8_max / (float)denom);
    *inv_scale = 1.0f / (float)scale;
  }
}
