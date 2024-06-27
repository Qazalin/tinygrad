import ctypes, pickle
from typing import Set
from tinygrad.codegen.uops import UOp
from tinygrad.engine.graph import print_tree

lib = ctypes.CDLL("/Users/qazal/code/dev/target/release/libdev.dylib")
lib.rewrite_uops.argtypes = [ctypes.POINTER(ctypes.c_ubyte), ctypes.c_int]
def egg_graph_rewrite(sink:UOp):
  print_tree(sink)
  print("----------")
  s = pickle.dumps(_fixup_uop(sink, set()))
  byte_array = (ctypes.c_ubyte * len(s)).from_buffer_copy(s)
  lib.rewrite_uops(byte_array, len(s))

def _fixup_uop(uop, seen:Set[UOp]):
  if uop in seen: return uop
  seen.add(uop)
  uop.op = uop.op.name
  uop.arg, uop.dtype = str(uop.arg) if uop.arg else None, str(uop.dtype) if uop.dtype else None
  for x in uop.src: _fixup_uop(x, seen)
  return uop
