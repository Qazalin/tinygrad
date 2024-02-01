import ctypes
from tinygrad.codegen.kernel import LinearizerOptions
from tinygrad.device import Compiled, Compiler, MallocAllocator
from tinygrad.renderer.cstyle import HIPRenderer

def compile_hip(prg:str, arch="gfx1100") -> bytes:
  """
  import http.client, urllib.parse
  params = urllib.parse.urlencode({'code': prg})
  headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
  conn = http.client.HTTPConnection("temps-mbp.home", 80)
  conn.request("POST", "/", params, headers)
  response = conn.getresponse()
  asm = response.read().decode()
  conn.close()
  return asm.encode("utf-8")
  """
  asm = open("/Users/qazal/code/tinygrad/tinygrad/experiments/a1.s").read()
  return asm.encode("utf-8")

class HIPCompiler(Compiler):
  linearizer_opts = LinearizerOptions("HIP")
  def __init__(self, arch:str):
    self.arch = arch
    super().__init__(f"compile_hip_{self.arch}")
  def render(self, name:str, uops) -> str: return HIPRenderer(name, uops)
  def compile(self, src:str) -> bytes: return compile_hip(src, self.arch)


hip = ctypes.CDLL("/Users/qazal/code/tinygrad/remu/target/release/libremu.dylib") # type: ignore[assignment]

class HIPProgram:
  def __init__(self, device, name:str, lib:bytes):
    self.name, self.lib = name, lib
  def __call__(self, *args, global_size, local_size, vals=(), wait=False):
    args = (*args, *vals)
    hip.hipModuleLaunchKernel(self.lib, len(self.lib), *global_size, *local_size, 0, None, None,
                              len(args), (ctypes.c_void_p * len(args))(*[ctypes.cast(x, ctypes.c_void_p) for x in args]))

class HIPDevice(Compiled):
  def __init__(self, device=""):
    self.device = ""
    super().__init__(device, MallocAllocator, HIPCompiler("gfx1100"), HIPProgram)
