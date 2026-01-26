#!/usr/bin/env python3
"""Debug ELF differences between old and new mmapeak approaches."""
import os, pathlib, struct

os.environ["AMD_AQL"] = "1"

from tinygrad.runtime.support.compiler_amd import HIPCompiler
from tinygrad.runtime.support.elf import elf_loader
from extra.assembly.amd.dsl import Reg, s

INTERNAL_LOOP = 100
INSTRUCTIONS_PER_LOOP = 10

template_old = (pathlib.Path(__file__).parent / "template_old.s").read_text()
template_new = (pathlib.Path(__file__).parent / "template.s").read_text()

def build_loop(mma_inst, loop_insts) -> bytes:
  mma_bytes = b"".join([mma_inst.to_bytes() for _ in range(INSTRUCTIONS_PER_LOOP)])
  s_sub, s_cmp, s_branch, s_end = loop_insts
  loop_size = len(mma_bytes) + s_sub.size() + s_cmp.size() + s_branch.size()
  branch_offset = -(loop_size // 4)
  s_branch = type(s_branch)(s_branch.op, simm16=branch_offset & 0xFFFF)
  return mma_bytes + s_sub.to_bytes() + s_cmp.to_bytes() + s_branch.to_bytes() + s_end.to_bytes()

def parse_kd(data: bytes) -> dict:
  """Parse 64-byte kernel descriptor."""
  if len(data) < 64:
    return {"error": f"KD too small: {len(data)} bytes"}
  return {
    "GROUP_SEGMENT_FIXED_SIZE": struct.unpack("<I", data[0:4])[0],
    "PRIVATE_SEGMENT_FIXED_SIZE": struct.unpack("<I", data[4:8])[0],
    "KERNARG_SIZE": struct.unpack("<I", data[8:12])[0],
    "reserved_12": struct.unpack("<I", data[12:16])[0],
    "KERNEL_CODE_ENTRY_BYTE_OFFSET": struct.unpack("<q", data[16:24])[0],
    "reserved_24": data[24:44].hex(),
    "COMPUTE_PGM_RSRC3": struct.unpack("<I", data[44:48])[0],
    "COMPUTE_PGM_RSRC1": struct.unpack("<I", data[48:52])[0],
    "COMPUTE_PGM_RSRC2": struct.unpack("<I", data[52:56])[0],
    "kernel_code_properties": struct.unpack("<H", data[56:58])[0],
    "kernarg_preload": struct.unpack("<H", data[58:60])[0],
    "reserved_60": struct.unpack("<I", data[60:64])[0],
  }

def compare_sections(lib_old: bytes, lib_new: bytes):
  _, secs_old, _ = elf_loader(lib_old)
  _, secs_new, _ = elf_loader(lib_new)

  sec_old_map = {s.name: s for s in secs_old}
  sec_new_map = {s.name: s for s in secs_new}

  all_names = sorted(set(sec_old_map.keys()) | set(sec_new_map.keys()))

  print("\n=== Section comparison ===")
  for name in all_names:
    old = sec_old_map.get(name)
    new = sec_new_map.get(name)
    if old is None:
      print(f"  {name}: only in NEW ({len(new.content)} bytes)")
    elif new is None:
      print(f"  {name}: only in OLD ({len(old.content)} bytes)")
    elif old.content == new.content:
      print(f"  {name}: identical ({len(old.content)} bytes)")
    else:
      print(f"  {name}: DIFFERS (old={len(old.content)}, new={len(new.content)} bytes)")
      # Find first diff
      for i, (a, b) in enumerate(zip(old.content, new.content)):
        if a != b:
          print(f"    First diff at offset {i:#x}: old={a:#04x} new={b:#04x}")
          print(f"    Old: {old.content[max(0,i-4):i+12].hex()}")
          print(f"    New: {new.content[max(0,i-4):i+12].hex()}")
          break
      if len(old.content) != len(new.content):
        print(f"    Size diff: {len(old.content)} vs {len(new.content)}")

      # If it's .rodata, parse kernel descriptor
      if name == ".rodata":
        print("\n    === Kernel Descriptor (OLD) ===")
        kd_old = parse_kd(old.content)
        for k, v in kd_old.items():
          print(f"      {k}: {v:#x}" if isinstance(v, int) else f"      {k}: {v}")

        print("\n    === Kernel Descriptor (NEW) ===")
        kd_new = parse_kd(new.content)
        for k, v in kd_new.items():
          print(f"      {k}: {v:#x}" if isinstance(v, int) else f"      {k}: {v}")

        print("\n    === KD Differences ===")
        for k in kd_old:
          if kd_old[k] != kd_new[k]:
            print(f"      {k}: old={kd_old[k]:#x if isinstance(kd_old[k], int) else kd_old[k]} new={kd_new[k]:#x if isinstance(kd_new[k], int) else kd_new[k]}")

if __name__ == "__main__":
  from extra.assembly.amd.autogen.rdna4.ins import v, v_wmma_bf16_16x16x16_bf16, s_sub_co_u32, s_cmp_lg_i32, s_cbranch_scc1, s_endpgm, s_mov_b32

  compiler = HIPCompiler("gfx1200")
  inst = v_wmma_bf16_16x16x16_bf16(v[0:3], v[4:7], v[4:7], 1)
  loop_insts = [s_sub_co_u32(s[1], s[1], 1), s_cmp_lg_i32(s[1], s[2]), s_cbranch_scc1(simm16=0), s_endpgm()]

  vgprs = set()
  for n, _ in inst._fields:
    if isinstance(val := getattr(inst, n), Reg) and val.offset >= v.offset:
      vgprs |= {val.offset + i for i in range(val.sz)}
  vgpr_count = str(max(vgprs) + 1)

  # OLD
  inst_bytes = b"".join([inst.to_bytes() for _ in range(INSTRUCTIONS_PER_LOOP)])
  inst_hex = "\n".join("  .byte " + ",".join(f"0x{b:02x}" for b in inst_bytes[i:i+16]) for i in range(0, len(inst_bytes), 16)) + "\n"
  src_old = template_old.replace("INTERNAL_LOOP", str(INTERNAL_LOOP)).replace("INSTRUCTION", inst_hex)
  src_old = src_old.replace("VGPR_COUNT", vgpr_count).replace("DIRECTIVE", ".amdhsa_wavefront_size32 1")
  lib_old = compiler.compile(src_old)

  # NEW
  loop_bytes = build_loop(inst, loop_insts)
  loop_hex = "\n".join("  .byte " + ",".join(f"0x{b:02x}" for b in loop_bytes[i:i+16]) for i in range(0, len(loop_bytes), 16)) + "\n"
  preamble = s_mov_b32(s[1], INTERNAL_LOOP).to_bytes() + s_mov_b32(s[2], 0).to_bytes()
  preamble_hex = "  .byte " + ",".join(f"0x{b:02x}" for b in preamble) + "\n"
  src_new = template_new.replace("PREAMBLE", preamble_hex).replace("LOOP", loop_hex)
  src_new = src_new.replace("VGPR_COUNT", vgpr_count).replace("DIRECTIVE", ".amdhsa_wavefront_size32 1")
  lib_new = compiler.compile(src_new)

  print(f"lib_old size: {len(lib_old)}, lib_new size: {len(lib_new)}")
  print(f"libs equal: {lib_old == lib_new}")

  compare_sections(lib_old, lib_new)
