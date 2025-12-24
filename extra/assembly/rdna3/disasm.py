from extra.assembly.rdna3.isa import *
from extra.assembly.rdna3.lib import *

def disassemble(buf:bytes):
  ret:str = ""
  off = 0
  while off + 4 <= len(buf):
    word = int.from_bytes(buf[off:off+4], "little")
    ret += disasm_word(word)+"\n"
    off += 4
  return ret

def disasm_word(word:int) -> str:
  for fmt in FORMATS:
    if fmt.match(word): return fmt.to_str(word)
  return f"0x{word:08x}"
