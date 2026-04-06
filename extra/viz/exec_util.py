#!/usr/bin/env python3
# custom processor for the viz cli output
import sys, itertools, signal
if hasattr(signal, "SIGPIPE"): signal.signal(signal.SIGPIPE, signal.SIG_DFL)
from tinygrad.helpers import ansistrip

def main() -> int:
  packets:list[str] = []
  pending_dispatch:dict[int, list[int]] = {}
  active:dict[int, list[int]] = {}
  for i,pkt in enumerate(itertools.islice(sys.stdin, 2, None)):
    packets.append(pkt:=ansistrip(pkt))
    data = pkt.split()
    ts, dur = int(data[0]), int(data[3])
    if "DISPATCH" in pkt:
      pending_dispatch.setdefault(ts, []).append(i)
      active.setdefault(ts, []).append(i)
    elif "EXEC" in pkt:
      # EXEC utilizes the pipe for the complete duration of the inst
      for t in range(ts, ts+dur): active.setdefault(t, []).append(i)
      delay = int(data[4])
      pending_dispatch[ts-delay].pop()
      # we know the resource utilization at that cycle once all EXEC and DISPATCH packets arrive.
      arrived:list[int] = []
      for t,util in active.items():
        if not pending_dispatch.get(t):
          arrived.append(t)
          print(t, util)
      for t in arrived: del active[t]

if __name__ == "__main__":
  try: main()
  except KeyboardInterrupt: pass
