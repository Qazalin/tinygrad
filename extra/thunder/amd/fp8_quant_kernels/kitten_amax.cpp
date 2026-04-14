// reduce max(abs(x)) over bf16 tensor into a float32 scalar
#include <hip/hip_runtime.h>
#include "kittens.cuh"
using namespace kittens;

constexpr unsigned int TILE_R = 16, TILE_C = 32;

using ST = st_bf<TILE_R, TILE_C, st_16x32_s>;
using RT = rt_bf<TILE_R, TILE_C, row_l, rt_16x32_s>;
using G = group<1>;

__device__ __forceinline__ void atomicMaxFloatNonNeg(float *addr, float value) {
  atomicMax(reinterpret_cast<int*>(addr), __float_as_int(value));
}

extern "C" __global__ void kitten_amax(float *amax_out, const bf16 *x) {
  constexpr unsigned int N = PARAM_N;
  gl<bf16, 1, 1, -1, -1> X{const_cast<bf16*>(x), nullptr, nullptr, (size_t)(N / TILE_C), (size_t)TILE_C};

  int tile_idx = blockIdx.x;
  __shared__ ST smem;
  RT reg;
  typename RT::col_vec row_max_vec;

  G::load(smem, X, {0, 0, tile_idx, 0});
  __builtin_amdgcn_s_waitcnt(0);
  __syncthreads();

  load(reg, smem);
  abs(reg, reg);
  row_max(row_max_vec, reg);

  bf16 tile_max_bf = bf16(0.0f);
  max(tile_max_bf, row_max_vec);
  if (laneid() == 0) atomicMaxFloatNonNeg(amax_out, (float)tile_max_bf);
}
