import math
from typing import Callable, Dict, Final
from tinygrad.helpers import dtypes
from tinygrad.renderer.cstyle import CStyleLanguage
from tinygrad.ops import Op, UnaryOps, BinaryOps, TernaryOps

triton_dtypes = { dtypes.double: "tl.float64", dtypes.float32: "tl.float32", dtypes.float16: "tl.float16", dtypes.bool: "tl.int1", dtypes.int8: "tl.int8", dtypes.uint8: "tl.uint8", dtypes.int32: "tl.int32", dtypes.int64: "tl.int64", dtypes.uint32: "tl.uint32", dtypes.uint64: "tl.uint64", dtypes.int16: "tl.int16", dtypes.uint16: "tl.uint16" }
signature_dtypes = { dtypes.double: "*fp64", dtypes.float32: "*fp32", dtypes.float16: "*fp16", dtypes.bool: "*i8", dtypes.int8: "*i1", dtypes.uint8: "*u8", dtypes._arg_int32: "i32", dtypes.int32: "*i32", dtypes.int64: "*i64", dtypes.uint32: "*u32", dtypes.uint64: "*u64", dtypes.int16: "*i16", dtypes.uint16: "*u16" }

# TODO fit in these two lines
def next_power_of_2(x): return 1 << (x - 1).bit_length()
def define_scalar(local_size, dtype, args, const):
  if len(local_size) > 0: return f"tl.full(({','.join([str(next_power_of_2(x)) for x in local_size])},),{const}, dtype={triton_dtypes[dtype]})"

def render_valid(valid): return '(' * (len(valid) -1) + ') and '.join(valid) if len(valid) else 'True'

class TritonLanguage(CStyleLanguage):
  kernel_prefix = "import triton\nimport triton.language as tl\ntl.core.TRITON_MAX_TENSOR_NUMEL = float('inf')\n@triton.jit\ndef "
  code_for_op: Final[Dict[Op, Callable]] = {
    UnaryOps.EXP2: lambda x,: f"tl.math.exp2({x})",
    UnaryOps.LOG2: lambda x,: f"tl.math.log2({x})",
    UnaryOps.SIN: lambda x,: f"tl.sin({x})",
    UnaryOps.SQRT: lambda x,: f"tl.sqrt({x})",
    UnaryOps.NEG: lambda x,: f"-{x}",
    BinaryOps.ADD: lambda x,y,: f"({x}+{y})", BinaryOps.SUB: lambda x,y,: f"({x}-{y})",
    BinaryOps.MUL: lambda x,y,: f"({x}*{y})", BinaryOps.DIV: lambda x,y,: f"({x}/{y})" if y != '0.0' else f"{x}*tl.where({x}==0.0, float('nan'), float('inf'))",
    BinaryOps.MAX: lambda x,y,: f"tl.maximum({x},{y})",
    BinaryOps.CMPLT: lambda x,y,: f"({x}<{y})",
    BinaryOps.MOD: lambda x,y,: f"tl.abs({x})%tl.abs({y})*tl.where({x}<0,-1,1)",
    TernaryOps.MULACC: lambda x,y,z,: f"(({x}*{y})+{z})",
    TernaryOps.WHERE: lambda x,y,z,: f"tl.where({x},{y},{z})",
  }
  end = None
  def render_for(self, expr, _min, _max): return f"for ({expr}) in range({_min}, {_max}):"
  def render_if(self, cond): return f"if ({cond}):"
  #if child_count[u] <=1 or dtypes.is_int(dtype): r[u] = int_div(*[r[x] for x in vin]) if args == BinaryOps.DIV and dtypes.is_int(dtype) else val
  def TODO_name_this(self, dtype, val, vin, args):
    def int_div(x,y): return f"({x}//{y})" if y != '0' else f"{x}*tl.where({x}==0, float('nan'), float('inf'))"
    return int_div(*vin) if args == BinaryOps.DIV and dtypes.is_int(dtype) else val
  def render_const(self, x, var_dtype): return (('-' if x<0 else '') + 'tl.where(1,float("inf"),0)') if math.isinf(x) else ('tl.where(1,float("nan"),0)' if math.isnan(x) else str(x)) # TODO this is incomplete, see define_scalar above
  # TODO UOps.SPECIAL
  def render_load(self, output_dtype, buf_name, buf_dtype, idx, local=False):
    pass
    #if len(vin) == 2: kk(f"{ssa(u, 'val')} = {render_cast(f'tl.load({r[vin[0]]} + { fill_dims_for_idx(r[vin[1]], dims)}, mask = {render_valid(valid)})', dtype)}")
    #else: kk(f"{ssa(u, 'val')} = {render_cast(f'tl.where({r[vin[2]]}, tl.load({r[vin[0]]}+{fill_dims_for_idx(r[vin[1]],dims)} , mask={render_valid(valid+[r[vin[2]]])}), 0.0)', dtype)}")
  def render_phi(self, x): return f"{x.replace('//', '/')}"
  def render_store(self, buf_name, buf_dtype, var_name, var_dtype, idx, local):
    return f"tl.store({buf_name} + {buf_dtype}, {var_name.replace('//', '/')}, mask = {render_valid([])})" # TODO fit in valid 
  def render_cast(self, x, var_dtype): return f"{x}.to({triton_dtypes[var_dtype]})"
  # TODO in DEFINE_GLOBAL, we need to also do signatures.append(signature_dtypes[args[1]])
