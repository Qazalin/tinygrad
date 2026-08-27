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

  # Phase-2 serial staging uses one reference LDS buffer per BK256. Four loader
  # waves * 8 x4/lane loads = exactly 32 KiB packed A, and 4 * 2 dword/lane
  # loads = exactly 2 KiB A scales. The reference's second 33792-byte region is
  # the software-pipelined *next* BK buffer, not more data for this BK.
  p2t = [repr(x) for x in p2]
  a_x4 = [x for x in p2t if x.startswith("buffer_load_dwordx4(v[0:3]") and x.endswith(", 1)")]
  a_sc = [x for x in p2t if x.startswith("buffer_load_dword(v[0]") and x.endswith(", 1)")]
  assert len(a_x4) == 8, (len(a_x4), a_x4)
  assert len(a_sc) == 2, (len(a_sc), a_sc)

  # Critical input-address invariant: the reference address math uses the full
  # logical 4-wave local thread id (wave_n*64 + lane), not lane alone. Physical
  # waves 4..7 must therefore fold local_id modulo 256 before reusing the
  # reference A/B/scale/LDS transforms. Prove the exact offsets lost by the old
  # lane-only implementation and the equivalence of logical_tid for both M cohorts.
  for wave_m in range(2):
    for wave_n in range(4):
      for lane in range(64):
        physical_tid = (wave_m*4 + wave_n)*64 + lane
        logical_tid = physical_tid & 255
        assert logical_tid == wave_n*64 + lane
        def af(t:int) -> int:
          x = t >> 3
          return ((x >> 2) << 4) + (((x & 3) >> 1) << 2) + (x & 1)
        def lds(t:int) -> int:
          return 1056*(2*((t & 15) >> 3) + ((t & 3) >> 1)) + 256*((t & 7) >> 2) + 128*(t & 1) + 16*(t >> 4) + 4096
        # wave0 is the only case where lane-only accidentally matched reference.
        assert af(logical_tid) - af(lane) == 32*wave_n
        assert lds(logical_tid) - lds(lane) == 64*wave_n
        assert 16*logical_tid - 16*lane == 1024*wave_n  # packed-B vaddr
        assert 4*logical_tid - 4*lane == 256*wave_n    # A/B scale vaddr
  assert "v_and_b32_e32(v[115], LIT, v[0], 255)" in p2t

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
  # Direct-load 8-wave resource gate.  This path has no LDS/M0/barrier instructions
  # and deliberately uses the GPU-proven 128+128 split.
  from extra.gemm.cdna_lib.phase2_direct import build_direct_kernel, build_direct_pingpong_kernel
  direct = build_direct_kernel(16384, 4096, 4096, fast=False)
  # VOP3 cannot carry a trailing literal dword.  The old direct kernel emitted
  # v_mul_lo_u32(v104, LIT, v112, half_k), which serialized src0/src2 as the
  # literal marker without encoding half_k at all.  Reject that class of bug
  # by inspecting the actual instruction objects, not the source formula.
  from tinygrad.renderer.amd.dsl import Reg
  for inst in direct:
    if type(inst).__name__.startswith("VOP3") and type(inst).__name__ != "VOP3PX2":
      for field in ("src0", "src1", "src2"):
        val = getattr(inst, field, None)
        assert not (isinstance(val, Reg) and val.offset == 255), (inst, field, inst.to_bytes().hex())
  dt = [repr(x) for x in direct]
  assert any(x.startswith("v_mul_i32_i24_e32(v[104], LIT, v[112]") for x in dt), [x for x in dt if "v[104]" in x and "mul" in x]
  dr = scan_resources(direct)
  assert dr.regular_vgprs == 128 and dr.accvgprs == 128 and dr.allocated_combined_vgprs == 256, dr
  text = "\n".join(map(repr, direct))
  assert "ds_read" not in text and "s_barrier" not in text and "s_mov_b32(NULL" not in text
  assert text.count("buffer_load_ubyte") == 12 * 2, text.count("buffer_load_ubyte")
  assert text.count("v_mfma_scale_f32_16x16x128_f8f6f4") == 64, text.count("v_mfma_scale_f32_16x16x128_f8f6f4")
  print("phase2_direct resources:", dr.one_line())
  pp = build_direct_pingpong_kernel(16384, 4096, 4096)
  for inst in pp:
    if type(inst).__name__.startswith("VOP3") and type(inst).__name__ != "VOP3PX2":
      for field in ("src0", "src1", "src2"):
        val = getattr(inst, field, None)
        assert not (isinstance(val, Reg) and val.offset == 255), (inst, field, inst.to_bytes().hex())
  ppt = [repr(x) for x in pp]
  assert any(x.startswith("v_mul_i32_i24_e32(v[124], LIT, v[121]") for x in ppt), [x for x in ppt if "v[124]" in x and "mul" in x]
  ppr = scan_resources(pp)
  assert ppr.regular_vgprs == 128 and ppr.accvgprs == 128 and ppr.allocated_combined_vgprs == 256, ppr
  pptext = "\n".join(map(repr, pp))
  assert "ds_read" not in pptext and "s_barrier" not in pptext
  assert pptext.count("v_mfma_scale_f32_16x16x128_f8f6f4") == 64
  print("phase2_direct_pingpong resources:", ppr.one_line())

  # 4-wave 128x256 Phase 2: same 128x64 wave tile, but two WGs/CU.
  from extra.gemm.cdna_lib.phase2_4w import build_4w_kernel, USED_LDS_BYTES as W4_USED, LDS_BYTES as W4_LDS
  for direct in (False, True):
    w4 = build_4w_kernel(16384,4096,4096,direct_lds=direct)
    w4r = scan_resources(w4)
    assert (w4r.regular_vgprs,w4r.accvgprs,w4r.accum_offset,w4r.allocated_combined_vgprs)==(128,128,128,256), w4r
    assert W4_USED == 16384 and W4_LDS == 16640 and 2*W4_LDS < 160*1024
    print(("phase2_4w_d2l" if direct else "phase2_4w")+" resources:", w4r.one_line())

  # 4-wave 64x256 max-residency Phase 2: 64 accumulators keep combined allocation at 128.
  from extra.gemm.cdna_lib.phase2_4w64 import build_4w64_kernel, USED_LDS_BYTES as W64_USED, LDS_BYTES as W64_LDS
  for progressive in (False,True):
    w64=build_4w64_kernel(16384,4096,4096,progressive=progressive)
    w64r=scan_resources(w64)
    assert (w64r.regular_vgprs,w64r.accvgprs,w64r.accum_offset,w64r.allocated_combined_vgprs)==(62,64,64,128),w64r
    assert W64_USED==8192 and W64_LDS==8960 and 4*W64_LDS<160*1024
    print(("phase2_4w64_pipe" if progressive else "phase2_4w64")+" resources:",w64r.one_line(),f"lds={W64_USED}/{W64_LDS}")

  # Transparent-LDS Phase 2: same 128+128 residency, 68 KiB live LDS bytes.
  from extra.gemm.cdna_lib.phase2_lds import build_lds_kernel, USED_LDS_BYTES, LDS_BYTES
  lds = build_lds_kernel(16384, 4096, 4096)
  lr = scan_resources(lds)
  assert (lr.regular_vgprs, lr.accvgprs, lr.accum_offset, lr.allocated_combined_vgprs) == (128,128,128,256), lr
  ltext = "\n".join(map(repr, lds))
  assert ltext.count("ds_write_b128") == 8 and ltext.count("ds_write_b32") == 2
  assert ltext.count("ds_read_b128") == 24 and ltext.count("ds_read_b32") == 6
  assert ltext.count("s_barrier") == 2 and ltext.count("v_mfma_scale_f32_16x16x128_f8f6f4") == 64
  assert USED_LDS_BYTES == 68*1024 and LDS_BYTES == 70*1024
  print("phase2_lds resources:", lr.one_line(), f"lds={USED_LDS_BYTES}/{LDS_BYTES}")

  print("codegen + mapper semantics checks passed")


if __name__ == "__main__": main()
