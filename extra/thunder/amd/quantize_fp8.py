from tinygrad import Tensor, dtypes

def custom_quantize_fp8(x:Tensor, amax_state:Tensor|None=None) -> None:
  assert isinstance(x.device, str), "multi todo"
  assert amax_state is None, "todo"
  x_fp8 = Tensor.invalid(*x.shape, dtype=dtypes.fp8e4m3, device=x.device)
  inv_scale = Tensor.invalid(1, dtype=dtypes.float, device=x.device).reshape(())
  new_amax = Tensor.invalid(1, dtype=x.dtype, device=x.device).reshape(())
  return x_fp8, inv_scale, new_amax
