import unittest
import numpy as np
from extra.gemm.asm.cdna.fast_gemm import fast_gemm
from tinygrad import Tensor, dtypes, Context
from tinygrad.engine.jit import TinyJit

def _test_gemm(A_shape, B_shape):
  rng = np.random.default_rng(1337)
  A = Tensor(rng.random(A_shape, dtype=np.float32) - 0.5, dtype=dtypes.half)
  B = Tensor(rng.random(B_shape, dtype=np.float32) - 0.5, dtype=dtypes.half)
  with Context(DEBUG=0):
    Tensor.realize(A, B)
  C_asm = fast_gemm(A, B)
  C_tiny = A @ B
  Tensor.realize(C_asm, C_tiny)
  np.testing.assert_allclose(C_asm.numpy(), C_tiny.numpy(), rtol=1e-2, atol=1e-2)

class TestGemm(unittest.TestCase):
  def test_default(self):
    _test_gemm((6, 612, 1024), (1024, 1024))

  def test_small(self):
    _test_gemm((1, 128, 256), (256, 256))

  def test_large_batch(self):
    _test_gemm((12, 1024, 1024), (1024, 1024))

  def test_2d(self):
    _test_gemm((256, 512), (512, 512))

  def test_2d_large(self):
    _test_gemm((128, 1024), (1024, 1024))

  def test_n_128(self):
    _test_gemm((4, 256, 512), (512, 128))

  def test_n_256(self):
    _test_gemm((4, 256, 512), (512, 256))

  def test_n_512(self):
    _test_gemm((4, 256, 512), (512, 512))

  def test_n_1024(self):
    _test_gemm((4, 256, 512), (512, 1024))

  def test_n_2048(self):
    _test_gemm((4, 256, 512), (512, 2048))

  def test_k_192(self):
    _test_gemm((4, 256, 192), (192, 512))

  def test_k_256(self):
    _test_gemm((4, 256, 256), (256, 512))

  def test_k_512(self):
    _test_gemm((4, 256, 512), (512, 512))

  def test_k_1024(self):
    _test_gemm((4, 256, 1024), (1024, 512))

  def test_k_2048(self):
    _test_gemm((4, 256, 2048), (2048, 512))

  def test_n_512_k_1024(self):
    _test_gemm((2, 512, 1024), (1024, 512))

  def test_n_1024_k_512(self):
    _test_gemm((2, 512, 512), (512, 1024))

  def test_n_2048_k_2048(self):
    _test_gemm((2, 512, 2048), (2048, 2048))

  def test_b1_m64(self):
    _test_gemm((1, 64, 256), (256, 256))

  def test_b1_m1024(self):
    _test_gemm((1, 1024, 512), (512, 512))

  def test_b16(self):
    _test_gemm((16, 128, 512), (512, 512))

  def test_invalid_a_dtype(self):
    A = Tensor.randn(4, 256, 512)
    B = Tensor.randn(512, 1024).cast(dtypes.half)
    with self.assertRaises(AssertionError):
      fast_gemm(A, B)

  def test_invalid_b_dtype(self):
    A = Tensor.randn(4, 256, 512).cast(dtypes.half)
    B = Tensor.randn(512, 1024)
    with self.assertRaises(AssertionError):
      fast_gemm(A, B)

  def test_invalid_k_mismatch_512_1024(self):
    A = Tensor.randn(4, 256, 512).cast(dtypes.half)
    B = Tensor.randn(1024, 256).cast(dtypes.half)
    with self.assertRaises(AssertionError):
      fast_gemm(A, B)

  def test_invalid_k_mismatch_256_512(self):
    A = Tensor.randn(4, 256, 256).cast(dtypes.half)
    B = Tensor.randn(512, 1024).cast(dtypes.half)
    with self.assertRaises(AssertionError):
      fast_gemm(A, B)

  def test_invalid_k_not_multiple_64(self):
    A = Tensor.randn(4, 256, 300).cast(dtypes.half)
    B = Tensor.randn(300, 512).cast(dtypes.half)
    with self.assertRaises((AssertionError, ZeroDivisionError, RuntimeError)):
      fast_gemm(A, B)

  def test_invalid_k_too_small(self):
    A = Tensor.randn(4, 256, 64).cast(dtypes.half)
    B = Tensor.randn(64, 512).cast(dtypes.half)
    with self.assertRaises((AssertionError, RuntimeError)):
      fast_gemm(A, B)

  def test_gpt2(self):
    _test_gemm((1, 13, 1024), (1024, 1024))

  def test_gpt2_alt(self):
    _test_gemm((1, 13, 1024), (1024, 3072))

  def test_backward(self):
    rng = np.random.default_rng(1337)
    A_np = rng.random((4, 256, 256), dtype=np.float32) - 0.5
    B_np = rng.random((256, 256), dtype=np.float32) - 0.5

    A = Tensor(A_np, dtype=dtypes.half, requires_grad=True)
    B = Tensor(B_np, dtype=dtypes.half, requires_grad=True)
    with Context(DEBUG=0): Tensor.realize(A, B)
    C_asm = fast_gemm(A, B)
    C_asm.sum().backward()
    grad_A_asm, grad_B_asm = A.grad, B.grad
    Tensor.realize(C_asm, grad_A_asm, grad_B_asm)

    A_ref = Tensor(A_np, dtype=dtypes.half, requires_grad=True)
    B_ref = Tensor(B_np, dtype=dtypes.half, requires_grad=True)
    with Context(DEBUG=0): Tensor.realize(A_ref, B_ref)
    C_ref = A_ref @ B_ref
    C_ref.sum().backward()
    grad_A_ref, grad_B_ref = A_ref.grad, B_ref.grad
    Tensor.realize(C_ref, grad_A_ref, grad_B_ref)

    np.testing.assert_allclose(C_asm.numpy(), C_ref.numpy(), rtol=1e-2, atol=1e-2)
    np.testing.assert_allclose(grad_A_asm.numpy(), grad_A_ref.numpy(), rtol=1e-2, atol=1e-2)
    np.testing.assert_allclose(grad_B_asm.numpy(), grad_B_ref.numpy(), rtol=1e-2, atol=1e-2)

  def test_multi(self):
    devs = ("AMD:0", "AMD:1")
    rng = np.random.default_rng(1337)
    A = Tensor(rng.random((4, 256, 256), dtype=np.float32) - 0.5, dtype=dtypes.half).shard_(devs, axis=0)
    B = Tensor(rng.random((256, 256), dtype=np.float32) - 0.5, dtype=dtypes.half).to(devs)
    with Context(DEBUG=0): Tensor.realize(A, B)
    C_asm = fast_gemm(A, B)
    C_tiny = A @ B
    Tensor.realize(C_asm, C_tiny)
    np.testing.assert_allclose(C_asm.numpy(), C_tiny.numpy(), rtol=1e-2, atol=1e-2)

  def test_jit(self):
    @TinyJit
    def jit_gemm(A, B): return fast_gemm(A, B).realize()

    rng = np.random.default_rng(1337)
    for _ in range(5):
      A = Tensor(rng.random((4, 256, 256), dtype=np.float32) - 0.5, dtype=dtypes.half)
      B = Tensor(rng.random((256, 256), dtype=np.float32) - 0.5, dtype=dtypes.half)
      with Context(DEBUG=0): Tensor.realize(A, B)
      C_asm = jit_gemm(A, B)
      C_tiny = A @ B
      Tensor.realize(C_tiny)
      np.testing.assert_allclose(C_asm.numpy(), C_tiny.numpy(), rtol=1e-2, atol=1e-2)

  @unittest.skip("KNOWN BUG: JIT replay without sync causes race condition with stream-k flags")
  def test_jit_chained(self):
    """
    Two fast_gemm calls within a single JIT function.
    This simulates the GPT2 pattern where multiple Linear layers use fast_gemm.

    KNOWN BUG: This test fails after JIT capture when run without synchronization.

    Passes with:
      JIT=0              (no JIT - kernels run with implicit sync)
      WAIT=1 JIT=2       (explicit sync between kernels)
      DEBUG=2 JIT=2      (wait=True adds sync)

    Fails with:
      JIT=2              (JIT replay without graph, no sync)
      JIT=1              (JIT replay with HCQ graph - hangs)

    ROOT CAUSE: The fast_gemm kernel uses stream-k which requires the flags
    buffer to be zeroed before kernel execution. A separate zeros kernel
    initializes the flags. During JIT replay without sync, the gemm kernel
    starts before the zeros kernel completes, reading uninitialized flag values.

    The dependency tracking (KernelInfo.outs/ins) is correctly set:
    - Zeros kernel: outs=[0] writes to flags buffer
    - Gemm kernel: ins=[..., 4, ...] reads flags buffer (buffer 4)

    However, JIT=2 replay doesn't use dependency info - it just launches
    kernels in sequence without waiting. JIT=1 creates an HCQ graph which
    should handle dependencies but hangs (needs investigation).

    WORKAROUND: Use WAIT=1 to ensure synchronization between kernels.

    Run with: python extra/gemm/asm/cdna/test_fast_gemm.py debug
    """
    @TinyJit
    def two_gemms(x, W1, W2):
      h = fast_gemm(x, W1)
      out = fast_gemm(h, W2)
      return out.realize()

    rng = np.random.default_rng(1337)
    W1 = Tensor(rng.random((256, 256), dtype=np.float32) - 0.5, dtype=dtypes.half)
    W2 = Tensor(rng.random((256, 256), dtype=np.float32) - 0.5, dtype=dtypes.half)
    with Context(DEBUG=0): Tensor.realize(W1, W2)

    for i in range(5):
      x = Tensor(rng.random((2, 1, 256), dtype=np.float32) - 0.5, dtype=dtypes.half)
      with Context(DEBUG=0): x.realize()
      C_asm = two_gemms(x, W1, W2)
      C_tiny = (x @ W1) @ W2
      Tensor.realize(C_tiny)
      np.testing.assert_allclose(C_asm.numpy(), C_tiny.numpy(), rtol=1e-2, atol=1e-2, err_msg=f"Failed at iteration {i}")

def debug_jit_chained():
  """
  Debug script for the chained JIT issue.

  Run with different settings:
    JIT=0: No JIT (should pass)
    JIT=2: JIT without graph (should fail after iter 1)
    JIT=1: JIT with HCQ graph (may hang)
    WAIT=1 JIT=2: JIT with explicit sync (should pass)
  """
  import sys
  from tinygrad.helpers import getenv

  jit_level = getenv("JIT", 2)
  wait = getenv("WAIT", 0)
  print(f"JIT={jit_level} WAIT={wait}")

  @TinyJit
  def two_gemms(x, W1, W2):
    h = fast_gemm(x, W1)
    out = fast_gemm(h, W2)
    return out.realize()

  rng = np.random.default_rng(1337)
  W1 = Tensor(rng.random((256, 256), dtype=np.float32) - 0.5, dtype=dtypes.half)
  W2 = Tensor(rng.random((256, 256), dtype=np.float32) - 0.5, dtype=dtypes.half)
  with Context(DEBUG=0): Tensor.realize(W1, W2)

  failed = False
  for i in range(5):
    x = Tensor(rng.random((2, 1, 256), dtype=np.float32) - 0.5, dtype=dtypes.half)
    with Context(DEBUG=0): x.realize()
    C_asm = two_gemms(x, W1, W2)
    C_tiny = (x @ W1) @ W2
    Tensor.realize(C_tiny)
    diff = np.abs(C_asm.numpy() - C_tiny.numpy()).max()
    status = "PASS" if diff < 0.1 else "FAIL"
    if diff >= 0.1: failed = True
    print(f"Iter {i}: {status} max_diff={diff:.6f}")

  sys.exit(1 if failed else 0)

if __name__ == "__main__":
  import sys
  if len(sys.argv) > 1 and sys.argv[1] == "debug":
    debug_jit_chained()
  else:
    unittest.main()
