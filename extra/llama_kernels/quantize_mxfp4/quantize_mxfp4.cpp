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
#ifndef SHUFFLE_DATA
#define SHUFFLE_DATA 0
#endif
#ifndef SHUFFLE_SCALES
#define SHUFFLE_SCALES 0
#endif
#ifndef TRANSPOSE_INPUT
#define TRANSPOSE_INPUT 0
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
  const int row = block / (K_DIM / BLK);
  const int kblock = block % (K_DIM / BLK);
  #pragma unroll
  for (int i = 0; i < BLK; i++) {
    const long long input = TRANSPOSE_INPUT ? ((long long)(kblock * BLK + i) * ROWS + row) :
                                              ((long long)block * BLK + i);
    vals[i] = float(x[input]);
  }
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

  const long long output = SHUFFLE_DATA ?
      ((((long long)(row / 16) * (K_DIM / 64) + kblock / 2) * 2 + kblock % 2) * 16 + row % 16) * 16 :
      (long long)block * (BLK / 2);
  #pragma unroll
  for (int i = 0; i < BLK / 2; i++)
    q[output + i] = encode_e2m1(vals[2*i] * qscale) | (encode_e2m1(vals[2*i+1] * qscale) << 4);
  if constexpr (SHUFFLE_SCALES) {
    const int bs0 = row / 32, bs1 = (row % 32) / 16, bs2 = row % 16;
    const int bs3 = kblock / 8, bs4 = (kblock % 8) / 4, bs5 = kblock % 4;
    e8_out[(long long)bs0 * 32 * (K_DIM / 32) + bs3 * 256 + bs5 * 64 + bs2 * 4 + bs4 * 2 + bs1] = e8;
  } else {
    e8_out[block] = e8;
  }
}
