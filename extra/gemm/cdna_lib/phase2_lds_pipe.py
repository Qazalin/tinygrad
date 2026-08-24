"""Software-pipelined 8-wave MXFP4 GEMM for gfx950.

This keeps the GPU-proven v14 MFMA math and transparent LDS byte layout, but
ping-pongs two 68 KiB LDS stages. The next BK256 is fetched while the current
second K128 MFMA half is executing.
"""
# ruff: noqa: F403,F405,E501
from tinygrad.runtime.autogen.amd.cdna.ins import *
from extra.gemm.gemm_mxfp4 import Kernel, v_mfma_fp4
from extra.gemm.cdna_lib.phase2_lds import (
  A_LDS, B_LDS, AS_LDS, BS_LDS, USED_LDS_BYTES,
  _ds_read_b128, _ds_write_b128, _ds_read_b32, _ds_write_b32, _emit_epilogue,
)

TILE_M = TILE_N = 256
THREADS = 512
STAGE_BYTES = USED_LDS_BYTES
USED_PIPE_LDS_BYTES = 2 * STAGE_BYTES
LDS_BYTES = 109 * 1280  # ceil(136 KiB / 1280) = 139520 B < 160 KiB


def _emit_stage_loads(k: Kernel) -> None:
  k.emit(s_add_u32(s[52], s[57], s[61]))
  k.emit(v_add_u32_e32(v[112], s[52], v[104]))
  for i in range(4): k.emit(buffer_load_dwordx4(v[i*4:i*4+3], v[112], s[12:15], 0, i*16, 1))
  k.emit(s_add_u32(s[52], s[58], s[62]))
  k.emit(v_add_u32_e32(v[113], s[52], v[105]))
  for i in range(4): k.emit(buffer_load_dwordx4(v[16+i*4:19+i*4], v[113], s[16:19], 0, i*16, 1))
  k.emit(s_add_u32(s[52], s[59], s[63]))
  k.emit(v_add_u32_e32(v[112], s[52], v[114]))
  k.emit(buffer_load_dword(v[32], v[112], s[20:23], 0, 0, 1))
  k.emit(s_add_u32(s[52], s[60], s[63]))
  k.emit(v_add_u32_e32(v[113], s[52], v[114]))
  k.emit(buffer_load_dword(v[33], v[113], s[24:27], 0, 0, 1))


def _emit_stage_writes(k: Kernel, stage: int) -> None:
  assert stage in (0, 1)
  data_addr = v[106] if stage == 0 else v[121]
  scale_addr = v[116] if stage == 0 else v[122]
  for i in range(4): _ds_write_b128(k, v[i*4:i*4+3], data_addr, A_LDS + i*16)
  for i in range(4): _ds_write_b128(k, v[16+i*4:19+i*4], data_addr, B_LDS + i*16)
  _ds_write_b32(k, v[32], scale_addr, 0)
  _ds_write_b32(k, v[33], scale_addr, BS_LDS-AS_LDS)


def _emit_initial_stage(k: Kernel) -> None:
  _emit_stage_loads(k)
  k.emit(s_waitcnt())
  _emit_stage_writes(k, 0)
  k.emit(s_waitcnt())
  k.emit(s_barrier())


def _stage_read_bases(stage: int):
  assert stage in (0, 1)
  return (v[107], v[108], v[109], v[110]) if stage == 0 else (v[117], v[118], v[119], v[120])


def _emit_half0_operand_reads(k: Kernel, stage: int) -> None:
  ar, br, asr, bsr = _stage_read_bases(stage)
  for pair in range(4): _ds_read_b32(k, v[96+pair], asr, pair*256)
  for pair in range(2): _ds_read_b32(k, v[100+pair], bsr, pair*256)
  for mb in range(8): _ds_read_b128(k, v[mb*4:mb*4+3], ar, mb*2048)
  for nb in range(4): _ds_read_b128(k, v[32+nb*4:35+nb*4], br, nb*2048)
  k.emit(s_waitcnt())


def _emit_half1_operand_reads_async(k: Kernel, stage: int) -> None:
  ar, br, _, _ = _stage_read_bases(stage)
  for mb in range(8): _ds_read_b128(k, v[48+mb*4:51+mb*4], ar, mb*2048 + 64)
  for nb in range(4): _ds_read_b128(k, v[80+nb*4:83+nb*4], br, nb*2048 + 1024)


def _mfma_inst(half: int, idx: int):
  nb, mb = divmod(idx, 8)
  abase, bbase = ((0, 32) if half == 0 else (48, 80))
  dst = nb*32 + mb*4
  bsel, asel = (nb & 1) + half*2, (mb & 1) + half*2
  opsel = (bsel & 1) | ((asel & 1) << 1)
  opsel_hi = ((bsel >> 1) & 1) | (((asel >> 1) & 1) << 1)
  return v_mfma_fp4(v[dst:dst+3], v[bbase+nb*4:bbase+nb*4+3], v[abase+mb*4:abase+mb*4+3],
                    opsel, opsel_hi, v[100+nb//2], v[96+mb//2])


def _emit_mfma_range(k: Kernel, half: int, start: int = 0, end: int = 32) -> None:
  for idx in range(start, end): k.emit(_mfma_inst(half, idx))


def _emit_pipelined_body(k: Kernel, current_stage: int, next_stage: int, loop_label: str, other_label: str, last_label: str) -> None:
  k.label(loop_label)
  _emit_half0_operand_reads(k, current_stage)
  # Half-1 LDS reads are independent of half-0 sources. Let them run under all
  # 32 half-0 matrix ops instead of serializing both operand banks up front.
  _emit_half1_operand_reads_async(k, current_stage)
  _emit_mfma_range(k, 0)
  k.emit(s_waitcnt())
  # 20 independent matrix ops retire the half-0 v0..v33 source reads before
  # those registers become destinations of the next-BK VMEM prefetch.
  _emit_mfma_range(k, 1, 0, 20)
  k.emit(s_cmp_eq_u32(s[56], 1))
  k.emit(s_cbranch_scc1(1), target=last_label)
  k.emit(s_add_u32(s[61], LIT, s[61], 128))
  k.emit(s_add_u32(s[62], LIT, s[62], 2048))
  k.emit(s_add_u32(s[63], LIT, s[63], 256))
  _emit_stage_loads(k)
  # Hide VMEM latency behind the remaining half-1 matrix work.
  _emit_mfma_range(k, 1, 20, 32)
  k.emit(s_waitcnt())
  _emit_stage_writes(k, next_stage)
  k.emit(s_waitcnt())
  k.emit(s_barrier())
  k.emit(s_sub_u32(s[56], s[56], 1))
  k.emit(s_branch(1), target=other_label)
  k.label(last_label)
  _emit_mfma_range(k, 1, 20, 32)
  k.emit(s_branch(1), target="PIPE_DONE")


def build_lds_pipelined_kernel(M: int, N: int, K: int):
  if M % 256 or N % 256 or K % 256:
    raise ValueError(f"phase2 LDS pipe requires M/N/K multiples of 256, got {M}x{N}x{K}")
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

  k.emit(v_lshrrev_b32_e32(v[103], 6, v[0]))
  k.emit(v_and_b32_e32(v[102], LIT, v[0], 63))
  k.emit(s_mov_b32(s[46], s[2])); k.emit(s_mov_b32(s[47], s[3]))
  k.emit(v_readfirstlane_b32_e32(v[49], v[103])); k.emit(s_nop(3))
  k.emit(s_and_b32(s[50], s[49], 3)); k.emit(s_lshr_b32(s[51], s[49], 2))

  k.emit(v_mov_b32_e32(v[127], 0))
  for i in range(128): k.emit(v_accvgpr_write(v[i], 0))

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
  k.emit(v_add_u32_e32(v[121], LIT, v[106], STAGE_BYTES))
  k.emit(v_add_u32_e32(v[122], LIT, v[116], STAGE_BYTES))

  k.emit(v_lshrrev_b32_e32(v[114], 6, v[0])); k.emit(v_mul_i32_i24_e32(v[114], LIT, v[114], K))
  k.emit(v_lshlrev_b32_e32(v[115], 2, v[102])); k.emit(v_add_u32_e32(v[114], v[115], v[114]))

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
  for dst, src in ((117,107),(118,108),(119,109),(120,110)):
    k.emit(v_add_u32_e32(v[dst], LIT, v[src], STAGE_BYTES))

  k.emit(s_mul_i32(s[52], s[47], LIT, 256)); k.emit(s_mul_i32(s[57], LIT, s[52], half_k))
  k.emit(s_mul_i32(s[52], s[46], LIT, 256)); k.emit(s_mul_i32(s[58], LIT, s[52], half_k))
  k.emit(s_mul_i32(s[52], s[47], 8)); k.emit(s_mul_i32(s[59], LIT, s[52], K))
  k.emit(s_mul_i32(s[52], s[46], 8)); k.emit(s_mul_i32(s[60], LIT, s[52], K))
  k.emit(s_mov_b32(s[61], 0)); k.emit(s_mov_b32(s[62], 0)); k.emit(s_mov_b32(s[63], 0))
  k.emit(s_mov_b32(s[56], K//256))

  k.emit(s_mov_b32(NULL, -1))
  _emit_initial_stage(k)
  _emit_pipelined_body(k, 0, 1, "PIPE_LOOP0", "PIPE_LOOP1", "PIPE_LAST0")
  _emit_pipelined_body(k, 1, 0, "PIPE_LOOP1", "PIPE_LOOP0", "PIPE_LAST1")
  k.label("PIPE_DONE")
  k.emit(s_nop(15)); k.emit(s_nop(3))
  _emit_epilogue(k, M, N)
  k.emit(s_waitcnt()); k.emit(s_endpgm())
  return k.finalize()
