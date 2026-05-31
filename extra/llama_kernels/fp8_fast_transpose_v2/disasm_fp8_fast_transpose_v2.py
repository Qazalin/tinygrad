#!/usr/bin/env python3
from __future__ import annotations
import argparse, subprocess
from pathlib import Path
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler

def main():
  ap = argparse.ArgumentParser()
  ap.add_argument("--rows", type=int, default=16384)
  ap.add_argument("--cols", type=int, default=4096)
  ap.add_argument("--load-size", type=int, default=4)
  ap.add_argument("--store-size", type=int, default=4)
  ap.add_argument("--symbol", default="fp8_fast_transpose_v2")
  ap.add_argument("--out", default="/tmp/opencode/fp8_fast_transpose_v2")
  args = ap.parse_args()
  src = (Path(__file__).parent/"fp8_fast_transpose_v2.cpp").read_text()
  defines = [f"-DROWS_DIM={args.rows}", f"-DCOLS_DIM={args.cols}", f"-DLOAD_SIZE={args.load_size}", f"-DSTORE_SIZE={args.store_size}"]
  lib = HIPCCCompiler("gfx950", ["-std=c++20", "-ffast-math", *defines]).compile_cached(src)
  stem = Path(f"{args.out}_{args.rows}_{args.cols}_l{args.load_size}_s{args.store_size}")
  obj = stem.with_suffix(".o")
  dis = stem.with_suffix(".dis")
  obj.write_bytes(lib)
  with dis.open("w") as f:
    subprocess.run(["/opt/rocm/llvm/bin/llvm-objdump", "-d", "--mcpu=gfx950", str(obj)], check=True, stdout=f)
  all_lines = dis.read_text(errors="ignore").splitlines()
  lines:list[str] = []
  in_symbol = False
  for line in all_lines:
    if f"<{args.symbol}>:" in line:
      in_symbol = True
      lines.append(line)
      continue
    if in_symbol and line and not line.startswith(" ") and "<" in line and ">:" in line: break
    if in_symbol: lines.append(line)
  if not lines: raise RuntimeError(f"symbol {args.symbol!r} not found in {dis}")

  counts:dict[str, int] = {}
  for line in lines:
    if "\t" not in line: continue
    op = line.split("\t")[-1].split()[0]
    counts[op] = counts.get(op, 0) + 1
  print(obj)
  print(dis)
  for op in sorted(counts, key=counts.get, reverse=True)[:40]: print(f"{counts[op]:4d} {op}")

if __name__ == "__main__": main()
