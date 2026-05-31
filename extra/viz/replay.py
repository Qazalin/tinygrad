from dataclasses import replace
from tinygrad.viz.serve import load_pickle, _reconstruct, VizData
from tinygrad.helpers import temp, ansistrip
from tinygrad.codegen import to_program
from tinygrad.codegen.opt.postrange import bufs_from_ast
from tinygrad.engine.realize import time_call
from tinygrad.uop.ops import UOp

data = VizData(load_pickle(temp("rewrites.pkl", append_user=True), []))
for i,k in enumerate(data.trace.keys):
  if ansistrip(k.display_name).endswith("E_114688_32_4_2_4"): break

assert data.trace.rewrites[i][-1].name == "View Program"
prg = _reconstruct(data, data.trace.rewrites[i][-1].sink)
print(prg.op)

device = prg.src[1].arg
bufs = [UOp.from_buffer(b.allocate()) for b in bufs_from_ast(prg.src[0], device)]
print(time_call(prg.call(*bufs)))
