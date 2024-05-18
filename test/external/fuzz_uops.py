from collections import deque
from typing import DefaultDict, List
from tinygrad.codegen.uops import UOp, UOpGraph
from tinygrad.device import Device

def fuzz_uops(graph:DefaultDict[UOp, List[UOp]], in_degree:DefaultDict[UOp, int]):
  # bfs ordering
  queue = deque(x for x, deg in in_degree.items() if deg == 0)
  ret: List[UOp] = []
  while queue:
    u = queue.popleft()
    ret.append(u)
    for v in graph[u]:
      in_degree[v] -= 1
      if in_degree[v] == 0: queue.append(v)

  uops = UOpGraph()
  uops._uops = ret
  Device[Device.DEFAULT].renderer.render("variant_0", uops)
  return []
