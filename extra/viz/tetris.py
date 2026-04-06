#!/usr/bin/env python3
# tetris board visualizer for the SQTT trace
# to play: ./extra/viz/cli.py | ./extra/viz/tetris.py
import sys, itertools, signal
if hasattr(signal, "SIGPIPE"): signal.signal(signal.SIGPIPE, signal.SIG_DFL)
from tinygrad.helpers import ansistrip
from tinygrad.viz.serve import wave_colors

TTY = sys.stdout.isatty()
# modern terminals support 24-bit color
def hex_colored(st:str, color:str) -> str:
  return f"\x1b[38;2;{int(color[1:3],16)};{int(color[3:5],16)};{int(color[5:7],16)}m{st}\x1b[0m"
if not TTY:
  def hex_colored(st, color): return st

WINDOW = 33
PIPES = ("SALU", "VALU", "LDS", "VMEM")

def pipe_of(pkt:str) -> str|None:
  if "EXEC" not in pkt:
    return None
  if "VMEMEXEC" in pkt and "LDS" in pkt:
    return "LDS"
  if "VMEMEXEC" in pkt:
    return "VMEM"
  if "ALUEXEC" in pkt and "SALU" in pkt:
    return "SALU"
  if "ALUEXEC" in pkt and "VALU" in pkt:
    return "VALU"
  return None

def redraw(board:dict[int, dict[str, int]], latest:int) -> None:
  start = max(0, latest-WINDOW+1)
  end = start + WINDOW - 1

  out:list[str] = []
  out.append("\x1b[H")
  base = start
  out.append(f"clk {start:>6}..{end:<6} latest={latest:>6}")
  ruler = ["·"] * WINDOW
  for x,n in [(0, "0"), (8, "8"), (16, "16"), (24, "24"), (31, "31")]:
    for j,ch in enumerate(n):
      if x+j < WINDOW: ruler[x+j] = ch
  for x in (1,2,3,4,5,6,7,9,10,11,12,13,14,15,17,18,19,20,21,22,23,25,26,27,28,29,30):
    if ruler[x] == "·": ruler[x] = "."
  out.append("        " + "".join(ruler))

  for pipe in PIPES:
    row:list[str] = []
    for t in range(start, end+1):
      n = board.get(t, {}).get(pipe, 0)
      color = next((v for k,v in wave_colors.items() if k in pipe), None)
      row.append("·" if n == 0 else hex_colored("█", color) if n == 1 else str(min(n, 9)))
    out.append(f"{pipe:<6}  {''.join(row)}")

  cover:list[str] = []
  for t in range(start, end+1):
    total = sum(board.get(t, {}).values())
    cover.append("·" if total == 0 else str(min(total, 9)))
  out.append(f"COVER   {''.join(cover)}")

  sys.stdout.write("\n".join(out))
  sys.stdout.write("\x1b[J")
  sys.stdout.flush()

def main() -> int:
  packets:list[str] = []
  pending_dispatch:dict[int, list[int]] = {}
  active:dict[int, list[int]] = {}
  board:dict[int, dict[str, int]] = {}

  sys.stdout.write("\x1b[?1049h\x1b[?25l")
  sys.stdout.flush()

  try:
    for i,pkt in enumerate(itertools.islice(sys.stdin, 2, None)):
      packets.append(pkt:=ansistrip(pkt))
      data = pkt.split()
      ts, dur = int(data[0]), int(data[3])

      if "DISPATCH" in pkt:
        pending_dispatch.setdefault(ts, []).append(i)
        active.setdefault(ts, [])

      elif "EXEC" in pkt:
        for t in range(ts, ts+dur):
          active.setdefault(t, []).append(i)

        delay = int(data[4])
        dispatch_ts = ts-delay
        pending_dispatch[dispatch_ts].pop()
        if not pending_dispatch[dispatch_ts]:
          del pending_dispatch[dispatch_ts]

        arrived:list[int] = []
        for t in sorted(active):
          if pending_dispatch.get(t):
            continue
          counts = {pipe: 0 for pipe in PIPES}
          for idx in active[t]:
            pipe = pipe_of(packets[idx])
            if pipe is not None:
              counts[pipe] += 1
          board[t] = counts
          arrived.append(t)

        if arrived:
          latest = arrived[-1]
          redraw(board, latest)
          cutoff = latest - WINDOW*2
          for t in list(board):
            if t < cutoff:
              del board[t]

        for t in arrived:
          del active[t]

  finally:
    sys.stdout.write("\x1b[?25h\x1b[?1049l")
    sys.stdout.flush()

  return 0

if __name__ == "__main__":
  try:
    raise SystemExit(main())
  except KeyboardInterrupt:
    pass
