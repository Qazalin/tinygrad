import functools, pathlib
from tinygrad import Tensor, dtypes
from tinygrad.renderer import Estimates
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
from tinygrad.uop.ops import UOp, Ops, KernelInfo

MX_BLOCK_SIZE = 32
MXFP4_VALUES = (0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0,
                -0.0, -0.5, -1.0, -1.5, -2.0, -3.0, -4.0, -6.0)


def _hadamard(size:int) -> list[list[float]]:
  assert size > 0 and size & (size - 1) == 0
  h = [[1.0]]
  while len(h) < size:
    h = [row + row for row in h] + [row + [-x for x in row] for row in h]
  return h


def hadamard16(x:Tensor) -> Tensor:
  """Apply normalized H16 independently to each contiguous group of 16 values."""
  assert x.shape[-1] % 16 == 0, f"last dimension must be divisible by 16, got {x.shape}"
  h = Tensor(_hadamard(16), dtype=dtypes.float32, device=x.device) * 0.25
  return (x.float().reshape(-1, 16) @ h).reshape(x.shape)


def quantize_mxfp4_ref(x:Tensor, use_hadamard:bool=False) -> tuple[Tensor, Tensor]:
  """Reference MXFP4 quantizer returning packed E2M1 data and unpadded E8M0 scales.

  Data has shape ``(*x.shape[:-1], K/2)`` and packs the even element in the low
  nibble. Scales have shape ``(*x.shape[:-1], K/32)``.
  """
  assert x.ndim >= 2 and x.shape[-1] % MX_BLOCK_SIZE == 0, f"expected K divisible by 32, got {x.shape}"
  *batch, K = x.shape
  rows, scale_k = x.numel() // K, K // MX_BLOCK_SIZE
  xf = hadamard16(x) if use_hadamard else x.float()
  blocks = xf.reshape(rows, scale_k, MX_BLOCK_SIZE)
  amax = blocks.abs().max(axis=-1)

  # Match Transformer Engine's compute_e8m0_scale: first round the fp32
  # mantissa using integer bits, then select a scale whose maximum FP4 value is 4.
  rounded_bits = (amax.bitcast(dtypes.uint32) + 0x200000) & 0xFF800000
  amax_rounded = rounded_bits.bitcast(dtypes.float32)
  scale_unbiased = amax_rounded.maximum(1e-45).log2().floor().sub(2).clamp(-127, 127)
  scales = (amax == 0).where(127, scale_unbiased + 127).cast(dtypes.uint8)
  scaled = blocks * (127.0 - scales.cast(dtypes.float32)).exp2().reshape(rows, scale_k, 1)

  magnitude = scaled.abs()
  code = sum((magnitude >= threshold).cast(dtypes.uint8)
             for threshold in (0.25, 0.75, 1.25, 1.75, 2.5, 3.5, 5.0))
  nibbles = code | ((scaled < 0).cast(dtypes.uint8) << 3)
  pairs = nibbles.reshape(rows, K // 2, 2)
  packed = pairs[:, :, 0] | (pairs[:, :, 1] << 4)
  return packed.reshape(*batch, K // 2), scales.reshape(*batch, scale_k)


def dequantize_mxfp4(packed:Tensor, scales:Tensor) -> Tensor:
  """Decode unshuffled packed E2M1 data and E8M0 scales to float32."""
  assert packed.ndim >= 2 and scales.ndim == packed.ndim
  *batch, half_k = packed.shape
  K, rows = half_k * 2, packed.numel() // half_k
  assert K % MX_BLOCK_SIZE == 0 and scales.shape == (*batch, K // MX_BLOCK_SIZE)
  p = packed.reshape(rows, half_k)
  nibbles = Tensor.stack(p & 0xF, p >> 4, dim=-1).reshape(rows, K)
  table = Tensor(MXFP4_VALUES, dtype=dtypes.float32, device=packed.device)
  values = table[nibbles]
  decoded_scales = (scales.reshape(rows, K // MX_BLOCK_SIZE).cast(dtypes.float32) - 127.0).exp2()
  return (values.reshape(rows, K // MX_BLOCK_SIZE, MX_BLOCK_SIZE) *
          decoded_scales.reshape(rows, K // MX_BLOCK_SIZE, 1)).reshape(*batch, K)


@functools.cache
def _custom_mxfp4_gemm(C:UOp, A:UOp, B:UOp, scale_a:UOp, scale_b:UOp, orig_a:UOp, orig_b:UOp, dname:str) -> UOp:
  M, K2 = A.shape
  N, K2b = B.shape
  K = K2 * 2
  assert K == K2b * 2, f"local K mismatch A={A.shape}, B={B.shape}"
  assert C.shape[-2:] == (M, N), f"output mismatch C={C.shape}, A={A.shape}, B={B.shape}"
  tile, nthreads = (128, 512) if M % 128 == N % 128 == 0 else (16, 64)
  threads = UOp.special(nthreads, "lidx0")
  workgroups = UOp.special((M // tile) * (N // tile), "gidx0")
  sink = UOp.sink(C.base, A.base, B.base, scale_a.base, scale_b.base, orig_a.base, orig_b.base, threads, workgroups,
                  arg=KernelInfo(f"mxfp4_gemm_{M}_{N}_{K}",
                                 estimates=Estimates(ops=2*M*N*K, mem=M*K//2 + N*K//2 + M*N*2)))
  thunder = pathlib.Path(__file__).parent.parent/"thunder"/"amd"
  src = (thunder/"gemm_mxfp4.cpp").read_text()
  opts = ["-std=c++20", "-ffast-math", f"-DGEMM_M={M}", f"-DGEMM_N={N}", f"-DGEMM_K={K}"]
  lib = HIPCCCompiler("gfx950", opts).compile_cached(src)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.LINEAR, src=(*sink.src, sink)),
                               UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=lib)))


def _mxfp4_gemm_launch(a:Tensor, b:Tensor, scale_a:Tensor, scale_b:Tensor, orig_a:Tensor, orig_b:Tensor, grad_fxn=None) -> Tensor:
  """Native gfx950 A4W4 ABt GEMM for plain packed rowwise MXFP4 tensors."""
  assert a.ndim == b.ndim == 2 and a.dtype == b.dtype == dtypes.uint8
  M, half_k = a.shape
  N, half_k_b = b.shape
  K = half_k * 2
  assert half_k == half_k_b and M % 16 == N % 16 == 0 and K % 128 == 0, f"unsupported shapes {a.shape} {b.shape}"
  assert scale_a.shape == (M, K // 32) and scale_b.shape == (N, K // 32)
  assert a.device == b.device == scale_a.device == scale_b.device
  reduce_out = False
  if isinstance(a.device, tuple):
    from extra.llama_kernels import alloc_like
    if a.uop.axis == 0 and b.uop.axis is None:
      out = alloc_like((M, N), dtypes.bfloat16, a.device, 0)
    elif a.uop.axis == b.uop.axis == 1:
      out = Tensor(Tensor.invalids(1, M, N, dtype=dtypes.bfloat16, device=a.device).uop.multi(0), device=a.device)
      reduce_out = True
    else:
      raise AssertionError(f"unsupported MXFP4 sharding axes A={a.uop.axis}, B={b.uop.axis}")
    dname = a.device[0].split(":")[0]
  else:
    out = Tensor.invalids(M, N, dtype=dtypes.bfloat16, device=a.device)
    dname = a.device.split(":")[0]
  fxn = functools.partial(_custom_mxfp4_gemm, dname=dname)
  out = Tensor.custom_kernel(out, a, b, scale_a, scale_b, orig_a, orig_b, fxn=fxn, grad_fxn=grad_fxn)[0]
  return out.sum(0) if reduce_out else out


def mxfp4_gemm(a:Tensor, b:Tensor, scale_a:Tensor, scale_b:Tensor) -> Tensor:
  return _mxfp4_gemm_launch(a, b, scale_a, scale_b, a, b)


def _mxfp4_linear_nograd(a:Tensor, b:Tensor, use_hadamard:bool) -> Tensor:
  from extra.llama_kernels.quantize_mxfp4 import quantize_mxfp4
  aq, ae = quantize_mxfp4(a, use_hadamard)
  bq, be = quantize_mxfp4(b, use_hadamard)
  return _mxfp4_gemm_launch(aq, bq, ae, be, a, b)


def _mxfp4_gemm_bw(gradient:UOp, kernel:UOp, use_hadamard:bool, dgrad:bool, wgrad:bool):
  _, _, _, _, _, orig_a, orig_b = kernel.src[1:]
  a = Tensor(orig_a, device=orig_a.device)
  b = Tensor(orig_b, device=orig_b.device)
  g = Tensor(gradient, device=gradient.device).cast(dtypes.bfloat16)
  # ABt only: dA = G @ B, dB = G.T @ A. Transposes are quantized directly
  # from the canonical BF16 tensors rather than transposing packed FP4.
  grad_a = _mxfp4_linear_nograd(g, b.T.contiguous(), use_hadamard) if dgrad else (g @ b).cast(dtypes.bfloat16)
  grad_b = _mxfp4_linear_nograd(g.T.contiguous(), a.T.contiguous(), use_hadamard) if wgrad else (g.T @ a).cast(dtypes.bfloat16)
  return None, None, None, None, None, grad_a.uop, grad_b.uop


def mxfp4_linear(a:Tensor, b:Tensor, use_hadamard:bool=True, dgrad:bool=True, wgrad:bool=True) -> Tensor:
  """Dynamic MXFP4 linear layer: BF16 A @ B.T with A4W4 fprop, dgrad, and wgrad."""
  assert a.ndim == b.ndim == 2 and a.dtype == b.dtype == dtypes.bfloat16
  from extra.llama_kernels.quantize_mxfp4 import quantize_mxfp4
  aq, ae = quantize_mxfp4(a, use_hadamard)
  bq, be = quantize_mxfp4(b, use_hadamard)
  grad_fxn = functools.partial(_mxfp4_gemm_bw, use_hadamard=use_hadamard, dgrad=dgrad, wgrad=wgrad)
  return _mxfp4_gemm_launch(aq, bq, ae, be, a, b, grad_fxn)
