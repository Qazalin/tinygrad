// kitten_cast: bf16 -> fp8 quantization (matching tinygrad bf16 numerics exactly)
// ref chain from DEBUG=4:
//   rcp  = bf16(1.0 / float(bf16(float(amax) + float(bf16(1e-8)))))
//   step = bf16(float(rcp) * float(val))
//   scaled = bf16(float(step) * float(bf16(448)))
//   out  = f32_to_fp8(float(scaled))    -- with STE clamp logic
#include "kittens.cuh"
using namespace kittens;

#ifndef PARAM_TILE
#define PARAM_TILE 2048
#endif
constexpr unsigned int TILE_ELEMS = PARAM_TILE;

extern "C" __global__ void kitten_cast(unsigned char *out_fp8, float *inv_scale,
                                       const bf16 *x, const float *amax) {
  float scale = 448.0f / (*amax + 1e-8f);

  int base = blockIdx.x * TILE_ELEMS;
  int tid = threadIdx.x;
  fp8e4m3_4 *out4 = reinterpret_cast<fp8e4m3_4*>(out_fp8 + base);
#pragma unroll 4
  for (int i4 = tid; i4 < (int)(TILE_ELEMS/4); i4 += 64) {
    int i = i4 << 2;
    bf16_2 a = *reinterpret_cast<const bf16_2*>(x + base + i + 0);
    bf16_2 b = *reinterpret_cast<const bf16_2*>(x + base + i + 2);
    float2 fa = __bfloat1622float2((__hip_bfloat162)a);
    float2 fb = __bfloat1622float2((__hip_bfloat162)b);
    float4 v = make_float4(fa.x*scale, fa.y*scale, fb.x*scale, fb.y*scale);
    out4[i4] = base_types::convertor<fp8e4m3_4, float4>::convert(v);
  }

  if (blockIdx.x == 0 && threadIdx.x == 0) {
    *inv_scale = 1.0f / scale;
  }
}
