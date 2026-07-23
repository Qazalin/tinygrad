#!/usr/bin/env python3
import argparse, statistics

import numpy as np

from tinygrad import Context, Device, GlobalCounters, Tensor
from tinygrad.engine.realize import run_linear
from extra.gemm.mxfp4 import (MXFP4_VALUES, aiter_mxfp4_gemm_preshuffled, quantize_mxfp4_ref,
                              shuffle_mxfp4_scales, shuffle_mxfp4_weight)


def dequantize(packed:np.ndarray, scales:np.ndarray) -> np.ndarray:
  rows, half_k = packed.shape
  nibbles = np.stack((packed & 0xF, packed >> 4), axis=-1).reshape(rows, half_k * 2)
  values = np.asarray(MXFP4_VALUES, dtype=np.float32)[nibbles]
  block_scales = np.exp2(scales.astype(np.float32) - 127.0)
  return (values.reshape(rows, half_k // 16, 32) * block_scales[:, :, None]).reshape(rows, half_k * 2)


def main(M:int, N:int, K:int, tile_m:int, tile_n:int, seed:int, warmup:int, repeat:int) -> None:
  assert (tile_m, tile_n) in ((256, 256), (192, 256), (128, 512))
  assert M % tile_m == N % tile_n == K % 256 == 0
  device = Device.DEFAULT
  target = Device[device].renderer.target
  assert target.arch == "gfx950", f"requires gfx950, got {target}"
  assert target.interface != "MOCK", "MOCK cannot validate numerical correctness"

  rng = np.random.default_rng(seed)
  a = (rng.standard_normal((M, K), dtype=np.float32) * 0.5).astype(np.float32)
  b = (rng.standard_normal((N, K), dtype=np.float32) * 0.5).astype(np.float32)

  # Quantize and establish the reference entirely on CPU. Only the exact AITER
  # GEMM and the final output copy execute on the selected gfx950.
  aq, ae = quantize_mxfp4_ref(Tensor(a, device="CPU"))
  bq, be = quantize_mxfp4_ref(Tensor(b, device="CPU"))
  aq_np, ae_np, bq_np, be_np = aq.numpy(), ae.numpy(), bq.numpy(), be.numpy()
  expected = dequantize(aq_np, ae_np) @ dequantize(bq_np, be_np).T

  bq_shuffled = shuffle_mxfp4_weight(Tensor(bq_np, device="CPU")).numpy()
  ae_shuffled = shuffle_mxfp4_scales(Tensor(ae_np, device="CPU")).numpy()
  be_shuffled = shuffle_mxfp4_scales(Tensor(be_np, device="CPU")).numpy()
  gpu_args = [Tensor(x, device=device).realize() for x in (aq_np, bq_shuffled, ae_shuffled, be_shuffled)]

  out = aiter_mxfp4_gemm_preshuffled(*gpu_args, tile_m=tile_m, tile_n=tile_n)
  linear = out.schedule_linear()
  times = []
  with Context(DEBUG=0):
    for _ in range(warmup): run_linear(linear, wait=True)
    for _ in range(repeat):
      GlobalCounters.reset()
      run_linear(linear, wait=True)
      times.append(GlobalCounters.time_sum_s)
  actual = out.float().numpy()

  abs_err = np.abs(actual - expected)
  np.testing.assert_allclose(actual, expected, atol=0.25, rtol=0.01)
  median_s, best_s = statistics.median(times), min(times)
  print(f"PASS AITER MXFP4 tile {tile_m}x{tile_n}, shape {M}x{N}x{K} on {target}")
  print(f"median: {median_s*1e6:.3f} us, {2*M*N*K/median_s*1e-12:.3f} TFLOPS; "
        f"best: {best_s*1e6:.3f} us, {2*M*N*K/best_s*1e-12:.3f} TFLOPS")
  print(f"max_abs_err: {abs_err.max():.6f}, mean_abs_err: {abs_err.mean():.6f}")


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Standalone correctness test for the exact AITER gfx950 MXFP4 GEMM")
  parser.add_argument("--m", type=int, default=256)
  parser.add_argument("--n", type=int, default=256)
  parser.add_argument("--k", type=int, default=256)
  parser.add_argument("--tile-m", type=int, choices=(128, 192, 256), default=256)
  parser.add_argument("--tile-n", type=int, choices=(256, 512), default=256)
  parser.add_argument("--seed", type=int, default=7)
  parser.add_argument("--warmup", type=int, default=3)
  parser.add_argument("--repeat", type=int, default=20)
  args = parser.parse_args()
  main(args.m, args.n, args.k, args.tile_m, args.tile_n, args.seed, args.warmup, args.repeat)
