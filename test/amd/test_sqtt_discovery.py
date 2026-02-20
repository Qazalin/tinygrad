import sys, os, pickle, subprocess, unittest
import tinygrad.runtime.autogen.amd.rdna4.ins as rdna4
from tinygrad.runtime.autogen.amd.rdna4.enum import SOP1Op
from tinygrad.renderer.amd.dsl import s, NULL

def run_op(op_name):
  """Build and run a minimal kernel with a single SOP1 instruction, capturing SQTT."""
  os.environ.update(AMD="1", VIZ="-2", AM_RESET="1")
  from extra.gemm.amd_asm_matmul import Kernel
  from tinygrad import Device, Tensor
  from tinygrad.uop.ops import UOp, Ops, KernelInfo
  op = SOP1Op[op_name]
  dev = Device["AMD"]
  k = Kernel(dev.arch)
  regs = rdna4.SOP1(op=op, sdst=NULL, ssrc0=NULL).op_regs
  dst = s[0:regs["sdst"]-1] if regs["sdst"] > 1 else s[0]
  src = s[2:2+regs["ssrc0"]-1] if regs["ssrc0"] > 1 else s[2]
  k.emit(rdna4.SOP1(op=op, sdst=dst, ssrc0=src))
  k.emit(rdna4.s_endpgm())
  insts = k.finalize()
  def fxn(A:UOp) -> UOp:
    lidx = UOp.special(1, "lidx0")
    gidx = UOp.special(1, "gidx0")
    sink = UOp.sink(A.base, lidx, gidx, arg=KernelInfo(name=f"sop1_{op.name.lower()}"))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in insts]))))
  a = Tensor.empty(1)
  a = Tensor.custom_kernel(a, fxn=fxn)[0]
  a.realize()

def sop1_test(op):
  def test(self):
    result = subprocess.run([sys.executable, __file__, op.name], capture_output=True, timeout=30)
    self.assertEqual(result.returncode, 0, f"{op.name} failed:\n{result.stderr.decode()}")
    from tinygrad.helpers import temp
    with open(temp("profile.pkl", append_user=True), "rb") as f:
      data = pickle.load(f)
    sqtt_events = [e for e in data if type(e).__name__ == "ProfileSQTTEvent"]
    prg = next((e for e in data if type(e).__name__ == "ProfileProgramEvent"), None)
    self.assertGreater(len(sqtt_events), 0, f"no SQTT events for {op.name}")
    from tinygrad.renderer.amd.sqtt import decode
    for event in sqtt_events:
      packets = list(decode(event.blob))
      self.assertGreater(len(packets), 0, f"our decoder failed for {op.name}")
    from test.amd.test_sqtt_examples import run_rocprof_decoder
    self.assertIsNotNone(prg, f"no program event for {op.name}")
    run_rocprof_decoder([e.blob for e in sqtt_events], prg.lib, prg.base, "gfx1200")
  return test

class TestSQTTDiscovery(unittest.TestCase): pass

for op in rdna4.SOP1.op.allowed:
  if op.name.lower() in {"s_setpc_b64", "s_getpc_b64", "s_swappc_b64", "s_rfe_b64", "s_alloc_vgpr", "s_sleep_var", "s_barrier_init", "s_barrier_join",
                         "s_barrier_signal", "s_barrier_signal_isfirst", "s_get_barrier_state"}: continue
  setattr(TestSQTTDiscovery, f"test_sop1_{op.name.lower()}", sop1_test(op))

if __name__ == "__main__":
  if len(sys.argv) == 2 and sys.argv[1] in SOP1Op.__members__:
    run_op(sys.argv[1])
  else:
    unittest.main()
