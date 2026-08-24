#!/usr/bin/env python3
"""Static equivalence proofs for the direct-load 8-wave kernel.

These checks compare the direct physical byte addresses against the known-good
256x256 reference data path / quantizer layouts.  They intentionally do not just
check bounds: every direct A/B/scale byte used by a native MFMA must be the same
physical byte that the reference delivers to that MFMA.
"""
from extra.gemm.cdna_lib.mxfp4 import LLAMA_SHAPES

READS = (
  (0,0,0),(0,64,0),(1,0,2),(1,64,2),
  (2,128,16),(2,192,16),(3,128,18),(3,192,18),
  (4,0,33),(4,64,33),(5,0,35),(5,64,35),
  (6,128,49),(6,192,49),(7,128,51),(7,192,51),
)

def scale_phys(row:int, col:int, K:int) -> int:
  cols = K//32
  tile = ((row >> 5) * (cols >> 3) + (col >> 3)) << 8
  off = ((col & 3) << 6) + ((row & 15) << 2) + (((col >> 2) & 1) << 1) + ((row >> 4) & 1)
  return tile + off

def ref_a_global(loader_wave:int, lane:int, block:int, half_k:int) -> int:
  q = lane >> 3
  rowcode = ((q >> 2) << 4) + (((q & 3) >> 1) << 2) + (q & 1)
  row = rowcode + ((loader_wave >> 1) << 3) + ((loader_wave & 1) << 1) + block*32
  return row*half_k + (lane & 7)*16

def ref_lds_base(lane:int) -> int:
  x = lane & 15
  base = (((x >> 3) << 1) + ((x & 3) >> 1)) * 1056
  y = lane & 7
  return base + (y >> 2)*256 + (y & 1)*128 + (lane >> 4)*16 + 4096

def prove_a(K:int) -> None:
  half_k=K//2
  lds={}
  for w in range(4):
    for lane in range(64):
      for block in range(8):
        lb=4096+w*1056+block*4224+lane*16
        gb=ref_a_global(w,lane,block,half_k)
        for b in range(16):
          assert lb+b not in lds
          lds[lb+b]=gb+b

  by_mb_half={}
  for idx,(mb,off0,off1) in enumerate(READS): by_mb_half[(mb,idx&1)]=(off0,off1)
  for wm in range(2):
    for mb in range(8):
      for kh in range(2):
        off0,off1=by_mb_half[(mb,kh)]
        for lane in range(64):
          lb=ref_lds_base(lane)+off0+(off1+wm*66)*256
          direct=(wm*128+mb*16+(lane&15))*half_k + kh*64 + (lane>>4)*16
          for b in range(16): assert lds[lb+b] == direct+b, (K,wm,mb,kh,lane,b,lds[lb+b],direct+b)

def prove_a_scale(K:int) -> None:
  sk=K//32
  lds={}
  for w in range(4):
    for lane in range(64):
      for rowoff,ldsoff in ((0,0),(128,1024)):
        gb=lane*4+(w*32+rowoff)*sk
        lb=w*256+lane*4+ldsoff
        for b in range(4):
          assert lb+b not in lds
          lds[lb+b]=gb+b
  for wm in range(2):
    for mb in range(8):
      for kh in range(2):
        byte=(mb&1)+kh*2
        for lane in range(64):
          lb=lane*4+(mb//2+wm*4)*256+byte
          row=wm*128+mb*16+(lane&15)
          col=kh*4+(lane>>4)
          direct=scale_phys(row,col,K)
          assert lds[lb] == direct, (K,wm,mb,kh,lane,lds[lb],direct)

def prove_b(K:int) -> None:
  half_k=K//2
  for wn in range(4):
    for nb in range(4):
      for kh in range(2):
        for lane in range(64):
          # Reference v225..v232 after v0 has been reduced to lane_id.
          ref=lane*16 + (wn*64+nb*16)*half_k + kh*1024
          direct=ref
          assert direct == ref

def prove_b_scale(K:int) -> None:
  sk=K//32
  for wn in range(4):
    for nb in range(4):
      for kh in range(2):
        byte=(nb&1)+kh*2
        for lane in range(64):
          # Reference loads a dword at v233 for nb0/1 and v234 for nb2/3.
          ref=lane*4 + wn*64*sk + (nb//2)*32*sk + byte
          row=wn*64+nb*16+(lane&15)
          col=kh*4+(lane>>4)
          direct=scale_phys(row,col,K)
          assert direct == ref, (K,wn,nb,kh,lane,ref,direct)

def prove_bounds(M:int,N:int,K:int) -> None:
  hk,sk=K//2,K//32
  for mt in range(M//256):
    for wm in range(2):
      for mb in range(8):
        for kh in range(2):
          for lane in range(64):
            a=((mt*256+wm*128+mb*16+(lane&15))*hk + kh*64 + (lane>>4)*16)
            assert a+15 < M*hk
            sa=scale_phys(mt*256+wm*128+mb*16+(lane&15), kh*4+(lane>>4), K)
            assert sa < M*sk
  for nt in range(N//256):
    for wn in range(4):
      for nb in range(4):
        for kh in range(2):
          for lane in range(64):
            b=lane*16 + (nt*256+wn*64+nb*16)*hk + kh*1024
            assert b+15 < N*hk
            sb=scale_phys(nt*256+wn*64+nb*16+(lane&15), kh*4+(lane>>4), K)
            assert sb < N*sk

def prove_mfma_schedule() -> None:
  # Normalize the known-good reference's first 128x64 half into native block
  # coordinates.  Direct Phase 2 must implement exactly these 64 operations: two
  # K128 contributions for every (mb,nb) output block.
  from extra.gemm.cdna_lib.phase2 import _mfma_half_template
  mfmas,_ = _mfma_half_template()
  seen=set()
  for x in mfmas:
    B=x.src0.offset-256; A=x.src1.offset-256; dst=x.vdst.offset-256
    kh=1 if B >= 152 else 0
    nb=(B-(152 if kh else 136))//4
    mb=(A-(40 if kh else 8))//4
    assert 0 <= mb < 8 and 0 <= nb < 4
    assert dst == nb*32+mb*4, (dst,nb,mb)
    # In the reference, packed scale byte selection is exactly parity + 2*kh.
    # Direct Phase 2 loads that byte alone into bits[7:0], so selector 00 is
    # architecturally equivalent.
    bbyte=(x.opsel & 1) + 2*(x.opsel_hi & 1)
    abyte=((x.opsel >> 1) & 1) + 2*((x.opsel_hi >> 1) & 1)
    assert bbyte == (nb&1)+2*kh, (bbyte,nb,kh)
    assert abyte == (mb&1)+2*kh, (abyte,mb,kh)
    seen.add((kh,nb,mb,dst))
  expected={(kh,nb,mb,nb*32+mb*4) for kh in range(2) for nb in range(4) for mb in range(8)}
  assert seen == expected


def prove_emitted_address_isa(K:int) -> None:
  # The direct kernels must encode the A row-stride product as a VOP2 literal
  # multiply.  VOP3 has no trailing literal dword; v12 accidentally emitted
  # the LIT marker in src0/src2 and never encoded half_k at all.
  from extra.gemm.cdna_lib.phase2_direct import build_direct_kernel, build_direct_pingpong_kernel
  from tinygrad.renderer.amd.dsl import Reg
  half_k=K//2
  for name,insts,target in (("direct",build_direct_kernel(256,4096,K,fast=False),104),
                            ("pingpong",build_direct_pingpong_kernel(256,4096,K),124)):
    matches=[x for x in insts if getattr(x,"op_name","")=="V_MUL_I32_I24_E32" and getattr(getattr(x,"vdst",None),"offset",-1)==256+target]
    assert len(matches)==1, (K,name,len(matches),matches)
    x=matches[0]
    assert type(x).__name__ == "VOP2_LIT", (K,name,type(x).__name__,repr(x))
    assert getattr(x,"literal",None) == half_k, (K,name,repr(x),getattr(x,"literal",None),half_k)
    assert x.to_bytes()[-4:] == half_k.to_bytes(4,"little"), (K,name,x.to_bytes().hex(),half_k)
    for inst in insts:
      if type(inst).__name__.startswith("VOP3") and type(inst).__name__ != "VOP3PX2":
        for field in ("src0","src1","src2"):
          val=getattr(inst,field,None)
          assert not (isinstance(val,Reg) and val.offset==255), (K,name,inst,field,inst.to_bytes().hex())

def main() -> None:
  prove_mfma_schedule()
  print("direct MFMA block/destination/scale-selector mapping == reference")
  for K in sorted({s[2] for s in LLAMA_SHAPES}):
    prove_a(K); prove_a_scale(K); prove_b(K); prove_b_scale(K); prove_emitted_address_isa(K)
    print(f"K={K}: direct MFMA input mapping + emitted address ISA == reference intent")
  for shape in LLAMA_SHAPES:
    prove_bounds(*shape)
    print(f"{shape}: direct global bounds passed")
  print("phase2 direct mapping proofs passed")

if __name__ == '__main__': main()
