#!/usr/bin/env python3
"""CPU-only codegen/resource + mapper semantics checks for MXFP4 variants."""

from extra.gemm.cdna_lib.mxfp4 import LLAMA_SHAPES, build_kernel, choose_auto_variant
from extra.gemm.cdna_lib.resources import scan_resources


def map_wgm(gidx0: int, gidx1: int, mtiles: int, ntiles: int, wgm: int) -> tuple[int, int]:
  """Mathematical form of the reference WGM mapper, including its partial final band."""
  linear = ntiles * gidx1 + gidx0
  full_band = mtiles * wgm
  band = linear // full_band
  within = linear % full_band
  nbase = band * wgm
  width = min(wgm, ntiles - nbase)
  return nbase + within % width, within // width


def check_mapper_semantics(M: int, N: int, variant: str) -> None:
  mtiles, ntiles = M // 256, N // 256
  if variant == "identity":
    assert ntiles <= 32
    got = {(x, y) for y in range(mtiles) for x in range(ntiles)}
    ref = {map_wgm(x, y, mtiles, ntiles, 32) for y in range(mtiles) for x in range(ntiles)}
    assert got == ref
    # Stronger than set equality: identity must match the reference coordinate for every launch ID.
    for y in range(mtiles):
      for x in range(ntiles): assert (x, y) == map_wgm(x, y, mtiles, ntiles, 32)
    return

  if variant.startswith("wgm"):
    wgm = int(variant[3:])
    assert ntiles % wgm == 0
    mapped = [map_wgm(x, y, mtiles, ntiles, wgm) for y in range(mtiles) for x in range(ntiles)]
    assert len(set(mapped)) == mtiles * ntiles
    assert all(0 <= x < ntiles and 0 <= y < mtiles for x, y in mapped)


def main():
  for M, N, K in LLAMA_SHAPES:
    ref = build_kernel(M, N, K, 256, 256, "reference")
    variant = choose_auto_variant(M, N, K)
    check_mapper_semantics(M, N, variant)
    tuned = build_kernel(M, N, K, 256, 256, variant)
    rr, tr = scan_resources(ref), scan_resources(tuned)
    assert rr.code_bytes == tr.code_bytes, (M, N, K, rr.code_bytes, tr.code_bytes)
    assert (rr.regular_vgprs, rr.accvgprs, rr.referenced_sgprs, rr.allocated_combined_vgprs) == \
           (tr.regular_vgprs, tr.accvgprs, tr.referenced_sgprs, tr.allocated_combined_vgprs), (rr, tr)
    assert len(b"".join(x.to_bytes() for x in tuned)) == tr.code_bytes
    print(f"{M:5d}x{N:5d}x{K:5d}  {variant:8s}  {tr.one_line()}")

  explicit = {
    4096: ("identity", "wgm8", "wgm16"),
    6144: ("identity", "wgm8"),
    14336: ("wgm8",),
    28672: ("wgm8", "wgm16"),
  }
  for N, variants in explicit.items():
    for variant in variants:
      check_mapper_semantics(16384, N, variant)
      insts = build_kernel(16384, N, 4096, 256, 256, variant)
      _ = b"".join(x.to_bytes() for x in insts)

  # Identity must be rejected once the reference WGM32 mapper starts reordering tiles.
  try: build_kernel(16384, 14336, 4096, 256, 256, "identity")
  except ValueError: pass
  else: raise AssertionError("identity unexpectedly accepted Ntiles>32")
  print("codegen + mapper semantics checks passed")


if __name__ == "__main__": main()
