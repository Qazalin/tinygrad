#!/usr/bin/env python3
import argparse, collections, json, pathlib, re, statistics, sys
sys.path.append(str(pathlib.Path(__file__).parents[2]))
from tinygrad.helpers import ansistrip

NEW_NAME = re.compile(
  r"\bhk_fp8_gemm_(?P<M>\d+)_(?P<N>\d+)_(?P<K>\d+)_m(?P<tile_m>\d+)_n(?P<tile_n>\d+)_k(?P<block_k>\d+)"
  r"_w(?P<num_warps>\d+)_wr(?P<warps_row>\d+)_wc(?P<warps_col>\d+)_wgm(?P<wgm>\d+)_mb(?P<min_blocks_per_cu>\d+)"
  r"_xcd(?P<xcd_swizzle>\d+)_sm(?P<scale_mode>\d+)\b")
OLD_NAME = re.compile(r"\bhk_fp8_gemm_(?P<M>\d+)_(?P<N>\d+)_(?P<K>\d+)_wgm(?P<wgm>\d+)_mb(?P<min_blocks_per_cu>\d+)_xcd(?P<xcd_swizzle>\d+)\b")
DEFAULTS = {"tile_m":"256", "tile_n":"256", "block_k":"128", "num_warps":"8", "warps_row":"2", "warps_col":"4", "scale_mode":"-"}
FIELDS = ["M", "N", "K", "tile_m", "tile_n", "block_k", "num_warps", "warps_row", "warps_col", "wgm", "xcd_swizzle",
          "min_blocks_per_cu", "scale_mode"]
RESOURCE_FIELDS = ["vgpr", "agpr", "scratch", "lds_bytes", "occupancy"]

def percentile(vals:list[float], pct:float) -> float:
  vals = sorted(vals)
  pos = (len(vals)-1) * pct / 100.0
  lo, hi = int(pos), min(int(pos)+1, len(vals)-1)
  return vals[lo] + (vals[hi] - vals[lo]) * (pos - lo)

def parse_name(name:str) -> dict[str, str]|None:
  if (m:=NEW_NAME.search(name)) is not None: return m.groupdict()
  if (m:=OLD_NAME.search(name)) is not None: return {**DEFAULTS, **m.groupdict()}
  return None

def row_key(row:dict[str, str]) -> tuple:
  return tuple(int(row[k]) if row[k] != "-" else -1 for k in FIELDS)

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Build an FP8 GEMM variant leaderboard from tinygrad.viz.cli --json")
  parser.add_argument("--csv", action="store_true", help="emit comma-separated rows instead of tab-separated rows")
  args = parser.parse_args()
  sep = "," if args.csv else "\t"

  groups:dict[tuple, dict] = {}
  for line in sys.stdin:
    if not line.strip(): continue
    rec = json.loads(line)
    dev, name = rec.get("device", ""), ansistrip(str(rec.get("name", "")))
    if not dev.startswith("AMD") or dev == "AMD Graph": continue
    parsed = parse_name(name)
    if parsed is None or "dur_ms" not in rec: continue
    key = row_key(parsed)
    group = groups.setdefault(key, {"attrs":parsed, "time_us":[], "tflops":[]})
    group["time_us"].append(float(rec["dur_ms"]) * 1000.0)
    if (flops:=rec.get("fmt", {}).get("FLOPS")) is not None: group["tflops"].append(float(flops) * 1e-12)

  header = FIELDS + ["time_us", "p10_us", "p90_us", "tflops", "count"] + RESOURCE_FIELDS
  print(sep.join(header))
  for _, group in sorted(groups.items()):
    attrs = group["attrs"]
    times, tflops = group["time_us"], group["tflops"]
    vals = [attrs[k] for k in FIELDS]
    vals += [f"{statistics.median(times):.3f}", f"{percentile(times, 10):.3f}", f"{percentile(times, 90):.3f}",
             f"{statistics.median(tflops):.3f}" if tflops else "-", str(len(times))]
    vals += ["-"] * len(RESOURCE_FIELDS)
    print(sep.join(vals))
