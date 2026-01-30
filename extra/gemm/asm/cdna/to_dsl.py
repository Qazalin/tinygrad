import pathlib, re
from tinygrad.runtime.support.elf import elf_loader
from tinygrad.runtime.support.compiler_amd import HIPCompiler
from extra.assembly.amd import decode_inst
from extra.assembly.amd.autogen.cdna.ins import *
from tinygrad.helpers import getenv

class Kernel:
  def __init__(self): self.instructions, self.labels, self.pos, self._patched = [], {}, 0, False
  def label(self, name): self.labels[name] = self.pos

  def emit(self, inst, target=None):
    self.instructions.append(inst)
    inst._target, inst._pos = target, self.pos
    self.pos += inst.size()
    return inst

  def _patch_branches(self):
    if self._patched: return
    for inst in self.instructions:
      if inst._target is None: continue
      offset_dwords = (self.labels[inst._target] - inst._pos - inst.size()) // 4
      inst.simm16 = offset_dwords
    self._patched = True

  def to_asm(self) -> str:
    self._patch_branches()
    import pathlib
    rodata = (pathlib.Path(__file__).parent/"rodata.s").read_text()
    kernel_s = (pathlib.Path(__file__).parent/"kernel.s").read_text()
    return rodata.replace("INSTRUCTIONS", kernel_s)

  def to_bytes(self) -> bytes:
    self._patch_branches()
    return b"".join(inst.to_bytes() for inst in self.instructions)

# parse kernel.s to extract labels and branch targets
kernel_s = (pathlib.Path(__file__).parent/"kernel.s").read_text()
labels_at_line: dict[int, list[str]] = {}  # inst_idx -> [label_names]
branch_targets: dict[int, str] = {}  # inst_idx -> target_label
inst_line = 0
for line in kernel_s.splitlines():
  line = line.split("//")[0].strip()
  if not line: continue
  if line.endswith(":"):
    labels_at_line.setdefault(inst_line, []).append(line[:-1])
  else:
    # check for branch instruction with label target
    match = re.match(r"s_(branch|cbranch_\w+)\s+(label_\w+)", line)
    if match: branch_targets[inst_line] = match.group(2)
    inst_line += 1

# compile and decode
src = (pathlib.Path(__file__).parent/"rodata.s").read_text().replace("INSTRUCTIONS", kernel_s)
lib = HIPCompiler("gfx950").compile(src)
image, sections, _ = elf_loader(lib)
text = next((sh for sh in sections if sh.name == ".text"), None)
text_off, text_size = text.header.sh_addr, text.header.sh_size

# build kernel with labels and instructions
kernel = Kernel()
offset, inst_idx = text_off, 0
while offset < text_off + text_size:
  for lbl in labels_at_line.get(inst_idx, []):
    kernel.label(lbl)
  inst = decode_inst(image[offset:], "cdna")
  target = branch_targets.get(inst_idx)
  kernel.emit(inst, target=target)
  offset += inst.size()
  inst_idx += 1

# generate asm.py
dst = pathlib.Path(__file__).parent/"asm.py"
if getenv("WRITE", 1):
  lines = ["import pathlib", "from extra.assembly.amd.autogen.cdna.ins import *", ""]
  lines.append("class Kernel:")
  lines.append("  def __init__(self): self.instructions, self.labels, self.pos, self._patched = [], {}, 0, False")
  lines.append("  def label(self, name): self.labels[name] = self.pos")
  lines.append("  def emit(self, inst, target=None):")
  lines.append("    self.instructions.append(inst)")
  lines.append("    inst._target, inst._pos = target, self.pos")
  lines.append("    self.pos += inst.size()")
  lines.append("    return inst")
  lines.append("  def _patch_branches(self):")
  lines.append("    if self._patched: return")
  lines.append("    for inst in self.instructions:")
  lines.append("      if inst._target is None: continue")
  lines.append("      offset_dwords = (self.labels[inst._target] - inst._pos - inst.size()) // 4")
  lines.append("      inst.simm16 = offset_dwords")
  lines.append("    self._patched = True")
  lines.append("  def to_asm(self) -> str:")
  lines.append("    self._patch_branches()")
  lines.append("    rodata = (pathlib.Path(__file__).parent/'rodata.s').read_text()")
  lines.append("    kernel_s = (pathlib.Path(__file__).parent/'kernel.s').read_text()")
  lines.append("    return rodata.replace('INSTRUCTIONS', kernel_s)")
  lines.append("  def to_bytes(self) -> bytes:")
  lines.append("    self._patch_branches()")
  lines.append("    return b''.join(inst.to_bytes() for inst in self.instructions)")
  lines.append("")
  lines.append("k = Kernel()")
  for i, inst in enumerate(kernel.instructions):
    for lbl in labels_at_line.get(i, []):
      lines.append(f"k.label({lbl!r})")
    target = branch_targets.get(i)
    if target:
      # emit branch without simm16 - to_asm() will patch it
      op_name = inst.op.name.lower()
      lines.append(f"k.emit({op_name}(), target={target!r})")
    else:
      lines.append(f"k.emit({repr(inst)})")
  with open(dst, "w") as f: f.write("\n".join(lines))

# load generated asm.py and patch branches
py_txt = dst.read_text()
exec(py_txt, globals())
k._patch_branches()

# roundtrip test: verify re-encoding matches original bytes
print(f"Testing roundtrip for {len(k.instructions)} instructions...")
offset = text_off
passed, failed = 0, 0
failures: list[str] = []
for i, inst in enumerate(k.instructions):
  orig_bytes = image[offset:offset+inst.size()]
  reencoded = inst.to_bytes()
  if reencoded == orig_bytes:
    passed += 1
  else:
    failed += 1
    failures.append(f"  [{i}] {inst.disasm()}: orig={orig_bytes.hex()} reenc={reencoded.hex()}")
  offset += inst.size()

print(f"Roundtrip: {passed} passed, {failed} failed")
if failures:
  print("Failures:")
  for f in failures[:20]: print(f)
  if len(failures) > 20: print(f"  ... and {len(failures) - 20} more")
  raise AssertionError(f"{failed} instructions failed roundtrip")
