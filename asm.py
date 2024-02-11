import numpy as np
from test.test_linearizer import helper_realized_ast
from tinygrad.helpers import ansistrip, from_mv
from tinygrad.runtime.compiler.hip_comgr import compile_rdna3
from tinygrad.runtime.ops_hip import HIPProgram
from tinygrad.tensor import Tensor

asm = """
s_load_b64 s[0:1], s[0:1], null
v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v1, 42
s_waitcnt lgkmcnt(0)
global_store_b32 v0, v1, s[0:1]
s_endpgm
"""
lib, asm = compile_rdna3(asm)
print(asm)
a = Tensor([1,2,3,4])
b = Tensor([4,5,6,7])
r = a + b
sched = r.lazydata.schedule()
realized_ast, real_bufs = helper_realized_ast(r)
real_bufs[0].copyin(np.zeros((real_bufs[0].size, ), dtype=real_bufs[0].dtype.np).data) # Zero to check that all values are filled
data0 = np.frombuffer(real_bufs[0].as_buffer(), real_bufs[0].dtype.np)
print("----------- before- ----------")
print(data0)
# self, *args, global_size:Tuple[int,int,int]=(1,1,1), local_size:Tuple[int,int,int]=(1,1,1), vals:Tuple[int, ...]=(), wait=False
prg = HIPProgram(0, "kernel", lib)
prg(real_bufs[0]._buf, global_size=(1,1,1), local_size=(1,1,1))
data0 = np.frombuffer(real_bufs[0].as_buffer(), real_bufs[0].dtype.np)
print("----------- after!!!- ----------")
print(data0)
