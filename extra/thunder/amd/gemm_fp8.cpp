#include "kittens.cuh"

using namespace kittens;

#ifndef GEMM_M
constexpr int GEMM_M = 8192;
#endif
#ifndef GEMM_N
constexpr int GEMM_N = 8192;
#endif
#ifndef GEMM_K
constexpr int GEMM_K = 8192;
#endif

#ifndef SCALE_MODE
#define SCALE_MODE 3
#endif

constexpr int NUM_WARPS = 4;
using G = kittens::group<NUM_WARPS>;

template<typename T, int ROWS, int COLS>
struct simple_gl {
    using identifier = ducks::gl::identifier;
    using dtype = T;
    T *raw_ptr;

    __device__ inline T& operator[](const coord<ducks::default_type> &idx) const {
        return raw_ptr[idx.r * COLS + idx.c];
    }
    template<int axis> __device__ inline size_t stride() const {
        if constexpr (axis == 0) return ROWS * COLS;
        if constexpr (axis == 1) return ROWS * COLS;
        if constexpr (axis == 2) return COLS;
        return 1;
    }
};

struct precomputed_addresses {
    i32x4 srsrc;
    uintptr_t lds_base;
};

template<typename ST, typename GL>
__device__ __forceinline__ static precomputed_addresses precompute_addresses(ST &dst, const GL &src, const coord<ST> &idx) {
    constexpr int axis = 2;
    using T = typename ST::dtype;
    const int row_stride = src.template stride<axis>();
    coord<> unit_coord = idx.template unit_coord<axis, 3>();
    T *global_ptr = (T*)&src[unit_coord];
    i32x4 srsrc = make_srsrc(global_ptr, row_stride * ST::rows * sizeof(T));
    constexpr int bytes_per_thread = ST::underlying_subtile_bytes_per_thread;
    constexpr int bytes_per_warp = bytes_per_thread * kittens::WARP_THREADS;
    uintptr_t lds_base = reinterpret_cast<uintptr_t>(&dst.data[0]) + (warpid() * bytes_per_warp);
    return {srsrc, lds_base};
}

template<int i, typename ST, typename GL>
__device__ inline static void load_one(ST &dst, const GL &src, precomputed_addresses addresses) {
    constexpr int axis = 2;
    using T = typename ST::dtype;
    constexpr int bytes_per_thread = ST::underlying_subtile_bytes_per_thread;
    constexpr int bytes_per_warp = bytes_per_thread * kittens::WARP_THREADS;
    constexpr int num_warps = NUM_WARPS;
    const int laneid = kittens::laneid();
    const int warp_id = kittens::warpid() % num_warps;
    const int row_stride = src.template stride<axis>();
    const int lane_byte_offset = (laneid * bytes_per_thread) + (warp_id * bytes_per_warp) + (i * num_warps * bytes_per_warp);
    const int subtile_id = lane_byte_offset / ST::underlying_subtile_bytes;
    const int subtile_row = subtile_id / ST::underlying_subtiles_per_row;
    const int subtile_col = subtile_id % ST::underlying_subtiles_per_row;
    const int subtile_lane_byte_offset = lane_byte_offset % ST::underlying_subtile_bytes;
    const int row = subtile_lane_byte_offset / ST::underlying_subtile_row_bytes;
    const int col = (subtile_lane_byte_offset % ST::underlying_subtile_row_bytes) / sizeof(T);
    const uint32_t swizzled_shared_byte_offset = dst.swizzle({row, col});
    const int swizzled_global_row = (swizzled_shared_byte_offset / ST::underlying_subtile_row_bytes) + subtile_row * ST::underlying_subtile_rows;
    const int swizzled_global_col = (swizzled_shared_byte_offset % ST::underlying_subtile_row_bytes) / sizeof(T) + subtile_col * ST::underlying_subtile_cols;
    const uint32_t swizzled_global_byte_offset = (swizzled_global_row * row_stride + swizzled_global_col) * sizeof(T);
    uintptr_t lds_addr = addresses.lds_base + (i * num_warps * bytes_per_warp);
    as3_uint32_ptr lds_ptr = (as3_uint32_ptr)(lds_addr);
    llvm_amdgcn_raw_buffer_load_lds(addresses.srsrc, lds_ptr, bytes_per_thread, swizzled_global_byte_offset, 0, 0, static_cast<int>(coherency::cache_all));
}

template<int num_offsets, typename RT, typename ST>
__device__ inline static void prefill_swizzled_offsets(RT &dst, ST &src, uint32_t *swizzled_offsets) {
    using U = ST::dtype;
    constexpr int subtile_stride = RT::base_tile_cols * sizeof(U) / 2;
    const uint32_t st_offset = (kittens::laneid() % RT::base_tile_rows) * ST::underlying_cols + (kittens::laneid() / RT::base_tile_rows * 16 / sizeof(U));
    uint32_t base_addr = reinterpret_cast<uintptr_t>(&src.data[st_offset]);
    swizzled_offsets[0] = base_addr;
    swizzled_offsets[0] ^= (((swizzled_offsets[0] % (256 * 8)) >> 8) << 4);
    swizzled_offsets[1] = base_addr + subtile_stride;
    swizzled_offsets[1] ^= (((swizzled_offsets[1] % (256 * 8)) >> 8) << 4);
}

template<int register_row, int register_col, int k, typename RT, typename ST>
__device__ inline static void load_one(RT &dst, ST &src, uint32_t *swizzled_offsets) {
    using U = ST::dtype;
    constexpr int packing = base_types::packing<typename RT::dtype>::num();
    const int idx = k * RT::base_tile_stride / packing;
    constexpr int row_stride = RT::base_tile_rows * ST::underlying_cols * sizeof(U);
    asm volatile(
        "ds_read_b128 %0, %1 offset:%2\n"
        : "=v"(*reinterpret_cast<float4*>(&dst.tiles[register_row][register_col].data[idx]))
        : "v"(swizzled_offsets[k]), "i"(register_row * row_stride)
        : "memory"
    );
}

template<typename D, typename A, typename B, typename C>
__device__ inline static void mma_one(D &d, const A &a, const B &b, const C &c, int n, int m) {
    mma_ABt_base(d.tiles[n][m], a.tiles[n][0], b.tiles[m][0], c.tiles[n][m]);
}

template<typename D, typename A, typename B>
__device__ inline static void mma_64x64(D &d, const A &a, const B &b) {
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 0, 0);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 0, 1);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 0, 2);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 0, 3);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 1, 0);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 1, 1);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 1, 2);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 1, 3);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 2, 0);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 2, 1);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 2, 2);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 2, 3);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 3, 0);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 3, 1);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 3, 2);
    __builtin_amdgcn_sched_barrier(0); mma_one(d, a, b, d, 3, 3);
    __builtin_amdgcn_sched_barrier(0);
}

template<typename ST_GL, typename GL_GL, typename ST, typename RT, typename RT_A, typename RT_B, typename RT_C, ducks::coord::tile COORD=coord<ST_GL>>
__device__ inline static void do_interleaved_cluster(ST_GL &dst_gl, const GL_GL &src_gl, COORD idx, RT &dst, ST &src, RT_A &a, RT_B &b, RT_C &c) {
    __builtin_amdgcn_sched_barrier(0); mma_one(c, a, b, c, 0, 0);
    __builtin_amdgcn_sched_barrier(0);
    precomputed_addresses addresses = precompute_addresses(dst_gl, src_gl, idx);
    __builtin_amdgcn_sched_barrier(0); mma_one(c, a, b, c, 0, 1);
    __builtin_amdgcn_sched_barrier(0);
    uint32_t swizzled_offsets[2];
    prefill_swizzled_offsets<2>(dst, src, swizzled_offsets);
    load_one<0>(dst_gl, src_gl, addresses);
    load_one<0, 0, 0>(dst, src, swizzled_offsets);
    __builtin_amdgcn_sched_barrier(0); mma_one(c, a, b, c, 0, 2);
    __builtin_amdgcn_sched_barrier(0);
    load_one<0, 0, 1>(dst, src, swizzled_offsets);
    __builtin_amdgcn_sched_barrier(0); mma_one(c, a, b, c, 0, 3);
    __builtin_amdgcn_sched_barrier(0);
    load_one<1>(dst_gl, src_gl, addresses);
    load_one<1, 0, 0>(dst, src, swizzled_offsets);
    __builtin_amdgcn_sched_barrier(0); mma_one(c, a, b, c, 1, 0);
    mma_one(c, a, b, c, 1, 1);
    __builtin_amdgcn_sched_barrier(0);
    load_one<1, 0, 1>(dst, src, swizzled_offsets);
    __builtin_amdgcn_sched_barrier(0); mma_one(c, a, b, c, 1, 2);
    mma_one(c, a, b, c, 1, 3);
    __builtin_amdgcn_sched_barrier(0);
    load_one<2>(dst_gl, src_gl, addresses);
    load_one<2, 0, 0>(dst, src, swizzled_offsets);
    __builtin_amdgcn_sched_barrier(0); mma_one(c, a, b, c, 2, 0);
    mma_one(c, a, b, c, 2, 1);
    __builtin_amdgcn_sched_barrier(0);
    load_one<2, 0, 1>(dst, src, swizzled_offsets);
    __builtin_amdgcn_sched_barrier(0); mma_one(c, a, b, c, 2, 2);
    mma_one(c, a, b, c, 2, 3);
    __builtin_amdgcn_sched_barrier(0);
    load_one<3>(dst_gl, src_gl, addresses);
    load_one<3, 0, 0>(dst, src, swizzled_offsets);
    __builtin_amdgcn_sched_barrier(0); mma_one(c, a, b, c, 3, 0);
    mma_one(c, a, b, c, 3, 1);
    __builtin_amdgcn_sched_barrier(0);
    load_one<3, 0, 1>(dst, src, swizzled_offsets);
    __builtin_amdgcn_sched_barrier(0); mma_one(c, a, b, c, 3, 2);
    mma_one(c, a, b, c, 3, 3);
    __builtin_amdgcn_sched_barrier(0);
}

__global__ __launch_bounds__(256, 1) void hk_fp8_gemm(bf16 *C_ptr, fp8e4m3 *A_ptr, fp8e4m3 *B_ptr
#if SCALE_MODE == 1
    , float *x_scale_ptr
#elif SCALE_MODE == 2
    , float *w_scale_ptr
#elif SCALE_MODE == 3
    , float *x_scale_ptr, float *w_scale_ptr
#endif
) {
    constexpr int M = GEMM_M, N = GEMM_N, K = GEMM_K;
    kittens::gl<fp8e4m3, 1, 1, M, K> A{A_ptr, nullptr, nullptr, nullptr, nullptr};
    kittens::gl<fp8e4m3, 1, 1, N, K> B{B_ptr, nullptr, nullptr, nullptr, nullptr};
    kittens::gl<bf16, 1, 1, M, N> C{C_ptr, nullptr, nullptr, nullptr, nullptr};

    constexpr int WARPS_COL = 2;
    constexpr int WARPS_ROW = 2;
    constexpr int BLOCK_SIZE_ROW = 256;
    constexpr int BLOCK_SIZE_COL = 256;
    constexpr int BLOCK_K = 128;
    constexpr int blocks_col = N / BLOCK_SIZE_COL;
    constexpr int k_iters = K / BLOCK_K;

    using ST_A = st_fp8e4m3<BLOCK_SIZE_ROW / 2, BLOCK_K, st_16x128_s>;
    using ST_B = st_fp8e4m3<BLOCK_SIZE_COL / 2, BLOCK_K, st_16x128_s>;
    using RT_A = rt_fp8e4m3<BLOCK_SIZE_ROW / 2 / WARPS_ROW, BLOCK_K>;
    using RT_B = rt_fp8e4m3<BLOCK_SIZE_COL / 2 / WARPS_COL, BLOCK_K>;
    using RT_C = rt_fl<BLOCK_SIZE_ROW / 2 / WARPS_ROW, BLOCK_SIZE_COL / 2 / WARPS_COL, col_l, rt_16x16_s>;

    __shared__ ST_A As[2][2];
    __shared__ ST_B Bs[2][2];
    RT_C c[2][2];

    int block_row = blockIdx.x / blocks_col;
    int block_col = blockIdx.x % blocks_col;
    int warp_m = warpid() / WARPS_COL;
    int warp_n = warpid() % WARPS_COL;
    int curr = 0, next = 1;

    {
    __builtin_amdgcn_sched_barrier(0);
    RT_A a[2];
    RT_B b[2];

    G::load(As[curr][0], A, {0, 0, block_row * WARPS_ROW, 0});
    G::load(Bs[curr][0], B, {0, 0, block_col * WARPS_COL, 0});
    G::load(Bs[curr][1], B, {0, 0, block_col * WARPS_COL + 1, 0});
    G::load(As[curr][1], A, {0, 0, block_row * WARPS_ROW + 1, 0});

    zero(c[0][0]); zero(c[0][1]); zero(c[1][0]); zero(c[1][1]);

    G::load(As[next][0], A, {0, 0, block_row * WARPS_ROW, 1});
    G::load(Bs[next][0], B, {0, 0, block_col * WARPS_COL, 1});
    G::load(Bs[next][1], B, {0, 0, block_col * WARPS_COL + 1, 1});
    G::load(As[next][1], A, {0, 0, block_row * WARPS_ROW + 1, 1});

    __builtin_amdgcn_sched_barrier(0);
    asm volatile("s_waitcnt vmcnt(28)");
    __builtin_amdgcn_s_barrier();
    __builtin_amdgcn_sched_barrier(0);
    auto a_subtile_0 = kittens::subtile_inplace<BLOCK_SIZE_ROW / 2 / WARPS_ROW, BLOCK_K>(As[curr][0], {warp_m, 0});
    load(a[0], a_subtile_0);
    __builtin_amdgcn_sched_barrier(0);
    asm volatile("s_waitcnt vmcnt(24)");
    __builtin_amdgcn_s_barrier();
    __builtin_amdgcn_sched_barrier(0);
    auto b_subtile_0 = kittens::subtile_inplace<BLOCK_SIZE_COL / 2 / WARPS_COL, BLOCK_K>(Bs[curr][0], {warp_n, 0});
    load(b[0], b_subtile_0);

    #pragma unroll
    for (int k = 0; k < k_iters - 2; ++k, curr ^= 1, next ^= 1) {
        __builtin_amdgcn_sched_barrier(0);
        asm volatile("s_waitcnt vmcnt(16)");
        asm volatile("s_waitcnt lgkmcnt(0)");
        __builtin_amdgcn_s_barrier();
        __builtin_amdgcn_sched_barrier(0);

        auto bs_subtile_1 = kittens::subtile_inplace<BLOCK_SIZE_COL / 2 / WARPS_COL, BLOCK_K>(Bs[curr][1], {warp_n, 0});
        do_interleaved_cluster(As[curr][0], A, {0, 0, block_row * WARPS_ROW, k + 2}, b[1], bs_subtile_1, a[0], b[0], c[0][0]);

        __builtin_amdgcn_sched_barrier(0);
        asm volatile("s_waitcnt lgkmcnt(0)");
        __builtin_amdgcn_sched_barrier(0);
        auto a_subtile_1 = kittens::subtile_inplace<BLOCK_SIZE_ROW / 2 / WARPS_ROW, BLOCK_K>(As[curr][1], {warp_m, 0});
        do_interleaved_cluster(Bs[curr][0], B, {0, 0, block_col * WARPS_COL, k + 2}, a[1], a_subtile_1, a[0], b[1], c[0][1]);

        __builtin_amdgcn_sched_barrier(0);
        asm volatile("s_waitcnt vmcnt(16)");
        __builtin_amdgcn_s_barrier();
        asm volatile("s_waitcnt lgkmcnt(0)");
        __builtin_amdgcn_sched_barrier(0);
        auto a_subtile_0_next = kittens::subtile_inplace<BLOCK_SIZE_ROW / 2 / WARPS_ROW, BLOCK_K>(As[next][0], {warp_m, 0});
        do_interleaved_cluster(Bs[curr][1], B, {0, 0, block_col * WARPS_COL + 1, k + 2}, a[0], a_subtile_0_next, a[1], b[0], c[1][0]);

        auto b_subtile_0_next = kittens::subtile_inplace<BLOCK_SIZE_COL / 2 / WARPS_COL, BLOCK_K>(Bs[next][0], {warp_n, 0});
        do_interleaved_cluster(As[curr][1], A, {0, 0, block_row * WARPS_ROW + 1, k + 2}, b[0], b_subtile_0_next, a[1], b[1], c[1][1]);
    }

    __builtin_amdgcn_sched_barrier(0);
    asm volatile("s_waitcnt vmcnt(16)");
    __builtin_amdgcn_s_barrier();
    __builtin_amdgcn_sched_barrier(0);
    __builtin_amdgcn_sched_barrier(0);
    asm volatile("s_waitcnt lgkmcnt(0)");
    __builtin_amdgcn_sched_barrier(0);
    auto b_subtile_1 = kittens::subtile_inplace<BLOCK_SIZE_COL / 2 / WARPS_COL, BLOCK_K>(Bs[curr][1], {warp_n, 0});
    load(b[1], b_subtile_1);
    __builtin_amdgcn_sched_barrier(0);
    mma_ABt(c[0][0], a[0], b[0], c[0][0]);
    __builtin_amdgcn_sched_barrier(0);
    __builtin_amdgcn_sched_barrier(0);
    asm volatile("s_waitcnt lgkmcnt(0)");
    __builtin_amdgcn_sched_barrier(0);
    auto a_subtile_1 = kittens::subtile_inplace<BLOCK_SIZE_ROW / 2 / WARPS_ROW, BLOCK_K>(As[curr][1], {warp_m, 0});
    load(a[1], a_subtile_1);
    __builtin_amdgcn_sched_barrier(0);
    mma_ABt(c[0][1], a[0], b[1], c[0][1]);
    __builtin_amdgcn_sched_barrier(0);
    __builtin_amdgcn_sched_barrier(0);
    asm volatile("s_waitcnt vmcnt(8)");
    __builtin_amdgcn_s_barrier();
    __builtin_amdgcn_sched_barrier(0);
    __builtin_amdgcn_sched_barrier(0);
    asm volatile("s_waitcnt lgkmcnt(0)");
    __builtin_amdgcn_sched_barrier(0);
    auto a_subtile_0_next = kittens::subtile_inplace<BLOCK_SIZE_ROW / 2 / WARPS_ROW, BLOCK_K>(As[next][0], {warp_m, 0});
    load(a[0], a_subtile_0_next);
    __builtin_amdgcn_sched_barrier(0);
    mma_ABt(c[1][0], a[1], b[0], c[1][0]);
    __builtin_amdgcn_sched_barrier(0);
    auto b_subtile_0_next = kittens::subtile_inplace<BLOCK_SIZE_COL / 2 / WARPS_COL, BLOCK_K>(Bs[next][0], {warp_n, 0});
    load(b[0], b_subtile_0_next);
    __builtin_amdgcn_sched_barrier(0);
    mma_ABt(c[1][1], a[1], b[1], c[1][1]);
    __builtin_amdgcn_sched_barrier(0);
    curr ^= 1; next ^= 1;

    __builtin_amdgcn_sched_barrier(0);
    asm volatile("s_waitcnt vmcnt(0)");
    __builtin_amdgcn_s_barrier();
    __builtin_amdgcn_sched_barrier(0);
    __builtin_amdgcn_sched_barrier(0);
    asm volatile("s_waitcnt lgkmcnt(0)");
    __builtin_amdgcn_sched_barrier(0);
    b_subtile_1 = kittens::subtile_inplace<BLOCK_SIZE_COL / 2 / WARPS_COL, BLOCK_K>(Bs[curr][1], {warp_n, 0});
    load(b[1], b_subtile_1);
    __builtin_amdgcn_sched_barrier(0);
    mma_ABt(c[0][0], a[0], b[0], c[0][0]);
    __builtin_amdgcn_sched_barrier(0);
    __builtin_amdgcn_sched_barrier(0);
    asm volatile("s_waitcnt lgkmcnt(0)");
    __builtin_amdgcn_sched_barrier(0);
    a_subtile_1 = kittens::subtile_inplace<BLOCK_SIZE_ROW / 2 / WARPS_ROW, BLOCK_K>(As[curr][1], {warp_m, 0});
    load(a[1], a_subtile_1);
    __builtin_amdgcn_sched_barrier(0);
    mma_ABt(c[0][1], a[0], b[1], c[0][1]);
    __builtin_amdgcn_sched_barrier(0);
    __builtin_amdgcn_sched_barrier(0);
    asm volatile("s_waitcnt lgkmcnt(0)");
    __builtin_amdgcn_sched_barrier(0);
    __builtin_amdgcn_sched_barrier(0);
    mma_ABt(c[1][0], a[1], b[0], c[1][0]);
    __builtin_amdgcn_sched_barrier(0);
    __builtin_amdgcn_sched_barrier(0);
    mma_ABt(c[1][1], a[1], b[1], c[1][1]);
    __builtin_amdgcn_sched_barrier(0);
    }

#if SCALE_MODE == 1
    float scale = *x_scale_ptr;
    mul(c[0][0], c[0][0], scale); mul(c[0][1], c[0][1], scale); mul(c[1][0], c[1][0], scale); mul(c[1][1], c[1][1], scale);
#elif SCALE_MODE == 2
    float scale = *w_scale_ptr;
    mul(c[0][0], c[0][0], scale); mul(c[0][1], c[0][1], scale); mul(c[1][0], c[1][0], scale); mul(c[1][1], c[1][1], scale);
#elif SCALE_MODE == 3
    float scale = *x_scale_ptr * *w_scale_ptr;
    mul(c[0][0], c[0][0], scale); mul(c[0][1], c[0][1], scale); mul(c[1][0], c[1][0], scale); mul(c[1][1], c[1][1], scale);
#endif

    store(C, c[0][0], {0, 0, (block_row * WARPS_ROW) * 2 + warp_m, (block_col * WARPS_COL) * 2 + warp_n});
    store(C, c[0][1], {0, 0, (block_row * WARPS_ROW) * 2 + warp_m, (block_col * WARPS_COL + 1) * 2 + warp_n});
    store(C, c[1][0], {0, 0, (block_row * WARPS_ROW + 1) * 2 + warp_m, (block_col * WARPS_COL) * 2 + warp_n});
    store(C, c[1][1], {0, 0, (block_row * WARPS_ROW + 1) * 2 + warp_m, (block_col * WARPS_COL + 1) * 2 + warp_n});
}
