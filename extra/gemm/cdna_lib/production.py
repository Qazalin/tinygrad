"""Production dispatch for gfx950 MXFP4 Llama GEMMs.

The fallback table contains the fastest bit-correct variants measured in this tuning
session.  finish_llama.py can overwrite those choices with locally correctness-gated
measurements in llama_dispatch.json.
"""
from __future__ import annotations
import json
from pathlib import Path
from extra.gemm.cdna_lib.mxfp4 import choose_auto_variant

# Best *correct* lower-envelope results supplied by the MI350X runs before the 8-wave kernel.
BASELINE_DISPATCH = {
  (28672, 4096, 16384): "identity",
  (16384, 28672, 4096): "wgm16",
  (16384, 4096, 28672): "identity",
  (16384, 14336, 4096): "reference",
  (4096, 14336, 16384): "ref128x512",
  (16384, 4096, 14336): "identity",
  (16384, 4096, 4096): "wgm16",
  (16384, 6144, 4096): "identity",
  (16384, 4096, 6144): "identity",
  (6144, 4096, 16384): "ref192x256",
  (4096, 4096, 16384): "reference",
}
DISPATCH_PATH = Path(__file__).with_name("llama_dispatch.json")


def _load_local() -> dict[tuple[int,int,int], str]:
  if not DISPATCH_PATH.exists(): return {}
  try: raw = json.loads(DISPATCH_PATH.read_text())
  except Exception: return {}
  out = {}
  for key, val in raw.get("dispatch", raw).items():
    try: shape = tuple(int(x) for x in key.replace("x", ",").split(","))
    except Exception: continue
    if len(shape) == 3:
      out[shape] = val["variant"] if isinstance(val, dict) else str(val)
  return out


def choose_production_variant(M: int, N: int, K: int) -> str:
  shape = (M,N,K)
  local = _load_local()
  # Never resurrect the retired experimental LDS/direct kernels from a stale
  # dispatch file left by an interrupted autotune. phase2_lds is the only
  # higher-residency candidate allowed into production in this revision.
  if shape in local:
    v = local[shape]
    # Only the current 4-wave Phase-2 family is allowed back into production.
    # Retire all previous 8-wave/direct/LDS experiments from stale dispatch files.
    if not v.startswith("phase2_") or v in ("phase2_4w", "phase2_4w_d2l", "phase2_4w64", "phase2_4w64_pipe"): return v
  if shape in BASELINE_DISPATCH: return BASELINE_DISPATCH[shape]
  return choose_auto_variant(M,N,K)


def launch_config(variant: str) -> tuple[int,int,int,int]:
  from extra.gemm.cdna_lib.mxfp4 import variant_tile
  tm, tn = variant_tile(variant)
  if variant in ("phase2_4w", "phase2_4w_d2l"):
    from extra.gemm.cdna_lib.phase2_4w import LDS_BYTES
    return (256, LDS_BYTES, tm, tn)
  if variant in ("phase2_4w64", "phase2_4w64_pipe"):
    from extra.gemm.cdna_lib.phase2_4w64 import LDS_BYTES
    return (256, LDS_BYTES, tm, tn)
  if variant in ("phase2_lds", "phase2_lds_pipe"):
    if variant == "phase2_lds_pipe":
      from extra.gemm.cdna_lib.phase2_lds_pipe import LDS_BYTES
    else:
      from extra.gemm.cdna_lib.phase2_lds import LDS_BYTES
    return (512, LDS_BYTES, tm, tn)
  return (512 if (variant.startswith("phase2_8w") or variant.startswith("phase2_direct")) else 256, 163840, tm, tn)
