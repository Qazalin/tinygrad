#!/usr/bin/env python3
import sys, itertools, signal
if hasattr(signal, "SIGPIPE"): signal.signal(signal.SIGPIPE, signal.SIG_DFL)
from tinygrad.helpers import ansistrip

def main() -> int:
  curr_active:dict[int, list[str]] = {}
  for line in itertools.islice(sys.stdin, 2, None):
    parts = ansistrip(line).split()
    cycle = int(parts[0])
    if cycle not in curr_active:
      print(curr_active)
      curr_active = {cycle:[]}
    else: curr_active[cycle].append(" ".join(parts[1:]))

if __name__ == "__main__":
  try: main()
  except KeyboardInterrupt: pass
