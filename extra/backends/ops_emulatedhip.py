import ctypes, functools
from tinygrad.device import Compiled, MallocAllocator
from tinygrad.renderer.cstyle import HIPRenderer
from tinygrad.codegen.kernel import LinearizerOptions
from tinygrad.runtime.ops_hip import compile_hip

hip = ctypes.CDLL("/Users/qazal/code/tinygrad/remu/target/release/libremu.dylib")

class EmulatedHIPProgram:
  def __init__(self, name:str, lib:bytes):
    self.name, self.lib = name, lib
  def __call__(self, *args, global_size, local_size, vals=(), wait=False):
    hip.hipModuleLaunchKernel(self.lib, len(self.lib), *global_size, *local_size, 0, None, None, len(args), (ctypes.c_void_p * len(args))(*[ctypes.cast(x, ctypes.c_void_p) for x in args]))

class EmulatedHIPDevice(Compiled):
  def __init__(self, device=""):
    self.arch = "gfx1100"
    super().__init__(device, MallocAllocator, LinearizerOptions("HIP"), HIPRenderer, functools.partial(compile_hip,arch=self.arch), f"compile_hip_{self.arch}", EmulatedHIPProgram)
