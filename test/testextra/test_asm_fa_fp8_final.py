import os, unittest
from collections import Counter
from unittest.mock import patch

from tinygrad import Device, Tensor, dtypes
from tinygrad.function import function
from tinygrad.uop.ops import Ops
from extra.thunder.amd.fa import flash_attention, fused_qkv_rope


class TestFinalFP8FA(unittest.TestCase):
  @patch.dict(os.environ, {"DEVICE_IN_FUNCTION_BUG":"1", "FP8_FA":"1", "ASM_FP8_FA":"1", "FP8_FA_BWD":"1"})
  def test_saved_operands_and_kernel_sequence(self):
    if Device[Device.DEFAULT].renderer.target.arch != "gfx950": self.skipTest("requires gfx950")
    base = Device.DEFAULT.split(":")[0]
    devices = (Device.DEFAULT, f"{base}:1")
    x = Tensor.empty(4, 8192, 6144, dtype=dtypes.bfloat16).shard(devices, axis=0)
    freqs = Tensor.empty(1, 16384, 1, 64, 2, dtype=dtypes.bfloat16).shard(devices, axis=None)
    do = Tensor.empty(4, 8192, 32, 128, dtype=dtypes.bfloat16).shard(devices, axis=0)
    state = Tensor([1., 0.], dtype=dtypes.float32).shard(devices, axis=None)
    next_state = Tensor.zeros(2, dtype=dtypes.float32).shard(devices, axis=None)

    @function(precompile=True, precompile_backward=True)
    def layer(x, freqs, state, next_state):
      q, k, v, q8, k8 = fused_qkv_rope(x, freqs, 32, 8, 128, prequantize_fp8=True, write_bf16_qk=False)
      out, *saves = flash_attention(q, k, v, is_causal=True, q_fp8=q8, k_fp8=k8, save_fp8=True,
                                    fa_bwd_amax=state, next_fa_bwd_amax=next_state)
      return out + 0.1, *saves

    out, *_ = layer(x, freqs, state, next_state)
    out.backward(do)
    counts = Counter()
    for u in out.schedule_linear(x.grad).toposort():
      if u.op is Ops.SINK: counts[u.arg.name] += 1
      elif u.op is Ops.PROGRAM: counts[u.src[0].arg.name] += 1
    expected = {"fused_qkv_rope_forward":1, "fa_v_amax_partial":2, "fa_v_quantize":2,
                "asm_fa_fwd_fp8_causal_2_8192_32_8_128":2, "fa_fp8_bwd_init":1, "fa_fp8_bwd_prep":1,
                "hk_fa_fp8_backward":2, "fused_qkv_rope_backward":2}
    for name, count in expected.items(): self.assertEqual(counts[name], count, name)


if __name__ == "__main__": unittest.main()
