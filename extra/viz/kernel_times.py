#!/usr/bin/env python3
# Usage: NO_COLOR=1 python -m tinygrad.viz.cli --json | ./extra/viz/kernel_times.py hk_fp8_gemm_16384_4096_28672
import argparse, collections, json, sys
from tinygrad.helpers import ansilen, ansistrip, time_to_str

def percentile(vals:list[float], pct:float) -> float|None:
  if not vals: return None
  vals = sorted(vals)
  pos = (len(vals)-1) * pct / 100.0
  lo, hi = int(pos), min(int(pos)+1, len(vals)-1)
  return vals[lo] + (vals[hi] - vals[lo]) * (pos - lo)

def median(vals:list[float]) -> float|None: return percentile(vals, 50)

def fmt_time(ms:float|None) -> str: return "-" if ms is None else time_to_str(ms*1e-3, w=9)

def fmt_us(us:float|None) -> str:
  if us is None: return "-"
  return f"{us:.1f}us" if abs(us) < 1000 else f"{us/1000:.3f}ms"

def fmt_rate(v:float|None, unit:str) -> str:
  if v is None: return "-"
  if abs(v) >= 1e13: return f"{v*1e-12:.0f} T{unit}"
  if abs(v) >= 1e10: return f"{v*1e-9:.0f} G{unit}"
  return f"{v:.0f} {unit}"

def in_interval(intervals:list[tuple[float, float]], t:float) -> bool:
  # The profiler trace is small enough that a linear scan keeps this script simple.
  return any(st <= t <= en for st,en in intervals)

def is_sdma(dev:str, name:str) -> bool: return ":SDMA:" in dev or " -> " in name

def short(s:str, limit:int=44) -> str: return s[:limit] + " "*max(0, limit-ansilen(s[:limit]))

def print_group(label:str, rows:list[dict]) -> None:
  if not rows: return
  durs = [x["dur_ms"] for x in rows]
  flops = [x["flops"] for x in rows if x["flops"] is not None]
  mem = [x["mem"] for x in rows if x["mem"] is not None]
  gaps = [x["gap_us"] for x in rows if x["gap_us"] is not None]
  prev = collections.Counter(x["prev"] for x in rows if x["prev"] is not None).most_common(1)
  print(f"{short(label, 34)} {len(rows):7d} {fmt_time(median(durs))} {fmt_time(percentile(durs, 10))}/{fmt_time(percentile(durs, 90))} "
        f"{fmt_rate(median(flops), 'FLOPS'):>10s} {fmt_rate(median(mem), 'B/s mem'):>13s} {fmt_us(median(gaps)):>9s} "
        f"{(prev[0][0] if prev else '-')[:36]}")

def print_examples(title:str, rows:list[dict], limit:int) -> None:
  if limit <= 0 or not rows: return
  print(title)
  for x in rows[:limit]:
    print(f"  {x['st_ms']:10.3f} {x['dev'][:8]:>8s} {fmt_time(x['dur_ms'])} {fmt_rate(x['flops'], 'FLOPS'):>10s} "
          f"gap {fmt_us(x['gap_us']):>9s} prev {(x['prev'] or '-')[:52]}")

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="summarize occurrences of one kernel from tinygrad.viz.cli --json")
  parser.add_argument("kernel", type=str, help="kernel name to summarize")
  parser.add_argument("-n", "--limit", type=int, default=8, help="number of fastest/slowest occurrences to print (default: 8, <=0 for none)")
  parser.add_argument("--contains", action="store_true", help="match kernel as a substring instead of exactly")
  parser.add_argument("--gap-us", type=float, default=100.0, help="gap threshold for fast/slow grouping (default: 100us)")
  parser.add_argument("--marker-prefix", type=str, default=None, help="only use markers with this prefix for phase grouping")
  parser.add_argument("--include-sdma", action="store_true", help="include SDMA copy events when finding previous work")
  args = parser.parse_args()

  markers:list[tuple[str, float]] = []
  graphs:list[tuple[float, float]] = []
  events:list[dict] = []
  end_time = 0.0
  for line in sys.stdin:
    if not line.strip(): continue
    rec = json.loads(line)
    rec["name"] = ansistrip(str(rec.get("name", "")))
    dev, name = rec.get("device", ""), rec["name"]
    if dev == "MARKER":
      if args.marker_prefix is None or name.startswith(args.marker_prefix): markers.append((name, rec["st_ms"]))
    elif "dur_ms" in rec:
      end_time = max(end_time, rec["st_ms"] + rec["dur_ms"])
      if dev == "AMD Graph": graphs.append((rec["st_ms"], rec["st_ms"] + rec["dur_ms"]))
      elif args.include_sdma or not is_sdma(dev, name): events.append(rec)

  def matches(name:str) -> bool: return args.kernel in name if args.contains else args.kernel == name

  rows:list[dict] = []
  by_dev:dict[str, list[dict]] = collections.defaultdict(list)
  for rec in events: by_dev[rec.get("device", "")].append(rec)
  for dev, dev_events in by_dev.items():
    dev_events.sort(key=lambda x:x["st_ms"])
    prev:dict|None = None
    for rec in dev_events:
      if matches(rec["name"]):
        gap_us = (rec["st_ms"] - (prev["st_ms"] + prev["dur_ms"])) * 1000 if prev is not None else None
        rows.append({"st_ms":rec["st_ms"], "dur_ms":rec["dur_ms"], "dev":dev, "prev":prev["name"] if prev is not None else None,
                     "gap_us":gap_us, "in_graph":in_interval(graphs, rec["st_ms"]),
                     "flops":rec.get("fmt", {}).get("FLOPS"), "mem":rec.get("fmt", {}).get("B/s mem")})
      prev = rec

  if not rows: raise SystemExit(f"kernel {args.kernel!r} not found")
  rows.sort(key=lambda x:x["st_ms"])

  print(f"kernel {args.kernel!r}: {len(rows)} occurrences")
  print(f"{'group':34s} {'count':>7s} {'median':>9s} {'p10/p90':>19s} {'FLOPS':>10s} {'B/s mem':>13s} {'gap':>9s} prev")
  print_group("all", rows)
  if graphs:
    print_group("outside AMD Graph", [x for x in rows if not x["in_graph"]])
    print_group("inside AMD Graph", [x for x in rows if x["in_graph"]])
  print_group(f"gap > {args.gap_us:g}us", [x for x in rows if x["gap_us"] is not None and x["gap_us"] > args.gap_us])
  print_group(f"gap <= {args.gap_us:g}us", [x for x in rows if x["gap_us"] is not None and x["gap_us"] <= args.gap_us])

  if markers:
    markers.sort(key=lambda x:x[1])
    for i,(name,st) in enumerate(markers):
      en = markers[i+1][1] if i+1 < len(markers) else end_time
      print_group(f"{name} -> {markers[i+1][0] if i+1 < len(markers) else 'end'}", [x for x in rows if st <= x["st_ms"] < en])

  rows_with_flops = [x for x in rows if x["flops"] is not None]
  if rows_with_flops:
    print_examples("slowest", sorted(rows_with_flops, key=lambda x:x["flops"]), args.limit)
    print_examples("fastest", sorted(rows_with_flops, key=lambda x:x["flops"], reverse=True), args.limit)
  else:
    print_examples("longest", sorted(rows, key=lambda x:x["dur_ms"], reverse=True), args.limit)
    print_examples("shortest", sorted(rows, key=lambda x:x["dur_ms"]), args.limit)
