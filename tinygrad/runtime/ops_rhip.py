import ctypes
from tinygrad.device import Compiler, Compiled, MallocAllocator
from tinygrad.renderer.cstyle import AMDRenderer

class AMDCompiler(Compiler):
  def __init__(self, arch:str):
    self.arch = arch
    super().__init__(f"compile_hip_{self.arch}")
  def compile(self, src:str) -> bytes:
    import http.client, urllib.parse
    params = urllib.parse.urlencode({'code': src})
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
    conn = http.client.HTTPConnection("temps-mbp.home", 80)
    conn.request("POST", "/", params, headers)
    response = conn.getresponse()
    asm = response.read().decode()
    conn.close()
    return asm.encode("utf-8")

rhip = ctypes.CDLL("/Users/qazal/code/remu/target/release/libremu.dylib")
class RHIPProgram:
  def __init__(self, name:str, lib:bytes):
    self.name, self.lib = name, lib
  def __call__(self, *args, global_size, local_size, vals=(), wait=False):
    args = (*args, *vals)
    err = rhip.run_asm(self.lib, len(self.lib), *global_size, *local_size, (ctypes.c_void_p * len(args))(*[ctypes.cast(x, ctypes.c_void_p) for x in args]))
    if err: raise RuntimeError("remu does not support the new instruction intorduced in this kernel")

class RHIPDevice(Compiled):
  def __init__(self, device:str=""):
    self.device = int(device.split(":")[1]) if ":" in device else 0
    super().__init__(device, MallocAllocator, AMDRenderer(), AMDCompiler("gfx1100"), RHIPProgram)
