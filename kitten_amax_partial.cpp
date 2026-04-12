// kitten_amax_partial: two-pass amax stage 1
// each workgroup scans multiple 16x32 tiles and writes one float partial max
#include <hip/hip_runtime.h>
#include "kittens.cuh"
using namespace kittens;

constexpr unsigned int TILE_R = 16, TILE_C = 32;
constexpr unsigned int ELEMS_PER_TILE = TILE_R * TILE_C; // 512
constexpr unsigned int GRID = PARAM_GRID;

using ST = st_bf<TILE_R, TILE_C, st_16x32_s>;
using G  = group<1>;

extern "C" __global__ void kitten_amax_partial(float *partials_out, const bf16 *x) {
  constexpr unsigned int N = PARAM_N;
  constexpr unsigned int NUM_TILES = N / ELEMS_PER_TILE;
  gl<bf16, 1, 1, -1, -1> X{const_cast<bf16*>(x), nullptr, nullptr, (size_t)(N / TILE_C), (size_t)TILE_C};

  __shared__ ST smem;
  float block_max = 0.0f;

  for (unsigned int tile_idx = blockIdx.x; tile_idx < NUM_TILES; tile_idx += GRID) {
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

  if (laneid() == 0) partials_out[blockIdx.x] = block_max;
}
