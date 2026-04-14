from tinygrad import Tensor

def custom_quantize_fp8(x:Tensor, amax_state:Tensor|None=None) -> None:
  assert isinstance(x.device, str), "multi todo"
  assert amax_state is None, "todo"
