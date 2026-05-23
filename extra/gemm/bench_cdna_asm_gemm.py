#!/usr/bin/env python3
import argparse, gc, pathlib, sys
sys.path.append(str(pathlib.Path(__file__).parents[2]))
from tinygrad import Tensor, Device, dtypes
from tinygrad.helpers import GlobalCounters, profile_marker
from extra.gemm.cdna_asm_gemm import asm_gemm

LLAMA_FP8_SHAPES = [
  (28672, 4096, 16384),
  (16384, 28672, 4096),
  (16384, 4096, 28672),
  (16384, 14336, 4096),
  (16384, 4096, 14336),
  (4096, 14336, 16384),
  (16384, 6144, 4096),
  (16384, 4096, 4096),
  (16384, 4096, 6144),
  (6144, 4096, 16384),
  (4096, 4096, 16384),
]
TOP6 = LLAMA_FP8_SHAPES[:6]

def parse_shape(s:str) -> tuple[int, int, int]:
  parts = s.replace("x", ",").replace("_", ",").split(",")
  if len(parts) != 3: raise argparse.ArgumentTypeError(f"shape must be M,N,K: {s!r}")
  return tuple(int(x) for x in parts)  # type: ignore[return-value]

def run_shape(M:int, N:int, K:int, scale_mode:int, warmup:int, cnt:int) -> None:
  a = Tensor.empty(M, K, dtype=dtypes.fp8e4m3).realize()
  # Match training: callers pass w.T, then asm_gemm passes b.T to the kernel as contiguous (N,K) weight storage.
  b_storage = Tensor.empty(N, K, dtype=dtypes.fp8e4m3).realize()
  b = b_storage.T
  x_scale = Tensor.empty((), dtype=dtypes.float32).realize() if scale_mode & 1 else None
  w_scale = Tensor.empty((), dtype=dtypes.float32).realize() if scale_mode & 2 else None

  label = f"fp8_gemm {M}x{N}x{K} sm{scale_mode}"
  profile_marker(label + " warmup")
  for _ in range(warmup):
    out = asm_gemm(a, b, x_scale=x_scale, w_scale=w_scale).realize()
    del out

  profile_marker(label + " measure")
  GlobalCounters.reset()
  for _ in range(cnt):
    out = asm_gemm(a, b, x_scale=x_scale, w_scale=w_scale).realize()
    del out
  Device[Device.DEFAULT].synchronize()
  profile_marker(label + " done")

  if GlobalCounters.time_sum_s:
    ops = 2 * M * N * K * cnt
    print(f"{label}: {cnt} iters, {GlobalCounters.time_sum_s*1e3:.3f} ms, {ops/GlobalCounters.time_sum_s*1e-15:.3f} PFLOPS")
  gc.collect()

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Benchmark exact FP8 CDNA GEMM shapes through asm_gemm")
  parser.add_argument("--shape", action="append", type=parse_shape, help="shape as M,N,K, MxNxK, or M_N_K; repeatable")
  parser.add_argument("--top6", action="store_true", help="benchmark only the six weighted-priority Llama FP8 GEMMs")
  parser.add_argument("--warmup", type=int, default=20)
  parser.add_argument("--cnt", type=int, default=100)
  parser.add_argument("--scale-mode", action="append", type=int, choices=(0, 1, 2, 3), default=None)
  args = parser.parse_args()

  shapes = args.shape if args.shape else (TOP6 if args.top6 else LLAMA_FP8_SHAPES)
  scale_modes = args.scale_mode or [3]
  for scale_mode in scale_modes:
    for M,N,K in shapes: run_shape(M, N, K, scale_mode, args.warmup, args.cnt)
