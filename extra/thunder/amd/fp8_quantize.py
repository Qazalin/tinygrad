import atexit, math, pathlib, functools, struct

from tinygrad import Device, Tensor
from tinygrad.dtype import dtypes
from tinygrad.helpers import DEBUG
from tinygrad.renderer import Estimates
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
from tinygrad.runtime.support.elf import elf_loader
from tinygrad.uop.ops import UOp, Ops, KernelInfo

FP8_MAX = 448.0
FP8_DTYPE = dtypes.fp8e4m3

@functools.cache
def _fp8_quantize_grad(shape, device, N_local):
  """STE gradient for fp8 quantization: dx = dout (pass-through, ignoring scale for now)"""
  def grad(*args, call:UOp|None=None) -> tuple[None, None, None, UOp, None]:
    # Handle both calling conventions:
    # - Single gradient: grad(dou, ker) where args=(dou, ker)
    # - Multiple gradients: grad(*grads, call=ker) where args=grads, call=ker
    if call is not None:
      dou = args[0]  # First gradient is for out_fp8 (the tensor output)
      ker = call
    else:
      dou, ker = args
    # Simple pass-through: just cast to bf16 without using kernel outputs
    # This avoids circular dependencies
    dx = dou.cast(dtypes.bfloat16)
    return None, None, None, dx, None
  return grad

@functools.cache
def _custom_fp8_quantize(out_fp8:UOp, out_inv_scale:UOp, out_new_amax:UOp, in_x:UOp, in_amax_state:UOp, device:str, arch:str, N:int):
  code = (pathlib.Path(__file__).parent / "fp8_quantize.cpp").read_text()
  compile_args = [f"-I{(pathlib.Path(__file__).parent / 'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-DHIP_ENABLE_WARP_SYNC_BUILTINS",
                  f"-DQUANT_N={N}"]

  NUM_WARPS = 4
  NUM_THREADS = 64 * NUM_WARPS
  ELEMENTS_PER_THREAD = 4
  ELEMENTS_PER_BLOCK = NUM_THREADS * ELEMENTS_PER_THREAD
  NUM_BLOCKS = math.ceil(N / ELEMENTS_PER_BLOCK)

  gsz = (NUM_BLOCKS, 1, 1)
  lsz = (NUM_THREADS, 1, 1)

  threadIdx_x = UOp.special(lsz[0], "lidx0")
  blockIdx_x = UOp.special(gsz[0], "gidx0")

  el = in_x.dtype.itemsize
  mem = N * el + N * out_fp8.dtype.itemsize + 2 * 4  # input bf16 + output fp8 + 2 floats
  estimates = Estimates(ops=N * 4, lds=mem, mem=mem)

  sink = UOp.sink(out_fp8.base, out_inv_scale.base, out_new_amax.base, in_x.base, in_amax_state.base,
                  threadIdx_x, blockIdx_x,
                  arg=KernelInfo(name="custom_fp8_quantize", estimates=estimates))

  lib = HIPCCCompiler(arch, compile_args).compile_cached(code)
  lib = bytearray(lib)
  rodata_off = next(sh.header.sh_offset for sh in elf_loader(bytes(lib))[1] if sh.name == ".rodata")
  struct.pack_into('<I', lib, rodata_off, 160000)
  lib = bytes(lib)

  return UOp(Ops.PROGRAM,
             src=(sink, UOp(Ops.DEVICE, arg=device), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=code), UOp(Ops.BINARY, arg=lib)))


EPS = 1e-8

_fp8_quantize_count = 0
def _fp8_quantize_report(): print(f'custom_fp8_quantize: {_fp8_quantize_count} used')
atexit.register(_fp8_quantize_report)

def _sharded_invalid(shape:tuple, ref:Tensor, dtype) -> Tensor:
  """Create an invalid tensor with the same sharding pattern as ref."""
  if not isinstance(ref.device, tuple):
    return Tensor.invalid(*shape, dtype=dtype, device=ref.device)
  axis = ref.uop.axis
  if axis is None:
    return Tensor.invalid(*shape, dtype=dtype, device=ref.device)
  num_devices = len(ref.device)
  local_shape = tuple(s // num_devices if i == axis else s for i, s in enumerate(shape))
  return Tensor(Tensor.invalid(*local_shape, dtype=dtype, device=ref.device).uop.multi(axis), dtype=dtype, device=ref.device)

def quantize_fp8(x:Tensor, amax_state:Tensor|None=None):
  """
  Quantize a bf16 tensor to fp8 using HipKittens.

  Args:
    x: Input tensor (bf16)
    amax_state: Optional pre-computed amax for scaling

  Returns:
    tuple: (x_fp8, inv_scale, new_amax)
  """
  global _fp8_quantize_count
  _fp8_quantize_count += 1
  assert x.dtype == dtypes.bfloat16, f"expected bf16 input, got {x.dtype}"
  device = x.device
  is_multi = isinstance(device, tuple)
  single_device = device[0] if is_multi else device
  arch = Device[single_device].renderer.target.arch
  num_devices = len(device) if is_multi else 1

  N = x.numel()
  N_local = N // num_devices
  if DEBUG >= 2: print(f"FP8 Quantize {N=} elements ({N_local=} per device) on {device}")

  # if no amax_state provided, use FP8_MAX as default
  if amax_state is None:
    amax_state = Tensor.full((), FP8_MAX, dtype=dtypes.float32, device=device).contiguous()
  elif is_multi and not isinstance(amax_state.device, tuple):
    amax_state = amax_state.to(device).contiguous()

  # Compute scale for STE gradient (gradient flows through x * scale)
  scale = FP8_MAX / (amax_state + EPS)
  inv_scale = (amax_state + EPS) / FP8_MAX

  # STE: gradient flows through x_scaled, kernel output replaces forward value
  # x_scaled is used for gradient computation, kernel output for forward value
  x_scaled = x * scale

  # Create output tensors
  out_fp8 = _sharded_invalid(x.shape, x, FP8_DTYPE) if is_multi else Tensor.invalid(*x.shape, dtype=FP8_DTYPE, device=device)
  out_inv_scale = Tensor.invalid((), dtype=dtypes.float32, device=device)
  out_new_amax = Tensor.invalid((), dtype=dtypes.float32, device=device)

  # Flatten for kernel
  x_flat = x.flatten()
  out_fp8_flat = out_fp8.flatten()

  # Custom kernel computes fp8 output and new_amax - NO grad_fxn needed
  # Gradient will flow through x_scaled via STE trick below
  out_fp8_flat, _, out_new_amax = Tensor.custom_kernel(
    out_fp8_flat, out_inv_scale, out_new_amax, x_flat, amax_state,
    fxn=functools.partial(_custom_fp8_quantize, device=single_device, arch=arch, N=N_local),
  )[:3]

  # STE trick: use kernel output for forward, but gradient flows through x_scaled
  # out_fp8_kernel + (x_scaled - x_scaled).detach() = out_fp8_kernel (forward)
  # gradient: d/dx = scale (from x_scaled term)
  out_fp8_final = out_fp8_flat.reshape(x.shape)
  out_fp8_ste = out_fp8_final.detach().cast(x.dtype) + (x_scaled - x_scaled.detach())
  out_fp8_ste = out_fp8_ste.cast(FP8_DTYPE)

  return out_fp8_ste, inv_scale, out_new_amax.cast(x.dtype).detach()
