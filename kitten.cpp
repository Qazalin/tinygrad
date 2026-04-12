#include "kittens.cuh"

using namespace kittens;

// === Pure data movement kernel: no compute, just tiling ===
//
// Goal: copy A -> C through the HK tile hierarchy to verify
// we understand how tiling, coordinates, and data movement work.
//
// Path: global memory -> shared memory (LDS) -> registers -> global memory
//
// Layout:
//   - 4 warps per workgroup = 256 threads
//   - each workgroup handles one 64x64 output tile
//   - workgroups tile over the full NxN matrix
//
// Tile sizes:
//   - shared tile: st_bf<64, 64, st_16x32_s>  (64 rows x 64 cols, bf16, 16x32 subtile shape)
//   - register tile: rt_bf<16, 64, row_l, rt_16x32_s>  (each warp owns 16 rows x 64 cols)
//   - global layout: gl<bf16, 1, 1, N, N>
//
// Coordinate system:
//   gl is addressed as {batch, depth, row, col} in units of tile dimensions.
//   For a 64x64 shared tile, coord {0, 0, r, c} means:
//     row_start = r * 64,  col_start = c * 64
//
// The 4 warps split the 64 rows: warp0 gets rows [0,16), warp1 gets [16,32), etc.
// Each warp loads its 16x64 slice from shared into registers, then stores back to global.

constexpr int TILE = 64;          // tile height and width
constexpr int NUM_WARPS = 4;
constexpr int NUM_THREADS = NUM_WARPS * WARP_THREADS;  // 4 * 64 = 256
constexpr int WARP_ROWS = TILE / NUM_WARPS;            // 16 rows per warp

// shared tile: 64x64 bf16 with 16x32 subtile layout (good for bf16 bank-conflict-free access)
using ST = st_bf<TILE, TILE, st_16x32_s>;

// register tile: 16x64 bf16, row-major, 16x32 base shape
// each warp owns one of these (16 rows of the 64-row shared tile)
using RT = rt_bf<WARP_ROWS, TILE, row_l, rt_16x32_s>;

// group: all 4 warps cooperate on global<->shared loads
using G = group<NUM_WARPS>;

__global__ __launch_bounds__(NUM_THREADS, 1)
void kitten_gemm(bf16 *C_ptr, const bf16 *A_ptr, const bf16 *B_ptr) {
    constexpr int N = GEMM_N;

    // wrap raw pointers in global tile descriptors
    // gl<type, batch, depth, rows, cols>
    // positive template args = compile-time dimensions, pass nullptr for those in constructor
    gl<bf16, 1, 1, -1, -1> A{const_cast<bf16*>(A_ptr), nullptr, nullptr, (size_t)N, (size_t)N};
    gl<bf16, 1, 1, -1, -1> C{C_ptr, nullptr, nullptr, (size_t)N, (size_t)N};

    // each workgroup handles one TILE x TILE block
    // gidx0 is a linear block index; convert to 2D tile coordinates
    constexpr int tiles_per_row = N / TILE;
    int tile_r = blockIdx.x / tiles_per_row;
    int tile_c = blockIdx.x % tiles_per_row;

    // === Step 1: allocate shared memory tile ===
    __shared__ ST smem;

    // === Step 2: global -> shared (all 4 warps cooperate) ===
    // coord {batch=0, depth=0, row=tile_r, col=tile_c} in tile units
    // the gl indexing multiplies by ST::rows and ST::cols internally
    G::load(smem, A, {0, 0, tile_r, tile_c});
    // G::load uses llvm_amdgcn_raw_buffer_load_lds (async DMA: global -> LDS).
    // the data is NOT in LDS yet until we drain the vector memory counter.
    // s_waitcnt vmcnt(0) waits for all pending buffer loads to complete.
    // __builtin_amdgcn_s_waitcnt(0) waits for BOTH vmcnt and lgkmcnt.
    __builtin_amdgcn_s_waitcnt(0);
    __syncthreads();

    // === Step 3: shared -> register (each warp loads its 16-row slice) ===
    RT reg;
    int wid = warpid();
    // subtile_inplace: carve out a WARP_ROWS x TILE sub-region of the 64x64 shared tile
    // {wid, 0} means: row-block = wid (in units of WARP_ROWS), col-block = 0
    auto my_slice = subtile_inplace<WARP_ROWS, TILE>(smem, {wid, 0});
    load(reg, my_slice);

    __syncthreads();

    // === Step 4: register -> global ===
    // store each warp's 16x64 register tile to the correct location in C
    // the coord is in units of RT dimensions (16 rows x 64 cols)
    // so row index = tile_r * (TILE/WARP_ROWS) + wid, col index = tile_c * 1
    store(C, reg, {0, 0, tile_r * NUM_WARPS + wid, tile_c});
}
