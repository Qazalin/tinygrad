# TODO: this should be auto generated from the XML
from enum import IntEnum
from extra.assembly.rdna3.lib import *

class SOPCOps(IntEnum):
  S_CMP_EQ_I32 = 0

class SOPC(PackTrait):
  ENC = 0b10_1111110
  ssrc0    = field(bits[7:0], SSRC)
  ssrc1    = field(bits[15:8], SSRC)
  op       = field(bits[22:16], Opcode(SOPCOps))
  encoding = field(bits[31:23], Id)

def s_cmp_eq_i32(*args): return SOPC.pack(*args, SOPCOps.S_CMP_EQ_I32, SOPC.ENC)
