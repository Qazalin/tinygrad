import functools, unittest, time

from tinygrad import Tensor, Device, dtypes, Context
from tinygrad.engine.jit import TinyJit
import numpy as np

from extra.thunder.amd.fa import (custom_asm_fa_forward, custom_asm_fa_backward, custom_asm_fa_backward_shuffle,
                                 custom_fa_backward_pre, custom_fa_backward, custom_hk_fa_forward, flash_attention)

def assert_allclose(cmp:Tensor, ref:Tensor, **kwargs) -> None:
  if Device.DEFAULT == "NULL": Tensor.realize(cmp, ref)
  else: np.testing.assert_allclose(cmp.numpy(), ref.numpy(), **kwargs)

class TestFA(unittest.TestCase):
  def setUp(self):
    arch = Device[Device.DEFAULT].renderer.target.arch
    if not arch.startswith("gfx9"):
      self.skipTest(f"arch {arch} not supported")

  def test_fast_fa_causal(self):
    B, N, H, H_KV, D = 1, 8192, 32, 8, 128

    with Context(DEBUG=0):
      q = Tensor.randn(B, N, H, D, dtype=dtypes.bfloat16).contiguous()
      k = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      v = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      Tensor.realize(q, k, v)

    q, k, v = q.transpose(1, 2), k.transpose(1, 2), v.transpose(1, 2)

    fa_jitted = TinyJit(flash_attention)

    for _ in range(10):
      st = time.perf_counter()
      out = fa_jitted(q, k, v, is_causal=True)
      et = time.perf_counter() - st
      attn_flops = 2 * B * H * N * N * D + \
                   4 * B * H * N * N + \
                   2 * B * H * N * N * D
      print(f"{attn_flops/(et*1e9):2f} GFLOPS")
    out = out.float().transpose(1, 2)

    ref = q.scaled_dot_product_attention(k, v, is_causal=True, enable_gqa=True).float().transpose(1, 2)

    assert_allclose(out, ref, atol=2e-2, rtol=2e-2)

  def test_asm_fa_fwd_mlperf(self):
    if Device[Device.DEFAULT].renderer.target.arch != "gfx950": self.skipTest("translated FA requires gfx950")
    B, N, H, H_KV, D = 2, 8192, 32, 8, 128
    Tensor.manual_seed(42)
    with Context(DEBUG=0):
      q = Tensor.randn(B, N, H, D, dtype=dtypes.bfloat16).contiguous()
      k = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      v = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      Tensor.realize(q, k, v)

    def run(fxn):
      o = Tensor.empty(B, N, H, D, dtype=dtypes.bfloat16)
      lse = Tensor.empty(B, H, 1, N, dtype=dtypes.float32)
      return Tensor.custom_kernel(o, lse, q, k, v, fxn=fxn)[:2]

    def asm_fxn(*xs): return custom_asm_fa_forward(*xs, B=B, N=N, H=H, H_KV=H_KV, D=D)
    hk_fxn = functools.partial(custom_hk_fa_forward, device=Device.DEFAULT,
      arch=Device[Device.DEFAULT].renderer.target.arch, B=B, N=N, H=H, H_KV=H_KV, D=D, has_sink=False, window=0)
    out, lse = run(asm_fxn)
    ref, ref_lse = run(hk_fxn)
    assert_allclose(out, ref, atol=3e-2, rtol=3e-2)
    assert_allclose(lse, ref_lse, atol=3e-2, rtol=3e-2)

  def test_asm_fa_bwd_mlperf(self):
    if Device[Device.DEFAULT].renderer.target.arch != "gfx950": self.skipTest("translated FA requires gfx950")
    B, N, H, H_KV, D = 2, 8192, 32, 8, 128
    Tensor.manual_seed(42)
    with Context(DEBUG=0):
      q = Tensor.randn(B, N, H, D, dtype=dtypes.bfloat16).contiguous()
      k = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      v = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      do = Tensor.randn(B, N, H, D, dtype=dtypes.bfloat16).contiguous()
      Tensor.realize(q, k, v, do)

    def fwd_fxn(*xs): return custom_asm_fa_forward(*xs, B=B, N=N, H=H, H_KV=H_KV, D=D)
    o = Tensor.empty(B, N, H, D, dtype=dtypes.bfloat16)
    lse = Tensor.empty(B, H, 1, N, dtype=dtypes.float32)
    o, lse = Tensor.custom_kernel(o, lse, q, k, v, fxn=fwd_fxn)[:2]
    delta = Tensor.empty(B, H, 1, N, dtype=dtypes.float32)
    dq_pre = Tensor.empty(B, H, N, D, dtype=dtypes.bfloat16)
    pre_fxn = functools.partial(custom_fa_backward_pre, device=Device.DEFAULT, arch="gfx950", B=B, N=N, H=H, H_KV=H_KV, D=D)
    delta, dq_pre = Tensor.custom_kernel(delta, dq_pre, o, do, fxn=pre_fxn)[:2]

    # Existing ThunderKittens backward reference.
    ref_dk_partial = Tensor.empty(B * 2, N, H_KV, D, dtype=dtypes.bfloat16)
    ref_dv_partial = Tensor.empty(B * 2, N, H_KV, D, dtype=dtypes.bfloat16)
    hk_fxn = functools.partial(custom_fa_backward, device=Device.DEFAULT, arch="gfx950", B=B, N=N, H=H, H_KV=H_KV, D=D, window=0)
    ref_dq_raw, ref_dk_partial, ref_dv_partial = Tensor.custom_kernel(
      dq_pre, ref_dk_partial, ref_dv_partial, do, q, k, v, lse, delta, fxn=hk_fxn)[:3]
    ref_dq = ref_dq_raw.reshape(B, H, N//16, 4, 2, 2, D//32, 4, 4, 2).permute(0, 1, 2, 7, 8, 3, 4, 6, 5, 9).reshape(B, H, N, D).transpose(1, 2)
    ref_dk = ref_dk_partial.reshape(B, 2, N, H_KV, D).sum(1)
    ref_dv = ref_dv_partial.reshape(B, 2, N, H_KV, D).sum(1)

    dq_acc = Tensor.zeros(B, H, N, D, dtype=dtypes.bfloat16)
    dk_expanded = Tensor.empty(B, N, H, D, dtype=dtypes.bfloat16)
    dv_expanded = Tensor.empty(B, N, H, D, dtype=dtypes.bfloat16)
    asm_fxn = functools.partial(custom_asm_fa_backward, B=B, N=N, H=H, H_KV=H_KV, D=D)
    dq_acc, dk_expanded, dv_expanded = Tensor.custom_kernel(
      dq_acc, dk_expanded, dv_expanded, q, k, v, do, lse, delta, fxn=asm_fxn)[:3]
    dq = Tensor.empty(B, N, H, D, dtype=dtypes.bfloat16)
    shuffle_fxn = functools.partial(custom_asm_fa_backward_shuffle, B=B, N=N, H=H, D=D)
    dq = Tensor.custom_kernel(dq, dq_acc, fxn=shuffle_fxn)[0]
    dk = dk_expanded.reshape(B, N, H_KV, H // H_KV, D).sum(3)
    dv = dv_expanded.reshape(B, N, H_KV, H // H_KV, D).sum(3)

    Tensor.realize(dq, dk, dv, ref_dq, ref_dk, ref_dv)
    assert_allclose(dq, ref_dq, atol=4e-2, rtol=4e-2)
    assert_allclose(dk, ref_dk, atol=8e-2, rtol=5e-2)
    assert_allclose(dv, ref_dv, atol=8e-2, rtol=5e-2)

  def test_fast_fa_bwd_causal(self):
    Tensor.manual_seed(42)

    B, N, H, H_KV, D = 1, 8192, 32, 8, 128

    with Context(DEBUG=0):
      q = Tensor.randn(B, N, H, D, dtype=dtypes.bfloat16).contiguous()
      k = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      v = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      Tensor.realize(q, k, v)

      do = Tensor.ones(B, N, H, D, dtype=dtypes.float32).contiguous()
      Tensor.realize(do)

    q_, k_, v_ = q.transpose(1, 2), k.transpose(1, 2), v.transpose(1, 2)
    out = flash_attention(q_, k_, v_, is_causal=True)
    out = out.float().transpose(1, 2)
    out.backward(do)
    Tensor.realize(q.grad, k.grad, v.grad)

    with Context(DEBUG=0):
      q_ref = q.detach().clone()
      k_ref = k.detach().clone()
      v_ref = v.detach().clone()
      Tensor.realize(q_ref, k_ref, v_ref)

    q_ref_, k_ref_, v_ref_ = q_ref.transpose(1, 2), k_ref.transpose(1, 2), v_ref.transpose(1, 2)
    ref = q_ref_.scaled_dot_product_attention(k_ref_, v_ref_, is_causal=True, enable_gqa=True)
    ref = ref.float().transpose(1, 2)
    ref.backward(do)
    Tensor.realize(q_ref.grad, k_ref.grad, v_ref.grad)

    assert_allclose(q.grad, q_ref.grad, atol=2e-2, rtol=2e-2)
    assert_allclose(v.grad, v_ref.grad, atol=2e-2, rtol=2e-2)
    assert_allclose(k.grad, k_ref.grad, atol=6e-2, rtol=2e-2)

  def test_fast_fa_bwd_causal_jitted(self):
    Tensor.manual_seed(42)

    B, N, H, H_KV, D = 1, 8192, 32, 8, 128

    with Context(DEBUG=0):
      q = Tensor.randn(B, N, H, D, dtype=dtypes.bfloat16).contiguous()
      k = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      v = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      Tensor.realize(q, k, v)

      do = Tensor.ones(B, N, H, D, dtype=dtypes.float32).contiguous()
      Tensor.realize(do)

    def fn(q, k, v, do):
      q_, k_, v_ = q.transpose(1, 2), k.transpose(1, 2), v.transpose(1, 2)
      out = flash_attention(q_, k_, v_, is_causal=True)
      out = out.float().transpose(1, 2)
      out.backward(do)
      Tensor.realize(out, q.grad, k.grad, v.grad)
      return q.grad, k.grad, v.grad

    fn_jitted = TinyJit(fn)

    for _ in range(10):
      q = Tensor.randn(B, N, H, D, dtype=dtypes.bfloat16).contiguous()
      k = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      v = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      Tensor.realize(q, k, v)
      do = Tensor.ones(B, N, H, D, dtype=dtypes.float32).contiguous()
      Tensor.realize(do)
      q.grad, k.grad, v.grad = fn_jitted(q, k, v, do)

    with Context(DEBUG=0):
      q_ref = q.detach().clone()
      k_ref = k.detach().clone()
      v_ref = v.detach().clone()
      Tensor.realize(q_ref, k_ref, v_ref)

    q_ref_, k_ref_, v_ref_ = q_ref.transpose(1, 2), k_ref.transpose(1, 2), v_ref.transpose(1, 2)
    ref = flash_attention(q_ref_, k_ref_, v_ref_, is_causal=True)
    ref = ref.float().transpose(1, 2)
    ref.backward(do)
    Tensor.realize(q_ref.grad, k_ref.grad, v_ref.grad)

    assert_allclose(q.grad, q_ref.grad, atol=3e-3, rtol=3e-3)
    assert_allclose(k.grad, k_ref.grad, atol=1e-5, rtol=1e-5)
    assert_allclose(v.grad, v_ref.grad, atol=1e-5, rtol=1e-5)

  def test_fast_fa_bwd_dp(self):
    Tensor.manual_seed(42)

    B, N, H, H_KV, D = 2, 1024, 32, 8, 128
    GPUS = tuple(f"AMD:{i}" for i in range(B))

    with Context(DEBUG=0):
      base_q = Tensor.randn(B, N, H, D, dtype=dtypes.bfloat16).contiguous()
      base_k = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      base_v = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()

      base_do = Tensor.ones(B, N, H, D, dtype=dtypes.float32).contiguous()

    with Context(DEBUG=0):
      q = base_q.clone().shard(GPUS, axis=0)
      k = base_k.clone().shard(GPUS, axis=0)
      v = base_v.clone().shard(GPUS, axis=0)
      Tensor.realize(q, k, v)

      do = base_do.clone().shard(GPUS, axis=0)
      Tensor.realize(do)

    q_, k_, v_ = q.transpose(1, 2), k.transpose(1, 2), v.transpose(1, 2)
    out = flash_attention(q_, k_, v_, is_causal=True)
    out = out.float().transpose(1, 2)
    out.backward(do)
    Tensor.realize(q.grad, k.grad, v.grad)

    with Context(DEBUG=0):
      q_ref = base_q.clone()
      k_ref = base_k.clone()
      v_ref = base_v.clone()
      Tensor.realize(q_ref, k_ref, v_ref)

      do_ref = base_do.clone()
      Tensor.realize(do_ref)

    q_ref_, k_ref_, v_ref_ = q_ref.transpose(1, 2), k_ref.transpose(1, 2), v_ref.transpose(1, 2)
    ref = flash_attention(q_ref_, k_ref_, v_ref_, is_causal=True)
    ref = ref.float().transpose(1, 2)
    ref.backward(do_ref)
    Tensor.realize(q_ref.grad, k_ref.grad, v_ref.grad)

    assert_allclose(q.grad, q_ref.grad, atol=1e-5, rtol=1e-5)
    assert_allclose(v.grad, v_ref.grad, atol=1e-5, rtol=1e-5)
    assert_allclose(k.grad, k_ref.grad, atol=1e-5, rtol=1e-5)

  def test_fast_fa_bwd_mp(self):
    Tensor.manual_seed(42)

    B, N, H, H_KV, D = 2, 1024, 32, 8, 128
    GPUS = tuple(f"AMD:{i}" for i in range(B))

    with Context(DEBUG=0):
      base_q = Tensor.randn(B, N, H, D, dtype=dtypes.bfloat16).contiguous()
      base_k = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()
      base_v = Tensor.randn(B, N, H_KV, D, dtype=dtypes.bfloat16).contiguous()

      base_do = Tensor.ones(B, N, H, D, dtype=dtypes.float32).contiguous()

    with Context(DEBUG=0):
      q = base_q.clone().shard(GPUS, axis=2)
      k = base_k.clone().shard(GPUS, axis=2)
      v = base_v.clone().shard(GPUS, axis=2)
      Tensor.realize(q, k, v)

      do = base_do.clone().shard(GPUS, axis=2)
      Tensor.realize(do)

    q_, k_, v_ = q.transpose(1, 2), k.transpose(1, 2), v.transpose(1, 2)
    out = flash_attention(q_, k_, v_, is_causal=True)
    out = out.float().transpose(1, 2)
    out.backward(do)
    Tensor.realize(q.grad, k.grad, v.grad)

    with Context(DEBUG=0):
      q_ref = base_q.clone()
      k_ref = base_k.clone()
      v_ref = base_v.clone()
      Tensor.realize(q_ref, k_ref, v_ref)

      do_ref = base_do.clone()
      Tensor.realize(do_ref)

    q_ref_, k_ref_, v_ref_ = q_ref.transpose(1, 2), k_ref.transpose(1, 2), v_ref.transpose(1, 2)
    ref = flash_attention(q_ref_, k_ref_, v_ref_, is_causal=True)
    ref = ref.float().transpose(1, 2)
    ref.backward(do_ref)
    Tensor.realize(q_ref.grad, k_ref.grad, v_ref.grad)

    assert_allclose(q.grad, q_ref.grad, atol=1e-5, rtol=1e-5)
    assert_allclose(v.grad, v_ref.grad, atol=1e-5, rtol=1e-5)
    assert_allclose(k.grad, k_ref.grad, atol=1e-5, rtol=1e-5)

if __name__ == "__main__":
  unittest.main()
