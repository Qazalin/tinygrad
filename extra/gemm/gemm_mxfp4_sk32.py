# ruff: noqa: F403,F405,E501
"""Shape-specialized gfx950 MXFP4 GEMM using 32x32x64 scaled-FP4 MFMAs."""
from extra.gemm.gemm_mxfp4 import Kernel
from tinygrad.helpers import getenv
from tinygrad.runtime.autogen.amd.cdna.ins import *

LDS_BYTES = 92160
PHASES = getenv("MXFP4_SK32_PHASES", 32)
SLABS = 2
B_DOUBLE = getenv("MXFP4_SK32_B_DOUBLE", 1)
SLAB_BARRIER = getenv("MXFP4_SK32_SLAB_BARRIER", 0)
PROFILE = getenv("MXFP4_SK32_PROFILE", 0)
SAFE_LDS = getenv("MXFP4_SK32_SAFE_LDS", 0)

def get_launch_config(M:int, N:int, K:int) -> tuple[int, tuple[int, int]]:
  assert M == 16384 and N in (14336, 28672) and K == 4096
  if PROFILE: return 256, (8, 1)
  return 256, (32, 8)

def mfma32(dst, a, b, scale_a, scale_b):
  return v_mfma_scale_f32_32x32x64_f8f6f4(dst, a, b, dst, 0, 0, 0, 0, 4, 1, 1, 0, 4, 0xD3AC,
                                           scale_a.offset, scale_b.offset)

def build_kernel(M:int, N:int, K:int):
  get_launch_config(M, N, K)
  k, e = Kernel(), None
  e = k.emit

  # C/A/B/scale-A/scale-B descriptors.
  e(s_and_b32(s[1], s[1], LIT, 65535))
  for desc, offset, size in ((4, 0, M*N*2), (8, 8, M*K//2), (12, 16, N*K//2),
                             (16, 24, M*K//32), (20, 32, N*K//32)):
    e(s_load_dwordx2(s[desc:desc+1], s[0:1], s[0], offset=offset, imm=1))
    e(s_mov_b32(s[desc+2], LIT, size))
    e(s_mov_b32(s[desc+3], LIT, 131072))

  # Lane, wave, and output tile coordinates. v104=lane%32, v105=lane/32.
  e(v_lshrrev_b32_e32(v[3], 6, v[0]))
  e(s_nop(3))
  e(v_readfirstlane_b32_e32(v[28], v[3]))
  e(v_and_b32_e32(v[0], 63, v[0]))
  e(v_and_b32_e32(v[104], 31, v[0]))
  e(v_lshrrev_b32_e32(v[105], 5, v[0]))
  e(s_lshl_b32(s[30], s[3], 5))
  e(s_add_u32(s[30], s[30], s[2]))     # persistent group id
  e(s_and_b32(s[31], s[30], 7))
  e(s_lshl_b32(s[31], s[31], 7))       # tile N, eight interleaved streams
  e(s_lshr_b32(s[30], s[30], 3))
  e(s_lshl_b32(s[30], s[30], 9))       # tile M
  e(s_mov_b32(s[36], LIT, N*2))
  e(v_lshlrev_b32_e32(v[110], 4, v[0]))  # lane * 16
  e(v_lshlrev_b32_e32(v[111], 2, v[0]))  # lane * 4
  # A0/A1 payload, B0/B1 payload, A scales, B scales.
  e(v_add_u32_e32(v[112], LIT, v[110], 65536))
  e(v_add_u32_e32(v[113], LIT, v[111], 81920))
  e(v_add_u32_e32(v[114], LIT, v[111], 90112))
  e(v_add_u32_e32(v[117], LIT, v[110], 73728))
  e(s_waitcnt(0))
  for desc in (4, 8, 12, 16, 20):
    e(s_and_b32(s[desc+1], s[desc+1], LIT, 65535))
    e(s_or_b32(s[desc+1], s[desc+1], LIT, 262144))

  def a_row(m:int):
    e(s_lshl_b32(s[33], s[28], 7))
    e(s_add_u32(s[33], s[33], s[30]))
    if m: e(s_add_u32(s[33], s[33], m*32))
    e(v_add_u32_e32(v[106], s[33], v[104]))

  def b_row():
    e(s_lshl_b32(s[33], s[28], 5))
    e(s_add_u32(s[33], s[33], s[31]))
    e(v_add_u32_e32(v[106], s[33], v[104]))

  def payload_addr_a(phase:int, slab:int, m:int):
    a_row(m)
    e(v_lshlrev_b32_e32(v[107], 11, v[106]))
    e(v_lshlrev_b32_e32(v[108], 4, v[105]))
    e(v_add_u32_e32(v[107], v[107], v[108]))
    e(v_add_u32_e32(v[107], LIT, v[107], phase*64+slab*32))

  def payload_addr_b(phase:int, slab:int):
    b_row()
    e(v_lshrrev_b32_e32(v[107], 4, v[106]))
    e(v_lshlrev_b32_e32(v[107], 15, v[107]))
    e(v_and_b32_e32(v[108], 15, v[106]))
    e(v_lshlrev_b32_e32(v[108], 4, v[108]))
    e(v_add_u32_e32(v[107], v[107], v[108]))
    e(v_lshlrev_b32_e32(v[108], 8, v[105]))
    e(v_add_u32_e32(v[107], v[107], v[108]))
    e(v_add_u32_e32(v[107], LIT, v[107], phase*1024+slab*512))

  def scale_addr(phase:int, slab:int, is_b:bool, m:int=0):
    b_row() if is_b else a_row(m)
    # Quantizer store_scale(row, phase*16 + slab*2 + lane/32, K/32).
    e(v_lshrrev_b32_e32(v[107], 5, v[106]))
    e(v_lshlrev_b32_e32(v[107], 12, v[107]))
    scale_phase_off = (phase//2)*256 + (phase&1)*2
    if scale_phase_off: e(v_add_u32_e32(v[107], LIT, v[107], scale_phase_off))
    e(v_and_b32_e32(v[108], 15, v[106]))
    e(v_lshlrev_b32_e32(v[108], 2, v[108]))
    e(v_add_u32_e32(v[107], v[107], v[108]))
    e(v_lshrrev_b32_e32(v[108], 4, v[106]))
    e(v_and_b32_e32(v[108], 1, v[108]))
    e(v_add_u32_e32(v[107], v[107], v[108]))
    # Low two col bits and bit 2 of the scale-column index.
    col0, col1 = (slab*2)&3, ((slab*2)>>2)&1
    if col0 or col1:
      e(v_add_u32_e32(v[107], LIT, v[107], col0*64+col1*2))
    e(v_lshlrev_b32_e32(v[108], 6, v[105]))
    e(v_add_u32_e32(v[107], v[107], v[108]))

  def load_half(phase:int, first_slab:int):
    records = []
    idx = 0
    for slab in range(first_slab, first_slab+4):
      for m in range(2):
        payload_addr_a(phase, slab, m)
        e(buffer_load_dwordx4(v[40+idx*4:43+idx*4], v[107], s[8:11], soffset=0, offen=1))
        scale_addr(phase, slab, False, m)
        e(buffer_load_ubyte(v[88+idx], v[107], s[16:19], soffset=0, offen=1))
        records.append((False, slab, m, 40+idx*4, 88+idx))
        idx += 1
      payload_addr_b(phase, slab)
      e(buffer_load_dwordx4(v[40+idx*4:43+idx*4], v[107], s[12:15], soffset=0, offen=1))
      scale_addr(phase, slab, True)
      e(buffer_load_ubyte(v[88+idx], v[107], s[20:23], soffset=0, offen=1))
      records.append((True, slab, 0, 40+idx*4, 88+idx))
      idx += 1
    e(s_waitcnt(0))
    e(s_lshl_b32(s[34], s[28], 12))
    e(s_lshl_b32(s[35], s[28], 10))
    e(s_lshl_b32(s[37], s[28], 10))
    e(s_lshl_b32(s[38], s[28], 8))
    for is_b, slab, m, preg, sreg in records:
      if is_b:
        off, soff = (slab*4)*1024, (slab*4)*256
        e(v_add_u32_e32(v[109], s[37], v[112]))
        e(ds_write_b128(addr=v[109], data0=v[preg:preg+3], offset0=off&255, offset1=off>>8))
        e(v_add_u32_e32(v[109], s[38], v[114]))
        e(ds_write_b32(addr=v[109], data0=v[sreg], offset0=soff&255, offset1=soff>>8))
      else:
        off, soff = (slab*16+m)*1024, (slab*16+m)*256
        e(v_add_u32_e32(v[109], s[34], v[110]))
        e(ds_write_b128(addr=v[109], data0=v[preg:preg+3], offset0=off&255, offset1=off>>8))
        e(v_add_u32_e32(v[109], s[35], v[113]))
        e(ds_write_b32(addr=v[109], data0=v[sreg], offset0=soff&255, offset1=soff>>8))

  def wait_lgkm(count:int): e(s_waitcnt(0xC07F | (count << 8)))

  def wait_vmem(count:int): e(s_waitcnt((count & 15) | ((count >> 4) << 14) | (7 << 4) | (15 << 8)))

  def prefetch_slab(phase:int, slab:int):
    for m, (preg, sreg) in enumerate(((40, 52), (44, 53))):
      payload_addr_a(phase, slab, m)
      e(buffer_load_dwordx4(v[preg:preg+3], v[107], s[8:11], soffset=0, offen=1))
      scale_addr(phase, slab, False, m)
      e(buffer_load_ubyte(v[sreg], v[107], s[16:19], soffset=0, offen=1))
    payload_addr_b(phase, slab)
    e(buffer_load_dwordx4(v[48:51], v[107], s[12:15], soffset=0, offen=1))
    scale_addr(phase, slab, True)
    e(buffer_load_ubyte(v[54], v[107], s[20:23], soffset=0, offen=1))

  def commit_prefetch(phase:int, slab:int):
    e(s_lshl_b32(s[34], s[28], 12))
    e(s_lshl_b32(s[35], s[28], 10))
    e(s_lshl_b32(s[37], s[28], 10))
    e(s_lshl_b32(s[38], s[28], 8))
    for m, (preg, sreg) in enumerate(((40, 52), (44, 53))):
      e(v_add_u32_e32(v[109], s[34], v[110]))
      off = (slab*16+m)*1024
      e(ds_write_b128(addr=v[109], data0=v[preg:preg+3], offset0=off&255, offset1=off>>8))
      e(v_add_u32_e32(v[109], s[35], v[113]))
      soff = (slab*16+m)*256
      e(ds_write_b32(addr=v[109], data0=v[sreg], offset0=soff&255, offset1=soff>>8))
    bbase, bsbase = (v[117], v[118]) if B_DOUBLE and phase & 1 else (v[112], v[114])
    e(v_add_u32_e32(v[109], s[37], bbase))
    off = (slab*4)*1024
    e(ds_write_b128(addr=v[109], data0=v[48:51], offset0=off&255, offset1=off>>8))
    e(v_add_u32_e32(v[109], s[38], bsbase))
    soff = (slab*4)*256
    e(ds_write_b32(addr=v[109], data0=v[54], offset0=soff&255, offset1=soff>>8))

  def issue_half(phase:int, first_slab:int):
    # Payloads bypass VGPRs. M0 is the per-wave LDS base; dwordx4 adds lane*16.
    e(s_lshl_b32(s[34], s[28], 12))
    e(s_lshl_b32(s[37], s[28], 10))
    a_bank, b_bank = (32768, 73728) if phase & 1 else (0, 65536)
    def direct_load(addr, desc):
      e(buffer_load_dwordx4(v[0:3], addr, desc, soffset=0, offen=1, lds=1))
    idx = 0
    for slab in range(first_slab, first_slab+SLABS):
      for m in range(4):
        e(s_add_u32(NULL, s[34], LIT, a_bank+(slab*16+m)*1024))
        direct_load(v[144+idx], s[8:11])
        e(buffer_load_ubyte(v[124+idx], v[164+idx], s[16:19], soffset=0, offen=1))
        e(v_add_u32_e32(v[144+idx], LIT, v[144+idx], 64))
        e(v_add_u32_e32(v[164+idx], LIT, v[164+idx], 2 if phase % 2 == 0 else 254))
        idx += 1
      e(s_add_u32(NULL, s[37], LIT, b_bank+(slab*4)*1024))
      direct_load(v[144+idx], s[12:15])
      e(buffer_load_ubyte(v[124+idx], v[164+idx], s[20:23], soffset=0, offen=1))
      e(v_add_u32_e32(v[144+idx], LIT, v[144+idx], 1024))
      e(v_add_u32_e32(v[164+idx], LIT, v[164+idx], 2 if phase % 2 == 0 else 254))
      idx += 1

  def prepare_addresses():
    idx = 0
    for slab in range(SLABS):
      for m in range(4):
        payload_addr_a(0, slab, m)
        e(v_mov_b32_e32(v[144+idx], v[107]))
        scale_addr(0, slab, False, m)
        e(v_mov_b32_e32(v[164+idx], v[107]))
        idx += 1
      payload_addr_b(0, slab)
      e(v_mov_b32_e32(v[144+idx], v[107]))
      scale_addr(0, slab, True)
      e(v_mov_b32_e32(v[164+idx], v[107]))
      idx += 1

  def commit_half(phase:int, first_slab:int):
    e(s_lshl_b32(s[34], s[28], 12))
    e(s_lshl_b32(s[35], s[28], 10))
    e(s_lshl_b32(s[38], s[28], 8))
    bsbase = v[114]
    idx = 0
    for slab in range(first_slab, first_slab+SLABS):
      for m in range(4):
        e(v_add_u32_e32(v[250], s[35], v[113]))
        soff = (slab*16+m)*256
        e(ds_write_b32(addr=v[250], data0=v[124+idx], offset0=soff&255, offset1=soff>>8))
        idx += 1
      e(v_add_u32_e32(v[250], s[38], bsbase))
      soff = (slab*4)*256
      e(ds_write_b32(addr=v[250], data0=v[124+idx], offset0=soff&255, offset1=soff>>8))
      idx += 1

  def compute_phase(phase:int, next_phase:int|None):
    e(s_lshl_b32(s[34], s[28], 12))
    e(s_lshl_b32(s[35], s[28], 10))
    if phase & 1: e(v_add_u32_e32(v[115], LIT, v[110], 32768))
    else: e(v_mov_b32_e32(v[115], v[110]))
    e(v_add_u32_e32(v[115], s[34], v[115]))
    e(v_add_u32_e32(v[116], s[35], v[113]))
    abase_ptr = v[115]
    bbase, bsbase = (v[117] if phase & 1 else v[112]), v[114]
    for first_slab in (0,):
      if next_phase is not None: issue_half(next_phase, first_slab)
      last_slab = first_slab+SLABS-1

      def read_a_slab(slab:int, bank:int):
        abase, ascale = ((0, 48) if bank == 0 else (16, 52))
        for m in range(4):
          off, soff = (slab*16+m)*1024, (slab*16+m)*256
          e(ds_read_b128(v[abase+m*4:abase+m*4+3], abase_ptr, offset0=off&255, offset1=off>>8))
          e(ds_read_b32(v[ascale+m], v[116], offset0=soff&255, offset1=soff>>8))

      def read_b_frag(slab:int, n:int):
        off, soff = (slab*4+n)*1024, (slab*4+n)*256
        e(ds_read_b128(v[32+n*4:32+n*4+3], bbase, offset0=off&255, offset1=off>>8))
        e(ds_read_b32(v[56+n], bsbase, offset0=soff&255, offset1=soff>>8))

      read_a_slab(first_slab, first_slab & 1)
      for n in range(4): read_b_frag(first_slab, n)
      wait_lgkm(0)
      for slab in range(first_slab, first_slab+SLABS):
        bank = slab & 1
        abase, ascale = ((0, 48) if bank == 0 else (16, 52))
        if slab < last_slab: read_a_slab(slab+1, bank^1)
        for n in range(4):
          if slab == last_slab and slab > first_slab and n: wait_lgkm(6-2*n)
          elif first_slab < slab < last_slab and n: wait_lgkm(10)
          if SAFE_LDS: wait_lgkm(0)
          for m in range(4):
            acc = (m*4+n)*16
            e(mfma32(v[acc:acc+15], v[abase+m*4:abase+m*4+3], v[32+n*4:32+n*4+3], v[ascale+m], v[56+n]))
          if slab < last_slab: read_b_frag(slab+1, n)
        if slab < last_slab: wait_lgkm(6)
      if next_phase is not None:
        wait_vmem(0)
        commit_half(next_phase, first_slab)

  k.label("tile_loop")
  for r in range(256): e(v_accvgpr_write(v[r], 0))
  prepare_addresses()
  issue_half(0, 0)
  e(s_waitcnt(0))
  commit_half(0, 0)
  wait_lgkm(0)
  e(s_barrier())
  for phase in range(PHASES):
    compute_phase(phase, phase+1 if phase < PHASES-1 else None)
    wait_lgkm(0)
    e(s_barrier())

  # Convert the 256x128 tile to BF16. Each wave owns 64 rows.
  for m in range(4):
    for n in range(4):
      acc = (m*4+n)*16
      for q in range(0, 16, 4):
        for j in range(4): e(v_accvgpr_read(v[40+j], v[acc+q+j]))
        e(s_nop(1))
        e(v_cvt_pk_bf16_f32(v[44], v[40], v[41]))
        e(v_cvt_pk_bf16_f32(v[45], v[42], v[43]))
        for j in range(4):
          row_group, row_in = divmod(q+j, 4)
          e(v_lshlrev_b32_e32(v[46], 2, v[105]))
          e(v_add_u32_e32(v[46], LIT, v[46], row_group*8+row_in))
          e(s_lshl_b32(s[33], s[28], 7))
          e(s_add_u32(s[33], s[33], s[30]))
          if m: e(s_add_u32(s[33], s[33], m*32))
          e(v_add_u32_e32(v[46], s[33], v[46]))
          e(v_mul_lo_u32(v[46], s[36], v[46]))
          e(v_add_u32_e32(v[47], s[31], v[104]))
          if n: e(v_add_u32_e32(v[47], LIT, v[47], n*32))
          e(v_lshlrev_b32_e32(v[47], 1, v[47]))
          e(v_add_u32_e32(v[46], v[46], v[47]))
          src = v[44+j//2]
          if j & 1:
            e(v_lshrrev_b32_e32(v[48], 16, src))
            src = v[48]
          e(buffer_store_short(src, v[46], s[4:7], soffset=0, offen=1))
        for j in range(4): e(v_accvgpr_write(v[acc+q+j], 0))
  e(s_waitcnt(0))
  if not PROFILE:
    e(s_barrier())
    e(s_add_u32(s[31], s[31], LIT, 1024))
    e(s_cmp_lt_u32(s[31], LIT, N))
    e(s_cbranch_scc1(), target="tile_loop")
  e(s_endpgm())
  return k.finalize()
