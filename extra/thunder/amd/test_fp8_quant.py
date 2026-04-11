"""
Test harness for a custom fp8 quantize kernel.

- `ref_quantize_fp8` is a verbatim copy of flat_llama.quantize_fp8 (the tinygrad-scheduler impl).
- `custom_quantize_fp8` is currently a placeholder that just calls the ref impl. Later we swap
  in a Tensor.custom_kernel-based implementation and these tests become the correctness gate.

Run on real hardware (MI350X):
  AMD=1 PYTHONPATH=. python extra/thunder/amd/test_fp8_quant.py
"""
import unittest
from tinygrad import Tensor, dtypes, Device
from tinygrad.helpers import Context

FP8_DTYPE = dtypes.fp8e4m3
FP8_MAX = 448.0


def ref_quantize_fp8(x: Tensor, amax_state: Tensor | None = None):
  """Verbatim copy of examples/mlperf/models/flat_llama.py:26-31."""
  new_amax = x.abs().max().detach()
  scale = FP8_MAX / ((amax_state if amax_state is not None else new_amax) + 1e-8)
  x_scaled = x * scale
  x_clamped = x_scaled + (x_scaled.detach().clamp(-FP8_MAX, FP8_MAX) - x_scaled.detach())  # STE
  return x_clamped.cast(FP8_DTYPE), scale.float().reciprocal(), new_amax


def custom_quantize_fp8(x: Tensor, amax_state: Tensor | None = None):
  new_amax = x.abs().max().detach()
  scale = FP8_MAX / ((amax_state if amax_state is not None else new_amax) + 1e-8)
  x_scaled = x * scale
  x_clamped = x_scaled + (x_scaled.detach().clamp(-FP8_MAX, FP8_MAX) - x_scaled.detach())  # STE
  return x_clamped.cast(FP8_DTYPE), scale.float().reciprocal(), new_amax


def _shard_dp(*ts: Tensor) -> tuple[Tensor, ...]:
  devs = tuple(f"{Device.DEFAULT}:{i}" for i in range(8))
  out = []
  for t in ts:
    if t.shape and t.shape[0] % len(devs) == 0:
      out.append(t.shard(devs, axis=0))
    else:
      out.append(t.shard(devs, axis=None))
  return tuple(out)


class TestFp8QuantForwardValues(unittest.TestCase):
  """Forward numeric equivalence between ref and custom on real inputs."""

  def _cmp_fwd(self, x: Tensor, amax_state: Tensor | None):
    x_ref = x.clone()
    x_cst = x.clone()
    amax_ref = amax_state.clone() if amax_state is not None else None
    amax_cst = amax_state.clone() if amax_state is not None else None
    with Context(DEBUG=0):
      Tensor.realize(x_ref, x_cst)
      if amax_state is not None: Tensor.realize(amax_ref, amax_cst)

    ref_fp8, ref_scale, ref_amax = ref_quantize_fp8(x_ref, amax_state=amax_ref)
    cst_fp8, cst_scale, cst_amax = custom_quantize_fp8(x_cst, amax_state=amax_cst)

    ctx = f"shape={tuple(x.shape)} dtype={x.dtype} amax_state={'None' if amax_state is None else amax_state.cast(dtypes.float32).item()}"

    # shape / dtype / device contract
    self.assertEqual(ref_fp8.shape, cst_fp8.shape,
                     f"x_fp8 shape mismatch [{ctx}]: ref={tuple(ref_fp8.shape)} cst={tuple(cst_fp8.shape)}")
    self.assertEqual(ref_fp8.dtype, cst_fp8.dtype,
                     f"x_fp8 dtype mismatch [{ctx}]: ref={ref_fp8.dtype} cst={cst_fp8.dtype}")
    self.assertEqual(ref_fp8.dtype, FP8_DTYPE,
                     f"x_fp8 dtype wrong [{ctx}]: got {ref_fp8.dtype}, expected {FP8_DTYPE}")
    self.assertEqual(ref_scale.dtype, cst_scale.dtype,
                     f"x_scale dtype mismatch [{ctx}]: ref={ref_scale.dtype} cst={cst_scale.dtype}")
    self.assertEqual(ref_scale.dtype, dtypes.float32,
                     f"x_scale dtype wrong [{ctx}]: got {ref_scale.dtype}, expected float32")
    self.assertEqual(ref_amax.dtype, cst_amax.dtype,
                     f"new_amax dtype mismatch [{ctx}]: ref={ref_amax.dtype} cst={cst_amax.dtype}")
    self.assertEqual(ref_amax.dtype, x.dtype,
                     f"new_amax dtype wrong [{ctx}]: got {ref_amax.dtype}, expected {x.dtype}")

    # numerical equivalence: fp8 fwd path is deterministic so we expect bit-identical results
    # compare fp8 outputs bitwise by casting back to bf16 (cast-back is lossy but deterministic)
    Tensor.realize(cst_fp8, cst_scale, cst_amax)
    Tensor.realize(ref_fp8, ref_scale, ref_amax)
    if Device.DEFAULT == "NULL": return None
    with Context(DEBUG=0):
      ref_bf16 = ref_fp8.cast(dtypes.bfloat16)
      cst_bf16 = cst_fp8.cast(dtypes.bfloat16)
      eq_mask = (ref_bf16 == cst_bf16)
      n_total = int(eq_mask.numel())
      n_eq = int(eq_mask.sum().item())
      if n_eq != n_total:
        n_mismatch = n_total - n_eq
        diff = (ref_bf16.cast(dtypes.float32) - cst_bf16.cast(dtypes.float32))
        max_abs_diff = float(diff.abs().max().item())
        ref_min = float(ref_bf16.cast(dtypes.float32).min().item())
        ref_max = float(ref_bf16.cast(dtypes.float32).max().item())
        cst_min = float(cst_bf16.cast(dtypes.float32).min().item())
        cst_max = float(cst_bf16.cast(dtypes.float32).max().item())
        self.fail(
          f"x_fp8 value mismatch [{ctx}]: "
          f"{n_mismatch}/{n_total} elements differ "
          f"({100.0 * n_mismatch / n_total:.3f}%), "
          f"max|ref-cst|={max_abs_diff} "
          f"ref range=[{ref_min}, {ref_max}] "
          f"cst range=[{cst_min}, {cst_max}]"
        )

      # bf16 has no python fmt so cast scalars to fp32 before .item()
      ref_scale_v = ref_scale.cast(dtypes.float32).item()
      cst_scale_v = cst_scale.cast(dtypes.float32).item()
      self.assertEqual(ref_scale_v, cst_scale_v,
                       f"x_scale value mismatch [{ctx}]: ref={ref_scale_v} cst={cst_scale_v} "
                       f"diff={cst_scale_v - ref_scale_v}")

      ref_amax_v = ref_amax.cast(dtypes.float32).item()
      cst_amax_v = cst_amax.cast(dtypes.float32).item()
      self.assertEqual(ref_amax_v, cst_amax_v,
                       f"new_amax value mismatch [{ctx}]: ref={ref_amax_v} cst={cst_amax_v} "
                       f"diff={cst_amax_v - ref_amax_v}")

  def test_fwd_no_amax_state_small(self):
    x = Tensor.randn(64, 128, dtype=dtypes.bfloat16)
    self._cmp_fwd(x, amax_state=None)

  def test_fwd_with_amax_state_small(self):
    x = Tensor.randn(64, 128, dtype=dtypes.bfloat16)
    amax = Tensor(2.5, dtype=dtypes.bfloat16)
    self._cmp_fwd(x, amax_state=amax)

  def test_fwd_contains_clamp_overflow(self):
    # values that would exceed fp8 range (448) to exercise clamp
    x = Tensor.randn(64, 128, dtype=dtypes.bfloat16) * 1000.0
    amax = Tensor(1.0, dtype=dtypes.bfloat16)  # tiny amax → large scale → clamp hits
    self._cmp_fwd(x, amax_state=amax)

  def test_fwd_swiglu_shape_single_device(self):
    # realistic SwiGLU output shape, single device
    x = Tensor.randn(1, 1024, 14336, dtype=dtypes.bfloat16)
    amax = Tensor(3.0, dtype=dtypes.bfloat16)
    self._cmp_fwd(x, amax_state=amax)


class TestFp8QuantForwardSharded(unittest.TestCase):
  """Forward equivalence with DP sharding matching profile.sh (8 devices, axis=0)."""

  def _cmp_fwd_sharded(self, x: Tensor, amax_state: Tensor | None):
    with Context(DEBUG=0):
      Tensor.realize(x) if amax_state is None else Tensor.realize(x, amax_state)
    x_sh, amax_sh = _shard_dp(x, amax_state) if amax_state is not None else (_shard_dp(x)[0], None)

    ref_fp8, ref_scale, ref_amax = ref_quantize_fp8(x_sh.clone(), amax_state=amax_sh.clone() if amax_sh is not None else None)
    cst_fp8, cst_scale, cst_amax = custom_quantize_fp8(x_sh.clone(), amax_state=amax_sh.clone() if amax_sh is not None else None)

    ctx = f"shape={tuple(x.shape)} dtype={x.dtype} sharded=8"

    self.assertEqual(ref_fp8.shape, cst_fp8.shape,
                     f"x_fp8 shape mismatch [{ctx}]: ref={tuple(ref_fp8.shape)} cst={tuple(cst_fp8.shape)}")
    self.assertEqual(ref_fp8.dtype, cst_fp8.dtype,
                     f"x_fp8 dtype mismatch [{ctx}]: ref={ref_fp8.dtype} cst={cst_fp8.dtype}")
    self.assertEqual(ref_fp8.uop.axis, cst_fp8.uop.axis,
                     f"x_fp8 shard axis mismatch [{ctx}]: ref={ref_fp8.uop.axis} cst={cst_fp8.uop.axis}")
    self.assertEqual(ref_fp8.uop.axis, 0,
                     f"x_fp8 shard axis wrong [{ctx}]: got {ref_fp8.uop.axis}, expected 0")

    Tensor.realize(cst_fp8, cst_scale, cst_amax)
    Tensor.realize(ref_fp8, ref_scale, ref_amax)
    with Context(DEBUG=0):
      ref_bf16 = ref_fp8.cast(dtypes.bfloat16)
      cst_bf16 = cst_fp8.cast(dtypes.bfloat16)
      eq_mask = (ref_bf16 == cst_bf16)
      n_total = int(eq_mask.numel())
      n_eq = int(eq_mask.sum().item())
      if n_eq != n_total:
        n_mismatch = n_total - n_eq
        diff = (ref_bf16.cast(dtypes.float32) - cst_bf16.cast(dtypes.float32))
        max_abs_diff = float(diff.abs().max().item())
        self.fail(
          f"x_fp8 value mismatch [{ctx}]: "
          f"{n_mismatch}/{n_total} elements differ "
          f"({100.0 * n_mismatch / n_total:.3f}%), "
          f"max|ref-cst|={max_abs_diff}"
        )

  def test_fwd_sharded_small(self):
    x = Tensor.randn(8, 128, 256, dtype=dtypes.bfloat16)
    amax = Tensor(2.0, dtype=dtypes.bfloat16)
    self._cmp_fwd_sharded(x, amax_state=amax)

  def test_fwd_sharded_swiglu_shape(self):
    # matches profile.sh DP=8 BS=8 SEQLEN=8192 hidden=14336 per-device swiglu shape
    x = Tensor.randn(8, 8192, 14336, dtype=dtypes.bfloat16)
    amax = Tensor(3.0, dtype=dtypes.bfloat16)
    self._cmp_fwd_sharded(x, amax_state=amax)


class TestFp8QuantBackwardSTE(unittest.TestCase):
  """
  The STE backward for quantize_fp8 passes gradient through as if clamp+cast were identity,
  multiplied by `scale` (= 448/(amax_state+eps)). This test builds a scalar loss and compares
  the input gradient between the ref impl and the custom impl.
  """

  def _cmp_bwd(self, x_init: Tensor, amax_state: Tensor | None):
    with Context(DEBUG=0):
      Tensor.realize(x_init) if amax_state is None else Tensor.realize(x_init, amax_state)
    x_ref = x_init.clone().requires_grad_(True)
    x_cst = x_init.clone().requires_grad_(True)

    ref_fp8, _, _ = ref_quantize_fp8(x_ref, amax_state=amax_state)
    cst_fp8, _, _ = custom_quantize_fp8(x_cst, amax_state=amax_state)

    # scalar loss that depends on fp8 values (cast back to bf16 so autodiff has a dtype to work in)
    ref_loss = ref_fp8.cast(dtypes.bfloat16).sum()
    cst_loss = cst_fp8.cast(dtypes.bfloat16).sum()

    (ref_grad,) = ref_loss.gradient(x_ref)
    (cst_grad,) = cst_loss.gradient(x_cst)

    ctx = f"shape={tuple(x_init.shape)} dtype={x_init.dtype} amax_state={'None' if amax_state is None else amax_state.cast(dtypes.float32).item()}"

    self.assertEqual(ref_grad.shape, cst_grad.shape,
                     f"grad shape mismatch [{ctx}]: ref={tuple(ref_grad.shape)} cst={tuple(cst_grad.shape)}")
    self.assertEqual(ref_grad.dtype, cst_grad.dtype,
                     f"grad dtype mismatch [{ctx}]: ref={ref_grad.dtype} cst={cst_grad.dtype}")

    Tensor.realize(ref_grad, cst_grad)
    with Context(DEBUG=0):
      eq_mask = (ref_grad == cst_grad)
      n_total = int(eq_mask.numel())
      n_eq = int(eq_mask.sum().item())
      if n_eq != n_total:
        n_mismatch = n_total - n_eq
        diff = (ref_grad.cast(dtypes.float32) - cst_grad.cast(dtypes.float32))
        max_abs_diff = float(diff.abs().max().item())
        self.fail(
          f"grad value mismatch [{ctx}]: "
          f"{n_mismatch}/{n_total} elements differ "
          f"({100.0 * n_mismatch / n_total:.3f}%), "
          f"max|ref-cst|={max_abs_diff}"
        )

  def test_bwd_no_amax_state(self):
    x = Tensor.randn(64, 128, dtype=dtypes.bfloat16)
    self._cmp_bwd(x, amax_state=None)

  def test_bwd_with_amax_state(self):
    x = Tensor.randn(64, 128, dtype=dtypes.bfloat16)
    amax = Tensor(2.5, dtype=dtypes.bfloat16)
    self._cmp_bwd(x, amax_state=amax)

  def test_bwd_clamp_zeros_outside_range(self):
    """
    flat_llama's STE: x_clamped = x_scaled + (clamp(x_scaled).detach() - x_scaled.detach())
    which algebraically simplifies to: forward = clamp(x_scaled), backward = d/dx(x_scaled) = scale.
    So the STE passes `scale` through everywhere, ignoring the clamp boundary. That's the "straight-through"
    semantics — grad does NOT zero at the clamp. Verify both impls agree on this.
    """
    x = Tensor.randn(64, 128, dtype=dtypes.bfloat16) * 10.0
    amax = Tensor(0.01, dtype=dtypes.bfloat16)  # tiny amax → huge scale → everything clamps
    self._cmp_bwd(x, amax_state=amax)


class TestFp8QuantBackwardSharded(unittest.TestCase):
  """Backward equivalence with DP sharding."""

  def test_bwd_sharded(self):
    x = Tensor.randn(8, 128, 256, dtype=dtypes.bfloat16)
    amax = Tensor(2.0, dtype=dtypes.bfloat16)
    with Context(DEBUG=0):
      Tensor.realize(x, amax)
    x_sh, amax_sh = _shard_dp(x, amax)
    x_ref = x_sh.clone().requires_grad_(True)
    x_cst = x_sh.clone().requires_grad_(True)

    ref_fp8, _, _ = ref_quantize_fp8(x_ref, amax_state=amax_sh.clone())
    cst_fp8, _, _ = custom_quantize_fp8(x_cst, amax_state=amax_sh.clone())

    ref_loss = ref_fp8.cast(dtypes.bfloat16).sum()
    cst_loss = cst_fp8.cast(dtypes.bfloat16).sum()

    (ref_grad,) = ref_loss.gradient(x_ref)
    (cst_grad,) = cst_loss.gradient(x_cst)

    ctx = f"shape={tuple(x.shape)} sharded=8"
    self.assertEqual(ref_grad.shape, cst_grad.shape,
                     f"grad shape mismatch [{ctx}]: ref={tuple(ref_grad.shape)} cst={tuple(cst_grad.shape)}")
    self.assertEqual(ref_grad.dtype, cst_grad.dtype,
                     f"grad dtype mismatch [{ctx}]: ref={ref_grad.dtype} cst={cst_grad.dtype}")
    self.assertEqual(ref_grad.uop.axis, cst_grad.uop.axis,
                     f"grad shard axis mismatch [{ctx}]: ref={ref_grad.uop.axis} cst={cst_grad.uop.axis}")

    Tensor.realize(ref_grad, cst_grad)
    with Context(DEBUG=0):
      eq_mask = (ref_grad == cst_grad)
      n_total = int(eq_mask.numel())
      n_eq = int(eq_mask.sum().item())
      if n_eq != n_total:
        n_mismatch = n_total - n_eq
        self.fail(
          f"grad value mismatch [{ctx}]: "
          f"{n_mismatch}/{n_total} elements differ "
          f"({100.0 * n_mismatch / n_total:.3f}%)"
        )


if __name__ == "__main__":
  unittest.main(verbosity=2)
