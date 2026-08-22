# CDNA4 MXFP4 tuning library

This directory starts from the known-good `extra/gemm/gemm_mxfp4.py` instruction stream and applies low-risk mapper specializations before attempting the larger 8-wave short-K rewrite.

## Implemented kernels

- `reference`: byte-for-byte instruction objects from the existing MXFP4 GEMM.
- `identity`: keeps the existing 256x256 MFMA/LDS/epilogue body, but skips the generic WGM32 mapper. `s46/s47` already contain `gidx0/gidx1`, so this is especially useful for `N=4096` and `N=6144`, where the reference mapper eventually computes the same coordinates through its slow remainder divide path.
- `wgm8`: changes only the five WGM constants in the reference mapper from 32 to 8. Requires `N/256` divisible by 8.
- `wgm16`: same, using WGM=16. Requires `N/256` divisible by 16.
- `auto`: `identity` for `N/256 <= 32`, otherwise WGM16 when possible, then WGM8.

All variants currently use 256 threads and 163,840 B LDS. They intentionally keep the known-good MFMA body untouched. `resources.py` mirrors tinygrad's typed operand scanner in `tinygrad/renderer/amd/elf.py`.

## CPU-only codegen check

```sh
PYTHONPATH=. python extra/gemm/cdna_lib/test_codegen.py
```

This serializes every production-shape variant, checks code-byte preservation, and verifies the register footprint remains unchanged.

## gfx950 assembly/ELF compile gate (no GPU required)

```sh
DEV=NULL:NULL:gfx950 PYTHONPATH=. python extra/gemm/cdna_lib/test_compile.py
```

This goes through the real `Tensor.custom_kernel -> schedule_linear -> compile_linear` path, assembles the CDNA instructions, and packs the gfx950 ELF/kernel descriptor. It also requires the `reference` wrapper to produce an ELF byte-for-byte identical to the repo's existing `_mxfp4_gemm_quantized` path for every production shape. Run this before any GPU benchmark.

## gfx950 correctness

```sh
PYTHONPATH=. DEV=AMD python extra/gemm/cdna_lib/bench_mxfp4.py --check
```

For all production N mapper sizes:

```sh
PYTHONPATH=. DEV=AMD python extra/gemm/cdna_lib/bench_mxfp4.py --check-all-mappers
```

The test quantizes one set of BF16 matrices with the existing quantizer, runs the existing FP4 GEMM as the reference, then requires tuned outputs to be bit-identical.

## Benchmark the main short-K shape

```sh
PYTHONPATH=. DEV=AMD python extra/gemm/cdna_lib/bench_mxfp4.py \
  --shape 16384,4096,4096 --warmup 20 --count 101 \
  --variants reference,auto,identity,wgm8,wgm16
```

For `N=4096`, `auto` resolves to `identity`, so duplicate mapper streams are skipped automatically.

## Benchmark all Llama production shapes

```sh
PYTHONPATH=. DEV=AMD python extra/gemm/cdna_lib/bench_mxfp4.py \
  --llama --warmup 20 --count 101 \
  --variants reference,auto,identity,wgm8,wgm16
```

The timing buffers are allocated directly in the packed FP4/scales physical shapes, so quantization is not part of the measured schedule. The script reports median/best kernel time, PFLOP/s, MFU against 9.2 PFLOP/s, and static register resources.

## Next kernel

The next step is a separate short-K `256x256`, 8-wave (`2M x 4N`) body targeting 128 AccVGPRs/wave and <=256 combined VGPRs. It should be added as a new builder rather than mutating the 4-wave reference schedule; the mapper experiments here provide a stable baseline first.
