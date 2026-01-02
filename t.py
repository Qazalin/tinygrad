import pickle
from extra.sqtt.roc import decode
from tinygrad.device import ProfileDeviceEvent, ProfileProgramEvent
from tinygrad.runtime.ops_amd import ProfileSQTTEvent
from tinygrad.helpers import temp, unwrap
from tinygrad.viz.serve import llvm_disasm

with open(temp("profile.pkl", append_user=True), "rb") as f:
  profile = pickle.load(f)

device_props = {}
p = None
sqtt = []
for e in profile:
  if isinstance(e, ProfileDeviceEvent) and e.device.startswith("AMD"): device_props[e.device] = e.props
  if isinstance(e, ProfileProgramEvent) and e.name == "gemm": p = e
  if isinstance(e, ProfileSQTTEvent) and e.kern == "gemm": sqtt.append(e)

"""
base = unwrap(p.base)
disasm = {addr+base:inst_disasm for addr,inst_disasm in llvm_disasm(device_props[p.device]["gfx_target_version"], unwrap(p.lib)).items()}
r = decode(sqtt, {p.name:disasm})
inst = r.inst_execs[('gemm', 1)]
insts = list(inst[0].unpack_insts())
print(len(insts))
print(p.base)
"""

from tinygrad.runtime.support.elf import elf_loader
_, sections, __ = elf_loader(p.lib)
for s in sections:
  print(s.name, s.header, f"{s.header.sh_addr:0X}")

#with open("/tmp/test", "wb") as f: f.write(p.lib)
