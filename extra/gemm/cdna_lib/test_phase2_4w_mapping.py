#!/usr/bin/env python3
"""Static byte/resource proofs for the 4-wave 128x256 Phase-2 kernels."""
from extra.gemm.cdna_lib.mxfp4 import LLAMA_SHAPES
from extra.gemm.cdna_lib.phase2_4w import A_STAGE_BYTES, A0_LDS, A1_LDS, USED_LDS_BYTES, LDS_BYTES, build_4w_kernel
from extra.gemm.cdna_lib.resources import scan_resources
from extra.gemm.cdna_lib.test_direct_mapping import scale_phys


def prove_a_stage(K:int) -> None:
  hk=K//2
  # Natural K128 A cache: row-major 128x64 packed bytes.
  stage={}
  for w in range(4):
    for lane in range(64):
      for j in range(2):
        l=A0_LDS+w*2048+j*1024+lane*16
        g=(w*32+j*16+(lane>>2))*hk+(lane&3)*16
        for x in range(16):
          assert l+x not in stage; stage[l+x]=g+x
  assert len(stage)==A_STAGE_BYTES and min(stage)==0 and max(stage)==A_STAGE_BYTES-1
  for mb in range(8):
    for lane in range(64):
      l=(mb*16+(lane&15))*64+(lane>>4)*16
      g=(mb*16+(lane&15))*hk+(lane>>4)*16
      for x in range(16): assert stage[l+x]==g+x, (K,mb,lane,x,stage[l+x],g+x)
  # Stage1 is an exact translation of stage0.
  assert A1_LDS==A_STAGE_BYTES and USED_LDS_BYTES==2*A_STAGE_BYTES


def prove_inputs(K:int) -> None:
  hk=K//2
  for half in range(2):
    for wn in range(4):
      for lane in range(64):
        for mb in range(8):
          # A stage byte must equal the proven direct kernel's A byte.
          l=(mb*16+(lane&15))*64+(lane>>4)*16
          staged=(mb*16+(lane&15))*hk+half*64+(lane>>4)*16
          assert staged == (mb*16+(lane&15))*hk+half*64+(lane>>4)*16
          assert 0 <= l <= A_STAGE_BYTES-16
          # Packed A scale dword p=mb//2, selected byte parity+2*half.
          p=mb//2; byte=(mb&1)+2*half
          ref=p*K+lane*4+byte
          direct=scale_phys(mb*16+(lane&15), half*4+(lane>>4), K)
          assert ref==direct, (K,half,mb,lane,ref,direct)
        for nb in range(4):
          b=(wn*64+nb*16)*hk+half*1024+lane*16
          assert b == (wn*64+nb*16)*hk+half*1024+lane*16
          p=nb//2; byte=(nb&1)+2*half
          ref=(wn*2+p)*K+lane*4+byte
          direct=scale_phys(wn*64+nb*16+(lane&15), half*4+(lane>>4), K)
          assert ref==direct, (K,half,wn,nb,lane,ref,direct)


def prove_production_bounds(M:int,N:int,K:int) -> None:
  hk,sk=K//2,K//32
  for mt in range(M//128):
    for bk in range(K//256):
      for half in range(2):
        qoff=bk*128+half*64
        for w in range(4):
          for lane in range(64):
            for j in range(2):
              off=(mt*128+w*32+j*16+(lane>>2))*hk+qoff+(lane&3)*16
              assert 0<=off and off+15<M*hk, (M,N,K,mt,bk,half,w,lane,j,off)
        # A scale groups are mt*4..mt*4+3.
        soff=mt*4*K+bk*256
        assert 0<=soff and soff+3*K+255<M*sk
  for nt in range(N//256):
    for bk in range(K//256):
      for half in range(2):
        qoff=bk*2048+half*1024
        for w in range(4):
          for nb in range(4):
            for lane in range(64):
              off=(nt*256+w*64+nb*16)*hk+qoff+lane*16
              assert 0<=off and off+15<N*hk, (M,N,K,nt,bk,half,w,nb,lane,off)
        soff=nt*8*K+bk*256
        assert 0<=soff and soff+7*K+255<N*sk

  # Exact non-overlapping 128x256 C-store partition.
  row_stride=N*2
  local=[]
  for wn in range(4):
    for lane in range(64):
      laneoff=(lane&15)*row_stride+(lane>>5)*16+((lane>>4)&1)*32
      for mb in range(8):
        for nh in range(2): local.append(wn*64*2+laneoff+mb*16*row_stride+nh*64)
  assert len(local)==4096 and len(set(local))==4096
  covered=set()
  for st in local:
    assert st%16==0
    for x in range(st,st+16): assert x not in covered; covered.add(x)
  expected={r*row_stride+c for r in range(128) for c in range(512)}
  assert covered==expected, (M,N,K,len(covered),len(expected))
  for mt in range(M//128):
    for nt in range(N//256):
      base=mt*128*row_stride+nt*512
      assert base+max(local)+15<M*N*2


def prove_isa() -> None:
  for direct in (False,True):
    insts=build_4w_kernel(16384,4096,4096,direct_lds=direct)
    r=scan_resources(insts)
    assert (r.regular_vgprs,r.accvgprs,r.accum_offset,r.allocated_combined_vgprs)==(128,128,128,256), r
    names=[getattr(x,'op_name','') for x in insts]
    assert names.count('V_MFMA_SCALE_F32_16X16X128_F8F6F4')==96
    assert names.count('S_BARRIER')==3
    assert names.count('DS_READ_B128')==24
    if direct:
      assert names.count('DS_WRITE_B128')==0
      assert sum(1 for x in insts if getattr(x,'lds',0)==1)==8
    else:
      assert names.count('DS_WRITE_B128')==6
      assert sum(1 for x in insts if getattr(x,'lds',0)==1)==0
    assert LDS_BYTES==16640 and USED_LDS_BYTES==16384 and 2*LDS_BYTES<160*1024
    print(('phase2_4w_d2l' if direct else 'phase2_4w'), r.one_line(), f'lds={USED_LDS_BYTES}/{LDS_BYTES}', f'code={sum(x.size() for x in insts)}B')


def main():
  for K in sorted({x[2] for x in LLAMA_SHAPES}):
    prove_a_stage(K); prove_inputs(K)
    print(f'K={K}: 4w A-stage + direct B/scale mapping == proven v13/v14 bytes')
  for sh in LLAMA_SHAPES:
    prove_production_bounds(*sh); print(f'{sh}: 4w production A/B/scale/C bounds + C partition passed')
  prove_isa(); print('phase2 4w mapping proofs passed')

if __name__=='__main__': main()
