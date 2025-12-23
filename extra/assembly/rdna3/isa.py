# TODO: this should be auto generated from the XML
from enum import IntEnum, auto
from extra.assembly.rdna3.bitfield import PackTrait, bits

class SOPC(PackTrait):
  ENC = 0b10_1111110
  encoding = bits[31:23]
  op       = bits[22:16]
  ssrc1    = bits[15:8]
  ssrc0    = bits[7:0]

class SOPCOps(IntEnum):
  S_CMP_EQ_I32 = 0

def s_cmp_eq_i32(*args): return SOPC.pack(SOPCOps.S_CMP_EQ_I32.value, *args)
