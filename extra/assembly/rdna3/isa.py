# TODO: this should be auto generated from the XML
import functools
from enum import IntEnum
from extra.assembly.rdna3.lib import *

class SOPCOps(IntEnum):
  S_CMP_EQ_I32 = 0

class SOPC(PackTrait):
  ENC = 0b10_1111110
  ssrc0    = bits[7:0]
  ssrc1    = bits[15:8]
  op       = bits[22:16]
  encoding = bits[31:23]

s_cmp_eq_i32 = functools.partial(SOPC.pack, op=SOPCOps.S_CMP_EQ_I32, encoding=SOPC.ENC)
