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
