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

def launchBenchmark(instruction, vgprIndices, dense=True, accum=False, **kwargs):
  if accum:
    inst = instruction(v[0:vgprIndices[0]], v[vgprIndices[1]:vgprIndices[2]], v[vgprIndices[1]:vgprIndices[2]], 1, clmp=1, opsel_hi=0, **kwargs)
  elif dense:
    inst = instruction(v[0:vgprIndices[0]], v[vgprIndices[1]:vgprIndices[2]], v[vgprIndices[1]:vgprIndices[2]], 1)
  else:
    inst = instruction(v[0:vgprIndices[0]], v[vgprIndices[1]:vgprIndices[2]], v[vgprIndices[3]:vgprIndices[4]], v[vgprIndices[5]])
  b = inst.to_bytes()
  inst_words = ".long " + ", ".join(f"0x{int.from_bytes(b[i:i+4], 'little'):08x}" for i in range(0, len(b), 4))
  src = assemblyTemplate.replace("INTERNAL_LOOP", str(INTERNAL_LOOP)).replace("INSTRUCTION", (inst_words+"\n")*INSTRUCTIONS_PER_LOOP)
  src = src.replace("DIRECTIVE", DIRECTIVE)
  lib = COMPILER.compile(src)
  fxn = AMDProgram(DEV, "matmul", lib)
  elapsed = min([fxn(global_size=(NUM_WORKGROUPS,1,1), local_size=(WAVE_SIZE*NUM_WAVES,1,1), wait=True) for _ in range(2)])
  FLOPs = FLOPS_PER_MATMUL * NUM_WAVES * NUM_WORKGROUPS * INTERNAL_LOOP * INSTRUCTIONS_PER_LOOP
  print(f"{inst.op_name.lower():<29} : {FLOPs/elapsed/10**12:.2f} T(FL)OPS")

if __name__=="__main__":
  DEVICENUM = os.getenv("DEVICENUM", "0")
  try:
    DEV = Device['AMD:' + DEVICENUM]
  except:
    raise RuntimeError("Error while initiating AMD device")

  COMPILER = HIPCompiler(DEV.arch)
  if DEV.arch in {'gfx1100', 'gfx1103', 'gfx1151'}:
    from extra.assembly.amd.autogen.rdna3.ins import *
    if DEV.arch == 'gfx1103': NUM_WORKGROUPS = 8
    if DEV.arch == 'gfx1151': NUM_WORKGROUPS = 32
    launchBenchmark(v_wmma_bf16_16x16x16_bf16, (7,8,15))
    launchBenchmark(v_wmma_f16_16x16x16_f16, (7,8,15))
    launchBenchmark(v_wmma_f32_16x16x16_bf16, (7,8,15))
    launchBenchmark(v_wmma_f32_16x16x16_f16, (7,8,15))
    launchBenchmark(v_wmma_i32_16x16x16_iu4, (7,8,9))
    launchBenchmark(v_wmma_i32_16x16x16_iu8, (7,8,11))
  elif DEV.arch == 'gfx1201':
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
  elif DEV.arch == 'gfx950':
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
    # TODO: should be 5 VGPRS, DSL asserts
    launchBenchmark(v_mfma_f32_16x16x128_f8f6f4, (3,0,7), accum=True) # fp8
    # TODO: should be 3 VGPRS, DSL asserts
    launchBenchmark(v_mfma_f32_16x16x128_f8f6f4, (3,0,7), accum=True, neg_hi=4, neg=4) # fp4
  else:
    raise RuntimeError(f"arch {DEV.arch} not supported.")
