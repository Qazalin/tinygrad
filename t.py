import ctypes, pickle, contextlib, io, enum
from typing import Any
from tinygrad.helpers import temp
from tinygrad.runtime.ops_amd import ProfileSQTTEvent
from tinygrad.device import Device, ProfileProgramEvent
from tinygrad.viz.sqtt_parser import Wave, RecordType, PC, TraceData, att_parse_data_fn, se_data_callback_t, trace_callback_t, isa_callback_t
from tinygrad.viz.sqtt_parser import InstCategory, Inst, TRACE_DECODER_STATUS_SUCCESS, TRACE_DECODER_STATUS_ERROR_OUT_OF_RESOURCES

# taken from https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/decode.cpp#L162C64-L162C72
# TODO: chunk copy
def copy_trace_data(buffer:ctypes.POINTER(ctypes.POINTER(ctypes.c_uint8)), buffer_size:ctypes.POINTER(ctypes.c_uint64), userdata:ctypes.c_void_p) -> int:
  data:TraceData = ctypes.cast(userdata, ctypes.POINTER(TraceData)).contents
  buffer_size[0] = ret = data.size
  buffer[0] = data.data
  data.size = 0
  return ret

instruction_timing:dict[int, Inst] = {}
def trace_callback(record_type, events_ptr, size, _) -> int:
  if size == 0 or not events_ptr: return 0
  if record_type == RecordType.WAVE:
    for i in range(size):
      wave = ctypes.cast(events_ptr, ctypes.POINTER(Wave))[i]
      for j in range(wave.instructions_size):
        inst = wave.instructions_array[j]
        instruction_timing[inst.pc.addr] = inst
  return 0

# map PC values to instructions
_isa_map: dict[int, str] = {}
def get_instruction_at(pc:int) -> str|None:
  if not _isa_map:
    programs = [e for e in profile if isinstance(e, ProfileProgramEvent) and e.device.startswith("AMD")]
    # TODO: exctract pc values by calling LLVM/MC directly.
    for e in programs:
      with contextlib.redirect_stdout(buf:=io.StringIO()): Device[e.device].compiler.disassemble(e.lib)
      for line in buf.getvalue().splitlines()[6:]:
        if not (line:=line.strip()): continue
        instr, rest = line.split("//")
        relative_pc = int(rest.split(":")[0], 16)
        _isa_map[e.base+relative_pc] = instr.strip()
  return _isa_map.get(pc)

def isa_callback(instr_ptr, mem_size_ptr, size_ptr, pc:PC, _) -> int:
  isa = get_instruction_at(pc.addr) or "<missing>" # TODO: this solves itself when size is real
  isa_bytes = isa.encode("utf-8")
  max_len = size_ptr[0]
  if len(isa_bytes) + 1 > max_len:
    size_ptr[0] = len(isa_bytes) + 1  # include null terminator
    return TRACE_DECODER_STATUS_ERROR_OUT_OF_RESOURCES
  ctypes.memmove(instr_ptr, isa_bytes, len(isa_bytes))
  instr_ptr[len(isa_bytes)] = 0  # null-terminate
  size_ptr[0] = len(isa_bytes) + 1
  mem_size_ptr[0] = 4 # TODO: real size
  return TRACE_DECODER_STATUS_SUCCESS

def sqtt_parse(profile) -> dict[int, Inst]:
  if not instruction_timing:
    se_blobs = [e.blob for e in profile if isinstance(e, ProfileSQTTEvent)]
    raw_data = b"".join(se_blobs)
    data_buf = ctypes.create_string_buffer(raw_data)
    userdata = TraceData(ctypes.cast(data_buf, ctypes.POINTER(ctypes.c_uint8)), len(raw_data))
    att_parse_data_fn(se_data_callback_t(copy_trace_data), trace_callback_t(trace_callback), isa_callback_t(isa_callback), ctypes.pointer(userdata))
  return instruction_timing

if __name__ == "__main__":
  with open(temp("profile.pkl", append_user=True), "rb") as f: profile = pickle.load(f)
  sqtt_parse(profile)
  for pc,inst in instruction_timing.items():
    isa = get_instruction_at(pc)
    cat = InstCategory(inst.category).name if inst.category in InstCategory._value2member_map_ else f"UNKNOWN({inst.category})"
    print(f"PC=0x{pc:012x} {isa:<50} time={inst.time}, duration={inst.duration}, stall={inst.stall}, category={cat:<8}")
