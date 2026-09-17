# ruff: noqa: E501,F403,F405
"""Short-K gfx950 MXFP4 GEMM with two resident MFMA16 waves per SIMD.

Four waves compute 64x128 pieces of a 128x256 workgroup tile.  The waves
cooperatively populate alternating MFMA-ready LDS panels, allowing two
workgroups per CU while overlapping the next panel with current MFMA.
"""
from tinygrad.runtime.autogen.amd.cdna.ins import *

LDS_PANEL_BYTES = 30720
LDS_BANK_BYTES = LDS_PANEL_BYTES
LDS_BYTES = 2 * LDS_BANK_BYTES

class Kernel:
  def __init__(self): self.instructions, self.labels, self.pos = [], {}, 0
  def label(self, name): self.labels[name] = self.pos
  def emit(self, inst, target=None):
    self.instructions.append(inst)
    inst._target, inst._pos = target, self.pos
    self.pos += inst.size()
  def finalize(self):
    for inst in self.instructions:
      if inst._target is not None:
        delta = (self.labels[inst._target] - inst._pos - inst.size()) // 4
        assert -32768 <= delta < 32768
        inst.simm16 = delta
    return self.instructions

def get_launch_config(M:int, N:int, K:int) -> tuple[int, tuple[int, int]]:
  assert M == 16384 and N in (14336, 28672) and K == 4096
  return 256, (N//256, M//128)

def mfma16(dst, a, b, scale_a, scale_b):
  return v_mfma_scale_f32_16x16x128_f8f6f4(dst, a, b, dst, 0, 0, 0, 0, 4, 1, 1, 0, 4, 0xD3AC,
                                             scale_a.offset, scale_b.offset)

def build_kernel(M:int, N:int, K:int):
  get_launch_config(M, N, K)
  k = Kernel()
  e = k.emit
  e(s_mov_b32(s[41], LIT, N*2))

  # C/A/B/scale-A/scale-B descriptors.
  e(s_and_b32(s[1], s[1], LIT, 65535))
  for desc, offset, size in ((4, 0, M*N*2), (8, 8, M*K//2), (12, 16, N*K//2),
                             (16, 24, M*K//32), (20, 32, N*K//32)):
    e(s_load_dwordx2(s[desc:desc+1], s[0:1], s[0], offset=offset, imm=1))
    e(s_mov_b32(s[desc+2], LIT, size))
    e(s_mov_b32(s[desc+3], LIT, 131072))

  # v60=lane, v61=lane%16, v62=lane/16.  s28=wave within WG.
  e(v_lshrrev_b32_e32(v[63], 6, v[0]))
  e(s_nop(3))
  e(v_readfirstlane_b32_e32(v[28], v[63]))
  e(v_and_b32_e32(v[60], 63, v[0]))
  e(v_and_b32_e32(v[61], 15, v[60]))
  e(v_lshrrev_b32_e32(v[62], 4, v[60]))

  # Two 64-row wave strips in M and two 128-column wave strips in N.
  e(s_lshr_b32(s[29], s[28], 1))
  e(s_lshl_b32(s[29], s[29], 6))
  e(s_lshl_b32(s[24], s[3], 7))
  e(s_mov_b32(s[31], s[24]))
  e(s_add_u32(s[29], s[29], s[24]))
  e(s_and_b32(s[30], s[28], 1))
  e(s_lshl_b32(s[30], s[30], 7))
  e(s_lshl_b32(s[24], s[2], 8))
  e(s_mov_b32(s[32], s[24]))
  e(s_add_u32(s[30], s[30], s[24]))
  e(s_waitcnt(0))
  for desc in (4, 8, 12, 16, 20):
    e(s_and_b32(s[desc+1], s[desc+1], LIT, 65535))
    e(s_or_b32(s[desc+1], s[desc+1], LIT, 262144))

  # LDS lane addresses for payload and scales.
  e(v_lshlrev_b32_e32(v[88], 4, v[60]))
  e(v_lshlrev_b32_e32(v[89], 2, v[60]))

  # Each wave permanently owns two A and four B loader fragments. Compute all
  # global addresses once; panels advance with cheap vector adds.
  e(s_lshl_b32(s[33], s[28], 5))
  e(s_lshl_b32(s[38], s[28], 6))
  e(s_add_u32(s[34], s[31], s[33]))
  e(s_add_u32(s[35], s[32], s[38]))
  e(s_lshl_b32(s[36], s[28], 11))
  e(s_lshl_b32(s[39], s[28], 12))
  e(s_lshl_b32(s[37], s[28], 9))
  e(s_lshl_b32(s[40], s[28], 10))
  for j in range(2):
    # A payload address.
    e(s_add_u32(s[24], s[34], j*16))
    e(v_add_u32_e32(v[64+j], s[24], v[61]))
    e(v_lshlrev_b32_e32(v[64+j], 11, v[64+j]))
    e(v_lshlrev_b32_e32(v[90], 4, v[62]))
    e(v_add_u32_e32(v[64+j], v[64+j], v[90]))
  for j in range(4):
    # B payload address in its shuffled layout.
    e(s_add_u32(s[24], s[35], j*16))
    e(v_add_u32_e32(v[66+j], s[24], v[61]))
    e(v_lshrrev_b32_e32(v[66+j], 4, v[66+j]))
    e(v_lshlrev_b32_e32(v[66+j], 15, v[66+j]))
    e(v_lshlrev_b32_e32(v[90], 8, v[62]))
    e(v_add_u32_e32(v[66+j], v[66+j], v[90]))
    e(v_lshlrev_b32_e32(v[90], 4, v[61]))
    e(v_add_u32_e32(v[66+j], v[66+j], v[90]))

  def init_scale_addr(dst:int, row_s):
    e(s_lshr_b32(s[25], row_s, 5))
    e(s_lshl_b32(s[25], s[25], 12))
    e(s_lshr_b32(s[26], row_s, 4))
    e(s_and_b32(s[26], s[26], 1))
    e(s_add_u32(s[25], s[25], s[26]))
    e(v_lshlrev_b32_e32(v[dst], 2, v[61]))
    e(v_lshlrev_b32_e32(v[90], 6, v[62]))
    e(v_add_u32_e32(v[dst], v[dst], v[90]))
    e(v_add_u32_e32(v[dst], s[25], v[dst]))

  for j in range(2):
    e(s_add_u32(s[24], s[34], j*16)); init_scale_addr(70+j, s[24])
  for j in range(4):
    e(s_add_u32(s[24], s[35], j*16)); init_scale_addr(72+j, s[24])

  # Fixed compute-side LDS pointers for both ping-pong banks.
  e(s_lshr_b32(s[24], s[28], 1))
  e(s_lshl_b32(s[25], s[24], 12))
  e(v_add_u32_e32(v[76], s[25], v[88]))
  e(s_lshl_b32(s[25], s[24], 10))
  e(v_add_u32_e32(v[78], s[25], v[89]))
  e(s_and_b32(s[24], s[28], 1))
  e(s_lshl_b32(s[25], s[24], 13))
  e(v_add_u32_e32(v[77], s[25], v[88]))
  e(s_lshl_b32(s[25], s[24], 11))
  e(v_add_u32_e32(v[79], s[25], v[89]))
  e(v_add_u32_e32(v[80], s[37], v[89]))
  e(v_add_u32_e32(v[81], s[40], v[89]))

  def issue_panel(panel:int, bank:int):
    for j in range(2):
      e(s_add_u32(s[25], s[36], bank+j*1024))
      e(s_add_u32(NULL, 0, s[25]))
      e(buffer_load_dwordx4(v[0:3], v[64+j], s[8:11], soffset=0, offen=1, lds=1))
      e(buffer_load_ubyte(v[92+j], v[70+j], s[16:19], soffset=0, offen=1))
    for j in range(4):
      e(s_add_u32(s[25], s[39], bank+8192+j*1024))
      e(s_add_u32(NULL, 0, s[25]))
      e(buffer_load_dwordx4(v[0:3], v[66+j], s[12:15], soffset=0, offen=1, lds=1))
      e(buffer_load_ubyte(v[94+j], v[72+j], s[20:23], soffset=0, offen=1))
    if panel < 31:
      for reg in range(64, 66): e(v_add_u32_e32(v[reg], LIT, v[reg], 64))
      for reg in range(66, 70): e(v_add_u32_e32(v[reg], LIT, v[reg], 1024))
      delta = 2 if panel % 2 == 0 else 254
      for reg in range(70, 76): e(v_add_u32_e32(v[reg], LIT, v[reg], delta))

  def commit_scales(bank:int):
    for j in range(2):
      e(v_mov_b32_e32(v[90], v[80]))
      if bank: e(v_add_u32_e32(v[90], LIT, v[90], bank))
      e(ds_write_b32(addr=v[90], data0=v[92+j], offset0=(24576+j*256)&255, offset1=(24576+j*256)>>8))
    for j in range(4):
      e(v_mov_b32_e32(v[90], v[81]))
      if bank: e(v_add_u32_e32(v[90], LIT, v[90], bank))
      e(ds_write_b32(addr=v[90], data0=v[94+j], offset0=(26624+j*256)&255, offset1=(26624+j*256)>>8))

  def compute_panel(panel_base:int):
    for i in range(4):
      if panel_base: e(v_add_u32_e32(v[84+i], LIT, v[76+i], panel_base))
      else: e(v_mov_b32_e32(v[84+i], v[76+i]))
    ap, bp, ass, bss = v[84], v[85], v[86], v[87]
    for mi in range(4):
      e(ds_read_b128(v[mi*4:mi*4+3], ap, offset0=(mi*1024)&255, offset1=(mi*1024)>>8))
      e(ds_read_b32(v[48+mi], ass, offset0=(24576+mi*256)&255, offset1=(24576+mi*256)>>8))
    for ni in range(8):
      e(ds_read_b128(v[16+ni*4:19+ni*4], bp, offset0=(8192+ni*1024)&255, offset1=(8192+ni*1024)>>8))
      e(ds_read_b32(v[52+ni], bss, offset0=(26624+ni*256)&255, offset1=(26624+ni*256)>>8))
    e(s_waitcnt(0))
    for mi in range(4):
      for ni in range(8):
        acc = (mi*8+ni)*4
        e(mfma16(v[acc:acc+3], v[mi*4:mi*4+3], v[16+ni*4:19+ni*4], v[48+mi], v[52+ni]))

  for acc in range(128): e(v_accvgpr_write(v[acc], 0))
  issue_panel(0, 0)
  e(s_waitcnt(0))
  commit_scales(0)
  e(s_waitcnt(0))
  e(s_barrier())
  for stage in range(32):
    current_bank = 0 if stage % 2 == 0 else LDS_BANK_BYTES
    next_bank = LDS_BANK_BYTES if stage % 2 == 0 else 0
    if stage < 31: issue_panel(stage+1, next_bank)
    compute_panel(current_bank)
    if stage < 31:
      e(s_waitcnt(0))
      commit_scales(next_bank)
      e(s_waitcnt(0))
      e(s_barrier())

  # MFMA16 output: lane%16 is the column, lane/16 selects a four-row group,
  # and the four accumulator registers are consecutive output rows.
  e(v_lshlrev_b32_e32(v[60], 2, v[62]))
  e(v_add_u32_e32(v[61], s[30], v[61]))
  for mi in range(4):
    for ni in range(8):
      acc = (mi*8+ni)*4
      e(v_accvgpr_read(v[0], v[acc]))
      e(v_accvgpr_read(v[1], v[acc+1]))
      e(v_accvgpr_read(v[2], v[acc+2]))
      e(v_accvgpr_read(v[3], v[acc+3]))
      e(s_nop(1))
      e(v_cvt_pk_bf16_f32(v[4], v[0], v[1]))
      e(v_cvt_pk_bf16_f32(v[5], v[2], v[3]))
      for q in range(4):
        e(v_add_u32_e32(v[6], LIT, v[60], mi*16+q))
        e(v_add_u32_e32(v[6], s[29], v[6]))
        e(v_mul_lo_u32(v[6], v[6], s[41]))
        e(v_add_u32_e32(v[7], LIT, v[61], ni*16))
        e(v_lshlrev_b32_e32(v[7], 1, v[7]))
        e(v_add_u32_e32(v[6], v[6], v[7]))
        src = v[4+q//2]
        if q & 1:
          e(v_lshrrev_b32_e32(v[7], 16, src))
          src = v[7]
        e(buffer_store_short(src, v[6], s[4:7], soffset=0, offen=1))
  e(s_waitcnt(0))
  e(s_endpgm())
  return k.finalize()
