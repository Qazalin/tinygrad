"""8-wave MXFP4 GEMM for gfx950 with transparent cooperative LDS staging.

This kernel keeps the v13 direct kernel's GPU-proven MFMA operand mapping, but
removes its duplicated global traffic.  A 512-thread workgroup stages one full
BK256 tile into a simple, non-swizzled LDS cache:

  A data   256 rows x 128 packed bytes = 32768 B
  B data   16 physical groups x 2048 B = 32768 B
  A scales 8 physical groups x 256 B  =  2048 B
  B scales 8 physical groups x 256 B  =  2048 B

The LDS layout deliberately mirrors the physical bytes consumed by the correct
v13 direct kernel.  It does not reuse the old reference LDS swizzle.
"""
# ruff: noqa: F403,F405,E501
from tinygrad.runtime.autogen.amd.cdna.ins import *
from extra.gemm.gemm_mxfp4 import Kernel, v_mfma_fp4

TILE_M = TILE_N = 256
THREADS = 512
A_LDS = 0
B_LDS = 32 * 1024
AS_LDS = 64 * 1024
BS_LDS = 66 * 1024
USED_LDS_BYTES = 68 * 1024
# CDNA4 allocates LDS in 1280-byte units.  70 KiB is exactly 56 units.
LDS_BYTES = 70 * 1024


def _off16(x: int) -> tuple[int, int]:
  assert 0 <= x <= 0xffff
  return x & 0xff, x >> 8


def _ds_read_b128(k: Kernel, dst, addr, offset: int) -> None:
  lo, hi = _off16(offset)
  k.emit(ds_read_b128(dst, addr, v[0], v[0], 0, lo, hi))


def _ds_write_b128(k: Kernel, data, addr, offset: int) -> None:
  lo, hi = _off16(offset)
  k.emit(ds_write_b128(v[0], addr, data, v[0], 0, lo, hi))


def _ds_read_b32(k: Kernel, dst, addr, offset: int) -> None:
  lo, hi = _off16(offset)
  k.emit(ds_read_b32(dst, addr, v[0], v[0], 0, lo, hi))


def _ds_write_b32(k: Kernel, data, addr, offset: int) -> None:
  lo, hi = _off16(offset)
  k.emit(ds_write_b32(v[0], addr, data, v[0], 0, lo, hi))


def _emit_epilogue(k: Kernel, M: int, N: int) -> None:
  """v8-proven 128x64 epilogue using a full-buffer C descriptor.

  Keeping the resource base fixed removes the production-M descriptor rebasing
  that made the old direct path risky.  All Llama C buffers are < 2^32 bytes.
  """
  row_stride = N * 2
  out_bytes = M * N * 2
  assert out_bytes < 2**32
  k.emit(s_mov_b32(s[6], LIT, out_bytes))
  k.emit(s_mov_b32(s[54], LIT, row_stride))

  # Per-lane byte offset inside the wave's 128x64 tile.
  k.emit(v_and_b32_e64(v[111], v[102], 15))
  k.emit(v_mul_lo_u32(v[111], v[111], s[54]))
  k.emit(v_lshrrev_b32_e32(v[112], 5, v[102]))
  k.emit(v_mul_i32_i24_e32(v[112], 16, v[112]))
  k.emit(v_add_u32_e32(v[111], v[112], v[111]))
  k.emit(v_lshrrev_b32_e32(v[112], 4, v[102]))
  k.emit(v_and_b32_e32(v[112], 1, v[112]))
  k.emit(v_mul_i32_i24_e32(v[112], 32, v[112]))
  k.emit(v_add_u32_e32(v[111], v[112], v[111]))

  # Full C byte base for (m_tile*256 + wave_m*128, n_tile*256 + wave_n*64).
  k.emit(s_mul_i32(s[52], s[47], LIT, 256))
  k.emit(s_mul_i32(s[53], s[51], 128))
  k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(s_mul_i32(s[52], s[52], s[54]))
  k.emit(s_mul_i32(s[53], s[46], LIT, 256))
  k.emit(s_mul_i32(s[55], s[50], 64))
  k.emit(s_add_u32(s[53], s[53], s[55]))
  k.emit(s_lshl_b32(s[53], s[53], 1))
  k.emit(s_add_u32(s[52], s[52], s[53]))
  k.emit(v_add_u32_e32(v[111], s[52], v[111]))
  k.emit(s_mov_b32(s[55], LIT, 16 * row_stride - 128))

  for mb in range(8):
    for nhalf in range(2):
      acc_base = nhalf * 64 + mb * 4
      for i in range(2):
        for j in range(4): k.emit(v_accvgpr_read(v[j+i*4], v[acc_base+j+i*32]))
      for i in range(4): k.emit(v_cvt_pk_bf16_f32(v[16+i], v[i*2], v[i*2+1]))
      k.emit(s_nop(1)); k.emit(v_permlane16_swap_b32_e32(v[16], v[18]))
      k.emit(s_nop(1)); k.emit(v_permlane16_swap_b32_e32(v[17], v[19]))
      k.emit(s_nop(1)); k.emit(buffer_store_dwordx4(v[16:19], v[111], s[4:7], 0, 0, 1))
      k.emit(v_add_i32(v[111], v[111], 64))
    if mb != 7: k.emit(v_add_u32_e32(v[111], s[55], v[111]))


def _emit_stage(k: Kernel) -> None:
  """Stage one BK256 from fixed global descriptors into the transparent LDS cache."""
  # A/B scalar K offsets are s61/s62; the shared scale offset is s63.
  k.emit(s_add_u32(s[52], s[57], s[61]))
  k.emit(v_add_u32_e32(v[112], s[52], v[104]))
  for i in range(4): k.emit(buffer_load_dwordx4(v[i*4:i*4+3], v[112], s[12:15], 0, i*16, 1))

  k.emit(s_add_u32(s[52], s[58], s[62]))
  k.emit(v_add_u32_e32(v[113], s[52], v[105]))
  for i in range(4): k.emit(buffer_load_dwordx4(v[16+i*4:19+i*4], v[113], s[16:19], 0, i*16, 1))

  # One packed scale dword per thread covers both M/N parities and both K128 halves.
  k.emit(s_add_u32(s[52], s[59], s[63]))
  k.emit(v_add_u32_e32(v[112], s[52], v[114]))
  k.emit(buffer_load_dword(v[32], v[112], s[20:23], 0, 0, 1))
  k.emit(s_add_u32(s[52], s[60], s[63]))
  k.emit(v_add_u32_e32(v[113], s[52], v[114]))
  k.emit(buffer_load_dword(v[33], v[113], s[24:27], 0, 0, 1))
  k.emit(s_waitcnt())

  # v106 = local_id*64.  A and B each assign one 64-byte chunk per thread.
  for i in range(4): _ds_write_b128(k, v[i*4:i*4+3], v[106], A_LDS + i*16)
  for i in range(4): _ds_write_b128(k, v[16+i*4:19+i*4], v[106], B_LDS + i*16)
  # v116 = AS_LDS + local_id*4.  B scales immediately follow A scales.
  _ds_write_b32(k, v[32], v[116], 0)
  _ds_write_b32(k, v[33], v[116], BS_LDS-AS_LDS)
  k.emit(s_waitcnt())
  k.emit(s_barrier())


def _emit_operand_reads(k: Kernel) -> None:
  """Read both K128 operand banks and the six packed scale dwords from LDS."""
  # Packed scale dwords are common to both halves.  Four A row-pairs, two B column-pairs.
  for pair in range(4): _ds_read_b32(k, v[96+pair], v[109], pair*256)
  for pair in range(2): _ds_read_b32(k, v[100+pair], v[110], pair*256)

  # half 0: A v0..31, B v32..47
  for mb in range(8): _ds_read_b128(k, v[mb*4:mb*4+3], v[107], mb*2048)
  for nb in range(4): _ds_read_b128(k, v[32+nb*4:35+nb*4], v[108], nb*2048)
  # half 1: A v48..79, B v80..95
  for mb in range(8): _ds_read_b128(k, v[48+mb*4:51+mb*4], v[107], mb*2048 + 64)
  for nb in range(4): _ds_read_b128(k, v[80+nb*4:83+nb*4], v[108], nb*2048 + 1024)
  k.emit(s_waitcnt())


def _emit_half_mfma(k: Kernel, half: int) -> None:
  assert half in (0, 1)
  abase, bbase = ((0, 32) if half == 0 else (48, 80))
  for nb in range(4):
    for mb in range(8):
      dst = nb*32 + mb*4
      bsel, asel = (nb & 1) + half*2, (mb & 1) + half*2
      # Load-scale encoding: OPSEL bit0/1 are scale src0/src1 low selector bits;
      # OPSEL_HI bit0/1 are their high selector bits. src0 is B, src1 is A.
      opsel = (bsel & 1) | ((asel & 1) << 1)
      opsel_hi = ((bsel >> 1) & 1) | (((asel >> 1) & 1) << 1)
      k.emit(v_mfma_fp4(v[dst:dst+3], v[bbase+nb*4:bbase+nb*4+3], v[abase+mb*4:abase+mb*4+3],
                         opsel, opsel_hi, v[100+nb//2], v[96+mb//2]))


def build_lds_kernel(M: int, N: int, K: int):
  if M % 256 or N % 256 or K % 256:
    raise ValueError(f"phase2 LDS requires M/N/K multiples of 256, got {M}x{N}x{K}")
  half_k, scale_k = K//2, K//32
  k = Kernel()

  # Fixed full-buffer resource descriptors.  K progression is carried in scalar
  # VADDR offsets rather than rebasing/shrinking descriptors each iteration.
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

  # v8/v13-proven wave identity.
  k.emit(v_lshrrev_b32_e32(v[103], 6, v[0]))
  k.emit(v_and_b32_e32(v[102], LIT, v[0], 63))
  k.emit(s_mov_b32(s[46], s[2])); k.emit(s_mov_b32(s[47], s[3]))
  k.emit(v_readfirstlane_b32_e32(v[49], v[103])); k.emit(s_nop(3))
  k.emit(s_and_b32(s[50], s[49], 3)); k.emit(s_lshr_b32(s[51], s[49], 2))

  # Force the GPU-proven 128 architectural + 128 accumulator allocation.
  k.emit(v_mov_b32_e32(v[127], 0))
  for i in range(128): k.emit(v_accvgpr_write(v[i], 0))

  # Thread-global staging offsets.  Every thread owns one 64-byte A chunk and one
  # 64-byte B chunk for the full BK256.
  k.emit(v_lshrrev_b32_e32(v[104], 1, v[0]))
  k.emit(v_mul_i32_i24_e32(v[104], LIT, v[104], half_k))
  k.emit(v_and_b32_e32(v[115], LIT, v[0], 1)); k.emit(v_lshlrev_b32_e32(v[115], 6, v[115]))
  k.emit(v_add_u32_e32(v[104], v[115], v[104]))

  k.emit(v_lshrrev_b32_e32(v[105], 5, v[0])); k.emit(v_lshlrev_b32_e32(v[105], 4, v[105]))
  k.emit(v_mul_i32_i24_e32(v[105], LIT, v[105], half_k))
  k.emit(v_and_b32_e32(v[115], LIT, v[0], 31)); k.emit(v_lshlrev_b32_e32(v[115], 6, v[115]))
  k.emit(v_add_u32_e32(v[105], v[115], v[105]))

  k.emit(v_lshlrev_b32_e32(v[106], 6, v[0]))
  k.emit(v_lshlrev_b32_e32(v[116], 2, v[0])); k.emit(v_add_u32_e32(v[116], LIT, v[116], AS_LDS))
  # Scale physical group = wave_id, lane = lane_id.
  k.emit(v_lshrrev_b32_e32(v[114], 6, v[0])); k.emit(v_mul_i32_i24_e32(v[114], LIT, v[114], K))
  k.emit(v_lshlrev_b32_e32(v[115], 2, v[102])); k.emit(v_add_u32_e32(v[114], v[115], v[114]))

  # Wave-private LDS read bases.
  k.emit(v_and_b32_e32(v[107], LIT, v[102], 15)); k.emit(v_lshlrev_b32_e32(v[107], 7, v[107]))
  k.emit(v_lshrrev_b32_e32(v[115], 4, v[102])); k.emit(v_lshlrev_b32_e32(v[115], 4, v[115]))
  k.emit(v_add_u32_e32(v[107], v[115], v[107]))
  k.emit(s_lshl_b32(s[52], s[51], 14)); k.emit(v_add_u32_e32(v[107], s[52], v[107]))

  k.emit(v_lshlrev_b32_e32(v[108], 4, v[102]))
  k.emit(s_lshl_b32(s[52], s[50], 13)); k.emit(s_add_u32(s[52], LIT, s[52], B_LDS))
  k.emit(v_add_u32_e32(v[108], s[52], v[108]))

  k.emit(v_lshlrev_b32_e32(v[109], 2, v[102]))
  k.emit(s_lshl_b32(s[52], s[51], 10)); k.emit(s_add_u32(s[52], LIT, s[52], AS_LDS))
  k.emit(v_add_u32_e32(v[109], s[52], v[109]))
  k.emit(v_lshlrev_b32_e32(v[110], 2, v[102]))
  k.emit(s_lshl_b32(s[52], s[50], 9)); k.emit(s_add_u32(s[52], LIT, s[52], BS_LDS))
  k.emit(v_add_u32_e32(v[110], s[52], v[110]))

  # Workgroup-global input bases.
  k.emit(s_mul_i32(s[52], s[47], LIT, 256)); k.emit(s_mul_i32(s[57], LIT, s[52], half_k))
  k.emit(s_mul_i32(s[52], s[46], LIT, 256)); k.emit(s_mul_i32(s[58], LIT, s[52], half_k))
  k.emit(s_mul_i32(s[52], s[47], 8)); k.emit(s_mul_i32(s[59], LIT, s[52], K))
  k.emit(s_mul_i32(s[52], s[46], 8)); k.emit(s_mul_i32(s[60], LIT, s[52], K))
  k.emit(s_mov_b32(s[61], 0)); k.emit(s_mov_b32(s[62], 0)); k.emit(s_mov_b32(s[63], 0))
  k.emit(s_mov_b32(s[56], K//256))

  # On CDNA the special encoding exposed as NULL by this DSL is M0.  Set it to
  # no-clamp once; this kernel never repurposes M0 for direct-to-LDS addressing.
  k.emit(s_mov_b32(NULL, -1))
  k.label("K_LOOP")
  _emit_stage(k)
  _emit_operand_reads(k)
  _emit_half_mfma(k, 0)
  _emit_half_mfma(k, 1)

  # No wave may overwrite the single LDS stage until every wave has consumed it.
  k.emit(s_barrier())
  k.emit(s_add_u32(s[61], LIT, s[61], 128))
  k.emit(s_add_u32(s[62], LIT, s[62], 2048))
  k.emit(s_add_u32(s[63], LIT, s[63], 256))
  k.emit(s_sub_u32(s[56], s[56], 1)); k.emit(s_cmp_eq_u32(s[56], 0))
  k.emit(s_cbranch_scc0(1), target="K_LOOP")

  # Final matrix result retirement before AccVGPR readback (one-time cost).
  k.emit(s_nop(15)); k.emit(s_nop(3))
  _emit_epilogue(k, M, N)
  k.emit(s_waitcnt()); k.emit(s_endpgm())
  return k.finalize()
