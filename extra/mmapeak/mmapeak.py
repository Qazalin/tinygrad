import os, pathlib

# TODO: there is a timing bug without this
os.environ["AMD_AQL"] = "1"

from tinygrad.device import Device
from tinygrad.runtime.support.compiler_amd import HIPCompiler
from tinygrad.runtime.ops_amd import AMDProgram

NUM_WORKGROUPS = 96
WAVE_SIZE = 32
NUM_WAVES = 2
FLOPS_PER_MATMUL = 16*16*16*2
INTERNAL_LOOP = 1_000_00
INSTRUCTIONS_PER_LOOP = 200
DIRECTIVE = ".amdhsa_wavefront_size32 1"

assemblyTemplate = (pathlib.Path(__file__).parent / "template.s").read_text()


def createInst(instruction, vgprIndices, dense=True, accum=False, extra="", **kwargs):
  if accum:
    instructions = instruction(v[0:vgprIndices[0]],
                               v[vgprIndices[1]:vgprIndices[2]],
                               v[vgprIndices[1]:vgprIndices[2]], 1, **kwargs)
  elif dense:
    instructions = instruction(v[0:vgprIndices[0]],
                               v[vgprIndices[1]:vgprIndices[2]],
                               v[vgprIndices[1]:vgprIndices[2]], 1)
  else:
    instructions = instruction(v[0:vgprIndices[0]],
                               v[vgprIndices[1]:vgprIndices[2]],
                               v[vgprIndices[3]:vgprIndices[4]],
                               v[vgprIndices[5]])
  return instructions

def launchBenchmark(inst, instruction, vgprIndices, dense=True, accum=False, extra="", **kwargs):
  if accum:
    instructions = "{} a[0:{}], v[{}:{}], v[{}:{}], 1{}\n".format(instruction, vgprIndices[0],
                                                                vgprIndices[1], vgprIndices[2],
                                                                vgprIndices[1], vgprIndices[2], extra)
  elif dense:
    instructions = "{} v[0:{}], v[{}:{}], v[{}:{}], 1\n".format(instruction, vgprIndices[0],
                                                                vgprIndices[1], vgprIndices[2],
                                                                vgprIndices[1], vgprIndices[2])
  else:
    instructions = "{} v[0:{}], v[{}:{}], v[{}:{}], v{}\n".format(instruction, vgprIndices[0],
                                                                  vgprIndices[1], vgprIndices[2],
                                                                  vgprIndices[3], vgprIndices[4],
                                                                  vgprIndices[5])
  from extra.assembly.amd.test.test_roundtrip import compile_asm
  ours = createInst(inst, vgprIndices, dense, accum, extra, **kwargs)
  llvm_disasm = instructions.rstrip()
  our_disasm = ours.disasm()
  #if llvm_disasm != our_disasm: print(f"DISASM DIFF:\nexisting={llvm_disasm}\nours={our_disasm}")
  our_bytes = ours.to_bytes()
  arch = ours.__class__.__module__.split(".")[-2]
  llvm_bytes = compile_asm(llvm_disasm, arch)
  if our_bytes != llvm_bytes:
    llvm_inst = ours.__class__.from_bytes(llvm_bytes)
    for k in ours._fields:
      lv = getattr(llvm_inst, k)
      ov = getattr(ours, k)
      if lv != ov: print(f"field {k}: llvm={lv} != ours={ov}")
    raise Exception(f"bytes don't match for {ours.op_name.lower()}")
  src = assemblyTemplate.replace("INTERNAL_LOOP", str(INTERNAL_LOOP)).replace("INSTRUCTION", instructions*INSTRUCTIONS_PER_LOOP)
  src = src.replace("DIRECTIVE", DIRECTIVE)
  lib = COMPILER.compile(src)
  fxn = AMDProgram(DEV, "matmul", lib)
  elapsed = min([fxn(global_size=(NUM_WORKGROUPS,1,1), local_size=(WAVE_SIZE*NUM_WAVES,1,1), wait=True) for _ in range(2)])
  FLOPs = FLOPS_PER_MATMUL * NUM_WAVES * NUM_WORKGROUPS * INTERNAL_LOOP * INSTRUCTIONS_PER_LOOP
  print(f"{instruction:<29} : {FLOPs/elapsed/10**12:.2f} T(FL)OPS")

if __name__=="__main__":
  DEVICENUM = os.getenv("DEVICENUM", "0")
  try:
    DEV = Device[Device.DEFAULT]
  except:
    raise RuntimeError("Error while initiating AMD device")

  COMPILER = HIPCompiler(DEV.arch)
  if DEV.arch in {'gfx1100', 'gfx1103', 'gfx1151'}:
    from extra.assembly.amd.autogen.rdna3.ins import *
    if DEV.arch == 'gfx1103': NUM_WORKGROUPS = 8
    if DEV.arch == 'gfx1151': NUM_WORKGROUPS = 32
    launchBenchmark(v_wmma_bf16_16x16x16_bf16, "v_wmma_bf16_16x16x16_bf16", (7,8,15))
    launchBenchmark(v_wmma_f16_16x16x16_f16, "v_wmma_f16_16x16x16_f16", (7,8,15))
    launchBenchmark(v_wmma_f32_16x16x16_bf16, "v_wmma_f32_16x16x16_bf16", (7,8,15))
    launchBenchmark(v_wmma_f32_16x16x16_f16, "v_wmma_f32_16x16x16_f16", (7,8,15))
    launchBenchmark(v_wmma_i32_16x16x16_iu4, "v_wmma_i32_16x16x16_iu4", (7,8,9))
    launchBenchmark(v_wmma_i32_16x16x16_iu8, "v_wmma_i32_16x16x16_iu8", (7,8,11))
  elif DEV.arch == 'gfx1201':
    from extra.assembly.amd.autogen.rdna4.ins import *
    NUM_WORKGROUPS = 64
    launchBenchmark(v_wmma_bf16_16x16x16_bf16, "v_wmma_bf16_16x16x16_bf16", (3,4,7))
    launchBenchmark(v_wmma_f16_16x16x16_f16, "v_wmma_f16_16x16x16_f16", (3,4,7))
    launchBenchmark(v_wmma_f32_16x16x16_bf16, "v_wmma_f32_16x16x16_bf16", (7,8,11))
    launchBenchmark(v_wmma_f32_16x16x16_f16, "v_wmma_f32_16x16x16_f16", (7,8,11))
    launchBenchmark(v_wmma_i32_16x16x16_iu4, "v_wmma_i32_16x16x16_iu4", (7,8,8))
    launchBenchmark(v_wmma_i32_16x16x16_iu8, "v_wmma_i32_16x16x16_iu8", (7,8,9))
    launchBenchmark(v_wmma_f32_16x16x16_fp8_fp8, "v_wmma_f32_16x16x16_fp8_fp8", (7,8,9))
    launchBenchmark(v_wmma_f32_16x16x16_fp8_bf8, "v_wmma_f32_16x16x16_fp8_bf8", (7,8,9))
    launchBenchmark(v_wmma_f32_16x16x16_bf8_fp8, "v_wmma_f32_16x16x16_bf8_fp8", (7,8,9))
    launchBenchmark(v_wmma_f32_16x16x16_bf8_bf8, "v_wmma_f32_16x16x16_bf8_bf8", (7,8,9))
    FLOPS_PER_MATMUL = 16*16*32*2
    launchBenchmark(v_wmma_i32_16x16x32_iu4, "v_wmma_i32_16X16X32_iu4", (7,8,9))
    launchBenchmark(v_swmmac_f32_16x16x32_f16, "v_swmmac_f32_16x16x32_f16", (7,8,11,12,19,20), False)
    launchBenchmark(v_swmmac_f32_16x16x32_bf16, "v_swmmac_f32_16x16x32_bf16", (7,8,11,12,19,20), False)
    launchBenchmark(v_swmmac_f16_16x16x32_f16, "v_swmmac_f16_16x16x32_f16", (3,4,7,8,15,16), False)
    launchBenchmark(v_swmmac_bf16_16x16x32_bf16, "v_swmmac_bf16_16x16x32_bf16", (3,4,7,8,15,16), False)
    launchBenchmark(v_swmmac_i32_16x16x32_iu8, "v_swmmac_i32_16x16x32_iu8", (7,8,9,10,13,14), False)
    launchBenchmark(v_swmmac_i32_16x16x32_iu4, "v_swmmac_i32_16x16x32_iu4", (7,8,8,9,10,11), False)
    launchBenchmark(v_swmmac_f32_16x16x32_fp8_fp8, "v_swmmac_f32_16x16x32_fp8_fp8", (7,8,9,10,13,14), False)
    launchBenchmark(v_swmmac_f32_16x16x32_fp8_bf8, "v_swmmac_f32_16x16x32_fp8_bf8", (7,8,9,10,13,14), False)
    launchBenchmark(v_swmmac_f32_16x16x32_bf8_fp8, "v_swmmac_f32_16x16x32_bf8_fp8", (7,8,9,10,13,14), False)
    launchBenchmark(v_swmmac_f32_16x16x32_bf8_bf8, "v_swmmac_f32_16x16x32_bf8_bf8", (7,8,9,10,13,14), False)
    FLOPS_PER_MATMUL = 16*16*64*2
    launchBenchmark(v_swmmac_i32_16x16x64_iu4, "v_swmmac_i32_16x16x64_iu4", (7,8,9,10,13,14), False)
  elif DEV.arch == 'gfx950':
    from extra.assembly.amd.autogen.cdna.ins import *
    DIRECTIVE = ".amdhsa_accum_offset 4"
    NUM_WORKGROUPS = 256
    WAVE_SIZE = 64
    NUM_WAVES = 4
    launchBenchmark(v_mfma_f32_16x16x16_f16, "v_mfma_f32_16x16x16_f16", (3,0,1), accum=True)
    launchBenchmark(v_mfma_f32_16x16x16_bf16, "v_mfma_f32_16x16x16_bf16", (3,0,1), accum=True)
    FLOPS_PER_MATMUL = 16*16*32*2
    launchBenchmark(v_mfma_f32_16x16x32_f16, "v_mfma_f32_16x16x32_f16", (3,0,3), accum=True)
    launchBenchmark(v_mfma_f32_16x16x32_bf16, "v_mfma_f32_16x16x32_bf16", (3,0,3), accum=True)
    FLOPS_PER_MATMUL = 16*16*128*2
    launchBenchmark(v_mfma_f32_16x16x128_f8f6f4, "v_mfma_f32_16x16x128_f8f6f4", (3,0,7), accum=True) # fp8
    launchBenchmark(v_mfma_f32_16x16x128_f8f6f4, "v_mfma_f32_16x16x128_f8f6f4", (3,0,5), accum=True, extra=", cbsz:2 blgp:2", neg=2, neg_hi=2) # fp6
    launchBenchmark(v_mfma_f32_16x16x128_f8f6f4, "v_mfma_f32_16x16x128_f8f6f4", (3,0,3), accum=True, extra=", cbsz:4 blgp:4", neg=4, neg_hi=4) # fp4
  else:
    raise RuntimeError(f"arch {DEV.arch} not supported.")
