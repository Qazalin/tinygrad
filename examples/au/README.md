# Tinygrad audiobook generation

The main CLI has two positional inputs: a reference voice sample and the new
source text (`.txt` or a text-layer `.pdf`). It produces a chapter-marked M4B
using Qwen3-TTS 12 Hz 1.7B Base voice cloning.

```sh
DEV=NV python3 examples/au/main.py narrator.wav book.pdf
DEV=METAL python3 examples/au/main.py narrator.m4a book.txt
DEV=CPU python3 examples/au/main.py narrator.wav short_story.txt
```

To test a PDF on a small inclusive page range before committing to a full
render, use `--pages`. Its default work directory includes the range, so the
preview cannot be confused with a full-book render:

```sh
DEV=METAL python3 examples/au/main.py narrator.mp3 book.pdf --pages 1-3
```

The default model is `Qwen/Qwen3-TTS-12Hz-1.7B-Base`; set
`QWEN_TTS_MODEL=/local/snapshot` or pass `--model`. If the exact transcript of
the reference clip is known, pass `--voice-text`; otherwise `faster-whisper`
transcribes it locally.

The CLI is one Python process: it loads the model and voice prompt once, renders
chunks sequentially, and packages them in process. Intermediate chunks live in
`build/au/<source-name>/` and are regenerated on every run. Use `--work` and
`--output` to choose other locations. Tinygrad's `DEBUG` output goes directly
to the terminal.

Model inference, reference speech encoding, speaker embedding, autoregressive
generation, and waveform decoding are tinygrad graphs. PyMuPDF/librosa/
soundfile handle formats and PyAV packages the M4B. The generic PDF extractor
uses top-level TOC entries and sentence-boundary chunks; production PDFs still
need text QC for headers, OCR damage, watermarks, references, and tables.
