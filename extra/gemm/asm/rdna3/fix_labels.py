with open("./extra/gemm/asm/rdna3/gemm2.s", "r") as f:
  src = f.read()

lines = []
for line in src.splitlines():
  if "<" not in line:
    lines.append(line)
    continue
  else:
    addr, label = line.replace("<", "").replace(">", "").split()
    lines.append(f"{label} // {addr}")

with open("./extra/gemm/asm/rdna3/gemm3.s", "w") as f:
  f.write("\n".join(lines))
