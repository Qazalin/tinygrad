import subprocess
from tinygrad.runtime.ops_hip import hip, check, ctypes
from tinygrad.helpers import to_char_p_p, get_bytes

def compile_hip(prg:str, arch="gfx1100") -> bytes:
  check(hip.hiprtcCreateProgram(ctypes.byref(prog := hip.hiprtcProgram()), prg.encode(), "<null>".encode(), 0, None, None))
  compile_options = [f'--offload-arch={arch}', '-I/opt/rocm/include']
  status = hip.hiprtcCompileProgram(prog, len(compile_options), to_char_p_p([o.encode() for o in compile_options]))
  if status != 0: raise RuntimeError(f"compile failed: {get_bytes(prog, hip.hiprtcGetProgramLogSize, hip.hiprtcGetProgramLog, check).decode()}")
  return get_bytes(prog, hip.hiprtcGetCodeSize, hip.hiprtcGetCode, check)
def get_asm(lib:bytes):
  asm = subprocess.check_output(["/opt/rocm/llvm/bin/llvm-objdump", '-d', '-'], input=lib)
  return '\n'.join([x for x in asm.decode('utf-8').split("\n") if 's_code_end' not in x])

lib = compile_hip(r"""
#include "hip/hip_runtime.h"
#include <hip/hip_common.h>
__global__ void kernel(float* val) {
    *(val+0) = 2+2;
}
""")
print(get_asm(lib))
