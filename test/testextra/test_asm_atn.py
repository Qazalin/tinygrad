import unittest
import numpy as np
from tinygrad import Tensor, Device, dtypes, Context
from extra.gemm.asm.cdna.atn import asm_atn, can_use_asm_atn
from test.helpers import needs_second_gpu

def is_cdna4(): return getattr(Device[Device.DEFAULT].renderer, "arch", "").startswith("gfx950")

class TestAsmAtn(unittest.TestCase):
  def setUp(self):
    if not is_cdna4():
      self.skipTest("ASM ATN only works on CDNA4 (MI350X)")

  def test_sdpa_forward(self):
    B, H, S, D = 8, 8, 8192, 128
    Tensor.manual_seed(0)
    q = Tensor.randn(B, H, S, D, dtype=dtypes.bfloat16)
    k = Tensor.randn(B, H, S, D, dtype=dtypes.bfloat16)
    v = Tensor.randn(B, H, S, D, dtype=dtypes.bfloat16)
    with Context(DEBUG=0): Tensor.realize(q, k, v)

    out_ref = Tensor.scaled_dot_product_attention(q, k, v, is_causal=True)
    out_asm = asm_atn(q, k, v)
    Tensor.realize(out_ref, out_asm)

if __name__ == "__main__":
  unittest.main()
