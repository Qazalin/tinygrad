from collections import defaultdict, deque
import numpy as np
from dataclasses import replace
from typing import DefaultDict, Dict, List, Set, Tuple
from tinygrad.codegen.uops import UOp, UOpGraph, UOps
from tinygrad.device import Buffer, Device
from tinygrad.engine.graph import save_graph
from tinygrad.engine.realize import CompiledRunner
from tinygrad.helpers import DEBUG, GRAPHPATH, colored, getenv
from tinygrad.shape.symbolic import Variable

def fuzz_uops(graph:DefaultDict[UOp, List[UOp]], in_degree:DefaultDict[UOp, int], loops_children:Dict[UOp, Set[UOp]]):
  paths: List[List[UOp]] = []
  # TODO: express DEFINE_ACC and loop children conditions in the graph, builtin.
  for p in [_bfs(graph, in_degree)]:
    assert p[-1].uop is UOps.SINK, f"didn't end with SINK, ended with {p[-1]}"
    paths.append(path:=list(p[:-1]))
    for u in path:
      if u.uop is UOps.IF: path.append(UOp(UOps.ENDIF, None, (u,)))
      if u.uop is UOps.RANGE:
        path.insert(max(path.index(x) for x in loops_children[u] if x in path)+1, UOp(UOps.ENDRANGE, None, (u,)))
  return paths

class UOpsFuzzerRunner(CompiledRunner):
  def __call__(self, rawbufs:List[Buffer], var_vals:Dict[Variable, int], wait=False):
    assert self.p.uops is not None and len(self.p.uops.fuzz_paths) >= 1
    init_rawbufs, init_name = {x:x.as_buffer() for x in rawbufs}, self.p.function_name
    init_globals = {i[0]:buf for i, buf in zip(self.p.globals, rawbufs)}
    if DEBUG >= 1: print(colored(f"fuzzing {len(self.p.uops.fuzz_paths)} UOps permutations for {init_name}", "yellow"))

    super().__call__(rawbufs, var_vals, wait)
    ground_truth = {x:np.frombuffer(x.as_buffer(), x.dtype.np) for x in rawbufs}

    for i, path in enumerate(self.p.uops.fuzz_paths):
      # setup prg
      uops = UOpGraph()
      uops._uops = list(path)
      if DEBUG >= 6: uops.print()
      self.p = replace(self.p, name=(name:=f"{init_name}fuzz{i}"), src=Device[self.p.dname].renderer.render(name, uops), uops=uops)
      if DEBUG >= 4: print(self.p.src)
      self.lib = Device[self.p.dname].compiler.compile_cached(self.p.src)
      self.clprg = Device[self.p.dname].runtime(name, self.lib)
      for x in (rawbufs:=[init_globals[i[0]] for i in self.p.globals]): x.copyin(init_rawbufs[x])
      # verify
      super().__call__(rawbufs, var_vals, wait)
      for i, x in enumerate(rawbufs):
        try:
          np.testing.assert_allclose(np.frombuffer(x.as_buffer(), x.dtype.np), ground_truth[x], atol=1e-6, rtol=1e-6)
          if DEBUG >= 2: print(colored(name, "green"))
        except AssertionError as e:
          print(colored(name, "red"))
          raise e

def find_all_toposorts(graph:DefaultDict[UOp, List[UOp]], in_degree:DefaultDict[UOp, int]) -> List[Tuple[UOp, ...]]:
  visited: Set[UOp] = set()
  ret: List[Tuple[UOp, ...]] = []
  path: List[UOp] = []

  def recurse_paths(path:List[UOp]):
    for v, d in in_degree.items():
      if d != 0 or v in visited: continue
      if v.uop is UOps.DEFINE_ACC and any(l not in path for l in v.vin): continue
      for u in graph[v]: in_degree[u] -= 1
      if v.uop is UOps.DEFINE_ACC: path.insert(min(path.index(l) for l in v.vin), v)
      else: path.append(v)
      visited.add(v)
      recurse_paths(path)
      if len(ret) >= getenv("FUZZ_UOPS_MAX_PATHS", 10): return
      # backtrack
      for u in graph[v]: in_degree[u] += 1
      path.pop()
      visited.remove(v)
    if len(path) == len(in_degree): ret.append(tuple(path))
  recurse_paths(path)

  if len(ret) == 0: raise RuntimeError("detected cycle in the graph")
  # verify all paths are unique
  assert len(ret) == len(set(ret))
  return ret

def panic(x=""): raise Exception(x)

def graph_uops(g:DefaultDict[UOp, List[UOp]]):
  import networkx as nx
  colors = {UOps.ALU: "#ffffc0", UOps.LOAD: "#ffc0c0", UOps.STORE: "#c0ffc0", UOps.SPECIAL: "#c0c0ff", UOps.CONST: "#e0e0e0",
            UOps.DEFINE_GLOBAL: "#ffe0b0", UOps.DEFINE_LOCAL: "#ffe0d0", UOps.DEFINE_ACC: "#f0ffe0",
            UOps.RANGE: "#c8a0e0", UOps.PHI: "#e0ffc0", UOps.BARRIER: "#ff8080", UOps.IF: "#c8b0c0"}
  G = nx.DiGraph()
  for u in (uops:=list(g)):
    G.add_node(uops.index(u), label=f"{str(u.uop)[5:]}{(' '+str(u.arg)) if u.arg is not None else ''}\n{str(u.dtype)}", style="filled", fillcolor=colors.get(u.uop, "#ffffff"))  # noqa: E501
    for v in g[u]:
      if v not in uops: continue
      G.add_edge(uops.index(v), uops.index(u))
  save_graph(G, f'{GRAPHPATH}.uops', '-Grankdir=LR')

def _bfs(graph:DefaultDict[UOp, List[UOp]], in_degree:DefaultDict[UOp, int]) -> Tuple[UOp, ...]:
  # *** build the range graph
  ranges = [x for x in in_degree if x.uop is UOps.RANGE]
  range_subtrees: DefaultDict[UOp, Set[UOp]] = defaultdict(set)
  def _get_group(u:UOp, group):
    if u.uop is UOps.PHI or u in group: return
    group.add(u)
    for x in graph[u]: _get_group(x, group)
  for r in ranges: _get_group(r, range_subtrees[r])
  # 1. once loop RANGE is inserted, ONLY its children are inserted until you reach END
  # 2. PHI is always leaf

  # *** sort
  queue = deque(x for x,d in in_degree.items() if d == 0)

  ret: List[UOp] = []
  while queue:
    u = queue.popleft()
    if u.uop is UOps.DEFINE_ACC: ret.insert(min(ret.index(v) for v in u.vin), u)
    else: ret.append(u)
    for x in graph[u]:
      in_degree[x] -= 1
      if in_degree[x] == 0: queue.append(x)

  return tuple(ret)
