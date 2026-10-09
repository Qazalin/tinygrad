import unittest
from unittest.mock import patch
from test.mockgpu.amd import call
from test.mockgpu.amd.call import dominators, cfg_loops


class TestAsmCFG(unittest.TestCase):
  def test_diamond_with_unreachable_block(self):
    paths = {0:{1:0, 2:1}, 1:{3:0}, 2:{3:0}, 3:{}, 99:{}}
    self.assertEqual(dominators(paths, 0), {0:0, 1:0, 2:0, 3:0})
    self.assertEqual(cfg_loops(paths, 0), {})

  def test_nested_loops(self):
    paths = {0:{1:0}, 1:{2:0, 5:1}, 2:{3:0, 4:1}, 3:{2:0}, 4:{1:0}, 5:{}}
    self.assertEqual(dominators(paths, 0), {0:0, 1:0, 2:1, 3:2, 4:2, 5:1})
    self.assertEqual(cfg_loops(paths, 0), {1:{1, 2, 3, 4}, 2:{2, 3}})

  def test_multiple_backedges(self):
    paths = {0:{1:0}, 1:{2:0, 3:1}, 2:{1:0}, 3:{1:0, 4:1}, 4:{}}
    self.assertEqual(cfg_loops(paths, 0), {1:{1, 2, 3}})

  def test_self_loop(self):
    self.assertEqual(cfg_loops({0:{0:0, 1:1}, 1:{}}, 0), {0:{0}})

  def test_irreducible_loop(self):
    with self.assertRaisesRegex(AssertionError, "irreducible"):
      cfg_loops({0:{1:0, 2:1}, 1:{2:0}, 2:{1:0, 3:1}, 3:{}}, 0)

  def test_long_chain(self):
    paths = {i:{i+1:0} for i in range(4999)} | {4999:{}}
    self.assertEqual(dominators(paths, 0), {0:0} | {i:i-1 for i in range(1, 5000)})
    self.assertEqual(cfg_loops(paths, 0), {})

  def test_loop_lift_has_stable_cache_key(self):
    from tinygrad.runtime.autogen.amd.rdna3.ins import s_mov_b32, s_add_u32, s_cmp_lt_i32, s_cbranch_scc1, s_endpgm
    from tinygrad.renderer.amd.dsl import s
    code = b"".join((s_mov_b32(s[2], 0).to_bytes(), s_add_u32(s[2], s[2], 1).to_bytes(), s_cmp_lt_i32(s[2], 4).to_bytes(),
                     s_cbranch_scc1(simm16=-3).to_bytes(), s_endpgm().to_bytes()))
    with patch.object(call, "to_program", side_effect=lambda sink, renderer: sink):
      first = call._lift(code, "rdna3", "PYTHON", 0)
      second = call._lift(code, "rdna3", "PYTHON", 0)
    self.assertEqual(first.key, second.key)


if __name__ == "__main__": unittest.main()
