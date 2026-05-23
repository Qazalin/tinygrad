#!/usr/bin/env python3
# Usage: NO_COLOR=1 python -m tinygrad.viz.cli --json | ./extra/viz/marker_interval.py "train @ 2" "train @ 3"
import argparse, collections, json, sys
from tinygrad.helpers import ansilen, time_to_str

def to_str(k:str, v) -> str:
  if k == "FLOPS" or k.startswith("B/s"): return f"{v*1e-9:.0f} G{k}" if v < 1e13 else f"{v*1e-12:.0f} T{k}"
  return f"{k}={v}"

def fmt_data(data:dict[str, float]) -> str:
  return "  ".join((p:=to_str(k, v))+" "*max(0, 14-ansilen(p)) for k,v in data.items())

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
  parser.add_argument("--include-sdma", action="store_true", help="include SDMA copy events")
  args = parser.parse_args()

  records = []
  markers:list[dict] = []
  for line in sys.stdin:
    if not line.strip(): continue
    rec = json.loads(line)
    rec["name"] = str(rec.get("name", ""))
    if rec.get("device") == "MARKER": markers.append(rec)
    elif "dur_ms" in rec: records.append(rec)

  start_marker = next((m for m in markers if m["name"] == args.start), None)
  if start_marker is None: raise SystemExit(f"start marker {args.start!r} not found")
  end_marker = next((m for m in markers if m["name"] == args.end and m["st_ms"] > start_marker["st_ms"]), None)
  if end_marker is None: raise SystemExit(f"end marker {args.end!r} after {args.start!r} not found")

  start, end = start_marker["st_ms"], end_marker["st_ms"]
  window = end - start
  intervals:list[tuple[float, float]] = []
  lane_sum:dict[str, dict[str, float]] = collections.defaultdict(lambda: collections.defaultdict(float))
  device_sum:dict[str, float] = collections.defaultdict(float)
  lane_estimates:dict[str, dict[str, dict[str, float]]] = collections.defaultdict(lambda: collections.defaultdict(lambda: collections.defaultdict(float)))
  counts:collections.Counter[str] = collections.Counter()

  for rec in records:
    dev, name = rec.get("device", ""), rec["name"]
    if dev == "AMD Graph": continue
    if not args.include_sdma and (":SDMA:" in dev or " -> " in name): continue
    st, en = rec["st_ms"], rec["st_ms"] + rec["dur_ms"]
    a, b = max(st, start), min(en, end)
    if b <= a: continue
    key = f"{dev}:{name}" if dev in {"USER", "TINY", "CPU:COPY"} else name
    intervals.append((a, b))
    lane_sum[key][dev] += b - a
    device_sum[key] += b - a
    for k in ("FLOPS", "B/s mem", "B/s lds"):
      if k in rec.get("fmt", {}): lane_estimates[key][dev][k] += rec["fmt"][k] * (b - a) * 1e-3
    counts[key] += 1

  covered = union_len(intervals)
  crit = {name:max(lanes.values()) for name,lanes in lane_sum.items()}
  crit_lane = {name:max(lanes, key=lambda lane:lanes[lane]) for name,lanes in lane_sum.items()}

  rows = sorted(crit, key=lambda x:crit[x], reverse=True)
  other = rows[args.limit:] if args.limit > 0 else []
  if args.limit > 0: rows = rows[:args.limit]
  print(f"window {args.start!r} -> {end_marker['name']!r}: {window:.3f} ms")
  print(f"covered: {covered:.3f} ms ({covered/window*100:.2f}%), gap: {window-covered:.3f} ms")
  for name in rows:
    lane = crit_lane[name]
    est = {k:int(v / (lane_sum[name][lane] * 1e-3)) for k,v in lane_estimates[name][lane].items() if lane_sum[name][lane] > 0}
    display = name + " "*max(0, 58-ansilen(name))
    print(f"{display} {time_to_str(crit[name]*1e-3, w=9)} {time_to_str(device_sum[name]*1e-3, w=9)} {counts[name]:7d} {crit[name]/window*100:6.2f}% {lane[:8]:>8s}"+
          ("    "+fmt_data(est) if est else ""))
  if other:
    other_crit, other_dev, other_count = sum(crit[x] for x in other), sum(device_sum[x] for x in other), sum(counts[x] for x in other)
    print(f"{'Other':38s} {time_to_str(other_crit*1e-3, w=9)} {time_to_str(other_dev*1e-3, w=9)} {other_count:7d} {other_crit/window*100:6.2f}%")
  print(f"TOTAL crit {sum(crit.values()):.3f} ms ({sum(crit.values())/window*100:.2f}%), device {sum(device_sum.values()):.3f} ms")
