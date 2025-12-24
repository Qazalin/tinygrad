from extra.assembly.rdna3.isa import *
from extra.assembly.rdna3.lib import *

from tinygrad.runtime.support.compiler_amd import HIPCompiler
from tinygrad.runtime.support.elf import elf_loader
from extra.assembly.rdna3.co import fmt_asm

code = s_cmp_eq_i32(s[2], s[1])

lib = HIPCompiler("gfx1100").compile(fmt_asm("s_cmp_eq_i32 s2 s1"))
image, sections, _ = elf_loader(lib)
data = next((s for s in sections if s.name.startswith(".text"))).content
code_llvm = int.from_bytes(data, byteorder="little", signed=False)

assert code_llvm == code
