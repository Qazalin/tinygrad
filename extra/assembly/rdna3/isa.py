# TODO: this should be auto generated from the XML
from enum import IntEnum
from extra.assembly.rdna3.lib import *

class SOPCOps(IntEnum):
  S_CMP_EQ_I32 = 0

class SOPC(PackTrait):
  ENC = 0b10_1111110
  encoding = field(bits[31:23], Id)
  op       = field(bits[22:16], Opcode(SOPCOps))
  ssrc1    = field(bits[15:8], SSRC)
  ssrc0    = field(bits[7:0], SSRC)

def s_cmp_eq_i32(*args): return SOPC.pack(SOPC.ENC, SOPCOps.S_CMP_EQ_I32, *args)
