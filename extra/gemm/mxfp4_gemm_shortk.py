# ruff: noqa: E501,F403,F405
from tinygrad.runtime.autogen.amd.cdna.ins import *

# Two symmetric four-wave groups. Each owns a 128x256 tile, 128 AGPRs/wave,
# and a private 32 KiB LDS region. Neither group reads the other's accumulators.
LDS_BYTES = 65536

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
  assert (M, N, K) == (16384, 4096, 4096)
  return 512, (16, 8)

def build_kernel(M:int, N:int, K:int):
  get_launch_config(M, N, K)
  k = Kernel()
  e = k.emit
  # s4/8/12/16/20: C/A/B/scaleA/scaleB buffer descriptors.
  # s28 local wave, s29 group, s30 phase, s32 current tile row, s34 tile column,
  # s35 next tile row, s36 group row limit, s40 previous output valid.
  # v0 lane, v1 lane%16, v2 lane//16; v8:13 LDS addresses; v20 C address.
  # v32:55 pending FP4 loads, v56:61 pending scales; v64:78 compute operands.
  e(s_and_b32(s[1], s[1], LIT, 65535))
  for desc, offset, size in ((4, 0, M*N*2), (8, 8, M*K//2), (12, 16, N*K//2), (16, 24, M*K//32), (20, 32, N*K//32)):
    e(s_load_dwordx2(s[desc:desc+1], s[0:1], s[0], offset=offset, imm=1))
    e(s_mov_b32(s[desc+2], LIT, size))
    e(s_mov_b32(s[desc+3], LIT, 131072))
  e(v_lshrrev_b32_e32(v[3], 6, v[0]))
  e(s_nop(3))
  e(v_readfirstlane_b32_e32(v[28], v[3]))
  e(s_nop(3))
  e(s_lshr_b32(s[29], s[28], 2))
  e(s_and_b32(s[28], s[28], 3))
  e(v_and_b32_e32(v[0], 63, v[0]))
  e(v_and_b32_e32(v[1], 15, v[0]))
  e(v_lshrrev_b32_e32(v[2], 4, v[0]))
  e(s_lshl_b32(s[32], s[3], 11))
  e(s_add_u32(s[36], s[32], LIT, 2048))
  e(s_lshl_b32(s[24], s[29], 7))
  e(s_add_u32(s[32], s[32], s[24]))
  e(s_lshl_b32(s[34], s[2], 8))
  e(s_lshl_b32(s[27], s[29], 15))
  # LDS addresses: A/B payloads occupy 0:24576; scales occupy 24576:30720.
  for reg, rows_per_wave, stride, base in ((8,32,64,0), (9,64,64,8192), (10,32,16,24576), (11,64,16,26624)):
    e(s_mul_i32(s[24], s[28], LIT, rows_per_wave*stride))
    e(s_add_u32(s[24], s[24], s[27]))
    e(v_mul_lo_u32(v[reg], v[1], stride))
    e(v_add_u32_e32(v[reg], s[24], v[reg]))
    e(v_mul_lo_u32(v[3], v[2], stride//4))
    e(v_add_u32_e32(v[reg], v[3], v[reg]))
    e(v_add_u32_e32(v[reg], LIT, v[reg], base))
  # B read addresses omit the loading wave's row contribution: all four waves reuse B.
  e(s_mul_i32(s[24], s[28], LIT, 4096))
  e(v_subrev_u32_e32(v[12], s[24], v[9]))
  e(s_mul_i32(s[24], s[28], LIT, 1024))
  e(v_subrev_u32_e32(v[13], s[24], v[11]))
  e(s_waitcnt(0))
  for desc in (4, 8, 12, 16, 20):
    e(s_and_b32(s[desc+1], s[desc+1], LIT, 65535))
    e(s_or_b32(s[desc+1], s[desc+1], LIT, 262144))

  def load_chunk(row, chunk):
    # A is row-major FP4, B is shuffled in 16-row x 64-element blocks.
    for operand, blocks, desc, scale_desc in ((0,2,8,16), (1,4,12,20)):
      e(s_mul_i32(s[24], s[28], 32 if operand == 0 else 64))
      e(s_add_u32(s[24], s[24], row if operand == 0 else s[34]))
      for i in range(blocks):
        e(s_add_u32(s[25], s[24], i*16))
        if operand == 0:
          e(v_add_u32_e32(v[3], s[25], v[1]))
          e(v_lshlrev_b32_e32(v[4], 11, v[3]))
          e(v_lshlrev_b32_e32(v[5], 4, v[2]))
          offset = chunk*64
        else:
          e(s_lshl_b32(s[26], s[25], 11))
          e(v_lshlrev_b32_e32(v[4], 4, v[1]))
          e(v_add_u32_e32(v[4], s[26], v[4]))
          e(v_lshlrev_b32_e32(v[5], 8, v[2]))
          offset = chunk*1024
        e(v_add_u32_e32(v[4], v[4], v[5]))
        e(v_add_u32_e32(v[4], LIT, v[4], offset))
        dst = 32+i*4 if operand == 0 else 40+i*4
        e(buffer_load_dwordx4(v[dst:dst+3], v[4], s[desc:desc+3], soffset=0, offen=1))
        # E8M0 layout: row32 x eight K scales, with four scale bytes interleaved by row.
        e(s_lshr_b32(s[26], s[25], 5))
        e(s_lshl_b32(s[26], s[26], 12))
        e(s_add_u32(s[26], s[26], LIT, (chunk//2)*256+(chunk%2)*2))
        e(s_lshr_b32(s[25], s[25], 4))
        e(s_and_b32(s[25], s[25], 1))
        e(s_add_u32(s[26], s[26], s[25]))
        e(v_lshlrev_b32_e32(v[4], 2, v[1]))
        e(v_lshlrev_b32_e32(v[5], 6, v[2]))
        e(v_add_u32_e32(v[4], v[4], v[5]))
        e(v_add_u32_e32(v[4], s[26], v[4]))
        e(buffer_load_ubyte(v[56+i if operand == 0 else 58+i], v[4], s[scale_desc:scale_desc+3], soffset=0, offen=1))

  def ds(inst, dst, addr, offset):
    if inst in (ds_write_b128, ds_write_b32): e(inst(addr=dst, data0=addr, offset0=offset&255, offset1=offset>>8))
    else: e(inst(dst, addr, offset0=offset&255, offset1=offset>>8))

  def commit_chunk():
    e(s_waitcnt(0))
    for i in range(2):
      ds(ds_write_b128, v[8], v[32+i*4:35+i*4], i*1024)
      ds(ds_write_b32, v[10], v[56+i], i*256)
    for i in range(4):
      ds(ds_write_b128, v[9], v[40+i*4:43+i*4], i*1024)
      ds(ds_write_b32, v[11], v[58+i], i*256)

  def compute_chunk():
    for i in range(2):
      ds(ds_read_b128, v[64+i*4:67+i*4], v[8], i*1024)
      ds(ds_read_b32, v[76+i], v[10], i*256)
    for n in range(16):
      ds(ds_read_b128, v[72:75], v[12], n*1024)
      ds(ds_read_b32, v[78], v[13], n*256)
      # Wait for LDS operands without draining the next-chunk global prefetch.
      e(s_waitcnt(49279))
      for m in range(2):
        acc = (m*16+n)*4
        e(v_mfma_scale_f32_16x16x128_f8f6f4(v[acc:acc+3], v[64+m*4:67+m*4], v[72:75], v[acc:acc+3],
                                          0, 0, 0, 0, 4, 1, 1, 0, 4, 0xD3AC, 256+76+m, 256+78))

  def output_address():
    e(s_mul_i32(s[24], s[28], 32))
    e(s_add_u32(s[24], s[24], s[32]))
    e(v_lshlrev_b32_e32(v[20], 2, v[2]))
    e(v_add_u32_e32(v[20], s[24], v[20]))
    e(v_lshlrev_b32_e32(v[20], 13, v[20]))
    e(v_add_u32_e32(v[3], s[34], v[1]))
    e(v_lshlrev_b32_e32(v[3], 1, v[3]))
    e(v_add_u32_e32(v[20], v[20], v[3]))

  def drain_stripe(stripe):
    m, n = divmod(stripe, 16)
    for j in range(4): e(v_accvgpr_read(v[64+j], v[stripe*4+j]))
    e(s_nop(1))
    e(v_cvt_pk_bf16_f32(v[68], v[64], v[65]))
    e(v_cvt_pk_bf16_f32(v[69], v[66], v[67]))
    for j in range(4):
      e(v_add_u32_e32(v[3], LIT, v[20], (m*16+j)*N*2+n*32))
      if j&1: e(v_lshrrev_b32_e32(v[70], 16, v[68+j//2]))
      e(buffer_store_short(v[70] if j&1 else v[68+j//2], v[3], s[4:7], soffset=0, offen=1))
      e(v_accvgpr_write(v[stripe*4+j], 0))

  for i in range(128): e(v_accvgpr_write(v[i], 0))
  load_chunk(s[32], 0)
  commit_chunk()
  e(s_waitcnt(0))
  e(s_barrier())
  e(s_mov_b32(s[30], 0))
  e(s_mov_b32(s[40], 0))
  k.label('phase')
  output_address()
  e(s_add_u32(s[35], s[32], LIT, 256))
  for chunk in range(32):
    # Uniform per-wave control flow, with identical WG barrier order for both groups.
    e(s_and_b32(s[24], s[30], 1))
    e(s_cmp_eq_u32(s[24], s[29]))
    e(s_cbranch_scc0(), target=f'service_{chunk}')
    if chunk < 31: load_chunk(s[32], chunk+1)
    compute_chunk()
    e(s_branch(), target=f'join_{chunk}')
    k.label(f'service_{chunk}')
    e(s_cmp_eq_u32(s[40], 0))
    e(s_cbranch_scc1(), target=f'join_{chunk}')
    drain_stripe(chunk)
    if chunk == 0:
      e(s_cmp_ge_u32(s[35], s[36]))
      e(s_cbranch_scc1(), target=f'join_{chunk}')
      load_chunk(s[35], 0)
    k.label(f'join_{chunk}')
    e(s_waitcnt(0))
    e(s_barrier())
    e(s_and_b32(s[24], s[30], 1))
    e(s_cmp_eq_u32(s[24], s[29]))
    if chunk < 31:
      e(s_cbranch_scc1(), target=f'commit_{chunk}')
    else: e(s_cbranch_scc1(), target=f'ready_{chunk}')
    if chunk == 0:
      e(s_cmp_eq_u32(s[40], 0))
      e(s_cbranch_scc1(), target=f'ready_{chunk}')
      e(s_cmp_ge_u32(s[35], s[36]))
      e(s_cbranch_scc1(), target=f'ready_{chunk}')
    else: e(s_branch(), target=f'ready_{chunk}')
    k.label(f'commit_{chunk}')
    commit_chunk()
    k.label(f'ready_{chunk}')
    e(s_waitcnt(0))
    e(s_barrier())
  e(s_and_b32(s[24], s[30], 1))
  e(s_cmp_eq_u32(s[24], s[29]))
  e(s_cbranch_scc0(), target='service_done')
  e(s_mov_b32(s[40], 1))
  e(s_branch(), target='phase_done')
  k.label('service_done')
  e(s_cmp_eq_u32(s[40], 0))
  e(s_cbranch_scc1(), target='phase_done')
  e(s_mov_b32(s[32], s[35]))
  e(s_mov_b32(s[40], 0))
  k.label('phase_done')
  e(s_add_u32(s[30], s[30], 1))
  e(s_cmp_lt_u32(s[30], 16))
  e(s_cbranch_scc1(), target='phase')
  # Only the final active group still owns output. No WG barriers after this point.
  e(s_cmp_eq_u32(s[40], 0))
  e(s_cbranch_scc1(), target='done')
  for stripe in range(32): drain_stripe(stripe)
  k.label('done')
  e(s_waitcnt(0))
  e(s_endpgm())
  return k.finalize()
