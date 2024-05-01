#!/usr/bin/env python3
import subprocess, os, dill, shlex, sys
from typing import List, Tuple
from tinygrad.features.graph import print_tree
from tinygrad.helpers import colored
from tinygrad.ops import LazyOp

if __name__ == "__main__":
  # grab the command TODO: delete once this runs on the entire CI
  parts, env, i = shlex.split(sys.argv[1]), {}, 0
  while "=" in parts[i]:
    key, value = parts[i].split("=")
    env[key] = value
    i += 1
  cmd, env = parts[i:], {**os.environ, **env}

  # run curr branch
  commit = subprocess.check_output(["git", "rev-parse", "HEAD"], encoding="utf-8").strip()
  subprocess.run(["git", "checkout", commit], check=True)
  subprocess.run(cmd, env={**env, "SAVE_SCHEDULE": "1", "SAVE_SCHEDULE_PATH": f"{commit}.pkl"})
  feat = dill.load(open(f"./{commit}.pkl", "rb"))

  # run master TODO: delete once master saves state
  commit = subprocess.run(["git", "rev-parse", "master"], stdout=subprocess.PIPE, check=True, text=True).stdout.strip()
  subprocess.run(["git", "checkout", commit], check=True)
  subprocess.run(cmd, env={**env, "SAVE_SCHEDULE": "1"})
  master = dill.load(open(f"./schedule.pkl", "rb"))

  # verify
  assert len(master) == len(feat)
  master_asts: List[Tuple[LazyOp, ...]] = [ps.ast for _, prescheduled in master for _, ps in prescheduled.items()]
  feat_asts: List[Tuple[LazyOp, ...]] = [ps.ast for _, prescheduled in feat for _, ps in prescheduled.items()]
  for m, f in zip(master_asts, feat_asts):
    try: assert m == f
    except AssertionError as e:
      print(colored("FAILED FOR AST: ", "red"))
      print("expected:")
      for op in m: print_tree(op)
      print("got:")
      for op in f: print_tree(op)
      raise e
