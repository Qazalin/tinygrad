import textwrap
from tinygrad import Tensor, Device
from test.testextra.test_cfg_viz import template
from tinygrad.uop.ops import track_rewrites, UOp, Ops
from tinygrad.helpers import TracingKey
from tinygrad.renderer import ProgramSpec
from tinygrad.engine.realize import ExecItem, CompiledRunner

out = Tensor.zeros((4,)).contiguous().realize()

@track_rewrites(name=lambda *args,ret,**kwargs: TracingKey(ret.prg.p.name, (ret.prg.p.function_name,), ret=ret.prg.p))
def assemble(src:str):
  src = template.replace("fn_name", "test").replace("INSTRUCTION", textwrap.dedent(src))
  ast = UOp(Ops.NOOP)
  prg = ProgramSpec("test", src, Device.DEFAULT, ast, global_size=[1,1,1], local_size=[1,1,1], globals=[0])
  return ExecItem(ast, [out.uop.buffer], prg=CompiledRunner(prg))

prg = assemble("s_mov_b32 s1 0\ns_endpgm")
prg.run(wait=True)
