// kitten_cast_amax_partial: fuse fp8 cast + per-block partial amax
#include <hip/hip_runtime.h>
#include "kittens.cuh"
using namespace kittens;

#ifndef PARAM_TILE
#define PARAM_TILE 16384
#endif
constexpr unsigned int TILE_ELEMS = PARAM_TILE;

extern "C" __global__ void kitten_cast_amax_partial(unsigned char *out_fp8, float *inv_scale, float *partials_out,
                                                      const bf16 *x, const float *amax_in) {
  float scale = 448.0f / (*amax_in + 1e-8f);

  int base = blockIdx.x * TILE_ELEMS;
  int tid = threadIdx.x;
  fp8e4m3_4 *out4 = reinterpret_cast<fp8e4m3_4*>(out_fp8 + base);
  float local_max = 0.0f;

  #pragma unroll 4
  for (int i4 = tid; i4 < (int)(TILE_ELEMS/4); i4 += 64) {
    int i = i4 << 2;
    bf16_2 a = *reinterpret_cast<const bf16_2*>(x + base + i + 0);
    bf16_2 b = *reinterpret_cast<const bf16_2*>(x + base + i + 2);
    float2 fa = __bfloat1622float2((__hip_bfloat162)a);
    float2 fb = __bfloat1622float2((__hip_bfloat162)b);
    local_max = fmaxf(local_max, fmaxf(fabsf(fa.x), fabsf(fa.y)));
    local_max = fmaxf(local_max, fmaxf(fabsf(fb.x), fabsf(fb.y)));
    float4 v = make_float4(fa.x*scale, fa.y*scale, fb.x*scale, fb.y*scale);
    out4[i4] = base_types::convertor<fp8e4m3_4, float4>::convert(v);
  }

  for (int ofs = 32; ofs > 0; ofs >>= 1) local_max = fmaxf(local_max, __shfl_xor(local_max, ofs, 64));
  if (tid == 0) partials_out[blockIdx.x] = local_max;

  if (blockIdx.x == 0 && tid == 0) *inv_scale = 1.0f / scale;
}
