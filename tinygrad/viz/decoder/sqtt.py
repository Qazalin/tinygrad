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

# Describes an instruction execution event.
# The duration is measured as stall+issue time (gfx9) or stall+execution time (gfx10+).
# Time + duration marks the issue (gfx9) or execution (gfx10+) completion time.
# Time + stall marks the successful issue time.
# Duration - stall is the issue time (gfx9) or execution time (gfx10+).
Inst = init_c_struct_t((("category", ctypes.c_uint32, 8), ("stall", ctypes.c_uint32, 24), ("duration", ctypes.c_int32), ("time", ctypes.c_int64),
                        ("pc", PC)))

# instructions_array contains a time-ordered list of all (traced) instructions by the wave.
Wave = init_c_struct_t((("cu", ctypes.c_uint8), ("simd", ctypes.c_uint8), ("wave_id", ctypes.c_uint8), ("contexts", ctypes.c_uint8),
                        ("_rsvd1", ctypes.c_uint32), ("_rsvd2", ctypes.c_uint32), ("_rsvd3", ctypes.c_uint32), ("begin_time", ctypes.c_int64),
                        ("end_time", ctypes.c_int64), ("timeline_size", ctypes.c_size_t), ("instructions_size", ctypes.c_size_t),
                        ("timeline_array", ctypes.c_void_p), ("instructions_array", ctypes.POINTER(Inst))))

# Describes an occupancy event (wave started or wave ended).
Occupancy = init_c_struct_t((
  ("pc", PC),                    # Wave start address (kernel entry point)
  ("time", ctypes.c_uint64),     # timestamp of the event
  ("reserved", ctypes.c_uint8),
  ("cu", ctypes.c_uint8),        # Compute unit ID (gfx9) or WGP ID (gfx10+)
  ("simd", ctypes.c_uint8),      # SIMD ID [0,3] within compute unit
  ("slot", ctypes.c_uint8),      # Wave slot ID within SIMD
  ("start", ctypes.c_uint32, 1), # 1 if wave_start, 0 if a wave_end
  ("_rsvd", ctypes.c_uint32, 31)
))

class DecoderStatus(enum.IntEnum): SUCCESS = 0; OUT_OF_RESOURCES = 2; INVALID_ARG = 3 # noqa: E702

# ** callbacks

@ctypes.CFUNCTYPE(ctypes.c_uint64, ctypes.POINTER(ctypes.POINTER(ctypes.c_uint8)), ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(TraceData))
def copy_cb(buf, buf_size, data_ptr):
  data = data_ptr.contents
  if DEBUG >= 2: print(f"[copy_cb] size={buf_size[0]} remaining={data.sz}")
  buf[0] = data.buf_ptr
  buf_size[0] = copied_sz = data.sz
  data.data = ctypes.cast(ctypes.addressof(data.buf_ptr.contents), ctypes.POINTER(ctypes.c_uint8))
  data.sz = 0
  return copied_sz

def decode_occupancy(events:ctypes.POINTER(Occupancy), n:int, data:TraceData):
  print(f"Parsing {n//2} wavefronts")
  compute_units = set()
  simds = set()
  slots = set()
  for i in range(n):
    e = events[i]
    compute_units.add(e.cu)
    simds.add(e.simd)
    slots.add((e.simd, e.slot))
  print(compute_units)
  print(simds)
  print(slots)

@ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_int, ctypes.c_void_p, ctypes.c_uint64, ctypes.POINTER(TraceData))
def trace_cb(record_type, events_ptr, n, data_ptr):
  if DEBUG >= 2: print(f"[trace_cb] {RecordType(record_type).name} {n}")
  if record_type == RecordType.GFXIP: print(f"Decoding SQTT trace for gfx{events_ptr}")
  if record_type == RecordType.OCCUPANCY: decode_occupancy(ctypes.cast(events_ptr, ctypes.POINTER(Occupancy)), n, data_ptr.contents)
  return DecoderStatus.SUCCESS

@ctypes.CFUNCTYPE(ctypes.c_int, ctypes.POINTER(ctypes.c_char), ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(ctypes.c_uint64), PC,
                  ctypes.POINTER(TraceData))
def isa_cb(instr_ptr, mem_size_ptr, size_ptr, pc, data_ptr):
  if DEBUG >= 2: print(f"[isa_cb] {pc.addr} {pc.marker_id}")
  raise KeyboardInterrupt
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
