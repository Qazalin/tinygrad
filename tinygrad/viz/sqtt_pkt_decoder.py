import ctypes, enum, contextlib, io, multiprocessing
from typing import Generator
from tinygrad.helpers import init_c_struct_t, fetch, unwrap
from tinygrad.runtime.ops_amd import ProfileSQTTEvent
from tinygrad.device import ProfileProgramEvent, ProfileEvent, Device

TraceData = init_c_struct_t((("data", ctypes.POINTER(ctypes.c_uint8)), ("size", ctypes.c_uint64), ("programs", ctypes.py_object),
                             ("instructions", ctypes.py_object)))

@ctypes.CFUNCTYPE(ctypes.c_uint64, ctypes.POINTER(ctypes.POINTER(ctypes.c_uint8)), ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(TraceData))
def copy_cb(buf, buf_size, data_ptr):
  data = data_ptr.contents
  chunk = data.size #min(data.size, CHUNK_SIZE)
  buf[0] = data.data
  buf_size[0] = ret = data.size
  data.data = ctypes.cast(ctypes.addressof(data.data.contents)+chunk, ctypes.POINTER(ctypes.c_uint8))
  data.size -= chunk
  return ret

class RecordType(enum.IntEnum): GFXIP = 0; OCCUPANCY = 1; WAVE = 3; INFO = 4 # noqa: E702

PC = init_c_struct_t((("addr", ctypes.c_size_t), ("marker_id", ctypes.c_size_t)))

Inst = init_c_struct_t((("category", ctypes.c_uint32, 8), ("stall", ctypes.c_uint32, 24), ("duration", ctypes.c_int32), ("time", ctypes.c_int64),
                        ("pc", PC)))

Wave = init_c_struct_t((("cu", ctypes.c_uint8), ("simd", ctypes.c_uint8), ("wave_id", ctypes.c_uint8), ("contexts", ctypes.c_uint8),
                        ("_rsvd1", ctypes.c_uint32), ("_rsvd2", ctypes.c_uint32), ("_rsvd3", ctypes.c_uint32), ("begin_time", ctypes.c_int64),
                        ("end_time", ctypes.c_int64), ("timeline_size", ctypes.c_size_t), ("instructions_size", ctypes.c_size_t),
                        ("timeline_array", ctypes.c_void_p), ("instructions_array", ctypes.POINTER(Inst))))

TRACE_DECODER_STATUS_SUCCESS = 0
TRACE_DECODER_STATUS_ERROR_OUT_OF_RESOURCES = 2
TRACE_DECODER_STATUS_ERROR_INVALID_ARGUMENT = 3

@ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_int, ctypes.c_void_p, ctypes.c_uint64, ctypes.POINTER(TraceData))
def trace_cb(record_type, events_ptr, n, data_ptr):
  global ii
  data = data_ptr.contents
  if record_type == RecordType.WAVE:
    for i in range(n):
      wave = ctypes.cast(events_ptr, ctypes.POINTER(Wave))[i]
      for j in range(wave.instructions_size):
        instr = wave.instructions_array[j]
        code, _ = data.instructions[instr.pc.addr]
        if (p:=data.programs.get(instr.pc.addr)) is not None: print(p.name)
        print(f"{j:{len(str(wave.instructions_size))}d} PC=0x{instr.pc.addr:012x} {code:<50} duration={instr.duration}, stall={instr.stall}")
  return TRACE_DECODER_STATUS_SUCCESS

# TODO: use llvm for ISA parsing....

@ctypes.CFUNCTYPE(ctypes.c_int, ctypes.POINTER(ctypes.c_char), ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(ctypes.c_uint64), PC,
                  ctypes.POINTER(TraceData))
def isa_cb(instr_ptr, mem_size_ptr, size_ptr, pc, data_ptr):
  instructions = data_ptr.contents.instructions
  code, size = instructions[pc.addr]
  # what's this?
  cc = code
  if "delay" in code: cc = code.split(" ")[0]
  if "s_endpgm" in code: size = 0
  code_bytes = cc.encode("utf-8")
  if len(code_bytes)+1>size_ptr[0]:
    return TRACE_DECODER_STATUS_ERROR_OUT_OF_RESOURCES
  ctypes.memmove(instr_ptr, code_bytes, len(code_bytes))
  instr_ptr[len(code_bytes)] = 0
  size_ptr[0] = len(code_bytes)+1
  mem_size_ptr[0] = size
  return TRACE_DECODER_STATUS_SUCCESS

def is_word(s:str) -> bool:
  try: return int(s, 16) <= 0xFFFFFFFF
  except ValueError: return False

def disasm_prg(p:ProfileProgramEvent) -> Generator[tuple[int, str, int], None, None]:
  with contextlib.redirect_stdout(buf:=io.StringIO()): Device[p.device].compiler.disassemble(unwrap(p.lib))
  i = 0
  for line in buf.getvalue().splitlines()[6:]:
    if not (line:=line.strip()): continue
    i += 1
    code, rest = line.split("//")
    pc, opcode = rest.split(":", 1)
    words = [w for w in opcode.strip().split(" ") if is_word(w)]
    offset = int(pc.strip(), 16)
    #print(f"{i:2d} {p.base+offset:012X}", code)
    yield unwrap(p.base)+offset, code.strip(), 4*len(words)

def worker(profile:list[ProfileEvent]):
  sqtt_events:list[ProfileSQTTEvent] = []
  prgs:dict[int, ProfileProgramEvent] = {}
  inst:dict[int, tuple[str, int]] = {}
  for e in profile:
    if isinstance(e, ProfileSQTTEvent): sqtt_events.append(e)
    if isinstance(e, ProfileProgramEvent) and e.device.startswith("AMD"):
      prgs[unwrap(e.base)] = e
      for pc,code,sz in disasm_prg(e): inst[pc] = (code, sz)

  sqtt_blobs = b"".join([s.blob for s in sqtt_events])
  trace_data = TraceData(ctypes.cast(ctypes.create_string_buffer(sqtt_blobs), ctypes.POINTER(ctypes.c_uint8)), len(sqtt_blobs), prgs, inst)

  # this seems to be a standalone blob, doesn't ship with any of the AMD software
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
