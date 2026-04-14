import functools, pathlib

from tinygrad import Device, Tensor, dtypes, getenv
from tinygrad.helpers import prod
from tinygrad.renderer import Estimates
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
from tinygrad.uop.ops import KernelInfo, Ops, UOp

FP8_MAX = 448.0

@functools.cache
def custom_quantize_fp8_amax(amax:UOp, x:UOp, device:str, arch:str) -> UOp:
  numel = prod(x.shape)
  code = (pathlib.Path(__file__).parent / "quantize_fp8_amax.cpp").read_text()
  compile_args = [f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math"]
  lidx, gidx = UOp.special(1, "lidx0"), UOp.special(1, "gidx0")
  sink = UOp.sink(amax.base, x.base, lidx, gidx, arg=KernelInfo(name="custom_quantize_fp8_amax", estimates=Estimates()))
  lib = HIPCCCompiler(arch, compile_args).compile_cached(code)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=device), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=code), UOp(Ops.BINARY, arg=lib)))

@functools.cache
def custom_quantize_fp8_cast(x_fp8:UOp, inv_scale:UOp, x:UOp, amax:UOp, device:str, arch:str) -> UOp:
  numel = prod(x.shape)
  code = (pathlib.Path(__file__).parent / "quantize_fp8_cast.cpp").read_text()
  compile_args = [f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math"]
  lidx, gidx = UOp.special(1, "lidx0"), UOp.special(1, "gidx0")
  sink = UOp.sink(x_fp8.base, inv_scale.base, x.base, amax.base, lidx, gidx, arg=KernelInfo(name="custom_quantize_fp8_cast", estimates=Estimates()))
  lib = HIPCCCompiler(arch, compile_args).compile_cached(code)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=device), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=code), UOp(Ops.BINARY, arg=lib)))

def custom_quantize_fp8(x:Tensor, amax_state:Tensor|None=None) -> tuple[Tensor, Tensor, Tensor]:
  assert isinstance(x.device, str), "multi todo"
  assert amax_state is None, "delayed scaling todo"
  assert x.dtype == dtypes.bfloat16, f"expected bfloat16 input, got {x.dtype}"

  x_fp8 = Tensor.invalid(*x.shape, dtype=dtypes.fp8e4m3, device=x.device)
  inv_scale = Tensor.invalid(1, dtype=dtypes.float, device=x.device).reshape(())
  amax = Tensor.invalid(1, dtype=dtypes.float, device=x.device).reshape(())

  dname = x.device.split(":")[0]
  arch = Device[x.device].renderer.target.arch
  amax = Tensor.custom_kernel(amax, x, fxn=functools.partial(custom_quantize_fp8_amax, device=dname, arch=arch))[0]
  x_fp8, inv_scale = Tensor.custom_kernel(x_fp8, inv_scale, x, amax, fxn=functools.partial(custom_quantize_fp8_cast, device=dname, arch=arch))[:2]
  new_amax = amax.cast(x.dtype).detach()
  return x_fp8, inv_scale, new_amax
