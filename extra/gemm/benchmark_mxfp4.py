#!/usr/bin/env python3
import argparse, csv, statistics, sys, time

from tinygrad import Context, Device, GlobalCounters, Tensor, dtypes
from tinygrad.engine.realize import run_linear

from extra.gemm.mxfp4 import mxfp4_gemm, mxfp4_gemm_preshuffled, shuffle_mxfp4_scales, shuffle_mxfp4_weight


OFFICIAL_SHAPES = (
  (4096, 4096, 16384),
  (6144, 4096, 16384),
  (16384, 4096, 4096),
  (16384, 4096, 6144),
  (16384, 4096, 14336),
  (16384, 4096, 28672),
  (28672, 4096, 16384),
  (16384, 6144, 4096),
  (4096, 14336, 16384),
  (16384, 14336, 4096),
  (16384, 28672, 4096),
)


def parse_shape(value:str) -> tuple[int, int, int]:
  try:
    shape = tuple(int(x) for x in value.lower().replace("x", ",").split(","))
  except ValueError as exc:
    raise argparse.ArgumentTypeError(f"invalid shape {value!r}") from exc
  if len(shape) != 3 or any(x <= 0 for x in shape):
    raise argparse.ArgumentTypeError("shape must be M,N,K with positive integers")
  return shape  # type: ignore[return-value]


def benchmark(M:int, N:int, K:int, warmup:int, warmup_seconds:float, repeat:int, preshuffle_b:bool) -> dict[str, float | int | str]:
  assert M % 16 == N % 16 == K % 128 == 0
  device = Device.DEFAULT
  a = Tensor.empty(M, K // 2, dtype=dtypes.uint8, device=device).realize()
  b = Tensor.empty(N, K // 2, dtype=dtypes.uint8, device=device).realize()
  if preshuffle_b: b = shuffle_mxfp4_weight(b).realize()
  scale_a = Tensor.full((M, K // 32), 127, dtype=dtypes.uint8, device=device).realize()
  scale_b = Tensor.full((N, K // 32), 127, dtype=dtypes.uint8, device=device).realize()
  if preshuffle_b:
    scale_a, scale_b = shuffle_mxfp4_scales(scale_a).realize(), shuffle_mxfp4_scales(scale_b).realize()
  linear = (mxfp4_gemm_preshuffled if preshuffle_b else mxfp4_gemm)(a, b, scale_a, scale_b).schedule_linear()

  with Context(DEBUG=0):
    for _ in range(warmup): run_linear(linear, wait=True)
    warmup_start = time.perf_counter()
    while time.perf_counter() - warmup_start < warmup_seconds: run_linear(linear, wait=True)
    times = []
    for _ in range(repeat):
      GlobalCounters.reset()
      run_linear(linear, wait=True)
      times.append(GlobalCounters.time_sum_s)

  median_s = statistics.median(times)
  best_s = min(times)
  return {
    "device": device, "M": M, "N": N, "K": K,
    "median_ms": median_s * 1e3, "best_ms": best_s * 1e3,
    "median_tflops": 2 * M * N * K / median_s * 1e-12,
    "best_tflops": 2 * M * N * K / best_s * 1e-12,
  }


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Benchmark the native Thunder MXFP4 ABt GEMM")
  parser.add_argument("shapes", nargs="*", type=parse_shape, help="M,N,K (or MxNxK); defaults to AMD's submitted shapes")
  parser.add_argument("--warmup", type=int, default=3)
  parser.add_argument("--warmup-seconds", type=float, default=0.25, help="additional steady-state warmup duration")
  parser.add_argument("--repeat", type=int, default=7)
  parser.add_argument("--csv", action="store_true", help="write CSV instead of a table")
  parser.add_argument("--amd-baseline", help="AMD shape-baseline CSV with M,N,K and rocprof_tflops columns")
  parser.add_argument("--preshuffle-b", action="store_true", help="benchmark AMD's physical B layout")
  args = parser.parse_args()

  shapes = args.shapes or OFFICIAL_SHAPES
  amd = {}
  if args.amd_baseline:
    with open(args.amd_baseline, newline="") as f:
      amd = {(int(r["M"]), int(r["N"]), int(r["K"])): float(r["rocprof_tflops"]) for r in csv.DictReader(f)}
  rows = []
  for shape in shapes:
    row = benchmark(*shape, args.warmup, args.warmup_seconds, args.repeat, args.preshuffle_b)
    if shape in amd:
      row["amd_tflops"] = amd[shape]
      row["amd_pct"] = float(row["median_tflops"]) / amd[shape] * 100
    rows.append(row)
    if not args.csv:
      comparison = f"  baseline {row['amd_pct']:5.1f}%" if "amd_pct" in row else ""
      print(f"{row['M']:5d} {row['N']:5d} {row['K']:5d}  "
            f"{row['median_ms']:9.3f} ms  {row['median_tflops']:8.2f} TFLOPS "
            f"(best {row['best_tflops']:8.2f}){comparison}", flush=True)
  if args.csv:
    writer = csv.DictWriter(sys.stdout, fieldnames=rows[0].keys())
    writer.writeheader()
    writer.writerows(rows)
