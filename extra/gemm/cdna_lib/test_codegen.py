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

  # Phase 2 architectural gate: 8 waves, 128 accumulators and <=256 combined VGPRs.
  p2 = build_kernel(16384, 4096, 4096, 256, 256, "phase2_8w")
  p2r = scan_resources(p2)
  assert p2r.regular_vgprs <= 128, p2r
  assert p2r.accvgprs == 128, p2r
  assert p2r.allocated_combined_vgprs <= 256, p2r
  assert len(b"".join(x.to_bytes() for x in p2)) == p2r.code_bytes
  print(f"phase2_8w resources: {p2r.one_line()}")

  # Wave-id extraction must preserve the known-good reference dependency spacing:
  # shift -> 3 independent instructions -> readfirstlane, then an explicit 4-cycle SGPR drain.
  raw = build_kernel(256, 4096, 4096, 256, 256, "phase2_8w_waveid_raw")
  rawr = scan_resources(raw)
  assert rawr.accvgprs == 0 and rawr.regular_vgprs <= 113, rawr
  rt = [repr(x) for x in raw]
  shift_i = rt.index("v_lshrrev_b32_e32(v[103], 6)")
  read_i = rt.index("v_readfirstlane_b32_e32(v[49], v[103])")
  assert read_i - shift_i == 4, (shift_i, read_i, rt[shift_i:read_i+1])
  assert rt[read_i+1] == "s_nop(3)", rt[read_i:read_i+3]
  print(f"phase2_8w_waveid_raw resources: {rawr.one_line()}")

  # Phase-2 allocation probes must stay genuinely disentangled.  In particular,
  # wavefill is forbidden from touching AccVGPRs and accscalar* may touch only AccVGPR0.
  alloc_expect = {
    "phase2_8w_wavefill": (113, 0, 0, 120),
    "phase2_8w_accscalar": (113, 1, 116, 120),
    "phase2_8w_accscalar128": (128, 1, 128, 136),
    "phase2_8w_accscalar252": (252, 1, 252, 256),
    "phase2_8w_accwave128": (128, 128, 128, 256),
    "phase2_8w_accwave252": (252, 128, 252, 384),
  }
  for variant, expected in alloc_expect.items():
    r = scan_resources(build_kernel(256, 4096, 4096, 256, 256, variant))
    got = (r.regular_vgprs, r.accvgprs, r.accum_offset, r.allocated_combined_vgprs)
    assert got == expected, (variant, got, expected, r)
    print(f"{variant:24s} allocation: {r.one_line()} offset={r.accum_offset}")

  # Identity must be rejected once the reference WGM32 mapper starts reordering tiles.
  try: build_kernel(16384, 14336, 4096, 256, 256, "identity")
  except ValueError: pass
  else: raise AssertionError("identity unexpectedly accepted Ntiles>32")
  print("codegen + mapper semantics checks passed")


if __name__ == "__main__": main()
