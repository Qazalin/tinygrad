import time
import numpy as np
from tinygrad.helpers import getenv, prod, flat_mv
from tinygrad.renderer.cstyle import HIPLanguage

if getenv("HIPCPU"):
  from tinygrad.runtime.ops_remu import MallocAllocator, compile_hip, HIPDevice, HIPProgram
  device = HIPDevice()
  hipallocator = MallocAllocator
else:
  from tinygrad.runtime.ops_hip import HIPAllocator, HIPDevice, HIPProgram, compile_hip, MallocAllocator, HIPProgram
  device = HIPDevice()
  hipallocator = HIPAllocator(device)


# AMD_LOG_LEVEL=3 ./MIOpenDriver gemm --iter 1000 --time 1 --a_w 2048 --a_h 2048 --b_w 2048
# 5.5: Cijk_Ailk_Bljk_HHS_BH_MT128x128x16_MI16x16x16x1_SN_1LDSB0_APM1_ABV0_ACED0_AF0EM1_AF1EM1_AMAS3_ASE_ASGT_ASAE01_ASCE01_ASEM1_AAC0_BL1_BS1_DTL0_DTVA0_DVO0_ETSP_EPS1_FL0_GRVW8_GSU1_GSUASB_GLS0_ISA1100_IU1_K1_KLA_LBSPP128_LPA0_LPB8_LDL1_LRVW16_LWPMn1_LDW0_FMA_MIAV1_MDA2_NTA0_NTB0_NTC0_NTD0_NEPBS0_NLCA1_NLCB1_ONLL1_OPLV0_PK0_PAP0_PGR1_PLR1_RK0_SIA1_SS1_SU32_SUM0_SUS128_SCIUI1_SPO0_SRVW0_SSO0_SVW4_SNLL0_TT4_64_TLDS1_USFGROn1_VAW2_VSn1_VW4_WSGRA1_WSGRB1_WS32_WG32_4_1_WGM4
# 5.6: Cijk_Ailk_Bljk_HHS_BH_MT128x128x16_MI16x16x16x1_SN_1LDSB0_APM1_ABV0_ACED0_AF0EM1_AF1EM1_AMAS3_ASE_ASGT_ASLT_ASAE01_ASCE01_ASEM1_AAC0_BL1_BS1_DTL0_DTVA0_DVO0_ETSP_EPS1_FL0_GRPM1_GRVW8_GSU1_GSUASB_GLS0_ISA1100_IU1_K1_KLA_LBSPP128_LPA0_LPB8_LDL1_LRVW16_LWPMn1_LDW0_FMA_MIAV1_MDA2_MO40_NTA0_NTB0_NTC0_NTD0_NEPBS0_NLCA1_NLCB1_ONLL1_OPLV0_PK0_PAP0_PGR1_PLR1_RK0_SIA1_SS1_SU32_SUM0_SUS128_SCIUI1_SPO0_SRVW0_SSO0_SVW4_SNLL0_TT4_64_TLDS1_USFGROn1_VAW2_VSn1_VW4_WSGRA1_WSGRB1_WS32_WG32_4_1_WGM4
# gets ~100
# hipExtModuleLaunchKernel ( 0x0x16ccde0, 2048, 16, 1, 128, 1, 1,
# 161.60 us = 106.31 TFLOPS
# with --batch_count 8 / 1.258128 ms / (8*2048*2048*2048*2)/(1.258128)*1e-9 / 109.24 TFLOPS

# we only get ~53
# KY=2 KX=2 N=2048 python3 extra/gemm/hip_matmul.py
#   4194304    324.76 us, would be  52899.88 GFLOPS matmul, 154.98 GB/s

N = getenv("N", 2048)
KX = getenv("KX", 4)
KY = getenv("KY", 4)
assert N%(16*KX) == 0, f"N must be multiple of {16*KX}"
assert N%(16*KY) == 0, f"N must be multiple of {16*KY}"
FLOPS = N*N*N*2
BW = N*N*3*4

# Can HIPAllocator initialized as device=0 by default?
a = hipallocator.alloc(N*N*4)
b = hipallocator.alloc(N*N*2)
c = hipallocator.alloc(N*N*2)
na = np.empty(N*N, np.float32)
nb = np.random.default_rng(seed=0).standard_normal(size=(N,N), dtype=np.float32).astype(np.float16)
nc = np.random.default_rng(seed=0).standard_normal(size=(N,N), dtype=np.float32).astype(np.float16)
hipallocator.copyin(b, bytearray(nb))
hipallocator.copyin(c, bytearray(nc))

def compile_hipold(prg:str, arch="gfx1100") -> bytes:
  from tinygrad.runtime.ops_hip import hip, check, ctypes
  from tinygrad.helpers import to_char_p_p, get_bytes
  check(hip.hiprtcCreateProgram(ctypes.byref(prog := hip.hiprtcProgram()), prg.encode(), "<null>".encode(), 0, None, None))
  compile_options = [f'--offload-arch={arch}', '-I/opt/rocm/include']
  status = hip.hiprtcCompileProgram(prog, len(compile_options), to_char_p_p([o.encode() for o in compile_options]))
  if status != 0: raise RuntimeError(f"compile failed: {get_bytes(prog, hip.hiprtcGetProgramLogSize, hip.hiprtcGetProgramLog, check).decode()}")
  return get_bytes(prog, hip.hiprtcGetCodeSize, hip.hiprtcGetCode, check)
#lib = compile_hip(HIPLanguage().kernel_prefix + open("gemm2.cpp").read())
lib = compile_hip(HIPLanguage().kernel_prefix + open("base.cpp").read())
#lib = compile_hipold(open("gemm.cpp").read())

prog = HIPProgram(device.device, "test", lib)

def timeit(fxn):
  st = time.perf_counter()
  et = fxn()
  ret = time.perf_counter() - st # NOTE: et doesn't contain the launch overhead
  #print(f"{ret*1e6:.2f} us")
  return et

"""
if not getenv("HIPCPU"):
  global_size, local_size = [N//(KX*16*2), N//(KY*16*2), 1], [32, 2, 2]
  print("global/local size", global_size, local_size, f"local_size:{prod(local_size)} total_size:{prod(global_size+local_size)}")
  tm = min([timeit(lambda: prog(a, b, c, global_size=global_size, local_size=local_size, wait=True)) for _ in range(1)])
  hipallocator.copyout(flat_mv(na.data),a)
  na = na.reshape(N,N)
  comp = nb.astype(np.float32) @ nc.astype(np.float32)
  print(f"{N*N:10d} {tm*1e6:9.2f} us, would be {FLOPS*1e-9/tm:9.2f} GFLOPS matmul, {BW*1e-9/tm:.2f} GB/s")
  np.testing.assert_allclose(na, comp, atol=1e-2, rtol=1e-2)
else:
"""
prog(a, b, c, global_size=(1,1,1), local_size=(1,1,1))
