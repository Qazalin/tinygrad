#!/usr/bin/env python3
"""Staged GPU validation for the Phase-2 8-wave MXFP4 kernel.

Run probes one at a time after a device reset if a previous probe faults:
  DEV=AMD PYTHONPATH=. python extra/gemm/cdna_lib/test_phase2_gpu.py --probe barrier
  DEV=AMD PYTHONPATH=. python extra/gemm/cdna_lib/test_phase2_gpu.py --probe store
  DEV=AMD PYTHONPATH=. python extra/gemm/cdna_lib/test_phase2_gpu.py --probe load
  DEV=AMD PYTHONPATH=. python extra/gemm/cdna_lib/test_phase2_gpu.py --probe full

Only `full` performs correctness + performance. The preceding probes isolate 512-thread/barrier,
C-store addressing, and input/LDS addressing respectively.
"""
import argparse, math, statistics
import numpy as np
from tinygrad import Context, Device, GlobalCounters, Tensor, dtypes
from tinygrad.engine.realize import compile_linear, run_linear

from extra.gemm.cdna_lib.bench_mxfp4 import launch_tensor, make_empty_quantized
from extra.gemm.cdna_lib.mxfp4 import build_kernel
from extra.gemm.cdna_lib.resources import scan_resources
from extra.llama_kernels.quantize_mxfp4 import quantize_mxfp4

PEAK = 9.2e15
VARIANTS = ("reference", "wgm16", "phase2_8w")


def _empty_inputs(device: str, M: int = 256):
  return make_empty_quantized(M, 4096, 4096, device)


def probe(device: str, kind: str) -> None:
  M, N, K = 256, 4096, 4096
  v = f"phase2_8w_{kind}"
  bufs = _empty_inputs(device, M)
  print(f"probe {kind}: {M}x{N}x{K} {v}")
  out = launch_tensor(bufs.a_q, bufs.b_q, bufs.scale_a, bufs.scale_b, v).realize()
  Device[device].synchronize()
  if kind in ("store", "acczero"):
    got = out.numpy()
    if not np.all(got == 0):
      raise AssertionError(f"{kind} probe completed but output is not all zero: nonzero={np.count_nonzero(got)} "
                           f"nan={np.count_nonzero(np.isnan(got.astype(np.float32)))}")
  if kind == "waveid_raw":
    got = out.numpy().astype(np.float32).reshape(-1)
    exp = np.concatenate([np.full(128, float(w+1), dtype=np.float32) for w in range(8)])
    if not np.array_equal(got[:1024], exp):
      neq = got[:1024] != exp
      i = int(np.flatnonzero(neq)[0])
      runs = [got[w*128:(w+1)*128].copy() for w in range(8)]
      summary = [(float(x[0]), int(np.count_nonzero(x != x[0]))) for x in runs]
      raise AssertionError(f"waveid_raw mismatch: mismatches={np.count_nonzero(neq)} first_flat={i} "
                           f"got={got[i]} expected={exp[i]} runs(first,nonuniform)={summary}")
  if kind in ("wavefill", "accscalar", "accscalar128", "accscalar252", "accwave", "accwave128", "accwave252"):
    got = out.numpy().astype(np.float32)
    exp = np.empty_like(got)
    # wave_id = wave_m*4 + wave_n. Each wave owns 128 rows x 64 cols, repeated
    # over each 256-column workgroup tile. The probe writes float(wave_id+1).
    for wm in range(2):
      for nt in range(16):
        for wn in range(4):
          exp[0, wm*128:(wm+1)*128, nt*256+wn*64:nt*256+(wn+1)*64] = float(wm*4 + wn + 1)
    neq = got != exp
    if np.any(neq):
      idx = tuple(np.argwhere(neq)[0])
      raise AssertionError(f"{kind} probe mismatch: mismatches={np.count_nonzero(neq)} first={idx} "
                           f"got={got[idx]} expected={exp[idx]}" + _mismatch_report(got, exp))
  print(f"  {kind}: PASS")


def _mismatch_report(got: np.ndarray, ref: np.ndarray) -> str:
  neq = got != ref
  # Output shape is (1,M,N). Report mismatch count by 128-row cohort and 256-col WG tile,
  # plus the first row split into 64-col wave_n slices. This distinguishes wave_m / n_tile / wave_n bugs.
  blocks = []
  for wm in range(2):
    row = []
    for nt in range(16):
      row.append(int(np.count_nonzero(neq[0, wm*128:(wm+1)*128, nt*256:(nt+1)*256])))
    blocks.append(row)
  row0 = [int(np.count_nonzero(neq[0, 0, x*64:(x+1)*64])) for x in range(64)]
  return f"\n  mismatch 128x256 blocks wm0={blocks[0]}\n  mismatch 128x256 blocks wm1={blocks[1]}\n  row0 64-col slices={row0}"


def correctness(device: str, variant: str = "phase2_8w") -> None:
  M, N, K = 256, 4096, 4096
  print(f"correctness {M}x{N}x{K} {variant}")
  Tensor.manual_seed(20260822)
  a = (Tensor.randn(M, K, device=device) * 0.25).cast(dtypes.bfloat16).realize()
  b = (Tensor.randn(N, K, device=device) * 0.25).cast(dtypes.bfloat16).realize()
  a_q, sa, _, _ = quantize_mxfp4(a, shuffle_col=True)
  b_q, sb, _, _ = quantize_mxfp4(b, shuffle_row=True, shuffle_col=True)
  Tensor.realize(a_q, sa, b_q, sb)
  ref = launch_tensor(a_q, b_q, sa, sb, "reference").realize().numpy()
  got = launch_tensor(a_q, b_q, sa, sb, variant).realize().numpy()
  if not np.array_equal(got, ref):
    neq = got != ref
    diff = got.astype(np.float32) - ref.astype(np.float32)
    idx = np.argwhere(neq)
    first = tuple(idx[0]) if len(idx) else None
    finite = np.abs(diff[np.isfinite(diff)])
    max_abs = float(np.max(finite)) if finite.size else float("nan")
    raise AssertionError(f"{variant} mismatch: mismatches={np.count_nonzero(neq)} max_abs_finite={max_abs} "
                         f"nan_got={np.count_nonzero(np.isnan(got.astype(np.float32)))} first={first} "
                         f"got={got[first] if first else None} ref={ref[first] if first else None}" + _mismatch_report(got, ref))
  print(f"  {variant}: bit-identical to reference")


def one_run(compiled) -> float:
  st = GlobalCounters.time_sum_s
  run_linear(compiled)
  return GlobalCounters.time_sum_s - st


def benchmark(device: str, rounds: int = 8, per_round: int = 31) -> None:
  M, N, K = 16384, 4096, 4096
  bufs = make_empty_quantized(M, N, K, device)
  compiled = {v: compile_linear(launch_tensor(bufs.a_q, bufs.b_q, bufs.scale_a, bufs.scale_b, v).schedule_linear()) for v in VARIANTS}
  samples = {v: [] for v in VARIANTS}
  round_bests = {v: [] for v in VARIANTS}

  with Context(DEBUG=2):
    for v in VARIANTS:
      for _ in range(10): one_run(compiled[v])
    for r in range(rounds):
      order = VARIANTS[r % len(VARIANTS):] + VARIANTS[:r % len(VARIANTS)]
      print(f"round {r+1}/{rounds}: {' '.join(order)}")
      for v in order:
        rs = [one_run(compiled[v]) for _ in range(per_round)]
        samples[v].extend(rs)
        round_bests[v].append(min(rs))

  flops = 2*M*N*K
  print("\nPhase-2 target 16384x4096x4096")
  for v in VARIANTS:
    xs = sorted(samples[v])
    best = xs[0]
    p10 = xs[max(0, math.ceil(0.10*len(xs))-1)]
    med = statistics.median(xs)
    rb = statistics.median(round_bests[v])
    pf = flops / best / 1e15
    mfu = 100 * flops / best / PEAK
    res = scan_resources(build_kernel(M, N, K, 256, 256, v))
    print(f"{v:12s} best={best*1e6:8.2f}us p10={p10*1e6:8.2f}us median={med*1e6:8.2f}us "
          f"round-best-med={rb*1e6:8.2f}us  best={pf:6.3f} PF/s {mfu:5.1f}% MFU  {res.one_line()}")


def triage(device: str) -> None:
  """Phase-2 v8: prove wave identity first, then tiled ownership, then ACC/MFMA."""
  results = {}
  for name in ("waveid_raw", "wavefill"):
    try:
      probe(device, name)
      results[name] = "PASS"
    except AssertionError as e:
      results[name] = "FAIL"
      print(f"\n{name}: FAIL\n{e}\n")
      print("Phase-2 v8 triage: " + "  ".join(f"{k}={v}" for k,v in results.items()))
      return

  # Once plain-VGPR wave ownership is correct, test the only viable 8-wave ACC split.
  try:
    probe(device, "accwave128")
    results["accwave128"] = "PASS"
  except AssertionError as e:
    results["accwave128"] = "FAIL"
    print(f"\naccwave128: FAIL\n{e}\n")
    print("Phase-2 v8 triage: " + "  ".join(f"{k}={v}" for k,v in results.items()))
    return

  try:
    correctness(device, "phase2_8w_acc128")
    results["acc128"] = "PASS"
  except AssertionError as e:
    results["acc128"] = "FAIL"
    print(f"\nacc128: FAIL\n{e}\n")
  print("Phase-2 v8 triage: " + "  ".join(f"{k}={v}" for k,v in results.items()))


def main() -> None:
  ap = argparse.ArgumentParser()
  ap.add_argument("--probe", choices=("barrier", "store", "load", "acczero", "waveid_raw", "wavefill", "accscalar", "accscalar128", "accscalar252", "accwave", "accwave128", "accwave252", "acc128", "acc252", "refregs", "refgap", "nop7", "postgap", "triage", "full"), default="barrier")
  ap.add_argument("--rounds", type=int, default=8)
  ap.add_argument("--per-round", type=int, default=31)
  args = ap.parse_args()

  dev = Device[Device.DEFAULT]
  arch = dev.renderer.target.arch
  if not arch.startswith("gfx950") or Device.DEFAULT.startswith("NULL"):
    raise RuntimeError(f"run this test on an actual gfx950 AMD device, got {Device.DEFAULT} {arch}")
  device = Device.DEFAULT

  if args.probe == "triage":
    triage(device)
    return
  if args.probe in ("barrier", "store", "load", "acczero", "waveid_raw", "wavefill", "accscalar", "accscalar128", "accscalar252", "accwave", "accwave128", "accwave252"):
    probe(device, args.probe)
    return
  if args.probe == "acc128":
    correctness(device, "phase2_8w_acc128")
    return
  if args.probe == "acc252":
    correctness(device, "phase2_8w_acc252")
    return
  if args.probe == "refregs":
    correctness(device, "phase2_8w_refregs")
    return
  if args.probe == "refgap":
    correctness(device, "phase2_8w_refgap")
    return
  if args.probe == "nop7":
    correctness(device, "phase2_8w_nop7")
    return
  if args.probe == "postgap":
    correctness(device, "phase2_8w_postgap")
    return
  correctness(device, "phase2_8w")
  benchmark(device, args.rounds, args.per_round)


if __name__ == "__main__": main()
