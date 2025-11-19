#!/usr/bin/env python3
import argparse
import subprocess
import sys
import re

def run_objdump(objdump, mcpu, binary):
  cmd = [
    objdump,
    "-d",
    "--mcpu=" + mcpu,
    "--no-show-raw-insn",
    "--no-leading-addr",
    binary,
  ]
  try:
    return subprocess.check_output(cmd, text=True)
  except subprocess.CalledProcessError as e:
    sys.stderr.write("error running llvm-objdump: %s\n" % e)
    sys.exit(1)

def to_asm(disasm):
  lines = disasm.splitlines()
  out = []
  out.append(".text")
  out.append(".amdgpu_target \"amdgcn-amd-amdhsa\"")
  out.append("")

  # patterns for label lines from llvm-objdump
  addr_sym_re = re.compile(r"^[0-9a-fA-F]+\s+<([^>]+)>:$")
  plain_sym_re = re.compile(r"^([A-Za-z0-9_.$]+):$")

  for raw in lines:
    s = raw.strip()

    # skip section headers like: "Disassembly of section .text:"
    if s.startswith("Disassembly of section"):
      continue
    if not s:
      out.append("")
      continue

    m = addr_sym_re.match(s)
    if not m:
      m = plain_sym_re.match(s)

    if m:
      sym = m.group(1)
      out.append("")
      out.append(".p2align 8")
      out.append(".amdgpu_hsa_kernel %s" % sym)
      out.append("%s:" % sym)
      continue

    # keep instruction / comment lines as-is
    out.append(raw)

  # trim trailing blank lines
  while out and not out[-1].strip():
    out.pop()
  return "\n".join(out) + "\n"

def main():
  p = argparse.ArgumentParser(description="Convert AMDGPU ELF to patchable .s")
  p.add_argument("binary", help="input AMDGPU ELF / HSA code object")
  p.add_argument("--objdump", default="/opt/rocm/llvm/bin/llvm-objdump",
                 help="path to llvm-objdump (default: %(default)s)")
  p.add_argument("--mcpu", default="gfx1100",
                 help="AMDGPU mcpu (default: %(default)s)")
  args = p.parse_args()

  disasm = run_objdump(args.objdump, args.mcpu, args.binary)
  asm = to_asm(disasm)
  sys.stdout.write(asm)

if __name__ == "__main__":
  main()

