#!/usr/bin/env python3
"""Create a cloned-voice audiobook: main.py VOICE_SAMPLE (.txt|.pdf) [options]."""
from __future__ import annotations
import argparse, json, os, re, time, wave
from collections import Counter
from fractions import Fraction
from pathlib import Path


def page_range(value:str) -> tuple[int,int|None]:
  try:
    if "-" not in value: return int(value), int(value)
    start,end = value.split("-", 1)
    return int(start), int(end) if end else None
  except ValueError as e: raise argparse.ArgumentTypeError("expected START, START-END, or START-") from e


def resolve_model(value:str) -> Path:
  path = Path(value).expanduser()
  if path.exists(): return path.resolve()
  try: from huggingface_hub import snapshot_download
  except ImportError as e: raise SystemExit(f"model {value!r} is not a local path; install huggingface_hub to download it") from e
  return Path(snapshot_download(value))


def transcribe(voice:Path) -> str:
  try: from faster_whisper import WhisperModel
  except ImportError as e: raise SystemExit("provide --voice-text or install faster-whisper for automatic reference transcription") from e
  model = WhisperModel("small", device="cpu", compute_type="int8")
  segments,_ = model.transcribe(str(voice), beam_size=5)
  text = " ".join(x.text.strip() for x in segments).strip()
  if not text: raise SystemExit("the voice sample transcription was empty; provide --voice-text")
  return text


def sentences(text:str) -> list[str]:
  return [x.strip() for x in re.split(r"(?<=[.!?])\s+", re.sub(r"\s+", " ", text)) if x.strip()]


def prepare(source:Path, work:Path, words:int, pages:tuple[int,int|None]|None=None):
  work.mkdir(parents=True, exist_ok=True)
  page_start, selected_end = 1, None
  if source.suffix.lower() == ".txt": raw_chapters = [(source.stem, source.read_text(encoding="utf-8"))]
  elif source.suffix.lower() == ".pdf":
    try: import fitz
    except ImportError as e: raise SystemExit("PDF extraction requires PyMuPDF: pip install pymupdf") from e
    doc = fitz.open(source)
    page_start, page_end = (1, None) if pages is None else pages
    if page_start < 1 or (page_end is not None and page_end < page_start): raise SystemExit("pages must be START or START-END")
    if page_start > len(doc): raise SystemExit(f"page {page_start} is past the end of this {len(doc)}-page PDF")
    selected_start, selected_end = page_start-1, min(page_end or len(doc), len(doc))
    page_texts = [doc[p].get_text("text", sort=True) for p in range(selected_start, selected_end)]
    line_counts = Counter(line.strip() for text in page_texts for line in set(text.splitlines()) if line.strip())
    repeated = {line for line,count in line_counts.items() if len(page_texts) > 1 and count > len(page_texts)/2}
    page_texts = ["\n".join(line for line in text.splitlines() if line.strip() not in repeated) for text in page_texts]
    toc = [row for row in doc.get_toc(simple=True) if row[0] == 1]
    starts = [(title, max(0, page-1)) for _,title,page in toc] or [(source.stem, 0)]
    raw_chapters = []
    for i,(title,start) in enumerate(starts):
      end = starts[i+1][1] if i+1 < len(starts) else len(doc)
      lo, hi = max(start, selected_start), min(end, selected_end)
      if lo < hi: raw_chapters.append((title, "\n".join(page_texts[p-selected_start] for p in range(lo, hi))))
  else: raise SystemExit("source must be a .txt or .pdf file")

  chapters, chunks, cid = [], [], 0
  for i,(title,text) in enumerate(raw_chapters):
    units, current, chapter_ids = sentences(re.sub(r"(?<=\w)-\s*\n\s*(?=\w)", "", text)), [], []
    for unit in units:
      if current and len(" ".join(current).split()) + len(unit.split()) > words:
        chunks.append({"id":cid, "chapter":i, "title":title, "text":" ".join(current)}); chapter_ids.append(cid); cid += 1; current=[]
      current.append(unit)
    if current: chunks.append({"id":cid, "chapter":i, "title":title, "text":" ".join(current)}); chapter_ids.append(cid); cid += 1
    chapters.append({"title":title, "chunks":chapter_ids})
  manifest = {"source":str(source), "chapters":chapters, "chunks":chunks}
  if source.suffix.lower() == ".pdf": manifest["pages"] = {"start":page_start, "end":selected_end}
  (work/"manifest.json").write_text(json.dumps(manifest, indent=2))
  print(f"prepared {len(chapters)} chapters, {len(chunks)} chunks, {sum(len(x['text'].split()) for x in chunks)} words")


def render(work:Path, model_path:Path, voice:Path, voice_text:str, language:str, max_frames:int, temperature:float, top_k:int):
  import numpy as np
  try: import librosa, soundfile as sf
  except ImportError as e: raise SystemExit("audio I/O requires librosa and soundfile") from e
  from tinygrad import Tensor
  from tinygrad.tts.cli import load_tokenizer
  from tinygrad.tts.codec import Qwen3TTSCodec
  from tinygrad.tts.model import Qwen3TTS

  manifest = json.loads((work/"manifest.json").read_text())
  outdir = work/"chunks_wav"; outdir.mkdir(exist_ok=True)
  missing = [x for x in manifest["chunks"] if not (outdir/f"{x['id']:05d}.wav").exists()]
  if not missing:
    print(f"rendered chunks already complete ({len(manifest['chunks'])}/{len(manifest['chunks'])})")
    return

  tok = load_tokenizer(model_path)
  target_ids = lambda text: tok.encode(f"<|im_start|>assistant\n{text}<|im_end|>\n<|im_start|>assistant\n")
  ref_ids = tok.encode(f"<|im_start|>assistant\n{voice_text}<|im_end|>\n")
  wav,sr = librosa.load(voice, sr=None, mono=True)
  model = Qwen3TTS.from_pretrained(model_path, max_context=max_frames+len(ref_ids)+512)
  codec = Qwen3TTSCodec.from_pretrained(model_path/"speech_tokenizer", encoder=True)
  prompt = model.create_voice_clone_prompt(wav, sr, ref_ids, codec)
  print(f"prompt={prompt.codes.shape[0]} frames, chunks={len(missing)} remaining", flush=True)
  ref_codes = prompt.codes.transpose(0,1).unsqueeze(0)
  for n,chunk in enumerate(missing,1):
    started = time.perf_counter()
    codes = model.generate_voice_clone_codes(target_ids(chunk["text"]), prompt, language, max_frames, temperature, top_k)
    joined = Tensor.cat(ref_codes, codes, dim=2)
    audio = codec.decoder.chunked_decode(joined, fixed_shape=True)[..., prompt.codes.shape[0]*codec.decoder.total_upsample:]
    samples = audio.float().flatten().numpy().astype(np.float32)
    dst = outdir/f"{chunk['id']:05d}.wav"; tmp = outdir/f".{chunk['id']:05d}.tmp.wav"
    sf.write(tmp, samples, model.SAMPLE_RATE); os.replace(tmp, dst)
    elapsed, duration = time.perf_counter()-started, len(samples)/model.SAMPLE_RATE
    print(f"{n}/{len(missing)} id={chunk['id']} {len(chunk['text'].split())}w -> {duration:.1f}s "
          f"in {elapsed:.1f}s, speed={duration/elapsed:.2f}x", flush=True)


def package(work:Path, output:Path, title:str, author:str):
  try: import av, numpy as np, soundfile as sf
  except ImportError as e: raise SystemExit("M4B packaging requires PyAV and soundfile: pip install av soundfile") from e
  manifest = json.loads((work/"manifest.json").read_text())
  wavs = [work/"chunks_wav"/f"{x['id']:05d}.wav" for x in manifest["chunks"]]
  missing = [x for x in wavs if not x.is_file()]
  if missing: raise SystemExit(f"only {len(wavs)-len(missing)}/{len(wavs)} chunks rendered")
  durations = {}
  for wav in wavs:
    with wave.open(str(wav)) as f: durations[int(wav.stem)] = f.getnframes()/f.getframerate()
  chapters, cursor = [], 0.0
  for i,chapter in enumerate(manifest["chapters"]):
    duration = sum(durations[x] for x in chapter["chunks"])
    chapters.append({"id":i, "start":round(cursor*1000), "end":round((cursor+duration)*1000),
                     "time_base":Fraction(1,1000), "metadata":{"title":chapter["title"]}})
    cursor += duration

  output.parent.mkdir(parents=True, exist_ok=True)
  container = av.open(str(output), mode="w", format="ipod")
  container.metadata.update({"title":title, "artist":author, "genre":"Audiobook"})
  container.set_chapters(chapters)
  stream = container.add_stream("aac", rate=24000); stream.bit_rate = 96000; stream.layout = "mono"
  sample_cursor = 0
  for wav in wavs:
    samples,sr = sf.read(wav, dtype="float32", always_2d=False)
    if sr != 24000: raise SystemExit(f"unexpected sample rate {sr} in {wav}")
    frame = av.AudioFrame.from_ndarray(np.asarray(samples).reshape(1,-1), format="fltp", layout="mono")
    frame.sample_rate, frame.pts, frame.time_base = sr, sample_cursor, Fraction(1,sr)
    for packet in stream.encode(frame): container.mux(packet)
    sample_cursor += len(samples)
  for packet in stream.encode(): container.mux(packet)
  container.close()
  print(f"wrote {output} ({cursor/3600:.2f} hours, {len(chapters)} chapters)")


def main():
  ap = argparse.ArgumentParser(description=__doc__)
  ap.add_argument("voice", type=Path, help="reference voice audio")
  ap.add_argument("source", type=Path, help="new text as .txt or text-layer .pdf")
  ap.add_argument("--model", default=os.getenv("QWEN_TTS_MODEL", "Qwen/Qwen3-TTS-12Hz-1.7B-Base"))
  ap.add_argument("--voice-text", help="exact transcript of the voice sample; transcribed automatically when omitted")
  ap.add_argument("--language", default="English")
  ap.add_argument("--output", type=Path); ap.add_argument("--work", type=Path)
  ap.add_argument("--pages", type=page_range, metavar="START[-END]", help="render only these 1-based PDF pages (inclusive)")
  ap.add_argument("--title"); ap.add_argument("--author", default="")
  ap.add_argument("--words", type=int, default=130); ap.add_argument("--max-frames", type=int, default=2048)
  ap.add_argument("--temperature", type=float, default=.9); ap.add_argument("--top-k", type=int, default=50)
  args = ap.parse_args()
  if not args.voice.is_file(): raise SystemExit(f"voice sample not found: {args.voice}")
  if not args.source.is_file() or args.source.suffix.lower() not in {".txt", ".pdf"}:
    raise SystemExit(f"source must be an existing .txt or .pdf file: {args.source}")
  if args.pages is not None and args.source.suffix.lower() != ".pdf": raise SystemExit("--pages is only valid for PDF sources")
  if args.pages is not None and (args.pages[0] < 1 or (args.pages[1] is not None and args.pages[1] < args.pages[0])):
    raise SystemExit("--pages must be START, START-END, or START-")
  page_suffix = "" if args.pages is None else f"-pages-{args.pages[0]}-{args.pages[1] or 'end'}"
  work = args.work or Path("build/au")/f"{args.source.stem}{page_suffix}"
  output = args.output or work/f"{args.source.stem}.m4b"
  model_path, voice_text = resolve_model(args.model), args.voice_text or transcribe(args.voice)
  if not (work/"manifest.json").exists(): prepare(args.source, work, args.words, args.pages)
  (work/"voice_text.txt").write_text(voice_text+"\n")
  render(work, model_path, args.voice, voice_text, args.language, args.max_frames, args.temperature, args.top_k)
  package(work, output, args.title or args.source.stem.replace("_", " "), args.author)


if __name__ == "__main__": main()
