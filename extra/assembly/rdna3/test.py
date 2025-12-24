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

if __name__ == "__main__":
  unittest.main()
