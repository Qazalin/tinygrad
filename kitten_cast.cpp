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

static __device__ __forceinline__ unsigned char f32_to_fp8(float v) {
  unsigned int bits = __float_as_uint(v);
  if ((bits & 0x7F800000u) != 0x7F800000u) v = __builtin_amdgcn_fmed3f(v, 448.0f, -448.0f);
  return (unsigned char)__builtin_amdgcn_cvt_pk_fp8_f32(v, v, 0, false);
}

extern "C" __global__ void kitten_cast(unsigned char *out_fp8, float *inv_scale,
                                       const bf16 *x, const float *amax) {
  float amax_f = __bfloat162float(__float2bfloat16(*amax));
  float eps_f = __bfloat162float(__float2bfloat16(1e-8f));
  __hip_bfloat16 sum_bf = __float2bfloat16(amax_f + eps_f);
  __hip_bfloat16 rcp_bf = __float2bfloat16(1.0f / __bfloat162float(sum_bf));
  float rcp_f = __bfloat162float(rcp_bf);
  float fp8_max_f = __bfloat162float(__float2bfloat16(448.0f));

  int base = blockIdx.x * TILE_ELEMS;
  int tid = threadIdx.x;
#pragma unroll 4
  for (int i = tid; i < TILE_ELEMS; i += 64) {
    float val_f = __bfloat162float((__hip_bfloat16)x[base + i]);
    float step_f = __bfloat162float(__float2bfloat16(rcp_f * val_f));
    float scaled = __bfloat162float(__float2bfloat16(step_f * fp8_max_f));
    out_fp8[base + i] = f32_to_fp8(scaled);
  }

  if (blockIdx.x == 0 && threadIdx.x == 0) {
    float scale_f = __bfloat162float(__float2bfloat16(rcp_f * fp8_max_f));
    *inv_scale = 1.0f / scale_f;
  }
}
