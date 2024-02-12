import numpy as np
from test.test_linearizer import helper_realized_ast
from tinygrad.helpers import ansistrip, from_mv
from tinygrad.codegen.linearizer import Linearizer
from tinygrad.runtime.compiler.hip_comgr import compile_rdna3
from tinygrad.runtime.ops_hip import HIPProgram
from tinygrad.tensor import Tensor, dtypes

"""
<stdin>:	file format elf64-amdgpu

Disassembly of section .text:

0000000000001700 <_Z6kernelPiS_S_>:
	s_load_b128 s[0:3], s[0:1], null                           // 000000001700: F4080000 F8000000
	s_mov_b32 s4, s15                                          // 000000001708: BE84000F
	s_ashr_i32 s5, s15, 31                                     // 00000000170C: 86059F0F
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000001710: BF870009
	s_lshl_b64 s[4:5], s[4:5], 2                               // 000000001714: 84848204
	s_waitcnt lgkmcnt(0)                                       // 000000001718: BF89FC07
	s_add_u32 s2, s2, s4                                       // 00000000171C: 80020402
	s_addc_u32 s3, s3, s5                                      // 000000001720: 82030503
	s_add_u32 s0, s0, s4                                       // 000000001724: 80000400
	s_load_b32 s2, s[2:3], null                                // 000000001728: F4000081 F8000000
	v_mov_b32_e32 v0, 0                                        // 000000001730: 7E000280
	s_addc_u32 s1, s1, s5                                      // 000000001734: 82010501
	s_waitcnt lgkmcnt(0)                                       // 000000001738: BF89FC07
	v_mov_b32_e32 v1, s2                                       // 00000000173C: 7E020202
	global_store_b32 v0, v1, s[0:1]                            // 000000001740: DC6A0000 00000100
	s_nop 0                                                    // 000000001748: BF800000
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)                       // 00000000174C: BFB60003
	s_endpgm                                                   // 000000001750: BFB00000
"""

# v_wmma_f32_16x16x16_f16
asm = open("./wmma.s").read()
asm = """
s_load_b128 s[0:3], s[0:1], null
v_mov_b32 v1, 69
v_mov_b32 v0, 0
s_waitcnt lgkmcnt(0)
global_store_b32 v0 v1 s[0:1]
s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
"""
N = 2
FLOPS = N*N*N*2
BW = N*N*3*4
dt = dtypes.int
a, b = Tensor.rand(N, N, dtype=dt), Tensor.rand(N, N, dtype=dt)
r = a + b
sched = r.lazydata.schedule()
realized_ast, real_bufs = helper_realized_ast(r)
real_bufs[0].copyin(np.zeros((real_bufs[0].size, ), dtype=real_bufs[0].dtype.np).data)
data0 = np.frombuffer(real_bufs[0].as_buffer(), real_bufs[0].dtype.np)
lib, asm = compile_rdna3(asm, dt)
prg = HIPProgram(0, "kernel", lib)
prg(*[b._buf for b in real_bufs], global_size=(2,1,1), local_size=(1,1,1), wait=True)
data0 = np.frombuffer(real_bufs[0].as_buffer(), real_bufs[0].dtype.np)
data1 = np.frombuffer(real_bufs[1].as_buffer(), real_bufs[1].dtype.np)
data2 = np.frombuffer(real_bufs[2].as_buffer(), real_bufs[2].dtype.np)
print(data0)
