"""High-residency 4-wave MXFP4 kernel for short-K gfx950 GEMMs.

This is a strict slice of the GPU-proven v16 128x256 kernel:
  * 256 threads / 4 wave64s per WG
  * 64x256 WG tile, 64x64 per wave
  * same 16x16x128 scaled-FP4 operand/scale mapping

Only the first four M16 blocks are retained, so each wave needs 64 AccVGPRs.
A K128 tile is 4 KiB and is ping-ponged through LDS. B uses two 16-VGPR
banks and scales use two 4-VGPR banks, allowing the next half/pair to prefetch
under current MFMA work without source-bank overwrite.

The register namespace is v0..v61: 62 regular + 64 Acc. The gfx950 ELF
allocation rounds the combined footprint to <=128, targeting four waves/SIMD
(16 waves/CU) with four resident 4-wave WGs.
"""
# ruff: noqa: F403,F405,E501
from tinygrad.runtime.autogen.amd.cdna.ins import *
from extra.gemm.gemm_mxfp4 import Kernel, v_mfma_fp4
from extra.gemm.cdna_lib.phase2_lds import _ds_read_b128

def _waitcnt_imm(vm:int=63,lgkm:int=15,exp:int=7)->int:
  assert 0<=vm<=63 and 0<=lgkm<=15 and 0<=exp<=7
  return (vm&0xf)|(exp<<4)|(lgkm<<8)|(((vm>>4)&0x3)<<14)

def _wait(k:Kernel,*,vm:int=63,lgkm:int=15)->None:
  k.emit(s_waitcnt(_waitcnt_imm(vm=vm,lgkm=lgkm)))

TILE_M,TILE_N,THREADS=64,256,256
A_STAGE_BYTES=4*1024
A0_LDS=0
A1_LDS=A_STAGE_BYTES
USED_LDS_BYTES=2*A_STAGE_BYTES
LDS_BYTES=7*1280  # 8960 B, comfortably permits four WGs/CU.


def _a_d2l(k:Kernel, odd:bool, stage:int)->None:
  # v56 = (lane>>2)*half_k + (lane&3)*16, precomputed. Each wave supplies
  # exactly one M16 block / 1024 B of the 64xK128 A tile.
  k.emit(s_add_u32(s[52],s[57],s[61]))
  if odd: k.emit(s_add_u32(s[52],LIT,s[52],64))
  off=(A1_LDS if stage else A0_LDS)
  if off: k.emit(s_add_u32(NULL,LIT,s[64],off))
  else: k.emit(s_add_u32(NULL,0,s[64]))
  k.emit(s_nop())  # CDNA4 SALU->M0 LDS-DMA dependency.
  k.emit(buffer_load_dwordx4(v[0:3],v[56],s[12:15],s[52],0,1,0,0,0,0,1))


def _a_reads(k:Kernel, stage:int, *, hazard:bool)->None:
  # v58 = (lane&15)*64 + (lane>>4)*16 + stage base.
  k.emit(v_lshrrev_b32_e32(v[58],4,v[59]))
  k.emit(v_and_b32_e32(v[60],LIT,v[58],15)); k.emit(v_lshlrev_b32_e32(v[60],6,v[60]))
  k.emit(v_lshrrev_b32_e32(v[61],4,v[58])); k.emit(v_lshlrev_b32_e32(v[61],4,v[61]))
  k.emit(v_add_u32_e32(v[58],v[61],v[60]))
  if stage: k.emit(v_add_u32_e32(v[58],LIT,v[58],A1_LDS))
  for mb in range(4):
    _ds_read_b128(k,v[mb*4:mb*4+3],v[58],mb*1024)
    # The same A bank was an MFMA SrcA in the previous half. At half end,
    # mb0/1/2/3 already have 12/8/4/0 independent MFMAs behind their last
    # use. Four explicit wait states between refills make every overwrite >=12.
    if hazard and mb != 3: k.emit(s_nop(3))


def _b_loads(k:Kernel,half_k:int,odd:bool,base:int)->None:
  assert base in (16,32)
  k.emit(s_add_u32(s[52],s[58],s[62]))
  if odd: k.emit(s_add_u32(s[52],LIT,s[52],1024))
  for nb in range(4):
    if nb: k.emit(s_add_u32(s[53],LIT,s[52],nb*16*half_k))
    else: k.emit(s_mov_b32(s[53],s[52]))
    k.emit(buffer_load_dwordx4(v[base+nb*4:base+nb*4+3],v[59],s[16:19],s[53],0,1))


def _scale_loads(k:Kernel,K:int,base:int)->None:
  assert base in (48,52)
  # Two A M32 packed rows for the 64-row tile, two B M32 packed rows for N64.
  k.emit(s_add_u32(s[52],s[59],s[63]))
  k.emit(buffer_load_dword(v[base],v[57],s[20:23],s[52],0,1))
  k.emit(s_add_u32(s[53],LIT,s[52],K)); k.emit(buffer_load_dword(v[base+1],v[57],s[20:23],s[53],0,1))
  k.emit(s_add_u32(s[52],s[60],s[63]))
  k.emit(buffer_load_dword(v[base+2],v[57],s[24:27],s[52],0,1))
  k.emit(s_add_u32(s[53],LIT,s[52],K)); k.emit(buffer_load_dword(v[base+3],v[57],s[24:27],s[53],0,1))


def _mfma_mb(k:Kernel,mb:int,half:int,bbase:int,sbase:int)->None:
  for nb in range(4):
    dst=nb*16+mb*4
    bsel,asel=(nb&1)+half*2,(mb&1)+half*2
    opsel=(bsel&1)|((asel&1)<<1); opsel_hi=((bsel>>1)&1)|(((asel>>1)&1)<<1)
    k.emit(v_mfma_fp4(v[dst:dst+3],v[bbase+nb*4:bbase+nb*4+3],v[mb*4:mb*4+3],
                       opsel,opsel_hi,v[sbase+2+nb//2],v[sbase+mb//2]))


def _mfma_one(k:Kernel,mb:int,nb:int,half:int,bbase:int,sbase:int)->None:
  dst=nb*16+mb*4
  bsel,asel=(nb&1)+half*2,(mb&1)+half*2
  opsel=(bsel&1)|((asel&1)<<1); opsel_hi=((bsel>>1)&1)|(((asel>>1)&1)<<1)
  k.emit(v_mfma_fp4(v[dst:dst+3],v[bbase+nb*4:bbase+nb*4+3],v[mb*4:mb*4+3],
                     opsel,opsel_hi,v[sbase+2+nb//2],v[sbase+mb//2]))


def _run_half(k:Kernel,half:int,bbase:int,sbase:int,*,next_odd:bool|None,next_stage:int|None,next_bbase:int|None,next_sbase:int|None,K:int,progressive:bool)->None:
  """Run one K128 region with a three-stage local/global prefetch.

  In progressive mode, VMEM ordering is used to begin mb0 as soon as B block 0
  returns instead of draining all four B loads. The next A D2L is appended after
  that first MFMA and overlaps the remaining B0..3 completion plus the rest of
  the half. This changes only scheduling, never operand bytes or MFMA controls.
  """
  if progressive:
    # Current scales, when newly loaded, are older than B. vmcnt(3) therefore
    # guarantees all required scales plus B0 while B1..3 can remain outstanding.
    _wait(k,vm=3,lgkm=3)
    _mfma_one(k,0,0,half,bbase,sbase)
    if next_odd is not None: _a_d2l(k,next_odd,next_stage)  # type: ignore[arg-type]
    extra = 1 if next_odd is not None else 0
    for nb in range(1,4):
      # If a next-A D2L was appended behind B1..3 it contributes one extra
      # outstanding VM op; the final half has no such tail.
      _wait(k,vm=3-nb+extra)
      _mfma_one(k,0,nb,half,bbase,sbase)
    if next_sbase is not None: _scale_loads(k,K,next_sbase)
    for mb in range(1,4):
      _wait(k,lgkm=3-mb)
      _mfma_mb(k,mb,half,bbase,sbase)
      if next_bbase is not None and mb==2: _b_loads(k,K//2,next_odd,next_bbase)  # type: ignore[arg-type]
  else:
    _wait(k,vm=0,lgkm=3)
    for mb in range(4):
      if mb: _wait(k,lgkm=3-mb)
      _mfma_mb(k,mb,half,bbase,sbase)
      if next_odd is not None and mb==0: _a_d2l(k,next_odd,next_stage)  # type: ignore[arg-type]
      if next_sbase is not None and mb==1: _scale_loads(k,K,next_sbase)
      if next_bbase is not None and mb==2: _b_loads(k,K//2,next_odd,next_bbase)  # type: ignore[arg-type]
  if next_odd is not None:
    tail=4+(4 if next_sbase is not None else 0)
    _wait(k,vm=tail)  # A D2L is oldest; keep B/scales in flight across barrier.
    k.emit(s_mov_b32(NULL,-1)); k.emit(s_barrier()); _a_reads(k,next_stage,hazard=True)  # type: ignore[arg-type]


def _epilogue(k:Kernel,M:int,N:int)->None:
  stride=N*2; out_bytes=M*N*2
  k.emit(s_mov_b32(s[6],LIT,out_bytes)); k.emit(s_mov_b32(s[54],LIT,stride))
  # Reuse dead B registers. v20 is C byte offset, v21/v22 temps.
  k.emit(v_lshrrev_b32_e32(v[21],4,v[59]))  # lane id
  k.emit(v_and_b32_e32(v[20],LIT,v[21],15)); k.emit(v_mul_lo_u32(v[20],v[20],s[54]))
  k.emit(v_lshrrev_b32_e32(v[22],5,v[21])); k.emit(v_mul_i32_i24_e32(v[22],16,v[22])); k.emit(v_add_u32_e32(v[20],v[22],v[20]))
  k.emit(v_lshrrev_b32_e32(v[22],4,v[21])); k.emit(v_and_b32_e32(v[22],1,v[22])); k.emit(v_mul_i32_i24_e32(v[22],32,v[22])); k.emit(v_add_u32_e32(v[20],v[22],v[20]))
  k.emit(s_mul_i32(s[52],s[47],LIT,64)); k.emit(s_mul_i32(s[52],s[52],s[54]))
  k.emit(s_mul_i32(s[53],s[46],LIT,256)); k.emit(s_mul_i32(s[55],s[30],64)); k.emit(s_add_u32(s[53],s[53],s[55])); k.emit(s_lshl_b32(s[53],s[53],1))
  k.emit(s_add_u32(s[52],s[52],s[53])); k.emit(v_add_u32_e32(v[20],s[52],v[20])); k.emit(s_mov_b32(s[55],LIT,16*stride-128))
  for mb in range(4):
    for npair in range(2):
      nb0=npair*2; base=nb0*16+mb*4
      for i in range(2):
        for j in range(4): k.emit(v_accvgpr_read(v[j+i*4],v[base+j+i*16]))
      for i in range(4): k.emit(v_cvt_pk_bf16_f32(v[8+i],v[i*2],v[i*2+1]))
      k.emit(s_nop(1)); k.emit(v_permlane16_swap_b32_e32(v[8],v[10]))
      k.emit(s_nop(1)); k.emit(v_permlane16_swap_b32_e32(v[9],v[11]))
      k.emit(s_nop(1)); k.emit(buffer_store_dwordx4(v[8:11],v[20],s[4:7],0,0,1)); k.emit(v_add_i32(v[20],v[20],64))
    if mb!=3: k.emit(v_add_u32_e32(v[20],s[55],v[20]))


def build_4w64_kernel(M:int,N:int,K:int,*,progressive:bool=False):
  if M%TILE_M or N%TILE_N or K%512: raise ValueError(f"phase2_4w64 requires M%64=N%256=0 and K%512=0, got {M}x{N}x{K}")
  hk,sk=K//2,K//32; k=Kernel()
  k.emit(s_and_b32(s[1],s[1],LIT,65535))
  for dst,off in ((4,0),(12,8),(16,16),(20,24),(24,32)): k.emit(s_load_dwordx2(s[dst:dst+1],s[0:1],s[0],off,0,0,0,1))
  k.emit(s_waitcnt())
  for hi in (5,13,17,21,25): k.emit(s_and_b32(s[hi],s[hi],LIT,65535)); k.emit(s_or_b32(s[hi],s[hi],LIT,262144))
  for cfg in (7,15,19,23,27): k.emit(s_mov_b32(s[cfg],LIT,131072))
  k.emit(s_mov_b32(s[6],LIT,M*N*2)); k.emit(s_mov_b32(s[14],LIT,M*hk)); k.emit(s_mov_b32(s[18],LIT,N*hk)); k.emit(s_mov_b32(s[22],LIT,M*sk)); k.emit(s_mov_b32(s[26],LIT,N*sk))

  # wave id s30, lane*16 v59. Same readfirstlane spacing that is GPU-proven in v16.
  k.emit(v_lshrrev_b32_e32(v[58],6,v[0])); k.emit(v_and_b32_e32(v[59],LIT,v[0],63)); k.emit(s_mov_b32(s[46],s[2])); k.emit(s_mov_b32(s[47],s[3]))
  k.emit(v_readfirstlane_b32_e32(v[30],v[58])); k.emit(s_nop(3)); k.emit(v_lshlrev_b32_e32(v[59],4,v[59]))
  # Force the intended regular namespace before entering AccVGPR init.
  k.emit(v_mov_b32_e32(v[59],v[59]))
  for i in range(64): k.emit(v_accvgpr_write(v[i],0))

  # Persistent lane address terms. v56=A packed address, v57=scale lane*4, v59=B lane*16.
  k.emit(v_lshrrev_b32_e32(v[56],6,v[59])); k.emit(v_mul_i32_i24_e32(v[56],LIT,v[56],hk))
  k.emit(v_and_b32_e32(v[58],LIT,v[59],48)); k.emit(v_add_u32_e32(v[56],v[58],v[56])); k.emit(v_lshrrev_b32_e32(v[57],2,v[59]))

  # A: each wave owns one M16 loader block. B: wave owns one N64 output block.
  k.emit(s_mul_i32(s[52],s[47],LIT,64)); k.emit(s_mul_i32(s[53],s[30],16)); k.emit(s_add_u32(s[52],s[52],s[53])); k.emit(s_mul_i32(s[57],LIT,s[52],hk)); k.emit(s_lshl_b32(s[64],s[30],10))
  k.emit(s_mul_i32(s[52],s[46],LIT,256)); k.emit(s_mul_i32(s[53],s[30],64)); k.emit(s_add_u32(s[52],s[52],s[53])); k.emit(s_mul_i32(s[58],LIT,s[52],hk))
  k.emit(s_mul_i32(s[52],s[47],2)); k.emit(s_mul_i32(s[59],LIT,s[52],K))
  k.emit(s_mul_i32(s[52],s[46],8)); k.emit(s_mul_i32(s[53],s[30],2)); k.emit(s_add_u32(s[52],s[52],s[53])); k.emit(s_mul_i32(s[60],LIT,s[52],K))
  k.emit(s_mov_b32(s[61],0)); k.emit(s_mov_b32(s[62],0)); k.emit(s_mov_b32(s[63],0)); k.emit(s_mov_b32(s[56],K//512))

  # Startup pair A (scale bank0, B bank0). A is first in VM order so its barrier can be partial-waited.
  _a_d2l(k,False,0); _scale_loads(k,K,48); _b_loads(k,hk,False,16)
  _wait(k,vm=8); k.emit(s_mov_b32(NULL,-1)); k.emit(s_barrier()); _a_reads(k,0,hazard=False)

  k.label('SUPER')
  # Pair A / even -> odd. Same scale bank, alternate B banks.
  _run_half(k,0,16,48,next_odd=True,next_stage=1,next_bbase=32,next_sbase=None,K=K,progressive=progressive)
  # Current odd operands already captured/queued. Advance to Pair B before odd prefetches its even half.
  k.emit(s_add_u32(s[61],LIT,s[61],128)); k.emit(s_add_u32(s[62],LIT,s[62],2048)); k.emit(s_add_u32(s[63],LIT,s[63],256))
  _run_half(k,1,32,48,next_odd=False,next_stage=0,next_bbase=16,next_sbase=52,K=K,progressive=progressive)

  # Pair B / even -> odd.
  _run_half(k,0,16,52,next_odd=True,next_stage=1,next_bbase=32,next_sbase=None,K=K,progressive=progressive)
  k.emit(s_cmp_eq_u32(s[56],1)); k.emit(s_cbranch_scc1(1),target='LAST_ODD')
  # Prepare next super-iteration Pair A before Pair B odd starts prefetching it.
  k.emit(s_add_u32(s[61],LIT,s[61],128)); k.emit(s_add_u32(s[62],LIT,s[62],2048)); k.emit(s_add_u32(s[63],LIT,s[63],256))
  _run_half(k,1,32,52,next_odd=False,next_stage=0,next_bbase=16,next_sbase=48,K=K,progressive=progressive)
  k.emit(s_sub_u32(s[56],s[56],1)); k.emit(s_branch(1),target='SUPER')

  k.label('LAST_ODD')
  _run_half(k,1,32,52,next_odd=None,next_stage=None,next_bbase=None,next_sbase=None,K=K,progressive=progressive)
  # The epilogue has >20 independent address/setup instructions before its first
  # AccVGPR read, so it itself supplies the final MFMA retirement distance.
  _epilogue(k,M,N); k.emit(s_waitcnt()); k.emit(s_endpgm())
  return k.finalize()
