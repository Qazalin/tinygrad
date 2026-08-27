#!/usr/bin/env python3
"""Correctness + timing harness for extra.gemm.cdna_lib MXFP4 kernels.

Examples:
  PYTHONPATH=. DEV=AMD python extra/gemm/cdna_lib/bench_mxfp4.py --check
  PYTHONPATH=. DEV=AMD python extra/gemm/cdna_lib/bench_mxfp4.py --shape 16384,4096,4096 --count 101
  PYTHONPATH=. DEV=AMD python extra/gemm/cdna_lib/bench_mxfp4.py --llama --count 101 --variants reference,auto,identity,wgm8,wgm16
"""

import argparse, functools, math, statistics
from dataclasses import dataclass

from tinygrad import Context, Device, GlobalCounters, Tensor, dtypes
from tinygrad.dtype import AddrSpace
from tinygrad.engine.realize import compile_linear, run_linear
from tinygrad.helpers import ceildiv
from tinygrad.renderer import Estimates
from tinygrad.uop.ops import KernelInfo, Ops, UOp

from extra.gemm.cdna_lib.mxfp4 import LLAMA_SHAPES, build_kernel, choose_auto_variant, variant_tile
from extra.gemm.cdna_lib.resources import scan_resources

PEAK_MXFP4_PFLOPS = 9.2
REF_LDS_BYTES = 163_840
REF_THREADS = 256
TILE_M = TILE_N = 256

def launch_config(variant: str) -> tuple[int, int]:
  if variant in ("phase2_4w", "phase2_4w_d2l", "phase2_4w_sched"):
    from extra.gemm.cdna_lib.phase2_4w import LDS_BYTES
    return (256, LDS_BYTES)
  if variant in ("phase2_4w64", "phase2_4w64_pipe"):
    from extra.gemm.cdna_lib.phase2_4w64 import LDS_BYTES
    return (256, LDS_BYTES)
  if variant in ("phase2_lds", "phase2_lds_pipe"):
    if variant == "phase2_lds_pipe":
      from extra.gemm.cdna_lib.phase2_lds_pipe import LDS_BYTES
    else:
      from extra.gemm.cdna_lib.phase2_lds import LDS_BYTES
    return (512, LDS_BYTES)
  return (512, REF_LDS_BYTES) if (variant.startswith("phase2_8w") or variant.startswith("phase2_direct")) else (REF_THREADS, REF_LDS_BYTES)


@functools.cache
def custom_mxfp4_cdna_lib(C: UOp, A: UOp, B: UOp, scale_a: UOp, scale_b: UOp, *, variant: str) -> UOp:
  M, half_k = math.prod(A.shape[:-1]), A.shape[-1]
  N, half_k_b = math.prod(B.shape[:-1]), B.shape[-1]
  K = half_k * 2
  assert half_k == half_k_b and math.prod(C.shape[:-1]) == M and C.shape[-1] == N
  tile_m, tile_n = variant_tile(variant)
  insts = build_kernel(M, N, K, tile_m, tile_n, variant)

  nthreads, lds_bytes = launch_config(variant)
  threads = UOp.special(nthreads, "lidx0")
  groups_x, groups_y = UOp.special(ceildiv(N, tile_n), "gidx0"), UOp.special(ceildiv(M, tile_m), "gidx1")
  lds = UOp.placeholder((lds_bytes,), dtypes.uint8, 0, AddrSpace.LOCAL)
  sink = UOp.sink(C.base, A.base, B.base, scale_a.base, scale_b.base, lds, threads, groups_x, groups_y,
                  arg=KernelInfo(f"cdna_lib_mxfp4_{variant}_{M}_{N}_{K}",
                                 estimates=Estimates(ops=2*M*N*K,
                                   mem=(M*half_k+N*half_k)*A.dtype.itemsize + M*N*C.dtype.itemsize)))
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.LINEAR, src=tuple(UOp(Ops.INS, arg=x) for x in insts))))


def launch_tensor(a_q: Tensor, b_q: Tensor, scale_a: Tensor, scale_b: Tensor, variant: str) -> Tensor:
  M, half_k = a_q.shape
  N, half_k_b = b_q.shape
  assert half_k == half_k_b
  # Match the production MXFP4 wrapper: the handwritten kernel fully defines the output.
  out_buf = Tensor.invalids(1, M, N, dtype=dtypes.bfloat16, device=a_q.device)
  return Tensor.custom_kernel(out_buf, a_q, b_q, scale_a, scale_b,
                              fxn=functools.partial(custom_mxfp4_cdna_lib, variant=variant))[0]


@dataclass
class BenchBuffers:
  a_q: Tensor
  b_q: Tensor
  scale_a: Tensor
  scale_b: Tensor


def make_empty_quantized(M: int, N: int, K: int, device: str) -> BenchBuffers:
  assert M % 256 == N % 256 == K % 256 == 0
  # Physical shapes match quantize_mxfp4 rowwise outputs. Contents don't matter for timing.
  bufs = BenchBuffers(
    Tensor.empty(M, K//2, dtype=dtypes.uint8, device=device),
    Tensor.empty(N, K//2, dtype=dtypes.uint8, device=device),
    Tensor.empty(M, K//32, dtype=dtypes.uint8, device=device),
    Tensor.empty(N, K//32, dtype=dtypes.uint8, device=device),
  )
  Tensor.realize(bufs.a_q, bufs.b_q, bufs.scale_a, bufs.scale_b)
  return bufs


def valid_variant(variant: str, N: int, M: int | None = None, K: int | None = None) -> bool:
  ntiles = N // TILE_N
  if variant in ("reference", "auto"): return True
  if variant == "ref128x512": return (M is None or M % 128 == 0) and N % 512 == 0
  if variant == "ref192x256": return (M is None or M % 192 == 0) and N % 256 == 0
  if variant in ("phase2_4w64", "phase2_4w64_pipe"): return (M is None or M % 64 == 0) and N % 256 == 0 and (K is None or K % 512 == 0)
  if variant in ("phase2_4w", "phase2_4w_d2l", "phase2_4w_sched"): return (M is None or M % 128 == 0) and N % 256 == 0 and (K is None or K % 256 == 0)
  if variant.startswith("phase2_8w") or variant.startswith("phase2_direct") or variant in ("phase2_lds", "phase2_lds_pipe"): return (M is None or M % 256 == 0) and N % 256 == 0 and (K is None or K % 256 == 0)
  if variant == "identity": return ntiles <= 32
  if variant.startswith("wgm"):
    return ntiles % int(variant[3:]) == 0
  return False


def bench_one(M: int, N: int, K: int, variant: str, bufs: BenchBuffers, warmup: int, count: int, debug: int) -> dict:
  actual = choose_auto_variant(M, N, K) if variant == "auto" else variant
  out = launch_tensor(bufs.a_q, bufs.b_q, bufs.scale_a, bufs.scale_b, variant)
  linear = out.schedule_linear()
  # Compile once up front. This exercises the real tinygrad handwritten-ASM lowering/ELF path
  # and makes compile failures happen before any timing loop. UOp has no boolean truth value.
  compiled = compile_linear(linear)

  with Context(DEBUG=debug):
    for _ in range(warmup): run_linear(compiled)
    samples = []
    for _ in range(count):
      start = GlobalCounters.time_sum_s
      run_linear(compiled)
      samples.append(GlobalCounters.time_sum_s - start)

  med, best = statistics.median(samples), min(samples)
  pflows = 2*M*N*K / med / 1e15
  best_pflows = 2*M*N*K / best / 1e15
  tm, tn = variant_tile(variant)
  resources = scan_resources(build_kernel(M, N, K, tm, tn, variant))
  return {"variant": variant, "actual": actual, "median": med, "best": best, "pflows": pflows,
          "best_pflows": best_pflows, "mfu": 100*pflows/PEAK_MXFP4_PFLOPS,
          "best_mfu": 100*best_pflows/PEAK_MXFP4_PFLOPS, "resources": resources}


def print_result(M: int, N: int, K: int, r: dict) -> None:
  label = r["variant"] if r["variant"] != "auto" else f"auto->{r['actual']}"
  print(f"{M:5d}x{N:5d}x{K:5d} {label:16s} median {r['median']*1e6:8.2f} us  "
        f"{r['pflows']:6.3f} PF/s {r['mfu']:5.1f}% MFU   best {r['best']*1e6:8.2f} us "
        f"{r['best_pflows']:6.3f} PF/s {r['best_mfu']:5.1f}%  {r['resources'].one_line()}")


def correctness_check(device: str, all_mappers: bool = False) -> None:
  """Compare tuned output bit-for-bit against the existing FP4 GEMM instruction stream."""
  import numpy as np
  from extra.llama_kernels.quantize_mxfp4 import quantize_mxfp4

  Ns = (4096, 6144, 14336, 28672) if all_mappers else (4096,)
  M, K = 256, 1024
  Tensor.manual_seed(123)
  for N in Ns:
    print(f"correctness M={M} N={N} K={K}")
    # Keep values modest. Both paths consume the exact same quantized buffers.
    a = (Tensor.randn(M, K, device=device) * 0.25).cast(dtypes.bfloat16).realize()
    b = (Tensor.randn(N, K, device=device) * 0.25).cast(dtypes.bfloat16).realize()
    a_q, scale_a, _, _ = quantize_mxfp4(a, shuffle_col=True)
    b_q, scale_b, _, _ = quantize_mxfp4(b, shuffle_row=True, shuffle_col=True)
    Tensor.realize(a_q, scale_a, b_q, scale_b)

    ref = launch_tensor(a_q, b_q, scale_a, scale_b, "reference").realize().numpy()
    variants = [v for v in ("identity", "wgm8", "wgm16") if valid_variant(v, N)]
    for variant in variants:
      got = launch_tensor(a_q, b_q, scale_a, scale_b, variant).realize().numpy()
      if not np.array_equal(got, ref):
        diff = got.astype(np.float32) - ref.astype(np.float32)
        raise AssertionError(f"{variant} mismatch for N={N}: max_abs={np.max(np.abs(diff))} mismatches={np.count_nonzero(got != ref)}")
      print(f"  {variant:8s}: bit-identical")
  print("correctness passed")


def parse_shape(s: str) -> tuple[int, int, int]:
  vals = tuple(int(x) for x in s.lower().replace("x", ",").split(",") if x)
  if len(vals) != 3: raise argparse.ArgumentTypeError("shape must be M,N,K")
  return vals  # type: ignore[return-value]


def main() -> None:
  ap = argparse.ArgumentParser()
  ap.add_argument("--shape", type=parse_shape, action="append", help="M,N,K; can be repeated")
  ap.add_argument("--llama", action="store_true", help="benchmark all production Llama shapes from the tuning table")
  ap.add_argument("--variants", default="reference,auto,identity,wgm8,wgm16")
  ap.add_argument("--warmup", type=int, default=10)
  ap.add_argument("--count", type=int, default=101)
  ap.add_argument("--debug", type=int, default=2)
  ap.add_argument("--check", action="store_true", help="run a bit-exact reference-vs-tuned correctness check first")
  ap.add_argument("--check-all-mappers", action="store_true", help="check all production N sizes (implies --check)")
  args = ap.parse_args()

  dev = Device[Device.DEFAULT]
  arch = dev.renderer.target.arch
  if not arch.startswith("gfx950"): raise RuntimeError(f"cdna_lib MXFP4 tuning requires gfx950, got {Device.DEFAULT} {arch}")
  device = Device.DEFAULT
  print(f"device={device} arch={arch}")

  if args.check or args.check_all_mappers: correctness_check(device, args.check_all_mappers)

  shapes = list(args.shape or [])
  if args.llama: shapes += list(LLAMA_SHAPES)
  if not shapes:
    if args.check or args.check_all_mappers: return
    shapes = [(16384, 4096, 4096)]

  variants = [x.strip() for x in args.variants.split(",") if x.strip()]
  for M, N, K in shapes:
    if M % 256 or N % 256 or K % 256:
      print(f"skip {M}x{N}x{K}: current cdna_lib path requires multiples of 256")
      continue
    print(f"\nshape {M}x{N}x{K}, Ntiles={N//256}")
    bufs = make_empty_quantized(M, N, K, device)
    seen_actual = set()
    for variant in variants:
      if not valid_variant(variant, N, M, K):
        print(f"  {variant:16s} skip (Ntiles={N//256} not divisible)")
        continue
      actual = choose_auto_variant(M, N, K) if variant == "auto" else variant
      # By default don't benchmark the exact same instruction stream twice via auto.
      key = actual
      if key in seen_actual:
        print(f"  {variant:16s} skip (same mapper as {actual})")
        continue
      seen_actual.add(key)
      r = bench_one(M, N, K, variant, bufs, args.warmup, args.count, args.debug)
      print_result(M, N, K, r)


if __name__ == "__main__": main()
