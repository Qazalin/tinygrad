"""Low-risk MXFP4 tuning variants for gfx950.

The MFMA/LDS schedule comes from extra.gemm.gemm_mxfp4 unchanged.  This module only
specializes the workgroup mapper in the finalized instruction stream.  All patches
preserve total code bytes so the already-resolved branch offsets in the reference
kernel remain valid.
"""

import math
from typing import Literal

from tinygrad.runtime.autogen.amd.cdna.ins import s_branch, s_nop
from extra.gemm.gemm_mxfp4 import build_kernel as build_reference_kernel

Variant = Literal["reference", "auto", "identity", "wgm8", "wgm16", "wgm32"]

# (M, N, K) from the production table in this tuning session.
LLAMA_SHAPES = (
  (28672, 4096, 16384),
  (16384, 28672, 4096),
  (16384, 4096, 28672),
  (16384, 14336, 4096),
  (4096, 14336, 16384),
  (16384, 4096, 14336),
  (16384, 4096, 4096),
  (16384, 6144, 4096),
  (16384, 4096, 6144),
  (6144, 4096, 16384),
  (4096, 4096, 16384),
)


def choose_auto_variant(M: int, N: int, K: int, tile_m: int = 256, tile_n: int = 256) -> Variant:
  if (tile_m, tile_n) != (256, 256): return "reference"
  ntiles = (N + tile_n - 1) // tile_n
  # For <=32 N tiles the reference WGM32 mapper produces exactly (gidx0,gidx1),
  # but takes the expensive generic remainder divide path when ntiles < 32.
  if ntiles <= 32: return "identity"
  # Avoid WGM32 partial bands on the larger production Ns.  Power-of-two WGMs keep
  # the fast scalar shift/mask mapper and preserve a useful N reuse band.
  if ntiles % 16 == 0: return "wgm16"
  if ntiles % 8 == 0: return "wgm8"
  return "reference"


def _find_unique(insts, text: str, start: int = 0, end: int | None = None) -> int:
  end = len(insts) if end is None else end
  found = [i for i in range(start, end) if repr(insts[i]) == text]
  if len(found) != 1: raise RuntimeError(f"expected one {text!r} in [{start}:{end}), found {len(found)} at {found}")
  return found[0]

def _mapper_bounds(insts) -> tuple[int, int]:
  start = _find_unique(insts, "s_add_u32(s[55], s[44], LIT, 255)")
  end = _find_unique(insts, "s_add_i32(s[46], s[52], s[46])", start=start)
  if end <= start: raise RuntimeError(f"bad mapper range {start}:{end}")
  return start, end


def _patch_wgm_pow2(insts, wgm: int) -> None:
  if wgm not in (8, 16, 32): raise ValueError(f"fast WGM must be 8/16/32, got {wgm}")
  shift = int(math.log2(wgm))

  # These are the five WGM=32 constants in the 256x256 reference mapper.
  patches = (
    ("s_lshl_b32(s[52], s[52], 5)", shift),
    ("s_add_i32(s[46], s[46], 32)", wgm),
    ("s_cmp_lt_i32(s[54], 32)", wgm),
    ("s_lshr_b32(s[47], s[48], 5)", shift),
    ("s_and_b32(s[52], s[48], 31)", wgm - 1),
  )
  start, end = _mapper_bounds(insts)
  for text, imm in patches:
    inst = insts[_find_unique(insts, text, start, end+1)]
    inst.ssrc1 = imm


def _patch_identity_mapper(insts) -> None:
  """Skip the entire generic mapper; s46/s47 already contain gidx0/gidx1.

  The replacement has exactly the same byte length as the removed range.  A branch
  jumps over padding, so runtime cost is one SOPP instead of reciprocal/divide logic.
  """
  start, end = _mapper_bounds(insts)
  nbytes = sum(inst.size() for inst in insts[start:end+1])
  if nbytes % 4 or nbytes < 8: raise RuntimeError(f"unexpected mapper size {nbytes}")

  # SOPP branch target is relative to the instruction after the branch, in dwords.
  replacement = [s_branch((nbytes - 4) // 4)] + [s_nop() for _ in range((nbytes - 4) // 4)]
  assert sum(x.size() for x in replacement) == nbytes
  insts[start:end+1] = replacement


def build_kernel(M: int, N: int, K: int, tile_m: int = 256, tile_n: int = 256,
                 variant: Variant = "auto"):
  """Build a reference-compatible kernel with a mapper specialization.

  Current optimized variants intentionally leave the MFMA body, LDS usage, thread
  count and epilogue untouched.  This makes them suitable as the first A/B baseline
  before the higher-risk 8-wave short-K rewrite.
  """
  insts = build_reference_kernel(M, N, K, tile_m, tile_n)
  if variant == "auto": variant = choose_auto_variant(M, N, K, tile_m, tile_n)
  if variant == "reference": return insts
  if (tile_m, tile_n) != (256, 256):
    raise ValueError(f"{variant} currently supports only the 256x256 reference path, got {tile_m}x{tile_n}")

  if variant == "identity":
    ntiles = (N + tile_n - 1) // tile_n
    if ntiles > 32:
      raise ValueError(f"identity is equivalent to the reference WGM32 mapper only for Ntiles<=32, got {ntiles}")
    _patch_identity_mapper(insts)
  elif variant.startswith("wgm"):
    wgm = int(variant[3:])
    ntiles = (N + tile_n - 1) // tile_n
    if ntiles % wgm:
      raise ValueError(f"N={N} has {ntiles} N-tiles, not divisible by WGM={wgm}; this variant intentionally has no partial-band path")
    _patch_wgm_pow2(insts, wgm)
  else:
    raise ValueError(f"unknown MXFP4 variant {variant!r}")
  return insts
