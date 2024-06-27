from dataclasses import replace
import ctypes, pickle
from tinygrad.codegen.uops import UOp

lib = ctypes.CDLL("/Users/qazal/code/dev/target/release/libdev.dylib")
lib.rewrite_uops.argtypes = [ctypes.POINTER(ctypes.c_ubyte), ctypes.c_int]

def egg_graph_rewrite(sink:UOp):
  s = pickle.dumps(_fixup_uop(sink))
  byte_array = (ctypes.c_ubyte * len(s)).from_buffer_copy(s)
  lib.rewrite_uops(byte_array, len(s))

def _fixup_uop(uop) -> UOp:
  uop = replace(uop, op=uop.op.name, arg=_as_str(uop.arg), dtype=_as_str(uop.dtype), src=tuple(_fixup_uop(x) for x in uop.src))
  return uop

def _as_str(x): return str(x) if x is not None else None
