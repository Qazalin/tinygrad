import ctypes, pickle, contextlib, io, enum
from tinygrad.helpers import temp
from tinygrad.runtime.ops_amd import ProfileSQTTEvent
from tinygrad.device import Device, ProfileProgramEvent

# types taken from https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/include/rocprofiler-sdk/experimental/thread-trace/trace_decoder_types.h#L49

class RecordType(enum.IntEnum): WAVE = 3

class PC(ctypes.Structure):
  _fields_ = [("addr", ctypes.c_size_t), ("marker_id", ctypes.c_size_t)]

class Inst(ctypes.Structure):
  _fields_ = [
    ("category", ctypes.c_uint32, 8),
    ("stall", ctypes.c_uint32, 24),
    ("duration", ctypes.c_int32),
    ("time", ctypes.c_int64),
    ("pc", PC)
  ]

class Wave(ctypes.Structure):
  _fields_ = [
    ("cu", ctypes.c_uint8),
    ("simd", ctypes.c_uint8),
    ("wave_id", ctypes.c_uint8),
    ("contexts", ctypes.c_uint8),
    ("_rsvd1", ctypes.c_uint32),
    ("_rsvd2", ctypes.c_uint32),
    ("_rsvd3", ctypes.c_uint32),
    ("begin_time", ctypes.c_int64),
    ("end_time", ctypes.c_int64),
    ("timeline_size", ctypes.c_size_t),
    ("instructions_size", ctypes.c_size_t),
    ("timeline_array", ctypes.c_void_p),
    ("instructions_array", ctypes.POINTER(Inst))
  ]

class InstCategory(enum.IntEnum):
  NONE = 0
  SMEM = 1
  SALU = 2
  VMEM = 3
  FLAT = 4
  LDS = 5
  VALU = 6
  JUMP = 7
  NEXT = 8
  IMMED = 9
  CONTEXT = 10
  MESSAGE = 11
  BVH = 12
  LAST = 13

class TraceData(ctypes.Structure):
  _fields_ = [("data", ctypes.POINTER(ctypes.c_uint8)), ("size", ctypes.c_uint64),]

def trace_callback(record_type, events_ptr, size, _) -> int:
  if size == 0 or not events_ptr: return 0
  if record_type == RecordType.WAVE:
    for i in range(size):
      wave = ctypes.cast(events_ptr, ctypes.POINTER(Wave))[i]
      for j in range(wave.instructions_size):
        inst = wave.instructions_array[j]
        cat = InstCategory(inst.category).name if inst.category in InstCategory._value2member_map_ else f"UNKNOWN({inst.category})"
        isa = isa_map[inst.pc.addr]
        print(f"PC=0x{inst.pc.addr:012x} {isa:<50} time={inst.time}, duration={inst.duration}, stall={inst.stall}, category={cat:<8}")
  return 0

lib = ctypes.CDLL("/opt/rocm/lib/librocprof-trace-decoder.so")

# from https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/trace_decoder_api.h
att_parse_data_fn = lib.rocprof_trace_decoder_parse_data
se_data_callback_t = ctypes.CFUNCTYPE(ctypes.c_uint64, ctypes.POINTER(ctypes.POINTER(ctypes.c_uint8)), ctypes.POINTER(ctypes.c_uint64), ctypes.c_void_p)
trace_callback_t   = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_int, ctypes.c_void_p, ctypes.c_uint64, ctypes.c_void_p)
isa_callback_t     = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.POINTER(ctypes.c_char), ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(ctypes.c_uint64), PC, ctypes.c_void_p)

# one shot copy, similar to https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/decode.cpp#L162C64-L162C72
# TODO: chunk copy
def copy_trace_data(buffer:ctypes.POINTER(ctypes.POINTER(ctypes.c_uint8)), buffer_size:ctypes.POINTER(ctypes.c_uint64), userdata:ctypes.c_void_p) -> int:
  data:TraceData = ctypes.cast(userdata, ctypes.POINTER(TraceData)).contents
  buffer_size[0] = ret = data.size
  buffer[0] = data.data
  data.size = 0
  return ret

# mostly from https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/decode.cpp#L172
ROCPROFILER_THREAD_TRACE_DECODER_STATUS_SUCCESS = 0
ROCPROFILER_THREAD_TRACE_DECODER_STATUS_ERROR_OUT_OF_RESOURCES = 4
ROCPROFILER_THREAD_TRACE_DECODER_STATUS_ERROR_INVALID_ARGUMENT = 3
def isa_callback(instr_ptr, mem_size_ptr, size_ptr, pc:PC, _) -> int:
  isa = isa_map.get(pc.addr, "<missing>") # this solves itself when size is real
  isa_bytes = isa.encode("utf-8")
  max_len = size_ptr[0]
  if len(isa_bytes) + 1 > max_len:
    size_ptr[0] = len(isa_bytes) + 1  # include null terminator
    return ROCPROFILER_THREAD_TRACE_DECODER_STATUS_ERROR_OUT_OF_RESOURCES
  ctypes.memmove(instr_ptr, isa_bytes, len(isa_bytes))
  instr_ptr[len(isa_bytes)] = 0  # null-terminate
  size_ptr[0] = len(isa_bytes) + 1
  mem_size_ptr[0] = 4 # TODO: real size
  return ROCPROFILER_THREAD_TRACE_DECODER_STATUS_SUCCESS

if __name__ == "__main__":
  with open(temp("profile.pkl", append_user=True), "rb") as f: profile = pickle.load(f)
  se_blobs = [e.blob for e in profile if isinstance(e, ProfileSQTTEvent)]
  programs = [e for e in profile if isinstance(e, ProfileProgramEvent) and e.device.startswith("AMD")]

  # map program counter to instructions
  isa_map: dict[int, str] = {}
  for e in programs:
    with contextlib.redirect_stdout(buf:=io.StringIO()): Device[e.device].compiler.disassemble(e.lib)
    disasm_str = buf.getvalue()
    for line in disasm_str.splitlines()[6:]:
      if not (line:=line.strip()): continue
      instr, rest = line.split("//")
      relative_pc = int(rest.split(":")[0], 16)
      isa_map[e.base+relative_pc] = instr.strip()

  # decode traces
  raw_data = b"".join(se_blobs)
  data_buf = ctypes.create_string_buffer(raw_data)
  userdata = TraceData(ctypes.cast(data_buf, ctypes.POINTER(ctypes.c_uint8)), len(raw_data))
  att_parse_data_fn(se_data_callback_t(copy_trace_data), trace_callback_t(trace_callback), isa_callback_t(isa_callback), ctypes.pointer(userdata))
