# minimal amdgpu elf packer
import ctypes
from tinygrad.runtime.autogen import hsa, libc

from extra.amdgpu_elf.autogen import pack_rodata

def align_up(x:int, a:int) -> int: return (x + (a - 1)) & ~(a - 1)

def put(dst:bytearray, off:int, data:bytes) -> None:
  end = off + len(data)
  if end > len(dst): raise ValueError("write past end of buffer")
  dst[off:end] = data

def pack_hsaco(prg:bytes, kd:dict, arch:str) -> bytes:
  text = prg + b'\x00' * ((hsa.AMD_ISA_ALIGN_BYTES - len(prg) % hsa.AMD_ISA_ALIGN_BYTES) % hsa.AMD_ISA_ALIGN_BYTES)
  text_offset = align_up(ctypes.sizeof(libc.Elf64_Ehdr), hsa.AMD_ISA_ALIGN_BYTES)
  rodata_offset = text_offset + len(text)
  rodata = pack_rodata(kd, text_offset-rodata_offset, arch)

  sh_names:list[int] = []
  strtab = bytearray(b"\x00")
  for name in [".text", ".rodata", ".strtab"]:
    sh_names.append(len(strtab))
    strtab += name.encode("ascii") + b"\x00"

  rodata_offset = align_up(text_offset+(text_size:=len(text)), hsa.AMD_KERNEL_CODE_ALIGN_BYTES)
  strtab_offset = rodata_offset+(rodata_size:=len(rodata))
  shdr_offset   = strtab_offset+(strtab_size:=len(strtab))

  sections = [(libc.SHT_PROGBITS, libc.SHF_ALLOC | libc.SHF_EXECINSTR, text_offset, text_offset, text_size),
              (libc.SHT_PROGBITS, libc.SHF_ALLOC, rodata_offset, rodata_offset, rodata_size),
              (libc.SHT_STRTAB, 0, 0, strtab_offset, strtab_size)]
  shdrs = (libc.Elf64_Shdr * len(sections))()
  for i,s in enumerate(sections): shdrs[i] = libc.Elf64_Shdr(sh_names[i], *s)

  ehdr = libc.Elf64_Ehdr()
  ehdr.e_shoff, ehdr.e_shnum, ehdr.e_shstrndx = shdr_offset, len(sections), 2

  elf = bytearray(shdr_offset + ctypes.sizeof(shdrs))
  put(elf, 0, bytes(ehdr))
  put(elf, text_offset, text)
  put(elf, rodata_offset, rodata)
  put(elf, strtab_offset, strtab)
  put(elf, shdr_offset, bytes(shdrs))
  return bytes(elf)
