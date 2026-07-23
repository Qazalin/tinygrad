#include "kittens.cuh"

using namespace kittens;

#ifndef GEMM_M
#define GEMM_M 256
#endif
#ifndef GEMM_N
#define GEMM_N 256
#endif
#ifndef GEMM_K
#define GEMM_K 128
#endif

using intx8_t = int32_t __attribute__((ext_vector_type(8)));
using float4_t = float __attribute__((ext_vector_type(4)));

#ifdef MXFP4_FOUR_WAVE
constexpr int NUM_WARPS = 4;
#else
constexpr int NUM_WARPS = 8;
#endif
constexpr int BLOCK_M = 256;
constexpr int BLOCK_N = 256;
constexpr int BLOCK_K = 128;
constexpr int PACKED_K = BLOCK_K / 2;
constexpr int WARPS_M = 2;
constexpr int WARPS_N = NUM_WARPS / WARPS_M;
#ifdef MXFP4_DEEP_PIPELINE
constexpr int FP_STAGES = 4;
#else
constexpr int FP_STAGES = 2;
#endif

static_assert(GEMM_M % BLOCK_M == 0 && GEMM_N % BLOCK_N == 0 && GEMM_K % BLOCK_K == 0);

using G = kittens::group<NUM_WARPS>;
// Thunder does not yet expose a packed-FP4 shared tile. fp8e4m3 is used only
// as its one-byte storage type here; the bytes remain packed E2M1 and are
// consumed by the MFMA with cbsz/blgp=4.
using ST = st<fp8e4m3, 128, PACKED_K, st_16x64_s>;

#ifdef MXFP4_FOUR_WAVE
#define MXFP4_LAUNCH_BOUNDS __launch_bounds__(256, 1)
#elif defined(MXFP4_DEEP_PIPELINE)
#define MXFP4_LAUNCH_BOUNDS __launch_bounds__(512, 1)
#else
#define MXFP4_LAUNCH_BOUNDS __launch_bounds__(512, 2)
#endif
extern "C" __global__ MXFP4_LAUNCH_BOUNDS void
mxfp4_gemm(__hip_bfloat16 *__restrict__ C,
           const uint8_t *__restrict__ A,
           const uint8_t *__restrict__ B,
           const uint8_t *__restrict__ scale_a,
           const uint8_t *__restrict__ scale_b,
           const void *__restrict__ orig_a,
           const void *__restrict__ orig_b) {
  (void)orig_a;
  (void)orig_b;
  constexpr int M = GEMM_M, N = GEMM_N, K = GEMM_K;
  constexpr int TILES_M = M / BLOCK_M, TILES_N = N / BLOCK_N;
  constexpr int K_ITERS = K / BLOCK_K;

  // Keep neighboring workgroups on the same XCD, matching the scheduling used
  // by Thunder's high-throughput BF16/FP8 GEMMs.
  int wgid = chiplet_transform_chunked(blockIdx.x, gridDim.x, 8, 64);
  constexpr int WGM = 8;
  int group_width = WGM * TILES_N;
  int group_id = wgid / group_width;
  int first_m = group_id * WGM;
  int group_m = min(TILES_M - first_m, WGM);
  int block_m_tile = first_m + (wgid % group_width) % group_m;
  int block_n_tile = (wgid % group_width) / group_m;
  int block_m = block_m_tile * BLOCK_M;
  int block_n = block_n_tile * BLOCK_N;

  int tid = threadIdx.x;
  int warp = tid >> 6;
  int lane = tid & 63;
  int warp_m = warp / WARPS_N;
  int warp_n = warp % WARPS_N;
  int operand_row = lane & 15;
  int k_group = lane >> 4;

#ifdef MXFP4_FOUR_WAVE
  float4_t accum4[8][8] = {};
#else
  float4_t accum[2][2][4][2] = {};
#endif

  kittens::gl<fp8e4m3, 1, 1, M, K / 2> Ag{reinterpret_cast<fp8e4m3 *>(const_cast<uint8_t *>(A)), nullptr, nullptr, nullptr, nullptr};
  kittens::gl<fp8e4m3, 1, 1, N, K / 2> Bg{reinterpret_cast<fp8e4m3 *>(const_cast<uint8_t *>(B)), nullptr, nullptr, nullptr, nullptr};

  __shared__ ST As[FP_STAGES][2];
  __shared__ ST Bs[FP_STAGES][2];
#ifdef SCALES_PRESHUFFLED
  __shared__ uint32_t scale_As[2][BLOCK_M * 2];
  __shared__ uint32_t scale_Bs[2][BLOCK_N * 2];
#else
  __shared__ uint32_t scale_As[2][BLOCK_M];
  __shared__ uint32_t scale_Bs[2][BLOCK_N];
#endif

  constexpr int COPIES = ST::rows * ST::cols / (16 * NUM_WARPS * WARP_THREADS);
  static_assert(COPIES == 8 / NUM_WARPS);
  uint32_t sw_A[COPIES], sw_B[COPIES];
  G::prefill_swizzled_offsets(As[0][0], Ag, sw_A);
  G::prefill_swizzled_offsets(Bs[0][0], Bg, sw_B);
#ifdef B_PRESHUFFLED
  i32x4 b_srsrc = make_srsrc(B, N * (K / 2));
#endif

  auto load_stage = [&](int stage, int kk) {
    G::load(As[stage][0], Ag, {0, 0, block_m_tile * 2, kk}, sw_A);
    G::load(As[stage][1], Ag, {0, 0, block_m_tile * 2 + 1, kk}, sw_A);
#ifdef B_PRESHUFFLED
    #pragma unroll
    for (int copy = 0; copy < 16 / NUM_WARPS; copy++) {
      int nblock_local = warp + copy * NUM_WARPS;
      uint32_t physical = ((block_n / 16 + nblock_local) * (K / 64) + kk * 2) * 512 + lane * 16;
      uintptr_t lds_addr = reinterpret_cast<uintptr_t>(&Bs[stage][0].data[0]) + nblock_local * 1024;
      llvm_amdgcn_raw_buffer_load_lds(b_srsrc, reinterpret_cast<as3_uint32_ptr>(lds_addr), 16, physical, 0, 0,
                                     static_cast<int>(coherency::cache_all));
    }
#else
    G::load(Bs[stage][0], Bg, {0, 0, block_n_tile * 2, kk}, sw_B);
    G::load(Bs[stage][1], Bg, {0, 0, block_n_tile * 2 + 1, kk}, sw_B);
#endif
#ifdef SCALES_PRESHUFFLED
    if ((kk & 1) == 0) {
      int bs0_local = tid >> 6;
      int rem = tid & 63;
      int bs2 = rem >> 2;
      int bs5 = rem & 3;
      int pair_stage = (kk >> 1) & 1;
      long long a_offset = (long long)(block_m / 32 + bs0_local) * 32 * (K / 32) + (kk >> 1) * 256 + bs5 * 64 + bs2 * 4;
      long long b_offset = (long long)(block_n / 32 + bs0_local) * 32 * (K / 32) + (kk >> 1) * 256 + bs5 * 64 + bs2 * 4;
      scale_As[pair_stage][tid] = *reinterpret_cast<const uint32_t *>(scale_a + a_offset);
      scale_Bs[pair_stage][tid] = *reinterpret_cast<const uint32_t *>(scale_b + b_offset);
    }
#else
    if (tid < BLOCK_M) {
      scale_As[stage][tid] = *reinterpret_cast<const uint32_t *>(
          scale_a + (long long)(block_m + tid) * (K / 32) + kk * 4);
      scale_Bs[stage][tid] = *reinterpret_cast<const uint32_t *>(
          scale_b + (long long)(block_n + tid) * (K / 32) + kk * 4);
    }
#endif
  };

  load_stage(0, 0);
#ifdef MXFP4_DEEP_PIPELINE
  if (K_ITERS > 1) load_stage(1, 1);
#endif
  asm volatile("s_waitcnt vmcnt(0)");
  __syncthreads();

  #pragma unroll 1
  for (int kk = 0; kk < K_ITERS; kk++) {
    int stage = kk & (FP_STAGES - 1);
#ifdef MXFP4_DEEP_PIPELINE
    if (kk + 2 < K_ITERS) load_stage((stage + 2) & (FP_STAGES - 1), kk + 2);
#else
    if (kk + 1 < K_ITERS) load_stage(stage ^ 1, kk + 1);
#endif

#ifdef MXFP4_FOUR_WAVE
    #pragma unroll
    for (int am = 0; am < 8; am++) {
      int a_local_row = warp_m * 128 + am * 16 + operand_row;
      const uint4 av = *reinterpret_cast<const uint4 *>(
          &As[stage][a_local_row / 128].data[(a_local_row % 128) * PACKED_K + k_group * 16]);
      const intx8_t a_arg = {int(av.x), int(av.y), int(av.z), int(av.w), 0, 0, 0, 0};
#ifdef SCALES_PRESHUFFLED
      int sa_idx = ((a_local_row >> 5) * 64 + (a_local_row & 15) * 4 + k_group) * 4 + ((kk & 1) * 2 + ((a_local_row >> 4) & 1));
      int sa = reinterpret_cast<uint8_t *>(scale_As[(kk >> 1) & 1])[sa_idx];
#else
      int sa = reinterpret_cast<uint8_t *>(scale_As[stage])[a_local_row * 4 + k_group];
#endif
      #pragma unroll
      for (int bn = 0; bn < 8; bn++) {
        int b_local_row = warp_n * 128 + bn * 16 + operand_row;
#ifdef B_PRESHUFFLED
        int b_offset = ((((b_local_row >> 4) * 2 + (k_group >> 1)) * 2 + (k_group & 1)) * 16 + (b_local_row & 15)) * 16;
        const uint4 bv = *reinterpret_cast<const uint4 *>(reinterpret_cast<const uint8_t *>(&Bs[stage][0].data[0]) + b_offset);
#else
        const uint4 bv = *reinterpret_cast<const uint4 *>(
            &Bs[stage][b_local_row / 128].data[(b_local_row % 128) * PACKED_K + k_group * 16]);
#endif
        const intx8_t b_arg = {int(bv.x), int(bv.y), int(bv.z), int(bv.w), 0, 0, 0, 0};
#ifdef SCALES_PRESHUFFLED
        int sb_idx = ((b_local_row >> 5) * 64 + (b_local_row & 15) * 4 + k_group) * 4 + ((kk & 1) * 2 + ((b_local_row >> 4) & 1));
        int sb = reinterpret_cast<uint8_t *>(scale_Bs[(kk >> 1) & 1])[sb_idx];
#else
        int sb = reinterpret_cast<uint8_t *>(scale_Bs[stage])[b_local_row * 4 + k_group];
#endif
        accum4[am][bn] = __builtin_amdgcn_mfma_scale_f32_16x16x128_f8f6f4(
            a_arg, b_arg, accum4[am][bn], 4, 4, 0, sa, 0, sb);
      }
    }
#else
    #pragma unroll
    for (int ah = 0; ah < 2; ah++) {
      #pragma unroll
      for (int bh = 0; bh < 2; bh++) {
        #pragma unroll
        for (int am = 0; am < 4; am++) {
          int a_local_row = warp_m * 64 + am * 16 + operand_row;
          const uint4 av = *reinterpret_cast<const uint4 *>(
              &As[stage][ah].data[a_local_row * PACKED_K + k_group * 16]);
          const intx8_t a_arg = {int(av.x), int(av.y), int(av.z), int(av.w), 0, 0, 0, 0};
          int a_total_row = ah * 128 + a_local_row;
#ifdef SCALES_PRESHUFFLED
          int sa_idx = ((a_total_row >> 5) * 64 + (a_total_row & 15) * 4 + k_group) * 4 + ((kk & 1) * 2 + ((a_total_row >> 4) & 1));
          int sa = reinterpret_cast<uint8_t *>(scale_As[(kk >> 1) & 1])[sa_idx];
#else
          int sa = reinterpret_cast<uint8_t *>(scale_As[stage])[a_total_row * 4 + k_group];
#endif
          #pragma unroll
          for (int bn = 0; bn < 2; bn++) {
            int b_local_row = warp_n * 32 + bn * 16 + operand_row;
            int b_total_row = bh * 128 + b_local_row;
#ifdef B_PRESHUFFLED
            int b_offset = ((((b_total_row >> 4) * 2 + (k_group >> 1)) * 2 + (k_group & 1)) * 16 + (b_total_row & 15)) * 16;
            const uint4 bv = *reinterpret_cast<const uint4 *>(reinterpret_cast<const uint8_t *>(&Bs[stage][0].data[0]) + b_offset);
#else
            const uint4 bv = *reinterpret_cast<const uint4 *>(
                &Bs[stage][bh].data[b_local_row * PACKED_K + k_group * 16]);
#endif
            const intx8_t b_arg = {int(bv.x), int(bv.y), int(bv.z), int(bv.w), 0, 0, 0, 0};
#ifdef SCALES_PRESHUFFLED
            int sb_idx = ((b_total_row >> 5) * 64 + (b_total_row & 15) * 4 + k_group) * 4 + ((kk & 1) * 2 + ((b_total_row >> 4) & 1));
            int sb = reinterpret_cast<uint8_t *>(scale_Bs[(kk >> 1) & 1])[sb_idx];
#else
            int sb = reinterpret_cast<uint8_t *>(scale_Bs[stage])[b_total_row * 4 + k_group];
#endif
            accum[ah][bh][am][bn] = __builtin_amdgcn_mfma_scale_f32_16x16x128_f8f6f4(
                a_arg, b_arg, accum[ah][bh][am][bn], 4, 4, 0, sa, 0, sb);
          }
        }
      }
    }
#endif
#ifdef MXFP4_DEEP_PIPELINE
    if ((kk & 1) && kk + 1 < K_ITERS) {
#else
    if (kk + 1 < K_ITERS) {
#endif
      asm volatile("s_waitcnt vmcnt(0)");
      __syncthreads();
    }
  }

#ifdef MXFP4_FOUR_WAVE
  #pragma unroll
  for (int am = 0; am < 8; am++) {
    #pragma unroll
    for (int bn = 0; bn < 8; bn++) {
      int col = block_n + warp_n * 128 + bn * 16 + (lane & 15);
      int row_base = block_m + warp_m * 128 + am * 16 + (lane >> 4) * 4;
      #pragma unroll
      for (int i = 0; i < 4; i++)
        C[(long long)(row_base + i) * N + col] = __hip_bfloat16(accum4[am][bn][i]);
    }
  }
#else
  #pragma unroll
  for (int ah = 0; ah < 2; ah++) {
    #pragma unroll
    for (int bh = 0; bh < 2; bh++) {
      #pragma unroll
      for (int am = 0; am < 4; am++) {
        #pragma unroll
        for (int bn = 0; bn < 2; bn++) {
          int col = block_n + bh * 128 + warp_n * 32 + bn * 16 + (lane & 15);
          int row_base = block_m + ah * 128 + warp_m * 64 + am * 16 + (lane >> 4) * 4;
          #pragma unroll
          for (int i = 0; i < 4; i++)
            C[(long long)(row_base + i) * N + col] = __hip_bfloat16(accum[ah][bh][am][bn][i]);
        }
      }
    }
  }
#endif
}
