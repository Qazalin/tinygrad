#include <hip/hip_runtime.h>
#include <hip/hip_bf16.h>

#ifndef ATTN_B
#define ATTN_B 2
#endif
#ifndef ATTN_N
#define ATTN_N 8192
#endif
#ifndef ATTN_H
#define ATTN_H 32
#endif
#ifndef ATTN_H_KV
#define ATTN_H_KV 8
#endif
#ifndef ATTN_D
#define ATTN_D 128
#endif
#ifndef THREADS_PER_BLOCK
#define THREADS_PER_BLOCK 256
#endif

constexpr int GROUP_SIZE = ATTN_H / ATTN_H_KV;
constexpr int Q_ELEMS = ATTN_B * ATTN_N * ATTN_H * ATTN_D;
constexpr int KV_ELEMS = ATTN_B * ATTN_N * ATTN_H_KV * ATTN_D;
constexpr int PACKED_D = (GROUP_SIZE + 2) * ATTN_D;

extern "C" __global__ __launch_bounds__(THREADS_PER_BLOCK) void
fused_qkv_rope_backward(
    __hip_bfloat16*       __restrict__ dxqkv,
    const __hip_bfloat16* __restrict__ dq,
    const __hip_bfloat16* __restrict__ dk,
    const __hip_bfloat16* __restrict__ dv,
    const float*          __restrict__ freqs_cis) {
  const int tid = blockIdx.x * blockDim.x + threadIdx.x;
  const int stride = blockDim.x * gridDim.x;

  for (int idx = tid; idx < Q_ELEMS; idx += stride) {
    const int d = idx % ATTN_D;
    if (d & 1) continue;
    const int h = (idx / ATTN_D) % ATTN_H;
    const int n = (idx / (ATTN_D * ATTN_H)) % ATTN_N;
    const int b = idx / (ATTN_D * ATTN_H * ATTN_N);
    const int kvh = h / GROUP_SIZE;
    const int rep = h - kvh * GROUP_SIZE;
    const int pair = d >> 1;
    const int base = (((b * ATTN_N + n) * ATTN_H_KV + kvh) * PACKED_D) + rep * ATTN_D;
    const float c = freqs_cis[((n * (ATTN_D / 2) + pair) * 2) + 0];
    const float s = freqs_cis[((n * (ATTN_D / 2) + pair) * 2) + 1];
    const float ge = static_cast<float>(dq[idx]);
    const float go = static_cast<float>(dq[idx + 1]);
    dxqkv[base + d] = static_cast<__hip_bfloat16>(ge * c + go * s);
    dxqkv[base + d + 1] = static_cast<__hip_bfloat16>(-ge * s + go * c);
  }

  for (int idx = tid; idx < KV_ELEMS; idx += stride) {
    const int d = idx % ATTN_D;
    const int kvh = (idx / ATTN_D) % ATTN_H_KV;
    const int n = (idx / (ATTN_D * ATTN_H_KV)) % ATTN_N;
    const int b = idx / (ATTN_D * ATTN_H_KV * ATTN_N);
    const int base = ((b * ATTN_N + n) * ATTN_H_KV + kvh) * PACKED_D;
    if ((d & 1) == 0) {
      const int pair = d >> 1;
      const float c = freqs_cis[((n * (ATTN_D / 2) + pair) * 2) + 0];
      const float s = freqs_cis[((n * (ATTN_D / 2) + pair) * 2) + 1];
      const float ge = static_cast<float>(dk[idx]);
      const float go = static_cast<float>(dk[idx + 1]);
      dxqkv[base + GROUP_SIZE * ATTN_D + d] = static_cast<__hip_bfloat16>(ge * c + go * s);
      dxqkv[base + GROUP_SIZE * ATTN_D + d + 1] = static_cast<__hip_bfloat16>(-ge * s + go * c);
    }
    dxqkv[base + (GROUP_SIZE + 1) * ATTN_D + d] = dv[idx];
  }
}
