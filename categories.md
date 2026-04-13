Step-2 kernel categories (from discovery ranks 1-200)

Scope
- Uses the kernels currently documented in `discovery.md` (ranks 1-200).
- These 200 kernels cover 2.073s out of 2.137s total step-2 time (~97.01%), so this is near-complete for where time is going.

1) How many of these kernels are just dumb copies?
- Dumb-copy kernels (exact/simple copy/cast, not heavy math): 51 / 200 unique kernels.
- Time in dumb-copy kernels: 0.318s (~15.32% of top-200 time).

2) How many are transposes / pure layout memory-bound stuff?
- Layout/transpose/reindex copy kernels: 69 / 200 unique kernels.
- Time in layout-copy kernels: 0.363s (~17.50%).
- If you include memset/zero-fill memory kernels too: +6 kernels, +0.030s (~1.47%).
- Combined memory-movement class (dumb copy + layout + memset):
  - 126 / 200 kernels
  - 0.711s (~34.29% of top-200 step time)

3) What is the rest of the time going into (and what to optimize)?
- FP8 GEMMs (`hk_fp8_gemm_*`): 0.449s (~21.64%).
  - Main compute core in attention/FFN projections (`flat_llama.py` matmul path).
- FP8 quant/cast/amax kernels (`kitten_*`): 0.255s (~12.30%).
  - Quantization bookkeeping overhead around FP8 path.
- Flash attention kernels (`custom_fa_*`): 0.240s (~11.57%).
  - Attention core (`custom_fa_forward/backward`).
- Dense vocab GEMMs (`gemm_1_*_128256_*`): 0.087s (~4.22%).
  - Output head / vocab projection hot spot.
- Optimizer fused updates: 0.055s (~2.65%).
- Loss/CE reductions + masking: 0.036s (~1.73%).

Percent of time by category (exclusive split, top-200 kernels)
- Layout/copies/memset: 34.29%
- FP8 GEMMs: 21.64%
- FP8 quant/cast/amax (`kitten_*`): 12.30%
- Flash attention (`custom_fa_*`): 11.57%
- Other fused elementwise/reduction kernels: 11.16%
- Dense vocab GEMMs (`gemm_1_*`): 4.22%
- Optimizer fused updates: 2.65%
- Loss / cross-entropy path: 1.73%
- RMSNorm stat kernels: 0.27%
- Embedding backward: 0.18%

Memory-only sub-breakdown (for question 1/2)
- Dumb copies: 15.32%
- Layout/transpose copies: 17.50%
- Memset/zero-fill: 1.47%
- Total memory-movement class: 34.29%

Actionable optimization priorities
1. Reduce memory traffic in relayout/copy path (~34%): fuse relayout into producer/consumer where possible, remove redundant slice/gather copies, and prefer kernels that consume native layout.
2. Attack FP8 overhead around GEMMs (~12% quant kernels): fuse cast+amax where legal, reduce amax update frequency, and avoid re-quantizing unchanged tensors.
3. Improve GEMM utilization (~26% combined FP8+dense GEMM): tune problem shapes/layouts to avoid transpose variants and improve tensor-core occupancy.
4. Recheck attention+bwd mix (~12% FA): ensure the FA pre/backward staging kernels are not blocked by extra memory transforms.
