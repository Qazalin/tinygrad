from __future__ import annotations
import argparse, json, struct, wave
from pathlib import Path
from tinygrad.tts.model import Qwen3TTS
from tinygrad.tts.codec import Qwen3TTSCodec
from tinygrad.llm.cli import SimpleTokenizer


def load_tokenizer(path:Path) -> SimpleTokenizer:
  vocab:dict[str,int] = json.loads((path/"vocab.json").read_text())
  cfg = json.loads((path/"tokenizer_config.json").read_text())
  specials = {entry["content"]:int(idx) for idx,entry in cfg["added_tokens_decoder"].items() if entry["special"]}
  normal = {token:idx for token,idx in vocab.items() if idx not in specials.values()}
  return SimpleTokenizer(normal, specials, preset="qwen2", eos_id=151645)


def write_wav(path:Path, samples:list[float], sample_rate:int=24000):
  pcm = struct.pack(f"<{len(samples)}h", *(max(-32768, min(32767, round(x*32767))) for x in samples))
  with wave.open(str(path), "wb") as f:
    f.setnchannels(1)
    f.setsampwidth(2)
    f.setframerate(sample_rate)
    f.writeframes(pcm)


def main():
  parser = argparse.ArgumentParser(description="Qwen3-TTS inference in pure tinygrad")
  parser.add_argument("text", help="text to synthesize")
  parser.add_argument("--model", "-m", type=Path, required=True, help="local Qwen3-TTS model snapshot")
  parser.add_argument("--speaker", default="ryan")
  parser.add_argument("--language", default="english")
  parser.add_argument("--output", "-o", type=Path, default=Path("output.wav"))
  parser.add_argument("--max-new-tokens", type=int, default=2048)
  parser.add_argument("--temperature", type=float, default=0.9)
  parser.add_argument("--top-k", type=int, default=50)
  args = parser.parse_args()

  tok = load_tokenizer(args.model)
  prompt = f"<|im_start|>assistant\n{args.text}<|im_end|>\n<|im_start|>assistant\n"
  print("loading talker...")
  model = Qwen3TTS.from_pretrained(args.model, max_context=args.max_new_tokens+len(tok.encode(prompt))+32)
  print("generating codec tokens...")
  codes = model.generate_codes(tok.encode(prompt), args.speaker, args.language, args.max_new_tokens, args.temperature, args.top_k)
  print(f"generated {codes.shape[-1]} frames; loading decoder...")
  codec = Qwen3TTSCodec.from_pretrained(args.model/"speech_tokenizer")
  wav = codec.decoder.chunked_decode(codes).float().flatten().numpy().tolist()
  write_wav(args.output, wav)
  print(f"wrote {args.output} ({len(wav)/model.SAMPLE_RATE:.2f}s at {model.SAMPLE_RATE} Hz)")


if __name__ == "__main__": main()
