import ctypes
from tinygrad.codegen.kernel import LinearizerOptions
from tinygrad.device import Compiled, Compiler, MallocAllocator
from tinygrad.renderer.cstyle import HIPRenderer

class RemoteCompiler(Compiler):
  linearizer_opts = LinearizerOptions("HSA", has_tensor_cores=True, shared_max=65536)
  def __init__(self, arch:str):
    self.arch = arch
    super().__init__(f"compile_hip_{self.arch}")
  def render(self, name:str, uops) -> str: return HIPRenderer(name, uops)
  def compile(self, src:str) -> bytes:
      import http.client, urllib.parse
      headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
      conn = http.client.HTTPConnection("temps-mbp.home", 80)
      conn.request("POST", "/", urllib.parse.urlencode({'code': src}), headers)
      response = conn.getresponse()
      asm = response.read().decode()
      conn.close()
      return asm.encode("utf-8")

rhip = ctypes.CDLL("/Users/qazal/code/tinygrad/remu/target/release/libremu.dylib")
class RHIPProgram:
  def __init__(self, name:str, lib:bytes):
    self.name, self.lib = name, lib
  def __call__(self, *args, global_size, local_size, vals=(), wait=False):
    args = (*args, *vals)
    rhip.hipModuleLaunchKernel(self.lib, len(self.lib), *global_size, *local_size, 0, None, None,
                              len(args), (ctypes.c_void_p * len(args))(*[ctypes.cast(x, ctypes.c_void_p) for x in args]))

class RHIPDevice(Compiled):
  def __init__(self, device:str=""):
    self.device = int(device.split(":")[1]) if ":" in device else 0
    super().__init__(device, MallocAllocator, RemoteCompiler("gfx1100"), RHIPProgram)
