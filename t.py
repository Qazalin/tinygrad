import pickle, json, os
import tinygrad.viz.serve as viz
from extra.viz.cli import decode_profile
from tinygrad.helpers import ansistrip, time_to_str


if not os.path.exists("sources.txt"):
  with open("rewrites.pkl", "rb") as f: trace = pickle.load(f)
  viz.load_rewrites(data:=viz.VizData(trace))
  sources = {}
  for i,c in enumerate(data.ctxs):
    name = ansistrip(c["name"])
    src, ast = None, None
    for j,s in enumerate(c["steps"]):
      if s["name"] == "View Base AST": ast = viz._reconstruct(data, trace.rewrites[i][j].sink).pyrender()
      if s["name"] == "View Source": src = s["data"]
    if src is None and ast is None: continue
    sources[name] = (src, ast)
  with open("sources.txt", "w") as f: json.dump(sources, f)

if not os.path.exists("items.txt"):
  data = viz.VizData()
  with open("profile.pkl", "rb") as f: profile = pickle.load(f)
  ret = decode_profile(viz.get_profile(data, profile))
  print(ret["markers"])

  markers = {m["name"]:m["ts"] for m in ret["markers"]}
  amd = ret["layout"]["AMD"]["events"]
  events = []
  for e in amd:
    if e["st"] >= markers["train @ 2"] and e["st"] <= markers["train @ 3"]:
      events.append(e)
  agg:dict[str, tuple[float, int]] = {}
  total = 0
  for e in events:
    et = e["dur"] * 1e-6
    t, c = agg.get(e["name"], (0.0, 0))
    agg[e["name"]] = (t+et, c+1)
    total += et
  if agg and total > 0:
    from tabulate import tabulate
    items = sorted(agg.items(), key=lambda kv:kv[1][0], reverse=True)
    with open("./items.txt", "w") as f:
      json.dump(items, f)
