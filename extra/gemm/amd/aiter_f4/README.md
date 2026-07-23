# AMD AITER gfx950 MXFP4 GEMM code objects

These code objects are the exact A4W4 assembly kernels used by AMD's MLPerf
Training v6.0 Llama 3.1 8B submission. They were extracted from
`rocm/amd-mlperf:llama31_8b_training_6.0` at:

`/workspace/aiter/hsa/gfx950/f4gemm/`

The kernels and their AITER host launcher are MIT licensed; see `LICENSE`.

SHA-256:

- `f4gemm_bf16_per1x32Fp4_BpreShuffle_128x512.co`:
  `c32d5356e5d92b77202ef90cfad4318cc990a3f3e1c305fabd808e441a8d1b85`
- `f4gemm_bf16_per1x32Fp4_BpreShuffle_192x256.co`:
  `01453b424c0b54ca51e2788c0e78ffc8c79eea224ce286f49b57ca24fa9cf0e4`
- `f4gemm_bf16_per1x32Fp4_BpreShuffle_256x256.co`:
  `ff0d6bb10a211068997cbb2d846734092270324cafcaf32281ce5fb50946ffa1`

These are opaque gfx950 HSA code objects with AITER's packed 384-byte kernarg
ABI. They cannot be launched with tinygrad's normal C-like argument layout.
