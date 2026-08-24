"""4-wave, two-WG/CU MXFP4 GEMM for gfx950.

Each 256-thread workgroup computes a 128x256 C tile.  The four wave64s own
128x64 tiles, exactly the GPU-proven v14/v15 per-wave MFMA/epilogue mapping.
Only A is shared through LDS; B and both scale operands are loaded directly by
the wave that consumes them.  Two 8 KiB A stages ping-pong across K128 halves.

This is intentionally the inverse of the failed 8-wave transport: keep the
correct 128x64 wave tile, but use two 4-wave workgroups per CU instead of one
8-wave workgroup.  Combined VGPR allocation remains 128+128=256/wave while LDS
is only 16 KiB/WG, so both resource thresholds permit 8 resident waves/CU.
"""
# ruff: noqa: F403,F405,E501
from tinygrad.runtime.autogen.amd.cdna.ins import *
from extra.gemm.gemm_mxfp4 import Kernel, v_mfma_fp4
from extra.gemm.cdna_lib.phase2_lds import _ds_read_b128, _ds_write_b128

TILE_M, TILE_N = 128, 256
THREADS = 256
A_STAGE_BYTES = 8 * 1024
A0_LDS = 0
A1_LDS = A_STAGE_BYTES
USED_LDS_BYTES = 2 * A_STAGE_BYTES
LDS_BYTES = 13 * 1280  # 16640 B, one allocation unit above 16 KiB


def _emit_epilogue(k: Kernel, M: int, N: int) -> None:
  row_stride, out_bytes = N*2, M*N*2
  assert out_bytes < 2**32
  k.emit(s_mov_b32(s[6], LIT, out_bytes))
  k.emit(s_mov_b32(s[54], LIT, row_stride))

  # Native 16x16 MFMA lane mapping within this wave's 128x64 tile.
  k.emit(v_and_b32_e64(v[111], v[102], 15))
  k.emit(v_mul_lo_u32(v[111], v[111], s[54]))
  k.emit(v_lshrrev_b32_e32(v[112], 5, v[102])); k.emit(v_mul_i32_i24_e32(v[112], 16, v[112]))
  k.emit(v_add_u32_e32(v[111], v[112], v[111]))
  k.emit(v_lshrrev_b32_e32(v[112], 4, v[102])); k.emit(v_and_b32_e32(v[112], 1, v[112]))
  k.emit(v_mul_i32_i24_e32(v[112], 32, v[112])); k.emit(v_add_u32_e32(v[111], v[112], v[111]))

  # Fixed full C descriptor; workgroup row tile is 128, N tile is 256.
  k.emit(s_mul_i32(s[52], s[47], LIT, 128)); k.emit(s_mul_i32(s[52], s[52], s[54]))
  k.emit(s_mul_i32(s[53], s[46], LIT, 256)); k.emit(s_mul_i32(s[55], s[49], 64))
  k.emit(s_add_u32(s[53], s[53], s[55])); k.emit(s_lshl_b32(s[53], s[53], 1))
  k.emit(s_add_u32(s[52], s[52], s[53])); k.emit(v_add_u32_e32(v[111], s[52], v[111]))
  k.emit(s_mov_b32(s[55], LIT, 16*row_stride - 128))

  for mb in range(8):
    for nhalf in range(2):
      acc_base = nhalf*64 + mb*4
      for i in range(2):
        for j in range(4): k.emit(v_accvgpr_read(v[j+i*4], v[acc_base+j+i*32]))
      for i in range(4): k.emit(v_cvt_pk_bf16_f32(v[16+i], v[i*2], v[i*2+1]))
      k.emit(s_nop(1)); k.emit(v_permlane16_swap_b32_e32(v[16], v[18]))
      k.emit(s_nop(1)); k.emit(v_permlane16_swap_b32_e32(v[17], v[19]))
      k.emit(s_nop(1)); k.emit(buffer_store_dwordx4(v[16:19], v[111], s[4:7], 0, 0, 1))
      k.emit(v_add_i32(v[111], v[111], 64))
    if mb != 7: k.emit(v_add_u32_e32(v[111], s[55], v[111]))


def _emit_a_prefetch_normal(k: Kernel, half_k: int, odd: bool) -> None:
  # Every wave supplies 32 rows.  Each lane supplies two consecutive 16-byte
  # chunks; together 4*64*2*16 = 8192 B, exactly one 128xK128 A tile.
  k.emit(s_add_u32(s[52], s[57], s[61]))
  if odd: k.emit(s_add_u32(s[52], LIT, s[52], 64))
  k.emit(buffer_load_dwordx4(v[120:123], v[104], s[12:15], s[52], 0, 1))
  k.emit(s_add_u32(s[53], s[52], LIT, 16*half_k))
  k.emit(buffer_load_dwordx4(v[124:127], v[104], s[12:15], s[53], 0, 1))


def _emit_a_prefetch_d2l(k: Kernel, half_k: int, odd: bool, stage: int) -> None:
  # Natural A stage mapping, but use MUBUF->LDS directly.  For each wave/load:
  # chunk = wave*128 + load*64 + lane; row=chunk//4, Kchunk=chunk%4.
  assert stage in (0, 1)
  stage_base = A0_LDS if stage == 0 else A1_LDS
  for j in range(2):
    k.emit(s_add_u32(s[52], s[57], s[61]))
    if odd: k.emit(s_add_u32(s[52], LIT, s[52], 64))
    if j: k.emit(s_add_u32(s[52], LIT, s[52], 16*half_k))
    m0off = stage_base + j*1024
    if m0off == 0: k.emit(s_add_u32(NULL, 0, s[64]))
    else: k.emit(s_add_u32(NULL, LIT, s[64], m0off))
    k.emit(buffer_load_dwordx4(v[0:3], v[104], s[12:15], s[52], 0, 1, 0, 0, 0, 0, 1))


def _emit_a_stage_write(k: Kernel, stage: int) -> None:
  assert stage in (0, 1)
  base = A0_LDS if stage == 0 else A1_LDS
  _ds_write_b128(k, v[120:123], v[118], base)
  _ds_write_b128(k, v[124:127], v[118], base+1024)


def _emit_a_commit(k: Kernel, stage: int, direct_lds: bool) -> None:
  k.emit(s_waitcnt())
  if not direct_lds:
    _emit_a_stage_write(k, stage)
    k.emit(s_waitcnt())
  else:
    # MUBUF->LDS uses M0 as a destination offset. Restore the unclamped LDS
    # size before ordinary DS reads, exactly as required by CDNA4.
    k.emit(s_mov_b32(NULL, -1))
  k.emit(s_barrier())


def _emit_a_reads(k: Kernel, stage: int, bank: int) -> None:
  assert stage in (0, 1) and bank in (0, 1)
  ar = v[107] if stage == 0 else v[108]
  abase = 0 if bank == 0 else 48
  for mb in range(8): _ds_read_b128(k, v[abase+mb*4:abase+mb*4+3], ar, mb*1024)
  k.emit(s_waitcnt())


def _emit_b_loads(k: Kernel, half_k: int, odd: bool, bank: int) -> None:
  assert bank in (0, 1)
  bbase = 32 if bank == 0 else 80
  k.emit(s_add_u32(s[52], s[58], s[62]))
  if odd: k.emit(s_add_u32(s[52], LIT, s[52], 1024))
  row16_stride = 16*half_k
  for nb in range(4):
    if nb == 0: k.emit(s_mov_b32(s[53], s[52]))
    else: k.emit(s_add_u32(s[53], s[52], LIT, nb*row16_stride))
    k.emit(buffer_load_dwordx4(v[bbase+nb*4:bbase+nb*4+3], v[105], s[16:19], s[53], 0, 1))


def _emit_scales(k: Kernel, K: int, dst: int) -> None:
  # Four packed A scale dwords (shared logically but tiny enough to duplicate
  # across four waves) and two B scale dwords for this wave's N64 tile.
  k.emit(s_add_u32(s[52], s[59], s[63]))
  for p in range(4):
    if p == 0: k.emit(s_mov_b32(s[53], s[52]))
    else: k.emit(s_add_u32(s[53], s[52], LIT, p*K))
    k.emit(buffer_load_dword(v[dst+p], v[106], s[20:23], s[53], 0, 1))
  k.emit(s_add_u32(s[52], s[60], s[63]))
  for p in range(2):
    if p == 0: k.emit(s_mov_b32(s[53], s[52]))
    else: k.emit(s_add_u32(s[53], s[52], LIT, K))
    k.emit(buffer_load_dword(v[dst+4+p], v[106], s[24:27], s[53], 0, 1))


def _emit_mfmas(k: Kernel, half: int, bank: int) -> None:
  assert half in (0, 1) and bank in (0, 1)
  abase = 0 if bank == 0 else 48
  bbase = 32 if bank == 0 else 80
  for nb in range(4):
    for mb in range(8):
      dst = nb*32 + mb*4
      bsel, asel = (nb&1)+half*2, (mb&1)+half*2
      opsel = (bsel&1) | ((asel&1)<<1)
      opsel_hi = ((bsel>>1)&1) | (((asel>>1)&1)<<1)
      k.emit(v_mfma_fp4(v[dst:dst+3], v[bbase+nb*4:bbase+nb*4+3], v[abase+mb*4:abase+mb*4+3],
                         opsel, opsel_hi, v[100+nb//2], v[96+mb//2]))


def build_4w_kernel(M: int, N: int, K: int, *, direct_lds: bool = False):
  if M % TILE_M or N % TILE_N or K % 256:
    raise ValueError(f"phase2 4w requires M%128=N%256=K%256=0, got {M}x{N}x{K}")
  half_k, scale_k = K//2, K//32
  k = Kernel()

  k.emit(s_and_b32(s[1], s[1], LIT, 65535))
  for dst, off in ((4,0),(12,8),(16,16),(20,24),(24,32)):
    k.emit(s_load_dwordx2(s[dst:dst+1], s[0:1], s[0], off, 0, 0, 0, 1))
  k.emit(s_waitcnt())
  for hi in (5,13,17,21,25):
    k.emit(s_and_b32(s[hi], s[hi], LIT, 65535)); k.emit(s_or_b32(s[hi], s[hi], LIT, 262144))
  for cfg in (7,15,19,23,27): k.emit(s_mov_b32(s[cfg], LIT, 131072))
  k.emit(s_mov_b32(s[6], LIT, M*N*2))
  k.emit(s_mov_b32(s[14], LIT, M*half_k)); k.emit(s_mov_b32(s[18], LIT, N*half_k))
  k.emit(s_mov_b32(s[22], LIT, M*scale_k)); k.emit(s_mov_b32(s[26], LIT, N*scale_k))

  # Four wave64s.  s49 is wave_n in [0,3]; there is no wave_m dimension.
  k.emit(v_lshrrev_b32_e32(v[103], 6, v[0])); k.emit(v_and_b32_e32(v[102], LIT, v[0], 63))
  k.emit(s_mov_b32(s[46], s[2])); k.emit(s_mov_b32(s[47], s[3]))
  k.emit(v_readfirstlane_b32_e32(v[49], v[103])); k.emit(s_nop(3))

  # 128 accumulator registers are exactly the proven 128x64 wave tile.
  # Keep the architectural/accumulator split at the GPU-proven 128 boundary.
  k.emit(v_mov_b32_e32(v[127], 0))
  for i in range(128): k.emit(v_accvgpr_write(v[i], 0))

  # Lane-local address terms.
  # A D2L/native mapping: (lane>>2)*half_k + (lane&3)*16.
  k.emit(v_lshrrev_b32_e32(v[104], 2, v[102])); k.emit(v_mul_i32_i24_e32(v[104], LIT, v[104], half_k))
  k.emit(v_and_b32_e32(v[119], LIT, v[102], 3)); k.emit(v_lshlrev_b32_e32(v[119], 4, v[119]))
  k.emit(v_add_u32_e32(v[104], v[119], v[104]))
  k.emit(v_lshlrev_b32_e32(v[105], 4, v[102]))  # B native lane*16
  k.emit(v_lshlrev_b32_e32(v[106], 2, v[102]))  # scale lane*4

  # Normal-stage LDS destination: wave*2048 + lane*16.
  k.emit(v_lshlrev_b32_e32(v[118], 11, v[103])); k.emit(v_lshlrev_b32_e32(v[119], 4, v[102]))
  k.emit(v_add_u32_e32(v[118], v[119], v[118]))
  # A MFMA read address: row-in-16 *64 + K32-quadrant*16.
  k.emit(v_and_b32_e32(v[107], LIT, v[102], 15)); k.emit(v_lshlrev_b32_e32(v[107], 6, v[107]))
  k.emit(v_lshrrev_b32_e32(v[119], 4, v[102])); k.emit(v_lshlrev_b32_e32(v[119], 4, v[119]))
  k.emit(v_add_u32_e32(v[107], v[119], v[107])); k.emit(v_add_u32_e32(v[108], LIT, v[107], A1_LDS))

  # Scalar full-buffer bases.  Each loader wave supplies 32 of the WG's 128 A rows.
  k.emit(s_mul_i32(s[52], s[47], LIT, 128)); k.emit(s_mul_i32(s[53], s[49], 32)); k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[57], LIT, s[52], half_k))
  # D2L M0 base for this wave's A quarter.
  k.emit(s_lshl_b32(s[64], s[49], 11))

  k.emit(s_mul_i32(s[52], s[46], LIT, 256)); k.emit(s_mul_i32(s[53], s[49], 64)); k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[58], LIT, s[52], half_k))
  k.emit(s_mul_i32(s[52], s[47], 4)); k.emit(s_mul_i32(s[59], LIT, s[52], K))
  k.emit(s_mul_i32(s[52], s[46], 8)); k.emit(s_mul_i32(s[53], s[49], 2)); k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[60], LIT, s[52], K))
  k.emit(s_mov_b32(s[61], 0)); k.emit(s_mov_b32(s[62], 0)); k.emit(s_mov_b32(s[63], 0))
  k.emit(s_mov_b32(s[56], K//256))
  k.emit(s_mov_b32(NULL, -1))

  def a_prefetch(odd: bool, stage: int):
    if direct_lds: _emit_a_prefetch_d2l(k, half_k, odd, stage)
    else: _emit_a_prefetch_normal(k, half_k, odd)

  # Initial even half: A stage0, B bank0, scales -> current registers.
  a_prefetch(False, 0); _emit_b_loads(k, half_k, False, 0); _emit_scales(k, K, 96)
  _emit_a_commit(k, 0, direct_lds); _emit_a_reads(k, 0, 0); k.emit(s_waitcnt())
  # Odd prefetch is already in flight when the first even MFMA starts.
  a_prefetch(True, 1); _emit_b_loads(k, half_k, True, 1)

  k.label("PAIR_EVEN")
  _emit_mfmas(k, 0, 0)
  _emit_a_commit(k, 1, direct_lds); _emit_a_reads(k, 1, 1); k.emit(s_waitcnt())
  k.emit(s_cmp_eq_u32(s[56], 1)); k.emit(s_cbranch_scc1(1), target="PAIR_LAST")

  # Next even half (next BK256) is prefetched under the current odd MFMA.
  k.emit(s_add_u32(s[61], LIT, s[61], 128)); k.emit(s_add_u32(s[62], LIT, s[62], 2048)); k.emit(s_add_u32(s[63], LIT, s[63], 256))
  a_prefetch(False, 0); _emit_b_loads(k, half_k, False, 0); _emit_scales(k, K, 112)
  _emit_mfmas(k, 1, 1)
  _emit_a_commit(k, 0, direct_lds); _emit_a_reads(k, 0, 0); k.emit(s_waitcnt())

  # Start the next odd prefetch before overwriting the current scale registers.
  # These independent instructions also satisfy the MFMA->scale VGPR retirement gap.
  a_prefetch(True, 1); _emit_b_loads(k, half_k, True, 1)
  for i in range(6): k.emit(v_mov_b32_e32(v[96+i], v[112+i]))
  k.emit(s_sub_u32(s[56], s[56], 1)); k.emit(s_branch(1), target="PAIR_EVEN")

  k.label("PAIR_LAST")
  _emit_mfmas(k, 1, 1)
  k.label("PAIR_DONE")
  k.emit(s_nop(15)); k.emit(s_nop(3))
  _emit_epilogue(k, M, N)
  k.emit(s_waitcnt()); k.emit(s_endpgm())
  return k.finalize()
