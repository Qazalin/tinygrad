import unittest

from extra.assembly.rdna3.isa import *
from extra.assembly.rdna3.lib import *

from extra.assembly.rdna3.co import llvm_asm

class TestRDNA(unittest.TestCase):
  def test_asm(self):
    self.assertEqual(s_cmp_eq_i32(s[1], s[2]), llvm_asm("s_cmp_eq_i32 s1 s2"))
    self.assertEqual(s_cmp_eq_i32(ssrc1=s[2], ssrc0=s[1]), llvm_asm("s_cmp_eq_i32 s1 s2"))
    self.assertEqual(s_cmp_eq_i32(s[1], ssrc1=s[2]), llvm_asm("s_cmp_eq_i32 s1 s2"))

    with self.assertRaisesRegex(TypeError, "wrong number of arguments"):
      s_cmp_eq_i32(s[2], s[1], 1)

    with self.assertRaises(KeyError): # could do better
      s_cmp_eq_i32(s[2], sdst=s[3])

  def test_disasm(self):
    bits = s_cmp_eq_i32(s[1], s[2])
    sopc = SOPC.unpack(bits)

    assert sopc.ssrc0 is s[1] and sopc.ssrc1 is s[2]
    # TODO: this doesn't pass yet
    assert llvm_asm(str(sopc)) == bits

if __name__ == "__main__":
  unittest.main()
