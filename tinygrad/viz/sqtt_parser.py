# references:
# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/include/rocprofiler-sdk/experimental/thread-trace/trace_decoder_types.h
# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/trace_decoder_api.h
import ctypes, enum

lib = ctypes.CDLL("/opt/rocm/lib/librocprof-trace-decoder.so")
att_parse_data_fn = lib.rocprof_trace_decoder_parse_data
se_data_callback_t = ctypes.CFUNCTYPE(ctypes.c_uint64, ctypes.POINTER(ctypes.POINTER(ctypes.c_uint8)), ctypes.POINTER(ctypes.c_uint64), ctypes.c_void_p)
trace_callback_t = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_int, ctypes.c_void_p, ctypes.c_uint64, ctypes.c_void_p)

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

class RecordType(enum.IntEnum): WAVE = 3

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

isa_callback_t = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.POINTER(ctypes.c_char), ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(ctypes.c_uint64), PC, ctypes.c_void_p)

TRACE_DECODER_STATUS_SUCCESS = 0
TRACE_DECODER_STATUS_ERROR_OUT_OF_RESOURCES = 4
