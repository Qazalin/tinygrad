# Qwen3-TTS benchmark

These numbers compare the same local Qwen3-TTS-12Hz-1.7B-CustomVoice weights,
prompt, Ryan/English conditioning, BF16 weights, one batch, and RTX 4090. The
official baseline is `qwen-tts==0.1.1`, `torch==2.10.0`, CUDA 12.8, and SDPA;
the tinygrad baseline is commit `8c2bf02d1` plus this implementation, using
`DEV=NV`. The machine has five RTX 4090s, driver 570.195.03. Each process was
pinned to one otherwise-idle GPU and synchronized at timing boundaries.

## Steady-state results

| stage | workload | official | tinygrad | tinygrad difference |
|---|---:|---:|---:|---:|
| talker, greedy | 20 frames | 122.72 ms/frame | 113.12 ms/frame | 7.8% faster |
| talker, top-k sampling | 5 frames, k=50, T=0.9 | 134.85 ms/frame | 290.70 ms/frame | 2.16x slower |
| codec | 20 frames to 1.60 s audio | 25.29 ms | 23.92 ms | 5.4% faster |
| full greedy pipeline | 20 frames / 1.60 s audio | RTF 1.55 | RTF 1.43 | 7.7% lower RTF |

The full-pipeline row is talker plus decoder and intentionally excludes model
loading and JIT capture. It is a throughput measurement for a resident service.
Twenty codec frames represent 1.60 seconds because this checkpoint emits 12.5
frames per second.

## JIT lifecycle

`TinyJit` executes normally on the first call, captures on the second compatible
call, and replays thereafter. For the 20-frame greedy talker the measured calls
were 33.92 s (compile), 2.05 s (capture), and 1.916 s (replay). For a 20-frame
codec decode they were 13.89 s, 0.673 s, and 0.02392 s. Persistent compiler cache
state strongly affects the first number; it must not be presented as steady-state
inference latency. The official eager baseline has no corresponding graph compile.

The JIT boundaries are deliberately stage-sized:

- each of the 15 dependent code-predictor steps captures embedding, projection,
  five transformer layers, output head, and sampler;
- the 28-layer talker retains its KV cache but currently schedules its advance
  eagerly; stateful capture requires making that cache an explicit graph output;
- codec decode captures the complete fixed-length decoder graph, keyed by frame
  count.

## Why performance differs

Before those boundaries were enlarged, tinygrad spent 515.3 ms/frame in the
talker and 542 ms in a warm codec decode (full RTF 6.78). A `PROFILE=1` trace
attributed 35.8% of talker wall time to 97 `realize` calls and another 23.4% to
scheduling/lowering rather than GPU math. Capturing the entire dependent steps
reduced the warm greedy pipeline by about 5.6x and makes graph replay faster than
PyTorch eager/SDPA.

Greedy decoding is favorable to replay: argmax is deterministic and remains in
the device graph. Sampled decoding still has 16 serial random choices per audio
frame. tinygrad's full-vocabulary random generation and categorical scan cost
about 152 ms/frame beyond greedy; official PyTorch's tuned categorical kernels
add only about 12 ms/frame. The implementation avoids an even slower vocabulary
sort by drawing eight categorical candidates in parallel and accepting the first
one inside the top-k. This is rejection sampling from the exact top-k conditional
distribution; the only approximation is an argmax fallback if all eight draws
miss the top-k.

The codec is convolution-heavy and fixed-shape, so whole-decoder graph replay
eliminates Python and scheduler overhead and lands close to the official CUDA
kernels. Its output was also checked numerically against the official decoder:
mean absolute error `1.50e-5`, maximum absolute error `1.98e-4`.

## Reproducing profiles

Use `PROFILE=1` and `profile_marker` around the third same-shape invocation, then:

```sh
NO_COLOR=1 python -m tinygrad.viz.cli --interval "run @ 2" "run @ 3" -t 30
```

`DEBUG=2` prints individual tinygrad kernel timings. Nsight Systems is installed
as `nsys` for checking CUDA launch gaps; PyTorch's `torch.profiler` is useful for
the official CUDA operator table. Profile only after warmup and synchronize CUDA
before and after the measured region.

## Base voice-clone validation

The Base implementation was checked with an 8.18-second, 24 kHz reference clip.
The tinygrad encoder produced the official 103-frame shape; its ECAPA speaker
embedding had `0.9999975` correlation and `6.43e-4` mean absolute error against
the official result. The Base conditioning tensor matched shape `(1,113,2048)`
with `2.17e-4` mean absolute error. The first two greedy generated frames matched
all 32 official codebook values exactly; later greedy choices can diverge near
argmax ties as BF16 numerical error accumulates.

For audiobook decoding, short final chunks are causally padded to one of two JIT
shapes instead of compiling every observed duration. Padded and unpadded decode
on a 10-frame fixture differed by only `9.02e-8` mean and `3.06e-6` maximum while
returning the same number of samples.
