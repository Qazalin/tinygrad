import pickle, subprocess, sys, os, ctypes, enum
from tinygrad.runtime.ops_amd import ProfileSQTTEvent
from tinygrad.device import ProfileProgramEvent
from tinygrad.helpers import getenv, temp

# run something with SQTT=1 PROFILE=1 to get raw shader engine SQTT buffers
with open(temp("profile.pkl", append_user=True), "rb") as f: profile = pickle.load(f)
se_blobs = [e.blob for e in profile if isinstance(e, ProfileSQTTEvent)]

lib = ctypes.CDLL("/opt/rocm/lib/librocprof-trace-decoder.so")

# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/dl.cpp#L43
att_parse_data_fn = lib.rocprof_trace_decoder_parse_data
att_info_fn = lib.rocprof_trace_decoder_get_info_string
att_status_fn = lib.rocprof_trace_decoder_get_status_string

raw_data = se_blobs[0]+se_blobs[1]
# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/decode.cpp#L151
class TraceData(ctypes.Structure):
  _fields_ = [("data", ctypes.POINTER(ctypes.c_uint8)), ("size", ctypes.c_uint64),]
data_buf = ctypes.create_string_buffer(raw_data)
userdata = TraceData(ctypes.cast(data_buf, ctypes.POINTER(ctypes.c_uint8)), len(raw_data))
userdata_ptr = ctypes.pointer(userdata)

# mostly from https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/trace_decoder_api.h
se_data_callback_t = ctypes.CFUNCTYPE(ctypes.c_uint64, ctypes.POINTER(ctypes.POINTER(ctypes.c_uint8)), ctypes.POINTER(ctypes.c_uint64), ctypes.c_void_p)
trace_callback_t   = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_int, ctypes.c_void_p, ctypes.c_uint64, ctypes.c_void_p)
# isa cb inferred from https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/decode.cpp#L172
isa_callback_t     = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.POINTER(ctypes.c_char), ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(ctypes.c_uint64), ctypes.c_void_p, ctypes.c_void_p)

# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/decode.cpp#L162C64-L162C72
def copy_trace_data(buffer:ctypes.POINTER(ctypes.POINTER(ctypes.c_uint8)), buffer_size:ctypes.POINTER(ctypes.c_uint64), userdata:ctypes.c_void_p) -> int:
  data:TraceData = ctypes.cast(userdata, ctypes.POINTER(TraceData)).contents
  buffer_size[0] = ret = data.size
  buffer[0] = data.data
  data.size = 0
  return ret

# ** SQTT parser

# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/samples/thread_trace/agent.cpp#L204
# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/include/rocprofiler-sdk/experimental/thread-trace/trace_decoder_types.h#L174
# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/samples/thread_trace/README.md?plain=1#L18

class RecordType(enum.IntEnum):
  GFXIP = 0
  OCCUPANCY = 1
  PERFEVENT = 2
  WAVE = 3
  INFO = 4
  DEBUG = 5
  LAST = 6

class InfoEvent(enum.IntEnum):
  NONE = 0
  DATA_LOST = 1
  STITCH_INCOMPLETE = 2
  LAST = 3

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

class PC(ctypes.Structure):
  _fields_ = [("addr", ctypes.c_size_t), ("marker_id", ctypes.c_size_t)]

class Occupancy(ctypes.Structure):
  _fields_ = [
    ("pc", PC),
    ("time", ctypes.c_uint64),
    ("reserved", ctypes.c_uint8),
    ("cu", ctypes.c_uint8),
    ("simd", ctypes.c_uint8),
    ("slot", ctypes.c_uint8),
    ("start", ctypes.c_uint32, 1),
    ("_rsvd", ctypes.c_uint32, 31)
  ]

class PerfEvent(ctypes.Structure):
  _fields_ = [
    ("time", ctypes.c_int64),
    ("events0", ctypes.c_uint16),
    ("events1", ctypes.c_uint16),
    ("events2", ctypes.c_uint16),
    ("events3", ctypes.c_uint16),
    ("CU", ctypes.c_uint8),
    ("bank", ctypes.c_uint8)
  ]

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

# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/decode.cpp#L209

def trace_callback(record_type_int, events_ptr, size, user):
  record_type = RecordType(record_type_int)
  print(f"\n[trace_cb] record_type={record_type.name} ({record_type.value}), size={size}")

  if size == 0 or not events_ptr:
    print("  No events")
    return 0

  if record_type == RecordType.OCCUPANCY:
    for i in range(size):
      occ = ctypes.cast(events_ptr, ctypes.POINTER(Occupancy))[i]
      print(f"  OCC [{i}]: PC=0x{occ.pc.addr:x}, CU={occ.cu}, SIMD={occ.simd}, slot={occ.slot}, time={occ.time}, start={bool(occ.start)}")

  elif record_type == RecordType.PERFEVENT:
    for i in range(size):
      ev = ctypes.cast(events_ptr, ctypes.POINTER(PerfEvent))[i]
      print(f"  PERF [{i}]: time={ev.time}, CU={ev.CU}, bank={ev.bank}, e0={ev.events0} e1={ev.events1} e2={ev.events2} e3={ev.events3}")

  elif record_type == RecordType.WAVE:
    for i in range(size):
      wave = ctypes.cast(events_ptr, ctypes.POINTER(Wave))[i]
      print(f"  WAVE [{i}]: CU={wave.cu}, SIMD={wave.simd}, insts={wave.instructions_size}")
      for j in range(wave.instructions_size):
        inst = wave.instructions_array[j]
        cat = InstCategory(inst.category).name if inst.category in InstCategory._value2member_map_ else f"UNKNOWN({inst.category})"
        print(f"    INST [{j}]: PC=0x{inst.pc.addr:x}, time={inst.time}, duration={inst.duration}, stall={inst.stall}, category={cat}")

  elif record_type == RecordType.INFO:
    info = ctypes.cast(events_ptr, ctypes.POINTER(ctypes.c_int))[0]
    print(f"  INFO: {InfoEvent(info).name if info in InfoEvent._value2member_map_ else f'UNKNOWN({info})'}")

  elif record_type == RecordType.GFXIP:
    gfxip = ctypes.cast(events_ptr, ctypes.POINTER(ctypes.c_size_t))[0]
    print(f"  GFXIP: major version {gfxip}")

  elif record_type == RecordType.DEBUG:
    print("  DEBUG event (no struct defined)")

  else:
    print("  Unknown record type")

  return 0

# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/decode.cpp#L172
ROCPROFILER_THREAD_TRACE_DECODER_STATUS_SUCCESS = 0
ROCPROFILER_THREAD_TRACE_DECODER_STATUS_ERROR_OUT_OF_RESOURCES = 4

def isa_callback(instr_ptr, mem_size_ptr, size_ptr, pc, user):
  max_len = size_ptr[0]  # size_ptr is IN/OUT
  fake_isa = b"v_add_f32 v0, v1, v2"  # pretend this is disassembled from PC

  # If not enough space, return size required
  if len(fake_isa) + 1 > max_len:
    size_ptr[0] = len(fake_isa) + 1
    return ROCPROFILER_THREAD_TRACE_DECODER_STATUS_ERROR_OUT_OF_RESOURCES

  # Write fake_isa to instr_ptr (as a c_char array)
  ctypes.memmove(instr_ptr, fake_isa, len(fake_isa))
  instr_ptr[len(fake_isa)] = 0  # null-terminate if needed

  size_ptr[0] = len(fake_isa)
  mem_size_ptr[0] = 4  # pretend 4-byte instruction

  return ROCPROFILER_THREAD_TRACE_DECODER_STATUS_SUCCESS

status = att_parse_data_fn(se_data_callback_t(copy_trace_data), trace_callback_t(trace_callback), isa_callback_t(isa_callback), ctypes.cast(userdata_ptr, ctypes.c_void_p))
print("[*] Returned status:", status)
