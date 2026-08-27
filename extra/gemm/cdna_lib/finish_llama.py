#!/usr/bin/env python3
"""One-shot correctness gate + interleaved autotune for the Llama MXFP4 shapes.

This never selects a phase2 kernel unless its BF16 output is bit-identical to the
existing handwritten reference on the same N/K.  It then benchmarks full production
shapes in interleaved rounds and writes llama_dispatch.json.
"""
from __future__ import annotations
import argparse, functools, json, math, statistics
from pathlib import Path
import numpy as np
from tinygrad import Context, Device, GlobalCounters, Tensor, dtypes
from tinygrad.engine.realize import compile_linear, run_linear
from extra.gemm.cdna_lib.bench_mxfp4 import launch_tensor, make_empty_quantized, valid_variant
from extra.gemm.cdna_lib.mxfp4 import LLAMA_SHAPES, variant_tile
from extra.gemm.cdna_lib.production import BASELINE_DISPATCH, DISPATCH_PATH
from extra.gemm.cdna_lib.resources import scan_resources
from extra.gemm.cdna_lib.mxfp4 import build_kernel

PEAK = 9.2
PHASE2 = ("phase2_4w_sched", "phase2_4w_d2l", "phase2_4w")


def patterned_inputs(M: int, N: int, K: int, device: str):
  hk, sk = K//2, K//32
  # Row and K dependent byte patterns.  Scales stay in a modest E8M0 range so all
  # outputs remain finite while still catching row/scale permutations.
  ka = np.arange(hk, dtype=np.uint16)[None,:]
  kb = np.arange(hk, dtype=np.uint16)[None,:]
  a = ((ka * 13 + np.arange(M, dtype=np.uint16)[:,None] * 17 + 3) & 0xff).astype(np.uint8)
  b = ((kb * 11 + np.arange(N, dtype=np.uint16)[:,None] * 29 + 5) & 0xff).astype(np.uint8)
  ks = np.arange(sk, dtype=np.uint16)[None,:]
  sa = (124 + ((ks + np.arange(M, dtype=np.uint16)[:,None] * 3) % 7)).astype(np.uint8)
  sb = (124 + ((ks * 2 + np.arange(N, dtype=np.uint16)[:,None] * 5) % 7)).astype(np.uint8)
  ts = tuple(Tensor(x, device=device).realize() for x in (a,b,sa,sb))
  return ts


def bits(x: Tensor) -> np.ndarray:
  return np.ascontiguousarray(x.realize().numpy()).view(np.uint16)


def correctness_for_shape(N: int, K: int, variants: list[str], device: str, M: int = 256) -> dict[str,bool]:
  a,b,sa,sb = patterned_inputs(M,N,K,device)
  ref = bits(launch_tensor(a,b,sa,sb,"reference"))
  verdict = {}
  for v in variants:
    try:
      got = bits(launch_tensor(a,b,sa,sb,v))
      ok = np.array_equal(got, ref)
      verdict[v] = bool(ok)
      if ok: print(f"    correctness {v:20s} PASS")
      else:
        neq = np.flatnonzero(got.reshape(-1) != ref.reshape(-1))
        first = int(neq[0]) if len(neq) else -1
        print(f"    correctness {v:20s} FAIL mismatches={len(neq)} first_flat={first}")
    except Exception as e:
      verdict[v] = False
      print(f"    correctness {v:20s} ERROR {type(e).__name__}: {e}")
  return verdict


def compile_variant(M,N,K,v,bufs):
  out = launch_tensor(bufs.a_q,bufs.b_q,bufs.scale_a,bufs.scale_b,v)
  return compile_linear(out.schedule_linear())


def timed_run(prg) -> float:
  st = GlobalCounters.time_sum_s
  run_linear(prg)
  return GlobalCounters.time_sum_s-st


def benchmark_shape(M,N,K,variants,device,warmup,rounds,per_round):
  bufs=make_empty_quantized(M,N,K,device)
  prgs={v:compile_variant(M,N,K,v,bufs) for v in variants}
  samples={v:[] for v in variants}; round_best={v:[] for v in variants}
  with Context(DEBUG=2):
    for v in variants:
      for _ in range(warmup): timed_run(prgs[v])
    for r in range(rounds):
      order=variants[r%len(variants):]+variants[:r%len(variants)]
      if r&1: order=list(reversed(order))
      for v in order:
        rs=[timed_run(prgs[v]) for _ in range(per_round)]
        samples[v].extend(rs); round_best[v].append(min(rs))
  out={}
  for v in variants:
    best=min(samples[v]); rb=statistics.median(round_best[v]); p=2*M*N*K/best/1e15
    out[v]={"best_s":best,"round_best_median_s":rb,"pflows":p,"mfu":100*p/PEAK,
            "resources":scan_resources(build_kernel(M,N,K,*variant_tile(v),v)).one_line()}
  return out


def candidates(M,N,K):
  vs=[BASELINE_DISPATCH[(M,N,K)],"reference"]
  for v in ("identity","wgm16","wgm8"):
    if valid_variant(v,N,M,K): vs.append(v)
  for v in ("ref128x512", "ref192x256"):
    if valid_variant(v,N,M,K): vs.append(v)
  vs += list(PHASE2)
  return list(dict.fromkeys(vs))


def main():
  ap=argparse.ArgumentParser()
  ap.add_argument("--warmup",type=int,default=5)
  ap.add_argument("--rounds",type=int,default=6)
  ap.add_argument("--per-round",type=int,default=5)
  ap.add_argument("--min-gain",type=float,default=0.01,help="require this fractional speedup before replacing baseline")
  ap.add_argument("--shape",action="append",help="optional M,N,K; otherwise all Llama shapes")
  args=ap.parse_args()
  dev=Device[Device.DEFAULT]; arch=dev.renderer.target.arch
  if not arch.startswith("gfx950"): raise RuntimeError(f"requires gfx950, got {Device.DEFAULT} {arch}")
  device=Device.DEFAULT
  shapes=list(LLAMA_SHAPES)
  if args.shape:
    shapes=[tuple(map(int,s.replace('x',',').split(','))) for s in args.shape]
  print(f"device={device} arch={arch}")

  # Small bit-exact gate plus a separate static production-M address proof.
  corr_cache={}
  dispatch={}; results={}
  from extra.gemm.cdna_lib.test_phase2_4w_mapping import prove_production_bounds as prove_4w_bounds, prove_a_stage, prove_inputs
  from extra.gemm.cdna_lib.test_phase2_4w64_mapping import prove_production_bounds as prove_4w64_bounds, prove_a_stage as prove_4w64_a, prove_inputs as prove_4w64_inputs
  for K0 in sorted({x[2] for x in shapes}): prove_a_stage(K0); prove_inputs(K0); prove_4w64_a(K0); prove_4w64_inputs(K0)
  for M,N,K in shapes:
    print(f"\n=== {M}x{N}x{K} ===")
    prove_4w_bounds(M,N,K); prove_4w64_bounds(M,N,K)
    print("  static 4w/4w64 production bounds/C partition PASS")
    ck=(N,K)
    if ck not in corr_cache:
      print(f"  correctness gate 256x{N}x{K}")
      corr_cache[ck]=correctness_for_shape(N,K,list(PHASE2),device,256)
    vs=[]
    for v in candidates(M,N,K):
      if v in PHASE2 and not corr_cache[ck].get(v,False): continue
      vs.append(v)
    print("  benchmark:",", ".join(vs))
    br=benchmark_shape(M,N,K,vs,device,args.warmup,args.rounds,args.per_round)
    for v,r in sorted(br.items(),key=lambda kv:kv[1]['best_s']):
      print(f"    {v:20s} best={r['best_s']*1e6:8.2f} us  {r['pflows']:6.3f} PF/s  {r['mfu']:5.1f}% MFU  round-floor-med={r['round_best_median_s']*1e6:8.2f} us  {r['resources']}")
    baseline=BASELINE_DISPATCH[(M,N,K)]
    best=min(br,key=lambda v:br[v]['best_s'])
    # Don't replace a proven baseline on a sub-percent shared-box fluctuation.
    if best != baseline and br[best]['best_s'] > br[baseline]['best_s']*(1-args.min_gain): best=baseline
    r=br[best]
    key=f"{M},{N},{K}"
    dispatch[key]={"variant":best,"best_us":r['best_s']*1e6,"pflows":r['pflows'],"mfu":r['mfu']}
    results[key]=br
    print(f"  SELECT {best}  {r['mfu']:.1f}% MFU" + ("  [>=70%]" if r['mfu']>=70 else "  [below 70%]"))

  payload={"arch":arch,"peak_mxfp4_pflops":PEAK,"dispatch":dispatch,"results":results}
  DISPATCH_PATH.write_text(json.dumps(payload,indent=2,sort_keys=True)+"\n")
  print(f"\nwrote {DISPATCH_PATH}")
  print("\nproduction dispatch:")
  for k,v in dispatch.items(): print(f"  {k:24s} -> {v['variant']:20s} {v['best_us']:8.2f} us {v['mfu']:5.1f}%")
  below=[(k,v) for k,v in dispatch.items() if v['mfu']<70]
  if below:
    print("\nWARNING: best correct candidate remains below 70% on:")
    for k,v in below: print(f"  {k}: {v['variant']} {v['mfu']:.1f}%")
  else: print("\nALL LLAMA SHAPES >= 70% MFU")

if __name__=='__main__': main()
