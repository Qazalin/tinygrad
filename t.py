import textwrap
from tinygrad import Tensor, Device
from test.testextra.test_cfg_viz import template
from tinygrad.uop.ops import track_rewrites, UOp, Ops
from tinygrad.helpers import TracingKey
from tinygrad.renderer import ProgramSpec
from tinygrad.engine.realize import ExecItem, CompiledRunner

out = Tensor.full((4,), 1.0).contiguous().realize()

@track_rewrites(name=lambda *args,ret,**kwargs: TracingKey(ret.prg.p.name, (ret.prg.p.function_name,), ret=ret.prg.p))
def assemble(src:str):
  src = template.replace("fn_name", "test").replace("INSTRUCTION", textwrap.dedent(src))
  ast = UOp(Ops.NOOP)
  prg = ProgramSpec("test", src, Device.DEFAULT, ast, global_size=[1,1,1], local_size=[1,1,1], globals=[0])
  return ExecItem(ast, [out.uop.buffer], prg=CompiledRunner(prg))

asm = """
s_load_b64 s[0:1], s[0:1], 0x0
v_mov_b32_e32 v0, 2.0
s_delay_alu instid0(VALU_DEP_1)
v_dual_mov_b32 v4, 0 :: v_dual_mov_b32 v1, v0
v_dual_mov_b32 v2, v0 :: v_dual_mov_b32 v3, v0
s_wait_kmcnt 0x0
global_store_b128 v4, v[0:3], s[0:1]
s_nop 0
s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
s_endpgm
"""
prg = assemble(asm)
prg.run(wait=True)
print(out.numpy())
