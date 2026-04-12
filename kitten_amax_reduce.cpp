// kitten_amax_reduce: two-pass amax stage 2 using HipKittens tiled load
// reduce float partial maxima to one scalar max (single block)
#include <hip/hip_runtime.h>
#include "kittens.cuh"
using namespace kittens;

constexpr unsigned int TILE_R = 16, TILE_C = 16;
constexpr unsigned int ELEMS_PER_TILE = TILE_R * TILE_C; // 256

using ST = st_fl<TILE_R, TILE_C, st_16x16_s>;
using G  = group<1>;

extern "C" __global__ void kitten_amax_reduce(float *amax_out, const float *partials_in) {
  constexpr unsigned int N = PARAM_N;       // padded to TILE multiple
  constexpr unsigned int VALID = PARAM_VALID; // true number of partials
  constexpr unsigned int NUM_TILES = N / ELEMS_PER_TILE;

  gl<float, 1, 1, -1, -1> P{const_cast<float*>(partials_in), nullptr, nullptr, (size_t)(N / TILE_C), (size_t)TILE_C};
  __shared__ ST smem;
  float block_max = 0.0f;

  for (unsigned int tile_idx = 0; tile_idx < NUM_TILES; tile_idx++) {
    G::load(smem, P, {0, 0, (int)tile_idx, 0});
    __builtin_amdgcn_s_waitcnt(0);
    __syncthreads();

    if (laneid() == 0) {
      float tile_max = 0.0f;
      const unsigned int base = tile_idx * ELEMS_PER_TILE;
      #pragma unroll
      for (int i = 0; i < ELEMS_PER_TILE; i++) {
        const unsigned int idx = base + (unsigned int)i;
        if (idx < VALID) tile_max = fmaxf(tile_max, smem.data[i]);
      }
      block_max = fmaxf(block_max, tile_max);
    }
    __syncthreads();
  }

  if (laneid() == 0) amax_out[0] = block_max;
}
