import os, pathlib

# TODO: there is a timing bug without this
os.environ["AMD_AQL"] = "1"

from tinygrad.device import Device
from tinygrad.runtime.support.compiler_amd import HIPCompiler
from tinygrad.runtime.support.elf import elf_loader
from extra.assembly.amd.dsl import Reg, s, v, Kernel

NUM_WORKGROUPS = 96
WAVE_SIZE = 32
NUM_WAVES = 2
FLOPS_PER_MATMUL = 16*16*16*2
INTERNAL_LOOP = 1_000_00
INSTRUCTIONS_PER_LOOP = 200
DIRECTIVE = ".amdhsa_wavefront_size32 1"

assemblyTemplate = (pathlib.Path(__file__).parent / "template.s").read_text()
assemblyTemplateOld = (pathlib.Path(__file__).parent / "template_old.s").read_text()

def verify_elf_match(lib_old: bytes, lib_new: bytes, inst_name: str):
  """Verify ELF sections match, excluding symbol/string tables (label names can differ)."""
  _, secs_old, _ = elf_loader(lib_old)
  _, secs_new, _ = elf_loader(lib_new)
  skip = {'.symtab', '.strtab', '.relro_padding'}
  for sec in secs_old:
    if sec.name in skip: continue
    sec_new = next((s for s in secs_new if s.name == sec.name), None)
    assert sec_new is not None, f"{inst_name}: section {sec.name} missing in new"
    assert sec.content == sec_new.content, f"{inst_name}: section {sec.name} mismatch"

def to_hex(data: bytes) -> str:
  return "\n".join("  .byte " + ",".join(f"0x{b:02x}" for b in data[i:i+16]) for i in range(0, len(data), 16)) + "\n"

def launchBenchmark(instruction, vgprIndices, dense=True, accum=False, **kwargs):
  if accum:
    inst = instruction(v[0:vgprIndices[0]], v[vgprIndices[1]:vgprIndices[2]], v[vgprIndices[1]:vgprIndices[2]], 1, acc_cd=1, **kwargs)
  elif dense:
    inst = instruction(v[0:vgprIndices[0]], v[vgprIndices[1]:vgprIndices[2]], v[vgprIndices[1]:vgprIndices[2]], 1)
  else:
    inst = instruction(v[0:vgprIndices[0]], v[vgprIndices[1]:vgprIndices[2]], v[vgprIndices[3]:vgprIndices[4]], v[vgprIndices[5]])
  vgprs: set = set()
  for n, _ in inst._fields:
    if isinstance(val := getattr(inst, n), Reg) and val.offset >= v.offset: vgprs |= {val.offset + i for i in range(val.sz)}
  vgpr_count = str(max(vgprs) + 1)

  # OLD: use template_old.s with assembler mnemonics
  inst_hex = to_hex(b"".join([inst.to_bytes() for _ in range(INSTRUCTIONS_PER_LOOP)]))
  src_old = assemblyTemplateOld.replace("INTERNAL_LOOP", str(INTERNAL_LOOP)).replace("INSTRUCTION", inst_hex)
  src_old = src_old.replace("VGPR_COUNT", vgpr_count).replace("DIRECTIVE", DIRECTIVE)
  lib_old = COMPILER.compile(src_old)

  # NEW: use Kernel class with emit_range
  k = Kernel()
  k.emit_range(inst, n=INSTRUCTIONS_PER_LOOP, loop_count=INTERNAL_LOOP)
  src_new = assemblyTemplate.replace("KERNEL", to_hex(k.to_bytes()))
  src_new = src_new.replace("VGPR_COUNT", vgpr_count).replace("DIRECTIVE", DIRECTIVE)
  lib_new = COMPILER.compile(src_new)

  # Verify ELF sections match (excluding symbol/string tables)
  verify_elf_match(lib_old, lib_new, inst.op_name)

  fxn = DEV.runtime("matmul", lib_new)
  elapsed = min([fxn(global_size=(NUM_WORKGROUPS,1,1), local_size=(WAVE_SIZE*NUM_WAVES,1,1), wait=True) for _ in range(2)])
  FLOPs = FLOPS_PER_MATMUL * NUM_WAVES * NUM_WORKGROUPS * INTERNAL_LOOP * INSTRUCTIONS_PER_LOOP
  print(f"{inst.op_name.lower():<29} : {FLOPs/elapsed/10**12:.2f} T(FL)OPS")

if __name__=="__main__":
  DEV = Device[Device.DEFAULT]
  arch = DEV.renderer.arch

  COMPILER = HIPCompiler(arch)
  if arch in {'gfx1100', 'gfx1103', 'gfx1151'}:
    from extra.assembly.amd.autogen.rdna3.ins import *
    if arch == 'gfx1103': NUM_WORKGROUPS = 8
    if arch == 'gfx1151': NUM_WORKGROUPS = 32
    launchBenchmark(v_wmma_bf16_16x16x16_bf16, (7,8,15))
    launchBenchmark(v_wmma_f16_16x16x16_f16, (7,8,15))
    launchBenchmark(v_wmma_f32_16x16x16_bf16, (7,8,15))
    launchBenchmark(v_wmma_f32_16x16x16_f16, (7,8,15))
    launchBenchmark(v_wmma_i32_16x16x16_iu4, (7,8,9))
    launchBenchmark(v_wmma_i32_16x16x16_iu8, (7,8,11))
  elif arch in {'gfx1200', 'gfx1201'}:
    from extra.assembly.amd.autogen.rdna4.ins import *
    NUM_WORKGROUPS = 64
    launchBenchmark(v_wmma_bf16_16x16x16_bf16, (3,4,7))
    launchBenchmark(v_wmma_f16_16x16x16_f16, (3,4,7))
    launchBenchmark(v_wmma_f32_16x16x16_bf16, (7,8,11))
    launchBenchmark(v_wmma_f32_16x16x16_f16, (7,8,11))
    launchBenchmark(v_wmma_i32_16x16x16_iu4, (7,8,8))
    launchBenchmark(v_wmma_i32_16x16x16_iu8, (7,8,9))
    launchBenchmark(v_wmma_f32_16x16x16_fp8_fp8, (7,8,9))
    launchBenchmark(v_wmma_f32_16x16x16_fp8_bf8, (7,8,9))
    launchBenchmark(v_wmma_f32_16x16x16_bf8_fp8, (7,8,9))
    launchBenchmark(v_wmma_f32_16x16x16_bf8_bf8, (7,8,9))
    FLOPS_PER_MATMUL = 16*16*32*2
    launchBenchmark(v_wmma_i32_16x16x32_iu4, (7,8,9))
    launchBenchmark(v_swmmac_f32_16x16x32_f16, (7,8,11,12,19,20), False)
    launchBenchmark(v_swmmac_f32_16x16x32_bf16, (7,8,11,12,19,20), False)
    launchBenchmark(v_swmmac_f16_16x16x32_f16, (3,4,7,8,15,16), False)
    launchBenchmark(v_swmmac_bf16_16x16x32_bf16, (3,4,7,8,15,16), False)
    launchBenchmark(v_swmmac_i32_16x16x32_iu8, (7,8,9,10,13,14), False)
    launchBenchmark(v_swmmac_i32_16x16x32_iu4, (7,8,8,9,10,11), False)
    launchBenchmark(v_swmmac_f32_16x16x32_fp8_fp8, (7,8,9,10,13,14), False)
    launchBenchmark(v_swmmac_f32_16x16x32_fp8_bf8, (7,8,9,10,13,14), False)
    launchBenchmark(v_swmmac_f32_16x16x32_bf8_fp8, (7,8,9,10,13,14), False)
    launchBenchmark(v_swmmac_f32_16x16x32_bf8_bf8, (7,8,9,10,13,14), False)
    FLOPS_PER_MATMUL = 16*16*64*2
    launchBenchmark(v_swmmac_i32_16x16x64_iu4, (7,8,9,10,13,14), False)
  elif arch == 'gfx950':
    from extra.assembly.amd.autogen.cdna.ins import *
    DIRECTIVE = ".amdhsa_accum_offset 4"
    NUM_WORKGROUPS = 256
    WAVE_SIZE = 64
    NUM_WAVES = 4
    launchBenchmark(v_mfma_f32_16x16x16_f16, (3,0,1), accum=True)
    launchBenchmark(v_mfma_f32_16x16x16_bf16, (3,0,1), accum=True)
    FLOPS_PER_MATMUL = 16*16*32*2
    launchBenchmark(v_mfma_f32_16x16x32_f16, (3,0,3), accum=True)
    launchBenchmark(v_mfma_f32_16x16x32_bf16, (3,0,3), accum=True)
    FLOPS_PER_MATMUL = 16*16*128*2
    launchBenchmark(v_mfma_f32_16x16x128_f8f6f4, (3,0,7), accum=True) # fp8
    launchBenchmark(v_mfma_f32_16x16x128_f8f6f4, (3,0,5), accum=True, cbsz=2, blgp=2) # fp6
    launchBenchmark(v_mfma_f32_16x16x128_f8f6f4, (3,0,3), accum=True, cbsz=4, blgp=4) # fp4
  else:
    raise RuntimeError(f"arch {arch} not supported.")
