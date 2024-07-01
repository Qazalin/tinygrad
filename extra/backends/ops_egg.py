from dataclasses import replace
import ctypes, pickle
from typing import Dict, Tuple
from tinygrad.codegen.uops import UOp, UOps
from tinygrad.dtype import DTYPES_DICT

class ByteArray(ctypes.Structure): _fields_ = [("ptr", ctypes.POINTER(ctypes.c_char)), ("len", ctypes.c_size_t)]
lib = ctypes.CDLL("/Users/qazal/code/egg/target/release/libdev.dylib")
lib.rewrite_uops.argtypes = [ctypes.POINTER(ctypes.c_ubyte), ctypes.c_int]
lib.rewrite_uops.restype = ByteArray

def egg_graph_rewrite(sink:UOp) -> UOp:
  s = pickle.dumps(_serialize(sink))
  byte_array = (ctypes.c_ubyte * len(s)).from_buffer_copy(s)
  ret: ByteArray = lib.rewrite_uops(byte_array, len(s))
  data = ctypes.string_at(ret.ptr, ret.len)
  uops = pickle.loads(data)
  new_sink = _deserialize(uops[-1], {}, {})
  return new_sink

def _serialize(uop) -> UOp:
  uop = replace(uop, op=uop.op.name, arg=_as_str(uop.arg), dtype=_as_str(uop.dtype), src=tuple(_serialize(x) for x in uop.src))
  return uop

def _deserialize(uop_dict, replace_nodes:Dict[UOp, UOp], nodes:Dict[Tuple, UOp]):
  dt = DTYPES_DICT[uop_dict["dtype"].replace("dtypes.", "")]
  op = UOps[uop_dict["op"]]
  n = UOp(op, dt, tuple(_deserialize(x, replace_nodes, nodes) for x in uop_dict["src"]), uop_dict["arg"])
  key = (n.op, n.dtype, tuple(replace_nodes.get(x, x) for x in n.src), n.arg)
  if found:=nodes.get(key): ret = replace_nodes[n] = found
  else: ret = replace_nodes[n] = nodes[key] = UOp(*key)
  return ret

def _as_str(x): return str(x) if x is not None else None
