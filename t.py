import json, os, pickle

import tinygrad.viz.serve as viz
from extra.viz.cli import decode_profile
from tinygrad.helpers import ansistrip


START_MARKER = os.getenv("START_MARKER", "train @ 2")
END_MARKER = os.getenv("END_MARKER", "train @ 3")
SRC_NAME = os.getenv("SRC", "AMD")
TOPK = int(os.getenv("TOPK", "30"))
DISCOVERY_TOPN = int(os.getenv("DISCOVERY_TOPN", "60"))


def load_or_build_sources() -> dict[str, tuple[str | None, str | None]]:
  if os.path.exists("sources.txt"):
    with open("sources.txt", "r") as f:
      return json.load(f)

  with open("rewrites.pkl", "rb") as f:
    trace = pickle.load(f)
  viz.load_rewrites(data := viz.VizData(trace))
  sources: dict[str, tuple[str | None, str | None]] = {}
  for i, c in enumerate(data.ctxs):
    name = ansistrip(c["name"])
    src, ast = None, None
    for j, s in enumerate(c["steps"]):
      if s["name"] == "View Base AST":
        ast = viz._reconstruct(data, trace.rewrites[i][j].sink).pyrender()
      if s["name"] == "View Source":
        src = s["data"]
    if src is None and ast is None:
      continue
    sources[name] = (src, ast)

  with open("sources.txt", "w") as f:
    json.dump(sources, f)
  return sources


def load_or_build_items() -> list[tuple[str, tuple[float, int]]]:
  if os.path.exists("items.txt"):
    with open("items.txt", "r") as f:
      return json.load(f)

  data = viz.VizData()
  with open("profile.pkl", "rb") as f:
    profile = pickle.load(f)
  ret = decode_profile(viz.get_profile(data, profile))

  markers = {m["name"]: m["ts"] for m in ret["markers"]}
  if START_MARKER not in markers or END_MARKER not in markers:
    raise RuntimeError(f"missing marker(s): start={START_MARKER!r}, end={END_MARKER!r}")

  events = [
    e for e in ret["layout"][SRC_NAME]["events"]
    if markers[START_MARKER] <= e["st"] <= markers[END_MARKER]
  ]

  agg: dict[str, tuple[float, int]] = {}
  for e in events:
    et = e["dur"] * 1e-6
    t, c = agg.get(e["name"], (0.0, 0))
    agg[e["name"]] = (t + et, c + 1)

  items = sorted(agg.items(), key=lambda kv: kv[1][0], reverse=True)
  with open("items.txt", "w") as f:
    json.dump(items, f)
  return items


def classify_kernel(name: str) -> str:
  if name.startswith("custom_fa_"):
    return "attention"
  if name.startswith("hk_fp8_gemm_") or name.startswith("gemm_"):
    return "gemm"
  if name.startswith("kitten_"):
    return "fp8_cast_amax"
  if name.startswith("E_") or name.startswith("En"):
    return "elementwise_misc"
  return "other"


def notes_and_refs(name: str, bucket: str) -> tuple[str, str]:
  if name.startswith("custom_fa_"):
    refs = ", ".join([
      "examples/mlperf/models/flat_llama.py:131",
      "examples/mlperf/models/flat_llama.py:133",
      "examples/mlperf/models/flat_llama.py:163",
    ])
    note = "Flash-attention kernel from attention path; dominant per-call latency in sequence attention."
    return refs, note
  if name.startswith("hk_fp8_gemm_"):
    refs = ", ".join([
      "examples/mlperf/models/flat_llama.py:33",
      "examples/mlperf/models/flat_llama.py:44",
      "examples/mlperf/models/flat_llama.py:120",
      "examples/mlperf/models/flat_llama.py:152",
      "examples/mlperf/models/flat_llama.py:158",
    ])
    note = "FP8 GEMM from matmul path used in attention and FFN projections."
    return refs, note
  if name.startswith("gemm_"):
    refs = ", ".join([
      "examples/mlperf/models/flat_llama.py:33",
      "examples/mlperf/models/flat_llama.py:38",
      "examples/mlperf/models/flat_llama.py:217",
    ])
    note = "Large GEMM in non-FP8/fallback path; very expensive per call, low launch count."
    return refs, note
  if name.startswith("kitten_"):
    refs = ", ".join([
      "examples/mlperf/models/flat_llama.py:26",
      "examples/mlperf/models/flat_llama.py:39",
      "examples/mlperf/models/flat_llama.py:40",
      "examples/mlperf/models/flat_llama.py:202",
      "examples/mlperf/models/flat_llama.py:215",
    ])
    note = "FP8 quantize/cast/amax maintenance around projection inputs and weights."
    return refs, note
  if bucket == "elementwise_misc":
    refs = ", ".join([
      "examples/mlperf/models/flat_llama.py:47",
      "examples/mlperf/models/flat_llama.py:148",
      "examples/mlperf/models/flat_llama.py:158",
      "examples/mlperf/models/flat_llama.py:172",
      "examples/mlperf/models/flat_llama.py:176",
    ])
    note = "Elementwise/reduction kernel from RMSNorm, activations, and residual combines."
    return refs, note
  refs = ", ".join([
    "examples/mlperf/model_train.py:1513",
    "examples/mlperf/model_train.py:1518",
    "examples/mlperf/model_train.py:1531",
  ])
  note = "Kernel in train-step execution window; inspect source+AST for direct op mapping."
  return refs, note


def source_signature(src: str | None) -> str:
  if src is None:
    return ""
  for ln in src.splitlines():
    s = ln.strip()
    if s.startswith("extern \"C\"") and "void" in s:
      return s
  return src.splitlines()[0].strip() if src.splitlines() else ""


def write_topk_reports(items, sources) -> None:
  total_time = sum(v[0] for _, v in items)
  top = items[:TOPK]

  top_rows = []
  buckets: dict[str, float] = {}
  for rank, (name, (time_s, count)) in enumerate(top, start=1):
    bucket = classify_kernel(name)
    buckets[bucket] = buckets.get(bucket, 0.0) + time_s
    src, ast = sources.get(name, (None, None))
    top_rows.append({
      "rank": rank,
      "name": name,
      "total_ms": time_s * 1e3,
      "share_pct": (time_s / total_time) * 100 if total_time else 0.0,
      "count": count,
      "avg_us": (time_s / count) * 1e6 if count else 0.0,
      "bucket": bucket,
      "has_source": src is not None,
      "has_ast": ast is not None,
      "source": src,
      "ast": ast,
    })

  out = {
    "window": {"start": START_MARKER, "end": END_MARKER, "src": SRC_NAME},
    "totals": {
      "unique_kernels": len(items),
      "total_time_s": total_time,
      "topk": TOPK,
      "topk_time_s": sum(x[1][0] for x in top),
      "topk_share_pct": (sum(x[1][0] for x in top) / total_time) * 100 if total_time else 0.0,
    },
    "bucket_time_s": buckets,
    "top_kernels": top_rows,
  }

  with open("top_kernels_step2.json", "w") as f:
    json.dump(out, f, indent=2)

  lines = [
    f"window: {START_MARKER} -> {END_MARKER} ({SRC_NAME})",
    f"total_time_s: {total_time:.6f}",
    f"unique_kernels: {len(items)}",
    f"top{TOPK}_time_s: {out['totals']['topk_time_s']:.6f}",
    f"top{TOPK}_share_pct: {out['totals']['topk_share_pct']:.2f}",
    "",
    "rank\tname\ttotal_ms\tshare_pct\tcount\tavg_us\tbucket",
  ]
  for row in top_rows:
    lines.append(
      f"{row['rank']}\t{row['name']}\t{row['total_ms']:.3f}\t{row['share_pct']:.2f}\t{row['count']}\t{row['avg_us']:.2f}\t{row['bucket']}"
    )
  lines.append("")
  lines.append("bucket_time_s:")
  for k, v in sorted(buckets.items(), key=lambda kv: kv[1], reverse=True):
    lines.append(f"{k}: {v:.6f}")

  with open("top_kernels_step2.txt", "w") as f:
    f.write("\n".join(lines))


def write_discovery(items, sources) -> None:
  total_time = sum(v[0] for _, v in items)
  top = items[:DISCOVERY_TOPN]
  top30_time = sum(v[0] for _, v in items[:30])
  next30_time = sum(v[0] for _, v in items[30:60])

  lines = [
    "# Step-2 kernel discovery",
    f"Window: {START_MARKER} -> {END_MARKER} ({SRC_NAME})",
    f"Total step time (aggregated): {total_time:.6f} s",
    f"Unique kernels: {len(items)}",
    f"Top 30 time: {top30_time:.6f} s ({(top30_time/total_time*100 if total_time else 0):.2f}%)",
    f"Ranks 31-60 time: {next30_time:.6f} s ({(next30_time/total_time*100 if total_time else 0):.2f}%)",
    "",
    "## Table (top 60)",
    "| rank | kernel | total_ms | share_pct | count | avg_us | bucket | flat_llama refs | note |",
    "| ---: | :----- | -------: | --------: | ----: | -----: | :----- | :------------- | :--- |",
  ]

  for rank, (name, (time_s, count)) in enumerate(top, start=1):
    bucket = classify_kernel(name)
    refs, note = notes_and_refs(name, bucket)
    lines.append(
      f"| {rank} | `{name}` | {time_s*1e3:.3f} | {(time_s/total_time*100 if total_time else 0):.2f} | {count} | {(time_s/count*1e6 if count else 0):.2f} | {bucket} | {refs} | {note} |"
    )

  lines.extend([
    "",
    "## Source signatures for ranks 1-60",
    "(From `sources.txt`; useful for exact kernel identity checks.)",
  ])
  for rank, (name, _) in enumerate(top, start=1):
    src = sources.get(name, (None, None))[0]
    lines.append(f"- {rank}. `{name}`: {source_signature(src)}")

  with open("discovery.txt", "w") as f:
    f.write("\n".join(lines))


sources = load_or_build_sources()
items = load_or_build_items()
write_topk_reports(items, sources)
write_discovery(items, sources)
