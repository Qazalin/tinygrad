import ctypes, functools, subprocess
from typing import Any, Tuple, TypeVar
from tinygrad.helpers import DEBUG, getenv, from_mv, init_c_var
from tinygrad.device import Compiled, LRUAllocator
from tinygrad.renderer.cstyle import HIPRenderer
from tinygrad.codegen.kernel import LinearizerOptions

HIPCPU = getenv("HIPCPU")

hip: Any = ctypes.CDLL("/Users/qazal/code/tinygrad/remu/target/release/libremu.dylib")

if HIPCPU:
  # TODO this whole section will be removed, the api should ideally match 1:1
  hip.hipSetDevice = lambda x: x
  hip.hipModuleUnload = lambda x: x
  hip.hipDeviceptr_t = lambda: ctypes.c_void_p(None)
  hip.hipModule_t = lambda: ctypes.c_void_p(None)
  hip.hipDeviceSynchronize = lambda: 0
  hip.hipModuleLaunchKernel.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint, ctypes.c_void_p]  # noqa: E501
  hip.hipMemcpyHostToDevice = 1
  hip.hipMemcpyDeviceToHost = 2

def compile_hip(prg) -> bytes: return open("/tmp/compiled.s", "r").read().encode("utf-8")

class HIPProgram:
  def __init__(self, device:int, name:str, lib:bytes):
    self.device, self.name, self.lib = device, name, lib

    if DEBUG >= 6:
      asm = subprocess.check_output(["/opt/rocm/llvm/bin/llvm-objdump", '-d', '-'], input=lib)
      print('\n'.join([x for x in asm.decode('utf-8').split("\n") if 's_code_end' not in x]))

    self.prg = lib

  def __del__(self):
    pass

  def __call__(self, *args, global_size:Tuple[int,int,int], local_size:Tuple[int,int,int], vals:Tuple[int, ...]=(), wait=False):
    args = (*args, *vals)
    return hip.hipModuleLaunchKernel(self.prg, len(self.prg), *global_size, *local_size, 0, None, None, len(args), (ctypes.c_void_p * len(args))(*[ctypes.cast(x, ctypes.c_void_p) for x in args]))

T = TypeVar("T")
class HIPAllocator(LRUAllocator):
  def __init__(self, device):
    self.device = device
    super().__init__()
  def _alloc(self, size:int):
    return init_c_var(hip.hipDeviceptr_t(), lambda x: hip.hipMalloc(ctypes.byref(x), size))
  def _free(self, opaque:T): hip.hipFree(opaque)
  def copyin(self, dest:T, src: memoryview):
    hip.hipMemcpy(dest, from_mv(src), len(src), hip.hipMemcpyHostToDevice)
  def copyout(self, dest:memoryview, src:T):
    hip.hipMemcpy(from_mv(dest), src, len(dest), hip.hipMemcpyDeviceToHost)
  def transfer(self, dest:T, src:T, sz:int):
    hip.hipMemcpy(dest, src, sz, hip.hipMemcpyDeviceToDevice)

class HIPDevice(Compiled):
  def __init__(self, device:str=""):
    self.device = int(device.split(":")[1]) if ":" in device else 0
    super().__init__(HIPAllocator(self.device), LinearizerOptions(device="HIP"), HIPRenderer, compile_hip, functools.partial(HIPProgram, self.device))
  def synchronize(self):
    pass
