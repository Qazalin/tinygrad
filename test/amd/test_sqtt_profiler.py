import unittest, contextlib
from tinygrad import Device, Tensor, Context, TinyJit
from tinygrad.viz.serve import load_amd_counters

@contextlib.contextmanager
def save_sqtt():
  Device[Device.DEFAULT].synchronize()
  Device[Device.DEFAULT].profile_events.clear()
  yield (ret:=[])
  load_amd_counters(ret, Device[Device.DEFAULT].profile_events)
  ret[:] = [r for r in ret if r["name"].startswith("Exec")]

@unittest.skipUnless(Device.DEFAULT == "AMD", "only runs on AMD")
class TestSQTTProfiler(unittest.TestCase):
  @classmethod
  def setUpClass(cls):
    if not Device[Device.DEFAULT].sqtt_enabled: raise unittest.SkipTest("requires device to be in SQTT profiling mode")

  def test_simple(self):
    t = Tensor.empty(1) + 1
    with save_sqtt() as sqtt:
      ei = t.schedule()[0].lower()
      ei.run()
    self.assertEqual(len(sqtt), 1)
    self.assertEqual(sqtt[0]["name"], f"Exec {ei.prg.p.function_name}")

  def test_multiple_runs(self):
    t = Tensor.empty(1) + 1
    with save_sqtt() as sqtt:
      ei = t.schedule()[0].lower()
      for _ in range(N:=3):
        ei.run()
    self.assertEqual(len(sqtt), N)
    for i in range(1, N):
      self.assertEqual(sqtt[i]["name"], f"Exec {ei.prg.p.function_name} n{i+1}")

  def test_multiple_kernels(self):
    t = ((Tensor.empty(1) + 1).contiguous() + 2)
    with save_sqtt() as sqtt:
      kernels = [si.lower() for si in t.schedule()]
      for k in kernels: k.run()
    self.assertEqual(len(sqtt), len(kernels))
    for i,k in enumerate(kernels):
      self.assertEqual(sqtt[i]["name"], f"Exec {k.prg.p.function_name}")

  def test_multiple_runs_jit(self):
    @TinyJit
    def f(t): return ((t + 1).contiguous() + 2)
    t = Tensor.empty(1)
    with save_sqtt() as sqtt:
      for _ in range(N:=5): f(t).realize()
    self.assertEqual(len(sqtt), N)

if __name__ == "__main__":
  unittest.main()
