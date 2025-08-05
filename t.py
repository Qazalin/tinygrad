import pickle, subprocess, sys, os, ctypes
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

raw_data = se_blobs[1]
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
isa_callback_t     = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_char_p, ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(ctypes.c_uint64), ctypes.c_void_p, ctypes.c_void_p)

# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/decode.cpp#L162C64-L162C72
def copy_trace_data(buffer:ctypes.POINTER(ctypes.POINTER(ctypes.c_uint8)), buffer_size:ctypes.POINTER(ctypes.c_uint64), userdata:ctypes.c_void_p) -> int:
  data:TraceData = ctypes.cast(userdata, ctypes.POINTER(TraceData)).contents
  buffer_size[0] = ret = data.size
  buffer[0] = data.data
  data.size = 0
  return ret

# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/decode.cpp#L209
def trace_callback(record_type_id, trace_events, trace_size, userdata):
  data:TraceData = ctypes.cast(userdata, ctypes.POINTER(TraceData)).contents
  print(record_type_id, data)
  return 0

# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/decode.cpp#L172
def isa_callback(instr, mem_size_ptr, size_ptr, pc, user):
  print("[isa_cb] Called", instr, mem_size_ptr, size_ptr, pc, user)
  return 0

status = att_parse_data_fn(se_data_callback_t(copy_trace_data), trace_callback_t(trace_callback), isa_callback_t(isa_callback), ctypes.cast(userdata_ptr, ctypes.c_void_p))
print("[*] Returned status:", status)
