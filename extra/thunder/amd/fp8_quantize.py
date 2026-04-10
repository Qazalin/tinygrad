import math, pathlib, functools, struct

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
def _fp8_quantize_grad(shape, device):
  """STE gradient for fp8 quantization: dx = dout * scale"""
  def grad(dou:UOp, ker:UOp) -> tuple[None, None, None, UOp, None]:
    # dou is gradient w.r.t. first output (out_fp8)
    # ker.src[1] = out_fp8, ker.src[2] = out_inv_scale, etc.
    dout = Tensor(dou, device=dou.device)
    inv_scale = Tensor(ker.src[2].after(ker), device=ker.src[2].device)
    # STE: gradient flows through as dx = dout * scale = dout / inv_scale
    scale = 1.0 / inv_scale
    dx = (dout.float() * scale).cast(dtypes.bfloat16).reshape(shape)
    return None, None, None, dx.uop, None
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


def quantize_fp8(x:Tensor, amax_state:Tensor|None=None):
  """
  Quantize a bf16 tensor to fp8 using HipKittens.

  Args:
    x: Input tensor (bf16)
    amax_state: Optional pre-computed amax for scaling

  Returns:
    tuple: (x_fp8, inv_scale, new_amax)
  """
  assert x.dtype == dtypes.bfloat16, f"expected bf16 input, got {x.dtype}"
  device = x.device
  arch = Device[device].renderer.target.arch

  N = x.numel()
  if DEBUG >= 2: print(f"FP8 Quantize {N=} elements on {device}")

  # create output tensors - use contiguous input directly to avoid reshape kernels
  out_fp8 = Tensor.empty(N, dtype=FP8_DTYPE, device=device)
  out_inv_scale = Tensor.empty((), dtype=dtypes.float32, device=device)
  # new_amax initialized to 0 via zeros() - kernel will use atomic max
  out_new_amax = Tensor.zeros((), dtype=dtypes.float32, device=device).contiguous()

  # if no amax_state provided, use FP8_MAX as default
  if amax_state is None:
    amax_state = Tensor.full((), FP8_MAX, dtype=dtypes.float32, device=device).contiguous()

  # flatten input - if already contiguous this should be free
  x_flat = x.flatten()

  grad_fxn = _fp8_quantize_grad(x.shape, device)

  out_fp8, out_inv_scale, out_new_amax = Tensor.custom_kernel(
    out_fp8, out_inv_scale, out_new_amax, x_flat, amax_state,
    fxn=functools.partial(_custom_fp8_quantize, device=device, arch=arch, N=N),
    grad_fxn=grad_fxn
  )[:3]

  return out_fp8.reshape(x.shape), out_inv_scale, out_new_amax
