#!/usr/bin/env python3
# Usage: NO_COLOR=1 python -m tinygrad.viz.cli --json | ./extra/viz/marker_interval.py "train @ 2" "train @ 3"
import argparse, collections, json, sys
from tinygrad.helpers import ansistrip

def union_len(ints:list[tuple[float, float]]) -> float:
  if not ints: return 0.0
  ints = sorted(ints)
  total, st, en = 0.0, ints[0][0], ints[0][1]
  for a,b in ints[1:]:
    if a <= en: en = max(en, b)
    else: total, st, en = total + en - st, a, b
  return total + en - st

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="attribute profiler wall-clock time within a marker interval from tinygrad.viz.cli --json")
  parser.add_argument("start", type=str, help="start marker name, for example 'train @ 2'")
  parser.add_argument("end", type=str, help="end marker name, for example 'train @ 3'")
  parser.add_argument("-n", "--limit", type=int, default=60, help="number of rows to print (default: 60, <=0 for all)")
  args = parser.parse_args()

  records = []
  markers:list[dict] = []
  for line in sys.stdin:
    if not line.strip(): continue
    rec = json.loads(line)
    rec["name"] = ansistrip(str(rec.get("name", "")))
    if rec.get("device") == "MARKER": markers.append(rec)
    elif "dur_ms" in rec: records.append(rec)

  start_marker = next((m for m in markers if m["name"] == args.start), None)
  if start_marker is None: raise SystemExit(f"start marker {args.start!r} not found")
  end_marker = next((m for m in markers if m["name"] == args.end and m["st_ms"] > start_marker["st_ms"]), None)
  if end_marker is None: raise SystemExit(f"end marker {args.end!r} after {args.start!r} not found")

  start, end = start_marker["st_ms"], end_marker["st_ms"]
  window = end - start
  events:list[tuple[float, int, str]] = []
  presence:dict[str, list[tuple[float, float]]] = collections.defaultdict(list)
  # possibly overlapped total time
  device_sum:dict[str, float] = collections.defaultdict(float)
  counts:collections.Counter[str] = collections.Counter()

  for rec in records:
    dev, name = rec.get("device", ""), rec["name"]
    if dev == "AMD Graph": continue
    st, en = rec["st_ms"], rec["st_ms"] + rec["dur_ms"]
    a, b = max(st, start), min(en, end)
    if b <= a: continue
    key = f"{dev}:{name}" if dev in {"USER", "TINY", "CPU:COPY"} else name
    events += [(a, 1, key), (b, -1, key)]
    presence[key].append((a, b))
    device_sum[key] += b - a
    counts[key] += 1

  events.sort(key=lambda x:(x[0], -x[1]))
  active:collections.Counter[str] = collections.Counter()
  attr:dict[str, float] = collections.defaultdict(float)
  covered, prev, i = 0.0, start, 0
  while i < len(events):
    t = events[i][0]
    if t > prev:
      keys = [k for k,n in active.items() if n > 0]
      dur = t - prev
      if keys:
        covered += dur
        for k in keys: attr[k] += dur / len(keys)
      prev = t
    while i < len(events) and events[i][0] == t:
      _, delta, key = events[i]
      active[key] += delta
      if active[key] == 0: del active[key]
      i += 1

  rows = sorted(attr.items(), key=lambda kv: kv[1], reverse=True)
  if args.limit > 0: rows = rows[:args.limit]
  print(f"window {args.start!r} -> {end_marker['name']!r}: {window:.3f} ms")
  print(f"covered: {covered:.3f} ms ({covered/window*100:.2f}%), gap: {window-covered:.3f} ms")
  print(f"{'rank':>4} {'wall_ms':>10} {'pct':>7} {'present_ms':>11} {'device_sum_ms':>13} {'count':>7}  name")
  for rank,(name,ms) in enumerate(rows, 1):
    print(f"{rank:4d} {ms:10.3f} {ms/window*100:6.2f}% {union_len(presence[name]):11.3f} {device_sum[name]:13.3f} {counts[name]:7d}  {name}")
  print(f"TOTAL {sum(attr.values()):.3f} ms ({sum(attr.values())/window*100:.2f}%)")
