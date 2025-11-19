from tinygrad.helpers import system
from tinygrad import Device

dev = Device["AMD"]

with open("/tmp/test", "rb") as f: lib = f.read()
ret = system("llvm-objdump -dr --no-show-raw-insn --triple=amdgcn-amd-amdhsa --mcpu=gfx1100 -", input=lib)
with open("/tmp/test.s", "w") as f: f.write(ret)
