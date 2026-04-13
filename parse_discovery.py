import re
from pathlib import Path


def main() -> int:
  path = Path("discovery.md")
  if not path.exists():
    print("error: discovery.md not found")
    return 1

  kernels = 0
  covered_seconds = 0.0

  for line in path.read_text().splitlines():
    s = line.strip()
    if not s.startswith("|"):
      continue
    if s.startswith("| rank ") or s.startswith("| ---"):
      continue

    cols = [c.strip() for c in s.split("|")[1:-1]]
    if len(cols) < 7:
      continue
    if not re.fullmatch(r"\d+", cols[0]):
      continue

    try:
      total_ms = float(cols[2])
    except ValueError:
      continue

    kernels += 1
    covered_seconds += total_ms / 1000.0

  print(f"kernels: {kernels}")
  print(f"covered_seconds: {covered_seconds:.6f}")
  return 0


if __name__ == "__main__":
  raise SystemExit(main())
