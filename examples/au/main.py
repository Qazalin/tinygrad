#!/usr/bin/env python3
"""Create a cloned-voice audiobook: main.py VOICE_SAMPLE (.txt|.pdf) [options]."""
from __future__ import annotations
import argparse, json, os, subprocess, sys
from pathlib import Path
from audiobook import package, prepare


def resolve_model(value:str) -> Path:
  path = Path(value).expanduser()
  if path.exists(): return path.resolve()
  try:
    from huggingface_hub import snapshot_download
    return Path(snapshot_download(value))
  except ImportError as e:
    raise SystemExit(f"model {value!r} is not a local path; install huggingface_hub to download it") from e


def transcribe(voice:Path) -> str:
  try: from faster_whisper import WhisperModel
  except ImportError as e:
    raise SystemExit("provide --voice-text or install faster-whisper for automatic reference transcription") from e
  model = WhisperModel("small", device="cpu", compute_type="int8")
  segments,_ = model.transcribe(str(voice), beam_size=5)
  text = " ".join(x.text.strip() for x in segments).strip()
  if not text: raise SystemExit("the voice sample transcription was empty; provide --voice-text")
  return text


def worker_devices(count:int) -> list[str|None]:
  if count == 1: return [None]
  backend = os.getenv("DEV", "").upper()
  if backend not in {"NV", "CUDA"}: return [None]*count
  visible = os.getenv("CUDA_VISIBLE_DEVICES")
  devices = visible.split(",") if visible else [str(i) for i in range(count)]
  if len(devices) < count: raise SystemExit(f"--shard {count} requested, but only {len(devices)} CUDA devices are visible")
  return devices[:count]


def main():
  ap = argparse.ArgumentParser(description=__doc__)
  ap.add_argument("voice", type=Path, help="reference voice audio")
  ap.add_argument("source", type=Path, help="new text as .txt or text-layer .pdf")
  ap.add_argument("--shard", type=int, default=1, metavar="N", help="run N synthesis worker shards (default: 1)")
  ap.add_argument("--model", default=os.getenv("QWEN_TTS_MODEL", "Qwen/Qwen3-TTS-12Hz-1.7B-Base"))
  ap.add_argument("--voice-text", help="exact transcript of the voice sample; transcribed automatically when omitted")
  ap.add_argument("--language", default="English")
  ap.add_argument("--output", type=Path)
  ap.add_argument("--work", type=Path)
  ap.add_argument("--title"); ap.add_argument("--author", default="")
  ap.add_argument("--words", type=int, default=130); ap.add_argument("--max-frames", type=int, default=2048)
  ap.add_argument("--temperature", type=float, default=.9); ap.add_argument("--top-k", type=int, default=50)
  args = ap.parse_args()
  if not args.voice.is_file(): raise SystemExit(f"voice sample not found: {args.voice}")
  if not args.source.is_file() or args.source.suffix.lower() not in {".txt", ".pdf"}:
    raise SystemExit(f"source must be an existing .txt or .pdf file: {args.source}")
  if args.shard < 1: raise SystemExit("--shard must be at least 1")
  work = args.work or Path("build/au")/args.source.stem
  output = args.output or work/f"{args.source.stem}.m4b"
  model, voice_text = resolve_model(args.model), args.voice_text or transcribe(args.voice)
  if not (work/"manifest.json").exists(): prepare(args.source, work, args.words)
  (work/"voice_text.txt").write_text(voice_text+"\n")

  processes = []
  for index,device in enumerate(worker_devices(args.shard)):
    cmd = [sys.executable, str(Path(__file__).with_name("audiobook.py")), "render", "--work", str(work), "--model", str(model),
           "--voice", str(args.voice), "--voice-text", voice_text, "--language", args.language, "--shard", str(index),
           "--shards", str(args.shard), "--max-frames", str(args.max_frames), "--temperature", str(args.temperature),
           "--top-k", str(args.top_k)]
    env = os.environ.copy()
    if device is not None: env["CUDA_VISIBLE_DEVICES"] = device
    log = (work/f"shard{index}.log").open("a")
    processes.append((subprocess.Popen(cmd, env=env, stdout=log, stderr=subprocess.STDOUT), log, index))
  failed = []
  for proc,log,index in processes:
    if proc.wait(): failed.append(index)
    log.close()
  if failed: raise SystemExit(f"worker shards failed: {failed}; inspect {work}/shardN.log")
  package(work, output, args.title or args.source.stem.replace("_", " "), args.author)


if __name__ == "__main__": main()
