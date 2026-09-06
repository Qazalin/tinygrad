# Two-group MXFP4 short-K kernel

`mxfp4_gemm_shortk.py` is a standalone assembly generator for
M=16384, N=4096, K=4096. It does not import or transform the generic GEMM.
The dispatcher selects it for K=4096; the generator asserts the supported
M and N. Other K values use the existing generic kernel.

## Schedule

Each of 128 workgroups contains eight waves, arranged as two four-wave groups.
Each group owns a 128x256 output tile, 128 accumulators per wave, and its own
32 KiB LDS region. The kernel uses VGPRs 0:78 and AGPRs 0:127; the combined
allocation rounds to 208 registers per thread. Each group computes eight tiles,
so each workgroup computes sixteen tiles in total.

Both groups prime their initial inputs. Group A computes tile 0; group B then
computes tile 1 while A drains tile 0 and primes tile 2. They continue alternating.
Each group reads and clears only its own accumulators. The last active group
performs the final drain.

Every tile has 32 K chunks of 128 elements. Between common workgroup barriers,
the active group issues its next-chunk input loads and computes 32 MFMAs from
current LDS operands. The service group drains one four-accumulator stripe;
on its first chunk, it also loads the next tile's initial inputs. After all waves
finish reading the old LDS contents, pending input data is written to LDS, then
all waves rendezvous again. LDS operand waits leave pending global loads in flight.
The generated source explicitly emits all addressing, loads, LDS accesses,
MFMAs, stores, branches, and barriers.

## Validation on MI350P, 2026-09-06

```sh
K=4096 DEV=AMD DEBUG=2 PYTHONPATH=. python test/backend/test_asm_gemm.py TestMXFP4.test_correctness2
K=4096 VIZ=-2 DEV=AMD DEBUG=2 PYTHONPATH=. python test/backend/test_asm_gemm.py TestMXFP4.test_correctness2
python -m tinygrad.viz.cli -s 'mxfp4_gemm_sk_16384_4096_4096 SQTT SE:0 PKTS' --json > /tmp/mxfp4_phase_final_sqtt.jsonl
```

- Full-output correctness passed three consecutive runs, with zero-initialized outputs.
- A separate signed random input check passed the same rtol=0.005, atol=0.001 comparison.
- Inserting `s_endpgm` at entry fails with zero output and `MXFP4 GEMM forward mismatch`.
- Repository ruff and mypy checks passed; the new kernel also passed explicit ruff checking.

The three unprofiled times were 881.12, 880.32, and 880.12 us. The median is
880.32 us, about 624.5 TFLOPS and 13.6% of the 4.6 PFLOPS peak used in our previous
comparisons. **This is an initial correct schedule, not a performance improvement.**
The original 256x256 kernel was approximately 250 us on this shape.

## Trace evidence and remaining work

SE0 captured eight complete wave lifetimes, two per SIMD. Each wave issued
8x1024 MFMAs, initialized 128 accumulators, and drained/cleared 8x128 accumulators.
The analysis classifies these events using the explicit phase schedule; VALU_MAI
also includes accumulator reads/writes, so it must not be counted directly as MFMA.

Across the four SIMD pairs, 7,440 of 7,680 steady-state output-store instructions
(96.9%) occur between the sibling tile's first and last MFMA. However, only 157
(2.0%) occur inside a sibling chunk's first-to-last-MFMA span. Next-tile input reads
also overlap chunk spans (249 of 672 read instructions). These are dispatch-time
interval comparisons, not measurements of memory-transaction completion.

Thus the persistent alternating schedule works and removes a separate full-tile
epilogue between compute phases, but the fine-grained work is not balanced.
Service stripes usually finish before the sibling's MFMA chunk starts. The active
path has substantial address generation, LDS traffic/waits, and two barriers per
128 K elements. The generated loop is also about 63 KiB. These are explicit costs
of this initial implementation; the trace does not show a continuously occupied
matrix pipe. Further work should improve the compute pipeline and place service
work inside its execution windows, while retaining this ownership/barrier model.

Local evidence:
- `/tmp/mxfp4_phase_prefetch_correctness.log`
- `/tmp/mxfp4_phase_signed.log`
- `/tmp/mxfp4_phase_mutation.log`
- `/tmp/mxfp4_phase_final_sqtt.jsonl`
- `/tmp/mxfp4_phase_overlap.json`
- `/tmp/analyze_mxfp4_phase.py`

Instruction/layout references: the repository's quantize_mxfp4.cpp and
[AMD CDNA4 ISA](https://www.amd.com/content/dam/amd/en/documents/instinct-tech-docs/instruction-set-architectures/amd-instinct-cdna4-instruction-set-architecture.pdf).
