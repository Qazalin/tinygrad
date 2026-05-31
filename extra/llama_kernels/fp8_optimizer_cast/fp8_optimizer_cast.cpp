#include <hip/hip_runtime.h>
#include <hip/hip_fp8.h>

#ifndef N_ELEMS
#define N_ELEMS 1
#endif
#ifndef ROWSZ
#define ROWSZ 1
#endif
#ifndef THREADS_PER_WG
#define THREADS_PER_WG 256
#endif
#ifndef VEC
#define VEC 4
#endif

constexpr float FP8_MAX = 448.0f;

extern "C" __global__ __launch_bounds__(THREADS_PER_WG) void
fp8_optimizer_cast(__hip_fp8_storage_t* out, const float* new_w, const float* inv_scale) {
  const long long tid = threadIdx.x;
  const long long gid = static_cast<long long>(blockIdx.x) * THREADS_PER_WG + tid;
  const long long base = gid * VEC;
  if (base >= N_ELEMS) return;

  __hip_fp8_storage_t v[VEC];
  #pragma unroll
  for (int i = 0; i < VEC; i++) {
    const long long idx = base + i;
    const float scale = 1.0f / inv_scale[idx / ROWSZ];
    const float x = fmaxf(-FP8_MAX, fminf(FP8_MAX, new_w[idx] * scale));
    v[i] = __hip_cvt_float_to_fp8(x, __HIP_SATFINITE, __HIP_E4M3);
  }
  *reinterpret_cast<uint32_t*>(&out[base]) = *reinterpret_cast<uint32_t*>(v);
}
