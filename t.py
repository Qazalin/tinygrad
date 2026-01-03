with open("./extra/gemm/asm/rdna3/trace.s", "r") as f: src = f.read()

class PC(int):
  def __repr__(self): return f"{self:012X}"

lines = src.splitlines()
code = []
pc_map = {}
pcs = []
for i,s in enumerate(lines):
  asm, pc = s.split(" // ")
  pc = int("0X"+pc, base=16)
  code.append((asm, PC(pc)))
  pc_map[pc] = asm

pcs = {**pc_map}
#with open("./extra/gemm/asm/rdna3/trace2.s", "r") as f: src = f.read()

hits = {}
for i,(asm,pc) in enumerate(code):
  hits[pc] = hits.get(pc, 0)+1

new_lines:list[str] = []
curr = None
cnt = 0
for k,v in hits.items():
  asm = pc_map[k]
  if v == 1:
    if "branch" in asm or "pc" in asm:
      new_lines.append(f"  // {asm}")
      continue
    new_lines.append(f"  {asm} // {k:012X}")
    continue
  if curr is None:
    cnt += 1
    new_lines.append(f"\nloop_n{cnt}:")
    curr = k
  if "branch" in asm: curr = None
  #print(f"  {asm} // {k:012X} hits={v}")
  new_lines.append(f"  {asm} // {k:012X}")

with open("./extra/gemm/asm/rdna3/trace2.s", "w") as f: f.write("\n".join(new_lines))
