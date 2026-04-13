from tinygrad import Tensor, dtypes

ELEMS_PER_WG = 64 * 128
TILE_R, TILE_C = 16, 32
ELEMS_PER_TILE = TILE_R * TILE_C  # 512
CAST_ELEMS_PER_WG = 2048
FUSED_CAST_ELEMS_PER_WG = 16384
FUSED_CAST_THREADS = 128

def custom_quantize_fp8(x:Tensor, amax_state:Tensor|None=None) -> Tensor:
  n_elems = 1
  for s in x.shape: n_elems *= s
  assert n_elems % ELEMS_PER_TILE == 0, f"n_elems={n_elems} must be divisible by {ELEMS_PER_TILE}"
  is_multi = isinstance(x.device, tuple)
  is_sharded = is_multi and x.uop.axis is not None
  n_local = n_elems // len(x.device) if is_sharded else n_elems
  single_device = x.device[0] if is_multi else x.device
  amax_f32 = Tensor.invalid(1, dtype=dtypes.float32, device=x.device)
  return out_fp8, inv_scale.squeeze(), amax_f32.squeeze().cast(x.dtype)
