# Tinygrad audiobook generation

The main CLI has two positional inputs: a reference voice sample and the new
source text (`.txt` or a text-layer `.pdf`). It produces a chapter-marked M4B
using Qwen3-TTS 12 Hz 1.7B Base voice cloning.

```sh
DEV=NV python examples/au/main.py narrator.wav book.pdf
DEV=METAL python examples/au/main.py narrator.m4a book.txt
DEV=CPU python examples/au/main.py narrator.wav short_story.txt
```

The default model is `Qwen/Qwen3-TTS-12Hz-1.7B-Base`; set
`QWEN_TTS_MODEL=/local/snapshot` or pass `--model`. If the exact transcript of
the reference clip is known, pass `--voice-text`; otherwise `faster-whisper`
transcribes it locally.

Sharding is explicitly requested with `--shard N`. For NV/CUDA this launches N
resident workers and assigns one visible GPU to each:

```sh
DEV=NV python examples/au/main.py narrator.wav book.pdf --shard 4
```

Intermediate chunks and logs live in `build/au/<source-name>/`. Existing WAVs
are skipped, so the same command resumes an interrupted render. Use `--work`
and `--output` to choose other locations.

Model inference, reference speech encoding, speaker embedding, autoregressive
generation, and waveform decoding are tinygrad graphs. PyMuPDF/librosa/
soundfile handle formats and ffmpeg packages the M4B. The generic PDF extractor
uses top-level TOC entries and sentence-boundary chunks; production PDFs still
need text QC for headers, OCR damage, watermarks, references, and tables.
