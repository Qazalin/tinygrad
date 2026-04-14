// kitten_amax_reduce: two-pass amax stage 2
// multi-wave reduction of partial maxima using kittens warp primitives
#include "kittens.cuh"
using namespace kittens;

extern "C" __global__ void custom_quantize_fp8_amax_reduce(float *amax_out, const float *partials_in) {
  constexpr unsigned int VALID = PARAM_VALID;
  constexpr unsigned int BLOCK = PARAM_BLOCK;
  static_assert(BLOCK % WARP_THREADS == 0, "BLOCK must be a multiple of wave size");
  static_assert(BLOCK <= 1024, "BLOCK must be <= 1024");

  const unsigned int wid = warpid();
  const unsigned int lid = laneid();
  const unsigned int tid = wid * WARP_THREADS + lid;
  const unsigned int n_waves = BLOCK / WARP_THREADS;

  __shared__ float wave_max[BLOCK / WARP_THREADS];

  float v = 0.0f;
  #pragma unroll 4
  for (unsigned int i = tid; i < VALID; i += BLOCK) v = fmaxf(v, partials_in[i]);

  for (int ofs = WARP_THREADS >> 1; ofs > 0; ofs >>= 1) v = fmaxf(v, __shfl_xor(v, ofs, WARP_THREADS));

  if (lid == 0) wave_max[wid] = v;
  __syncthreads();

  if (wid == 0) {
    float w = (lid < n_waves) ? wave_max[lid] : 0.0f;
    for (int ofs = WARP_THREADS >> 1; ofs > 0; ofs >>= 1) w = fmaxf(w, __shfl_xor(w, ofs, WARP_THREADS));
    if (lid == 0) amax_out[0] = w;
  }
}
