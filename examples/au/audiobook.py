#!/usr/bin/env python3
"""Resume-safe PDF -> cloned-voice audiobook using Qwen3-TTS Base in tinygrad."""
from __future__ import annotations
import argparse, json, os, re, subprocess, time, wave
from pathlib import Path


def sentences(text:str) -> list[str]:
  return [x.strip() for x in re.split(r"(?<=[.!?])\s+", re.sub(r"\s+", " ", text)) if x.strip()]


def prepare(source:Path, work:Path, words:int):
  work.mkdir(parents=True, exist_ok=True)
  if source.suffix.lower() == ".txt": raw_chapters = [(source.stem, source.read_text(encoding="utf-8"))]
  elif source.suffix.lower() == ".pdf":
    try: import fitz
    except ImportError as e: raise SystemExit("PDF extraction requires PyMuPDF: pip install pymupdf") from e
    doc = fitz.open(source)
    toc = [row for row in doc.get_toc(simple=True) if row[0] == 1]
    starts = [(title, max(0, page-1)) for _,title,page in toc] or [(source.stem, 0)]
    raw_chapters = [(title, "\n".join(doc[p].get_text("text", sort=True)
                     for p in range(start, starts[i+1][1] if i+1 < len(starts) else len(doc))))
                    for i,(title,start) in enumerate(starts)]
  else: raise SystemExit("source must be a .txt or .pdf file")
  chapters, chunks, cid = [], [], 0
  for i,(title,text) in enumerate(raw_chapters):
    text = re.sub(r"(?<=\w)-\s*\n\s*(?=\w)", "", text)
    units, current = sentences(text), []
    chapter_ids = []
    for unit in units:
      if current and len(" ".join(current).split()) + len(unit.split()) > words:
        chunks.append({"id":cid, "chapter":i, "title":title, "text":" ".join(current)}); chapter_ids.append(cid); cid += 1; current=[]
      current.append(unit)
    if current: chunks.append({"id":cid, "chapter":i, "title":title, "text":" ".join(current)}); chapter_ids.append(cid); cid += 1
    chapters.append({"title":title, "chunks":chapter_ids})
  (work/"manifest.json").write_text(json.dumps({"source":str(source), "chapters":chapters, "chunks":chunks}, indent=2))
  print(f"prepared {len(chapters)} chapters, {len(chunks)} chunks, {sum(len(x['text'].split()) for x in chunks)} words")


def render(args):
  import numpy as np
  try: import librosa, soundfile as sf
  except ImportError as e: raise SystemExit("audio I/O requires librosa and soundfile") from e
  from tinygrad import Tensor
  from tinygrad.tts.cli import load_tokenizer
  from tinygrad.tts.codec import Qwen3TTSCodec
  from tinygrad.tts.model import Qwen3TTS

  manifest = json.loads((args.work/"manifest.json").read_text())
  mine = [x for x in manifest["chunks"] if x["id"] % args.shards == args.shard]
  outdir = args.work/"chunks_wav"; outdir.mkdir(exist_ok=True)
  tok = load_tokenizer(args.model)
  target_ids = lambda text: tok.encode(f"<|im_start|>assistant\n{text}<|im_end|>\n<|im_start|>assistant\n")
  ref_ids = tok.encode(f"<|im_start|>assistant\n{args.voice_text}<|im_end|>\n")
  wav,sr = librosa.load(args.voice, sr=None, mono=True)
  model = Qwen3TTS.from_pretrained(args.model, max_context=args.max_frames+len(ref_ids)+512)
  codec = Qwen3TTSCodec.from_pretrained(args.model/"speech_tokenizer", encoder=True)
  prompt = model.create_voice_clone_prompt(wav, sr, ref_ids, codec)
  print(f"shard {args.shard}: prompt={prompt.codes.shape[0]} frames, chunks={len(mine)}", flush=True)
  ref_codes = prompt.codes.transpose(0,1).unsqueeze(0)
  for n,chunk in enumerate(mine,1):
    dst = outdir/f"{chunk['id']:05d}.wav"
    if dst.exists(): continue
    started = time.perf_counter()
    codes = model.generate_voice_clone_codes(target_ids(chunk["text"]), prompt, args.language, args.max_frames,
                                              args.temperature, args.top_k)
    joined = Tensor.cat(ref_codes, codes, dim=2)
    audio = codec.decoder.chunked_decode(joined, fixed_shape=True)[..., prompt.codes.shape[0]*codec.decoder.total_upsample:]
    samples = audio.float().flatten().numpy().astype(np.float32)
    tmp = outdir/f".{chunk['id']:05d}.tmp.wav"; sf.write(tmp, samples, model.SAMPLE_RATE); os.replace(tmp, dst)
    elapsed, duration = time.perf_counter()-started, len(samples)/model.SAMPLE_RATE
    print(f"[{args.shard}] {n}/{len(mine)} id={chunk['id']} {len(chunk['text'].split())}w -> {duration:.1f}s "
          f"in {elapsed:.1f}s, speed={duration/elapsed:.2f}x", flush=True)


def package(work:Path, output:Path, title:str, author:str):
  manifest = json.loads((work/"manifest.json").read_text())
  wavs = sorted((work/"chunks_wav").glob("[0-9]*.wav"))
  if len(wavs) != len(manifest["chunks"]): raise SystemExit(f"only {len(wavs)}/{len(manifest['chunks'])} chunks rendered")
  durations = {}
  for wav in wavs:
    with wave.open(str(wav)) as f: durations[int(wav.stem)] = f.getnframes()/f.getframerate()
  concat = work/"concat.txt"; concat.write_text("\n".join(f"file '{x.resolve()}'" for x in wavs)+"\n")
  meta, cursor = [";FFMETADATA1", f"title={title}", f"artist={author}", "genre=Audiobook"], 0.0
  for chapter in manifest["chapters"]:
    duration = sum(durations[x] for x in chapter["chunks"])
    meta += ["[CHAPTER]", "TIMEBASE=1/1000", f"START={int(cursor*1000)}", f"END={int((cursor+duration)*1000)}",
             f"title={chapter['title'].replace('=', r'\=')}"]
    cursor += duration
  metadata = work/"chapters.ffmeta"; metadata.write_text("\n".join(meta)+"\n")
  output.parent.mkdir(parents=True, exist_ok=True)
  subprocess.run(["ffmpeg","-y","-loglevel","error","-f","concat","-safe","0","-i",str(concat),"-i",str(metadata),
                  "-map_metadata","1","-map","0:a","-c:a","aac","-b:a","96k","-movflags","+faststart",str(output)], check=True)
  print(f"wrote {output} ({cursor/3600:.2f} hours, {len(manifest['chapters'])} chapters)")


def main():
  ap=argparse.ArgumentParser(description=__doc__); sub=ap.add_subparsers(dest="command",required=True)
  p=sub.add_parser("prepare");p.add_argument("--pdf",type=Path,required=True);p.add_argument("--work",type=Path,required=True);p.add_argument("--words",type=int,default=130)
  r=sub.add_parser("render");r.add_argument("--work",type=Path,required=True);r.add_argument("--model",type=Path,required=True);r.add_argument("--voice",type=Path,required=True);r.add_argument("--voice-text",required=True);r.add_argument("--language",default="English");r.add_argument("--shard",type=int,default=0);r.add_argument("--shards",type=int,default=1);r.add_argument("--max-frames",type=int,default=2048);r.add_argument("--temperature",type=float,default=.9);r.add_argument("--top-k",type=int,default=50)
  k=sub.add_parser("package");k.add_argument("--work",type=Path,required=True);k.add_argument("--output",type=Path,required=True);k.add_argument("--title",required=True);k.add_argument("--author",default="")
  a=ap.parse_args()
  if a.command=="prepare": prepare(a.pdf,a.work,a.words)
  elif a.command=="render": render(a)
  else: package(a.work,a.output,a.title,a.author)
if __name__ == "__main__": main()
