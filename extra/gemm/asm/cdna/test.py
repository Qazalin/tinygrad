# Run assembly on the AMD runtime and check correctness
# VIZ=2 to profile
import pathlib
from tinygrad import Tensor, Device, dtypes, Context
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.helpers import getenv

fp = pathlib.Path(__file__).parent/"gemm.s"

M = getenv("M", 8192)
N = getenv("N", 8192)
K = getenv("K", 8192)
THREADS_PER_WG = 256
NUM_WG = (M//THREADS_PER_WG) * (N//THREADS_PER_WG)

assert M % THREADS_PER_WG == 0, "M must be divisible by THREADS_PER_WG"
assert N % THREADS_PER_WG == 0, "N must be divisible by THREADS_PER_WG"

# ** generate inputs on CPU

scale = 10.0

import torch
torch.manual_seed(0)
A = (torch.randn(M, K, dtype=torch.float32, device="cpu") / scale).to(torch.bfloat16).contiguous()
B = (torch.randn(K, N, dtype=torch.float32, device="cpu") / scale).to(torch.bfloat16).contiguous()
Bt = B.t().contiguous() # transpose B for the asm gemm
C_torch = A@B

# ** copy buffers to AMD

# input creation and validation run on the copy engine for simpler tracing

def from_torch(t:torch.Tensor) -> Tensor:
  return Tensor.from_blob(t.data_ptr(), t.shape, dtype=dtypes.bfloat16, device="cpu").to(Device.DEFAULT).realize()

C_tiny = from_torch(A) @ from_torch(B)
C_asm = Tensor.empty_like(C_tiny)

# ** assembly custom kernel

def custom_asm_gemm(C:UOp, A:UOp, B:UOp) -> UOp:
  lidx = UOp.special(THREADS_PER_WG, "lidx0")
  gidx = UOp.special(NUM_WG, "gidx0")

  src = (pathlib.Path(__file__).parent/"template.s").read_text().replace("INSTRUCTIONS", fp.read_text())

  m = UOp.variable("M", 256, 8192)
  n = UOp.variable("N", 256, 8192)
  k = UOp.variable("K", 256, 8192)

  sink = UOp.sink(C.base, A.base, B.base, m, n, k, lidx, gidx, arg=KernelInfo(name="gemm"))
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=src)))

C_asm = Tensor.custom_kernel(C_asm, from_torch(A), from_torch(Bt), fxn=custom_asm_gemm)[0]

# ** run gemms

sched = Tensor.schedule(C_tiny, C_asm)
eis = [si.lower() for si in sched]

with Context(DEBUG=2):
  for ei in eis:
    et = ei.run({"M":M, "N":N, "K":K}, wait=True)
    print(f"{(M*N*K*2 / et)*1e-12:.2f} REAL TFLOPS")

# ** correctness

import ctypes

def torch_bf16(t:Tensor) -> torch.tensor:
  t_cpu = t.to("cpu").realize()
  buf = (ctypes.c_uint16*t_cpu.uop.size).from_address(t_cpu.uop.buffer._buf.va_addr)
  return torch.frombuffer(buf, dtype=torch.bfloat16, count=t_cpu.uop.size).reshape(t.shape)

assert torch.allclose(torch_bf16(C_asm), C_torch, rtol=1e-2, atol=1e-3)
assert torch.allclose(torch_bf16(C_tiny), C_torch, rtol=1e-2, atol=1e-3)
