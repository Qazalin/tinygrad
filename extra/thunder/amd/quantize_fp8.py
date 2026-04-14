import functools, pathlib

from tinygrad import Device, Tensor, dtypes, getenv
from tinygrad.helpers import prod
from tinygrad.renderer import Estimates
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
from tinygrad.uop.ops import KernelInfo, Ops, UOp

FP8_MAX = 448.0
TILE_ELEMS = 16 * 32

@functools.cache
def custom_quantize_fp8_amax_partials(partials:UOp, x:UOp, device:str, arch:str, n:int, grid:int) -> UOp:
  numel = prod(x.shape)
  assert numel == n
  code = (pathlib.Path(__file__).parent / "quantize_fp8_amax.cpp").read_text()
  compile_args = [f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math", "-DHIP_ENABLE_WARP_SYNC_BUILTINS", f"-DQFP8_N={n}", f"-DQFP8_GRID={grid}"]
  lidx, gidx = UOp.special(64, "lidx0"), UOp.special(grid, "gidx0")
  sink = UOp.sink(partials.base, x.base, lidx, gidx, arg=KernelInfo(name="custom_quantize_fp8_amax_partials", estimates=Estimates()))
  lib = HIPCCCompiler(arch, compile_args).compile_cached(code)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=device), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=code), UOp(Ops.BINARY, arg=lib)))

@functools.cache
def custom_quantize_fp8_amax_reduce(amax:UOp, partials:UOp, device:str, arch:str, num_partials:int) -> UOp:
  code = (pathlib.Path(__file__).parent / "quantize_fp8_reduce.cpp").read_text()
  compile_args = ["-std=c++20", "-ffast-math", f"-DNUM_PARTIALS={num_partials}"]
  lidx, gidx = UOp.special(256, "lidx0"), UOp.special(1, "gidx0")
  sink = UOp.sink(amax.base, partials.base, lidx, gidx, arg=KernelInfo(name="custom_quantize_fp8_amax_reduce", estimates=Estimates()))
  lib = HIPCCCompiler(arch, compile_args).compile_cached(code)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=device), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=code), UOp(Ops.BINARY, arg=lib)))

@functools.cache
def custom_quantize_fp8_cast(x_fp8:UOp, inv_scale:UOp, x:UOp, amax:UOp, device:str, arch:str) -> UOp:
  numel = prod(x.shape)
  code = (pathlib.Path(__file__).parent / "quantize_fp8_cast.cpp").read_text()
  compile_args = [f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math", f"-DQFP8_N={numel}", f"-DQFP8_FP8_MAX={FP8_MAX}f"]
  threads, blocks = 256, max(1, (numel + 255) // 256)
  lidx, gidx = UOp.special(threads, "lidx0"), UOp.special(blocks, "gidx0")
  sink = UOp.sink(x_fp8.base, inv_scale.base, x.base, amax.base, lidx, gidx, arg=KernelInfo(name="custom_quantize_fp8_cast", estimates=Estimates()))
  lib = HIPCCCompiler(arch, compile_args).compile_cached(code)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=device), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=code), UOp(Ops.BINARY, arg=lib)))

def custom_quantize_fp8(x:Tensor, amax_state:Tensor|None=None) -> tuple[Tensor, Tensor, Tensor]:
  assert isinstance(x.device, str), "multi todo"
  assert amax_state is None, "delayed scaling todo"
  assert x.dtype == dtypes.bfloat16, f"expected bfloat16 input, got {x.dtype}"

  amax = Tensor.invalid(1, dtype=dtypes.float, device=x.device).reshape(())

  dname = x.device.split(":")[0]
  arch = Device[x.device].renderer.target.arch
  n = prod(x.shape)
  assert n % TILE_ELEMS == 0, f"unsupported shape {n}"
  num_tiles = n // TILE_ELEMS
  global_size = min(getenv("HK_QFP8_GLOBALS", 131072), num_tiles)
  partials = Tensor.invalid(global_size, dtype=dtypes.float, device=x.device)
  partials = Tensor.custom_kernel(partials, x, fxn=functools.partial(custom_quantize_fp8_amax_partials, device=dname, arch=arch, n=n, grid=global_size))[0]
  amax = Tensor.custom_kernel(amax, partials, fxn=functools.partial(custom_quantize_fp8_amax_reduce, device=dname, arch=arch, num_partials=global_size))[0]

  new_amax = amax.cast(x.dtype).detach()
  scale = FP8_MAX / (new_amax + 1e-8)
  x_scaled = x * scale
  x_clamped = x_scaled + (x_scaled.detach().clip(-FP8_MAX, FP8_MAX) - x_scaled.detach())
  x_fp8 = x_clamped.cast(dtypes.fp8e4m3)
  inv_scale = scale.float().reciprocal()
  return x_fp8, inv_scale, new_amax
