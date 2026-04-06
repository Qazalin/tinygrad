#!/usr/bin/env python3
# custom processor for the viz cli output
import sys, itertools, signal
if hasattr(signal, "SIGPIPE"): signal.signal(signal.SIGPIPE, signal.SIG_DFL)
from tinygrad.helpers import ansistrip, colored

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
          pipes = {"VALU":0, "SALU":0, "VMEM":0, "LDS":0}
          for packet_idx in util:
            p = packets[packet_idx]
            for k in pipes:
              if k in p: pipes[k] += 1
          util_str = [f"{t:<12}"]
          for p,util in pipes.items():
            #util_str.append(colored(p, "GREEN" if util > 0 else None))
            util_str.append("·" if util == 0 else "█")
          print(" ".join(util_str))
      for t in arrived: del active[t]

if __name__ == "__main__":
  try: main()
  except KeyboardInterrupt: pass
