import math, pathlib

from tinygrad import Device, dtypes
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.helpers import getenv

from extra.gemm.amd_uop_matmul import test_matmul

M = N = K = 4096
TM = TN = 96
THREADS_PER_WG = 128
NUM_WG = math.ceil(M / TM) * math.ceil(N / TN)

dname:str = Device.DEFAULT
template:str = (pathlib.Path(__file__).parent/"template.s").read_text()

src = template.replace("INSTRUCTIONS", (pathlib.Path(__file__).parent/"gemm.s").read_text())

def asm_kernel() -> UOp:
  lidx = UOp.special(THREADS_PER_WG, "lidx0")
  gidx = UOp.special(NUM_WG, "gidx0")

  a = UOp.placeholder((N*N,), dtypes.half, slot=1)
  b = UOp.placeholder((N*N,), dtypes.half, slot=2)
  c = UOp.placeholder((N*N,), dtypes.half, slot=0)

  sink = UOp.sink(a, b, c, lidx, gidx, arg=KernelInfo(name="gemm"))
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=dname), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=src)))

if __name__ == "__main__":
  test_matmul(asm_kernel(), dtype=dtypes.half, N=N)

  # rewrite the assembly file with the new pc addresses
  lib = Device[Device.DEFAULT].compiler.compile(src)
  from tinygrad.viz.serve import get_stdout
  disasm = get_stdout(lambda: Device[Device.DEFAULT].compiler.disassemble(lib))
  lines = []
  for line in disasm.splitlines()[4:]:
    if "<" not in line:
      lines.append(line)
    else:
      addr, label = line.replace("<", "").replace(">", "").split()
      lines.append(f"{label} // {addr}")
  with open("./extra/gemm/asm/rdna3/gemm.s", "w") as f: f.write("\n".join(lines))
