// copy A -> C through: global -> shared (LDS) -> registers -> global
#include "kittens.cuh"
using namespace kittens;

constexpr int TILE = 64, NUM_WARPS = 4, WARP_ROWS = TILE / NUM_WARPS; // 16

using ST = st_bf<TILE, TILE, st_16x32_s>;           // 64x64 shared tile
using RT = rt_bf<WARP_ROWS, TILE, row_l, rt_16x32_s>; // 16x64 register tile per warp
using G  = group<NUM_WARPS>;                          // 4 warps cooperate on global<->shared

__global__ __launch_bounds__(NUM_WARPS * WARP_THREADS, 1)
void kitten(bf16 *C_ptr, const bf16 *A_ptr, const bf16 *B_ptr) {
    constexpr int N = GEMM_N;
    gl<bf16, 1, 1, -1, -1> A{const_cast<bf16*>(A_ptr), nullptr, nullptr, (size_t)N, (size_t)N};
    gl<bf16, 1, 1, -1, -1> C{C_ptr, nullptr, nullptr, (size_t)N, (size_t)N};

    int tile_r = blockIdx.x / (N / TILE);
    int tile_c = blockIdx.x % (N / TILE);
    int wid = warpid();

    // global -> shared (async DMA, all warps cooperate)
    __shared__ ST smem;
    G::load(smem, A, {0, 0, tile_r, tile_c});
    __builtin_amdgcn_s_waitcnt(0); // wait for buffer loads to land in LDS
    __syncthreads();

    // shared -> registers (each warp loads its 16-row slice)
    RT reg;
    load(reg, subtile_inplace<WARP_ROWS, TILE>(smem, {wid, 0}));

    // registers -> global
    store(C, reg, {0, 0, tile_r * NUM_WARPS + wid, tile_c});
}
