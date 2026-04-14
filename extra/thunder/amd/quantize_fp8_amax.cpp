#include "kittens.cuh"
using namespace kittens;

#ifndef QFP8_N
constexpr unsigned int QFP8_N = 512;
#endif
#ifndef QFP8_GRID
constexpr unsigned int QFP8_GRID = 1;
#endif

constexpr unsigned int TILE_R = 16;
constexpr unsigned int TILE_C = 32;
constexpr unsigned int ELEMS_PER_TILE = TILE_R * TILE_C;
constexpr unsigned int NUM_TILES = QFP8_N / ELEMS_PER_TILE;

using ST = st_bf<TILE_R, TILE_C, st_16x32_s>;
using G = group<1>;

__global__ void custom_quantize_fp8_amax_partials(float *partials_ptr, const bf16 *x_ptr) {
  gl<bf16, 1, 1, -1, -1> X{const_cast<bf16*>(x_ptr), nullptr, nullptr, (size_t)(QFP8_N / TILE_C), (size_t)TILE_C};

  __shared__ ST smem;
  float block_max = 0.0f;

  for (unsigned int tile_idx = blockIdx.x; tile_idx < NUM_TILES; tile_idx += QFP8_GRID) {
    G::load(smem, X, {0, 0, (int)tile_idx, 0});
    __builtin_amdgcn_s_waitcnt(0);
    __syncthreads();

    if (laneid() == 0) {
      float tile_max = 0.0f;
      #pragma unroll
      for (int i = 0; i < ELEMS_PER_TILE; i++) tile_max = fmaxf(tile_max, fabsf((float)smem.data[i]));
      block_max = fmaxf(block_max, tile_max);
    }
    __syncthreads();
  }

  if (laneid() == 0) partials_ptr[blockIdx.x] = block_max;
}
