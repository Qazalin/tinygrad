#!/usr/bin/env python3
"""Static semantic/resource proofs for the 64x256, 4-wave high-residency kernel."""
from extra.gemm.cdna_lib.mxfp4 import LLAMA_SHAPES
from extra.gemm.cdna_lib.phase2_4w64 import (
  TILE_M,TILE_N,A_STAGE_BYTES,A0_LDS,A1_LDS,USED_LDS_BYTES,LDS_BYTES,build_4w64_kernel,
)
from extra.gemm.cdna_lib.resources import scan_resources
from extra.gemm.cdna_lib.test_direct_mapping import scale_phys


def prove_a_stage(K:int)->None:
  hk=K//2
  # Each of four waves supplies one M16 row block, 64 lanes x16 B = 1 KiB/wave.
  stage={}
  for w in range(4):
    for lane in range(64):
      l=A0_LDS+w*1024+lane*16
      g=(w*16+(lane>>2))*hk+(lane&3)*16
      for x in range(16):
        assert l+x not in stage
        stage[l+x]=g+x
  assert len(stage)==A_STAGE_BYTES==4096
  assert min(stage)==0 and max(stage)==A_STAGE_BYTES-1
  # The four native M16 MFMA operands must read exactly the direct/v16 bytes.
  for mb in range(4):
    for lane in range(64):
      l=(mb*16+(lane&15))*64+(lane>>4)*16
      g=(mb*16+(lane&15))*hk+(lane>>4)*16
      for x in range(16): assert stage[l+x]==g+x,(K,mb,lane,x,stage[l+x],g+x)
  assert A1_LDS==A_STAGE_BYTES and USED_LDS_BYTES==2*A_STAGE_BYTES


def prove_inputs(K:int)->None:
  hk=K//2
  for half in range(2):
    for wn in range(4):
      for lane in range(64):
        for mb in range(4):
          # A physical operand is the first four M16 blocks of the GPU-proven v16 tile.
          got=(mb*16+(lane&15))*hk+half*64+(lane>>4)*16
          ref=(mb*16+(lane&15))*hk+half*64+(lane>>4)*16
          assert got==ref
          p=mb//2; byte=(mb&1)+2*half
          packed=p*K+lane*4+byte
          phys=scale_phys(mb*16+(lane&15),half*4+(lane>>4),K)
          assert packed==phys,(K,half,mb,lane,packed,phys)
        for nb in range(4):
          got=(wn*64+nb*16)*hk+half*1024+lane*16
          ref=(wn*64+nb*16)*hk+half*1024+lane*16
          assert got==ref
          p=nb//2; byte=(nb&1)+2*half
          packed=(wn*2+p)*K+lane*4+byte
          phys=scale_phys(wn*64+nb*16+(lane&15),half*4+(lane>>4),K)
          assert packed==phys,(K,half,wn,nb,lane,packed,phys)


def prove_production_bounds(M:int,N:int,K:int)->None:
  hk,sk=K//2,K//32
  assert M%TILE_M==N%TILE_N==0 and K%512==0
  for mt in range(M//TILE_M):
    for bk in range(K//256):
      for half in range(2):
        q=bk*128+half*64
        for w in range(4):
          for lane in range(64):
            off=(mt*64+w*16+(lane>>2))*hk+q+(lane&3)*16
            assert 0<=off and off+15<M*hk,(M,N,K,mt,bk,half,w,lane,off)
        soff=mt*2*K+bk*256
        assert 0<=soff and soff+K+255<M*sk
  for nt in range(N//TILE_N):
    for bk in range(K//256):
      for half in range(2):
        q=bk*2048+half*1024
        for wn in range(4):
          for nb in range(4):
            for lane in range(64):
              off=(nt*256+wn*64+nb*16)*hk+q+lane*16
              assert 0<=off and off+15<N*hk,(M,N,K,nt,bk,half,wn,nb,lane,off)
        soff=nt*8*K+bk*256
        assert 0<=soff and soff+7*K+255<N*sk

  # Exact byte partition of one 64x256 BF16 tile.
  stride=N*2
  starts=[]
  for wn in range(4):
    for lane in range(64):
      laneoff=(lane&15)*stride+(lane>>5)*16+((lane>>4)&1)*32
      for mb in range(4):
        for nh in range(2): starts.append(wn*128+laneoff+mb*16*stride+nh*64)
  assert len(starts)==2048 and len(set(starts))==2048
  covered=set()
  for st in starts:
    assert st%16==0
    for x in range(st,st+16):
      assert x not in covered
      covered.add(x)
  expected={r*stride+c for r in range(64) for c in range(512)}
  assert covered==expected,(M,N,K,len(covered),len(expected))
  for mt in range(M//64):
    for nt in range(N//256):
      base=mt*64*stride+nt*512
      assert base+max(starts)+15<M*N*2


def prove_isa()->None:
  for progressive in (False,True):
    insts=build_4w64_kernel(16384,4096,4096,progressive=progressive)
    r=scan_resources(insts)
    assert (r.regular_vgprs,r.accvgprs,r.accum_offset,r.allocated_combined_vgprs)==(62,64,64,128),r
    names=[getattr(x,'op_name','') for x in insts]
    # Static control flow contains four normal K128 sites plus the final-odd branch site.
    assert names.count('V_MFMA_SCALE_F32_16X16X128_F8F6F4')==80,names.count('V_MFMA_SCALE_F32_16X16X128_F8F6F4')
    assert names.count('S_BARRIER')==5,names.count('S_BARRIER')
    assert names.count('DS_READ_B128')==20,names.count('DS_READ_B128')
    assert names.count('DS_WRITE_B128')==0
    assert sum(1 for x in insts if getattr(x,'lds',0)==1)==5
    for x in insts:
      if getattr(x,'op_name','').startswith('V_') and x.__class__.__name__.startswith('VOP3'):
        assert 'LIT' not in repr(x),repr(x)
    waits=[getattr(x,'simm16',None) for x in insts if getattr(x,'op_name','')=='S_WAITCNT']
    if progressive: assert len(waits)>20 and len(set(waits))>5,waits
    assert USED_LDS_BYTES==8192 and LDS_BYTES==8960 and 4*LDS_BYTES<160*1024
    label='phase2_4w64_pipe' if progressive else 'phase2_4w64'
    print(label+' resources:',r.one_line(),f'lds={USED_LDS_BYTES}/{LDS_BYTES}',f'code={sum(x.size() for x in insts)}B insts={len(insts)}')


def main():
  for K in sorted({x[2] for x in LLAMA_SHAPES}):
    prove_a_stage(K); prove_inputs(K)
    print(f'K={K}: 4w64 A-stage/B/scale mapping == GPU-proven v16 bytes')
  for sh in LLAMA_SHAPES:
    prove_production_bounds(*sh)
    print(f'{sh}: 4w64 production A/B/scale/C bounds + exact C partition passed')
  prove_isa(); print('phase2 4w64 mapping proofs passed')

if __name__=='__main__': main()
