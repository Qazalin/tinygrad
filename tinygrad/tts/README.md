# Qwen3-TTS

Pure tinygrad inference for Qwen3-TTS 12 Hz CustomVoice and Base checkpoints.
The autoregressive talker/code predictor, reference speech encoder, ECAPA speaker
encoder, and 24 kHz neural codec run as tinygrad graphs; PyTorch and Transformers
are not used.

```sh
DEV=NV python -m tinygrad.tts "Hello from tinygrad." \
  --model /path/to/Qwen3-TTS-12Hz-1.7B-CustomVoice \
  --speaker Ryan --language English -o hello.wav
```

The model argument is a local Hugging Face snapshot containing
`model.safetensors`, tokenizer JSON files, and the `speech_tokenizer/` directory.
Use `DEV=CUDA` instead of `DEV=NV` for the CUDA backend. `DEBUG=2` prints kernel
timings; `VIZ=1` records graphs and profiling data for `python -m tinygrad.viz.cli`.

`temperature=0` selects deterministic greedy decoding. Sampling uses parallel
top-k rejection sampling so the 16 serial codebooks do not each sort the
vocabulary; its vanishingly rare all-rejected fallback is greedy.

Base checkpoints expose `create_voice_clone_prompt` and
`generate_voice_clone_codes`. A resume-safe PDF-to-M4B application using those
APIs is in `examples/au/`.

See [BENCHMARK.md](BENCHMARK.md) for matched official/tinygrad measurements,
JIT warmup behavior, and the profiler-driven optimization notes.

Supported predefined 1.7B voices are Serena, Vivian, Uncle Fu, Ryan, Aiden, Ono
Anna, Sohee, Eric, and Dylan. Base checkpoints clone a voice from reference audio
plus its transcript.
