import subprocess

from tinygrad.runtime.ops_hip import compile_hip

with open("/home/qazal/rdna/app.cpp", "r") as file:
    prg = file.read().splitlines()

kernel = "#include <hip/hip_runtime.h>\n"
for line in prg[3:]:
    if "printf" not in line:
        kernel += line + "\n"
    if line == "}":
        break

lib = compile_hip(kernel)
asm_output = subprocess.check_output(["/opt/rocm/llvm/bin/llvm-objdump", '-d', '-'], input=lib)
asm = '\n'.join([x for x in asm_output.decode('utf-8').split("\n") if 's_code_end' not in x][6:])

print(asm)

prg = []
registers = []
for instr in asm.splitlines():
  if "v_mov_b32_e32" in instr:
    loc = f'vec_reg[{instr.strip().split(" ")[1].replace("v", "").replace(",", "")}]'
    val = instr.strip().split(" ")[2].strip()
    if not "v" in val: registers.append((loc,val))
  else:
    prg += list(map(lambda x: "0x"+x, instr.strip().split("//")[-1].split(":")[1].strip().split(" ")))

prg = [code for code in prg if code != "0xBFB00000"]
prg.append("END_PRG")

test = "let mut cpu = _helper_test_cpu();\n"
for reg, val in registers: test += f"cpu.{reg} = {val};\n"
prg_str = str(prg).replace("'", '')
test += f"cpu.interpret(&vec!{prg_str});"

print(test)
