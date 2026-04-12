// kitten_cast: bf16 -> fp8 quantization
// reads amax (float32), computes scale = 448/(amax+eps), applies scale+clamp+cast
// one 16x32 tile per workgroup, 1 warp (64 threads) per workgroup
// 512 elements per tile, 8 elements per thread
#include <hip/hip_runtime.h>
#include <hip/hip_bf16.h>

constexpr unsigned int TILE_ELEMS = 512; // 16*32
constexpr float FP8_MAX = 448.0f;
constexpr float EPS = 1e-8f;

static __device__ __forceinline__ unsigned char f32_to_fp8(float v) {
  v = __builtin_amdgcn_fmed3f(v, FP8_MAX, -FP8_MAX);
  return (unsigned char)__builtin_amdgcn_cvt_pk_fp8_f32(v, v, 0, false);
}

extern "C" __global__ void kitten_cast(unsigned char *out_fp8, float *inv_scale,
                                       const __hip_bfloat16 *x, const float *amax) {
  constexpr unsigned int N = PARAM_N;
  const float scale = FP8_MAX / (*amax + EPS);

  int base = blockIdx.x * TILE_ELEMS;
  int tid = threadIdx.x;
  for (int i = tid; i < TILE_ELEMS; i += 64) {
    float val = __bfloat162float(x[base + i]) * scale;
    out_fp8[base + i] = f32_to_fp8(val);
  }

  if (blockIdx.x == 0 && threadIdx.x == 0) *inv_scale = 1.0f / scale;
}
