
import numpy as np

def test_valid(batch, M, N, K, desc=""):
  """Test that valid inputs produce correct results."""
  rng = np.random.default_rng(42)
  if batch is None:
    # 2D test
    A = Tensor(rng.random((M, K), dtype=np.float32) - 0.5, dtype=dtypes.half)
  else:
    # 3D test
    A = Tensor(rng.random((batch, M, K), dtype=np.float32) - 0.5, dtype=dtypes.half)
  B = Tensor(rng.random((K, N), dtype=np.float32) - 0.5, dtype=dtypes.half)

  out = fast_matmul(A, B)
  expected = A @ B

  np.testing.assert_allclose(out.numpy(), expected.numpy(), rtol=1e-2, atol=1e-2)
  shape_str = f"({M},{K})@({K},{N})" if batch is None else f"({batch},{M},{K})@({K},{N})"
  print(f"  PASS: {shape_str} {desc}")

def test_invalid(fn, expected_errors, desc):
  """Test that invalid inputs raise the expected error."""
  if not isinstance(expected_errors, tuple):
    expected_errors = (expected_errors,)
  try:
    fn()
    names = "/".join(e.__name__ for e in expected_errors)
    print(f"  FAIL: {desc} - expected {names} but no error raised")
  except expected_errors as e:
    print(f"  PASS: {desc} -> {type(e).__name__}")
  except Exception as e:
    names = "/".join(err.__name__ for err in expected_errors)
    print(f"  FAIL: {desc} - expected {names} but got {type(e).__name__}: {e}")

print("=" * 60)
print("VALID INPUT TESTS")
print("=" * 60)

# Basic cases
test_valid(6, 612, 1024, 1024, "(default case)")
test_valid(1, 128, 256, 256, "(small)")
test_valid(12, 1024, 1024, 1024, "(large batch)")

# 2D input (no batch)
test_valid(None, 256, 512, 512, "(2D input)")
test_valid(None, 128, 1024, 1024, "(2D large)")

# Various N values (multiples of 128)
test_valid(4, 256, 128, 512, "(N=128)")
test_valid(4, 256, 256, 512, "(N=256)")
test_valid(4, 256, 512, 512, "(N=512)")
test_valid(4, 256, 1024, 512, "(N=1024)")
test_valid(4, 256, 2048, 512, "(N=2048)")

# Various K values (multiples of 64, min ~192)
test_valid(4, 256, 512, 192, "(K=192)")
test_valid(4, 256, 512, 256, "(K=256)")
test_valid(4, 256, 512, 512, "(K=512)")
test_valid(4, 256, 512, 1024, "(K=1024)")
test_valid(4, 256, 512, 2048, "(K=2048)")

# Mixed N and K
test_valid(2, 512, 512, 1024, "(N=512, K=1024)")
test_valid(2, 512, 1024, 512, "(N=1024, K=512)")
test_valid(2, 512, 2048, 2048, "(N=2048, K=2048)")

# Edge cases for batch and M
test_valid(1, 64, 256, 256, "(B=1, M=64)")
test_valid(1, 1024, 512, 512, "(B=1, M=1024)")
test_valid(16, 128, 512, 512, "(B=16)")

print()
print("=" * 60)
print("INVALID INPUT TESTS")
print("=" * 60)

# Wrong dtype
test_invalid(
  lambda: fast_matmul(
    Tensor.randn(4, 256, 512),  # float32, not half
    Tensor.randn(512, 1024).cast(dtypes.half)
  ),
  AssertionError,
  "A is float32 (should be half)"
)

test_invalid(
  lambda: fast_matmul(
    Tensor.randn(4, 256, 512).cast(dtypes.half),
    Tensor.randn(512, 1024)  # float32, not half
  ),
  AssertionError,
  "B is float32 (should be half)"
)

# Dimension mismatch
test_invalid(
  lambda: fast_matmul(
    Tensor.randn(4, 256, 512).cast(dtypes.half),  # K=512
    Tensor.randn(1024, 256).cast(dtypes.half)     # K=1024
  ),
  AssertionError,
  "K dimension mismatch (512 vs 1024)"
)

test_invalid(
  lambda: fast_matmul(
    Tensor.randn(4, 256, 256).cast(dtypes.half),  # K=256
    Tensor.randn(512, 1024).cast(dtypes.half)     # K=512
  ),
  AssertionError,
  "K dimension mismatch (256 vs 512)"
)

# K not multiple of 64 (KT=64)
test_invalid(
  lambda: fast_matmul(
    Tensor.randn(4, 256, 300).cast(dtypes.half),  # K=300, not multiple of 64
    Tensor.randn(300, 512).cast(dtypes.half)
  ),
  (AssertionError, ZeroDivisionError, RuntimeError),
  "K=300 not multiple of 64"
)

# K too small (need at least ~192 for iters >= 3)
test_invalid(
  lambda: fast_matmul(
    Tensor.randn(4, 256, 64).cast(dtypes.half),  # K=64, iters=1
    Tensor.randn(64, 512).cast(dtypes.half)
  ),
  (AssertionError, RuntimeError),
  "K=64 too small (iters=1)"
)

print()
print("=" * 60)
print("ALL TESTS COMPLETED")
print("=" * 60)
