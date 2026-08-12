#!/usr/bin/env python3
"""Benchmark the concurrent P2P copy pattern used by an 8-device ALL2ALL graph.

Unlike bandwidth_test.py, this submits every directed device pair together in one
HCQ graph.  This exercises one copy queue per destination on every source device.

To capture a profile suitable for tinygrad.viz.cli:
  PROFILE=1 DEV=AMD python examples/tools/all2all_bandwidth_test.py
  python -m tinygrad.viz.cli --profile-path /tmp/profile.pkl.$USER --json > /tmp/all2all_bw.jsonl
"""
import gc, time

from tinygrad import Context, Device, Tensor, TinyJit, dtypes
from tinygrad.helpers import getenv, profile_marker

GPUS = getenv("GPUS", 8)
ITERS = getenv("ITERS", 5)
WARMUP = getenv("WARMUP", 3)
DEPTH = getenv("DEPTH", 4)
# Bytes copied by the dominant SDMA operations in the Llama training profile.
SIZES = tuple(int(x) for x in getenv("SIZES", "4194304,6291456,14680064,29360128,131334144,134217728").split(","))


def benchmark(size:int, devices:tuple[str, ...]) -> None:
  # Independent rounds keep every logical SDMA queue fed. A single round is too
  # shallow to reproduce the sustained queue contention in the training graph.
  sources = tuple(Tensor.empty(size, dtype=dtypes.uint8, device=dev).contiguous().realize() for _ in range(DEPTH) for dev in devices)

  @TinyJit
  def all_to_all(*srcs:Tensor) -> tuple[Tensor, ...]:
    # Realizing the tuple together captures all GPUS*(GPUS-1) copies in one linear schedule.
    return Tensor.realize(*(src.to(dst) for i,src in enumerate(srcs) for j,dst in enumerate(devices) if i % GPUS != j))

  times = []
  # ALL2ALL=1 matches MLPerf and enables one copy queue per destination.  Without it,
  # HCQ serializes every transfer from a source through SDMA:0, which is a different test.
  with Context(ALL2ALL=1, JIT_BATCH_SIZE=0):
    for iteration in range(WARMUP + ITERS):
      profile_marker(f"all2all {size} bytes @ {iteration}")
      st = time.perf_counter()
      outputs = all_to_all(*sources)
      for dev in devices: Device[dev].synchronize()
      elapsed = time.perf_counter() - st
      if iteration >= WARMUP:
        times.append(elapsed)
        aggregate_gbs = size * GPUS * (GPUS - 1) * DEPTH / elapsed / 1e9
        print(f"{size:>10d} bytes  iter {iteration-WARMUP+1}/{ITERS}: {elapsed*1e3:8.3f} ms  {aggregate_gbs:8.2f} GB/s aggregate")

  best, average = min(times), sum(times) / len(times)
  print(f"{size:>10d} bytes  best {best*1e3:8.3f} ms  avg {average*1e3:8.3f} ms  "
        f"best aggregate {size*GPUS*(GPUS-1)*DEPTH/best/1e9:8.2f} GB/s")
  del outputs, sources, all_to_all
  gc.collect()


if __name__ == "__main__":
  assert GPUS > 1
  devices = tuple(f"{Device.DEFAULT}:{i}" for i in range(GPUS))
  interfaces = tuple(type(Device[dev].iface).__name__ for dev in devices)
  print(f"devices={devices} interfaces={interfaces} sizes={SIZES} depth={DEPTH} warmup={WARMUP} iters={ITERS} "
        f"HCQ_NUM_SDMA={getenv('HCQ_NUM_SDMA', 'auto')}")
  for size in SIZES: benchmark(size, devices)
  profile_marker("all2all benchmark complete")
