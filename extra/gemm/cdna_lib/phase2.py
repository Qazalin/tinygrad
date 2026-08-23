"""Phase-2 short-K kernel for gfx950 MXFP4.

Target: Mx4096x4096, 256x256 workgroup tile, 8 wave64s (2M x 4N).
Each wave owns 128x64 output -> 128 AccVGPRs instead of the reference 256.

This first prototype deliberately uses a serialized single-LDS-stage K loop.  It is
meant to test the occupancy hypothesis with a hard <=256 combined-VGPR target before
we spend complexity on ping-pong prefetching.
"""
# ruff: noqa: F403,F405,E501
from tinygrad.runtime.autogen.amd.cdna.ins import *
import functools
from extra.gemm.gemm_mxfp4 import Kernel, build_kernel as build_reference_kernel, v_mfma_fp4

TILE_M = 256
TILE_N = 256
THREADS = 512
# Keep the reference LDS allocation for Phase 2. The experiment is register/wave residency,
# not LDS-size reduction; using 160 KiB removes LDS allocation as a runtime variable.
LDS_BYTES = 160 * 1024


@functools.cache
def _mfma_half_template():
  """Return the reference's first 128x64 output-half MFMA pattern and issue gaps.

  The reference deliberately interleaves LDS/VMEM/SALU work between many MFMAs.
  The gap vector records the number of issued instructions between consecutive
  matrix instructions so a diagnostic schedule can preserve those wait states.
  """
  ref = build_reference_kernel(16384, 4096, 4096, 256, 256)
  mfma_pos = [i for i, x in enumerate(ref) if repr(x).startswith("v_mfma_scale_f32_16x16x128_f8f6f4")]
  mfmas = [ref[i] for i in mfma_pos]
  assert len(mfmas) >= 128
  first = tuple(mfmas[:64])
  gaps = tuple(mfma_pos[i+1] - mfma_pos[i] - 1 for i in range(63))
  # This is the architectural split we depend on: first 64 write acc0..127,
  # the next half starts at acc128 in the 1M x 4N reference wave tile.
  assert all(x.vdst.offset - 256 < 128 for x in first)
  assert mfmas[64].vdst.offset - 256 >= 128
  # Prove the lower 128x64 half is structurally the same schedule after the
  # expected accumulator/A/A-scale renaming.
  for a, b in zip(mfmas[:64], mfmas[64:128]):
    assert b.vdst.offset == a.vdst.offset + 128
    assert b.src0.offset == a.src0.offset
    assert b.src1.offset == a.src1.offset + 64
    assert b.opsel == a.opsel and b.opsel_hi == a.opsel_hi
    assert b.scale_src0 == a.scale_src0 and b.scale_src1 == a.scale_src1 + 4
  return first, gaps


def _emit_mfma_half(k: Kernel, padding: str = "none") -> None:
  """Remap the known-good first-half schedule into the low-VGPR register plan.

  padding=refgap preserves the reference's MFMA-to-MFMA issue distance using
  scalar NOP wait states. padding=nop7 is a deliberately conservative hazard
  diagnostic, not a performance schedule.
  """
  mfmas, gaps = _mfma_half_template()
  for idx, x in enumerate(mfmas):
    if idx:
      if padding == "refgap":
        if gaps[idx-1]: k.emit(s_nop(gaps[idx-1]-1))
      elif padding == "nop7": k.emit(s_nop(7))
      elif padding != "none": raise ValueError(f"unknown MFMA padding {padding}")
    dst = x.vdst.offset - 256
    src0 = x.src0.offset - 256   # reference B data: v136..167
    src1 = x.src1.offset - 256   # reference A data: v8..71
    sc0 = x.scale_src0 - 256     # reference B scale: v208..209
    sc1 = x.scale_src1 - 256     # reference A scale: v200..203
    assert 136 <= src0 <= 167 and 8 <= src1 <= 71
    assert 208 <= sc0 <= 209 and 200 <= sc1 <= 203
    # new: A=v0..63, B=v64..95, A-scale=v96..99, B-scale=v100..101.
    k.emit(v_mfma_fp4(v[dst:dst+3], v[src0-72:src0-69], v[src1-8:src1-5],
                       x.opsel, x.opsel_hi, v[100 + (sc0-208)], v[96 + (sc1-200)]))


def _emit_mfma_half_refregs(k: Kernel) -> None:
  """Emit the same 64 reference MFMAs using their original architectural VGPR numbers.

  This is a correctness control for the compact register remap. Accumulators remain
  acc0..127, but A/B/scales live at exactly the reference locations.
  """
  mfmas, _ = _mfma_half_template()
  for x in mfmas:
    dst = x.vdst.offset - 256
    src0 = x.src0.offset - 256
    src1 = x.src1.offset - 256
    sc0 = x.scale_src0 - 256
    sc1 = x.scale_src1 - 256
    k.emit(v_mfma_fp4(v[dst:dst+3], v[src0:src0+3], v[src1:src1+3],
                       x.opsel, x.opsel_hi, v[sc0], v[sc1]))


def _copy_compact_operands_to_reference_regs(k: Kernel) -> None:
  """Copy the already-loaded compact operand set to the exact reference VGPR indices.

  Copy B/scales first, then A in descending order because reference A v8..71 overlaps
  compact A v0..63 and compact B v64..95. This keeps the loaded bytes unchanged and
  changes only the physical register numbers seen by MFMA.
  """
  # B v64..95 -> v136..167
  for i in range(32): k.emit(v_mov_b32_e32(v[136+i], v[64+i]))
  # scales: compact B v100..101 -> reference v208..209; A v96..99 -> v200..203
  for i in range(2): k.emit(v_mov_b32_e32(v[208+i], v[100+i]))
  for i in range(4): k.emit(v_mov_b32_e32(v[200+i], v[96+i]))
  # A v0..63 -> v8..71, descending to preserve overlapping sources.
  for i in range(63, -1, -1): k.emit(v_mov_b32_e32(v[8+i], v[i]))


def _emit_a_reads(k: Kernel) -> None:
  """Read the appropriate 128-row A half from the reference LDS swizzle."""
  # (destination start in old reference, offset0, offset1) for rows 0..127.
  reads = (
    (8, 0, 0), (40, 64, 0), (12, 0, 2), (44, 64, 2),
    (16, 128, 16), (48, 192, 16), (20, 128, 18), (52, 192, 18),
    (24, 0, 33), (56, 64, 33), (28, 0, 35), (60, 64, 35),
    (32, 128, 49), (64, 192, 49), (36, 128, 51), (68, 192, 51),
  )
  k.emit(s_cmp_eq_u32(s[51], 0))
  k.emit(s_cbranch_scc0(1), target="A_READ_M1")
  for old_dst, off0, off1 in reads:
    nd = old_dst - 8
    k.emit(ds_read_b128(v[nd:nd+3], v[108], v[0], v[0], 0, off0, off1))
  for i in range(4): k.emit(ds_read_b32(v[96+i], v[110], v[0], v[0], 0, 0, i))
  k.emit(s_branch(1), target="A_READ_DONE")
  k.label("A_READ_M1")
  for old_dst, off0, off1 in reads:
    nd = old_dst - 8
    k.emit(ds_read_b128(v[nd:nd+3], v[108], v[0], v[0], 0, off0, off1 + 66))
  for i in range(4): k.emit(ds_read_b32(v[96+i], v[110], v[0], v[0], 0, 0, i + 4))
  k.label("A_READ_DONE")


def _emit_a_global_to_lds(k: Kernel) -> None:
  """Only wave_m==0 loads the shared 256-row A tile and scales into LDS."""
  k.emit(s_cmp_eq_u32(s[51], 0))
  k.emit(s_cbranch_scc0(1), target="A_LOAD_DONE")
  # A FP4: 8 x 16B/lane loads, each block 32 rows apart in the shuffled layout.
  for i in range(8):
    k.emit(s_add_u32(NULL, s[59], 0) if i == 0 else s_add_u32(NULL, LIT, s[59], i * 4224))
    if i == 0:
      k.emit(buffer_load_dwordx4(v[0:3], v[104], s[12:15], 0, 0, 1, 0, 0, 0, 0, 1))
    else:
      k.emit(v_add_u32_e32(v[112], LIT, v[104], i * 65536))
      k.emit(buffer_load_dwordx4(v[0:3], v[112], s[12:15], 0, 0, 1, 0, 0, 0, 0, 1))
  # A scales: two dwords/lane, for row halves 0..127 and 128..255.
  k.emit(s_add_u32(NULL, s[60], 0))
  k.emit(buffer_load_dword(v[0], v[106], s[20:23], 0, 0, 1, 0, 0, 0, 0, 1))
  k.emit(s_add_u32(NULL, LIT, s[60], 1024))
  k.emit(v_add_u32_e32(v[112], LIT, v[106], 16384))
  k.emit(buffer_load_dword(v[0], v[112], s[20:23], 0, 0, 1, 0, 0, 0, 0, 1))
  k.label("A_LOAD_DONE")


def _emit_b_global(k: Kernel) -> None:
  """Load this wave_n's 64x256 B slice + scales into low VGPRs.

  wave_m pairs intentionally duplicate B in this prototype. That keeps the kernel
  simple enough to isolate occupancy; a follow-up can share B through LDS if useful.
  """
  # 4 row-16 groups for first K half, then the corresponding +1024-byte K half.
  for j in range(4):
    if j == 0: addr = v[105]
    else:
      k.emit(v_add_u32_e32(v[112], LIT, v[105], j * 32768))
      addr = v[112]
    k.emit(buffer_load_dwordx4(v[64+j*4:67+j*4], addr, s[16:19], 0, 0, 1))
  for j in range(4):
    k.emit(v_add_u32_e32(v[112], LIT, v[105], 1024 + j * 32768))
    k.emit(buffer_load_dwordx4(v[80+j*4:83+j*4], v[112], s[16:19], 0, 0, 1))
  k.emit(buffer_load_dword(v[100], v[107], s[24:27], 0, 0, 1))
  k.emit(v_add_u32_e32(v[112], LIT, v[107], 4096))
  k.emit(buffer_load_dword(v[101], v[112], s[24:27], 0, 0, 1))


def _advance_k_descriptors(k: Kernel) -> None:
  for base, size, delta in ((12,14,128), (16,18,2048), (20,22,256), (24,26,256)):
    k.emit(s_add_u32(s[base], LIT, s[base], delta))
    k.emit(s_addc_u32(s[base+1], 0, s[base+1]))
    k.emit(s_sub_u32(s[size], s[size], delta))


def _emit_epilogue(k: Kernel, N: int, read_acc: bool = True, zero_regs: bool = True) -> None:
  """Store one wave's 128x64 BF16 tile.

  Keep the C descriptor base exactly reference-style at m_tile*256 rows. wave_m is
  represented only as a vector byte offset (+0 or +128 rows). This avoids mutating
  the descriptor base differently across the two M-wave cohorts.
  """
  k.emit(s_mov_b32(s[54], LIT, N * 2))  # output row stride in bytes

  # Reference descriptor setup: shift only by the 256-row workgroup M tile.
  k.emit(s_mul_i32(s[52], s[47], LIT, 256))
  k.emit(s_mul_hi_u32(s[53], s[52], s[54]))
  k.emit(s_add_u32(s[5], s[5], s[53]))
  k.emit(s_mul_i32(s[53], s[52], s[54]))
  k.emit(s_add_u32(s[4], s[4], s[53]))
  k.emit(s_addc_u32(s[5], 0, s[5]))
  k.emit(s_sub_i32(s[52], s[43], s[52]))
  k.emit(s_mul_i32(s[52], s[52], s[54]))
  k.emit(s_mov_b32(s[6], s[52]))

  # Reference lane-local address within the 256-row WG tile.
  k.emit(v_and_b32_e64(v[111], v[102], 15))
  k.emit(v_mul_lo_u32(v[111], v[111], s[54]))
  k.emit(v_lshrrev_b32_e32(v[112], 5, v[102]))
  k.emit(v_mul_i32_i24_e32(v[112], 16, v[112]))
  k.emit(v_add_u32_e32(v[111], v[112], v[111]))
  k.emit(v_lshrrev_b32_e32(v[112], 4, v[102]))
  k.emit(v_and_b32_e32(v[112], 1, v[112]))
  k.emit(v_mul_i32_i24_e32(v[112], 32, v[112]))
  k.emit(v_add_u32_e32(v[111], v[112], v[111]))
  k.emit(s_mul_i32(s[52], s[46], LIT, 256))
  k.emit(s_mul_i32(s[53], s[50], 64))
  k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_lshl_b32(s[52], s[52], 1))
  k.emit(v_add_u32_e32(v[111], s[52], v[111]))

  # wave_m=1 owns rows 128..255; express that only in vaddr.
  k.emit(s_mul_i32(s[52], s[51], 128))
  k.emit(s_mul_i32(s[52], s[52], s[54]))
  k.emit(v_add_u32_e32(v[111], s[52], v[111]))

  # After two 64-byte column advances, jump to the next 16-row block.
  k.emit(s_mov_b32(s[55], LIT, 16 * 8192 - 128))

  if not read_acc and zero_regs:
    for i in range(4): k.emit(v_mov_b32_e32(v[16+i], 0))

  for r in range(8):
    for half in range(2):
      if read_acc:
        base = half * 64 + r * 4
        for i in range(2):
          for j in range(4):
            k.emit(v_accvgpr_read(v[j + i*4], v[base + j + i*32]))
        for i in range(4): k.emit(v_cvt_pk_bf16_f32(v[16+i], v[i*2], v[i*2+1]))
        k.emit(s_nop(1))
        k.emit(v_permlane16_swap_b32_e32(v[16], v[18]))
        k.emit(s_nop(1))
        k.emit(v_permlane16_swap_b32_e32(v[17], v[19]))
        k.emit(s_nop(1))
      k.emit(buffer_store_dwordx4(v[16:19], v[111], s[4:7], 0, 0, 1))
      k.emit(v_add_i32(v[111], v[111], 64))
    if r != 7: k.emit(v_add_u32_e32(v[111], s[55], v[111]))


def _emit_waveid_raw(k: Kernel, M: int, N: int) -> None:
  """Minimal wave-id probe with no tiled epilogue and no AccVGPRs.

  Each wave writes 64 dwords to a private 256-byte region at the beginning of C.
  Each dword contains two identical BF16 copies of float(wave_id+1). Thus the
  first 1024 BF16 elements encode eight 128-element constant runs.
  """
  # Make the C resource span the full output; no reference epilogue descriptor math.
  k.emit(s_mov_b32(s[6], LIT, M * N * 2))
  k.emit(v_mov_b32_e32(v[0], s[49]))
  k.emit(v_add_u32_e32(v[0], 1, v[0]))
  k.emit(v_cvt_f32_u32_e32(v[0], v[0]))
  k.emit(v_cvt_pk_bf16_f32(v[16], v[0], v[0]))
  k.emit(s_nop(1))  # keep packed writedata safely ahead of VMEM consume
  # wave_id * (64 lanes * 4 bytes) + lane_id * 4
  k.emit(s_lshl_b32(s[52], s[49], 8))
  k.emit(v_lshlrev_b32_e32(v[111], 2, v[102]))
  k.emit(v_add_u32_e32(v[111], s[52], v[111]))
  k.emit(buffer_store_dword(v[16], v[111], s[4:7], 0, 0, 1))
  k.emit(s_waitcnt())
  k.emit(s_endpgm())


def _emit_wave_constant(k: Kernel, N: int, through_acc: bool) -> None:
  """Fill this wave's 128x64 output tile with float(wave_id+1).

  With through_acc=False this validates wave-id extraction and C ownership using
  only architectural VGPRs. With through_acc=True it routes the same scalar through
  AccVGPR0 exactly once, isolating the physical AccVGPR split from MFMA and from the
  128-register accumulator file.
  """
  k.emit(v_mov_b32_e32(v[0], s[49]))
  k.emit(v_add_u32_e32(v[0], 1, v[0]))
  k.emit(v_cvt_f32_u32_e32(v[0], v[0]))
  if through_acc:
    k.emit(v_accvgpr_write(v[0], v[0]))
    for _ in range(4): k.emit(s_nop(7))
    k.emit(s_barrier())
    k.emit(v_accvgpr_read(v[0], v[0]))
    for _ in range(2): k.emit(s_nop(7))
  else:
    k.emit(s_barrier())

  for i in range(4): k.emit(v_cvt_pk_bf16_f32(v[16+i], v[0], v[0]))
  for _ in range(2): k.emit(s_nop(7))
  _emit_epilogue(k, N, read_acc=False, zero_regs=False)
  k.emit(s_waitcnt())
  k.emit(s_endpgm())


def build_phase2_kernel(M: int, N: int, K: int, mode: str = "full"):
  if mode not in ("full", "barrier", "store", "load", "acczero", "accwave", "accwave128", "accwave252",
                  "waveid_raw", "wavefill", "accscalar", "accscalar128", "accscalar252",
                  "acc128", "acc252", "refregs", "refgap", "nop7", "postgap", "fast", "compact"):

    raise ValueError(f"unknown phase2 mode {mode}")
  if M % 256 or N % 256 or K % 256:
    raise ValueError(f"phase2_8w requires M/N/K multiples of 256; got {M}x{N}x{K}")
  k = Kernel()
  half_k, scale_k = K // 2, K // 32

  # Kernarg pointers and buffer descriptors. Keep the same descriptor conventions as reference.
  k.emit(s_and_b32(s[1], s[1], LIT, 65535))
  k.emit(s_load_dwordx2(s[4:5], s[0:1], s[0], 0, 0, 0, 0, 1))      # C
  k.emit(s_load_dwordx2(s[12:13], s[0:1], s[0], 8, 0, 0, 0, 1))    # A
  k.emit(s_load_dwordx2(s[16:17], s[0:1], s[0], 16, 0, 0, 0, 1))   # B
  k.emit(s_load_dwordx2(s[20:21], s[0:1], s[0], 24, 0, 0, 0, 1))   # scale A
  k.emit(s_load_dwordx2(s[24:25], s[0:1], s[0], 32, 0, 0, 0, 1))   # scale B
  k.emit(s_waitcnt())  # do not modify descriptor high words before scalar loads retire
  k.emit(s_mov_b32(s[8], 0)); k.emit(s_mov_b32(s[9], 0))
  for hi in (5, 9, 13, 17, 21, 25):
    k.emit(s_and_b32(s[hi], s[hi], LIT, 65535))
    k.emit(s_or_b32(s[hi], s[hi], LIT, 262144))
  for size in (6, 10, 14, 18): k.emit(s_mov_b32(s[size], -16))
  for cfg in (7, 11, 15, 19, 23, 27): k.emit(s_mov_b32(s[cfg], LIT, 131072))
  k.emit(s_mov_b32(s[14], LIT, M * half_k))
  k.emit(s_mov_b32(s[18], LIT, N * half_k))
  k.emit(s_mov_b32(s[22], LIT, M * scale_k))
  k.emit(s_mov_b32(s[26], LIT, N * scale_k))
  k.emit(s_mov_b32(s[40], N)); k.emit(s_mov_b32(s[43], M))

  # Fixed identity mapper for Ntiles=16, and 2M x 4N wave decomposition.
  # IMPORTANT: keep the v103 -> v_readfirstlane dependency distance source-faithful.
  # The known-good reference computes wave_id, then issues three independent ops before
  # V_READFIRSTLANE consumes it. CDNA4 requires software wait distance on VGPR->lane-read.
  k.emit(v_lshrrev_b32_e32(v[103], 6, v[0]))
  k.emit(v_and_b32_e32(v[102], LIT, v[0], 63))
  k.emit(s_mov_b32(s[46], s[2]))  # n tile
  k.emit(s_mov_b32(s[47], s[3]))  # m tile
  k.emit(v_readfirstlane_b32_e32(v[49], v[103]))
  # Be conservative on the VALU->SGPR result before SALU consumers. The reference
  # leaves a long gap here; four explicit scalar wait states make the probe deterministic.
  k.emit(s_nop(3))
  k.emit(s_and_b32(s[50], s[49], 3))  # wave_n
  k.emit(s_lshr_b32(s[51], s[49], 2)) # wave_m

  # Keep wave-identity/allocation diagnostics minimal: return before any A/B/LDS setup.
  if mode == "waveid_raw":
    _emit_waveid_raw(k, M, N)
    return k.finalize()
  if mode == "wavefill":
    _emit_wave_constant(k, N, through_acc=False)
    return k.finalize()
  if mode in ("accscalar", "accscalar128", "accscalar252"):
    if mode == "accscalar128": k.emit(v_mov_b32_e32(v[127], 0))
    if mode == "accscalar252": k.emit(v_mov_b32_e32(v[251], 0))
    _emit_wave_constant(k, N, through_acc=True)
    return k.finalize()
  if mode in ("accwave", "accwave128", "accwave252"):
    if mode == "accwave128": k.emit(v_mov_b32_e32(v[127], 0))
    if mode == "accwave252": k.emit(v_mov_b32_e32(v[251], 0))
    k.emit(v_mov_b32_e32(v[0], s[49]))
    k.emit(v_add_u32_e32(v[0], 1, v[0]))
    k.emit(v_cvt_f32_u32_e32(v[0], v[0]))
    for i in range(128): k.emit(v_accvgpr_write(v[i], v[0]))
    for _ in range(4): k.emit(s_nop(7))
    k.emit(s_barrier())
    _emit_epilogue(k, N, read_acc=True)
    k.emit(s_waitcnt())
    k.emit(s_endpgm())
    return k.finalize()

  # A global shuffled address (same arithmetic as reference, using wave_n as loader-wave).
  k.emit(v_lshrrev_b32_e32(v[112], 3, v[102]))
  k.emit(v_lshrrev_b32_e32(v[113], 2, v[112]))
  k.emit(v_lshlrev_b32_e32(v[113], 4, v[113]))
  k.emit(v_and_b32_e32(v[112], 3, v[112]))
  k.emit(v_lshrrev_b32_e32(v[114], 1, v[112]))
  k.emit(v_lshlrev_b32_e32(v[114], 2, v[114]))
  k.emit(v_add_u32_e32(v[113], v[113], v[114]))
  k.emit(v_and_b32_e32(v[112], 1, v[112]))
  k.emit(v_add_u32_e32(v[113], v[113], v[112]))
  k.emit(v_mul_lo_u32(v[104], LIT, v[113], half_k))
  k.emit(v_and_b32_e32(v[112], LIT, v[102], 7))
  k.emit(v_lshlrev_b32_e32(v[112], 4, v[112]))
  k.emit(v_add_u32_e32(v[104], v[104], v[112]))
  k.emit(s_lshr_b32(s[52], s[50], 1))
  k.emit(s_mul_i32(s[52], s[52], 8))
  k.emit(s_and_b32(s[53], s[50], 1))
  k.emit(s_mul_i32(s[53], s[53], 2))
  k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[53], s[47], LIT, 256))
  k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[52], LIT, s[52], half_k))
  k.emit(v_add_u32_e32(v[104], s[52], v[104]))
  k.emit(s_mul_i32(s[59], LIT, s[50], 1056))
  k.emit(s_add_u32(s[59], LIT, s[59], 4096))

  # A LDS read address, identical for both wave_m halves; DS offset1 selects the half.
  k.emit(v_and_b32_e32(v[112], LIT, v[102], 15))
  k.emit(v_lshrrev_b32_e32(v[113], 3, v[112]))
  k.emit(v_mul_i32_i24_e32(v[113], 2, v[113]))
  k.emit(v_and_b32_e32(v[112], 3, v[112]))
  k.emit(v_lshrrev_b32_e32(v[114], 1, v[112]))
  k.emit(v_add_u32_e32(v[112], v[113], v[114]))
  k.emit(v_mul_i32_i24_e32(v[108], LIT, v[112], 1056))
  k.emit(v_and_b32_e32(v[112], LIT, v[102], 7))
  k.emit(v_lshrrev_b32_e32(v[113], 2, v[112]))
  k.emit(v_mul_i32_i24_e32(v[113], LIT, v[113], 256))
  k.emit(v_add_u32_e32(v[108], v[113], v[108]))
  k.emit(v_and_b32_e32(v[112], 1, v[112]))
  k.emit(v_mul_i32_i24_e32(v[114], LIT, v[112], 128))
  k.emit(v_add_u32_e32(v[108], v[114], v[108]))
  k.emit(v_lshrrev_b32_e32(v[112], 4, v[102]))
  k.emit(v_mul_i32_i24_e32(v[112], 16, v[112]))
  k.emit(v_add_u32_e32(v[108], v[112], v[108]))
  k.emit(v_add_u32_e32(v[108], LIT, v[108], 4096))
  k.emit(v_lshlrev_b32_e32(v[110], 2, v[102]))

  # A scale global address; loaders are wave_m0 only.
  k.emit(v_lshlrev_b32_e32(v[106], 2, v[102]))
  k.emit(s_mul_i32(s[52], s[47], LIT, 256))
  k.emit(s_mul_i32(s[53], s[50], 32))
  k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[53], LIT, s[52], scale_k))
  k.emit(v_add_u32_e32(v[106], s[53], v[106]))
  k.emit(s_mul_i32(s[60], s[50], LIT, 256))

  # B global shuffled address for this wave_n.
  k.emit(v_lshlrev_b32_e32(v[105], 4, v[102]))
  k.emit(s_mul_i32(s[52], s[46], LIT, 256))
  k.emit(s_mul_i32(s[53], s[50], 64))
  k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[52], LIT, s[52], half_k))
  k.emit(v_add_u32_e32(v[105], s[52], v[105]))
  k.emit(v_lshlrev_b32_e32(v[107], 2, v[102]))
  k.emit(s_mul_i32(s[52], s[46], LIT, 256))
  k.emit(s_mul_i32(s[53], s[50], 64))
  k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[53], LIT, s[52], scale_k))
  k.emit(v_add_u32_e32(v[107], s[53], v[107]))

  # Force selected architectural-VGPR/AccVGPR split points for allocator probes.
  # Do NOT bulk-touch AccVGPRs in wavefill/accscalar: those probes deliberately isolate
  # normal-VGPR wave identity and AccVGPR0 respectively.
  if mode in ("full", "fast", "acc128", "accwave128", "accscalar128"): k.emit(v_mov_b32_e32(v[127], 0))
  if mode in ("acc252", "accwave252", "accscalar252"): k.emit(v_mov_b32_e32(v[251], 0))

  bulk_acc_modes = {"full", "fast", "compact", "acczero", "accwave", "accwave128", "accwave252",
                    "acc128", "acc252", "refregs", "refgap", "nop7", "postgap"}
  if mode in bulk_acc_modes:
    for i in range(128): k.emit(v_accvgpr_write(v[i], 0))
  k.emit(s_waitcnt())  # kernarg scalar loads/descriptors settled before memory traffic

  if mode == "barrier":
    k.emit(s_barrier())
    k.emit(s_waitcnt())
    k.emit(s_endpgm())
    return k.finalize()
  if mode == "store":
    _emit_epilogue(k, N, read_acc=False)
    k.emit(s_waitcnt())
    k.emit(s_endpgm())
    return k.finalize()
  if mode == "acczero":
    # Exercise the new AccVGPR allocation + read/pack/permlane/store path without
    # any MFMA. Give the AGPR writes an intentionally generous VALU->read gap.
    for _ in range(4): k.emit(s_nop(7))
    k.emit(s_barrier())
    _emit_epilogue(k, N, read_acc=True)
    k.emit(s_waitcnt())
    k.emit(s_endpgm())
    return k.finalize()

  # Fixed 16 x BK256 loop. Keep one body: besides avoiding I-cache bloat this makes
  # the wave-level A-load/read branches unambiguous in the finalized label table.
  k.emit(s_mov_b32(s[56], K // 256))
  k.label("K_LOOP")
  _emit_a_global_to_lds(k)
  _emit_b_global(k)
  k.emit(s_waitcnt())
  k.emit(s_barrier())
  # CDNA4 normal DS operations use M0 as an LDS byte-size clamp.  The direct-to-LDS
  # loads above temporarily use M0 as their destination offset, and wave_m=1 does not
  # execute those loads at all.  Set an explicit unclamped LDS size in every wave before
  # any ds_read.  This is required by the ISA and prevents valid A rows from reading zero.
  k.emit(s_mov_b32(NULL, -1))
  k.emit(s_nop())
  _emit_a_reads(k)
  k.emit(s_waitcnt())
  k.emit(s_barrier())  # all waves have finished LDS reads before loaders may reuse it
  if mode == "refregs":
    _copy_compact_operands_to_reference_regs(k)
    # CDNA4 requires two independent waits from a VALU write to an MFMA source read.
    k.emit(s_nop(1))
    _emit_mfma_half_refregs(k)
  else:
    _emit_mfma_half(k, "refgap" if mode == "refgap" else "nop7" if mode == "nop7" else "none")

  # CDNA4 matrix-core source/result retirement hazard. The 4-wave reference executes
  # another 64 scaled MFMAs after this 128x64 half, which naturally keeps its
  # A/B VGPRs alive long enough before the next BK256 iteration overwrites them.
  # In the 2M x 4N kernel each wave stops after 64 MFMAs, so that implicit drain
  # disappeared. Table 38 allows up to 20 required waits for a multi-pass MFMA
  # followed by VM/LDS/VALU access to overlapping VGPRs. s_nop(15) supplies 16
  # explicit wait states; the descriptor/loop-control instructions below supply
  # additional independent issue distance before any A/B/scale VGPR is written.
  # Keep this conservative version until GPU correctness is established; the
  # performance version will fill this window with useful next-tile work.
  if mode in ("full", "compact", "postgap", "acc128", "acc252", "refregs"):
    k.emit(s_nop(15))

  _advance_k_descriptors(k)
  k.emit(s_sub_u32(s[56], s[56], 1))
  k.emit(s_cmp_eq_u32(s[56], 0))
  k.emit(s_cbranch_scc0(1), target="K_LOOP")

  k.emit(s_waitcnt())
  k.emit(s_barrier())
  if mode == "load":
    k.emit(s_waitcnt())
    k.emit(s_endpgm())
    return k.finalize()
  _emit_epilogue(k, N)
  k.emit(s_waitcnt())
  k.emit(s_endpgm())
  return k.finalize()
