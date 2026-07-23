#include <hip/hip_bf16.h>
#include <hip/hip_runtime.h>
#include <stdint.h>

#ifndef GEMM_M
#define GEMM_M 16
#endif
#ifndef GEMM_N
#define GEMM_N 16
#endif
#ifndef GEMM_K
#define GEMM_K 128
#endif

using intx8_t = int32_t __attribute__((ext_vector_type(8)));
using float4_t = float __attribute__((ext_vector_type(4)));

static_assert(GEMM_M % 16 == 0 && GEMM_N % 16 == 0 && GEMM_K % 128 == 0);

#if GEMM_M % 128 == 0 && GEMM_N % 128 == 0

constexpr int BLOCK_M = 128;
constexpr int BLOCK_N = 128;
constexpr int BLOCK_K = 128;
constexpr int PACKED_K = BLOCK_K / 2;
constexpr int WARPS_M = 2;
constexpr int WARPS_N = 4;

extern "C" __global__ __launch_bounds__(512, 2) void
mxfp4_gemm(__hip_bfloat16 *__restrict__ C,
            const uint8_t *__restrict__ A,
            const uint8_t *__restrict__ B,
            const uint8_t *__restrict__ scale_a,
            const uint8_t *__restrict__ scale_b,
            const void *__restrict__ orig_a,
            const void *__restrict__ orig_b) {
  (void)orig_a;
  (void)orig_b;
  const int tile = blockIdx.x;
  if (tile >= (GEMM_M / BLOCK_M) * (GEMM_N / BLOCK_N)) return;
  const int block_m = (tile / (GEMM_N / BLOCK_N)) * BLOCK_M;
  const int block_n = (tile % (GEMM_N / BLOCK_N)) * BLOCK_N;
  const int tid = threadIdx.x;
  const int warp = tid >> 6;
  const int lane = tid & 63;
  const int warp_m = warp / WARPS_N;
  const int warp_n = warp % WARPS_N;
  const int operand_row = lane & 15;
  const int k_group = lane >> 4;
  float4_t accum[4][2] = {};

  __shared__ __align__(16) uint8_t As[BLOCK_M * PACKED_K];
  __shared__ __align__(16) uint8_t Bs[BLOCK_N * PACKED_K];

  for (int k = 0; k < GEMM_K; k += 128) {
    const int copy_row = tid >> 2;
    const int copy_col = (tid & 3) * 16;
    *reinterpret_cast<uint4*>(&As[copy_row * PACKED_K + copy_col]) =
        *reinterpret_cast<const uint4*>(A + (long long)(block_m + copy_row) * (GEMM_K / 2) + k / 2 + copy_col);
    *reinterpret_cast<uint4*>(&Bs[copy_row * PACKED_K + copy_col]) =
        *reinterpret_cast<const uint4*>(B + (long long)(block_n + copy_row) * (GEMM_K / 2) + k / 2 + copy_col);
    __syncthreads();

    #pragma unroll
    for (int am = 0; am < 4; am++) {
      const int a_local_row = warp_m * 64 + am * 16 + operand_row;
      const uint4 av = *reinterpret_cast<const uint4*>(&As[a_local_row * PACKED_K + k_group * 16]);
      const intx8_t a_arg = {int(av.x), int(av.y), int(av.z), int(av.w), 0, 0, 0, 0};
      const int sa = scale_a[(long long)(block_m + a_local_row) * (GEMM_K / 32) + k / 32 + k_group];
      #pragma unroll
      for (int bn = 0; bn < 2; bn++) {
        const int b_local_row = warp_n * 32 + bn * 16 + operand_row;
        const uint4 bv = *reinterpret_cast<const uint4*>(&Bs[b_local_row * PACKED_K + k_group * 16]);
        const intx8_t b_arg = {int(bv.x), int(bv.y), int(bv.z), int(bv.w), 0, 0, 0, 0};
        const int sb = scale_b[(long long)(block_n + b_local_row) * (GEMM_K / 32) + k / 32 + k_group];
        accum[am][bn] = __builtin_amdgcn_mfma_scale_f32_16x16x128_f8f6f4(
            a_arg, b_arg, accum[am][bn], 4, 4, 0, sa, 0, sb);
      }
    }
    __syncthreads();
  }

  #pragma unroll
  for (int am = 0; am < 4; am++) {
    #pragma unroll
    for (int bn = 0; bn < 2; bn++) {
      const int col = block_n + warp_n * 32 + bn * 16 + (lane & 15);
      const int row_base = block_m + warp_m * 64 + am * 16 + (lane >> 4) * 4;
      #pragma unroll
      for (int i = 0; i < 4; i++) C[(long long)(row_base + i) * GEMM_N + col] = __hip_bfloat16(accum[am][bn][i]);
    }
  }
}

#else

extern "C" __global__ __launch_bounds__(64) void
mxfp4_gemm(__hip_bfloat16 *__restrict__ C,
            const uint8_t *__restrict__ A,
            const uint8_t *__restrict__ B,
            const uint8_t *__restrict__ scale_a,
            const uint8_t *__restrict__ scale_b,
            const void *__restrict__ orig_a,
            const void *__restrict__ orig_b) {
  (void)orig_a;
  (void)orig_b;
  const int tile = blockIdx.x;
  if (tile >= (GEMM_M / 16) * (GEMM_N / 16)) return;
  const int tile_m = tile / (GEMM_N / 16);
  const int tile_n = tile % (GEMM_N / 16);
  const int lane = threadIdx.x;
  const int operand_row = lane & 15;
  const int k_group = lane >> 4;
  float4_t accum = {0.0f, 0.0f, 0.0f, 0.0f};

  #pragma unroll
  for (int k = 0; k < GEMM_K; k += 128) {
    const int a_row = tile_m * 16 + operand_row;
    const int b_row = tile_n * 16 + operand_row;
    const uint4 av = *reinterpret_cast<const uint4*>(
        A + (long long)a_row * (GEMM_K / 2) + (k + k_group * 32) / 2);
    const uint4 bv = *reinterpret_cast<const uint4*>(
        B + (long long)b_row * (GEMM_K / 2) + (k + k_group * 32) / 2);
    const intx8_t a_arg = {int(av.x), int(av.y), int(av.z), int(av.w), 0, 0, 0, 0};
    const intx8_t b_arg = {int(bv.x), int(bv.y), int(bv.z), int(bv.w), 0, 0, 0, 0};
    const int sa = scale_a[(long long)a_row * (GEMM_K / 32) + k / 32 + k_group];
    const int sb = scale_b[(long long)b_row * (GEMM_K / 32) + k / 32 + k_group];
    accum = __builtin_amdgcn_mfma_scale_f32_16x16x128_f8f6f4(
        a_arg, b_arg, accum, 4, 4, 0, sa, 0, sb);
  }

  const int col = tile_n * 16 + (lane & 15);
  const int row_base = tile_m * 16 + (lane >> 4) * 4;
  #pragma unroll
  for (int i = 0; i < 4; i++) C[(long long)(row_base + i) * GEMM_N + col] = __hip_bfloat16(accum[i]);
}

#endif
