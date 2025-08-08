import ctypes, enum, contextlib, io, threading, queue, json
from typing import Generator
from tinygrad.helpers import init_c_struct_t, fetch, unwrap
from tinygrad.runtime.ops_amd import ProfileSQTTEvent
from tinygrad.device import ProfileProgramEvent, ProfileEvent, Device

# ** base structs

TraceData = init_c_struct_t((
  # raw sqtt input bufs
  ("buf_ptr", ctypes.POINTER(ctypes.c_uint8)), ("sz", ctypes.c_uint64),
  # internal PC address table
  ("programs", ctypes.py_object), ("instructions", ctypes.py_object),
  # output queue
  ("sink", ctypes.py_object), ("stop", ctypes.py_object),
))

class RecordType(enum.IntEnum): GFXIP = 0; OCCUPANCY = 1; WAVE = 3; INFO = 4
PC = init_c_struct_t((("addr", ctypes.c_size_t), ("marker_id", ctypes.c_size_t)))
Inst = init_c_struct_t((("category", ctypes.c_uint32, 8), ("stall", ctypes.c_uint32, 24), ("duration", ctypes.c_int32), ("time", ctypes.c_int64),
                        ("pc", PC)))
Wave = init_c_struct_t((
  ("cu", ctypes.c_uint8), ("simd", ctypes.c_uint8), ("wave_id", ctypes.c_uint8), ("contexts", ctypes.c_uint8),
  ("_rsvd1", ctypes.c_uint32), ("_rsvd2", ctypes.c_uint32), ("_rsvd3", ctypes.c_uint32),
  ("begin_time", ctypes.c_int64), ("end_time", ctypes.c_int64),
  ("timeline_size", ctypes.c_size_t), ("instructions_size", ctypes.c_size_t),
  ("timeline_array", ctypes.c_void_p), ("instructions_array", ctypes.POINTER(Inst))
))

TRACE_DECODER_STATUS_SUCCESS = 0
TRACE_DECODER_STATUS_ERROR_OUT_OF_RESOURCES = 2

SENTINEL = {"type":"__end__"}

# ** disassembly helper, this should probably use LLVM

def is_word(s:str) -> bool:
  try: return int(s, 16) <= 0xFFFFFFFF
  except ValueError: return False

def disasm_prg(p:ProfileProgramEvent):
  with contextlib.redirect_stdout(buf:=io.StringIO()): Device[p.device].compiler.disassemble(unwrap(p.lib))
  for line in buf.getvalue().splitlines()[6:]:
    if not (line:=line.strip()): continue
    code, rest = line.split("//"); pc, opcode = rest.split(":", 1)
    words = [w for w in opcode.strip().split(" ") if is_word(w)]
    pc_offset = int(pc.strip(), 16)
    yield unwrap(p.base)+pc_offset, code.strip(), 4*len(words)

# ** decoder callbacks

@ctypes.CFUNCTYPE(ctypes.c_uint64, ctypes.POINTER(ctypes.POINTER(ctypes.c_uint8)), ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(TraceData))
def copy_cb(buf, buf_size, data_ptr):
  data = data_ptr.contents
  buf[0] = data.buf_ptr
  buf_size[0] = copied_sz = data.sz
  data.data = ctypes.cast(ctypes.addressof(data.buf_ptr.contents), ctypes.POINTER(ctypes.c_uint8))
  data.sz = 0
  return copied_sz

@ctypes.CFUNCTYPE(ctypes.c_int, ctypes.POINTER(ctypes.c_char), ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(ctypes.c_uint64), PC, ctypes.POINTER(TraceData))
def isa_cb(instr_ptr, mem_size_ptr, size_ptr, pc, data_ptr):
  instructions = data_ptr.contents.instructions
  code, size = instructions[pc.addr]
  # HACKS: delay instructions don't have any clks?
  cc = code.split(" ")[0] if "delay" in code else code
  if "s_endpgm" in code: size = 0
  code_bytes = cc.encode("utf-8")
  if len(code_bytes)+1 > size_ptr[0]: return TRACE_DECODER_STATUS_ERROR_OUT_OF_RESOURCES
  ctypes.memmove(instr_ptr, code_bytes, len(code_bytes))
  instr_ptr[len(code_bytes)] = 0
  size_ptr[0] = len(code_bytes)+1
  mem_size_ptr[0] = size
  return TRACE_DECODER_STATUS_SUCCESS

def push(rec:dict, sink) -> None:
  try: sink.put(rec, timeout=0.5)
  except queue.Full: pass

@ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_int, ctypes.c_void_p, ctypes.c_uint64, ctypes.POINTER(TraceData))
def trace_cb(record_type, events_ptr, n, data_ptr):
  data = data_ptr.contents
  if record_type != RecordType.WAVE: return TRACE_DECODER_STATUS_SUCCESS
  for i in range(n):
    if data.stop.is_set(): break
    wave = ctypes.cast(events_ptr, ctypes.POINTER(Wave))[i]
    push({"type":"wave_begin","cu":wave.cu,"simd":wave.simd,"wave_id":wave.wave_id,"begin_time":wave.begin_time,"end_time":wave.end_time}, data.sink)
    for j in range(wave.instructions_size):
      if data.stop.is_set(): break
      instr = wave.instructions_array[j]
      code, _ = data.instructions.get(instr.pc.addr, ("<unknown>", 0))
      if (p:=data.programs.get(instr.pc.addr)) is not None: push({"type":"prg", "prg":p}, data.sink)
      push({"type":"inst","idx":j,"pc":f"0x{instr.pc.addr:012x}","code":code,"duration":instr.duration,"stall":instr.stall, "time":instr.time,
            "cu":wave.cu, "simd":wave.simd, "wave_id":wave.wave_id}, data.sink)
    push({"type":"wave_end","wave_id":wave.wave_id}, data.sink)
  return TRACE_DECODER_STATUS_SUCCESS

# ** main decoder loop

def _worker(profile:list[ProfileEvent], q:queue.Queue, stop:threading.Event):
  # gather events from the profile trace
  sqtt_events:list[ProfileSQTTEvent] = []
  prgs:dict[int, ProfileProgramEvent] = {}
  inst:dict[int, tuple[str, int]] = {}
  for e in profile:
    if isinstance(e, ProfileSQTTEvent): sqtt_events.append(e)
    if isinstance(e, ProfileProgramEvent) and e.device.startswith("AMD"):
      asm:list[str] = []
      for pc,code,sz in disasm_prg(e):
        inst[pc] = (code, sz)
        asm.append(code)
      prgs[unwrap(e.base)] = {"name":e.name, "asm":asm}
  # pass to decoder, this doesn't ship with any of the AMD stuff. It is a standalone blob, no rocm install required.
  sqtt_buf = ctypes.create_string_buffer(b"".join([s.blob for s in sqtt_events]))
  td = TraceData(ctypes.cast(sqtt_buf, ctypes.POINTER(ctypes.c_uint8)), len(sqtt_buf), prgs, inst, q, stop)
  decoder = ctypes.CDLL(str(fetch("https://github.com/ROCm/rocprof-trace-decoder/raw/5420409ad0963b2d76450add067b9058493ccbd0/releases/linux_glibc_2_28_x86_64/librocprof-trace-decoder.so")))
  try:
    decoder.rocprof_trace_decoder_parse_data(copy_cb, trace_cb, isa_cb, ctypes.pointer(td))
  finally:
    try: q.put(SENTINEL, timeout=0.1)
    except Exception: pass

def decode_sqtt_packets(profile:list[ProfileEvent]) -> Generator[dict, None, None]:
  # put it in a daemon thread to propagate ctrl+c from Python to C
  q = queue.Queue(maxsize=1024)
  stop = threading.Event()
  t = threading.Thread(target=_worker, args=(profile, q, stop), daemon=True)
  t.start()
  try:
    while True:
      item = q.get()
      if item == SENTINEL: break
      yield item
  except GeneratorExit: stop.set()
  finally:
    stop.set()
    t.join(timeout=1)
