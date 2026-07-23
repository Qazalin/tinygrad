import functools, pathlib, struct
from dataclasses import replace
from tinygrad import Tensor, dtypes, Device
from tinygrad.renderer import Estimates
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
from tinygrad.uop.ops import UOp, Ops, KernelInfo, ProgramInfo
from tinygrad.helpers import ceildiv, getenv

MX_BLOCK_SIZE = 32
MXFP4_VALUES = (0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0,
                -0.0, -0.5, -1.0, -1.5, -2.0, -3.0, -4.0, -6.0)

_AITER_F4_KERNELS = {
  (4096, 4096, 16384): (256, 256),
  (6144, 4096, 16384): (192, 256),
  (16384, 4096, 4096): (256, 256),
  (16384, 4096, 6144): (128, 512),
  (16384, 4096, 14336): (256, 256),
  (16384, 4096, 28672): (256, 256),
  (28672, 4096, 16384): (256, 256),
  (16384, 6144, 4096): (256, 256),
  (4096, 14336, 16384): (256, 256),
  (16384, 14336, 4096): (256, 256),
  (16384, 28672, 4096): (256, 256),
}


def _aiter_f4_kernargs(M:int, N:int, K:int) -> bytes:
  """Construct AITER's packed 384-byte gfx950 F4 GEMM kernarg block."""
  args = bytearray(384)
  struct.pack_into("<f", args, 64, 1.0)   # alpha
  struct.pack_into("<f", args, 80, 0.0)   # beta
  for offset, value in ((96, N), (112, 1), (128, N), (144, 1),
                        (160, K), (176, 1), (192, K), (208, 1),
                        (224, M), (240, N), (256, K),
                        (304, K // 32), (320, 1), (336, K // 32), (352, 1),
                        (368, 0)):  # no split-K in AMD's submitted tuned table
    struct.pack_into("<I", args, offset, value)
  return bytes(args)


def _aiter_f4_program_info(sink:UOp, M:int, N:int, K:int, tile_m:int, tile_n:int) -> ProgramInfo:
  info = ProgramInfo.from_sink(sink)
  # Buffer order is D, A, B, ScaleA, ScaleB, OrigA, OrigB. OrigA/B are retained
  # solely for tinygrad autograd and therefore have no entries in the hardware ABI.
  packed_offsets = (0, 32, 48, 272, 288, None, None)
  return replace(info, global_size=(ceildiv(N, tile_n), ceildiv(M, tile_m), 1), local_size=(256, 1, 1),
                 outs=(info.globals[0],), ins=info.globals[1:],
                 aux=("packed", _aiter_f4_kernargs(M, N, K), packed_offsets))


@functools.cache
def _custom_aiter_f4_gemm(C:UOp, A:UOp, B:UOp, scale_a:UOp, scale_b:UOp, orig_a:UOp, orig_b:UOp, dname:str,
                          tile_m:int, tile_n:int) -> UOp:
  M, K2 = A.shape
  N, K2b = B.shape
  K = K2 * 2
  assert K == K2b * 2 and C.shape[-2:] == (M, N)
  threads = UOp.special(256, "lidx0")
  groups_x, groups_y = UOp.special(ceildiv(N, tile_n), "gidx0"), UOp.special(ceildiv(M, tile_m), "gidx1")
  sink = UOp.sink(C.base, A.base, B.base, scale_a.base, scale_b.base, orig_a.base, orig_b.base, threads, groups_x, groups_y,
                  arg=KernelInfo(f"aiter_f4gemm_{M}_{N}_{K}",
                                 estimates=Estimates(ops=2*M*N*K, mem=M*K//2 + N*K//2 + M*N*2)))
  root = pathlib.Path(__file__).parent/"amd"/"aiter_f4"
  stem = f"f4gemm_bf16_per1x32Fp4_BpreShuffle_{tile_m}x{tile_n}"
  lib = (root/f"{stem}.co").read_bytes()
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.LINEAR, src=(*sink.src, sink)),
                               UOp(Ops.SOURCE, arg=f"AITER gfx950 opaque code object: {stem}"),
                               UOp(Ops.BINARY, arg=lib)), arg=_aiter_f4_program_info(sink, M, N, K, tile_m, tile_n))


def _custom_mxfp4_dispatch(C:UOp, A:UOp, B:UOp, scale_a:UOp, scale_b:UOp, orig_a:UOp, orig_b:UOp, dname:str,
                           b_preshuffled:bool, use_aiter:bool) -> UOp:
  # Select after multi-device lowering: A/B are per-device UOps here, whereas
  # _mxfp4_gemm_launch sees the global Tensor shapes before DP/MP sharding.
  M, K2 = A.shape
  N, K2b = B.shape
  assert K2 == K2b
  if use_aiter and b_preshuffled and (tiles := _AITER_F4_KERNELS.get((M, N, K2 * 2))) is not None:
    return _custom_aiter_f4_gemm(C, A, B, scale_a, scale_b, orig_a, orig_b, dname, tiles[0], tiles[1])
  return _custom_mxfp4_gemm(C, A, B, scale_a, scale_b, orig_a, orig_b, dname, b_preshuffled)


def shuffle_mxfp4_weight(x:Tensor) -> Tensor:
  """Apply AMD's 16x16 packed-FP4 B preshuffle."""
  assert x.ndim == 2 and x.dtype == dtypes.uint8
  if isinstance(x.device, tuple) and (axis:=x.uop.axis) is not None:
    local_shape = x.uop.shard_shape
    parts = [shuffle_mxfp4_weight(Tensor(x.uop.mselect(i).shrink(tuple((0, s) for s in local_shape)), device=d)).uop
             for i, d in enumerate(x.device)]
    return Tensor(UOp.mstack(*parts).multi(axis), device=x.device)
  N, half_k = x.shape
  assert N % 16 == 0 and half_k % 32 == 0, f"unsupported packed weight shape {x.shape}"
  return x.reshape(N // 16, 16, half_k // 32, 2, 16).permute(0, 2, 3, 1, 4).contiguous().reshape(N, half_k)


def unshuffle_mxfp4_weight(x:Tensor) -> Tensor:
  """Invert :func:`shuffle_mxfp4_weight`."""
  assert x.ndim == 2 and x.dtype == dtypes.uint8
  N, half_k = x.shape
  assert N % 16 == 0 and half_k % 32 == 0, f"unsupported packed weight shape {x.shape}"
  return x.reshape(N // 16, half_k // 32, 2, 16, 16).permute(0, 3, 1, 2, 4).contiguous().reshape(N, half_k)


def shuffle_mxfp4_scales(x:Tensor) -> Tensor:
  """Apply the E8M0 scale layout used by AMD's gfx950 A4W4 kernels."""
  assert x.ndim == 2 and x.dtype == dtypes.uint8
  if isinstance(x.device, tuple) and (axis:=x.uop.axis) is not None:
    local_shape = x.uop.shard_shape
    parts = [shuffle_mxfp4_scales(Tensor(x.uop.mselect(i).shrink(tuple((0, s) for s in local_shape)), device=d)).uop
             for i, d in enumerate(x.device)]
    return Tensor(UOp.mstack(*parts).multi(axis), device=x.device)
  rows, scale_k = x.shape
  assert rows % 32 == 0 and scale_k % 8 == 0, f"unsupported scale shape {x.shape}"
  return x.reshape(rows // 32, 2, 16, scale_k // 8, 2, 4).permute(0, 3, 5, 2, 4, 1).contiguous().reshape(rows, scale_k)


def unshuffle_mxfp4_scales(x:Tensor) -> Tensor:
  """Invert :func:`shuffle_mxfp4_scales`."""
  assert x.ndim == 2 and x.dtype == dtypes.uint8
  rows, scale_k = x.shape
  assert rows % 32 == 0 and scale_k % 8 == 0, f"unsupported scale shape {x.shape}"
  return x.reshape(rows // 32, scale_k // 8, 4, 16, 2, 2).permute(0, 5, 3, 1, 4, 2).contiguous().reshape(rows, scale_k)


def mxfp4_gemm_program_info(sink:UOp) -> ProgramInfo:
  info = ProgramInfo.from_sink(sink)
  return replace(info, outs=(info.globals[0],), ins=info.globals[1:])


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
def _custom_mxfp4_gemm(C:UOp, A:UOp, B:UOp, scale_a:UOp, scale_b:UOp, orig_a:UOp, orig_b:UOp, dname:str,
                       b_preshuffled:bool=False) -> UOp:
  M, K2 = A.shape
  N, K2b = B.shape
  K = K2 * 2
  assert K == K2b * 2, f"local K mismatch A={A.shape}, B={B.shape}"
  assert C.shape[-2:] == (M, N), f"output mismatch C={C.shape}, A={A.shape}, B={B.shape}"
  thunder_tile = M % 256 == N % 256 == 0
  tile = 256 if thunder_tile else (128 if M % 128 == N % 128 == 0 else 16)
  nthreads = 512 if tile != 16 else 64
  threads = UOp.special(nthreads, "lidx0")
  workgroups = UOp.special((M // tile) * (N // tile), "gidx0")
  sink = UOp.sink(C.base, A.base, B.base, scale_a.base, scale_b.base, orig_a.base, orig_b.base, threads, workgroups,
                  arg=KernelInfo(f"mxfp4_gemm_{M}_{N}_{K}",
                                 estimates=Estimates(ops=2*M*N*K, mem=M*K//2 + N*K//2 + M*N*2)))
  thunder = pathlib.Path(__file__).parent.parent/"thunder"/"amd"
  src = (thunder/("gemm_mxfp4_thunder.cpp" if thunder_tile else "gemm_mxfp4.cpp")).read_text()
  opts = ["-std=c++20", "-ffast-math", f"-DGEMM_M={M}", f"-DGEMM_N={N}", f"-DGEMM_K={K}"]
  if thunder_tile:
    opts += [f"-I{thunder/'include'}", "-DKITTENS_CDNA4", "-DHIP_ENABLE_WARP_SYNC_BUILTINS"]
    if b_preshuffled: opts += ["-DB_PRESHUFFLED", "-DSCALES_PRESHUFFLED", "-DMXFP4_DEEP_PIPELINE"]
  lib = HIPCCCompiler("gfx950", opts).compile_cached(src)
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.LINEAR, src=(*sink.src, sink)),
                               UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=lib)), arg=mxfp4_gemm_program_info(sink))


def _mxfp4_gemm_launch(a:Tensor, b:Tensor, scale_a:Tensor, scale_b:Tensor, orig_a:Tensor, orig_b:Tensor, grad_fxn=None,
                       b_preshuffled:bool=False) -> Tensor:
  """Native gfx950 A4W4 ABt GEMM for plain packed rowwise MXFP4 tensors."""
  assert a.ndim == b.ndim == 2 and a.dtype == b.dtype == dtypes.uint8
  M, half_k = a.shape
  N, half_k_b = b.shape
  K = half_k * 2
  assert half_k == half_k_b and M % 16 == N % 16 == 0 and K % 128 == 0, f"unsupported shapes {a.shape} {b.shape}"
  assert scale_a.shape == (M, K // 32) and scale_b.shape == (N, K // 32), \
    f"scale mismatch A={a.shape}/{scale_a.shape}, B={b.shape}/{scale_b.shape}"
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
  assert not b_preshuffled or M % 256 == N % 256 == 0, "B preshuffle is only supported by the 256x256 Thunder kernel"
  devices = a.device if isinstance(a.device, tuple) else (a.device,)
  is_gfx950 = all(Device[d].renderer.target.arch == "gfx950" for d in devices)
  use_aiter = getenv("AITER_MXFP4", int(is_gfx950))
  if use_aiter: assert is_gfx950, "AITER_MXFP4 code objects require gfx950"
  fxn = functools.partial(_custom_mxfp4_dispatch, dname=dname, b_preshuffled=b_preshuffled, use_aiter=bool(use_aiter))
  out = Tensor.custom_kernel(out, a, b, scale_a, scale_b, orig_a, orig_b, fxn=fxn, grad_fxn=grad_fxn)[0]
  return out.sum(0) if reduce_out else out


def mxfp4_gemm(a:Tensor, b:Tensor, scale_a:Tensor, scale_b:Tensor) -> Tensor:
  return _mxfp4_gemm_launch(a, b, scale_a, scale_b, a, b)


def mxfp4_gemm_preshuffled(a:Tensor, b:Tensor, scale_a:Tensor, scale_b:Tensor) -> Tensor:
  """A4W4 ABt GEMM where B and both scales use AMD's physical layouts."""
  return _mxfp4_gemm_launch(a, b, scale_a, scale_b, a, b, b_preshuffled=True)


def aiter_mxfp4_gemm_preshuffled(a:Tensor, b:Tensor, scale_a:Tensor, scale_b:Tensor,
                                 tile_m:int=256, tile_n:int=256) -> Tensor:
  """Launch an exact AITER gfx950 A4W4 code object, including for standalone test shapes."""
  assert (tile_m, tile_n) in ((256, 256), (192, 256), (128, 512)), f"unavailable AITER tile {tile_m}x{tile_n}"
  assert a.ndim == b.ndim == 2 and a.dtype == b.dtype == dtypes.uint8
  M, half_k = a.shape
  N, half_k_b = b.shape
  K = half_k * 2
  assert half_k == half_k_b and M % tile_m == N % tile_n == 0 and K % 256 == 0, f"unsupported shapes {a.shape} {b.shape}"
  assert scale_a.shape == (M, K // 32) and scale_b.shape == (N, K // 32)
  assert a.device == b.device == scale_a.device == scale_b.device and not isinstance(a.device, tuple)
  assert Device[a.device].renderer.target.arch == "gfx950", "AITER MXFP4 code objects require gfx950"
  out = Tensor.invalids(M, N, dtype=dtypes.bfloat16, device=a.device)
  fxn = functools.partial(_custom_aiter_f4_gemm, dname=a.device.split(":")[0], tile_m=tile_m, tile_n=tile_n)
  return Tensor.custom_kernel(out, a, b, scale_a, scale_b, a, b, fxn=fxn)[0]


def _mxfp4_linear_nograd(a:Tensor, b:Tensor, use_hadamard:bool) -> Tensor:
  from extra.llama_kernels.quantize_mxfp4 import quantize_mxfp4
  use_fast = a.shape[0] % 256 == b.shape[0] % 256 == 0 and (a.shape[1] // 32) % 8 == 0
  aq, ae = quantize_mxfp4(a, use_hadamard, shuffle_scales=use_fast)
  bq, be = quantize_mxfp4(b, use_hadamard, shuffle_data=use_fast, shuffle_scales=use_fast)
  if use_fast: return _mxfp4_gemm_launch(aq, bq, ae, be, a, b, b_preshuffled=True)
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
  use_fast = a.shape[0] % 256 == b.shape[0] % 256 == 0 and (a.shape[1] // 32) % 8 == 0
  aq, ae = quantize_mxfp4(a, use_hadamard, shuffle_scales=use_fast)
  bq, be = quantize_mxfp4(b, use_hadamard, shuffle_data=use_fast, shuffle_scales=use_fast)
  grad_fxn = functools.partial(_mxfp4_gemm_bw, use_hadamard=use_hadamard, dgrad=dgrad, wgrad=wgrad)
  if use_fast: return _mxfp4_gemm_launch(aq, bq, ae, be, a, b, grad_fxn, b_preshuffled=True)
  return _mxfp4_gemm_launch(aq, bq, ae, be, a, b, grad_fxn)
