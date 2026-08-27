"""Throughput-scheduled 4-wave MXFP4 kernel for gfx950.

This is a schedule-only rewrite of the GPU-proven v16 phase2_4w_d2l kernel:
  * same 128x256 WG / 128x64 wave output ownership
  * same 16x16x128 scaled FP4 MFMA operands, scales and AccVGPR destinations
  * same two 8KiB A LDS stages and direct B/scales
  * same 128 regular + 128 AccVGPR allocation target

The difference is the hot-loop issue schedule.  A LDS reads are locally pipelined
four-deep, the next A D2L is launched as soon as current DS reads have all been
issued, and next B dwordx4 loads are spaced by four 16-cycle MFMAs.  Partial
S_WAITCNTs only release the exact current operands while future prefetches remain
in flight across the workgroup barrier.
"""
# ruff: noqa: F403,F405,E501
from tinygrad.runtime.autogen.amd.cdna.ins import *
from extra.gemm.gemm_mxfp4 import Kernel, v_mfma_fp4
from extra.gemm.cdna_lib.phase2_lds import _ds_read_b128
from extra.gemm.cdna_lib.phase2_4w import _emit_epilogue

TILE_M, TILE_N, THREADS = 128, 256, 256
A_STAGE_BYTES = 8 * 1024
A0_LDS, A1_LDS = 0, A_STAGE_BYTES
USED_LDS_BYTES = 2 * A_STAGE_BYTES
LDS_BYTES = 13 * 1280


def _waitcnt_imm(vm:int=63, lgkm:int=15, exp:int=7) -> int:
  assert 0 <= vm <= 63 and 0 <= lgkm <= 15 and 0 <= exp <= 7
  return (vm&0xf) | (exp<<4) | (lgkm<<8) | (((vm>>4)&0x3)<<14)


def _wait(k:Kernel, *, vm:int=63, lgkm:int=15) -> None:
  k.emit(s_waitcnt(_waitcnt_imm(vm=vm, lgkm=lgkm)))


def _a_d2l_one(k:Kernel, half_k:int, odd:bool, stage:int, j:int) -> None:
  """Issue one of the two per-wave A D2L operations for a K128 half."""
  assert stage in (0,1) and j in (0,1)
  k.emit(s_add_u32(s[52], s[57], s[61]))
  if odd: k.emit(s_add_u32(s[52], LIT, s[52], 64))
  if j: k.emit(s_add_u32(s[52], LIT, s[52], 16*half_k))
  m0off = (A1_LDS if stage else A0_LDS) + j*1024
  if m0off: k.emit(s_add_u32(NULL, LIT, s[64], m0off))
  else: k.emit(s_add_u32(NULL, 0, s[64]))
  # CDNA4 requires one independent wait between SALU->M0 and LDS DMA use.
  k.emit(s_nop())
  k.emit(buffer_load_dwordx4(v[0:3], v[104], s[12:15], s[52], 0, 1, 0, 0, 0, 0, 1))


def _a_d2l_pair(k:Kernel, half_k:int, odd:bool, stage:int) -> None:
  _a_d2l_one(k, half_k, odd, stage, 0)
  _a_d2l_one(k, half_k, odd, stage, 1)


def _a_read_one(k:Kernel, stage:int, bank:int, mb:int) -> None:
  assert stage in (0,1) and bank in (0,1) and 0 <= mb < 8
  ar = v[107] if stage == 0 else v[108]
  abase = 0 if bank == 0 else 48
  _ds_read_b128(k, v[abase+mb*4:abase+mb*4+3], ar, mb*1024)


def _a_read_head(k:Kernel, stage:int, bank:int) -> None:
  for mb in range(4): _a_read_one(k, stage, bank, mb)


def _b_load_one(k:Kernel, half_k:int, odd:bool, bank:int, nb:int) -> None:
  assert bank in (0,1) and 0 <= nb < 4
  bbase = 32 if bank == 0 else 80
  k.emit(s_add_u32(s[52], s[58], s[62]))
  if odd: k.emit(s_add_u32(s[52], LIT, s[52], 1024))
  if nb: k.emit(s_add_u32(s[53], LIT, s[52], nb*16*half_k))
  else: k.emit(s_mov_b32(s[53], s[52]))
  k.emit(buffer_load_dwordx4(v[bbase+nb*4:bbase+nb*4+3], v[105], s[16:19], s[53], 0, 1))


def _b_load_all(k:Kernel, half_k:int, odd:bool, bank:int) -> None:
  for nb in range(4): _b_load_one(k, half_k, odd, bank, nb)


def _scale_load_one(k:Kernel, K:int, base:int, idx:int) -> None:
  """Load one packed scale dword. idx 0..3=A, 4..5=B."""
  assert base in (96,112) and 0 <= idx < 6
  if idx < 4:
    k.emit(s_add_u32(s[52], s[59], s[63]))
    if idx: k.emit(s_add_u32(s[53], LIT, s[52], idx*K))
    else: k.emit(s_mov_b32(s[53], s[52]))
    k.emit(buffer_load_dword(v[base+idx], v[106], s[20:23], s[53], 0, 1))
  else:
    p = idx-4
    k.emit(s_add_u32(s[52], s[60], s[63]))
    if p: k.emit(s_add_u32(s[53], LIT, s[52], K))
    else: k.emit(s_mov_b32(s[53], s[52]))
    k.emit(buffer_load_dword(v[base+idx], v[106], s[24:27], s[53], 0, 1))


def _scale_load_all(k:Kernel, K:int, base:int) -> None:
  for i in range(6): _scale_load_one(k, K, base, i)


def _mfma_one(k:Kernel, mb:int, nb:int, half:int, bank:int, scale_base:int) -> None:
  assert 0 <= mb < 8 and 0 <= nb < 4 and half in (0,1) and bank in (0,1)
  assert scale_base in (96,112)
  abase = 0 if bank == 0 else 48
  bbase = 32 if bank == 0 else 80
  dst = nb*32 + mb*4
  bsel, asel = (nb&1)+half*2, (mb&1)+half*2
  opsel = (bsel&1) | ((asel&1)<<1)
  opsel_hi = ((bsel>>1)&1) | (((asel>>1)&1)<<1)
  k.emit(v_mfma_fp4(v[dst:dst+3], v[bbase+nb*4:bbase+nb*4+3], v[abase+mb*4:abase+mb*4+3],
                     opsel, opsel_hi, v[scale_base+4+nb//2], v[scale_base+mb//2]))


def _run_half(k:Kernel, K:int, half:int, stage:int, bank:int, scale_base:int, *,
              next_odd:bool|None, next_stage:int|None, next_bank:int|None, next_scale_base:int|None) -> None:
  """Execute one K128 half while scheduling the next half under its 32 MFMAs.

  Entry state:
    * four current A DS reads (mb0..3) are outstanding;
    * current scale loads (if newly loaded) precede current B0..B3 in VM order;
    * no future-half VM operations have yet been issued.
  """
  half_k = K//2
  # Current B0 and all current scales are enough to start.  Four A reads are
  # queued; lgkm(3) releases mb0 only.
  _wait(k, vm=3, lgkm=3)

  # N block 0: consume the eight A blocks while extending the local-prefetch
  # queue one read per MFMA.  Four-deep gives each DS read >=4*16 matrix cycles.
  for mb in range(8):
    if mb:
      # Queue remains four-deep through mb4, then drains 3/2/1/0.
      target = 3 if mb <= 4 else 7-mb
      _wait(k, lgkm=target)
    _mfma_one(k, mb, 0, half, bank, scale_base)
    if mb < 4: _a_read_one(k, stage, bank, mb+4)
    # Once every current DS read has been issued, start the next A stage.  The
    # two D2L operations are older than all future scales/B, enabling a partial
    # VM wait at the stage boundary.
    if next_odd is not None and mb == 4:
      _a_d2l_one(k, half_k, next_odd, next_stage, 0)  # type: ignore[arg-type]
    if next_odd is not None and mb == 6:
      _a_d2l_one(k, half_k, next_odd, next_stage, 1)  # type: ignore[arg-type]

  # B1..B3 had eight MFMAs (~128 matrix cycles) to return.  Drain only those
  # three current loads; keep the two next-A D2Ls in flight.
  _wait(k, vm=2 if next_odd is not None else 0)

  # Remaining 24 MFMAs are the global-prefetch issue window.  If the next half
  # needs a new scale bank, place all six scale dwords before B0 so vmcnt(3) at
  # the next half start means "new scales + B0 ready".  B dwordx4 loads are
  # separated by four MFMAs, matching the ~64-cycle gfx950 throughput cadence.
  pos = 0
  if next_odd is not None:
    scale_positions = {0:0, 2:1, 4:2, 6:3, 8:4, 10:5} if next_scale_base is not None else {}
    b_positions = (11,15,19,23) if next_scale_base is not None else (4,8,12,16)
  else:
    scale_positions, b_positions = {}, ()

  for nb in range(1,4):
    for mb in range(8):
      _mfma_one(k, mb, nb, half, bank, scale_base)
      if next_scale_base is not None and pos in scale_positions:
        _scale_load_one(k, K, next_scale_base, scale_positions[pos])
      if next_bank is not None and pos in b_positions:
        _b_load_one(k, half_k, next_odd, next_bank, b_positions.index(pos))  # type: ignore[arg-type]
      pos += 1

  if next_odd is not None:
    tail = 4 + (6 if next_scale_base is not None else 0)
    # The two next-A D2Ls are oldest.  Make only those visible, leaving the
    # future B/scales outstanding across the barrier.
    _wait(k, vm=tail)
    k.emit(s_mov_b32(NULL, -1)); k.emit(s_barrier())
    _a_read_head(k, next_stage, next_bank)  # type: ignore[arg-type]


def build_4w_sched_kernel(M:int, N:int, K:int):
  if M%TILE_M or N%TILE_N or K%512:
    raise ValueError(f"phase2_4w_sched requires M%128=N%256=0 and K%512=0, got {M}x{N}x{K}")
  half_k, scale_k = K//2, K//32
  k = Kernel()

  k.emit(s_and_b32(s[1], s[1], LIT, 65535))
  for dst,off in ((4,0),(12,8),(16,16),(20,24),(24,32)):
    k.emit(s_load_dwordx2(s[dst:dst+1], s[0:1], s[0], off, 0,0,0,1))
  k.emit(s_waitcnt())
  for hi in (5,13,17,21,25):
    k.emit(s_and_b32(s[hi], s[hi], LIT, 65535)); k.emit(s_or_b32(s[hi], s[hi], LIT, 262144))
  for cfg in (7,15,19,23,27): k.emit(s_mov_b32(s[cfg], LIT, 131072))
  k.emit(s_mov_b32(s[6], LIT, M*N*2))
  k.emit(s_mov_b32(s[14], LIT, M*half_k)); k.emit(s_mov_b32(s[18], LIT, N*half_k))
  k.emit(s_mov_b32(s[22], LIT, M*scale_k)); k.emit(s_mov_b32(s[26], LIT, N*scale_k))

  k.emit(v_lshrrev_b32_e32(v[103], 6, v[0])); k.emit(v_and_b32_e32(v[102], LIT, v[0], 63))
  k.emit(s_mov_b32(s[46], s[2])); k.emit(s_mov_b32(s[47], s[3]))
  k.emit(v_readfirstlane_b32_e32(v[49], v[103])); k.emit(s_nop(3))
  k.emit(v_mov_b32_e32(v[127], 0))
  for i in range(128): k.emit(v_accvgpr_write(v[i], 0))

  # Same GPU-proven v16 lane-local address equations.
  k.emit(v_lshrrev_b32_e32(v[104], 2, v[102])); k.emit(v_mul_i32_i24_e32(v[104], LIT, v[104], half_k))
  k.emit(v_and_b32_e32(v[119], LIT, v[102], 3)); k.emit(v_lshlrev_b32_e32(v[119], 4, v[119])); k.emit(v_add_u32_e32(v[104], v[119], v[104]))
  k.emit(v_lshlrev_b32_e32(v[105], 4, v[102])); k.emit(v_lshlrev_b32_e32(v[106], 2, v[102]))
  k.emit(v_and_b32_e32(v[107], LIT, v[102], 15)); k.emit(v_lshlrev_b32_e32(v[107], 6, v[107]))
  k.emit(v_lshrrev_b32_e32(v[119], 4, v[102])); k.emit(v_lshlrev_b32_e32(v[119], 4, v[119])); k.emit(v_add_u32_e32(v[107], v[119], v[107])); k.emit(v_add_u32_e32(v[108], LIT, v[107], A1_LDS))

  k.emit(s_mul_i32(s[52], s[47], LIT, 128)); k.emit(s_mul_i32(s[53], s[49], 32)); k.emit(s_add_u32(s[52], s[52], s[53])); k.emit(s_mul_i32(s[57], LIT, s[52], half_k)); k.emit(s_lshl_b32(s[64], s[49], 11))
  k.emit(s_mul_i32(s[52], s[46], LIT, 256)); k.emit(s_mul_i32(s[53], s[49], 64)); k.emit(s_add_u32(s[52], s[52], s[53])); k.emit(s_mul_i32(s[58], LIT, s[52], half_k))
  k.emit(s_mul_i32(s[52], s[47], 4)); k.emit(s_mul_i32(s[59], LIT, s[52], K))
  k.emit(s_mul_i32(s[52], s[46], 8)); k.emit(s_mul_i32(s[53], s[49], 2)); k.emit(s_add_u32(s[52], s[52], s[53])); k.emit(s_mul_i32(s[60], LIT, s[52], K))
  k.emit(s_mov_b32(s[61], 0)); k.emit(s_mov_b32(s[62], 0)); k.emit(s_mov_b32(s[63], 0))
  k.emit(s_mov_b32(s[56], K//512))

  # Startup Pair A even.  A is oldest, then scales, then B.  Waiting vmcnt(10)
  # makes only A visible; scale/B can continue while the barrier resolves.
  _a_d2l_pair(k, half_k, False, 0); _scale_load_all(k, K, 96); _b_load_all(k, half_k, False, 0)
  _wait(k, vm=10); k.emit(s_mov_b32(NULL,-1)); k.emit(s_barrier()); _a_read_head(k, 0, 0)

  k.label("SUPER")
  # Pair A even -> odd.  Same scales; prefetch odd B only.
  _run_half(k, K, 0, 0, 0, 96, next_odd=True, next_stage=1, next_bank=1, next_scale_base=None)

  # Pair A odd -> Pair B even.  Advance BK256 base before prefetching Pair B and
  # fill the alternate scale bank under current MFMA.
  k.emit(s_add_u32(s[61], LIT, s[61], 128)); k.emit(s_add_u32(s[62], LIT, s[62], 2048)); k.emit(s_add_u32(s[63], LIT, s[63], 256))
  _run_half(k, K, 1, 1, 1, 96, next_odd=False, next_stage=0, next_bank=0, next_scale_base=112)

  # Pair B even -> odd.  Same alternate scales.
  _run_half(k, K, 0, 0, 0, 112, next_odd=True, next_stage=1, next_bank=1, next_scale_base=None)
  k.emit(s_cmp_eq_u32(s[56], 1)); k.emit(s_cbranch_scc1(1), target="LAST_ODD")

  # Pair B odd -> next super Pair A even.
  k.emit(s_add_u32(s[61], LIT, s[61], 128)); k.emit(s_add_u32(s[62], LIT, s[62], 2048)); k.emit(s_add_u32(s[63], LIT, s[63], 256))
  _run_half(k, K, 1, 1, 1, 112, next_odd=False, next_stage=0, next_bank=0, next_scale_base=96)
  k.emit(s_sub_u32(s[56], s[56], 1)); k.emit(s_branch(1), target="SUPER")

  k.label("LAST_ODD")
  _run_half(k, K, 1, 1, 1, 112, next_odd=None, next_stage=None, next_bank=None, next_scale_base=None)
  # Epilogue setup supplies ample independent work before the first AccVGPR read.
  _emit_epilogue(k, M, N)
  k.emit(s_waitcnt()); k.emit(s_endpgm())
  return k.finalize()
