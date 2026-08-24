#!/usr/bin/env python3
"""Static byte-for-byte proofs for phase2_lds.

The staged kernel is only allowed to change transport.  Every 16-byte MFMA data
operand and every selected scale byte must be the same physical byte used by the
GPU-proven v13 direct kernel.  These proofs cover production M/N and every K block.
"""
from extra.gemm.cdna_lib.mxfp4 import LLAMA_SHAPES
from extra.gemm.cdna_lib.phase2_lds import A_LDS, B_LDS, AS_LDS, BS_LDS, USED_LDS_BYTES, LDS_BYTES, build_lds_kernel
from extra.gemm.cdna_lib.resources import scan_resources


def prove_stage_to_operands(K: int) -> None:
  hk = K//2
  # A full-BK256 staging map: LDS byte -> relative physical A byte.
  a = {}
  b = {}
  sa = {}
  sb = {}
  for t in range(512):
    row, halfchunk = t>>1, t&1
    for x in range(64):
      la=A_LDS+t*64+x; ga=row*hk+halfchunk*64+x
      assert la not in a; a[la]=ga
    group, chunk = t>>5, t&31
    for x in range(64):
      lb=B_LDS+t*64+x; gb=group*16*hk+chunk*64+x
      assert lb not in b; b[lb]=gb
    group, lane=t>>6,t&63
    for x in range(4):
      la=AS_LDS+t*4+x; ga=group*K+lane*4+x
      lb=BS_LDS+t*4+x; gb=group*K+lane*4+x
      assert la not in sa and lb not in sb
      sa[la]=ga; sb[lb]=gb

  assert min(a)==A_LDS and max(a)==B_LDS-1
  assert min(b)==B_LDS and max(b)==AS_LDS-1
  assert min(sa)==AS_LDS and max(sa)==BS_LDS-1
  assert min(sb)==BS_LDS and max(sb)==USED_LDS_BYTES-1

  for wm in range(2):
    for wn in range(4):
      for lane in range(64):
        abase=wm*16384+(lane&15)*128+(lane>>4)*16
        bbase=B_LDS+wn*8192+lane*16
        asbase=AS_LDS+wm*1024+lane*4
        bsbase=BS_LDS+wn*512+lane*4
        for half in range(2):
          for mb in range(8):
            l=abase+mb*2048+half*64
            direct=(wm*128+mb*16+(lane&15))*hk+half*64+(lane>>4)*16
            for x in range(16): assert a[l+x] == direct+x, (K,wm,mb,half,lane,x,a[l+x],direct+x)
          for nb in range(4):
            l=bbase+nb*2048+half*1024
            direct=(wn*64+nb*16)*hk+half*1024+lane*16
            for x in range(16): assert b[l+x] == direct+x, (K,wn,nb,half,lane,x,b[l+x],direct+x)
          for mb in range(8):
            sel=(mb&1)+2*half; l=asbase+(mb//2)*256+sel
            direct=(wm*4+mb//2)*K+lane*4+sel
            assert sa[l] == direct, (K,wm,mb,half,lane,sa[l],direct)
          for nb in range(4):
            sel=(nb&1)+2*half; l=bsbase+(nb//2)*256+sel
            direct=(wn*2+nb//2)*K+lane*4+sel
            assert sb[l] == direct, (K,wn,nb,half,lane,sb[l],direct)


def prove_production_bounds(M: int, N: int, K: int) -> None:
  hk, sk = K//2, K//32
  nbk=K//256
  for mt in range(M//256):
    abase=mt*256*hk
    asbase=mt*8*K
    for bk in range(nbk):
      ak=bk*128; skoff=bk*256
      for t in range(512):
        off=abase+(t>>1)*hk+(t&1)*64+ak
        assert 0 <= off and off+63 < M*hk, (M,N,K,mt,bk,t,off,M*hk)
        soff=asbase+(t>>6)*K+(t&63)*4+skoff
        assert 0 <= soff and soff+3 < M*sk, (M,N,K,mt,bk,t,soff,M*sk)
  for nt in range(N//256):
    bbase=nt*256*hk
    bsbase=nt*8*K
    for bk in range(nbk):
      bkoff=bk*2048; skoff=bk*256
      for t in range(512):
        off=bbase+(t>>5)*16*hk+(t&31)*64+bkoff
        assert 0 <= off and off+63 < N*hk, (M,N,K,nt,bk,t,off,N*hk)
        soff=bsbase+(t>>6)*K+(t&63)*4+skoff
        assert 0 <= soff and soff+3 < N*sk, (M,N,K,nt,bk,t,soff,N*sk)

  # Prove the C stores are a disjoint exact partition of every 256x256 output tile.
  row_stride=N*2
  local=[]
  for wm in range(2):
    for wn in range(4):
      wavebase=wm*128*row_stride+wn*64*2
      for lane in range(64):
        laneoff=(lane&15)*row_stride+(lane>>5)*16+((lane>>4)&1)*32
        for mb in range(8):
          for nh in range(2): local.append(wavebase+laneoff+mb*16*row_stride+nh*64)
  assert len(local)==8192 and len(set(local))==8192
  covered=set()
  for st in local:
    assert st % 16 == 0
    for x in range(st,st+16):
      assert x not in covered; covered.add(x)
  # The tile spans 256 rows but only its 256 N columns, with row gaps when N>256.
  expected={r*row_stride+c for r in range(256) for c in range(512)}
  assert covered == expected, (M,N,K,len(covered),len(expected))
  for mt in range(M//256):
    for nt in range(N//256):
      base=mt*256*row_stride+nt*512
      assert base+max(local)+15 < M*N*2


def prove_isa() -> None:
  from tinygrad.renderer.amd.dsl import Reg
  insts=build_lds_kernel(16384,4096,4096)
  r=scan_resources(insts)
  assert r.regular_vgprs == 128 and r.accvgprs == 128 and r.allocated_combined_vgprs == 256, r
  assert USED_LDS_BYTES == 69632 and LDS_BYTES == 71680
  names=[getattr(x,'op_name','') for x in insts]
  assert names.count('S_BARRIER') == 2, names.count('S_BARRIER')
  assert names.count('DS_WRITE_B128') == 8 and names.count('DS_WRITE_B32') == 2
  assert names.count('DS_READ_B128') == 24 and names.count('DS_READ_B32') == 6
  mf=[x for x in insts if getattr(x,'op_name','')=='V_MFMA_SCALE_F32_16X16X128_F8F6F4']
  assert len(mf)==64
  for half in range(2):
    for nb in range(4):
      for mb in range(8):
        x=mf[half*32+nb*8+mb]
        assert x.vdst.offset-256 == nb*32+mb*4
        bsel,asel=(nb&1)+2*half,(mb&1)+2*half
        assert x.opsel == ((bsel&1)|((asel&1)<<1))
        assert x.opsel_hi == (((bsel>>1)&1)|(((asel>>1)&1)<<1))
  # No malformed VOP3 literal marker is permitted outside the special scale MFMA encoding.
  for inst in insts:
    if type(inst).__name__.startswith('VOP3') and type(inst).__name__ != 'VOP3PX2':
      for field in ('src0','src1','src2'):
        val=getattr(inst,field,None)
        assert not (isinstance(val,Reg) and val.offset==255), (inst,field,inst.to_bytes().hex())


def main() -> None:
  for K in sorted({x[2] for x in LLAMA_SHAPES}):
    prove_stage_to_operands(K)
    print(f'K={K}: transparent LDS bytes == v13 direct MFMA bytes')
  for sh in LLAMA_SHAPES:
    prove_production_bounds(*sh)
    print(f'{sh}: production A/B/scale/C bounds + C partition passed')
  prove_isa()
  print('phase2_lds ISA/resources passed: 128+128=256, 68KiB used LDS')
  print('phase2 LDS mapping proofs passed')

if __name__=='__main__': main()
