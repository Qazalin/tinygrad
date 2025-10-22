import os, unittest
#os.environ["AM_RESET"] = "1"
os.environ["AMD"] = "1"
os.environ["PYTHONPATH"] = "/Users/qazal/code/tinygrad"
os.environ["SQTT"] = "2"
os.environ["VIZ"] = "1"
os.environ["PRINT_MATCH_STATS"] = "0"
os.environ["AMD_LLVM"] = "0"

from tinygrad import Tensor, dtypes
from tinygrad.renderer import ProgramSpec
from tinygrad.uop.ops import UOp, Ops
from tinygrad.engine.realize import CompiledRunner
from tinygrad.device import finalize_profile, Compiled
from extra.sqtt.roc import decode_sqtt

class WPrg:
  def __init__(self, p): self.p = p
  def run(self, *args:Tensor):
    self.p([t.realize().uop.base.buffer.ensure_allocated() for t in args], {}, wait=True)
  def __repr__(self): return self.p.__repr__
def get_prg(src:str, name:str, global_size=[1, 1, 1], local_size=[2, 1, 1]):
    prg = ProgramSpec(name, src, "AMD", UOp(Ops.NOOP), None, global_size=global_size, local_size=local_size)
    return WPrg(CompiledRunner(prg))

class TestSQTT(unittest.TestCase):
  def test_asm(self):
    test = """
typedef long unsigned int size_t;
extern "C" __attribute__((device, const)) size_t __ockl_get_local_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_group_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_local_size(unsigned int);

extern "C" __attribute__((global)) void test(float* data0) {
  unsigned int g = __ockl_get_local_id(0);
  asm volatile("v_mov_b32 v0, 0");
  #pragma clang loop unroll(disable)
  for (unsigned i = 0; i < 10; i++) {
    asm volatile("v_add_u32 v0, v0, 1" ::: "v0");
  }
  unsigned res;
  asm volatile("v_mov_b32 %0, v0" : "=v"(res));
  data0[g] = (float)res;
}
    """
    prg = get_prg(test, "test")
    t = Tensor.empty(2)
    prg.run(t)
    finalize_profile()
    sqtt = decode_sqtt(Compiled.profile_events).output
    for o in sqtt.occ: print(o.simd, o.cu)
    for w in sqtt.wav: print(w)

  def test_wave_sched(self):
    test = """extern "C" __attribute__((global)) void test(float* data0) {}"""
    global_size = [32, 1, 1]
    local_size  = [32, 1, 1]
    prg = ProgramSpec("test", test, "AMD", UOp(Ops.NOOP), None, global_size=global_size, local_size=local_size)
    cr = CompiledRunner(prg)
    cr([Tensor.empty(1).uop.buffer.ensure_allocated()], {}, wait=True)

if __name__ == "__main__":
  unittest.main()
