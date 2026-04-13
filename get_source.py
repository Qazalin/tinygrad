import json
import sys
from pathlib import Path


def main() -> int:
  if len(sys.argv) != 2:
    print("usage: python3 get_source.py <kernel_name>")
    return 1

  name = sys.argv[1]
  src_path = Path("sources.txt")
  if not src_path.exists():
    print("error: sources.txt not found")
    return 1

  with src_path.open("r") as f:
    sources = json.load(f)

  if name not in sources:
    print(f"error: kernel not found: {name}")
    return 2

  src, ast = sources[name]

  print(f"name: {name}")
  print("=== AST ===")
  print(ast if ast is not None else "<missing>")
  print("=== SOURCE ===")
  print(src if src is not None else "<missing>")
  return 0


if __name__ == "__main__":
  raise SystemExit(main())
