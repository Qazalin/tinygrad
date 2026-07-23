#include <hip/hip_bf16.h>
#include <hip/hip_runtime.h>

#ifndef ROWS
#define ROWS 1
#endif
#ifndef K_DIM
#define K_DIM 32
#endif
#ifndef THREADS_PER_WG
#define THREADS_PER_WG 256
#endif
#ifndef USE_HADAMARD
#define USE_HADAMARD 0
#endif

constexpr int BLK = 32;
constexpr int N_BLOCKS = ROWS * K_DIM / BLK;
static_assert(K_DIM % BLK == 0, "K_DIM must be divisible by 32");

__device__ __forceinline__ void hadamard16(float *x) {
  #pragma unroll
  for (int stride = 1; stride < 16; stride <<= 1) {
    #pragma unroll
    for (int base = 0; base < 16; base += 2 * stride) {
      #pragma unroll
      for (int i = 0; i < stride; i++) {
        const float a = x[base + i], b = x[base + stride + i];
        x[base + i] = a + b;
        x[base + stride + i] = a - b;
      }
    }
  }
  #pragma unroll
  for (int i = 0; i < 16; i++) x[i] *= 0.25f;
}

__device__ __forceinline__ uint8_t encode_e2m1(float x) {
  const float a = fabsf(x);
  uint8_t code = (a >= 0.25f) + (a >= 0.75f) + (a >= 1.25f) + (a >= 1.75f) +
                 (a >= 2.5f) + (a >= 3.5f) + (a >= 5.0f);
  return code | (uint8_t(signbit(x)) << 3);
}

extern "C" __global__ __launch_bounds__(THREADS_PER_WG) void
quantize_mxfp4(uint8_t *__restrict__ q, uint8_t *__restrict__ e8_out,
               const __hip_bfloat16 *__restrict__ x) {
  const int block = blockIdx.x * THREADS_PER_WG + threadIdx.x;
  if (block >= N_BLOCKS) return;

  float vals[BLK];
  const long long input = (long long)block * BLK;
  #pragma unroll
  for (int i = 0; i < BLK; i++) vals[i] = float(x[input + i]);
  if constexpr (USE_HADAMARD) {
    hadamard16(vals);
    hadamard16(vals + 16);
  }

  float amax = 0.0f;
  #pragma unroll
  for (int i = 0; i < BLK; i++) amax = fmaxf(amax, fabsf(vals[i]));

  union { float f; uint32_t u; } rounded{amax};
  rounded.u = (rounded.u + 0x200000u) & 0xFF800000u;
  int unbiased = int(floorf(log2f(fmaxf(rounded.f, 1e-45f)))) - 2;
  unbiased = max(-127, min(127, unbiased));
  const uint8_t e8 = amax == 0.0f ? 127 : uint8_t(unbiased + 127);
  const float qscale = ldexpf(1.0f, 127 - int(e8));

  const long long output = (long long)block * (BLK / 2);
  #pragma unroll
  for (int i = 0; i < BLK / 2; i++)
    q[output + i] = encode_e2m1(vals[2*i] * qscale) | (encode_e2m1(vals[2*i+1] * qscale) << 4);
  e8_out[block] = e8;
}
