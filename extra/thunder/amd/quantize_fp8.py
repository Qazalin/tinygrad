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
  compile_args = [f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math", f"-DNUMEL={numel}"]
  threads, blocks = 256, min(65535, max(1, (numel + 255) // 256))
  lidx, gidx = UOp.special(threads, "lidx0"), UOp.special(blocks, "gidx0")
  estimates = Estimates(ops=numel, mem=numel*x.dtype.itemsize + amax.dtype.itemsize)
  sink = UOp.sink(amax.base, x.base, lidx, gidx, arg=KernelInfo(name="custom_quantize_fp8_amax", estimates=estimates))
  lib = HIPCCCompiler(arch, compile_args).compile_cached(code)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=device), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=code), UOp(Ops.BINARY, arg=lib)))

@functools.cache
def custom_quantize_fp8_amax_pass1(partial_amax:UOp, x:UOp, device:str, arch:str) -> UOp:
  numel = prod(x.shape)
  code = (pathlib.Path(__file__).parent / "quantize_fp8_amax_pass1.cpp").read_text()
  compile_args = [f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math", f"-DNUMEL={numel}"]
  threads, blocks = 256, min(65535, max(1, (numel + 255) // 256))
  lidx, gidx = UOp.special(threads, "lidx0"), UOp.special(blocks, "gidx0")
  estimates = Estimates(ops=numel, mem=numel*x.dtype.itemsize + partial_amax.dtype.itemsize*blocks)
  sink = UOp.sink(partial_amax.base, x.base, lidx, gidx, arg=KernelInfo(name="custom_quantize_fp8_amax_pass1", estimates=estimates))
  lib = HIPCCCompiler(arch, compile_args).compile_cached(code)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=device), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=code), UOp(Ops.BINARY, arg=lib)))

@functools.cache
def custom_quantize_fp8_amax_pass2(amax:UOp, partial_amax:UOp, device:str, arch:str) -> UOp:
  partial_numel = prod(partial_amax.shape)
  code = (pathlib.Path(__file__).parent / "quantize_fp8_amax_pass2.cpp").read_text()
  compile_args = [f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math", f"-DPARTIAL_NUMEL={partial_numel}"]
  threads, blocks = 256, 1
  lidx, gidx = UOp.special(threads, "lidx0"), UOp.special(blocks, "gidx0")
  estimates = Estimates(ops=partial_numel, mem=partial_numel*partial_amax.dtype.itemsize + amax.dtype.itemsize)
  sink = UOp.sink(amax.base, partial_amax.base, lidx, gidx, arg=KernelInfo(name="custom_quantize_fp8_amax_pass2", estimates=estimates))
  lib = HIPCCCompiler(arch, compile_args).compile_cached(code)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=device), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=code), UOp(Ops.BINARY, arg=lib)))

@functools.cache
def custom_quantize_fp8_cast(x_fp8:UOp, inv_scale:UOp, x:UOp, amax:UOp, device:str, arch:str) -> UOp:
  numel = prod(x.shape)
  code = (pathlib.Path(__file__).parent / "quantize_fp8_cast.cpp").read_text()
  compile_args = [f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math", f"-DNUMEL={numel}", f"-DFP8_MAX={FP8_MAX}f"]
  threads, blocks = 256, min(65535, max(1, (numel + 255) // 256))
  lidx, gidx = UOp.special(threads, "lidx0"), UOp.special(blocks, "gidx0")
  estimates = Estimates(ops=6*numel, mem=numel*(x.dtype.itemsize + x_fp8.dtype.itemsize) + inv_scale.dtype.itemsize + amax.dtype.itemsize)
  sink = UOp.sink(x_fp8.base, inv_scale.base, x.base, amax.base, lidx, gidx, arg=KernelInfo(name="custom_quantize_fp8_cast", estimates=estimates))
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
  if getenv("HK_QUANTIZE_FP8_TWOPASS"):
    numel = prod(x.shape)
    blocks = min(65535, max(1, (numel + 255) // 256))
    partial_amax = Tensor.invalid(blocks, dtype=dtypes.float, device=x.device)
    partial_amax = Tensor.custom_kernel(partial_amax, x, fxn=functools.partial(custom_quantize_fp8_amax_pass1, device=dname, arch=arch))[0]
    amax = Tensor.custom_kernel(amax, partial_amax, fxn=functools.partial(custom_quantize_fp8_amax_pass2, device=dname, arch=arch))[0]
  else:
    amax = Tensor.custom_kernel(amax, x, fxn=functools.partial(custom_quantize_fp8_amax, device=dname, arch=arch))[0]
  x_fp8, inv_scale = Tensor.custom_kernel(x_fp8, inv_scale, x, amax, fxn=functools.partial(custom_quantize_fp8_cast, device=dname, arch=arch))[:2]
  new_amax = amax.cast(x.dtype).detach()
  return x_fp8, inv_scale, new_amax
