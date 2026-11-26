import unittest
from tinygrad.renderer.amd.dsl import s
from tinygrad.runtime.autogen.amd.rdna3.ins import *
from tinygrad.helpers import Context, dedup, DEBUG
from tinygrad import Tensor, UOp, Device
from tinygrad.uop.ops import KernelInfo, Ops
from tinygrad.codegen import to_program
from test.mockgpu.amd.emu import lift
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
      print(f"** args "+(", ".join([u.render_uir() for u in u.src_without_body])))
    if u.body not in seen:
      seen.add(u.body)
      if DEBUG >= 3: print(u.body.src[0].render_uir())
      if DEBUG >= 4: print(u.body.src[2].arg)
  return ret

class TestEmuReuse(unittest.TestCase):
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

if __name__ == "__main__":
  unittest.main()
