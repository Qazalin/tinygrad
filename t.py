with open("./extra/gemm/asm/rdna3/gemm2.s", "r") as f: asm = f.read()

lines = []
for inst in asm.splitlines():
  if "<" not in inst: lines.append(inst)
  else:
    pc, name = inst.replace("<", "").replace(">", "").split(" ")
    lines.append(f"{name} // {pc}")


with open("./extra/gemm/asm/rdna3/gemm2.s", "r") as f:
  f.write("\n".join(lines)

