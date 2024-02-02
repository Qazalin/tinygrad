import time
import numpy as np
from tinygrad.helpers import getenv, prod, flat_mv
from tinygrad.renderer.cstyle import HIPLanguage

if getenv("HIPCPU"):
  from tinygrad.runtime.ops_remu import MallocAllocator, compile_hip, HIPDevice, HIPProgram
  device = HIPDevice()
  hipallocator = MallocAllocator
else:
  from tinygrad.runtime.ops_hip import HIPAllocator, HIPDevice, HIPProgram, compile_hip, MallocAllocator, HIPProgram
  device = HIPDevice()
  hipallocator = HIPAllocator(device)

N = getenv("N", 16)
FLOPS = N*N*N*2
BW = N*N*3*4

a = hipallocator.alloc(N*N*4)
b = hipallocator.alloc(N*N*2)
c = hipallocator.alloc(N*N*2)
na = np.zeros(N*N, np.float16)
nb = np.random.default_rng(seed=0).standard_normal(size=(N,N), dtype=np.float32).astype(np.float16)
nc = np.random.default_rng(seed=1).standard_normal(size=(N,N), dtype=np.float32).astype(np.float16)
hipallocator.copyin(b, bytearray(nb))
hipallocator.copyin(c, bytearray(nc))

def compile_hipold(prg:str, arch="gfx1100") -> bytes:
  if not getenv("HIPCPU"):
    from tinygrad.runtime.ops_hip import hip, check, ctypes
    from tinygrad.helpers import to_char_p_p, get_bytes
    check(hip.hiprtcCreateProgram(ctypes.byref(prog := hip.hiprtcProgram()), prg.encode(), "<null>".encode(), 0, None, None))
    compile_options = [f'--offload-arch={arch}', '-I/opt/rocm/include']
    status = hip.hiprtcCompileProgram(prog, len(compile_options), to_char_p_p([o.encode() for o in compile_options]))
    if status != 0: raise RuntimeError(f"compile failed: {get_bytes(prog, hip.hiprtcGetProgramLogSize, hip.hiprtcGetProgramLog, check).decode()}")
    return get_bytes(prog, hip.hiprtcGetCodeSize, hip.hiprtcGetCode, check)
  return open("./compiled.s").read().encode("utf-8")

lib = compile_hipold(open("gemm3.cpp").read())

if getenv("ASM"):
  import subprocess
  asm = subprocess.check_output(["/opt/rocm/llvm/bin/llvm-objdump", '-d', '-'], input=lib)
  asm = '\n'.join([x for x in asm.decode('utf-8').split("\n") if 's_code_end' not in x])
  print(asm)
  open("./compiled.s", "w").write(asm)

prog = HIPProgram(device.device, "wmma_rdna3", lib)

def timeit(fxn):
  st = time.perf_counter()
  et = fxn()
  ret = time.perf_counter() - st # NOTE: et doesn't contain the launch overhead
  print(f"{ret*1e6:.2f} us")
  return et

global_size=(1,1,1)
local_size=(32,1,1)
tm = min([timeit(lambda: prog(b, c, a, global_size=global_size, local_size=local_size, wait=True)) for _ in range(1)])
hipallocator.copyout(flat_mv(na.data),a)
na = na.reshape(N,N)
comp = nb.astype(np.float32) @ nc.astype(np.float32)
#print(f"{N*N:10d} {tm*1e6:9.2f} us, would be {FLOPS*1e-9/tm:9.2f} GFLOPS matmul, {BW*1e-9/tm:.2f} GB/s")
np.testing.assert_allclose(na, comp, atol=1e-2, rtol=1e-2)
