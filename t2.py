import json
import os
import pickle

import matplotlib
import tinygrad.viz.serve as viz
from extra.viz.cli import decode_profile

matplotlib.use("Agg")
import matplotlib.pyplot as plt

START_MARKER = os.getenv("START_MARKER", "train @ 2")
END_MARKER = os.getenv("END_MARKER", "train @ 3")
SRC_NAME = os.getenv("SRC", "AMD")
TOPN = int(os.getenv("TOPN", "50"))
BAR_WIDTH = int(os.getenv("BAR_WIDTH", "50"))
PLOT_PATH = os.getenv("PLOT_PATH", "kernel_count_distribution_step2.png")


def load_events() -> list[dict]:
  data = viz.VizData()
  with open("profile.pkl", "rb") as f:
    profile = pickle.load(f)
  ret = decode_profile(viz.get_profile(data, profile))

  markers = {m["name"]: m["ts"] for m in ret["markers"]}
  if START_MARKER not in markers or END_MARKER not in markers:
    raise RuntimeError(f"missing marker(s): start={START_MARKER!r}, end={END_MARKER!r}")

  st, en = markers[START_MARKER], markers[END_MARKER]
  return [e for e in ret["layout"][SRC_NAME]["events"] if st <= e["st"] <= en]


def main() -> None:
  events = load_events()

  agg: dict[str, tuple[int, float]] = {}
  for e in events:
    name = e["name"]
    dur_s = e["dur"] * 1e-6
    count, total_s = agg.get(name, (0, 0.0))
    agg[name] = (count + 1, total_s + dur_s)

  unique_kernels = len(agg)
  total_calls = sum(count for count, _ in agg.values())
  ranked_by_count = sorted(agg.items(), key=lambda kv: kv[1][0], reverse=True)

  print(f"window: {START_MARKER} -> {END_MARKER} ({SRC_NAME})")
  print(f"unique_kernels_total: {unique_kernels}")
  print(f"total_kernel_calls: {total_calls}")
  print("")
  print("rank\tkernel\tcount\ttotal_ms\tavg_us")
  for i, (name, (count, total_s)) in enumerate(ranked_by_count[:TOPN], start=1):
    avg_us = (total_s / count) * 1e6 if count else 0.0
    print(f"{i}\t{name}\t{count}\t{total_s*1e3:.3f}\t{avg_us:.2f}")

  print("")
  print(f"call-count distribution (top {TOPN})")
  print("rank kernel                              count   pct_of_calls  bar")
  max_count = ranked_by_count[0][1][0] if ranked_by_count else 0
  lines = []
  for i, (name, (count, _)) in enumerate(ranked_by_count[:TOPN], start=1):
    pct = (count / total_calls) * 100 if total_calls else 0.0
    bar_len = int((count / max_count) * BAR_WIDTH) if max_count else 0
    bar = "#" * max(bar_len, 1)
    row = f"{i:>4} {name[:34]:<34} {count:>7} {pct:>12.2f}%  {bar}"
    print(row)
    lines.append(row)

  with open("kernel_count_distribution_step2.txt", "w") as f:
    f.write("\n".join(lines) + "\n")

  # matplotlib chart (top TOPN by call count)
  top = ranked_by_count[:TOPN]
  names = [name for name, _ in top]
  counts = [count for _, (count, _) in top]
  labels = [f"{i}: {n}" for i, n in enumerate(names, start=1)]

  fig_h = max(6, min(18, 0.35 * len(labels) + 2))
  fig, ax = plt.subplots(figsize=(14, fig_h))
  bars = ax.barh(range(len(labels)), counts)
  ax.set_yticks(range(len(labels)))
  ax.set_yticklabels(labels, fontsize=8)
  ax.invert_yaxis()
  ax.set_xlabel("Call count")
  ax.set_title(f"Kernel call-count distribution ({START_MARKER} -> {END_MARKER}, {SRC_NAME})")
  ax.grid(axis="x", linestyle="--", alpha=0.3)

  for bar, count in zip(bars, counts):
    ax.text(bar.get_width(), bar.get_y() + bar.get_height() / 2, f" {count}", va="center", fontsize=8)

  fig.tight_layout()
  fig.savefig(PLOT_PATH, dpi=180)
  plt.close(fig)
  print(f"saved_plot: {PLOT_PATH}")

  out = {
    "window": {"start": START_MARKER, "end": END_MARKER, "src": SRC_NAME},
    "unique_kernels_total": unique_kernels,
    "total_kernel_calls": total_calls,
    "ranked_by_count": [
      {
        "rank": i,
        "name": name,
        "count": count,
        "total_s": total_s,
        "avg_us": (total_s / count) * 1e6 if count else 0.0,
      }
      for i, (name, (count, total_s)) in enumerate(ranked_by_count, start=1)
    ],
  }
  with open("kernel_counts_step2.json", "w") as f:
    json.dump(out, f, indent=2)


if __name__ == "__main__":
  main()
