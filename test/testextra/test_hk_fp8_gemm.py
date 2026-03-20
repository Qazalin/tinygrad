import unittest
from tinygrad import Tensor, Device, dtypes, Context
from tinygrad.device import is_dtype_supported
from tinygrad.helpers import getenv
from extra.gemm.cdna_asm_gemm import asm_gemm
from test.helpers import needs_second_gpu

def is_cdna4(): return getattr(Device[Device.DEFAULT].renderer, "arch", "").startswith("gfx950")

def run_asm_gemm(a_shape, b_shape, dtype=dtypes.fp8e4m3, a_shard=None, b_shard=None, gpus:int=1) -> None:
  Tensor.manual_seed(0)
  a_rand = Tensor.randn(a_shape, dtype=dtypes.float).sub(0.5).cast(dtype)
  b_rand = Tensor.randn(b_shape, dtype=dtypes.float).sub(0.5).cast(dtype)
  with Context(DEBUG=0):
    Tensor.realize(a_rand, b_rand)

  devs = tuple(f"{Device.DEFAULT}:{i}" for i in range(gpus)) if (multi:=gpus>1) else None

  a, b = a_rand.clone().requires_grad_(), b_rand.clone().requires_grad_()
  if multi: a, b = a.shard(devs, axis=a_shard), b.shard(devs, axis=b_shard)
  with Context(ASM_GEMM=1):
    tst = asm_gemm(a, b)
    tst.sum().backward()
  Tensor.realize(tst, a.grad, b.grad)

  a_ref, b_ref = a_rand.clone().requires_grad_(), b_rand.clone().requires_grad_()
  if multi: a_ref, b_ref = a_ref.shard(devs, axis=a_shard), b_ref.shard(devs, axis=b_shard)
  with Context(ASM_GEMM=0):
    ref = asm_gemm(a_ref, b_ref)
    ref.sum().backward()
  Tensor.realize(ref, a_ref.grad, b_ref.grad)

  # no validation on the NULL device
  if a_rand.device.startswith("NULL"): return None
  atol, rtol = (1.0, 1e-1)
  with Context(DEBUG=0):
    assert tst.allclose(ref, atol=atol, rtol=rtol), "forward mismatch"
    assert a.grad.allclose(a_ref.grad, atol=atol, rtol=rtol), "grad_a mismatch"
    assert b.grad.allclose(b_ref.grad, atol=atol, rtol=rtol), "grad_b mismatch"

def verify_asm_gemm(batch:int, M:int, N:int, K:int, dtype=dtypes.fp8e4m3, gpus:int=1) -> None:
  run_asm_gemm((batch, M, K), (K, N), dtype=dtype, a_shard=0, b_shard=None, gpus=gpus)

def verify_asm_gemm_k_sharded(M:int, N:int, K:int, dtype=dtypes.fp8e4m3, gpus:int=8) -> None:
  run_asm_gemm((M, K), (K, N), dtype=dtype, a_shard=1, b_shard=0, gpus=gpus)

def verify_asm_gemm_n_sharded(batch:int, M:int, N:int, K:int, dtype=dtypes.fp8e4m3, gpus:int=2) -> None:
  run_asm_gemm((batch, M, K), (K, N), dtype=dtype, a_shard=None, b_shard=1, gpus=gpus)

def verify_asm_gemm_m_sharded(M:int, N:int, K:int, dtype=dtypes.fp8e4m3, gpus:int=2) -> None:
  run_asm_gemm((M, K), (K, N), dtype=dtype, a_shard=0, b_shard=None, gpus=gpus)

def verify_asm_gemm_n_sharded_2d(M:int, N:int, K:int, dtype=dtypes.fp8e4m3, gpus:int=2) -> None:
  run_asm_gemm((M, K), (K, N), dtype=dtype, a_shard=None, b_shard=1, gpus=gpus)

def verify_asm_gemm_k_sharded_3d(batch:int, M:int, N:int, K:int, dtype=dtypes.fp8e4m3, gpus:int=2) -> None:
  run_asm_gemm((batch, M, K), (K, N), dtype=dtype, a_shard=2, b_shard=0, gpus=gpus)

# HK FP8 GEMM requires M,N % 256 == 0, K % 128 == 0, K >= 256
# These tests mirror test_asm_gemm.py with fp8-compatible shapes

@unittest.skipUnless(is_dtype_supported(dtypes.fp8e4m3), "fp8 not supported")
@unittest.skipUnless(is_cdna4(), "HK FP8 GEMM requires CDNA4 (gfx950)")
class TestHKFP8Gemm(unittest.TestCase):
  # basic shapes
  def test_simple(self): verify_asm_gemm(1, N:=getenv("N", 4096), N, N)
  def test_gemm(self): verify_asm_gemm(1, 8192, 4096, 14336)
  def test_gemm_batched(self): verify_asm_gemm(2, 8192, 4096, 4096)

  # llama shapes
  def test_gemm1(self): verify_asm_gemm(1, 8192, 4096, 14336)
  def test_gemm3(self): verify_asm_gemm(1, 8192, 14336, 4096)
  def test_gemm4(self): verify_asm_gemm(1, 4096, 14336, 4096)
  def test_gemm5(self): verify_asm_gemm(1, 4096, 4096, 14336)
  def test_gemm8(self): verify_asm_gemm(1, 4096, 14336, 8192)
  def test_gemm10(self): verify_asm_gemm(1, 4096, 8192, 4096)

  # vary M, N, K independently
  def test_shape_small_square(self): verify_asm_gemm(1, 256, 256, 256)
  def test_shape_small_rect_m(self): verify_asm_gemm(1, 512, 256, 256)
  def test_shape_small_rect_n(self): verify_asm_gemm(1, 256, 512, 256)
  def test_shape_small_rect_k(self): verify_asm_gemm(1, 256, 256, 512)
  def test_shape_tall(self): verify_asm_gemm(1, 2048, 256, 256)
  def test_shape_wide(self): verify_asm_gemm(1, 256, 2048, 256)
  def test_shape_deep(self): verify_asm_gemm(1, 256, 256, 4096)
  def test_shape_non_square(self): verify_asm_gemm(1, 1024, 2048, 512)
  def test_shape_batched_small(self): verify_asm_gemm(2, 256, 256, 256)
  def test_shape_batched_rect(self): verify_asm_gemm(2, 512, 1024, 256)

  # K edge cases: K=256 (2 iters), K=384 (3 iters)
  def test_shape_k256(self): verify_asm_gemm(1, 256, 256, 256)
  def test_shape_k384(self): verify_asm_gemm(1, 256, 256, 384)

  # batch folding: batch*M must be multiple of 256
  def test_batch_fold_2(self): verify_asm_gemm(2, 256, 256, 256)
  def test_batch_fold_4(self): verify_asm_gemm(4, 256, 256, 256)
  def test_batch_fold_8(self): verify_asm_gemm(8, 1024, 4096, 4096)
  def test_batch_fold_16(self): verify_asm_gemm(16, 512, 4096, 4096)

  # real training shape that caused fault
  def test_training_shape_m65536_n6144_k4096(self): verify_asm_gemm(8, 65536, 6144, 4096, gpus=8)

  # sharding tests (require multiple GPUs)
  @needs_second_gpu
  def test_gemm_k_sharded(self): verify_asm_gemm_k_sharded(256, 256, 512, gpus=2)
  @needs_second_gpu
  def test_gemm_m_sharded(self): verify_asm_gemm_m_sharded(512, 256, 256, gpus=2)
  @needs_second_gpu
  def test_gemm_n_sharded(self): verify_asm_gemm_n_sharded(1, 256, 512, 256, gpus=2)
  @needs_second_gpu
  def test_gemm_n_sharded_2d(self): verify_asm_gemm_n_sharded_2d(256, 512, 256, gpus=2)
  @needs_second_gpu
  def test_gemm_k_sharded_3d(self): verify_asm_gemm_k_sharded_3d(1, 256, 256, 512, gpus=2)

  # larger sharding tests
  @needs_second_gpu
  def test_k_sharded_1(self): verify_asm_gemm_k_sharded(4096, 4096, 2048, gpus=2)
  @needs_second_gpu
  def test_k_sharded_2(self): verify_asm_gemm_k_sharded(4096, 4096, 2048, gpus=2)
  @needs_second_gpu
  def test_m_sharded_1(self): verify_asm_gemm_m_sharded(2048, 4096, 4096, gpus=2)
  @needs_second_gpu
  def test_n_sharded_2d_1(self): verify_asm_gemm_n_sharded_2d(4096, 2048, 4096, gpus=2)

if __name__ == "__main__":
  unittest.main()
