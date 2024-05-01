import dill, subprocess, os
from typing import List, Tuple
from tinygrad.features.graph import print_tree
from tinygrad.helpers import colored
from tinygrad.ops import LazyOp

master = dill.load(open("./ref.pkl", "rb"))

commit = subprocess.check_output(["git", "rev-parse", "HEAD"], encoding="utf-8").strip()
subprocess.run(["git", "checkout", commit], check=True)
subprocess.run(["python3", "test/test_schedule.py"], env={**os.environ, "SAVE_SCHEDULE": "1"})
feat = dill.load(open("./schedule.pkl", "rb"))

assert len(master) == len(feat)
master_asts: List[Tuple[LazyOp, ...]] = [ps.ast for _, prescheduled in master for _, ps in prescheduled.items()]
feat_asts: List[Tuple[LazyOp, ...]] = [ps.ast for _, prescheduled in feat for _, ps in prescheduled.items()]

for m, f in zip(master_asts, feat_asts):
  try: assert m == f
  except AssertionError:
    print(colored("FAILED FOR AST: ", "red"))
    print("expected:")
    for op in m: print_tree(op)
    print("got:")
    for op in f: print_tree(op)
