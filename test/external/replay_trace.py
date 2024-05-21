import pickle
from typing import Dict, Tuple
from tinygrad.codegen.linearizer import Linearizer
from tinygrad.device import Device
from tinygrad.engine.graph import print_tree
from tinygrad.helpers import to_function_name
from tinygrad.ops import LazyOp

# 
with open("/Users/tiny/traces/833aa0ca0ae05de8444e76216f9142da359e8b38", "rb") as f:
  try:
    while True:
      trace: Dict[Tuple[LazyOp, ...], Linearizer] = pickle.load(f)
      print(len(trace))
      if len(trace) != 21: continue
      for ast, k in trace.items():
        for op in ast: print_tree(op)
        k.uops.print()
        print(Device[Device.DEFAULT].renderer.render(to_function_name(k.name), k.uops))
  except EOFError: pass
