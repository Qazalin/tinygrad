from collections import deque
from typing import DefaultDict, List
from tinygrad.codegen.uops import UOp, UOpGraph

def fuzz_uops(graph:DefaultDict[UOp, List[UOp]], in_degree:DefaultDict[UOp, int]):
  variants: List[List[UOp]] = []

  # bfs ordering
  queue = deque(x for x, deg in in_degree.items() if deg == 0)
  print(queue)
  return []
