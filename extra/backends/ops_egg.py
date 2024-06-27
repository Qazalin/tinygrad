from dataclasses import replace
import ctypes, pickle
from tinygrad.codegen.uops import UOp, UOps
from tinygrad.dtype import DTYPES_DICT

class ByteArray(ctypes.Structure): _fields_ = [("ptr", ctypes.POINTER(ctypes.c_char)), ("len", ctypes.c_size_t)]
lib = ctypes.CDLL("/Users/qazal/code/dev/target/release/libdev.dylib")
lib.rewrite_uops.argtypes = [ctypes.POINTER(ctypes.c_ubyte), ctypes.c_int]
lib.rewrite_uops.restype = ByteArray

def egg_graph_rewrite(sink:UOp):
  s = pickle.dumps(_serialize(sink))
  byte_array = (ctypes.c_ubyte * len(s)).from_buffer_copy(s)
  ret: ByteArray = lib.rewrite_uops(byte_array, len(s))
  data = ctypes.string_at(ret.ptr, ret.len)
  new_sink = pickle.loads(data)
  _deserialize(new_sink)

def _serialize(uop) -> UOp:
  uop = replace(uop, op=uop.op.name, arg=_as_str(uop.arg), dtype=_as_str(uop.dtype), src=tuple(_serialize(x) for x in uop.src))
  return uop

def _deserialize(uop_dict):
  print(uop_dict)
  dt = DTYPES_DICT[uop_dict["dtype"].replace("dtypes.", "")]
  op = UOps[uop_dict["op"]]
  arg = uop_dict["arg"]
  print(arg, type(arg))

def _as_str(x): return str(x) if x is not None else None
