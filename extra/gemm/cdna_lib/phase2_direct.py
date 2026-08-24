"""Correctness-first 8-wave MXFP4 GEMM for gfx950 using direct MFMA-native loads.

Unlike the earlier Phase-2 prototype, this kernel does not reuse the reference's
workgroup LDS swizzle.  Each wave owns a 128x64 C tile and loads the exact
16x16x128 FP4 operands required by the CDNA4 MFMA directly from the quantized
rowwise layouts:

  A: unshuffled rowwise FP4
  B: 16-row x 32-packed-byte shuffled rowwise FP4
  scales: store_scale layout from quantize_mxfp4.cpp

The direct path intentionally trades cache traffic for a much smaller correctness
surface.  It keeps 128 AccVGPRs and forces a 128-register architectural VGPR split,
so the combined allocation is 256 registers/wave (2 waves/SIMD, 8 waves/CU).
"""
# ruff: noqa: F403,F405,E501
from tinygrad.runtime.autogen.amd.cdna.ins import *
from extra.gemm.gemm_mxfp4 import Kernel, v_mfma_fp4

TILE_M = TILE_N = 256
THREADS = 512
LDS_BYTES = 160 * 1024  # launch compatibility; the direct kernel issues no LDS ops


def _emit_epilogue(k: Kernel, M: int, N: int, lane_reg=v[102]) -> None:
  """Store this wave's 128x64 accumulator tile as BF16.

  The address mapping is the v8 wavefill-proven mapping, generalized so the
  row-block jump uses the actual N rather than the old N=4096 literal.
  """
  row_stride = N * 2
  k.emit(s_mov_b32(s[54], LIT, row_stride))

  # C resource begins at the 256-row workgroup M tile.
  k.emit(s_mul_i32(s[52], s[47], LIT, 256))
  k.emit(s_mul_hi_u32(s[53], s[52], s[54]))
  k.emit(s_add_u32(s[5], s[5], s[53]))
  k.emit(s_mul_i32(s[53], s[52], s[54]))
  k.emit(s_add_u32(s[4], s[4], s[53]))
  k.emit(s_addc_u32(s[5], 0, s[5]))
  k.emit(s_sub_i32(s[52], s[43], s[52]))
  k.emit(s_mul_i32(s[52], s[52], s[54]))
  k.emit(s_mov_b32(s[6], s[52]))

  # Native 16x16 MFMA output lane layout inside a 64-column wave tile.
  k.emit(v_and_b32_e64(v[111], lane_reg, 15))
  k.emit(v_mul_lo_u32(v[111], v[111], s[54]))
  k.emit(v_lshrrev_b32_e32(v[112], 5, lane_reg))
  k.emit(v_mul_i32_i24_e32(v[112], 16, v[112]))
  k.emit(v_add_u32_e32(v[111], v[112], v[111]))
  k.emit(v_lshrrev_b32_e32(v[112], 4, lane_reg))
  k.emit(v_and_b32_e32(v[112], 1, v[112]))
  k.emit(v_mul_i32_i24_e32(v[112], 32, v[112]))
  k.emit(v_add_u32_e32(v[111], v[112], v[111]))

  # Workgroup N tile + wave_n's 64 columns.
  k.emit(s_mul_i32(s[52], s[46], LIT, 256))
  k.emit(s_mul_i32(s[53], s[50], 64))
  k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_lshl_b32(s[52], s[52], 1))
  k.emit(v_add_u32_e32(v[111], s[52], v[111]))

  # wave_m=1 owns rows 128..255.
  k.emit(s_mul_i32(s[52], s[51], 128))
  k.emit(s_mul_i32(s[52], s[52], s[54]))
  k.emit(v_add_u32_e32(v[111], s[52], v[111]))

  # Each row-block emits two 64-byte column chunks.  After both chunks the
  # pointer has advanced 128 B, so jump by 16 rows minus that 128 B.
  k.emit(s_mov_b32(s[55], LIT, 16 * row_stride - 128))

  for mb in range(8):
    for nhalf in range(2):
      acc_base = nhalf * 64 + mb * 4
      for i in range(2):
        for j in range(4):
          k.emit(v_accvgpr_read(v[j + i*4], v[acc_base + j + i*32]))
      for i in range(4): k.emit(v_cvt_pk_bf16_f32(v[16+i], v[i*2], v[i*2+1]))
      k.emit(s_nop(1))
      k.emit(v_permlane16_swap_b32_e32(v[16], v[18]))
      k.emit(s_nop(1))
      k.emit(v_permlane16_swap_b32_e32(v[17], v[19]))
      k.emit(s_nop(1))
      k.emit(buffer_store_dwordx4(v[16:19], v[111], s[4:7], 0, 0, 1))
      k.emit(v_add_i32(v[111], v[111], 64))
    if mb != 7: k.emit(v_add_u32_e32(v[111], s[55], v[111]))


def _emit_half_loads(k: Kernel, half_k: int, K: int, half: int) -> None:
  """Load one K=128 contribution for all 8x4 native output blocks.

  Descriptor bases point at the beginning of the current BK256.  `half` selects
  K[0:128] or K[128:256] within that block.
  """
  assert half in (0, 1)
  a_koff = half * 64      # 128 FP4 values = 64 packed bytes
  b_koff = half * 1024    # shuffled B: +64 packed columns => +2*512 B tiles
  scale_half = half * 2   # scale bytes 0/1 vs 2/3 inside the packed dword
  row16_stride = 16 * half_k

  # A: eight 16-row native M blocks.  v104 already holds
  # (lane&15)*half_k + (lane>>4)*16.
  for mb in range(8):
    if mb == 0: k.emit(s_mov_b32(s[52], s[57]))
    else: k.emit(s_add_u32(s[52], s[57], LIT, mb * row16_stride))
    k.emit(v_add_u32_e32(v[100], s[52], v[104]))
    d = mb * 4
    k.emit(buffer_load_dwordx4(v[d:d+3], v[100], s[12:15], 0, a_koff, 1))

    # A scale byte.  For row_base multiple 16 and K32 base multiple 4,
    # store_scale simplifies to lane*4 + pair*K + parity + half*2.
    pair_off = (mb // 2) * K
    if pair_off == 0: k.emit(s_mov_b32(s[52], s[59]))
    else: k.emit(s_add_u32(s[52], s[59], LIT, pair_off))
    k.emit(v_add_u32_e32(v[100], s[52], v[106]))
    k.emit(buffer_load_ubyte(v[32+mb], v[100], s[20:23], 0, (mb & 1) + scale_half, 1))

  # B: four 16-column native N blocks.  v105=lane*16 exactly matches the
  # rowwise shuffled FP4 physical layout for a 16x128 MFMA operand.
  for nb in range(4):
    if nb == 0: k.emit(s_mov_b32(s[52], s[58]))
    else: k.emit(s_add_u32(s[52], s[58], LIT, nb * row16_stride))
    k.emit(v_add_u32_e32(v[100], s[52], v[105]))
    d = 40 + nb * 4
    k.emit(buffer_load_dwordx4(v[d:d+3], v[100], s[16:19], 0, b_koff, 1))

    pair_off = (nb // 2) * K
    if pair_off == 0: k.emit(s_mov_b32(s[52], s[60]))
    else: k.emit(s_add_u32(s[52], s[60], LIT, pair_off))
    k.emit(v_add_u32_e32(v[100], s[52], v[106]))
    k.emit(buffer_load_ubyte(v[56+nb], v[100], s[24:27], 0, (nb & 1) + scale_half, 1))


def _emit_half_mfma(k: Kernel) -> None:
  """Issue the 32 native 16x16x128 MFMAs for one 128x64 wave tile."""
  for nb in range(4):
    for mb in range(8):
      dst = nb * 32 + mb * 4
      # Direct scale loads put the exact E8M0 byte in bits[7:0], so both scale
      # byte selectors are zero.  Source ordering follows the known-good
      # reference: shuffled B is SRC0, unshuffled A is SRC1.
      k.emit(v_mfma_fp4(v[dst:dst+3], v[40+nb*4:43+nb*4], v[mb*4:mb*4+3],
                         0, 0, v[56+nb], v[32+mb]))


def _advance_bk256(k: Kernel) -> None:
  # The physical layouts advance by these exact byte counts per logical K=256.
  for base, size, delta in ((12,14,128), (16,18,2048), (20,22,256), (24,26,256)):
    k.emit(s_add_u32(s[base], LIT, s[base], delta))
    k.emit(s_addc_u32(s[base+1], 0, s[base+1]))
    k.emit(s_sub_u32(s[size], s[size], delta))


def build_direct_kernel(M: int, N: int, K: int, *, fast: bool = False):
  if M % 256 or N % 256 or K % 256:
    raise ValueError(f"phase2 direct requires M/N/K multiples of 256, got {M}x{N}x{K}")
  half_k, scale_k = K // 2, K // 32
  k = Kernel()

  # Kernargs and buffer resources.
  k.emit(s_and_b32(s[1], s[1], LIT, 65535))
  k.emit(s_load_dwordx2(s[4:5], s[0:1], s[0], 0, 0, 0, 0, 1))
  k.emit(s_load_dwordx2(s[12:13], s[0:1], s[0], 8, 0, 0, 0, 1))
  k.emit(s_load_dwordx2(s[16:17], s[0:1], s[0], 16, 0, 0, 0, 1))
  k.emit(s_load_dwordx2(s[20:21], s[0:1], s[0], 24, 0, 0, 0, 1))
  k.emit(s_load_dwordx2(s[24:25], s[0:1], s[0], 32, 0, 0, 0, 1))
  k.emit(s_waitcnt())
  for hi in (5, 13, 17, 21, 25):
    k.emit(s_and_b32(s[hi], s[hi], LIT, 65535))
    k.emit(s_or_b32(s[hi], s[hi], LIT, 262144))
  for cfg in (7, 15, 19, 23, 27): k.emit(s_mov_b32(s[cfg], LIT, 131072))
  k.emit(s_mov_b32(s[6], -16)); k.emit(s_mov_b32(s[7], LIT, 131072))
  k.emit(s_mov_b32(s[14], LIT, M * half_k))
  k.emit(s_mov_b32(s[18], LIT, N * half_k))
  k.emit(s_mov_b32(s[22], LIT, M * scale_k))
  k.emit(s_mov_b32(s[26], LIT, N * scale_k))
  k.emit(s_mov_b32(s[43], M))

  # 512-thread wave identity.  Preserve the v8-proven dependency spacing.
  k.emit(v_lshrrev_b32_e32(v[103], 6, v[0]))
  k.emit(v_and_b32_e32(v[102], LIT, v[0], 63))
  k.emit(s_mov_b32(s[46], s[2]))
  k.emit(s_mov_b32(s[47], s[3]))
  k.emit(v_readfirstlane_b32_e32(v[49], v[103]))
  k.emit(s_nop(3))
  k.emit(s_and_b32(s[50], s[49], 3))
  k.emit(s_lshr_b32(s[51], s[49], 2))

  # Force the already GPU-proven 128 architectural + 128 accumulator split.
  k.emit(v_mov_b32_e32(v[127], 0))
  for i in range(128): k.emit(v_accvgpr_write(v[i], 0))

  # Per-lane offsets that are invariant across all K blocks.
  # A native layout: row lane in low 4 bits, K32 quadrant in high 2 bits.
  k.emit(v_and_b32_e32(v[112], LIT, v[102], 15))
  k.emit(v_mul_i32_i24_e32(v[104], LIT, v[112], half_k))
  k.emit(v_lshrrev_b32_e32(v[113], 4, v[102]))
  k.emit(v_lshlrev_b32_e32(v[113], 4, v[113]))
  k.emit(v_add_u32_e32(v[104], v[113], v[104]))
  # B shuffled rowwise physical layout and both scale layouts.
  k.emit(v_lshlrev_b32_e32(v[105], 4, v[102]))
  k.emit(v_lshlrev_b32_e32(v[106], 2, v[102]))

  # Scalar byte bases for this wave's output-owned A/B rows.
  k.emit(s_mul_i32(s[52], s[47], LIT, 256))
  k.emit(s_mul_i32(s[53], s[51], 128))
  k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[57], LIT, s[52], half_k))
  k.emit(s_lshr_b32(s[52], s[52], 5))
  k.emit(s_mul_i32(s[59], LIT, s[52], K))

  k.emit(s_mul_i32(s[52], s[46], LIT, 256))
  k.emit(s_mul_i32(s[53], s[50], 64))
  k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[58], LIT, s[52], half_k))
  k.emit(s_lshr_b32(s[52], s[52], 5))
  k.emit(s_mul_i32(s[60], LIT, s[52], K))

  k.emit(s_mov_b32(s[56], K // 256))
  k.label("K_LOOP")
  for half in (0, 1):
    _emit_half_loads(k, half_k, K, half)
    k.emit(s_waitcnt())
    _emit_half_mfma(k)
    # Matrix sources are overwritten by the next half.  The correctness path
    # honors the CDNA4 software-managed source retirement window.  The fast
    # candidate intentionally omits it and is only benchmarked if bit-correct.
    if not fast:
      k.emit(s_nop(15)); k.emit(s_nop(3))  # 20 explicit independent wait states
  _advance_bk256(k)
  k.emit(s_sub_u32(s[56], s[56], 1))
  k.emit(s_cmp_eq_u32(s[56], 0))
  k.emit(s_cbranch_scc0(1), target="K_LOOP")

  # Ensure final AccVGPR writes are committed before reads in the epilogue.
  if not fast:
    k.emit(s_nop(15)); k.emit(s_nop(3))  # 20 waits before AccVGPR readback
  _emit_epilogue(k, M, N)
  k.emit(s_waitcnt())
  k.emit(s_endpgm())
  return k.finalize()


# Two disjoint 60-VGPR operand banks used by the pipelined direct kernel.
# (A_data, A_scale, B_data, B_scale)
_PP_BANKS = ((0, 32, 40, 56), (60, 92, 100, 116))

def _emit_half_loads_bank(k: Kernel, half_k: int, K: int, half: int, bank: int) -> None:
  assert half in (0,1) and bank in (0,1)
  ad, asc, bd, bsc = _PP_BANKS[bank]
  a_koff, b_koff, scale_half = half*64, half*1024, half*2
  row16_stride=16*half_k
  for mb in range(8):
    if mb == 0: k.emit(s_mov_b32(s[52], s[57]))
    else: k.emit(s_add_u32(s[52], s[57], LIT, mb*row16_stride))
    k.emit(v_add_u32_e32(v[120], s[52], v[124]))
    d=ad+mb*4
    k.emit(buffer_load_dwordx4(v[d:d+3], v[120], s[12:15], 0, a_koff, 1))
    pair=(mb//2)*K
    if pair == 0: k.emit(s_mov_b32(s[52], s[59]))
    else: k.emit(s_add_u32(s[52], s[59], LIT, pair))
    k.emit(v_add_u32_e32(v[120], s[52], v[126]))
    k.emit(buffer_load_ubyte(v[asc+mb], v[120], s[20:23], 0, (mb&1)+scale_half, 1))
  for nb in range(4):
    if nb == 0: k.emit(s_mov_b32(s[52], s[58]))
    else: k.emit(s_add_u32(s[52], s[58], LIT, nb*row16_stride))
    k.emit(v_add_u32_e32(v[120], s[52], v[125]))
    d=bd+nb*4
    k.emit(buffer_load_dwordx4(v[d:d+3], v[120], s[16:19], 0, b_koff, 1))
    pair=(nb//2)*K
    if pair == 0: k.emit(s_mov_b32(s[52], s[60]))
    else: k.emit(s_add_u32(s[52], s[60], LIT, pair))
    k.emit(v_add_u32_e32(v[120], s[52], v[126]))
    k.emit(buffer_load_ubyte(v[bsc+nb], v[120], s[24:27], 0, (nb&1)+scale_half, 1))

def _emit_half_mfma_bank(k: Kernel, bank:int) -> None:
  ad, asc, bd, bsc = _PP_BANKS[bank]
  for nb in range(4):
    for mb in range(8):
      dst=nb*32+mb*4
      k.emit(v_mfma_fp4(v[dst:dst+3], v[bd+nb*4:bd+nb*4+3], v[ad+mb*4:ad+mb*4+3],
                         0, 0, v[bsc+nb], v[asc+mb]))

def build_direct_pingpong_kernel(M:int, N:int, K:int):
  """Double-buffered direct-load kernel: useful loads occupy MFMA retirement time."""
  if M%256 or N%256 or K%256: raise ValueError(f"phase2 direct requires M/N/K multiples of 256, got {M}x{N}x{K}")
  half_k, scale_k=K//2,K//32
  k=Kernel()
  # Same descriptors / wave identity as build_direct_kernel.
  k.emit(s_and_b32(s[1], s[1], LIT, 65535))
  for dst,off in ((4,0),(12,8),(16,16),(20,24),(24,32)):
    k.emit(s_load_dwordx2(s[dst:dst+1], s[0:1], s[0], off, 0, 0, 0, 1))
  k.emit(s_waitcnt())
  for hi in (5,13,17,21,25):
    k.emit(s_and_b32(s[hi], s[hi], LIT, 65535)); k.emit(s_or_b32(s[hi], s[hi], LIT, 262144))
  for cfg in (7,15,19,23,27): k.emit(s_mov_b32(s[cfg], LIT, 131072))
  k.emit(s_mov_b32(s[6], -16)); k.emit(s_mov_b32(s[7], LIT, 131072))
  k.emit(s_mov_b32(s[14], LIT, M*half_k)); k.emit(s_mov_b32(s[18], LIT, N*half_k))
  k.emit(s_mov_b32(s[22], LIT, M*scale_k)); k.emit(s_mov_b32(s[26], LIT, N*scale_k)); k.emit(s_mov_b32(s[43], M))
  k.emit(v_lshrrev_b32_e32(v[121], 6, v[0]))
  k.emit(v_and_b32_e32(v[123], LIT, v[0], 63))
  k.emit(s_mov_b32(s[46], s[2])); k.emit(s_mov_b32(s[47], s[3]))
  k.emit(v_readfirstlane_b32_e32(v[49], v[121])); k.emit(s_nop(3))
  k.emit(s_and_b32(s[50], s[49], 3)); k.emit(s_lshr_b32(s[51], s[49], 2))
  k.emit(v_mov_b32_e32(v[127], 0))
  for i in range(128): k.emit(v_accvgpr_write(v[i], 0))

  # Invariant lane offsets live above both operand banks.
  k.emit(v_and_b32_e32(v[121], LIT, v[123], 15))
  k.emit(v_mul_i32_i24_e32(v[124], LIT, v[121], half_k))
  k.emit(v_lshrrev_b32_e32(v[122], 4, v[123])); k.emit(v_lshlrev_b32_e32(v[122], 4, v[122]))
  k.emit(v_add_u32_e32(v[124], v[122], v[124]))
  k.emit(v_lshlrev_b32_e32(v[125], 4, v[123])); k.emit(v_lshlrev_b32_e32(v[126], 2, v[123]))

  k.emit(s_mul_i32(s[52], s[47], LIT, 256)); k.emit(s_mul_i32(s[53], s[51], 128)); k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[57], LIT, s[52], half_k)); k.emit(s_lshr_b32(s[52], s[52], 5)); k.emit(s_mul_i32(s[59], LIT, s[52], K))
  k.emit(s_mul_i32(s[52], s[46], LIT, 256)); k.emit(s_mul_i32(s[53], s[50], 64)); k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[58], LIT, s[52], half_k)); k.emit(s_lshr_b32(s[52], s[52], 5)); k.emit(s_mul_i32(s[60], LIT, s[52], K))

  # Seed bank 0 with the first K128 contribution.
  _emit_half_loads_bank(k, half_k, K, 0, 0); k.emit(s_waitcnt())
  k.emit(s_mov_b32(s[56], K//256))
  k.label("PP_LOOP")
  _emit_half_mfma_bank(k,0)
  # Disjoint bank-1 prefetch supplies ample independent work while bank 0 retires.
  _emit_half_loads_bank(k, half_k, K, 1, 1); k.emit(s_waitcnt())
  _emit_half_mfma_bank(k,1)
  _advance_bk256(k)
  k.emit(s_sub_u32(s[56], s[56], 1)); k.emit(s_cmp_eq_u32(s[56], 0)); k.emit(s_cbranch_scc1(1), target="PP_DONE")
  # Bank 0 was last used before the entire bank-1 load+MFMA sequence, so it is safe to overwrite.
  _emit_half_loads_bank(k, half_k, K, 0, 0); k.emit(s_waitcnt())
  k.emit(s_branch(1), target="PP_LOOP")
  k.label("PP_DONE")
  # Final bank-1 results need an explicit retirement window before AccVGPR reads.
  k.emit(s_nop(15)); k.emit(s_nop(3))
  _emit_epilogue(k,M,N,lane_reg=v[123]); k.emit(s_waitcnt()); k.emit(s_endpgm())
  return k.finalize()
