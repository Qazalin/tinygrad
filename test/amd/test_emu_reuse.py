import unittest
from tinygrad.runtime.autogen.amd.rdna3.ins import *
from tinygrad.helpers import dedup, DEBUG
from tinygrad import UOp, Device
from tinygrad.uop.ops import Ops
from tinygrad.codegen import to_program
from test.mockgpu.amd.emu import lift, instruction_cache
from extra.gemm.amd_asm_matmul import Kernel

def get_prg(k:Kernel) -> UOp:
  insts = k.finalize()
  renderer = Device["NULL"].renderer
  return to_program(lift(b"".join(x.to_bytes() for x in insts), "rdna3", renderer, (1, 1, 1, 32, 1, 1, 0x19c, 0), "test_emu"), renderer)

def dedup_body(lst): return dedup([u.body for u in lst])

def get_calls(prg:UOp, name_prefix:str) -> list[UOp]:
  ret = [u for u in prg.src[0].toposort(enter_calls=True) if u.op is Ops.CALL and u.body.src[0].arg.name.startswith(name_prefix)]
  seen:set[UOp] = set()
  for i,u in enumerate(ret):
    if DEBUG >= 3:
      print(f"** emulated {name_prefix} match {i}")
      print("** args "+(", ".join([u.render_uir() for u in u.src_without_body])))
    if u.body not in seen:
      seen.add(u.body)
      if DEBUG >= 3: print(u.body.src[0].render_uir())
      if DEBUG >= 4: print(u.body.src[2].arg)
  return ret

def icache_size() -> int: return sum(len(v) for v in instruction_cache.values())

class TestEmuReuse(unittest.TestCase):
  def setUp(self): instruction_cache.clear()
  def test_reuse(self):
    k = Kernel()
    k.emit(v_mov_b32_e32(v[3], v[4]))
    k.emit(v_mov_b32_e32(v[4], 10))
    k.emit(s_endpgm())
    prg = get_prg(k)
    # two calls with different args, same implementation gets reused
    v_mov_calls = get_calls(prg, "v_mov")
    self.assertEqual(len(v_mov_calls), 2)
    self.assertEqual(len(dedup_body(v_mov_calls)), 1)

  def test_instruction_cache_hit(self):
    k1 = Kernel()
    k1.emit(v_mov_b32_e32(v[3], v[4]))
    k1.emit(s_endpgm())
    p1 = get_prg(k1)
    n = icache_size()

    k2 = Kernel()
    k2.emit(v_mov_b32_e32(v[5], 10))
    k2.emit(s_endpgm())
    p2 = get_prg(k2)
    self.assertEqual(icache_size(), n)
    self.assertEqual(len(dedup_body(get_calls(p1, "v_mov") + get_calls(p2, "v_mov"))), 1)

  def test_instruction_cache_literal(self):
    k1 = Kernel()
    k1.emit(v_mov_b32_e32(v[3], 0x12345678))
    k1.emit(s_endpgm())
    get_prg(k1)
    n = icache_size()

    k2 = Kernel()
    k2.emit(v_mov_b32_e32(v[4], 0xdeadbeef))
    k2.emit(s_endpgm())
    get_prg(k2)
    self.assertEqual(icache_size(), n)

  def test_instruction_cache_modifiers(self):
    k1 = Kernel()
    k1.emit(v_add_f32_e64(v[0], v[1], v[2], neg=1))
    k1.emit(s_endpgm())
    p1 = get_prg(k1)
    n = icache_size()

    k2 = Kernel()
    k2.emit(v_add_f32_e64(v[3], v[4], v[5], neg=1))
    k2.emit(s_endpgm())
    p2 = get_prg(k2)
    self.assertEqual(icache_size(), n)

    k3 = Kernel()
    k3.emit(v_add_f32_e64(v[0], v[1], v[2]))
    k3.emit(s_endpgm())
    p3 = get_prg(k3)
    self.assertEqual(icache_size(), n + 1)
    self.assertEqual(len(dedup_body(get_calls(p1, "v_add") + get_calls(p2, "v_add"))), 1)
    self.assertEqual(len(dedup_body(get_calls(p1, "v_add") + get_calls(p3, "v_add"))), 2)

if __name__ == "__main__":
  unittest.main()
