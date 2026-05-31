#!/usr/bin/env python3
import argparse

from tinygrad.helpers import ansistrip, temp
from tinygrad.codegen import to_program
from tinygrad.uop.render import pyrender
from tinygrad.viz.serve import VizData, _reconstruct, load_pickle

def main():
  parser = argparse.ArgumentParser(description="Print the base SINK for a kernel rewrite trace")
  parser.add_argument("--kernel", default="E_114688_32_4_2_4", help="kernel display name suffix to load from rewrites.pkl")
  parser.add_argument("--pickle", default=None, help="path to rewrites.pkl, defaults to tinygrad temp path")
  parser.add_argument("--program", action="store_true", help="run base sink through to_program with trace renderer and print final program")
  args = parser.parse_args()

  data = VizData(load_pickle(args.pickle or temp("rewrites.pkl", append_user=True), []))
  for i,k in enumerate(data.trace.keys):
    if ansistrip(k.display_name).endswith(args.kernel): break
  else: raise RuntimeError(f"kernel {args.kernel!r} not found in rewrites")

  sink = _reconstruct(data, data.trace.rewrites[i][0].sink)
  if args.program:
    prg = to_program(sink, data.trace.keys[i].ret)
    print(prg.src[3].arg)
  else:
    print(pyrender(sink))

if __name__ == "__main__": main()
