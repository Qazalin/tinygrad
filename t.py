import numpy as np
from tinygrad import Tensor, dtypes
from tinygrad.helpers import getenv
from extra.gemm.asm.cdna.fast_gemm import fast_gemm

if __name__ == "__main__":
  M, N, K, batch = getenv("M", 612), getenv("N", 1024), getenv("K", 1024), getenv("B", 6)

  rng = np.random.default_rng(0)
  A = Tensor(rng.random((batch, M, K), dtype=np.float32) - 0.5, dtype=dtypes.half)
  B = Tensor(rng.random((K, N), dtype=np.float32) - 0.5, dtype=dtypes.half)
  Tensor.realize(A, B)

  C_asm = fast_gemm(A, B)
  C_tiny = A @ B

  Tensor.realize(C_asm, C_tiny)
  print(f"M={M} N={N} K={K} batch={batch}")
  np.testing.assert_allclose(C_asm.numpy(), C_tiny.numpy(), rtol=1e-2, atol=1e-2)
  print("PASS")
