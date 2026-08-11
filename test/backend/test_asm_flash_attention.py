import math, unittest

import numpy as np

from tinygrad import Device, Tensor, dtypes
from tinygrad.helpers import DEV
from tinygrad.runtime.autogen.amd.cdna.ins import v_mov_b32_e32
from extra.attention.aiter_fa_asm import (_AiterDSLProgram, _pack_fwd, aiter_fa_backward, aiter_fa_forward,
                                         build_code_object, build_kernel, code_object_path)


def is_gfx950(): return Device[Device.DEFAULT].renderer.target.arch.startswith("gfx950")


@unittest.skipUnless(is_gfx950() and not DEV.interface.startswith("MOCK"), "requires a real gfx950 GPU")
class TestAsmFlashAttention(unittest.TestCase):
  B, H, S, D = 1, 8, 256, 128

  def test_dsl_roundtrip(self):
    for kind in ("fwd", "odo", "bwd", "dq"):
      self.assertGreater(len(build_kernel(kind)), 0)
      self.assertEqual(build_code_object(kind), code_object_path(kind).read_bytes())

  def _inputs(self):
    rng = np.random.default_rng(4)
    shape = (self.B, self.H, self.S, self.D)
    return tuple(Tensor(rng.standard_normal(shape, dtype=np.float32)*0.2, dtype=dtypes.bfloat16).contiguous() for _ in range(3))

  def test_forward(self):
    q, k, v = self._inputs()
    out, lse = aiter_fa_forward(q, k, v)
    scores = (q.float() @ k.float().transpose(-2, -1)) / math.sqrt(self.D)
    mask = Tensor.ones(self.S, self.S, dtype=dtypes.bool).tril()
    scores = mask.where(scores, -float("inf"))
    ref = scores.softmax(-1) @ v.float()
    np.testing.assert_allclose(out.float().numpy(), ref.numpy(), atol=3e-2, rtol=3e-2)
    np.testing.assert_allclose(lse.numpy(), scores.logsumexp(-1).numpy(), atol=2e-3, rtol=2e-3)

  def test_forward_gqa(self):
    q, k, v = self._inputs()
    k, v = k[:, :2].contiguous(), v[:, :2].contiguous()
    out, _ = aiter_fa_forward(q, k, v)
    kg = k.reshape(self.B, 2, 1, self.S, self.D).expand(self.B, 2, 4, self.S, self.D).reshape(q.shape)
    vg = v.reshape(self.B, 2, 1, self.S, self.D).expand(self.B, 2, 4, self.S, self.D).reshape(q.shape)
    scores = (q.float() @ kg.float().transpose(-2, -1)) / math.sqrt(self.D)
    ref = Tensor.ones(self.S, self.S, dtype=dtypes.bool).tril().where(scores, -float("inf")).softmax(-1) @ vg.float()
    np.testing.assert_allclose(out.float().numpy(), ref.numpy(), atol=3e-2, rtol=3e-2)

  def test_mutated_asm_fails_numerical_oracle(self):
    # A valid but wrong mutation: turn every hardware exponential into a zero move.
    mutated = tuple(v_mov_b32_e32(x.vdst, 0) if getattr(x, "op", None).name == "V_EXP_F32_E32" else x for x in build_kernel("fwd"))
    self.assertNotEqual(b"".join(x.to_bytes() for x in mutated), b"".join(x.to_bytes() for x in build_kernel("fwd")))
    q, k, v = self._inputs()
    bad, _ = aiter_fa_forward(q, k, v, _AiterDSLProgram(Device[q.device], "fwd", _pack_fwd, mutated))
    scores = (q.float() @ k.float().transpose(-2, -1)) / math.sqrt(self.D)
    ref = Tensor.ones(self.S, self.S, dtype=dtypes.bool).tril().where(scores, -float("inf")).softmax(-1) @ v.float()
    with self.assertRaises(AssertionError): np.testing.assert_allclose(bad.float().numpy(), ref.numpy(), atol=3e-2, rtol=3e-2)

  def test_backward(self):
    q, k, v = self._inputs()
    rng = np.random.default_rng(5)
    grad_out = Tensor(rng.standard_normal(q.shape, dtype=np.float32)*0.1, dtype=dtypes.bfloat16).contiguous()
    out, lse = aiter_fa_forward(q, k, v)
    dq, dk, dv = aiter_fa_backward(q, k, v, out, lse, grad_out)

    qr, kr, vr = (x.float().clone() for x in (q, k, v))
    scores = (qr @ kr.transpose(-2, -1)) / math.sqrt(self.D)
    mask = Tensor.ones(self.S, self.S, dtype=dtypes.bool).tril()
    ref = mask.where(scores, -float("inf")).softmax(-1) @ vr
    (ref * grad_out.float()).sum().backward()
    for name, actual, expected in (("dq", dq, qr.grad), ("dk", dk, kr.grad), ("dv", dv, vr.grad)):
      assert expected is not None
      np.testing.assert_allclose(actual.float().numpy(), expected.numpy(), atol=4e-2, rtol=5e-2, err_msg=name)


if __name__ == "__main__": unittest.main()
