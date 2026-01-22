import numpy as np
from tinygrad import Tensor, dtypes
from tinygrad.helpers import getenv

M, N, K, batch = getenv("M", 612), getenv("N", 1024), getenv("K", 1024), getenv("B", 6)

rng = np.random.default_rng(0)
A = Tensor(rng.random((batch, M, K), dtype=np.float32) - 0.5, dtype=dtypes.half)
B = Tensor(rng.random((K, N), dtype=np.float32) - 0.5, dtype=dtypes.half)

# This will use fast_gemm if FAST_GEMM=1
C = A @ B
C.realize()

print(f"M={M} N={N} K={K} batch={batch}")

# Verify correctness
expected = (A.numpy().astype(np.float32) @ B.numpy().astype(np.float32)).astype(np.float16)
np.testing.assert_allclose(C.numpy(), expected, rtol=1e-2, atol=1e-2)
print("PASS")
