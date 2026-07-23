#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <hip/hip_runtime.h>

#include "gemm_mxfp4_thunder.cpp"

#define HIP_CHECK(expr) do { \
  hipError_t status = (expr); \
  if (status != hipSuccess) { \
    std::cerr << #expr << ": " << hipGetErrorString(status) << '\n'; \
    return 1; \
  } \
} while (0)

int main(int argc, char **argv) {
  constexpr size_t A_BYTES = static_cast<size_t>(GEMM_M) * GEMM_K / 2;
  constexpr size_t B_BYTES = static_cast<size_t>(GEMM_N) * GEMM_K / 2;
  constexpr size_t SA_BYTES = static_cast<size_t>(GEMM_M) * GEMM_K / 32;
  constexpr size_t SB_BYTES = static_cast<size_t>(GEMM_N) * GEMM_K / 32;
  constexpr size_t C_BYTES = static_cast<size_t>(GEMM_M) * GEMM_N * sizeof(__hip_bfloat16);
  int warmup = argc > 1 ? std::atoi(argv[1]) : 1000;
  int repeat = argc > 2 ? std::atoi(argv[2]) : 20;

  uint8_t *a, *b, *sa, *sb;
  __hip_bfloat16 *c;
  HIP_CHECK(hipMalloc(&a, A_BYTES));
  HIP_CHECK(hipMalloc(&b, B_BYTES));
  HIP_CHECK(hipMalloc(&sa, SA_BYTES));
  HIP_CHECK(hipMalloc(&sb, SB_BYTES));
  HIP_CHECK(hipMalloc(&c, C_BYTES));
  HIP_CHECK(hipMemset(a, 0x22, A_BYTES));
  HIP_CHECK(hipMemset(b, 0x22, B_BYTES));
  HIP_CHECK(hipMemset(sa, 127, SA_BYTES));
  HIP_CHECK(hipMemset(sb, 127, SB_BYTES));

  dim3 grid((GEMM_M / BLOCK_M) * (GEMM_N / BLOCK_N));
  dim3 block(NUM_WARPS * WARP_THREADS);
  auto launch = [&]() {
    hipLaunchKernelGGL(mxfp4_gemm, grid, block, 0, nullptr, c, a, b, sa, sb, a, b);
  };
  for (int i = 0; i < warmup; i++) launch();
  HIP_CHECK(hipDeviceSynchronize());

  hipEvent_t start, stop;
  HIP_CHECK(hipEventCreate(&start));
  HIP_CHECK(hipEventCreate(&stop));
  HIP_CHECK(hipEventRecord(start));
  for (int i = 0; i < repeat; i++) launch();
  HIP_CHECK(hipEventRecord(stop));
  HIP_CHECK(hipEventSynchronize(stop));
  float elapsed_ms;
  HIP_CHECK(hipEventElapsedTime(&elapsed_ms, start, stop));
  float mean_ms = elapsed_ms / repeat;
  double tflops = 2.0 * GEMM_M * GEMM_N * GEMM_K / (mean_ms * 1e9);
  std::cout << GEMM_M << 'x' << GEMM_N << 'x' << GEMM_K << "  "
            << std::fixed << std::setprecision(3) << mean_ms << " ms  "
            << std::setprecision(2) << tflops << " TFLOPS\n";

  HIP_CHECK(hipEventDestroy(start));
  HIP_CHECK(hipEventDestroy(stop));
  HIP_CHECK(hipFree(a));
  HIP_CHECK(hipFree(b));
  HIP_CHECK(hipFree(sa));
  HIP_CHECK(hipFree(sb));
  HIP_CHECK(hipFree(c));
  return 0;
}
