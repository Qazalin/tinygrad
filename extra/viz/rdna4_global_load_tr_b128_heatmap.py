#!/usr/bin/env python3
import argparse
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np


def load_result(path: Path) -> np.ndarray:
  data = np.fromfile(path, dtype=np.float16)
  if data.size != 256:
    raise ValueError(f"expected 256 float16 values in {path}, got {data.size}")
  return data.reshape(16, 16)


def draw_heatmap(ax: plt.Axes, data: np.ndarray, title: str) -> None:
  im = ax.imshow(data, cmap="turbo", interpolation="nearest", origin="upper")
  ax.set_title(title, color="#f5f5f5", pad=12)
  ax.set_xticks(range(16))
  ax.set_yticks(range(16))
  ax.set_xticklabels(range(16), color="#cfcfcf", fontsize=8)
  ax.set_yticklabels(range(16), color="#cfcfcf", fontsize=8)
  ax.set_xticks(np.arange(-0.5, 16, 1), minor=True)
  ax.set_yticks(np.arange(-0.5, 16, 1), minor=True)
  ax.grid(which="minor", color="#1f1f1f", linestyle="-", linewidth=1)
  ax.tick_params(which="minor", bottom=False, left=False)

  for row in range(data.shape[0]):
    for col in range(data.shape[1]):
      value = int(data[row, col])
      text_color = "#101010" if value > 96 else "#f7f7f7"
      ax.text(col, row, f"{value}", ha="center", va="center", fontsize=7, color=text_color)

  return im


def main() -> None:
  parser = argparse.ArgumentParser(description="Visualize RDNA4 global_load_tr_b128 source vs result.")
  parser.add_argument("--result", type=Path, default=Path("result.dat"), help="Raw float16 dump from the test")
  parser.add_argument("--output", type=Path, default=Path("rdna4_global_load_tr_b128_heatmap.png"), help="PNG output path")
  args = parser.parse_args()

  source = np.arange(256, dtype=np.float16).reshape(16, 16)
  result = load_result(args.result)

  plt.style.use("dark_background")
  fig, axes = plt.subplots(1, 2, figsize=(16, 8), constrained_layout=True)
  fig.patch.set_facecolor("#0b0f14")

  im0 = draw_heatmap(axes[0], source, "Test Input Matrix (16x16 row-major)")
  im1 = draw_heatmap(axes[1], result, "Observed result.dat Layout (16x16 view)")

  cbar0 = fig.colorbar(im0, ax=axes[0], fraction=0.046, pad=0.04)
  cbar1 = fig.colorbar(im1, ax=axes[1], fraction=0.046, pad=0.04)
  for cbar in (cbar0, cbar1):
    cbar.ax.yaxis.set_tick_params(color="#cfcfcf")
    plt.setp(cbar.ax.get_yticklabels(), color="#cfcfcf")

  fig.suptitle("RDNA4 global_load_tr_b128: source matrix vs captured output", color="#f5f5f5", fontsize=16)
  args.output.parent.mkdir(parents=True, exist_ok=True)
  fig.savefig(args.output, dpi=200, facecolor=fig.get_facecolor())
  print(f"wrote {args.output}")


if __name__ == "__main__":
  main()
