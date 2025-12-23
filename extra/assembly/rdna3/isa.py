# TODO: this should be auto generated from the XML
from extra.assembly.rdna3.bitfield import PackTrait, field

class SOPC(PackTrait):
  ENC = 0b10_1111110
  encoding = field(23, 31)
  op       = field(16, 22)
  ssrc1    = field(8, 15)
  ssrc0    = field(0, 7)
  def s_cmp_eq_i32(*args): return SOPC.pack(0, *args)
  def s_cmp_lg_i32(*args): return SOPC.pack(1, *args)
