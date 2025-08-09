import pickle, ctypes
import tinygrad.runtime.autogen.comgr as comgr
from tinygrad.runtime.support.compiler_amd import check
from tinygrad.device import ProfileProgramEvent
from tinygrad.helpers import init_c_struct_t

UserData = init_c_struct_t((("data", comgr.amd_comgr_data_t), ("lib_buf", ctypes.POINTER(ctypes.c_char)),
                            ("info", comgr.amd_comgr_disassembly_info_t), ("address_table", ctypes.py_object)))

# instruction callback ret
class InstrRet:
  __slots__ = ("pc","inst")
  def __init__(self): self.pc=0; self.inst=""
instr_ret_ptr = ctypes.cast(ctypes.pointer(ctypes.py_object(instr_ret:=InstrRet())), ctypes.c_void_p)

@comgr.amd_comgr_create_disassembly_info.argtypes[1]
def memory_callback(from_addr, to, size, udata):
  base, buf_len = ctypes.addressof(lib_buf), len(lib_buf)
  start = int(from_addr) - base
  if start < 0 or start >= buf_len: return 0
  n = min(int(size), buf_len - start); ctypes.memmove(to, base + start, n); return n

@comgr.amd_comgr_create_disassembly_info.argtypes[2]
def inst_callback(txt, udata):
  c = ctypes.cast(udata, ctypes.POINTER(ctypes.py_object)).contents.value
  c.inst = ctypes.string_at(txt).decode("utf-8", "replace").strip()
  return 0

@comgr.amd_comgr_create_disassembly_info.argtypes[3]
def addr_callback(*args): return 0

@comgr.amd_comgr_iterate_symbols.argtypes[1]
def sym_callback(sym, user_data_ptr):
  user_data = ctypes.cast(user_data_ptr, ctypes.POINTER(UserData)).contents
  check(comgr.amd_comgr_symbol_get_info(sym, comgr.AMD_COMGR_SYMBOL_INFO_TYPE, ctypes.byref(sym_type:=ctypes.c_int())))
  if sym_type.value != comgr.AMD_COMGR_SYMBOL_TYPE_FUNC: return comgr.AMD_COMGR_STATUS_SUCCESS
  check(comgr.amd_comgr_symbol_get_info(sym, comgr.AMD_COMGR_SYMBOL_INFO_VALUE, ctypes.byref(vaddr:=ctypes.c_uint64())))
  check(comgr.amd_comgr_symbol_get_info(sym, comgr.AMD_COMGR_SYMBOL_INFO_SIZE, ctypes.byref(size:=ctypes.c_uint64())))
  check(comgr.amd_comgr_symbol_get_info(sym, comgr.AMD_COMGR_SYMBOL_INFO_NAME_LENGTH, ctypes.byref(name_len:=ctypes.c_size_t())))
  name_src = (ctypes.c_char*name_len.value)(); check(comgr.amd_comgr_symbol_get_info(sym, comgr.AMD_COMGR_SYMBOL_INFO_NAME, name_src))
  check(comgr.amd_comgr_map_elf_virtual_address_to_code_object_offset(user_data.data, vaddr.value, ctypes.byref(offset:=ctypes.c_uint64()),
                                                                      ctypes.byref(ctypes.c_uint64()), ctypes.byref(nobits:=ctypes.c_bool())))
  name = name_src.value.decode()
  lib_buf, info = user_data.lib_buf, user_data.info
  base = ctypes.addressof(lib_buf); pc = base + offset.value; end = pc + size.value
  tbl = user_data.address_table
  while pc < end:
    size_read = ctypes.c_uint64(0); instr_ret.pc = pc
    st = comgr.amd_comgr_disassemble_instruction(info, ctypes.c_uint64(pc), instr_ret_ptr, ctypes.byref(size_read))
    if st == comgr.AMD_COMGR_STATUS_SUCCESS and size_read.value:
      rel = (pc - base) - offset.value
      tbl[vaddr.value + rel] = (instr_ret.inst, int(size_read.value))
      pc += size_read.value
    else: # don't inf loop
      b = ctypes.c_ubyte.from_buffer(lib_buf, pc - base).value
      tbl[vaddr.value + (pc - base - offset.value)] = (f"DISASSEMBLER ISSUE 0x{b:02x}", 1); pc += 1
  return comgr.AMD_COMGR_STATUS_SUCCESS

def get_pc_address_table(lib:bytes) -> dict:
  # create data
  check(comgr.amd_comgr_create_data(comgr.AMD_COMGR_DATA_KIND_EXECUTABLE, ctypes.byref(data_src:=comgr.amd_comgr_data_t())))
  lib_buf = ctypes.create_string_buffer(lib, len(lib))
  check(comgr.amd_comgr_set_data(data_src, len(lib), lib_buf))

  # get isa
  isa_sz = ctypes.c_size_t(128)
  isa = (ctypes.c_char * isa_sz.value)()
  check(comgr.amd_comgr_get_data_isa_name(data_src, isa_sz, isa))
  info_src = comgr.amd_comgr_disassembly_info_t()
  check(comgr.amd_comgr_create_disassembly_info(ctypes.cast(isa, ctypes.POINTER(ctypes.c_char)), memory_callback, inst_callback, addr_callback, info_src))

  # get address table
  user_data = UserData(data_src, lib_buf, info_src, addr_table:={})
  check(comgr.amd_comgr_iterate_symbols(data_src, sym_callback, ctypes.cast(ctypes.pointer(user_data), ctypes.c_void_p)))
  check(comgr.amd_comgr_release_data(data_src))
  check(comgr.amd_comgr_destroy_disassembly_info(info_src))
  return addr_table

with open("/tmp/profile.pkl.qazal", "rb") as f: raw = pickle.load(f)
prg = next((s for s in raw if isinstance(s, ProfileProgramEvent)))
addr_table = get_pc_address_table(prg.lib)
print(addr_table)
