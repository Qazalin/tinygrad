import atexit, functools
from pathlib import Path

from tinygrad import Device, Tensor, dtypes
from tinygrad.helpers import ContextVar
from tinygrad.renderer import Estimates
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
from tinygrad.uop.ops import KernelInfo, Ops, UOp

FP8_DTYPE = dtypes.fp8e4m3
FP8_MAX = 448.0
ELEMS_PER_TILE = 16 * 32
CAST_TILE = 2048
FUSED_CAST_TILE = 16384
FUSED_CAST_BLOCK = 256

HK_FP8_QUANTIZE = ContextVar("HK_FP8_QUANTIZE", 0)
HK_FP8_CAST_AMAX_FUSED = ContextVar("HK_FP8_CAST_AMAX_FUSED", 0)
HK_FP8_AMAX_BLOCKS = ContextVar("HK_FP8_AMAX_BLOCKS", 8192)

_THIS_DIR = Path(__file__).parent
_KERNEL_DIR = _THIS_DIR / "fp8_quant_kernels"
_KITTENS_INCLUDE = _THIS_DIR / "include"

_COUNTERS = {"used": 0, "used_no_amax_state": 0}
def _hk_fp8_quantize_report():
  print(f'hk_fp8_quantize: {_COUNTERS["used"]} used ({_COUNTERS["used_no_amax_state"]} with no amax_state)')
atexit.register(_hk_fp8_quantize_report)


def _local_abs_max_input(x: Tensor) -> Tensor:
  return Tensor(x.uop.src[0]) if x.uop.op is Ops.MULTI else x


def ref_quantize_fp8(x: Tensor, amax_state: Tensor | None = None):
  new_amax = (_local_abs_max_input(x).abs().max() if isinstance(x.device, tuple) else x.abs().max()).cast(x.dtype).detach()
  scale = FP8_MAX / ((amax_state if amax_state is not None else new_amax) + 1e-8)
  x_scaled = x * scale
  x_clamped = x_scaled + (x_scaled.detach().clamp(-FP8_MAX, FP8_MAX) - x_scaled.detach())
  return x_clamped.cast(FP8_DTYPE), scale.float().reciprocal(), new_amax


def _compile_kitten(name: str, n_elems: int, extra_defs: dict[str, int] | None = None, fast_math: bool = True, use_kittens: bool = True):
  src = (_KERNEL_DIR / f"{name}.cpp").read_text()
  flags = ["-std=c++20", f"-DPARAM_N={n_elems}"]
  if extra_defs is not None: flags += [f"-D{k}={v}" for k, v in extra_defs.items()]
  if use_kittens: flags += [f"-I{_KITTENS_INCLUDE.as_posix()}", "-DKITTENS_CDNA4", "-DHIP_ENABLE_WARP_SYNC_BUILTINS"]
  if fast_math: flags += ["-ffast-math"]
  lib = HIPCCCompiler(Device[Device.DEFAULT].renderer.target.arch, flags).compile_cached(src)
  return src, lib


@functools.lru_cache(None)
def _build_amax_runner(n_elems: int):
  src, lib = _compile_kitten("kitten_amax", n_elems)
  num_tiles = n_elems // ELEMS_PER_TILE
  est = Estimates(ops=2 * n_elems, lds=n_elems * 2 + 4, mem=n_elems * 2 + 4)
  name = f"kitten_amax_{n_elems}"

  def runner(amax_f32: UOp, x_bf16: UOp):
    sink = UOp.sink(UOp.special(num_tiles, "gidx0"), UOp.special(64, "lidx0"), amax_f32, x_bf16,
                    arg=KernelInfo(name=name, estimates=est))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                                 UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=lib)))

  return runner


@functools.lru_cache(None)
def _build_amax_fused_runner(n_elems: int, num_blocks: int):
  src, lib = _compile_kitten("kitten_amax_fused", n_elems, extra_defs={"PARAM_GRID": num_blocks})
  est = Estimates(ops=2 * n_elems, lds=n_elems * 2 + 4, mem=n_elems * 2 + 4)
  name = f"kitten_amax_fused_{n_elems}_{num_blocks}"

  def runner(amax_f32: UOp, x_bf16: UOp):
    sink = UOp.sink(UOp.special(num_blocks, "gidx0"), UOp.special(64, "lidx0"), amax_f32, x_bf16,
                    arg=KernelInfo(name=name, estimates=est))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                                 UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=lib)))

  return runner


@functools.lru_cache(None)
def _build_cast_runner(n_elems: int, tile_elems: int = CAST_TILE):
  src, lib = _compile_kitten("kitten_cast", n_elems, extra_defs={"PARAM_TILE": tile_elems}, fast_math=False)
  num_tiles = n_elems // tile_elems
  est = Estimates(ops=2 * n_elems, lds=n_elems * 2 + 4 + n_elems + 4, mem=n_elems * 2 + 4 + n_elems + 4)
  name = f"kitten_cast_{n_elems}"

  def runner(out_fp8: UOp, inv_scale: UOp, x_bf16: UOp, amax_f32: UOp):
    sink = UOp.sink(UOp.special(num_tiles, "gidx0"), UOp.special(64, "lidx0"), out_fp8, inv_scale, x_bf16, amax_f32,
                    arg=KernelInfo(name=name, estimates=est))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                                 UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=lib)))

  return runner


@functools.lru_cache(None)
def _build_cast_amax_fused_runner(n_elems: int, tile_elems: int = FUSED_CAST_TILE):
  src, lib = _compile_kitten("kitten_cast_amax_fused", n_elems,
                             extra_defs={"PARAM_TILE": tile_elems}, fast_math=False)
  num_tiles = n_elems // tile_elems
  est = Estimates(ops=4 * n_elems, lds=n_elems * 2 + n_elems + 8, mem=n_elems * 2 + n_elems + 8)
  name = f"kitten_cast_amax_fused_{n_elems}"

  def runner(out_fp8: UOp, inv_scale: UOp, out_amax: UOp, x_bf16: UOp, amax_f32: UOp):
    sink = UOp.sink(UOp.special(num_tiles, "gidx0"), UOp.special(64, "lidx0"), out_fp8, inv_scale, out_amax, x_bf16, amax_f32,
                    arg=KernelInfo(name=name, estimates=est))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                                 UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=lib)))

  return runner


@functools.lru_cache(None)
def _build_cast_amax_partial_runner(n_elems: int, tile_elems: int = FUSED_CAST_TILE, block_threads: int = FUSED_CAST_BLOCK):
  src, lib = _compile_kitten("kitten_cast_amax_partial", n_elems,
                             extra_defs={"PARAM_TILE": tile_elems, "PARAM_BLOCK_THREADS": block_threads}, fast_math=False)
  num_tiles = n_elems // tile_elems
  est = Estimates(ops=4 * n_elems, lds=n_elems * 2 + n_elems + num_tiles * 4 + 8, mem=n_elems * 2 + n_elems + num_tiles * 4 + 8)
  name = f"kitten_cast_amax_partial_{n_elems}"

  def runner(out_fp8: UOp, inv_scale: UOp, partials_out: UOp, x_bf16: UOp, amax_f32: UOp):
    sink = UOp.sink(UOp.special(num_tiles, "gidx0"), UOp.special(block_threads, "lidx0"), out_fp8, inv_scale, partials_out, x_bf16, amax_f32,
                    arg=KernelInfo(name=name, estimates=est))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                                 UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=lib)))

  return runner, num_tiles


@functools.lru_cache(None)
def _build_amax_reduce_runner(num_partials_padded: int, num_partials_valid: int):
  src, lib = _compile_kitten("kitten_amax_reduce", num_partials_padded,
                             extra_defs={"PARAM_VALID": num_partials_valid}, use_kittens=False)
  est = Estimates(ops=2 * num_partials_valid, lds=num_partials_padded * 4 + 4, mem=num_partials_padded * 4 + 4)
  name = f"kitten_amax_reduce_{num_partials_valid}"

  def runner(amax_f32: UOp, partials_f32: UOp):
    sink = UOp.sink(UOp.special(1, "gidx0"), UOp.special(256, "lidx0"), amax_f32, partials_f32,
                    arg=KernelInfo(name=name, estimates=est))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                                 UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=lib)))

  return runner


def _sharded_empty(shape, ref: Tensor, dtype=None, axis=None):
  dtype = dtype or ref.dtype
  if not isinstance(ref.device, tuple): return Tensor.invalid(*shape, dtype=dtype, device=ref.device)
  shard_axis = ref.uop.axis if axis is None else axis
  per_dev = tuple(s // len(ref.device) if i == shard_axis else s for i, s in enumerate(shape))
  return Tensor(Tensor.invalid(*per_dev, dtype=dtype, device=ref.device).uop.multi(shard_axis), dtype=dtype, device=ref.device)


def _zero_f32(out: UOp) -> UOp:
  i = UOp.range(out.size, 0)
  return out.flatten()[i].store(0).end(i).sink(arg=KernelInfo(name="zero", estimates=Estimates(ops=0, lds=4, mem=4)))


def _cast_grad(gradient: UOp, kernel: UOp):
  _, _, _, x_uop, amax_uop = kernel.src[1:]
  grad = Tensor(gradient, device=gradient.device)
  amax = Tensor(amax_uop, device=amax_uop.device)
  scale = (FP8_MAX / (amax.cast(dtypes.bfloat16) + 1e-8)).cast(dtypes.bfloat16)
  return (None, None, None, (grad * scale).uop, None)


def _cast_only_grad(gradient: UOp, kernel: UOp):
  _, _, x_uop, amax_uop = kernel.src[1:]
  grad = Tensor(gradient, device=gradient.device)
  amax = Tensor(amax_uop, device=amax_uop.device)
  scale = (FP8_MAX / (amax.cast(dtypes.bfloat16) + 1e-8)).cast(dtypes.bfloat16)
  return (None, None, (grad * scale).uop, None)


def _amax_grad(gradient: UOp, kernel: UOp):
  return (None, gradient)


def _amax_reduce_grad(gradient: UOp, kernel: UOp):
  return (None, None)


def custom_quantize_fp8(x: Tensor, amax_state: Tensor | None = None):
  if HK_FP8_QUANTIZE.value != 1: return ref_quantize_fp8(x, amax_state)
  if Device.DEFAULT != "AMD": return ref_quantize_fp8(x, amax_state)

  n_elems = x.numel()
  is_multi = isinstance(x.device, tuple)
  is_sharded = is_multi and x.uop.axis is not None
  n_local = n_elems // len(x.device) if is_sharded else n_elems

  if n_local % ELEMS_PER_TILE != 0: return ref_quantize_fp8(x, amax_state)
  tile_elems = FUSED_CAST_TILE
  if n_local % tile_elems != 0:
    for cand in (16384, 8192, 4096, 2048, 1024, 512):
      if cand <= n_local and n_local % cand == 0:
        tile_elems = cand
        break
  if n_local % tile_elems != 0: return ref_quantize_fp8(x, amax_state)

  out_fp8 = _sharded_empty(x.shape, x, dtype=FP8_DTYPE) if is_sharded else Tensor.invalid(*x.shape, dtype=FP8_DTYPE, device=x.device)
  kernel_inv_scale = Tensor.invalid(1, dtype=dtypes.float32, device=x.device)

  if amax_state is None:
    if n_local % CAST_TILE != 0: return ref_quantize_fp8(x, amax_state)
    amax_f32 = Tensor.invalid(1, dtype=dtypes.float32, device=x.device).custom_kernel(fxn=_zero_f32)[0]
    x_for_amax = _local_abs_max_input(x) if is_multi else x
    num_blocks = min(HK_FP8_AMAX_BLOCKS.value, n_local // ELEMS_PER_TILE)
    amax_f32, _ = Tensor.custom_kernel(amax_f32, x_for_amax,
                                       fxn=_build_amax_fused_runner(n_local, num_blocks), grad_fxn=_amax_grad)
    amax_input = amax_f32
    out_fp8, kernel_inv_scale, _, _ = Tensor.custom_kernel(out_fp8, kernel_inv_scale, x, amax_input,
                                                           fxn=_build_cast_runner(n_local), grad_fxn=_cast_only_grad)
    _COUNTERS["used_no_amax_state"] += 1
  else:
    amax_input = amax_state.cast(dtypes.float32)
    if is_multi and not isinstance(amax_input.device, tuple): amax_input = amax_input.shard(x.device, axis=None)
    if HK_FP8_CAST_AMAX_FUSED.value:
      amax_f32 = Tensor.invalid(1, dtype=dtypes.float32, device=x.device).custom_kernel(fxn=_zero_f32)[0]
      out_fp8, kernel_inv_scale, amax_f32, _, _ = Tensor.custom_kernel(out_fp8, kernel_inv_scale, amax_f32, x, amax_input,
                                                                       fxn=_build_cast_amax_fused_runner(n_local, tile_elems=tile_elems),
                                                                       grad_fxn=_cast_grad)
    else:
      fxn_partial, num_tiles = _build_cast_amax_partial_runner(n_local, tile_elems=tile_elems)
      num_partials = ((num_tiles + 255) // 256) * 256
      partials = Tensor.zeros(num_partials, dtype=dtypes.float32, device=x.device)
      out_fp8, kernel_inv_scale, partials, _, _ = Tensor.custom_kernel(out_fp8, kernel_inv_scale, partials, x, amax_input,
                                                                        fxn=fxn_partial, grad_fxn=_cast_grad)
      amax_f32 = Tensor.invalid(1, dtype=dtypes.float32, device=x.device)
      amax_f32, _ = Tensor.custom_kernel(amax_f32, partials,
                                         fxn=_build_amax_reduce_runner(num_partials, num_tiles), grad_fxn=_amax_reduce_grad)

  new_amax = amax_f32.squeeze().cast(x.dtype).detach()
  _COUNTERS["used"] += 1
  scale_src = amax_state if amax_state is not None else new_amax
  inv_scale = (FP8_MAX / (scale_src + 1e-8)).float().reciprocal()
  return out_fp8, inv_scale, new_amax
