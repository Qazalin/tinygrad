import numpy as np
from test.test_linearizer import helper_realized_ast
from tinygrad.helpers import ansistrip, from_mv
from tinygrad.codegen.linearizer import Linearizer
from tinygrad.runtime.compiler.hip_comgr import compile_rdna3
from tinygrad.runtime.ops_hip import HIPProgram
from tinygrad.tensor import Tensor, dtypes

# v_wmma_f32_16x16x16_f16
asm = """
s_load_b128 s[0:3], s[0:1], null
v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v1, 11878
s_waitcnt lgkmcnt(0)
global_store_b32 v0, v1, s[2:3]
s_endpgm
"""
lib, asm = compile_rdna3(asm)
a, b = Tensor([1,2,3,4]), Tensor([1,2,3,4])
r = a + b
sched = r.lazydata.schedule()
realized_ast, real_bufs = helper_realized_ast(r)
real_bufs[0].copyin(np.zeros((real_bufs[0].size, ), dtype=real_bufs[0].dtype.np).data)
data0 = np.frombuffer(real_bufs[0].as_buffer(), real_bufs[0].dtype.np)
prg = HIPProgram(0, "kernel", lib)
prg(*[b._buf for b in real_bufs], global_size=(1,1,1), local_size=(1,1,1))
data0 = np.frombuffer(real_bufs[0].as_buffer(), real_bufs[0].dtype.np)
data1 = np.frombuffer(real_bufs[1].as_buffer(), real_bufs[1].dtype.np)
data2 = np.frombuffer(real_bufs[2].as_buffer(), real_bufs[2].dtype.np)
print(data2)
