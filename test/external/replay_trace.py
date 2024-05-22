import pickle
from typing import Dict, List, Tuple
from tinygrad.codegen.linearizer import Linearizer
from tinygrad.device import Device
from tinygrad.engine.graph import print_tree
from tinygrad.helpers import to_function_name
from tinygrad.ops import LazyOp

with open("/Users/tiny/traces/26e7b157cf87855be38ee4bc718f80a3ffa94004", "rb") as f:
  try:
    while True:
      trace: Dict[Tuple[LazyOp, ...], List[Tuple[str, Linearizer]]] = pickle.load(f)
      print(len(trace))
      if len(trace) != 22: continue
      for ast, lins in trace.items():
        for op in ast: print_tree(op)
        print(ast)
        print(len(lins))
        for _,lin in lins:
          lin.uops.print()
          print(Device[Device.DEFAULT].renderer.render(to_function_name(lin.name), lin.uops))
        print("---")
  except EOFError: pass
