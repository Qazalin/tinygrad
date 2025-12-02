import os
os.environ["PYTHONPATH"] = "."
os.environ["PMC"] = "1"
os.environ["SQTT"] = "1"
if "DEV" not in os.environ: os.environ["DEV"] = "AMD"
os.environ["PROFILE"] = "1"
os.environ["AMD_LLVM"] = "0"

import unittest
import contextlib
from functools import partial
from tinygrad import Tensor, dtypes, Device
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.runtime.ops_amd import ProfilePMCEvent
from extra.sqtt.roc import print_pmc

# use Tensor.custom_kernel to get DEBUG features for free
def escape_format(s):
  return s.replace("{", "{{").replace("}", "}}")

def custom_c_kernel(*args:tuple[UOp, ...], fp:str="", global_size:tuple[int,int,int]=(1,1,1), local_size:tuple[int,int,int]=(1,1,1)):
  args = [a.flatten().base for a in args]
  with open(os.path.dirname(__file__)+f"/examples/{fp}.c", "r") as f: lines = f.readlines()
  c = UOp(Ops.CUSTOM, arg=escape_format("".join(lines[1:-1])))
  launch_args = [*[UOp.special(v, f"gidx{i}") for i,v in enumerate(global_size)], *[UOp.special(v, f"lidx{i}") for i,v in enumerate(local_size)]]
  return UOp.sink(c, *args, *launch_args, arg=KernelInfo("kernel", opts_to_apply=()))

dev = Device[Device.DEFAULT]

@contextlib.contextmanager
def save_pmc():
  dev.profile_events.clear()
  # one pmc event per run
  pmc:list[ProfilePMCEvent] = []
  yield pmc
  for e in dev.profile_events:
    if isinstance(e, ProfilePMCEvent): pmc.append(e)

class TestPMC(unittest.TestCase):
  def test_matrix_add_2d(self):
    size_h = 1024
    size_w = 1024

    A = Tensor.full((size_h, size_w), 1, dtype=dtypes.uint32)
    B = Tensor.full((size_h, size_w), 2, dtype=dtypes.uint32)
    C = Tensor.zeros((size_h, size_w), dtype=dtypes.uint32).contiguous().realize()
    fxn = partial(custom_c_kernel, fp="k0_matrix_add_2d", local_size=(32, 32, 1), global_size=(1024, 1024))
    C = Tensor.custom_kernel(C, A, B, fxn=fxn)[0]
    with save_pmc() as pmc:
      C.realize()
    for p in pmc: print_pmc(p)

if __name__ == "__main__":
  unittest.main()
