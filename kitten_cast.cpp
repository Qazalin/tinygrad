// kitten_cast: bf16 -> fp8 quantization (matching tinygrad bf16 numerics exactly)
// ref chain from DEBUG=4:
//   rcp  = bf16(1.0 / float(bf16(float(amax) + float(bf16(1e-8)))))
//   step = bf16(float(rcp) * float(val))
//   scaled = bf16(float(step) * float(bf16(448)))
//   out  = f32_to_fp8(float(scaled))    -- with STE clamp logic
#include <hip/hip_runtime.h>
#include <hip/hip_bf16.h>

constexpr unsigned int TILE_ELEMS = 512; // 16*32

// exact copy of tinygrad's f32_to_fp8 (with NaN/Inf passthrough)
static __device__ __forceinline__ unsigned char f32_to_fp8(float v) {
  unsigned int bits = __float_as_uint(v);
  if ((bits & 0x7F800000u) != 0x7F800000u) v = __builtin_amdgcn_fmed3f(v, 448.0f, -448.0f);
  return (unsigned char)__builtin_amdgcn_cvt_pk_fp8_f32(v, v, 0, false);
}

extern "C" __global__ void kitten_cast(unsigned char *out_fp8, float *inv_scale,
                                       const __hip_bfloat16 *x, const float *amax) {
  // match tinygrad's bf16 truncation chain exactly
  // ref passes amax as bf16, so truncate our float32 amax to bf16 first
  float amax_f = __bfloat162float(__float2bfloat16(*amax));
  float eps_f = __bfloat162float(__float2bfloat16(1e-8f));       // float(bf16(1e-8))
  __hip_bfloat16 sum_bf = __float2bfloat16(amax_f + eps_f);     // bf16(float(amax) + float(bf16(1e-8)))
  __hip_bfloat16 rcp_bf = __float2bfloat16(1.0f / __bfloat162float(sum_bf));  // bf16(1/float(sum_bf))
  float rcp_f = __bfloat162float(rcp_bf);
  float fp8_max_f = __bfloat162float(__float2bfloat16(448.0f));  // float(bf16(448))

  int base = blockIdx.x * TILE_ELEMS;
  int tid = threadIdx.x;
  for (int i = tid; i < TILE_ELEMS; i += 64) {
    float val_f = __bfloat162float(x[base + i]);
    // step = bf16(rcp * val), then scaled = bf16(float(step) * 448)
    float step_f = __bfloat162float(__float2bfloat16(rcp_f * val_f));
    float scaled = __bfloat162float(__float2bfloat16(step_f * fp8_max_f));
    out_fp8[base + i] = f32_to_fp8(scaled);
  }

  if (blockIdx.x == 0 && threadIdx.x == 0) {
    // inv_scale = 1 / float(bf16(float(rcp) * float(bf16(448))))
    float scale_f = __bfloat162float(__float2bfloat16(rcp_f * fp8_max_f));
    *inv_scale = 1.0f / scale_f;
  }
}
