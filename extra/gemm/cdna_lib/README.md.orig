# gfx950 MXFP4 Llama GEMM finish-line tuner

This directory contains two layers:

1. **Measured safe baseline** — the fastest bit-correct reference/mapper/tile choice from the MI350X results collected in this tuning session.
2. **8-wave Phase 2 candidates** — `256x256`, 512-thread, 2M x 4N wave decomposition with 128 AccVGPRs/wave.  The production form forces a 128 regular-VGPR boundary (`128+128=256 combined`) and explicitly sets M0 to an unclamped LDS size before normal DS reads, per the CDNA4 LDS requirements.

The tuner never installs an 8-wave kernel merely because it compiles.  It first compares BF16 output bit-for-bit against the existing handwritten reference using row/K-dependent packed FP4 and E8M0 scale patterns.  Only correct candidates are benchmarked and eligible for dispatch.

## One command on MI350X

From the repo root:

```bash
DEV=AMD PYTHONPATH=. python extra/gemm/cdna_lib/finish_llama.py \
  --warmup 10 --rounds 8 --per-round 7
```

It tests all 11 Llama shapes, interleaves candidate timing to reduce shared-GPU bias, and writes:

```text
extra/gemm/cdna_lib/llama_dispatch.json
```

`extra/gemm/cdna_asm_gemm.py` automatically consumes that file on subsequent MXFP4 GEMMs.  A candidate must be at least 1% faster than the measured baseline to replace it (change with `--min-gain`).

The final output explicitly reports whether every selected shape reached 70% MFU.  If a Phase-2 variant is not bit-identical, it is discarded automatically and cannot enter production dispatch.

## Compile-only gate

The package has already been run through the gfx950 compile path. To reproduce the basic gate:

```bash
PYTHONPATH=. python extra/gemm/cdna_lib/test_codegen.py
DEV=NULL:NULL:gfx950 PYTHONPATH=. python extra/gemm/cdna_lib/test_compile.py
```

The finish-line compile matrix used during development additionally compiled every applicable candidate on all 11 Llama shapes (83 custom kernels total).

## Production behavior

If `llama_dispatch.json` exists, `cdna_asm_gemm.py` uses it automatically for 256-compatible MXFP4 GEMMs.  Without that file, the original path remains unchanged unless you explicitly set:

```bash
CDNA_LIB_MXFP4=1
```

That opt-in uses the measured safe baseline table in `production.py`.

Current baseline choices before local autotuning:

```text
28672,4096,16384   identity
16384,28672,4096   wgm16
16384,4096,28672   identity
16384,14336,4096   reference
4096,14336,16384   ref128x512
16384,4096,14336   identity
16384,4096,4096    wgm16
16384,6144,4096    identity
16384,4096,6144    identity
6144,4096,16384    ref192x256
4096,4096,16384    reference
```

## 8-wave candidates

The finish-line tuner tries all three and keeps only bit-correct ones:

- `phase2_8w` — 128 regular + 128 AccVGPR, conservative post-MFMA drain.
- `phase2_8w_fast` — same 128+128 allocation without the conservative drain.
- `phase2_8w_compact` — 115 regular + 128 AccVGPR (`248 combined`), with conservative drain.

All use 512 threads and the same `256x256` workgroup tile.  The implementation is generalized to M/N/K multiples of 256, covering all Llama shapes in `LLAMA_SHAPES`.
