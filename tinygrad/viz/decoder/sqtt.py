import io, contextlib, ctypes, multiprocessing, enum
from tinygrad.helpers import temp, init_c_struct_t, unwrap, fetch, DEBUG
from tinygrad.device import ProfileEvent, ProfileProgramEvent, ProfileSQTTEvent
#from tinygrad.runtime.support.compiler_amd import amdgpu_disassemble

# ** base structs

TraceData = init_c_struct_t((
  # raw sqtt input buffer
  ("buf_ptr", ctypes.POINTER(ctypes.c_uint8)), ("sz", ctypes.c_uint64),
  # internal PC address table
  #("programs", ctypes.py_object), ("instructions", ctypes.py_object),
))

class RecordType(enum.IntEnum): GFXIP = 0; OCCUPANCY = 1; WAVE = 3; INFO = 4 # noqa: E702

PC = init_c_struct_t((("addr", ctypes.c_size_t), ("marker_id", ctypes.c_size_t)))

Inst = init_c_struct_t((("category", ctypes.c_uint32, 8), ("stall", ctypes.c_uint32, 24), ("duration", ctypes.c_int32), ("time", ctypes.c_int64),
                        ("pc", PC)))

Wave = init_c_struct_t((("cu", ctypes.c_uint8), ("simd", ctypes.c_uint8), ("wave_id", ctypes.c_uint8), ("contexts", ctypes.c_uint8),
                        ("_rsvd1", ctypes.c_uint32), ("_rsvd2", ctypes.c_uint32), ("_rsvd3", ctypes.c_uint32), ("begin_time", ctypes.c_int64),
                        ("end_time", ctypes.c_int64), ("timeline_size", ctypes.c_size_t), ("instructions_size", ctypes.c_size_t),
                        ("timeline_array", ctypes.c_void_p), ("instructions_array", ctypes.POINTER(Inst))))

class DecoderStatus(enum.IntEnum): SUCCESS = 0; OUT_OF_RESOURCES = 2; INVALID_ARG = 3 # noqa: E702

# ** callbacks

@ctypes.CFUNCTYPE(ctypes.c_uint64, ctypes.POINTER(ctypes.POINTER(ctypes.c_uint8)), ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(TraceData))
def copy_cb(buf, buf_size, data_ptr):
  if DEBUG >= 2: print("[copy_cb] {buf_size[0]} {data.size}")
  data = data_ptr.contents
  buf[0] = data.buf_ptr
  buf_size[0] = copied_sz = data.sz
  data.data = ctypes.cast(ctypes.addressof(data.buf_ptr.contents), ctypes.POINTER(ctypes.c_uint8))
  data.sz = 0
  return copied_sz

@ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_int, ctypes.c_void_p, ctypes.c_uint64, ctypes.POINTER(TraceData))
def trace_cb(record_type, events_ptr, n, data_ptr):
  if DEBUG >= 2: print(f"[trace_cb] {RecordType(record_type).name} {n}")
  return DecoderStatus.SUCCESS

@ctypes.CFUNCTYPE(ctypes.c_int, ctypes.POINTER(ctypes.c_char), ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(ctypes.c_uint64), PC,
                  ctypes.POINTER(TraceData))
def isa_cb(instr_ptr, mem_size_ptr, size_ptr, pc, data_ptr):
  if DEBUG >= 2: print(f"[isa_cb] {pc.addr} {pc.marker_id}")
  return DecoderStatus.SUCCESS

# ** main loop

def worker(profile:list[ProfileEvent]):
  # get traces
  sqtt_events:list[ProfileSQTTEvent] = []
  prog_events:dict[int, ProfileProgramEvent] = {}
  for e in profile:
    if isinstance(e, ProfileSQTTEvent): sqtt_events.append(e)
    if isinstance(e, ProfileProgramEvent) and e.device.startswith("AMD"): prog_events[unwrap(e.base)] = e

  # pass to the "decoder", this doesn't ship with any of the AMD stuff. It is a standalone blob, no rocm install required.
  sqtt_blobs = b"".join([s.blob for s in sqtt_events])
  trace_data = TraceData(ctypes.cast(ctypes.create_string_buffer(sqtt_blobs), ctypes.POINTER(ctypes.c_uint8)), len(sqtt_blobs))
  decoder_path = fetch("https://github.com/ROCm/rocprof-trace-decoder/raw/5420409ad0963b2d76450add067b9058493ccbd0/releases/linux_glibc_2_28_x86_64/librocprof-trace-decoder.so")
  decoder = ctypes.CDLL(str(decoder_path))
  decoder.rocprof_trace_decoder_parse_data(copy_cb, trace_cb, isa_cb, ctypes.pointer(trace_data))

def decode_sqtt_packets(profile:list[ProfileEvent]):
  p = multiprocessing.Process(target=worker, args=(profile,))
  p.start()
  try:
    p.join()
  except KeyboardInterrupt:
    print("decoder is shutting down...")
    p.terminate()
    p.join()
