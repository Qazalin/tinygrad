# ruff: noqa: E501,F403,F405
"""Eight-wave cooperative MFMA32 short-K MXFP4 GEMM for gfx950."""
from tinygrad.runtime.autogen.amd.cdna.ins import *

PANEL_BYTES, LDS_BYTES = 40960, 81920

class Kernel:
  def __init__(self): self.instructions, self.labels, self.pos = [], {}, 0
  def label(self, name): self.labels[name] = self.pos
  def emit(self, inst, target=None):
    self.instructions.append(inst); inst._target, inst._pos = target, self.pos; self.pos += inst.size()
  def finalize(self):
    for inst in self.instructions:
      if inst._target is not None: inst.simm16 = (self.labels[inst._target] - inst._pos - inst.size()) // 4
    return self.instructions

def get_launch_config(M:int, N:int, K:int) -> tuple[int, tuple[int, int]]:
  assert M == 16384 and N in (14336, 28672) and K == 4096
  return 512, (N//256, M//256)

def mfma32(dst, a, b, scale_a, scale_b):
  return v_mfma_scale_f32_32x32x64_f8f6f4(dst, a, b, dst, 0, 0, 0, 0, 4, 1, 1, 0, 4, 0xD3AC,
                                           scale_a.offset, scale_b.offset)

def build_kernel(M:int, N:int, K:int):
  get_launch_config(M, N, K)
  k, e = Kernel(), None
  e = k.emit
  e(s_mov_b32(s[41], LIT, N*2)); e(s_and_b32(s[1], s[1], LIT, 65535))
  for desc, offset, size in ((4, 0, M*N*2), (8, 8, M*K//2), (12, 16, N*K//2),
                             (16, 24, M*K//32), (20, 32, N*K//32)):
    e(s_load_dwordx2(s[desc:desc+1], s[0:1], s[0], offset=offset, imm=1))
    e(s_mov_b32(s[desc+2], LIT, size)); e(s_mov_b32(s[desc+3], LIT, 131072))

  # v60 lane, v61 lane%32, v62 lane/32; s28 wave, s29/s30 output M/N.
  e(v_lshrrev_b32_e32(v[63], 6, v[0])); e(s_nop(3)); e(v_readfirstlane_b32_e32(v[28], v[63]))
  e(v_and_b32_e32(v[60], 63, v[0])); e(v_and_b32_e32(v[61], 31, v[60])); e(v_lshrrev_b32_e32(v[62], 5, v[60]))
  e(s_lshr_b32(s[29], s[28], 1)); e(s_lshl_b32(s[29], s[29], 6)); e(s_lshl_b32(s[24], s[3], 8)); e(s_add_u32(s[29], s[29], s[24]))
  e(s_and_b32(s[30], s[28], 1)); e(s_lshl_b32(s[30], s[30], 7)); e(s_lshl_b32(s[24], s[2], 8)); e(s_add_u32(s[30], s[30], s[24]))
  e(s_waitcnt(0))
  for desc in (4, 8, 12, 16, 20):
    e(s_and_b32(s[desc+1], s[desc+1], LIT, 65535)); e(s_or_b32(s[desc+1], s[desc+1], LIT, 262144))

  # Each loader wave owns one 32-row A fragment and one 32-row B fragment.
  e(s_lshl_b32(s[24], s[28], 5)); e(s_lshl_b32(s[25], s[3], 8)); e(s_add_u32(s[24], s[24], s[25]))
  e(v_add_u32_e32(v[64], s[24], v[61])); e(v_lshlrev_b32_e32(v[64], 11, v[64]))
  e(v_lshlrev_b32_e32(v[90], 4, v[62])); e(v_add_u32_e32(v[64], v[64], v[90]))
  e(s_lshl_b32(s[24], s[28], 5)); e(s_lshl_b32(s[25], s[2], 8)); e(s_add_u32(s[24], s[24], s[25]))
  e(v_add_u32_e32(v[65], s[24], v[61])); e(v_lshrrev_b32_e32(v[65], 4, v[65])); e(v_lshlrev_b32_e32(v[65], 15, v[65]))
  e(v_lshlrev_b32_e32(v[90], 4, v[61])); e(v_add_u32_e32(v[65], v[65], v[90]))
  e(v_lshlrev_b32_e32(v[90], 8, v[62])); e(v_add_u32_e32(v[65], v[65], v[90]))

  def scale_addr(dst:int, row_s):
    e(s_lshr_b32(s[25], row_s, 5)); e(s_lshl_b32(s[25], s[25], 12))
    e(s_lshr_b32(s[26], row_s, 4)); e(s_and_b32(s[26], s[26], 1)); e(s_add_u32(s[25], s[25], s[26]))
    e(v_lshlrev_b32_e32(v[dst], 2, v[61])); e(v_lshlrev_b32_e32(v[90], 6, v[62]))
    e(v_add_u32_e32(v[dst], v[dst], v[90])); e(v_add_u32_e32(v[dst], s[25], v[dst]))
  e(s_lshl_b32(s[24], s[28], 5)); e(s_lshl_b32(s[25], s[3], 8)); e(s_add_u32(s[24], s[24], s[25])); scale_addr(66, s[24])
  e(s_lshl_b32(s[24], s[28], 5)); e(s_lshl_b32(s[25], s[2], 8)); e(s_add_u32(s[24], s[24], s[25])); scale_addr(67, s[24])

  # LDS loader bases and compute bases. Each K64 slab is 20 KiB.
  e(v_lshlrev_b32_e32(v[88], 4, v[60])); e(v_lshlrev_b32_e32(v[89], 2, v[60]))
  e(s_lshl_b32(s[32], s[28], 10)); e(s_lshl_b32(s[33], s[28], 8))
  e(v_add_u32_e32(v[80], s[33], v[89])); e(v_add_u32_e32(v[81], s[33], v[89]))
  e(s_lshr_b32(s[24], s[28], 1)); e(s_lshl_b32(s[25], s[24], 11)); e(v_add_u32_e32(v[76], s[25], v[88]))
  e(s_lshl_b32(s[25], s[24], 9)); e(v_add_u32_e32(v[78], s[25], v[89]))
  e(s_and_b32(s[24], s[28], 1)); e(s_lshl_b32(s[25], s[24], 12)); e(v_add_u32_e32(v[77], s[25], v[88]))
  e(s_lshl_b32(s[25], s[24], 10)); e(v_add_u32_e32(v[79], s[25], v[89]))

  def issue_chunk(chunk:int, bank:int):
    for slab in range(2):
      e(s_add_u32(s[25], s[32], bank+slab*20480)); e(s_add_u32(NULL, 0, s[25]))
      e(buffer_load_dwordx4(v[0:3], v[64], s[8:11], soffset=0, offen=1, lds=1))
      e(s_add_u32(s[25], s[32], bank+8192+slab*20480)); e(s_add_u32(NULL, 0, s[25]))
      e(buffer_load_dwordx4(v[0:3], v[65], s[12:15], soffset=0, offen=1, lds=1))
      e(buffer_load_ubyte(v[92+slab*2], v[66], s[16:19], soffset=0, offen=1))
      e(buffer_load_ubyte(v[93+slab*2], v[67], s[20:23], soffset=0, offen=1))
      if slab == 0:
        e(v_add_u32_e32(v[64], LIT, v[64], 32)); e(v_add_u32_e32(v[65], LIT, v[65], 512))
        e(v_add_u32_e32(v[66], LIT, v[66], 128)); e(v_add_u32_e32(v[67], LIT, v[67], 128))
    if chunk < 31:
      e(v_add_u32_e32(v[64], LIT, v[64], 32)); e(v_add_u32_e32(v[65], LIT, v[65], 512))
      delta = -126 if chunk % 2 == 0 else 126
      e(v_add_u32_e32(v[66], LIT, v[66], delta)); e(v_add_u32_e32(v[67], LIT, v[67], delta))

  def commit_scales(bank:int):
    for slab in range(2):
      e(v_mov_b32_e32(v[90], v[80])); e(v_mov_b32_e32(v[91], v[81]))
      if bank:
        e(v_add_u32_e32(v[90], LIT, v[90], bank)); e(v_add_u32_e32(v[91], LIT, v[91], bank))
      ao, bo = 16384+slab*20480, 18432+slab*20480
      e(ds_write_b32(addr=v[90], data0=v[92+slab*2], offset0=ao&255, offset1=ao>>8))
      e(ds_write_b32(addr=v[91], data0=v[93+slab*2], offset0=bo&255, offset1=bo>>8))

  def compute_chunk(bank:int):
    for slab in range(2):
      base = bank + slab*20480
      for i in range(4):
        if base: e(v_add_u32_e32(v[84+i], LIT, v[76+i], base))
        else: e(v_mov_b32_e32(v[84+i], v[76+i]))
      ap, bp, ass, bss = v[84], v[85], v[86], v[87]
      for m in range(2):
        e(ds_read_b128(v[m*4:m*4+3], ap, offset0=(m*1024)&255, offset1=(m*1024)>>8))
        e(ds_read_b32(v[48+m], ass, offset0=(16384+m*256)&255, offset1=(16384+m*256)>>8))
      for n in range(4):
        e(ds_read_b128(v[8+n*4:11+n*4], bp, offset0=(8192+n*1024)&255, offset1=(8192+n*1024)>>8))
        e(ds_read_b32(v[50+n], bss, offset0=(18432+n*256)&255, offset1=(18432+n*256)>>8))
      e(s_waitcnt(0))
      for m in range(2):
        for n in range(4):
          acc=(m*4+n)*16
          e(mfma32(v[acc:acc+15], v[m*4:m*4+3], v[8+n*4:11+n*4], v[48+m], v[50+n]))

  for r in range(128): e(v_accvgpr_write(v[r], 0))
  issue_chunk(0, 0); e(s_waitcnt(0)); commit_scales(0); e(s_waitcnt(0)); e(s_barrier())
  for chunk in range(32):
    bank, nxt = (0, PANEL_BYTES) if chunk % 2 == 0 else (PANEL_BYTES, 0)
    if chunk < 31: issue_chunk(chunk+1, nxt)
    compute_chunk(bank)
    if chunk < 31: e(s_waitcnt(0)); commit_scales(nxt); e(s_waitcnt(0)); e(s_barrier())

  # Verified MFMA32 accumulator-to-output lane mapping.
  for m in range(2):
    for n in range(4):
      acc=(m*4+n)*16
      for q in range(0,16,4):
        for j in range(4): e(v_accvgpr_read(v[40+j], v[acc+q+j]))
        e(s_nop(1)); e(v_cvt_pk_bf16_f32(v[44], v[40], v[41])); e(v_cvt_pk_bf16_f32(v[45], v[42], v[43]))
        for j in range(4):
          row_group,row_in=divmod(q+j,4)
          e(v_lshlrev_b32_e32(v[46],2,v[62])); e(v_add_u32_e32(v[46],LIT,v[46],row_group*8+row_in+m*32))
          e(v_add_u32_e32(v[46],s[29],v[46])); e(v_mul_lo_u32(v[46],v[46],s[41]))
          e(v_add_u32_e32(v[47],s[30],v[61]))
          if n: e(v_add_u32_e32(v[47],LIT,v[47],n*32))
          e(v_lshlrev_b32_e32(v[47],1,v[47])); e(v_add_u32_e32(v[46],v[46],v[47]))
          src=v[44+j//2]
          if j&1: e(v_lshrrev_b32_e32(v[47],16,src)); src=v[47]
          e(buffer_store_short(src,v[46],s[4:7],soffset=0,offen=1))
  e(s_waitcnt(0)); e(s_endpgm())
  return k.finalize()
