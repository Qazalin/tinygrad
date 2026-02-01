# minimal amdgpu elf packer
import ctypes, struct, msgpack
from tinygrad.helpers import ceildiv, round_up
from tinygrad.runtime.autogen import amdgpu_kd, hsa, libc

# instructions used for padding
from extra.assembly.amd.autogen.rdna3.ins import s_code_end # same encoding as RDNA4
from extra.assembly.amd.autogen.cdna.ins import s_nop as s_nop_cdna

# AMDGPU ELF OS/ABI
ELFOSABI_AMDGPU_HSA = 0x40
ELFABIVERSION_AMDGPU_HSA_V5 = 0x04

# Symbol binding and type
STB_GLOBAL, STT_FUNC, STT_OBJECT = 1, 2, 1

# Dynamic tags
DT_NULL, DT_HASH, DT_STRTAB, DT_SYMTAB, DT_STRSZ, DT_SYMENT = 0, 4, 5, 6, 10, 11

def put(dst:bytearray, off:int, data:bytes) -> None:
  end = off + len(data)
  if end > len(dst): raise ValueError("write past end of buffer")
  dst[off:end] = data

def pack_sym(st_name:int, st_info:int, st_shndx:int, st_value:int, st_size:int) -> bytes:
  return struct.pack('<IBBHQQ', st_name, st_info, 0, st_shndx, st_value, st_size)

def pack_dyn(d_tag:int, d_val:int) -> bytes:
  return struct.pack('<QQ', d_tag, d_val)

def elf_hash(name:bytes) -> int:
  h = 0
  for c in name:
    h = (h << 4) + c
    g = h & 0xf0000000
    if g: h ^= g >> 24
    h &= ~g
  return h

def pack_hsaco(prg:bytes, kd:dict, name:str="kernel") -> bytes:
  is_cdna = 'wavefront_size' not in kd
  padding_inst = (s_nop_cdna(0) if is_cdna else s_code_end()).to_bytes()
  text = prg + padding_inst * ((hsa.AMD_ISA_ALIGN_BYTES - len(prg) % hsa.AMD_ISA_ALIGN_BYTES) % hsa.AMD_ISA_ALIGN_BYTES)

  # ** pack kernel descriptor (rodata)
  desc = amdgpu_kd.llvm_amdhsa_kernel_descriptor_t()
  desc.group_segment_fixed_size = kd.get('group_segment_fixed_size', 0)
  desc.private_segment_fixed_size = kd.get('private_segment_fixed_size', 0)
  desc.kernarg_size = kd.get('kernarg_size', 0)
  # rsrc1
  vgpr_granule = max(0, (kd['next_free_vgpr'] + 7) // 8 - 1)
  # CDNA: add 6 for VCC(2) + FLAT_SCRATCH(2) + XNACK_MASK(2)
  sgpr_granule = (2 * max(0, ceildiv(kd['next_free_sgpr'] + 6, 16) - 1)) if is_cdna else 0
  reserved1 = 0 if is_cdna else (kd.get('workgroup_processor_mode', 1) << 3) | (kd.get('memory_ordered', 1) << 4)
  desc.compute_pgm_rsrc1 = (vgpr_granule << hsa.AMD_COMPUTE_PGM_RSRC_ONE_GRANULATED_WORKITEM_VGPR_COUNT_SHIFT |
                            sgpr_granule << hsa.AMD_COMPUTE_PGM_RSRC_ONE_GRANULATED_WAVEFRONT_SGPR_COUNT_SHIFT |
                            3 << hsa.AMD_COMPUTE_PGM_RSRC_ONE_FLOAT_DENORM_MODE_32_SHIFT |
                            3 << hsa.AMD_COMPUTE_PGM_RSRC_ONE_FLOAT_DENORM_MODE_16_64_SHIFT |
                            kd.get('dx10_clamp', 1) << hsa.AMD_COMPUTE_PGM_RSRC_ONE_ENABLE_DX10_CLAMP_SHIFT |
                            kd.get('ieee_mode', 1) << hsa.AMD_COMPUTE_PGM_RSRC_ONE_ENABLE_IEEE_MODE_SHIFT |
                            reserved1 << hsa.AMD_COMPUTE_PGM_RSRC_ONE_RESERVED1_SHIFT)
  # rsrc2
  desc.compute_pgm_rsrc2 = (kd.get('user_sgpr_count', 0) << hsa.AMD_COMPUTE_PGM_RSRC_TWO_USER_SGPR_COUNT_SHIFT |
                            kd.get('system_sgpr_workgroup_id_x', 1) << hsa.AMD_COMPUTE_PGM_RSRC_TWO_ENABLE_SGPR_WORKGROUP_ID_X_SHIFT |
                            kd.get('system_sgpr_workgroup_id_y', 0) << hsa.AMD_COMPUTE_PGM_RSRC_TWO_ENABLE_SGPR_WORKGROUP_ID_Y_SHIFT |
                            kd.get('system_sgpr_workgroup_id_z', 0) << hsa.AMD_COMPUTE_PGM_RSRC_TWO_ENABLE_SGPR_WORKGROUP_ID_Z_SHIFT)
  # rsrc3, only cdna uses this
  accum_offset = kd.get('accum_offset', 0)
  amdhsa_accum_offset = ((accum_offset // 4) - 1) & amdgpu_kd.COMPUTE_PGM_RSRC3_GFX90A_ACCUM_OFFSET if accum_offset else 0
  desc.compute_pgm_rsrc3 = (amdhsa_accum_offset << amdgpu_kd.COMPUTE_PGM_RSRC3_GFX90A_ACCUM_OFFSET_SHIFT)
  # code properties, different for every arch
  desc.kernel_code_properties = (kd.get('user_sgpr_kernarg_segment_ptr', 0) << hsa.AMD_KERNEL_CODE_PROPERTIES_ENABLE_SGPR_KERNARG_SEGMENT_PTR_SHIFT |
                                 kd.get('uses_dynamic_stack', 0) << hsa.AMD_KERNEL_CODE_PROPERTIES_IS_DYNAMIC_CALLSTACK_SHIFT |
                                 kd.get('wavefront_size32', 0 if is_cdna else 1) << hsa.AMD_KERNEL_CODE_PROPERTIES_ENABLE_WAVEFRONT_SIZE32_SHIFT)
  rodata = bytes(desc)

  # ** string tables
  name_b = name.encode()
  name_kd_b = (name + ".kd").encode()
  dynstr = b"\x00" + name_b + b"\x00" + name_kd_b + b"\x00"
  strtab = b"\x00" + name_b + b"\x00" + name_kd_b + b"\x00"  # same content for now

  # ** hash table for 3 symbols (null, kernel, kernel.kd)
  nbucket, nchain = 3, 3
  buckets = [0, 0, 0]
  chains = [0, 0, 0]
  h1 = elf_hash(name_b) % nbucket
  h2 = elf_hash(name_kd_b) % nbucket
  buckets[h1] = 1
  buckets[h2] = 2
  hash_data = struct.pack('<II', nbucket, nchain) + struct.pack(f'<{nbucket}I', *buckets) + struct.pack(f'<{nchain}I', *chains)

  # ** AMDGPU metadata (note section)
  metadata = {
    'amdhsa.version': [1, 1],
    'amdhsa.kernels': [{
      '.name': name,
      '.symbol': name + '.kd',
      '.kernarg_segment_size': kd.get('kernarg_size', 0),
      '.kernarg_segment_align': 8,
      '.group_segment_fixed_size': kd.get('group_segment_fixed_size', 0),
      '.private_segment_fixed_size': kd.get('private_segment_fixed_size', 0),
      '.wavefront_size': 64,
      '.max_flat_workgroup_size': 256,
      '.sgpr_count': kd.get('next_free_sgpr', 0),
      '.vgpr_count': kd.get('next_free_vgpr', 0),
      '.sgpr_spill_count': 0,
      '.vgpr_spill_count': 0,
      '.args': [
        {'.name': 'C', '.size': 8, '.offset': 0, '.value_kind': 'global_buffer', '.address_space': 'generic'},
        {'.name': 'A', '.size': 8, '.offset': 8, '.value_kind': 'global_buffer', '.address_space': 'generic'},
        {'.name': 'B', '.size': 8, '.offset': 16, '.value_kind': 'global_buffer', '.address_space': 'generic'},
      ]
    }]
  }
  meta_bytes = msgpack.packb(metadata)
  # Note format: namesz(4) + descsz(4) + type(4) + name(aligned to 4) + desc(aligned to 4)
  note_name = b"AMDGPU\x00"
  note_name_aligned = note_name + b'\x00' * ((4 - len(note_name) % 4) % 4)
  meta_aligned = meta_bytes + b'\x00' * ((4 - len(meta_bytes) % 4) % 4)
  note = struct.pack('<III', len(note_name), len(meta_bytes), 32) + note_name_aligned + meta_aligned  # type 32 = NT_AMDGPU_METADATA

  # ** layout: ehdr | phdrs | note | dynsym | dynstr | hash | dynamic | rodata | text | symtab | strtab | shstrtab | shdrs
  ehdr_size = ctypes.sizeof(libc.Elf64_Ehdr)
  phdr_size = ctypes.sizeof(libc.Elf64_Phdr)
  shdr_size = ctypes.sizeof(libc.Elf64_Shdr)
  num_phdrs = 4  # PT_LOAD, PT_LOAD, PT_DYNAMIC, PT_NOTE

  note_offset = ehdr_size + num_phdrs * phdr_size
  dynsym_offset = note_offset + len(note)
  dynstr_offset = dynsym_offset + 3 * 24
  hash_offset = dynstr_offset + len(dynstr)
  dynamic_offset = hash_offset + len(hash_data)
  rodata_offset = round_up(dynamic_offset + 6 * 16, hsa.AMD_KERNEL_CODE_ALIGN_BYTES)
  text_offset = round_up(rodata_offset + len(rodata), hsa.AMD_ISA_ALIGN_BYTES)

  # kernel descriptor offset (positive from rodata to text)
  desc.kernel_code_entry_byte_offset = text_offset - rodata_offset
  rodata = bytes(desc)

  # symtab and strtab come after text
  symtab_offset = text_offset + len(text)
  strtab_offset = symtab_offset + 3 * 24  # 3 symbols

  # ** symbol tables (both dynsym and symtab have same symbols)
  # section indices: .note=1, .dynsym=2, .dynstr=3, .hash=4, .rodata=5, .text=6, .dynamic=7, .symtab=8, .strtab=9, .shstrtab=10
  dynsym = pack_sym(0, 0, 0, 0, 0)  # null symbol
  dynsym += pack_sym(1, (STB_GLOBAL << 4) | STT_FUNC, 6, text_offset, 0)  # kernel, section 6 (.text)
  dynsym += pack_sym(1 + len(name_b) + 1, (STB_GLOBAL << 4) | STT_OBJECT, 5, rodata_offset, len(rodata))  # kernel.kd, section 5 (.rodata)

  symtab = pack_sym(0, 0, 0, 0, 0)  # null symbol
  symtab += pack_sym(1, (STB_GLOBAL << 4) | STT_FUNC, 6, text_offset, 0)  # kernel
  symtab += pack_sym(1 + len(name_b) + 1, (STB_GLOBAL << 4) | STT_OBJECT, 5, rodata_offset, len(rodata))  # kernel.kd

  # ** dynamic section
  dynamic = pack_dyn(DT_SYMTAB, dynsym_offset)
  dynamic += pack_dyn(DT_SYMENT, 24)
  dynamic += pack_dyn(DT_STRTAB, dynstr_offset)
  dynamic += pack_dyn(DT_STRSZ, len(dynstr))
  dynamic += pack_dyn(DT_HASH, hash_offset)
  dynamic += pack_dyn(DT_NULL, 0)

  # ** section string table
  # sections: null, .note, .dynsym, .dynstr, .hash, .rodata, .text, .dynamic, .symtab, .strtab, .shstrtab
  shstrtab = b"\x00.note\x00.dynsym\x00.dynstr\x00.hash\x00.rodata\x00.text\x00.dynamic\x00.symtab\x00.strtab\x00.shstrtab\x00"
  shstrtab_offset = strtab_offset + len(strtab)
  shdr_offset = shstrtab_offset + len(shstrtab)
  num_sections = 11

  # section name offsets: .note=1, .dynsym=7, .dynstr=15, .hash=23, .rodata=29, .text=37, .dynamic=43, .symtab=52, .strtab=60, .shstrtab=68
  def make_shdr(sh_name, sh_type, sh_flags, sh_addr, sh_offset, sh_size, sh_link=0, sh_info=0, sh_addralign=0, sh_entsize=0):
    shdr = libc.Elf64_Shdr()
    shdr.sh_name, shdr.sh_type, shdr.sh_flags = sh_name, sh_type, sh_flags
    shdr.sh_addr, shdr.sh_offset, shdr.sh_size = sh_addr, sh_offset, sh_size
    shdr.sh_link, shdr.sh_info, shdr.sh_addralign, shdr.sh_entsize = sh_link, sh_info, sh_addralign, sh_entsize
    return shdr

  shdrs = (libc.Elf64_Shdr * num_sections)()
  shdrs[0] = make_shdr(0, libc.SHT_NULL, 0, 0, 0, 0)
  shdrs[1] = make_shdr(1, libc.SHT_NOTE, libc.SHF_ALLOC, note_offset, note_offset, len(note), sh_addralign=4)
  shdrs[2] = make_shdr(7, libc.SHT_DYNSYM, libc.SHF_ALLOC, dynsym_offset, dynsym_offset, len(dynsym), sh_link=3, sh_info=1, sh_addralign=8, sh_entsize=24)
  shdrs[3] = make_shdr(15, libc.SHT_STRTAB, libc.SHF_ALLOC, dynstr_offset, dynstr_offset, len(dynstr), sh_addralign=1)
  shdrs[4] = make_shdr(23, libc.SHT_HASH, libc.SHF_ALLOC, hash_offset, hash_offset, len(hash_data), sh_link=2, sh_addralign=4, sh_entsize=4)
  shdrs[5] = make_shdr(29, libc.SHT_PROGBITS, libc.SHF_ALLOC, rodata_offset, rodata_offset, len(rodata), sh_addralign=hsa.AMD_KERNEL_CODE_ALIGN_BYTES)
  shdrs[6] = make_shdr(37, libc.SHT_PROGBITS, libc.SHF_ALLOC | libc.SHF_EXECINSTR, text_offset, text_offset, len(text), sh_addralign=hsa.AMD_ISA_ALIGN_BYTES)
  shdrs[7] = make_shdr(43, libc.SHT_DYNAMIC, libc.SHF_ALLOC | libc.SHF_WRITE, dynamic_offset, dynamic_offset, len(dynamic), sh_link=3, sh_addralign=8, sh_entsize=16)
  shdrs[8] = make_shdr(52, libc.SHT_SYMTAB, 0, 0, symtab_offset, len(symtab), sh_link=9, sh_info=1, sh_addralign=8, sh_entsize=24)
  shdrs[9] = make_shdr(60, libc.SHT_STRTAB, 0, 0, strtab_offset, len(strtab), sh_addralign=1)
  shdrs[10] = make_shdr(68, libc.SHT_STRTAB, 0, 0, shstrtab_offset, len(shstrtab), sh_addralign=1)

  # ** ELF header
  ehdr = libc.Elf64_Ehdr()
  ehdr.e_ident[0:4] = [0x7f, ord('E'), ord('L'), ord('F')]
  ehdr.e_ident[4] = libc.ELFCLASS64
  ehdr.e_ident[5] = libc.ELFDATA2LSB
  ehdr.e_ident[6] = 1  # EV_CURRENT
  ehdr.e_ident[7] = ELFOSABI_AMDGPU_HSA
  ehdr.e_ident[8] = ELFABIVERSION_AMDGPU_HSA_V5
  ehdr.e_type = libc.ET_DYN
  ehdr.e_machine = libc.EM_AMDGPU
  ehdr.e_version = 1
  ehdr.e_phoff = ehdr_size
  ehdr.e_shoff = shdr_offset
  ehdr.e_flags = kd['e_flags']
  ehdr.e_ehsize = ehdr_size
  ehdr.e_phentsize = phdr_size
  ehdr.e_phnum = num_phdrs
  ehdr.e_shentsize = shdr_size
  ehdr.e_shnum = num_sections
  ehdr.e_shstrndx = 10  # .shstrtab is section 10

  # ** program headers
  phdrs = (libc.Elf64_Phdr * num_phdrs)()
  # PT_LOAD for headers + note + dynsym + dynstr + hash + dynamic + rodata
  phdrs[0].p_type = libc.PT_LOAD
  phdrs[0].p_flags = libc.PF_R
  phdrs[0].p_offset = 0
  phdrs[0].p_vaddr = 0
  phdrs[0].p_paddr = 0
  phdrs[0].p_filesz = rodata_offset + len(rodata)
  phdrs[0].p_memsz = phdrs[0].p_filesz
  phdrs[0].p_align = 0x1000

  # PT_LOAD for text
  phdrs[1].p_type = libc.PT_LOAD
  phdrs[1].p_flags = libc.PF_R | libc.PF_X
  phdrs[1].p_offset = text_offset
  phdrs[1].p_vaddr = text_offset
  phdrs[1].p_paddr = text_offset
  phdrs[1].p_filesz = len(text)
  phdrs[1].p_memsz = len(text)
  phdrs[1].p_align = 0x1000

  # PT_DYNAMIC
  phdrs[2].p_type = libc.PT_DYNAMIC
  phdrs[2].p_flags = libc.PF_R | libc.PF_W
  phdrs[2].p_offset = dynamic_offset
  phdrs[2].p_vaddr = dynamic_offset
  phdrs[2].p_paddr = dynamic_offset
  phdrs[2].p_filesz = len(dynamic)
  phdrs[2].p_memsz = len(dynamic)
  phdrs[2].p_align = 8

  # PT_NOTE
  phdrs[3].p_type = libc.PT_NOTE
  phdrs[3].p_flags = libc.PF_R
  phdrs[3].p_offset = note_offset
  phdrs[3].p_vaddr = note_offset
  phdrs[3].p_paddr = note_offset
  phdrs[3].p_filesz = len(note)
  phdrs[3].p_memsz = len(note)
  phdrs[3].p_align = 4

  elf = bytearray(shdr_offset + ctypes.sizeof(shdrs))
  put(elf, 0, bytes(ehdr))
  put(elf, ehdr_size, bytes(phdrs))
  put(elf, note_offset, note)
  put(elf, dynsym_offset, dynsym)
  put(elf, dynstr_offset, dynstr)
  put(elf, hash_offset, hash_data)
  put(elf, dynamic_offset, dynamic)
  put(elf, rodata_offset, rodata)
  put(elf, text_offset, text)
  put(elf, symtab_offset, symtab)
  put(elf, strtab_offset, strtab)
  put(elf, shstrtab_offset, shstrtab)
  put(elf, shdr_offset, bytes(shdrs))
  return bytes(elf)
