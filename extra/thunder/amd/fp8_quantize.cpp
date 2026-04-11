#include "kittens.cuh"

using namespace kittens;

#ifndef QUANT_N
constexpr int QUANT_N = 131072;  // total number of elements
#endif

constexpr int NUM_WARPS = 4;
constexpr int NUM_THREADS = WARP_THREADS * NUM_WARPS;  // 256 threads per block
constexpr int ELEMENTS_PER_THREAD = 4;
constexpr int ELEMENTS_PER_BLOCK = NUM_THREADS * ELEMENTS_PER_THREAD;  // 1024 elements per block

constexpr float FP8_MAX = 448.0f;
constexpr float EPS = 1e-8f;

__device__ __forceinline__ float warp_reduce_max(float val) {
    #pragma unroll
    for (int offset = WARP_THREADS / 2; offset > 0; offset /= 2) {
        float other = __shfl_down(val, offset);
        val = (val > other) ? val : other;
    }
    return __shfl(val, 0);
}

// Use exact same helper as tinygrad renderer
__device__ __forceinline__ unsigned char f32_to_fp8_impl(float v) {
    // Check for NaN/Inf - if exponent bits are all 1, don't clamp
    unsigned int vi = std::bit_cast<unsigned int>(v);
    if ((vi & 0x7F800000) != 0x7F800000) {
        v = __builtin_amdgcn_fmed3f(v, FP8_MAX, -FP8_MAX);
    }
    return (unsigned char)__builtin_amdgcn_cvt_pk_fp8_f32(v, v, 0, false);
}

__global__ __launch_bounds__(NUM_THREADS, 1)
void hk_fp8_quantize(unsigned char* __restrict__ out_fp8,
                     float* __restrict__ out_inv_scale,
                     float* __restrict__ out_new_amax,
                     const bf16* __restrict__ in_x,
                     const float* __restrict__ in_amax_state) {
    const int tid = threadIdx.x;
    const int warp_id = tid / WARP_THREADS;
    const int lane_id = tid % WARP_THREADS;
    const int block_offset = blockIdx.x * ELEMENTS_PER_BLOCK;

    // load amax_state and compute scale - match tinygrad's computation order exactly
    const float amax_state = *in_amax_state;
    const float inv_amax = 1.0f / (amax_state + EPS);  // tinygrad computes 1/(amax+eps) first
    const float inv_scale = 1.0f / (inv_amax * FP8_MAX);  // then multiplies by FP8_MAX

    // write inv_scale and initialize out_new_amax once (first thread of first block)
    if (blockIdx.x == 0 && tid == 0) {
        *out_inv_scale = inv_scale;
        *out_new_amax = 0.0f;  // initialize for atomic max
        __threadfence();  // ensure initialization is visible to other blocks
    }

    // shared memory for block-level max reduction
    __shared__ float smem_max[NUM_WARPS];

    // each thread processes ELEMENTS_PER_THREAD elements
    float local_max = 0.0f;
    const int thread_offset = block_offset + tid * ELEMENTS_PER_THREAD;

    if (thread_offset < QUANT_N) {
        // load 4 bf16 values and process them
        #pragma unroll
        for (int i = 0; i < ELEMENTS_PER_THREAD; i++) {
            if (thread_offset + i < QUANT_N) {
                float v = float(in_x[thread_offset + i]);
                float abs_v = (v < 0.0f) ? -v : v;
                local_max = (local_max > abs_v) ? local_max : abs_v;

                // scale and convert to fp8 - match tinygrad's computation order
                float scaled = inv_amax * v * FP8_MAX;
                out_fp8[thread_offset + i] = f32_to_fp8_impl(scaled);
            }
        }
    }

    // warp-level reduction for max
    float warp_max = warp_reduce_max(local_max);

    // first lane of each warp writes to shared memory
    if (lane_id == 0) {
        smem_max[warp_id] = warp_max;
    }

    __syncthreads();

    // first warp reduces across all warps
    if (warp_id == 0) {
        float block_max = (lane_id < NUM_WARPS) ? smem_max[lane_id] : 0.0f;
        block_max = warp_reduce_max(block_max);

        // atomic max to global memory using CAS loop for float
        if (lane_id == 0 && block_max > 0.0f) {
            unsigned int* addr = reinterpret_cast<unsigned int*>(out_new_amax);
            unsigned int old = *addr;
            unsigned int assumed;
            do {
                assumed = old;
                float old_val = std::bit_cast<float>(assumed);
                if (block_max <= old_val) break;
                old = atomicCAS(addr, assumed, std::bit_cast<unsigned int>(block_max));
            } while (assumed != old);
        }
    }
}
