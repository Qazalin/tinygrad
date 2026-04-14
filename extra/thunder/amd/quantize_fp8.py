import functools, pathlib

from tinygrad import Device, Tensor, dtypes, getenv
from tinygrad.helpers import prod
from tinygrad.renderer import Estimates
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
from tinygrad.uop.ops import KernelInfo, Ops, UOp

FP8_MAX = 448.0
TILE_ELEMS = 16 * 32
CAST_ELEMS_PER_WG = getenv("HK_FP8_CAST_TILE", 2048)

@functools.cache
def custom_quantize_fp8_amax(amax:UOp, x:UOp, device:str, arch:str, n:int, grid:int) -> UOp:
  numel = prod(x.shape)
  assert numel == n
  code = (pathlib.Path(__file__).parent / "quantize_fp8_amax.cpp").read_text()
  compile_args = [
    f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}",
    "-std=c++20",
    "-DKITTENS_CDNA4",
    "-ffast-math",
    "-DHIP_ENABLE_WARP_SYNC_BUILTINS",
    f"-DPARAM_N={n}",
    f"-DPARAM_GRID={grid}",
  ]
  lidx, gidx = UOp.special(64, "lidx0"), UOp.special(grid, "gidx0")
  sink = UOp.sink(amax.base, x.base, lidx, gidx, arg=KernelInfo(name="custom_quantize_fp8_amax", estimates=Estimates()))
  lib = HIPCCCompiler(arch, compile_args).compile_cached(code)
  return UOp(Ops.PROGRAM, src=(
    sink,
    UOp(Ops.DEVICE, arg=device),
    UOp(Ops.LINEAR, src=(*sink.src, sink)),
    UOp(Ops.SOURCE, arg=code),
    UOp(Ops.BINARY, arg=lib)
  ))

@functools.cache
def custom_quantize_fp8_cast(x_fp8:UOp, inv_scale:UOp, x:UOp, amax:UOp, device:str, arch:str) -> UOp:
  numel = prod(x.shape)
  assert numel % CAST_ELEMS_PER_WG == 0, f"n_elems={numel} must be divisible by {CAST_ELEMS_PER_WG}"
  code = (pathlib.Path(__file__).parent / "quantize_fp8_cast.cpp").read_text()
  compile_args = [
    f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}",
    "-std=c++20",
    "-DKITTENS_CDNA4",
    "-DHIP_ENABLE_WARP_SYNC_BUILTINS",
    f"-DPARAM_N={numel}",
    f"-DPARAM_TILE={CAST_ELEMS_PER_WG}",
  ]
  threads, blocks = 64, numel // CAST_ELEMS_PER_WG
  lidx, gidx = UOp.special(threads, "lidx0"), UOp.special(blocks, "gidx0")
  sink = UOp.sink(x_fp8.base, inv_scale.base, x.base, amax.base, lidx, gidx, arg=KernelInfo(name="custom_quantize_fp8_cast", estimates=Estimates()))
  lib = HIPCCCompiler(arch, compile_args).compile_cached(code)
  return UOp(Ops.PROGRAM, src=(
    sink,
    UOp(Ops.DEVICE, arg=device),
    UOp(Ops.LINEAR, src=(*sink.src, sink)),
    UOp(Ops.SOURCE, arg=code),
    UOp(Ops.BINARY, arg=lib)
  ))

def amax_grad(gradient:UOp, kernel:UOp):
  return (None, gradient)

def cast_grad(gradient:UOp, kernel:UOp):
  _, _, x_uop, amax_uop = kernel.src[1:]
  grad = Tensor(gradient, device=gradient.device)
  amax = Tensor(amax_uop, device=amax_uop.device)
  scale = (FP8_MAX / (amax.cast(dtypes.bfloat16) + 1e-8)).cast(dtypes.bfloat16)
  return (None, None, (grad * scale).uop, None)

def _custom_amax_impl(x:Tensor) -> Tensor:
  assert x.dtype == dtypes.bfloat16, f"expected bfloat16 input, got {x.dtype}"

  single_device = x.device[0] if isinstance(x.device, tuple) else x.device
  dname = single_device.split(":")[0]
  arch = Device[single_device].renderer.target.arch
  n = prod(x.shape)
  assert n % TILE_ELEMS == 0, f"unsupported shape {n}"

  num_tiles = n // TILE_ELEMS
  global_size = min(getenv("HK_FP8_AMAX_GRID", 16384), num_tiles)

  # Must be zero-initialized because kernel atomically maxes into it.
  amax = Tensor.zeros(1, dtype=dtypes.float32, device=x.device).reshape(())
  amax, _ = Tensor.custom_kernel(
    amax,
    x,
    fxn=functools.partial(custom_quantize_fp8_amax, device=dname, arch=arch, n=n, grid=global_size),
    grad_fxn=amax_grad
  )
  return amax.squeeze().cast(x.dtype)

@functools.cache
def _custom_amax_fxn(x_p:UOp, device:str|tuple[str, ...]):
  x = Tensor(x_p, device=device)
  inner = Tensor(x.uop.src[0]) if x.uop.op is Ops.MULTI else x
  return (_custom_amax_impl(inner),)

def custom_amax(x:Tensor) -> Tensor:
  if isinstance(x.device, tuple):
    param = x.as_param(0)
    fxn = _custom_amax_fxn(param.uop, x.device)
    return Tensor(fxn[0].uop.call(x.uop).gettuple(0))
  return _custom_amax_impl(x)

def custom_quantize_fp8(x:Tensor, amax_state:Tensor|None=None) -> tuple[Tensor, Tensor, Tensor]:
  assert isinstance(x.device, str), "multi todo"
  assert x.dtype == dtypes.bfloat16, f"expected bfloat16 input, got {x.dtype}"

  dname = x.device.split(":")[0]
  arch = Device[x.device].renderer.target.arch
  n = prod(x.shape)
  assert n % TILE_ELEMS == 0, f"unsupported shape {n}"

  num_tiles = n // TILE_ELEMS
  global_size = min(getenv("HK_FP8_AMAX_GRID", 16384), num_tiles)

  # Must be zero-initialized because kernel 1 atomically maxes into it.
  amax = Tensor.zeros(1, dtype=dtypes.float32, device=x.device).reshape(())
  amax, _ = Tensor.custom_kernel(
    amax,
    x,
    fxn=functools.partial(custom_quantize_fp8_amax, device=dname, arch=arch, n=n, grid=global_size),
    grad_fxn=amax_grad
  )

  out_fp8 = Tensor.invalid(*x.shape, dtype=dtypes.fp8e4m3, device=x.device)
  inv_scale = Tensor.invalid(1, dtype=dtypes.float32, device=x.device)

  amax_input = amax_state.cast(dtypes.float32) if amax_state is not None else amax
  out_fp8, inv_scale, _, _ = Tensor.custom_kernel(
    out_fp8,
    inv_scale,
    x,
    amax_input,
    fxn=functools.partial(custom_quantize_fp8_cast, device=dname, arch=arch),
    grad_fxn=cast_grad
  )
  return out_fp8, inv_scale.squeeze(), amax.squeeze().cast(x.dtype)
