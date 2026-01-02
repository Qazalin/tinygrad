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
srcs = {}
for i,(asm,pc) in enumerate(code):
  if "branch" in asm:
    next_asm, next_pc = code[i+1]
    hits[next_pc] = hits.get(next_pc, 0)+1
    srcs.setdefault(next_pc, []).append(pc)

DONT_REMOVE = set()
for k,v in hits.items():
  ss = set(srcs[k])
  if v > 1:
    print(PC(k), pc_map[k], v)
    for s in ss: DONT_REMOVE.add(s)

for ss in srcs.values():
  for s in ss:
    if s not in DONT_REMOVE:
      del pcs[s]

new_lines = []
for addr,asm in pcs.items():
  new_lines.append(f"{asm} // {addr:012X}")
with open("./extra/gemm/asm/rdna3/trace2.s", "w") as f: f.write("\n".join(new_lines))
