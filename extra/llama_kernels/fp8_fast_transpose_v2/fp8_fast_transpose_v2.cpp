#include <hip/hip_runtime.h>
#include <stdint.h>

// TransformerEngine-style RTC transpose specialized for FP8 byte payloads.
//
// in  : (ROWS_DIM, COLS_DIM) contiguous bytes
// out : (COLS_DIM, ROWS_DIM) contiguous bytes, out[c][r] = in[r][c]
//
// The important structure is the packed Vec union plus element reassignment in registers. On gfx950,
// AMD clang lowers that packing to v_perm_b32 and uses ds_read2/ds_write2 for the shared-memory tile.

#ifndef ROWS_DIM
#define ROWS_DIM 16384
#endif
#ifndef COLS_DIM
#define COLS_DIM 4096
#endif
#ifndef LOAD_SIZE
#define LOAD_SIZE 4
#endif
#ifndef STORE_SIZE
#define STORE_SIZE 4
#endif
#ifndef THREADS_PER_WARP
#define THREADS_PER_WARP 32
#endif
#ifndef WARPS_PER_TILE
#define WARPS_PER_TILE 4
#endif

constexpr int block_size = THREADS_PER_WARP * WARPS_PER_TILE;

template <int BYTES> struct BytesToType {};
template <> struct BytesToType<8> { using Type = uint64_t; };
template <> struct BytesToType<4> { using Type = uint32_t; };
template <> struct BytesToType<2> { using Type = uint16_t; };
template <> struct BytesToType<1> { using Type = uint8_t; };

template <typename Elt, int NUM_ELT>
struct Vec {
  static constexpr int BYTES = NUM_ELT * sizeof(Elt);
  using VecType = typename BytesToType<BYTES>::Type;
  union Alias { VecType vec; Elt elt[NUM_ELT]; } data;

  __device__ __forceinline__ void load_from(const void *ptr) {
    data.vec = *reinterpret_cast<const VecType*>(ptr);
  }
  __device__ __forceinline__ void store_to(void *ptr) const {
    *reinterpret_cast<VecType*>(ptr) = data.vec;
  }
};

template <bool RUNTIME_DIMS>
__device__ __forceinline__ void fp8_fast_transpose_v2_impl(uint8_t *__restrict__ out, const uint8_t *__restrict__ in,
                                                           const size_t row_length, const size_t num_rows) {
  constexpr int nvec_in = LOAD_SIZE;
  constexpr int nvec_out = STORE_SIZE;
  using IVec = Vec<uint8_t, nvec_in>;
  using OVec = Vec<uint8_t, nvec_out>;

  constexpr int tile_dim_m = THREADS_PER_WARP * nvec_out;
  constexpr int tile_dim_n = THREADS_PER_WARP * nvec_in;
  static_assert(RUNTIME_DIMS || ROWS_DIM % tile_dim_m == 0, "ROWS_DIM must align to tile rows");
  static_assert(RUNTIME_DIMS || COLS_DIM % tile_dim_n == 0, "COLS_DIM must align to tile columns");

  const size_t actual_rows = RUNTIME_DIMS ? num_rows : ROWS_DIM;
  const size_t actual_cols = RUNTIME_DIMS ? row_length : COLS_DIM;
  const size_t num_tiles_m = actual_rows / tile_dim_m;
  constexpr int num_iterations = THREADS_PER_WARP / WARPS_PER_TILE;

  const int tid = threadIdx.x;
  const int tidx = tid % THREADS_PER_WARP;
  const int tidy = tid / THREADS_PER_WARP;
  const int bid = blockIdx.x;

  const int tile_id_m = bid % num_tiles_m;
  const int tile_id_n = bid / num_tiles_m;
  const int tile_row = tile_id_m * tile_dim_m;
  const int tile_col = tile_id_n * tile_dim_n;

  OVec local_output[nvec_in][num_iterations];

  #pragma unroll
  for (int iter = 0; iter < num_iterations; ++iter) {
    const int i1 = tidy + iter * WARPS_PER_TILE;
    const int j1 = tidx;
    #pragma unroll
    for (int i2 = 0; i2 < nvec_out; ++i2) {
      const int row = tile_row + i1 * nvec_out + i2;
      const int col = tile_col + j1 * nvec_in;
      IVec local_input;
      local_input.load_from(&in[(long long)row * actual_cols + col]);
      #pragma unroll
      for (int j2 = 0; j2 < nvec_in; ++j2) {
        local_output[j2][iter].data.elt[i2] = local_input.data.elt[j2];
      }
    }
  }

  __shared__ OVec shared_output[THREADS_PER_WARP][THREADS_PER_WARP + 1];

  #pragma unroll
  for (int j2 = 0; j2 < nvec_in; ++j2) {
    #pragma unroll
    for (int iter = 0; iter < num_iterations; ++iter) {
      const int i1 = tidy + iter * WARPS_PER_TILE;
      const int j1 = tidx;
      shared_output[j1][i1] = local_output[j2][iter];
    }
    __syncthreads();

    #pragma unroll
    for (int iter = 0; iter < num_iterations; ++iter) {
      const int i1 = tidx;
      const int j1 = tidy + iter * WARPS_PER_TILE;
      const int row = tile_row + i1 * nvec_out;
      const int col = tile_col + j1 * nvec_in + j2;
      shared_output[j1][i1].store_to(&out[(long long)col * actual_rows + row]);
    }
    __syncthreads();
  }
}

extern "C" __global__ __launch_bounds__(block_size) void
fp8_fast_transpose_v2(uint8_t *__restrict__ out, const uint8_t *__restrict__ in) {
  fp8_fast_transpose_v2_impl<false>(out, in, COLS_DIM, ROWS_DIM);
}

extern "C" __global__ __launch_bounds__(block_size) void
fp8_fast_transpose_v2_rtc_like(const uint8_t *__restrict__ in, const float *const noop,
                               uint8_t *__restrict__ out, const size_t row_length,
                               const size_t num_rows) {
  if (noop != nullptr && noop[0] == 1.0f) return;
  fp8_fast_transpose_v2_impl<true>(out, in, row_length, num_rows);
}
