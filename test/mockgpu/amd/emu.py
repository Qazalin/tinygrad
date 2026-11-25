# RDNA3 emulator v2 - compiles pcode to UOps executed via tinygrad CPU backend
# Each instruction is compiled to a kernel that operates on buffers:
#   arg=0: sgpr - sgpr[0-127], inline constants[128-255], SCC=258
#   arg=1: vgpr - vgpr[reg * 32 + lane]
#   arg=2: vmem - base address 0, INDEX offsets directly to host memory
#   arg=3: lds - local data share
#   arg=4: scratch - per-lane scratch memory
import ctypes, functools, itertools, re, platform, struct, subprocess, tempfile, traceback
from typing import Any, Callable

# Set/restore DAZ+FTZ (denormals-are-zero + flush-to-zero) to match RDNA3 default float mode
# x86: MXCSR bits DAZ(6)+FTZ(15), ARM64: FPCR bit FZ(24)
# Only applied during emulator execution, restored afterward to avoid breaking hypothesis tests
@functools.cache
def _get_ftz_lib():
  machine = platform.machine()
  if machine in ('x86_64', 'AMD64'):
    src = b'''
unsigned int get_fpcr(void){unsigned int m;__asm__ __volatile__("stmxcsr %0":"=m"(m));return m;}
void set_fpcr(unsigned int m){__asm__ __volatile__("ldmxcsr %0"::"m"(m));}
'''
    ftz_bits = 0x8040  # DAZ (bit 6) + FTZ (bit 15)
  elif machine in ('arm64', 'aarch64'):
    src = b'''
unsigned int get_fpcr(void){unsigned long long v;__asm__ __volatile__("mrs %0,fpcr":"=r"(v));return(unsigned int)v;}
void set_fpcr(unsigned int m){unsigned long long v=m;__asm__ __volatile__("msr fpcr,%0"::"r"(v));}
'''
    ftz_bits = 1 << 24  # FZ (bit 24)
  else: return None, 0
  try:
    with tempfile.NamedTemporaryFile(suffix='.so', delete=False) as f:
      subprocess.check_output(['clang', '-shared', '-O2', '-x', 'c', '-', '-o', f.name], input=src)
      lib = ctypes.CDLL(f.name)
      lib.get_fpcr.restype = ctypes.c_uint32
      lib.set_fpcr.argtypes = [ctypes.c_uint32]
      return lib, ftz_bits
  except Exception: return None, 0

class _MXCSRContext:
  """Context manager to set DAZ+FTZ during emulator execution and restore afterward."""
  __slots__ = ('_saved',)
  def __enter__(self):
    lib, ftz_bits = _get_ftz_lib()
    if lib is None: return self
    self._saved = lib.get_fpcr()
    lib.set_fpcr(self._saved | ftz_bits)
    return self
  def __exit__(self, *args):
    lib, _ = _get_ftz_lib()
    if lib is None or not hasattr(self, '_saved'): return
    lib.set_fpcr(self._saved)

from tinygrad.uop.ops import UOp, Ops, KernelInfo, uopfunc, rewrite_group, graph_rewrite, PatternMatcher, UPat
from tinygrad.dtype import dtypes, DType, AddrSpace
from tinygrad.device import Buffer, BufferSpec, Device
from tinygrad.engine.realize import run_linear
from tinygrad.codegen import to_program, to_program_config
from tinygrad.renderer import Renderer
from tinygrad.helpers import Context, DEV, to_mv, ContextVar, VIZ
from tinygrad.runtime.autogen import hsa
from tinygrad.viz.serve import amd_decode, get_cfg, COND_TAKEN, COND_NOT_TAKEN, get_elf_section

from tinygrad.runtime.autogen.amd.rdna3.str_pcode import PCODE as PCODE_RDNA3
from tinygrad.runtime.autogen.amd.rdna4.str_pcode import PCODE as PCODE_RDNA4
from tinygrad.runtime.autogen.amd.cdna.str_pcode import PCODE as PCODE_CDNA
from tinygrad.runtime.autogen.amd.rdna3 import ins as ir3
from tinygrad.runtime.autogen.amd.rdna4 import ins as ir4
from tinygrad.runtime.autogen.amd.cdna import ins as irc
from tinygrad.renderer.amd.dsl import VCC_LO, EXEC_LO, SCC, ttmp, Inst, Reg
from tinygrad.runtime.autogen.amd.common import Fmt, OpType
from test.amd.helpers import decode_dpp16
from test.mockgpu.amd.pcode import parse_pcode, _FUNCS, _set_bits, _to_bool, _to_u32, _val_to_bits, _ftz_f32, _bitreverse, _countbits

def _c(val, dtype=dtypes.uint32): return UOp.const(val, dtype)

def _u64(lo: UOp, hi: UOp) -> UOp:
  """Combine two 32-bit UOps into a 64-bit UOp."""
  return lo.cast(dtypes.uint64) | (hi.cast(dtypes.uint64) << _c(32, dtypes.uint64))

def _split64(val: UOp) -> tuple[UOp, UOp]:
  """Split a 64-bit value into (lo, hi) 32-bit values."""
  v64 = val.bitcast(dtypes.uint64) if val.dtype == dtypes.float64 else val.cast(dtypes.uint64)
  return v64.cast(dtypes.uint32), (v64 >> _c(32, dtypes.uint64)).cast(dtypes.uint32)

_SRC_MOD_TYPES = {16: (dtypes.uint16, dtypes.half, 0x7FFF), 32: (dtypes.uint32, dtypes.float32, 0x7FFFFFFF),
                  64: (dtypes.uint64, dtypes.float64, 0x7FFFFFFFFFFFFFFF)}
def _apply_src_mods(val: UOp, mod_bit: int, abs_bits: int, neg_bits: int, bits: int = 32) -> UOp:
  """Apply abs/neg modifiers to source value based on bit width (16, 32, or 64)."""
  if not (abs_bits & (1 << mod_bit)) and not (neg_bits & (1 << mod_bit)): return val
  ut, ft, mask = _SRC_MOD_TYPES[bits]
  fv = val.cast(ut).bitcast(ft) if bits == 16 else val.bitcast(ft) if val.dtype == ut else val
  if abs_bits & (1 << mod_bit): fv = (fv.bitcast(ut) & _c(mask, ut)).bitcast(ft)
  # neg modifier is a pure sign-bit toggle (preserves NaN payloads), not an arithmetic negate
  if neg_bits & (1 << mod_bit): fv = (fv.bitcast(ut) ^ _c((mask + 1) & (1 << (bits - 1)), ut)).bitcast(ft)
  return fv.bitcast(ut).cast(dtypes.uint32) if bits == 16 else fv.bitcast(ut)

# Map VOPD ops to VOP2/VOP1 ops for pcode lookup (both RDNA3 and RDNA4 share these targets)
_VOPD_TARGETS = {
  'V_DUAL_FMAC_F32': ir3.VOP2Op.V_FMAC_F32_E32, 'V_DUAL_MUL_F32': ir3.VOP2Op.V_MUL_F32_E32,
  'V_DUAL_ADD_F32': ir3.VOP2Op.V_ADD_F32_E32, 'V_DUAL_SUB_F32': ir3.VOP2Op.V_SUB_F32_E32,
  'V_DUAL_SUBREV_F32': ir3.VOP2Op.V_SUBREV_F32_E32, 'V_DUAL_MAX_F32': ir3.VOP2Op.V_MAX_F32_E32,
  'V_DUAL_MIN_F32': ir3.VOP2Op.V_MIN_F32_E32, 'V_DUAL_ADD_NC_U32': ir3.VOP2Op.V_ADD_NC_U32_E32,
  'V_DUAL_LSHLREV_B32': ir3.VOP2Op.V_LSHLREV_B32_E32, 'V_DUAL_AND_B32': ir3.VOP2Op.V_AND_B32_E32,
  'V_DUAL_MOV_B32': ir3.VOP1Op.V_MOV_B32_E32, 'V_DUAL_CNDMASK_B32': ir3.VOP2Op.V_CNDMASK_B32_E32,
  'V_DUAL_FMAAK_F32': ir3.VOP2Op.V_FMAAK_F32_E32, 'V_DUAL_FMAMK_F32': ir3.VOP2Op.V_FMAMK_F32_E32,
  'V_DUAL_DOT2ACC_F32_F16': ir3.VOP2Op.V_DOT2ACC_F32_F16_E32,
}
# RDNA4 uses a _NUM_ suffix for min/max
VOPD_TO_VOP2 = {getattr(ir3.VOPDOp, n): t for n, t in _VOPD_TARGETS.items()}
VOPD_TO_VOP2.update({getattr(ir4.VOPDOp, n.replace('_MAX_', '_MAX_NUM_').replace('_MIN_', '_MIN_NUM_')): t for n, t in _VOPD_TARGETS.items()})
def _wave_size(arch: str) -> int: return 64 if arch.startswith("cdna") else 32
def _iattr(inst, name: str, default: int = 0) -> int:
  """Optional integer attribute of a decoded instruction (None/missing -> default)."""
  v = getattr(inst, name, default)
  return default if v is None else v

def _op_name(inst) -> str:
  if hasattr(inst, 'opx'): return f"{inst.opx.name}_{inst.opy.name}"  # VOPD has opx/opy not op
  return inst.op.name

def _lane_active(exec_mask: UOp, lane: UOp) -> UOp:
  if exec_mask.dtype == dtypes.uint64: return ((exec_mask >> lane.cast(dtypes.uint64)) & _c(1, dtypes.uint64)).ne(_c(0, dtypes.uint64))
  return ((exec_mask >> lane.cast(dtypes.uint32)) & _c(1)).ne(_c(0))
def _hi16(v: UOp) -> UOp: return (v >> _c(16)) & _c(0xFFFF)
def _cond(cond, if_true, if_false):
  """Select between values based on condition (works with UOp or bool)."""
  return cond.where(if_true, if_false) if isinstance(cond, UOp) else if_true if cond else if_false
def _cond_hi16(cond, val: UOp) -> UOp: return _cond(cond, _hi16(val), val)
def _apply_opsel(val: UOp, sel_bit: int, opsel: int) -> UOp: return _hi16(val) if opsel & (1 << sel_bit) else val

def _val_to_u32(val: UOp) -> UOp:
  """Convert any value to uint32 for storage (bitcast floats, cast ints)."""
  if val.dtype == dtypes.float32: return val.bitcast(dtypes.uint32)
  if val.dtype == dtypes.half: return val.bitcast(dtypes.uint16).cast(dtypes.uint32)
  return val.cast(dtypes.uint32)

_pcode_fixes = {
  'V_CVT_F32_FP8': ('VGPR[laneId][SRC0.u32]', 'S0'),
  'V_CVT_F32_BF8': ('VGPR[laneId][SRC0.u32]', 'S0'),
  'V_DIV_FMAS_F32': ('D0.f32 = 2.0F ** 32 * fma(S0.f32, S1.f32, S2.f32)',
    'D0.f32 = (exponent(S2.f32) > 127) ? (2.0F ** 64 * fma(S0.f32, S1.f32, S2.f32)) : (2.0F ** -64 * fma(S0.f32, S1.f32, S2.f32))'),
  'V_DIV_FMAS_F64': ('D0.f64 = 2.0 ** 64 * fma(S0.f64, S1.f64, S2.f64)',
    'D0.f64 = (exponent(S2.f64) > 1023) ? (2.0 ** 128 * fma(S0.f64, S1.f64, S2.f64)) : (2.0 ** -128 * fma(S0.f64, S1.f64, S2.f64))'),
  'V_DIV_FIXUP_F32': ('D0.f32 = sign_out ? -abs(S0.f32) : abs(S0.f32)',
    'D0.f32 = isNAN(S0.f32) ? (sign_out ? -INF.f32 : +INF.f32) : (sign_out ? -abs(S0.f32) : abs(S0.f32))'),
  'V_DIV_FIXUP_F64': ('D0.f64 = sign_out ? -abs(S0.f64) : abs(S0.f64)',
    'D0.f64 = isNAN(S0.f64) ? (sign_out ? -INF : +INF) : (sign_out ? -abs(S0.f64) : abs(S0.f64))'),
  'V_TRIG_PREOP_F64': ("result = 64'F((1201'B(2.0 / PI)[1200 : 0] << shift.u32) & 1201'0x1fffffffffffff)", "result = trig_preop_result(shift)"),
  # exponent() returns 0 for denormals; frexp_exp handles them per hardware (f32: 0, f64: normalized)
  'V_FREXP_EXP_I32_F32': ('D0.i32 = exponent(S0.f32) - 127 + 1', 'D0.i32 = frexp_exp(S0.f32)'),
  'V_FREXP_EXP_I32_F64': ('D0.i32 = exponent(S0.f64) - 1023 + 1', 'D0.i32 = frexp_exp(S0.f64)'),
  # route through ldexp() which propagates 0/inf/NaN inputs instead of computing val * 2**exp (0*inf = NaN on the host)
  'V_LDEXP_F32': ('D0.f32 = S0.f32 * 2.0F ** S1.i32', 'D0.f32 = ldexp(S0.f32, S1.i32)'),
  'V_LDEXP_F64': ('D0.f64 = S0.f64 * 2.0 ** S1.i32', 'D0.f64 = ldexp(S0.f64, S1.i32)'),
  # hardware sets SCC only on STRICT inequality for S_MAX (equal operands -> SCC=0)
  'S_MAX_I32': ('SCC = S0.i32 >= S1.i32', 'SCC = S0.i32 > S1.i32'),
  'S_MAX_U32': ('SCC = S0.u32 >= S1.u32', 'SCC = S0.u32 > S1.u32'),
  # hardware computes abs on the WRAPPED 32-bit difference; the i32 pcode overflows into UB on the host (e.g. |45 - -2147483647|),
  # so compute in u32 with a UB-free two's-complement negate
  'S_ABSDIFF_I32': ('D0.i32 = S0.i32 - S1.i32;\nif D0.i32 < 0 then\nD0.i32 = -D0.i32\nendif',
                    'D0.u32 = S0.u32 - S1.u32;\nif D0.i32 < 0 then\nD0.u32 = -D0.u32\nendif'),
  # CLASS denormal test uses abs(x) > 0.0, which the host's DAZ flushes; use bit-domain test instead
  'V_CMP_CLASS_F32': ('64\'F(abs(S0.f32)) > 0.0', '(64\'U(S0.u32 & 0x7FFFFFFF) != 0)'),
  'V_CMP_CLASS_F16': ('64\'F(abs(S0.f16)) > 0.0', '(64\'U(S0.u32 & 0x7FFF) != 0)'),
  'V_CMP_CLASS_F64': ('64\'F(abs(S0.f64)) > 0.0', '(64\'U(S0.u64 & 0x7FFFFFFFFFFFFFFF) != 0)'),
  'V_MUL_F32': ('D0.f32 = S0.f32 * S1.f32', 'D0.f32 = isNAN(S0.f32) ? cvtToQuietNAN(S0.f32) : isNAN(S1.f32) ? cvtToQuietNAN(S1.f32) : S0.f32*S1.f32'),
}

def _get_pcode_dict(op) -> dict:
  """Return the PCODE dictionary for the given opcode based on its architecture."""
  return PCODE_CDNA if 'cdna' in type(op).__module__ else PCODE_RDNA4 if 'rdna4' in type(op).__module__ else PCODE_RDNA3

# Pcode lookup with hardware errata fixes (the AMD-pdf pcode for these ops is subtly wrong)
@functools.cache
def get_pcode(op) -> str:
  op_name = op.name
  pcode_dict = _get_pcode_dict(op)
  if op not in pcode_dict and op_name.endswith('_E64'):
    # VOP3 ops ending in _E64 may share pcode with VOP1 _E32 equivalents
    import importlib
    enum_mod = importlib.import_module(type(op).__module__)
    vop1_cls, e32_name = getattr(enum_mod, 'VOP1Op', None), op_name.replace('_E64', '_E32')
    if vop1_cls and hasattr(vop1_cls, e32_name): op = vop1_cls[e32_name]
  pcode = pcode_dict[op]
  fix_name = op_name.replace('_E64', '').replace('_E32', '')
  if fix_name in _pcode_fixes: pcode = pcode.replace(*_pcode_fixes[fix_name])
  return _fix_div_scale(pcode, 'f32' if 'F32' in op_name else 'f64') if 'V_DIV_SCALE' in op_name else pcode

def _fix_div_scale(pcode: str, dt: str) -> str:
  """V_DIV_SCALE fixes: only the divWouldBeDenorm/exponent-overflow path may return the scaled value;
  all other paths must return S0 unchanged, and VCC is set exactly when scaling happened."""
  exp_lim, ldexp_val = ('23', '64') if dt == 'f32' else ('52', '128')
  for old, new in [(f'S2.{dt} / S1.{dt} == DENORM.{dt}', f'divWouldBeDenorm(S2.{dt}, S1.{dt})'), (f"1.0 / 64'F(S1.{dt}) == DENORM.f64", '0'),
                   (f'1.0 / S1.{dt} == DENORM.{dt}', '0'), (f'S1.{dt} == DENORM.{dt}', f'isDENORM(S1.{dt})'),
                   (f'D0.{dt} = NAN.{dt}', f'VCC = 0x1LL;\nD0.{dt} = NAN.{dt}'),
                   (f'elsif isDENORM(S1.{dt}) then\nD0.{dt} = ldexp(S0.{dt}, {ldexp_val})', f'elsif 1 == 0 then\nD0.{dt} = S0.{dt}'),
                    (f'elsif exponent(S2.{dt}) <= {exp_lim} then\n// Numerator is tiny\n'
                     f'D0.{dt} = ldexp(S0.{dt}, {ldexp_val})',
                     f'elsif exponent(S2.{dt}) <= {exp_lim} then\nVCC = 0x1LL;\n'
                     f'D0.{dt} = ldexp(S0.{dt}, {ldexp_val})'),
                    (f'elsif divWouldBeDenorm(S2.{dt}, S1.{dt}) then\nVCC = 0x1LL;\n'
                     f'if S0.{dt} == S2.{dt} then\n// Only scale the numerator\n'
                     f'D0.{dt} = ldexp(S0.{dt}, {ldexp_val})\nendif',
                     f'elsif divWouldBeDenorm(S2.{dt}, S1.{dt}) then\n'
                     f'VCC = 0x1LL;\nD0.{dt} = S0.{dt}'),
                    (f'D0.{dt} = ldexp(S0.{dt}, {ldexp_val})\nendif\nelsif',
                     f'D0.{dt} = ldexp(S0.{dt}, {ldexp_val})\nelse\n'
                     f'D0.{dt} = S0.{dt}\nendif\nelsif')]:
    pcode = pcode.replace(old, new)
  lines = pcode.rstrip().split('\n')
  for i in range(len(lines) - 1, -1, -1):
    if lines[i].strip() == 'endif':
      lines.insert(i, f'else\nD0.{dt} = S0.{dt}')
      break
  pcode = '\n'.join(lines) + f';\nif isDENORM(S1.{dt}) then\nD0.{dt} = NAN.{dt}\nendif'
  return pcode.replace('VCC = 0x0LL', 'VCC.u64[laneId] = 0').replace('VCC = 0x1LL', 'VCC.u64[laneId] = 1')

def _write_64bit(val: UOp, wfn, reg_or_addr, is_mem: bool, *args) -> list[UOp]:
  """Write a 64-bit value as two 32-bit writes. args passed to wfn after reg/addr and lo/hi value."""
  lo, hi = _split64(val)
  incr = 4 if is_mem else 1  # 4 bytes for memory addresses, 1 for register indices
  return [wfn(reg_or_addr, lo, *args), wfn(reg_or_addr + (_c(incr, reg_or_addr.dtype) if isinstance(reg_or_addr, UOp) else incr), hi, *args)]

def _write_val(bits: int, val: UOp, wfn, reg_or_addr, *args, is_mem: bool = False) -> list[UOp]:
  """Write value, splitting 64-bit if needed. bits=64 for 64-bit writes, otherwise 32-bit."""
  return _write_64bit(val, wfn, reg_or_addr, is_mem, *args) if bits == 64 else [wfn(reg_or_addr, _to_u32(val), *args)]

def _mem_store_bytes(mem: UOp, addr: UOp, val: UOp, active: UOp, data_bits: int = 32) -> list[UOp]:
  """Store to byte-addressable memory. addr is byte offset, mem is uint8 buffer."""
  stores = []
  val_u32 = val.cast(dtypes.uint32)
  for i in range(data_bits // 8):
    byte_val = (val_u32 >> _c(i * 8)) & _c(0xFF)
    stores.append(mem.index((addr + _c(i, dtypes.uint64)).valid(active)).store(byte_val.cast(dtypes.uint8)))
  return stores

def _collect_data_slices(assigns: list[tuple[str, UOp]], data_prefix: str, pcode_vars: dict | None = None, op_name: str = "") -> dict[int, UOp]:
  """Collect bit slices from assigns into {dword_idx: value} dict."""
  slices = {}
  for dest, val in assigns:
    if dest.startswith(f'{data_prefix}['):
      if (m := re.match(rf'{data_prefix}\[(\d+)\s*:\s*(\d+)\]', dest)):
        hi_bit, low_bit = int(m.group(1)), int(m.group(2))
        dword_idx = low_bit // 32
        # D16 loads preserve bits - use final value from pcode_vars which has hi bits preserved
        if pcode_vars and 'D16' in op_name and dword_idx == 0 and hi_bit < 32:
          slices[0] = _to_u32(pcode_vars.get(data_prefix, val))
        else: slices[dword_idx] = _to_u32(val)
    elif dest.startswith(data_prefix): slices[0] = _to_u32(val)
  return slices

# ═══════════════════════════════════════════════════════════════════════════════
# INSTRUCTION COMPILER - converts decoded instruction to UOp SINK
# ═══════════════════════════════════════════════════════════════════════════════

def _int_clamp(op_name: str, srcs: dict) -> UOp | None:
  """Integer clamp for V_*ADD/SUB/MAD* ops: compute in wide arithmetic and saturate to the narrow range. None if not applicable.
  NOTE: MUL_LO ops don't saturate - they always return the low bits."""
  s0, s1, s2 = srcs.get('S0'), srcs.get('S1'), srcs.get('S2')
  if not isinstance(s0, UOp) or not isinstance(s1, UOp): return None
  is_signed, is_16bit = '_I' in op_name and '_U' not in op_name, '16' in op_name
  if any(p in op_name for p in ('_NC_U', '_MAD_U', '_NC_I', '_MAD_I')):
    op_bits = 16 if '16' in op_name else (24 if '24' in op_name else 32)
    # D0 range: 16 for the *_U16/*_I16 result-narrow ops, else 32 (mad*32* D0 is u32/i32; mul operands have op-fmt width)
    narrow_dt = dtypes.uint16 if is_16bit and '32' not in op_name else (dtypes.int32 if is_signed else dtypes.uint32)
    wide_dt = dtypes.int64
    narrow_max, narrow_min = ((0xFFFF, 0) if narrow_dt == dtypes.uint16 else ((0x7FFFFFFF, -0x80000000) if is_signed else (0xFFFFFFFF, 0)))
    def to_mulin(x: UOp) -> UOp:  # mul-source: extract the op-fmt-width suboperand with sext for signed
      mask = (1 << op_bits) - 1
      if op_bits == 32: return x.bitcast(narrow_dt) if x.dtype.itemsize == 4 else x.cast(narrow_dt)
      m = (x & _c(mask)).cast(dtypes.int)
      if not is_signed: return m.cast(wide_dt)
      sign = (m >> _c(op_bits - 1)) & _c(1)
      return sign.ne(_c(0)).where(m - _c(1 << op_bits), m).cast(wide_dt)
    def to_wide(x: UOp) -> UOp: return (x.bitcast(narrow_dt) if x.dtype.itemsize == narrow_dt.itemsize else x.cast(narrow_dt)).cast(wide_dt)
    if isinstance(s2, UOp) and 'MAD' in op_name: full = to_mulin(s0) * to_mulin(s1) + to_wide(s2)
    elif 'SUBREV' in op_name: full = to_wide(s1) - to_wide(s0)
    elif 'SUB' in op_name: full = to_wide(s0) - to_wide(s1)
    else: full = to_wide(s0) + to_wide(s1)
    return full.clamp(narrow_min, narrow_max).cast(narrow_dt)
  # V_SUB_U32 / V_ADD_U32 with clamp: unsigned saturate (SUB underflow->0, ADD overflow->0xFFFFFFFF)
  if any(p in op_name for p in ('_SUB_U32', '_ADD_U32', '_SUB_U16', '_ADD_U16')):
    a, b = (s1.cast(dtypes.uint32), s0.cast(dtypes.uint32)) if 'SUBREV' in op_name else (s0.cast(dtypes.uint32), s1.cast(dtypes.uint32))
    if 'SUB' in op_name: return (a < b).where(_c(0), a - b)  # underflow -> 0
    return (a + b < a).where(_c(0xFFFFFFFF), a + b)  # overflow -> MAX
  return None

# Inline float constants (as bit patterns) for GPU instructions
F32_INLINE = {240: 0x3f000000, 241: 0xbf000000, 242: 0x3f800000, 243: 0xbf800000,  # 0.5, -0.5, 1.0, -1.0
              244: 0x40000000, 245: 0xc0000000, 246: 0x40800000, 247: 0xc0800000, 248: 0x3e22f983}  # 2.0, -2.0, 4.0, -4.0, 1/(2*pi)

# Canonical physical register param tokens: 0..255 SGPR, 256..511 VGPR, 512..767 ACCVGPR
@functools.cache
def _reg_param(file: str, idx: int, wave_size: int) -> UOp:
  assert 0 <= idx < 256, f"register index out of range: {file}{idx}"
  if file == 's': return UOp.param(idx, dtypes.uint32, (1,), name=f"s{idx}", addrspace=AddrSpace.REG)
  if file == 'v': return UOp.param(256 + idx, dtypes.uint32, (wave_size,), name=f"v{idx}", addrspace=AddrSpace.REG)
  if file == 'a': return UOp.param(512 + idx, dtypes.uint32, (wave_size,), name=f"a{idx}", addrspace=AddrSpace.REG)
  raise ValueError(f"unknown reg file {file}")

def _inline_u32(off: int, literal: int | None = None) -> int:
  if 128 <= off <= 192: return off - 128
  if 193 <= off <= 208: return (64 - (off - 128)) & 0xFFFFFFFF
  if off in F32_INLINE: return F32_INLINE[off]
  if off == 255: return (literal or 0) & 0xFFFFFFFF
  return 0

def _inline_val(off: int, bits: int, literal: int | None = None, is_f64: bool = False, do_cast: bool = True) -> tuple[int, DType]:
  if bits == 64:
    if off == 255: return (((literal or 0) & 0xFFFFFFFF) << 32) if is_f64 else ((literal or 0) & 0xFFFFFFFF), dtypes.uint64
    if off in F32_INLINE:
      return struct.unpack('<Q', struct.pack('<d', struct.unpack('<f', struct.pack('<I', F32_INLINE[off]))[0]))[0], dtypes.uint64
    v = _inline_u32(off)
    return (v - 0x100000000 if v >= 0x80000000 else v) & 0xFFFFFFFFFFFFFFFF, dtypes.uint64
  u = _inline_u32(off, literal)
  if bits == 16 and do_cast and off in F32_INLINE:
    u = struct.unpack('<H', struct.pack('<e', struct.unpack('<f', struct.pack('<I', u))[0]))[0]
  return u, dtypes.uint32

def _field_off(inst: Inst, name: str) -> int:
  v = getattr(inst, name)
  return v.offset if isinstance(v, Reg) else int(v)

def _field_int(inst: Inst, name: str, signed: bool = False) -> int:
  f = getattr(type(inst), name)
  v = int(getattr(inst, name))
  if signed:
    w = f.hi - f.lo + 1
    if v >= (1 << (w - 1)): v -= (1 << w)
  return v

def _is_16bit_rdna_hi_field(inst: Inst, fname: str) -> bool:
  if isinstance(inst, (irc.VOP1, irc.VOP2, irc.VOPC)) or not isinstance(inst, (ir3.VOP1, ir3.VOP2, ir3.VOPC, ir4.VOP1, ir4.VOP2, ir4.VOPC)):
    return False
  bits = inst.canonical_op_bits
  return (bits['d'] == 16 if fname == 'vdst' else bits['s0'] == 16)

def _field_active(fname: str, ops: dict) -> bool:
  return (not ops or fname in ops or (fname == 'src0' and 'vsrc0' in ops)
          or fname in ('scale_src0', 'scale_src1', 'vsrc0', 'vsrc1', 'sdst', 'sbase'))

def _active_reg_fields(inst: Inst) -> list[tuple[str, Reg]]:
  ops = inst.operands
  return [(fname, val) for fname, _ in inst._fields if isinstance(val := getattr(inst, fname), Reg) and _field_active(fname, ops)]

def _ext_reg(file: str, fname: str, delta: int, shift: int, wave_size: int, inst: Inst) -> UOp:
  off = _field_off(inst, fname)
  return _reg_param(file, (off - 256 - shift if off >= 256 else off) + delta, wave_size)

def _ext_sdwa_sgpr(fname: str, wave_size: int, inst: Inst) -> UOp: return _reg_param('s', _field_off(inst, fname) - 256, wave_size)
def _ext_sdwa_imm(fname: str, inst: Inst) -> UOp: return _c(_inline_u32(_field_off(inst, fname) - 256, getattr(inst, 'literal', None)))
def _ext_fixed_reg(file: str, idx: int, wave_size: int, _inst: Inst) -> UOp: return _reg_param(file, idx, wave_size)
def _ext_imm_field(name: str, signed: bool, dtype: DType, inst: Inst) -> UOp: return _c(_field_int(inst, name, signed), dtype)
def _ext_rsrc_imm(fname: str, bits: int, is_f64: bool, do_cast: bool, inst: Inst) -> UOp:
  return _c(*_inline_val(_field_off(inst, fname), bits, getattr(inst, 'literal', None), is_f64, do_cast))

class _VGPRMap(dict):
  def __init__(self, ctx: '_Ctx'): self.ctx = ctx
  def __getitem__(self, idx: int) -> UOp: return self.ctx.vgpr(idx)

class _Ctx:
  """Context for instruction compilation - allocates distinct per-register params and ALU imm params."""
  __slots__ = ('inst', '_axis_id', 'wave_size', 'branch_cond', '_regs', '_imms', '_param_specs', '_reg_fields')
  vmem = UOp.param(1000, dtypes.uint32, 1 << 46, name="vmem", addrspace=AddrSpace.GLOBAL)
  lds = UOp.param(1001, dtypes.uint32, 16384, name="lds", addrspace=AddrSpace.REG)
  scratch = UOp.param(1002, dtypes.uint8, 1 << 30, name="scratch", addrspace=AddrSpace.REG)
  scratch_stride = UOp.param(-10, dtypes.uint32, name="scratch_stride", addrspace=AddrSpace.ALU)

  def __init__(self, inst: Inst, wave_size: int = 32):
    self.inst, self._axis_id, self.wave_size = inst, 0, wave_size
    self.branch_cond: UOp | None = None
    self._regs: dict[tuple[str, int], UOp] = {}
    self._imms: list[UOp] = []
    self._param_specs: dict[UOp, Callable[[Inst], UOp]] = {
      self.vmem: lambda _: self.vmem, self.lds: lambda _: self.lds,
      self.scratch: lambda _: self.scratch, self.scratch_stride: lambda _: self.scratch_stride,
    }
    self._reg_fields: dict[tuple[str, int], Callable[[Inst], UOp]] = {}
    for fname, val in _active_reg_fields(inst):
      off = val.offset
      if off >= 256:
        sh = 128 if (off >= 384 and _is_16bit_rdna_hi_field(inst, fname)) else 0
        base = off - 256 - sh
        for d in range(val.sz):
          self._reg_fields.setdefault(('v', base + d), functools.partial(_ext_reg, 'v', fname, d, sh, wave_size))
          self._reg_fields.setdefault(('a', base + d), functools.partial(_ext_reg, 'a', fname, d, 0, wave_size))
      elif off < 128 or off == SCC.offset:
        for d in range(val.sz):
          self._reg_fields.setdefault(('s', off + d), functools.partial(_ext_reg, 's', fname, d, 0, wave_size))

  def range(self, n: int | None = None) -> UOp:
    """Create a lane range UOp with unique axis ID."""
    if n is None: n = self.wave_size
    self._axis_id += 1
    return UOp.range(n, self._axis_id, dtype=dtypes.int)

  def unroll_lanes(self, get_lane_bit, exec_mask: UOp, apply_exec: bool = True) -> UOp:
    """Combine lane bits into a mask using RANGE+REDUCE (32-bit for RDNA, 64-bit for CDNA)."""
    lane = self.range()
    dtype = dtypes.uint32 if self.wave_size <= 32 else dtypes.uint64
    bit = get_lane_bit(lane).cast(dtype) << lane.cast(dtype)
    result = bit.reduce(lane, arg=Ops.ADD)
    return result & exec_mask if apply_exec else result

  def reg(self, file: str, idx: int, ext: Callable[[Inst], UOp] | None = None) -> UOp:
    key = (file, idx)
    if key in self._regs: return self._regs[key]
    slot = len(self._regs)
    p = UOp.param(slot, dtypes.uint32, (1,) if file == 's' else (self.wave_size,), name=f"{file}{slot}", addrspace=AddrSpace.REG)
    self._regs[key] = p
    self._param_specs[p] = ext or self._reg_fields.get(key) or functools.partial(_ext_fixed_reg, file, idx, self.wave_size)
    return p

  def sgpr(self, idx: int, ext: Callable[[Inst], UOp] | None = None) -> UOp: return self.reg('s', idx, ext)
  def vgpr(self, idx: int, ext: Callable[[Inst], UOp] | None = None) -> UOp: return self.reg('v', idx, ext)
  def accvgpr(self, idx: int, ext: Callable[[Inst], UOp] | None = None) -> UOp: return self.reg('a' if self.wave_size == 64 else 'v', idx, ext)

  def imm(self, dtype: DType, ext: Callable[[Inst], UOp]) -> UOp:
    p = UOp.param(-100 - len(self._imms), dtype, name=f"imm{len(self._imms)}", addrspace=AddrSpace.ALU)
    self._imms.append(p)
    self._param_specs[p] = ext
    return p

  def imm_field(self, name: str, signed: bool = False, dtype: DType = dtypes.uint32) -> UOp:
    return self.imm(dtype, functools.partial(_ext_imm_field, name, signed, dtype))

  def optional_imm_field(self, name: str, signed: bool = False, dtype: DType = dtypes.uint32) -> UOp | None:
    return self.imm_field(name, signed, dtype) if hasattr(type(self.inst), name) else None

  def _fext(self, file: str, fname: str, delta: int = 0, hi16_shift: int = 0) -> Callable[[Inst], UOp]:
    return functools.partial(_ext_reg, file, fname, delta, hi16_shift, self.wave_size)

  def rexec(self) -> UOp: return self.rmask(EXEC_LO.offset)

  def rsgpr(self, idx: int, ext: Callable[[Inst], UOp] | None = None) -> UOp:
    if self.wave_size == 32 and idx == 124: return _c(0)
    return self.sgpr(idx, ext).index(_c(0, dtypes.int)).load()

  def wsgpr(self, idx: int, val: UOp, ext: Callable[[Inst], UOp] | None = None) -> list[UOp]:
    if self.wave_size == 32 and idx == 124: return []
    return [self.sgpr(idx, ext).index(_c(0, dtypes.int)).store(val.cast(dtypes.uint32))]

  def wmask(self, idx: int, val: UOp, fname: str | None = None) -> list[UOp]:
    ext0 = self._fext('s', fname, 0) if fname else None
    if self.wave_size > 32:
      lo, hi = _split64(val)
      ext1 = self._fext('s', fname, 1) if fname else None
      return self.wsgpr(idx, lo, ext0) + self.wsgpr(idx + 1, hi, ext1)
    return self.wsgpr(idx, val, ext0)

  def rmask(self, idx: int, fname: str | None = None) -> UOp:
    ext0 = self._fext('s', fname, 0) if fname else None
    if self.wave_size > 32:
      ext1 = self._fext('s', fname, 1) if fname else None
      return _u64(self.rsgpr(idx, ext0), self.rsgpr(idx + 1, ext1))
    return self.rsgpr(idx, ext0)

  def rvgpr(self, idx: int, lane: UOp, ext: Callable[[Inst], UOp] | None = None) -> UOp:
    return self.vgpr(idx, ext).index(lane.cast(dtypes.int)).load()

  def wvgpr(self, idx: int, lane: UOp, val: UOp, exec_mask: UOp, after: UOp | None = None, ext: Callable[[Inst], UOp] | None = None) -> UOp:
    buf = self.vgpr(idx, ext)
    if after is not None: buf = buf.after(after)
    return buf.index(lane.cast(dtypes.int).valid(_lane_active(exec_mask, lane))).store(val.cast(dtypes.uint32))

  def raccvgpr(self, idx: int, lane: UOp, ext: Callable[[Inst], UOp] | None = None) -> UOp:
    return self.accvgpr(idx, ext).index(lane.cast(dtypes.int)).load()

  def waccvgpr(self, idx: int, lane: UOp, val: UOp, exec_mask: UOp, ext: Callable[[Inst], UOp] | None = None) -> UOp:
    return self.accvgpr(idx, ext).index(lane.cast(dtypes.int).valid(_lane_active(exec_mask, lane))).store(val.cast(dtypes.uint32))

  def rsrc(self, fname: str, lane: UOp | None, bits: int = 32, is_f64: bool = False, do_cast: bool = True, hi16_vop: bool = False) -> UOp:
    """Read source operand from field fname. Statically dispatches VGPR vs SGPR vs NULL vs inline constant/literal."""
    off = _field_off(self.inst, fname)
    if off >= 256:
      assert lane is not None
      if hi16_vop and bits == 16 and off >= 384:
        return _hi16(self.rvgpr(off - 384, lane, self._fext('v', fname, 0, hi16_shift=128)))
      vreg = off - 256
      lo = self.rvgpr(vreg, lane, self._fext('v', fname, 0))
      return _u64(lo, self.rvgpr(vreg + 1, lane, self._fext('v', fname, 1))) if bits == 64 else lo
    if off == SCC.offset:
      s = self.rsgpr(SCC.offset)
      return s.cast(dtypes.uint64) if bits == 64 else s
    if self.wave_size == 32 and off == 124: return _c(0, dtypes.uint64 if bits == 64 else dtypes.uint32)
    if off < 128:
      lo = self.rsgpr(off, self._fext('s', fname, 0))
      return _u64(lo, self.rsgpr(off + 1, self._fext('s', fname, 1))) if bits == 64 else lo
    # Inline constant (128..248) or literal (255)
    _, dt = _inline_val(off, bits, getattr(self.inst, 'literal', None), is_f64, do_cast)
    return self.imm(dt, functools.partial(_ext_rsrc_imm, fname, bits, is_f64, do_cast))

  def scalar_stores(self, assigns: list[tuple[str, UOp]], sdst_reg: int, sdst_size: int = 1, sdst_field: str | None = None) -> list[UOp]:
    """Generate stores for scalar assigns (D0, SCC, EXEC, VCC)."""
    stores: list[UOp] = []
    for dest, val in assigns:
      if dest.startswith('D0'):
        if sdst_size == 2:
          lo, hi = _split64(val)
          stores.extend(self.wsgpr(sdst_reg, lo, self._fext('s', sdst_field, 0) if sdst_field else None))
          stores.extend(self.wsgpr(sdst_reg + 1, hi, self._fext('s', sdst_field, 1) if sdst_field else None))
        elif sdst_size == 1:
          stores.extend(self.wsgpr(sdst_reg, _val_to_u32(val), self._fext('s', sdst_field, 0) if sdst_field else None))
      elif dest.startswith('SCC'): stores.extend(self.wsgpr(SCC.offset, _to_u32(val)))
      elif dest.startswith('EXEC'):
        if self.wave_size > 32 and val.dtype in (dtypes.uint64, dtypes.int64):
          lo, hi = _split64(val)
          stores.extend(self.wsgpr(EXEC_LO.offset, lo) + self.wsgpr(EXEC_LO.offset + 1, hi))
        else: stores.extend(self.wsgpr(EXEC_LO.offset, _to_u32(val)))
      elif dest.startswith('VCC'): stores.extend(self.wmask(VCC_LO.offset, val))
      elif dest.startswith('PC'): raise NotImplementedError("AMD lifter does not support direct PC writes")
    return stores

  def compile_sop_pcode(self, op, srcs: dict[str, UOp | int], sdst_reg: int, sdst_size: int, sdst_field: str | None = None) -> UOp:
    """Compile a scalar instruction."""
    pcode = get_pcode(op)
    srcs.update(self.base_srcs(self.rexec()), VCC=self.rmask(VCC_LO.offset))
    if 'D0' not in srcs and sdst_size > 0:
      srcs['D0'] = self.rsgpr(sdst_reg, self._fext('s', sdst_field, 0) if sdst_field else None)
    _, assigns = parse_pcode(pcode, srcs)
    return UOp.sink(*self.scalar_stores(assigns, sdst_reg, sdst_size, sdst_field))

  def compile_lane_pcode(self, op, inst) -> UOp:
    """Compile cross-lane ops (READLANE/WRITELANE/PERMLANE) using pcode parser."""
    pcode, op_name, ops = get_pcode(op), op.name, inst.operands
    src0_off, vdst_off = _field_off(inst, 'src0'), _field_off(inst, 'vdst')
    src0_reg = src0_off - 256 if src0_off >= 256 else 0
    vdst_vreg = vdst_off - 256 if vdst_off >= 256 else vdst_off
    has_src1 = hasattr(type(inst), 'src1') and (not ops or 'src1' in ops)
    has_src2 = hasattr(type(inst), 'src2') and (not ops or 'src2' in ops)
    src1_off = _field_off(inst, 'src1') if has_src1 else None
    src2_off = _field_off(inst, 'src2') if has_src2 else None
    exec_val = self.rexec()
    srcs = {
      'SRC0': _c(src0_reg), 'VDST': _c(vdst_vreg), 'EXEC_LO': exec_val.cast(dtypes.uint32), 'EXEC': exec_val.cast(dtypes.uint64),
      '_vgpr': _VGPRMap(self), '_wave_size': self.wave_size,
      'SRC1': _c(src1_off - 256 if src1_off is not None and src1_off >= 256 else (src1_off or 0)),
      'SRC2': _c(src2_off - 256 if src2_off is not None and src2_off >= 256 else (src2_off or 0)),
      'S0': self.rsrc('src0', _c(0, dtypes.int)) if 'WRITELANE' in op_name else _c(src0_reg),
      'S1': self.rsrc('src1', _c(0, dtypes.int)) if has_src1 else _c(0),
      'S2': self.rsrc('src2', _c(0, dtypes.int)) if has_src2 else _c(0),
    }
    _, assigns = parse_pcode(pcode, srcs)
    stores = []
    for dest, val in assigns:
      if dest.startswith('D0'): stores.extend(self.wsgpr(vdst_vreg, val.cast(dtypes.uint32), self._fext('s', 'vdst', 0)))
      elif dest.startswith('VGPR['): stores.append(val[0].store(val[1].cast(dtypes.uint32)))
    return UOp.sink(*stores)

  def base_srcs(self, exec_mask: UOp, lane: UOp | None = None) -> dict[str, Any]:
    """Pcode environment entries shared by all instructions: EXEC/SCC, rounding mode (emulator always rounds-nearest-even),
    and CDNA SDWA byte/word select defaults (E32 encodings always use BYTE0/WORD0)."""
    srcs: dict[str, Any] = {'EXEC': exec_mask, 'SCC': self.rsgpr(SCC.offset), '_vgpr': _VGPRMap(self), '_wave_size': self.wave_size,
                                  'ROUND_MODE': _c(0), 'ROUND_TOWARD_ZERO': _c(0), 'ROUND_NEAREST_EVEN': _c(0),
                                  'SDWA_SRC0_SEL': _c(0), 'BYTE0': _c(0), 'BYTE1': _c(1), 'BYTE2': _c(2), 'BYTE3': _c(3),
                                  'WORD0': _c(0), 'WORD1': _c(1)}
    if lane is not None: srcs['laneId'] = lane
    return srcs

  def compile_vop_pcode(self, op, srcs: dict[str, UOp | int], lane: UOp, vdst_reg: int, exec_mask: UOp,
                        opsel_dst_hi: bool = False, sdst_reg: int | None = None, sdst_field: str | None = None, clmp: int = 0,
                        src0_vreg: int | None = None, vdst_hi_shift: int = 0) -> UOp:
    """Compile VOP instruction to a sink of stores."""
    pcode = get_pcode(op)
    vcc_reg = sdst_reg if sdst_reg is not None else VCC_LO.offset
    if 'VCC' not in srcs: srcs['VCC'] = self.rmask(vcc_reg, sdst_field)
    srcs.update(self.base_srcs(exec_mask, lane), VDST=_c(vdst_reg), MAX_FLOAT_F32=_c(3.4028234663852886e38, dtypes.float32))
    # f32 min/max/median ops flush denormal inputs to signed zero (select-style ops: results propagate inputs bitwise)
    # (RDNA4 calls them _NUM_: V_MIN_NUM_F32 etc.)
    if any(p in op.name for p in ('MIN_F32', 'MAX_F32', 'MIN3_F32', 'MAX3_F32', 'MED3_F32', 'MIN_NUM_F32', 'MAX_NUM_F32')):
      srcs = {k: _ftz_f32(v) if k in ('S0', 'S1', 'S2') and isinstance(v, UOp) else v for k, v in srcs.items()}
    _, assigns = parse_pcode(pcode, srcs)

    # For integer ops with clamp, pre-compute the saturated result; floats clamp to [0,1] at write time
    int_saturate = _int_clamp(op.name, srcs) if clmp else None
    vdst_ext0 = self._fext('v', 'vdst', 0, hi16_shift=vdst_hi_shift)
    vdst_ext1 = self._fext('v', 'vdst', 1)

    # For swap ops (writing both D0 and S0), ensure both reads complete before either write.
    swap_reads = UOp.group(*(v for k in ('D0', 'S0') if isinstance(v := srcs.get(k), UOp))) \
      if src0_vreg is not None and any(d.startswith('S0') for d, _ in assigns) else None

    lane_stores, scalar_stores, slice_stores = [], [], []
    vcc_val, exec_val = None, None
    for dest, val in assigns:
      # VGPR bit-slice assignment: VGPR[lane][reg][hi:lo] -> read-modify-write with optional condition
      if dest.startswith('VGPR[') and re.search(r'\[\d+:\d+\]', dest):
        hi_bit, lo_bit = int(val[2]), int(val[3])
        new_val = _set_bits(val[0].load(), _val_to_bits(val[1]), hi_bit - lo_bit + 1, lo_bit).cast(dtypes.uint32)
        active = _lane_active(exec_mask, lane) & _to_bool(val[4]) if len(val) > 4 else _lane_active(exec_mask, lane)
        lane_stores.append(val[0].src[0].index(val[0].src[1].valid(active)).store(new_val))
      elif 'D0' in dest and '[laneId]' in dest: continue  # per-lane mask bits are written via VCC/EXEC assigns instead
      elif dest.startswith('D0'):
        if (dest_suffix := re.match(r'D0\.(\w+)', dest)) is not None:
          target_dt = {'u16': dtypes.uint16, 'i16': dtypes.int16, 'f16': dtypes.half}.get(dest_suffix.group(1))
          if target_dt is not None: val = val.cast(target_dt)
        if (slice_match := re.match(r'D0\[(\d+)\s*:\s*(\d+)\]', dest)) and (int(slice_match.group(1)), int(slice_match.group(2))) != (31, 0):
          slice_stores.append((int(slice_match.group(2)), int(slice_match.group(1)) - int(slice_match.group(2)) + 1, _val_to_bits(val)))
          continue
        if int_saturate is not None: val = int_saturate
        elif clmp and val.dtype in (dtypes.float32, dtypes.half, dtypes.float64):
          # hardware clamp: -0 becomes +0 and NaN becomes 0 (hardware verified)
          val = (val > _c(0.0, val.dtype)).where(val.minimum(_c(1.0, val.dtype)), _c(0.0, val.dtype))
        if val.dtype in (dtypes.uint64, dtypes.int64, dtypes.float64):
          lo, hi = _split64(val)
          lane_stores.extend([self.wvgpr(vdst_reg, lane, lo, exec_mask, after=swap_reads, ext=vdst_ext0),
                              self.wvgpr(vdst_reg + 1, lane, hi, exec_mask, after=swap_reads, ext=vdst_ext1)])
        elif val.dtype in (dtypes.half, dtypes.uint16, dtypes.int16):
          result, old_val = _val_to_u32(val), self.rvgpr(vdst_reg, lane, vdst_ext0)
          if opsel_dst_hi: result = (old_val & _c(0xFFFF)) | (result << _c(16, dtypes.uint32))
          else: result = (result & _c(0xFFFF)) if self.wave_size == 64 else (old_val & _c(0xFFFF0000)) | (result & _c(0xFFFF))
          lane_stores.append(self.wvgpr(vdst_reg, lane, result, exec_mask, after=swap_reads, ext=vdst_ext0))
        else: lane_stores.append(self.wvgpr(vdst_reg, lane, _val_to_u32(val), exec_mask, after=swap_reads, ext=vdst_ext0))
      elif dest.startswith('S0') and src0_vreg is not None:
        lane_stores.append(self.wvgpr(src0_vreg, lane, _val_to_u32(val), exec_mask, after=swap_reads, ext=self._fext('v', 'src0', 0)))
      elif dest.startswith('VCC'): vcc_val = val
      elif dest.startswith('EXEC'): exec_val = val
      elif dest.startswith('SCC'): scalar_stores.extend(self.wsgpr(SCC.offset, _to_u32(val)))

    # VCC/EXEC mask writes must be computed BEFORE VGPR stores to avoid reading modified VGPRs.
    stores: list[UOp] = []
    for mask_val, reg, fn in [(vcc_val, vcc_reg, sdst_field), (exec_val, EXEC_LO.offset, None)]:
      if mask_val is None: continue
      stores.extend(self.wmask(reg, self.unroll_lanes(lambda l, v=mask_val: (_to_u32(v.substitute({lane: l})) & _c(1)).cast(dtypes.uint32),
                                                      exec_mask, apply_exec=reg != EXEC_LO.offset), fn))
    if slice_stores:  # merge D0[hi:lo] slices into one read-modify-write of the destination VGPR
      result = self.rvgpr(vdst_reg, lane, vdst_ext0)
      for lo_bit, width, val_bits in slice_stores: result = _set_bits(result, val_bits, width, lo_bit)
      lane_stores.append(self.wvgpr(vdst_reg, lane, result, exec_mask, ext=vdst_ext0))
    if lane_stores: stores.append(UOp.sink(*lane_stores).end(lane))
    stores.extend(scalar_stores)
    return UOp.sink(*stores)

# ═══════════════════════════════════════════════════════════════════════════════
# INSTRUCTION HANDLERS
# ═══════════════════════════════════════════════════════════════════════════════

def _compile_sopp(inst: ir3.SOPP | ir4.SOPP, ctx: _Ctx) -> UOp:
  if inst.op in (ir3.SOPPOp.S_ENDPGM, ir4.SOPPOp.S_ENDPGM, irc.SOPPOp.S_ENDPGM): return UOp.sink()
  if inst.op in _BARRIER_OPS: return UOp.sink()
  if inst.op in (ir3.SOPPOp.S_NOP, ir4.SOPPOp.S_NOP, irc.SOPPOp.S_NOP, irc.SOPPOp.S_WAITCNT): return UOp.sink()
  if inst.op in _get_pcode_dict(inst.op):
    pcode = get_pcode(inst.op)
    simm16 = ctx.imm_field('simm16', signed=True, dtype=dtypes.int16)
    vcc, exec_val = ctx.rmask(VCC_LO.offset), ctx.rexec()
    srcs = {'PC': _c(0, dtypes.uint32), 'SIMM16': simm16, 'SCC': ctx.rsgpr(SCC.offset), 'VCC': vcc,
            'VCCZ': vcc.eq(_c(0, vcc.dtype)).cast(dtypes.uint32), 'EXECZ': exec_val.eq(_c(0, exec_val.dtype)).cast(dtypes.uint32)}
    for dest, val in parse_pcode(pcode, srcs)[1]:
      if dest.startswith('PC') and val.op is Ops.WHERE: ctx.branch_cond = val.src[0]
  return UOp.sink()

def _compile_smem(inst: ir3.SMEM | ir4.SMEM, ctx: _Ctx) -> UOp:
  sbase = _field_off(inst, 'sbase')
  sdata_reg = _field_off(inst, 'sdata')
  offset_name = 'ioffset' if hasattr(type(inst), 'ioffset') else 'offset'
  offset = ctx.imm_field(offset_name, signed=True, dtype=dtypes.int32)
  soffset_val = _c(0, dtypes.uint64)
  if not (isinstance(inst, irc.SMEM) and not inst.soffset_en):
    soffset_val = ctx.rsrc('soffset', None, 32).cast(dtypes.uint64)
  base = _u64(ctx.rsgpr(sbase, ctx._fext('s', 'sbase', 0)), ctx.rsgpr(sbase + 1, ctx._fext('s', 'sbase', 1)))
  byte_offset = offset.cast(dtypes.uint64) + soffset_val
  srcs = {'ADDR': base + byte_offset, 'sgpr_base': base, 'offset': byte_offset,
          'SBASE': base, 'SOFFSET': soffset_val, 'OFFSET': offset, '_vmem': ctx.vmem}
  funcs = {'CalcScalarGlobalAddr': lambda _base, soffset, offset: base + soffset.cast(dtypes.uint64) + offset.cast(dtypes.uint64)}
  _, assigns = parse_pcode(get_pcode(inst.op), srcs, funcs)
  stores = [st for i, val in _collect_data_slices(assigns, 'SDATA').items()
            for st in ctx.wsgpr(sdata_reg + i, val, ctx._fext('s', 'sdata', i))]
  return UOp.sink(*stores)

def _compile_sop(inst: ir3.SOP1|ir3.SOP2|ir3.SOPC|ir3.SOPK|ir4.SOP1|ir4.SOP2|ir4.SOPC|ir4.SOPK|irc.SOP1|irc.SOP2|irc.SOPC|irc.SOPK, ctx: _Ctx) -> UOp:
  bits = inst.canonical_op_bits
  if isinstance(inst, (ir3.SOPK, ir4.SOPK, irc.SOPK)):
    sdst_off = _field_off(inst, 'sdst')
    simm16 = ctx.imm_field('simm16', signed=False, dtype=dtypes.uint32)
    simm16_sext = simm16.cast(dtypes.int16).cast(dtypes.int32)
    op_name = _op_name(inst)
    d0 = ctx.rsgpr(sdst_off, ctx._fext('s', 'sdst', 0))
    if isinstance(inst, ir4.SOPK): s0 = simm16
    elif isinstance(inst, irc.SOPK) and 'CMPK' not in op_name and 'SETREG' not in op_name: s0 = simm16_sext
    else: s0 = d0
    srcs: dict[str, UOp|int] = {'S0': s0, 'S1': simm16_sext, 'SIMM16': simm16_sext, 'D0': d0}
    dst_off, dst_size, dst_field = sdst_off, 1, 'sdst'
  elif isinstance(inst, (ir3.SOP1, ir4.SOP1, irc.SOP1)):
    if isinstance(inst, ir4.SOP1) and inst.op in _BARRIER_SOP1_OPS: return UOp.sink()
    sdst_off = _field_off(inst, 'sdst')
    srcs = {'S0': ctx.rsrc('ssrc0', None, bits['s0'])}
    dst_off, dst_size, dst_field = sdst_off, 2 if bits['d'] == 64 else 1, 'sdst'
  elif isinstance(inst, (ir3.SOP2, ir4.SOP2, irc.SOP2)):
    sdst_off = _field_off(inst, 'sdst')
    srcs = {'S0': ctx.rsrc('ssrc0', None, bits['s0']), 'S1': ctx.rsrc('ssrc1', None, bits['s1'])}
    if (lit := ctx.optional_imm_field('literal')) is not None: srcs['SIMM32'] = lit
    dst_off, dst_size, dst_field = sdst_off, 2 if bits['d'] == 64 else 1, 'sdst'
  elif isinstance(inst, (ir3.SOPC, ir4.SOPC, irc.SOPC)):
    srcs = {'S0': ctx.rsrc('ssrc0', None, bits['s0']), 'S1': ctx.rsrc('ssrc1', None, bits['s1'])}
    dst_off, dst_size, dst_field = 0, 0, None
  else:
    raise RuntimeError(f"unknown SOP type: {type(inst).__name__}")
  return ctx.compile_sop_pcode(inst.op, srcs, dst_off, dst_size, dst_field)

def _sdwa_select(val: UOp, sel: UOp, sext: UOp) -> UOp:
  """Apply SDWA byte/word selection and optional sign extension to a 32-bit value."""
  # sel: 0-3=BYTE_0..3, 4=WORD_0, 5=WORD_1, 6=DWORD
  b0 = val & _c(0xFF)
  b1 = (val >> _c(8)) & _c(0xFF)
  b2 = (val >> _c(16)) & _c(0xFF)
  b3 = (val >> _c(24)) & _c(0xFF)
  w0 = val & _c(0xFFFF)
  w1 = (val >> _c(16)) & _c(0xFFFF)
  selected = sel.eq(_c(1)).where(b1, sel.eq(_c(2)).where(b2, sel.eq(_c(3)).where(b3,
    sel.eq(_c(4)).where(w0, sel.eq(_c(5)).where(w1, sel.eq(_c(6)).where(val, b0))))))
  # Sign extend when sext=1
  is_byte = sel < _c(4)
  byte_sext = (selected & _c(0x80)).ne(_c(0)).where(selected | _c(0xFFFFFF00), selected)
  word_sext = (selected & _c(0x8000)).ne(_c(0)).where(selected | _c(0xFFFF0000), selected)
  return sext.ne(_c(0)).where(is_byte.where(byte_sext, word_sext), selected)

def _sdwa_write(old: UOp, val: UOp, dst_sel: UOp, dst_unused: UOp) -> UOp:
  """Apply SDWA destination selection: write selected byte/word, handle unused bits."""
  # dst_unused: 0=PAD(zero), 1=SEXT, 2=PRESERVE
  # dst_sel: 0-3=BYTE, 4=WORD_0, 5=WORD_1, 6=DWORD
  is_byte = dst_sel < _c(4)
  is_word = (dst_sel >= _c(4)) & (dst_sel < _c(6))
  shift = is_byte.where(dst_sel * _c(8), (dst_sel - _c(4)) * _c(16))
  mask = is_byte.where(_c(0xFF), is_word.where(_c(0xFFFF), _c(0xFFFFFFFF)))
  placed = (val & mask) << shift
  preserve_mask = (mask << shift) ^ _c(0xFFFFFFFF)
  preserved = (old & preserve_mask) | placed
  # For PAD and SEXT, unused bits are zero (PAD) or sign-extended (SEXT). For DWORD, just return val.
  return dst_sel.eq(_c(6)).where(val, dst_unused.eq(_c(2)).where(preserved, placed))

def _dpp_quad_sel(quad_lane: UOp, sels: tuple[int, int, int, int]) -> UOp:
  sel = _c(sels[0], dtypes.int)
  for i, src in enumerate(sels[1:], start=1): sel = quad_lane.eq(_c(i, dtypes.int)).where(_c(src, dtypes.int), sel)
  return sel

def _dpp16_ctrl(lane: UOp, dpp: int, row_mask: int, bank_mask: int, wave_size: int) -> tuple[UOp, UOp, UOp]:
  """Return (src_lane, row/bank enabled, in-bounds) for a DPP16 swizzle."""
  lane_i = lane.cast(dtypes.int)
  row_base, lane_in_row = lane_i & _c(~15, dtypes.int), lane_i & _c(15, dtypes.int)
  row = lane_i // _c(16, dtypes.int)
  bank = lane_in_row >> _c(2, dtypes.int)
  enabled = (((_c(row_mask) >> row.cast(dtypes.uint32)) & _c(1)).ne(_c(0)) & (((_c(bank_mask) >> bank.cast(dtypes.uint32)) & _c(1)).ne(_c(0))))
  op, arg = decode_dpp16(dpp)
  src_lane, valid = lane_i, UOp.const(True)

  if op == 'quad_perm':
    assert isinstance(arg, tuple)
    src_lane = (lane_i & _c(~3, dtypes.int)) + _dpp_quad_sel(lane_i & _c(3, dtypes.int), arg)
  else:
    assert isinstance(arg, int)
    if op == 'row_shl': src_lane, valid = row_base + lane_in_row + _c(arg, dtypes.int), lane_in_row <= _c(15 - arg, dtypes.int)
    elif op == 'row_shr': src_lane, valid = row_base + lane_in_row - _c(arg, dtypes.int), lane_in_row >= _c(arg, dtypes.int)
    elif op == 'row_ror': src_lane = row_base + ((lane_in_row - _c(arg, dtypes.int)) & _c(15, dtypes.int))
    elif op == 'row_mirror': src_lane = row_base + (_c(15, dtypes.int) - lane_in_row)
    elif op == 'row_half_mirror': src_lane = row_base + ((lane_in_row & _c(8, dtypes.int)) | (_c(7, dtypes.int) - (lane_in_row & _c(7, dtypes.int))))
    elif op == 'row_bcast': src_lane = row_base
    elif op == 'wave_shl': src_lane, valid = lane_i + _c(arg, dtypes.int), lane_i < _c(wave_size - arg, dtypes.int)
    elif op == 'wave_rol': src_lane = (lane_i + _c(arg, dtypes.int)) % _c(wave_size, dtypes.int)
    elif op == 'wave_shr': src_lane, valid = lane_i - _c(arg, dtypes.int), lane_i >= _c(arg, dtypes.int)
    elif op == 'wave_ror': src_lane = (lane_i - _c(arg, dtypes.int)) % _c(wave_size, dtypes.int)
    else: raise NotImplementedError(f"DPP16 control {dpp:#x} ({op}:{arg}) not implemented in emulator")
  return src_lane, enabled, valid

def _load_dpp16_src0(ctx: _Ctx, inst, lane: UOp, fallback: UOp) -> UOp:
  """Load a DPP16-swizzled src0 value from vsrc0."""
  src_lane, enabled, valid = _dpp16_ctrl(lane, _iattr(inst, 'dpp'), _iattr(inst, 'row_mask', 0xf), _iattr(inst, 'bank_mask', 0xf), ctx.wave_size)
  safe_src_lane = (enabled & valid).where(src_lane, _c(0, dtypes.int))
  swizzled = ctx.rvgpr(_field_off(inst, 'vsrc0') - 256, safe_src_lane, ctx._fext('v', 'vsrc0', 0))
  invalid = _c(0, fallback.dtype) if _iattr(inst, 'bc') else fallback
  return enabled.where(valid.where(swizzled, invalid), fallback)

def _compile_sdwa(inst: irc.VOP1_SDWA | irc.VOP2_SDWA | irc.VOP2_SDWA_SDST | irc.VOPC_SDWA_SDST, ctx: _Ctx) -> UOp:
  """Compile CDNA SDWA (Sub-Dword Access) VOP1/VOP2/VOPC instructions."""
  is_vopc = isinstance(inst, irc.VOPC_SDWA_SDST)
  exec_mask = ctx.rexec()
  if isinstance(inst, (irc.VOP2_SDWA_SDST, irc.VOPC_SDWA_SDST)) and _iattr(inst, 'sd'):
    sdst_off, sdst_field = _field_off(inst, 'sdst'), 'sdst'
  else:
    sdst_off, sdst_field = VCC_LO.offset, None
  src0_sel, src0_sext = _c(_field_int(inst, 'src0_sel')), _c(_field_int(inst, 'src0_sext'))
  vsrc0_idx = _field_off(inst, 'vsrc0') - 256
  pcode = get_pcode(inst.op)
  if isinstance(inst, (irc.VOP2_SDWA, irc.VOP2_SDWA_SDST, irc.VOPC_SDWA_SDST)):
    src1_sel, src1_sext = _c(_field_int(inst, 'src1_sel')), _c(_field_int(inst, 'src1_sext'))
    vsrc1_idx = _field_off(inst, 'vsrc1') - 256

  def _read_sdwa_src(fname: str, idx: int, is_scalar: int, lane: UOp) -> UOp:
    if not is_scalar: return ctx.rvgpr(idx, lane, ctx._fext('v', fname, 0))
    if idx < 128 or idx == SCC.offset:
      return ctx.rsgpr(idx, functools.partial(_ext_sdwa_sgpr, fname, ctx.wave_size))
    return ctx.imm(dtypes.uint32, functools.partial(_ext_sdwa_imm, fname))

  if is_vopc:
    def get_cmp_bit(lane: UOp) -> UOp:
      lc = lane.cast(dtypes.int)
      s0 = _sdwa_select(_read_sdwa_src('vsrc0', vsrc0_idx, inst.s0, lc), src0_sel, src0_sext)
      s1 = _sdwa_select(_read_sdwa_src('vsrc1', vsrc1_idx, inst.s1, lc), src1_sel, src1_sext)
      for dest, val in parse_pcode(pcode, {'S0': s0, 'S1': s1, 'laneId': lc})[1]:
        if '[laneId]' in dest and ('D0' in dest or 'EXEC' in dest): return val.cast(dtypes.uint32)
      return _c(0)
    return UOp.sink(*ctx.wmask(sdst_off, ctx.unroll_lanes(get_cmp_bit, exec_mask), sdst_field))

  lane = ctx.range()
  vdst_reg = _field_off(inst, 'vdst') - 256
  vdst_ext = ctx._fext('v', 'vdst', 0)
  s0 = _sdwa_select(_read_sdwa_src('vsrc0', vsrc0_idx, inst.s0, lane), src0_sel, src0_sext)
  if isinstance(inst, (irc.VOP2_SDWA, irc.VOP2_SDWA_SDST)):
    s1 = _sdwa_select(_read_sdwa_src('vsrc1', vsrc1_idx, inst.s1, lane), src1_sel, src1_sext)
    srcs:dict[str, UOp | int] = {'S0': s0, 'S1': s1, 'D0': ctx.rvgpr(vdst_reg, lane, vdst_ext)}
  else:
    srcs = {'S0': s0}
  has_dst_sel = hasattr(type(inst), 'dst_sel')
  if has_dst_sel:
    dst_sel, dst_unused = _c(_field_int(inst, 'dst_sel')), _c(_field_int(inst, 'dst_unused'))
  srcs.update(ctx.base_srcs(exec_mask, lane), VCC=ctx.rmask(VCC_LO.offset), VDST=_c(vdst_reg))
  _, assigns = parse_pcode(pcode, srcs)
  stores, vcc_val = [], None
  for dest, val in assigns:
    if 'D0' in dest and '[laneId]' in dest: vcc_val = val
    elif dest.startswith('D0'):
      result = _val_to_u32(val)
      if has_dst_sel: result = _sdwa_write(ctx.rvgpr(vdst_reg, lane, vdst_ext), result, dst_sel, dst_unused)
      stores.append(ctx.wvgpr(vdst_reg, lane, result, exec_mask, ext=vdst_ext))
    elif dest.startswith('VCC'): vcc_val = val
  if vcc_val is not None:
    mask = ctx.unroll_lanes(lambda l: (_to_u32(vcc_val.substitute({lane:l})) & _c(1)).cast(dtypes.uint32), exec_mask)
    return UOp.sink(*ctx.wmask(sdst_off, mask, sdst_field), UOp.sink(*stores).end(lane))
  return UOp.sink(UOp.sink(*stores).end(lane)) if stores else UOp.sink()

def _load_vsrc0(ctx: _Ctx, inst: ir3.VOP1 | ir3.VOP1_SDST | ir3.VOP1_DPP16 | ir3.VOP2 | ir3.VOP2_DPP16 |
                ir4.VOP1 | ir4.VOP1_SDST | ir4.VOP1_DPP16 | ir4.VOP2 | ir4.VOP2_DPP16 |
                irc.VOP1 | irc.VOP1_DPP16 | irc.VOP2 | irc.VOP2_DPP16,
                lane: UOp, bits: dict, is_f64: bool, is_float: bool, fallback: UOp) -> tuple[UOp, int | None]:
  """Load VOP src0: DPP16 swizzle (with abs/neg mods for floats), 16-bit VGPR hi-half, or plain operand."""
  if hasattr(type(inst), 'dpp') and hasattr(type(inst), 'vsrc0'):
    s0 = _load_dpp16_src0(ctx, inst, lane, fallback)
    if is_float: s0 = _apply_src_mods(s0, 0, 1 if _iattr(inst, 'src0_abs') else 0, 1 if _iattr(inst, 'src0_neg') else 0, bits['s0'])
    return s0, None
  s0 = ctx.rsrc('src0', lane, bits['s0'], is_f64, hi16_vop=not isinstance(inst, (irc.VOP1, irc.VOP2)))
  src0_off = _field_off(inst, 'src0')
  return s0, (src0_off - 256 if src0_off >= 256 else None)

def _compile_vop12(inst: ir3.VOP1 | ir3.VOP1_SDST | ir3.VOP1_DPP16 | ir3.VOP2 | ir3.VOP2_DPP16 |
                   ir4.VOP1 | ir4.VOP1_SDST | ir4.VOP1_DPP16 | ir4.VOP2 | ir4.VOP2_DPP16 |
                   irc.VOP1 | irc.VOP1_DPP16 | irc.VOP2 | irc.VOP2_DPP16, ctx: _Ctx) -> UOp:
  op_name = _op_name(inst)
  if op_name in ('V_READFIRSTLANE_B32_E32', 'V_PERMLANE64_B32_E32'): return ctx.compile_lane_pcode(inst.op, inst)
  if 'ACCVGPR_MOV' in op_name:
    lane, exec_mask = ctx.range(), ctx.rexec()
    vdst_reg, acc_src0 = _field_off(inst, 'vdst') - 256, _field_off(inst, 'src0') - 256
    val = ctx.raccvgpr(acc_src0, lane, ctx._fext('a', 'src0', 0))
    return UOp.sink(ctx.waccvgpr(vdst_reg, lane, val, exec_mask, ext=ctx._fext('a', 'vdst', 0)).end(lane))
  lane, exec_mask, bits = ctx.range(), ctx.rexec(), inst.canonical_op_bits
  is_f64 = 'F64' in op_name and 'B64' not in op_name
  is_float = any(x in op_name for x in ('F16', 'F32', 'F64'))
  is_dpp16 = hasattr(type(inst), 'dpp') and hasattr(type(inst), 'vsrc0')
  vdst_off = _field_off(inst, 'vdst') - 256
  write_hi_half = bits['d'] == 16 and not isinstance(inst, (irc.VOP1, irc.VOP2)) and vdst_off >= 128
  vdst_reg, vdst_hi_shift = (vdst_off - 128, 128) if write_hi_half else (vdst_off, 0)
  vdst_ext0 = ctx._fext('v', 'vdst', 0, hi16_shift=vdst_hi_shift)
  if isinstance(inst, (ir3.VOP1, ir4.VOP1, irc.VOP1)):
    d0 = _cond_hi16(write_hi_half, ctx.rvgpr(vdst_reg, lane, vdst_ext0))
    s0, src0_vreg = _load_vsrc0(ctx, inst, lane, bits, is_f64, is_float, d0)
    srcs: dict[str, UOp | int] = {'S0': s0, 'D0': d0, 'OPSEL': _c(0)}
  else:
    vsrc1_off = _field_off(inst, 'vsrc1') - 256
    vsrc1_hi = bits['s0'] == 16 and not isinstance(inst, irc.VOP2) and vsrc1_off >= 128
    vsrc1_reg, vsrc1_sh = (vsrc1_off - 128, 128) if vsrc1_hi else (vsrc1_off, 0)
    vsrc1_ext0 = ctx._fext('v', 'vsrc1', 0, hi16_shift=vsrc1_sh)
    if bits['s1'] == 64:
      s1 = _u64(ctx.rvgpr(vsrc1_reg, lane, vsrc1_ext0), ctx.rvgpr(vsrc1_reg + 1, lane, ctx._fext('v', 'vsrc1', 1)))
      d0 = _u64(ctx.rvgpr(vdst_reg, lane, vdst_ext0), ctx.rvgpr(vdst_reg + 1, lane, ctx._fext('v', 'vdst', 1)))
    else:
      s1 = _cond_hi16(vsrc1_hi, ctx.rvgpr(vsrc1_reg, lane, vsrc1_ext0))
      d0 = _cond_hi16(write_hi_half, ctx.rvgpr(vdst_reg, lane, vdst_ext0))
    s0, src0_vreg = _load_vsrc0(ctx, inst, lane, bits, is_f64, is_float, d0)
    if is_dpp16 and is_float:
      s1 = _apply_src_mods(s1, 0, 1 if _iattr(inst, 'src1_abs') else 0, 1 if _iattr(inst, 'src1_neg') else 0, bits['s1'])
    srcs = {'S0': s0, 'S1': s1, 'D0': d0}
    if 'V_FMAA' in op_name or 'V_FMAM' in op_name:
      lit = ctx.optional_imm_field('literal')
      assert lit is not None
      srcs['SIMM32'] = lit
  return ctx.compile_vop_pcode(inst.op, srcs, lane, vdst_reg, exec_mask, opsel_dst_hi=write_hi_half, src0_vreg=src0_vreg, vdst_hi_shift=vdst_hi_shift)

def _compile_vopc(inst: ir3.VOPC|ir3.VOPC_DPP16|ir3.VOP3|ir4.VOPC|ir4.VOPC_DPP16|ir4.VOP3|irc.VOPC|irc.VOP3, ctx: _Ctx,
                  opsel: int = 0, abs_bits: int = 0, neg_bits: int = 0) -> UOp:
  exec_mask, op_name, bits = ctx.rexec(), _op_name(inst), inst.canonical_op_bits
  is_cmpx, is_vopc = 'CMPX' in op_name, hasattr(inst, 'vsrc1')
  is_dpp16 = hasattr(type(inst), 'dpp') and hasattr(type(inst), 'vsrc0')
  if is_vopc:
    vsrc1_off = _field_off(inst, 'vsrc1') - 256
    vsrc1_hi = bits['s0'] == 16 and not isinstance(inst, irc.VOPC) and vsrc1_off >= 128
    vsrc1_reg, vsrc1_sh = (vsrc1_off - 128, 128) if vsrc1_hi else (vsrc1_off, 0)
  else:
    dst_off = _field_off(inst, 'vdst')

  is_float, is_f64, pcode = any(x in op_name for x in ('_F32', '_F64', '_F16')), '_F64' in op_name, get_pcode(inst.op)
  def get_cmp_bit(lane: UOp) -> UOp:
    lc = lane.cast(dtypes.int)
    s0 = _load_dpp16_src0(ctx, inst, lc, _c(0)) if is_dpp16 \
      else ctx.rsrc('src0', lc, bits['s0'], is_f64, hi16_vop=is_vopc and not isinstance(inst, irc.VOPC))
    if is_vopc:
      if bits['s1'] == 64:
        s1 = _u64(ctx.rvgpr(vsrc1_reg, lc, ctx._fext('v', 'vsrc1', 0)), ctx.rvgpr(vsrc1_reg + 1, lc, ctx._fext('v', 'vsrc1', 1)))
      else:
        s1 = _cond_hi16(vsrc1_hi, ctx.rvgpr(vsrc1_reg, lc, ctx._fext('v', 'vsrc1', 0, hi16_shift=vsrc1_sh)))
    else:
      s1 = ctx.rsrc('src1', lc, bits['s1'], is_f64)
    if bits['s0'] == 16 and opsel: s0, s1 = _apply_opsel(s0, 0, opsel), _apply_opsel(s1, 1, opsel)
    if is_float and is_dpp16:
      s0 = _apply_src_mods(s0, 0, 1 if _iattr(inst, 'src0_abs') else 0, 1 if _iattr(inst, 'src0_neg') else 0, bits['s0'])
      s1 = _apply_src_mods(s1, 0, 1 if _iattr(inst, 'src1_abs') else 0, 1 if _iattr(inst, 'src1_neg') else 0, bits['s1'])
    s0 = _apply_src_mods(s0, 0, abs_bits, neg_bits, bits['s0'])
    s1 = _apply_src_mods(s1, 1, abs_bits, neg_bits, bits['s1'])
    for dest, val in parse_pcode(pcode, {'S0': s0, 'S1': s1, 'laneId': lc, 'D0': _c(0, dtypes.uint64)})[1]:
      if '[laneId]' in dest and ('D0' in dest or 'EXEC' in dest): return val.cast(dtypes.uint32)
    return _c(0)

  new_result = ctx.unroll_lanes(get_cmp_bit, exec_mask)
  if is_cmpx: stores = ctx.wmask(EXEC_LO.offset, new_result)
  else: stores = ctx.wmask(dst_off, new_result, 'vdst') if not is_vopc else ctx.wmask(VCC_LO.offset, new_result)
  return UOp.sink(*stores)

def _compile_bitop3(inst, ctx: _Ctx, exec_mask: UOp, bits: dict, op_name: str) -> UOp:
  """BITOP3: 3-input truth table. abs/neg/omod encode the truth table, not source modifiers."""
  lane = ctx.range()
  vdst_reg = _field_off(inst, 'vdst') - 256
  ops = inst.canonical_operands
  src0 = ctx.rsrc('src0', lane, bits['s0'], 's0' in ops and ops['s0'][0] == Fmt.FMT_NUM_F64)
  src1 = ctx.rsrc('src1', lane, bits['s1'], 's1' in ops and ops['s1'][0] == Fmt.FMT_NUM_F64) if 's1' in ops else _c(0)
  src2 = ctx.rsrc('src2', lane, bits['s2'], 's2' in ops and ops['s2'][0] == Fmt.FMT_NUM_F64) if 's2' in ops else _c(0)
  ttbl = ((_iattr(inst, 'omod')) << 6) | ((_iattr(inst, 'abs')) << 3) | (_iattr(inst, 'neg'))
  is_16 = 'B16' in op_name
  dt, mask = (dtypes.uint16, 0xFFFF) if is_16 else (dtypes.uint32, 0xFFFFFFFF)
  s0, s1, s2 = src0.cast(dt), src1.cast(dt), src2.cast(dt)
  def bnot(v): return v ^ _c(mask, dt)
  result = _c(0, dt)
  for i in range(8):
    if not (ttbl & (1 << i)): continue
    result = result | ((s0 if i & 4 else bnot(s0)) & (s1 if i & 2 else bnot(s1)) & (s2 if i & 1 else bnot(s2)))
  return UOp.sink(ctx.wvgpr(vdst_reg, lane, result.cast(dtypes.uint32), exec_mask, ext=ctx._fext('v', 'vdst', 0)).end(lane))

def _compile_vop3(inst: ir3.VOP3 | ir4.VOP3 | irc.VOP3, ctx: _Ctx) -> UOp:
  exec_mask = ctx.rexec()
  bits = inst.canonical_op_bits
  opsel, op_name = _iattr(inst, 'opsel'), _op_name(inst)
  if op_name in ('V_READLANE_B32', 'V_READFIRSTLANE_B32', 'V_READFIRSTLANE_B32_E64', 'V_WRITELANE_B32'):
    return ctx.compile_lane_pcode(inst.op, inst)
  if 'PERMLANE16' in op_name or 'PERMLANEX16' in op_name:
    return ctx.compile_lane_pcode(inst.op, inst)
  if 'V_CMP' in op_name:
    return _compile_vopc(inst, ctx, opsel=opsel, abs_bits=_iattr(inst, 'abs'), neg_bits=_iattr(inst, 'neg'))
  if 'BITOP3' in op_name:
    return _compile_bitop3(inst, ctx, exec_mask, bits, op_name)

  abs_bits, neg_bits = _iattr(inst, 'abs'), _iattr(inst, 'neg')
  if 'V_S_' in op_name:
    vdst_sreg = _field_off(inst, 'vdst')
    src0 = _apply_src_mods(ctx.rsrc('src0', _c(0, dtypes.int), bits['s0']), 0, abs_bits, neg_bits, bits['s0'])
    srcs = {**ctx.base_srcs(exec_mask, _c(0, dtypes.int)), 'S0': src0}
    pcode_vars, _ = parse_pcode(get_pcode(inst.op), srcs)
    return UOp.sink(*ctx.wsgpr(vdst_sreg, _val_to_u32(pcode_vars['D0']), ctx._fext('s', 'vdst', 0)))

  lane = ctx.range()
  vdst_reg = _field_off(inst, 'vdst') - 256
  ops = inst.canonical_operands
  src0 = ctx.rsrc('src0', lane, bits['s0'], 's0' in ops and ops['s0'][0] == Fmt.FMT_NUM_F64)
  src1 = ctx.rsrc('src1', lane, bits['s1'], 's1' in ops and ops['s1'][0] == Fmt.FMT_NUM_F64) if 's1' in ops else _c(0)
  src2 = ctx.rsrc('src2', lane, bits['s2'], 's2' in ops and ops['s2'][0] == Fmt.FMT_NUM_F64) if 's2' in ops else _c(0)
  if bits['s0'] == 16:
    src0, src1, src2 = _apply_opsel(src0, 0, opsel), _apply_opsel(src1, 1, opsel), _apply_opsel(src2, 2, opsel)
  src0 = _apply_src_mods(src0, 0, abs_bits, neg_bits, bits['s0'])
  src1 = _apply_src_mods(src1, 1, abs_bits, neg_bits, bits['s1'])
  src2 = _apply_src_mods(src2, 2, abs_bits, neg_bits, bits['s2'])
  srcs = {'S0': src0, 'S1': src1, 'S2': src2, 'OPSEL': _c(opsel, dtypes.uint32)}
  if 'CNDMASK' in op_name: srcs['VCC'] = src2
  if 'FMAC' in op_name: srcs['D0'] = ctx.rvgpr(vdst_reg, lane, ctx._fext('v', 'vdst', 0))
  opsel_dst_hi = bool(opsel & 0b1000) and bits['d'] == 16
  return ctx.compile_vop_pcode(inst.op, srcs, lane, vdst_reg, exec_mask, opsel_dst_hi=opsel_dst_hi, clmp=_iattr(inst, 'clmp'))

def _compile_vinterp(inst: ir3.VINTERP | ir4.VINTERP, ctx: _Ctx) -> UOp:
  lane, exec_mask = ctx.range(), ctx.rexec()
  vdst_reg = _field_off(inst, 'vdst') - 256
  src0_off, src2_off = _field_off(inst, 'src0'), _field_off(inst, 'src2')
  srcs = {
    'SRC0': _c(src0_off - 256 if src0_off >= 256 else src0_off),
    'SRC2': _c(src2_off - 256 if src2_off >= 256 else src2_off),
    'S0': ctx.rsrc('src0', lane), 'S1': ctx.rsrc('src1', lane), 'S2': ctx.rsrc('src2', lane),
  }
  return ctx.compile_vop_pcode(inst.op, srcs, lane, vdst_reg, exec_mask)

def _compile_vop3sd(inst: ir3.VOP3SD | ir4.VOP3SD | irc.VOP3SD, ctx: _Ctx) -> UOp:
  exec_mask = ctx.rexec()
  bits, pcode, ops = inst.canonical_op_bits, get_pcode(inst.op), inst.canonical_operands
  vdst_reg, sdst_off = _field_off(inst, 'vdst') - 256, _field_off(inst, 'sdst')
  has_carry_in = 's2' in ops and ops['s2'][2] == OpType.OPR_SREG
  vcc_in_off, vcc_in_field = (_field_off(inst, 'src2'), 'src2') if has_carry_in else (sdst_off, 'sdst')

  def load_srcs(lane_uop):
    ret = {**ctx.base_srcs(exec_mask, lane_uop), 'VCC': ctx.rmask(vcc_in_off, vcc_in_field)}
    ret['S0'] = ctx.rsrc('src0', lane_uop, bits['s0'], ops['s0'][0] == Fmt.FMT_NUM_F64)
    ret['S1'] = ctx.rsrc('src1', lane_uop, bits['s1'], ops['s1'][0] == Fmt.FMT_NUM_F64)
    if 's2' in ops: ret['S2'] = ctx.rsrc('src2', lane_uop, bits['s2'], ops['s2'][0] == Fmt.FMT_NUM_F64)
    return ret

  lane = ctx.range()
  srcs = load_srcs(lane)
  _, assigns = parse_pcode(pcode, srcs)
  has_per_lane_vcc = any('[laneId]' in dest for dest, _ in assigns if dest.startswith('VCC') or dest.startswith('D0.u64'))
  clmp = _iattr(inst, 'clmp')
  if has_per_lane_vcc:
    def get_vcc_bit(lane_uop) -> UOp:
      vcc_bit = _c(0)
      for dest, val in parse_pcode(pcode, load_srcs(lane_uop))[1]:
        if dest.startswith('VCC') or (dest.startswith('D0.u64') and '[laneId]' in dest): vcc_bit = val.cast(dtypes.uint32)
      return vcc_bit
    final_vcc = ctx.unroll_lanes(get_vcc_bit, exec_mask)
    lane3 = ctx.range()
    d0_val, vcc_per_lane = None, None
    for dest, val in parse_pcode(pcode, load_srcs(lane3))[1]:
      if dest.startswith('D0') and '[laneId]' not in dest: d0_val = val
      if dest.startswith('VCC') or (dest.startswith('D0.u64') and '[laneId]' in dest): vcc_per_lane = val
    vgpr_stores = []
    if d0_val is not None:
      if clmp and vcc_per_lane is not None:
        sat_val = _c(0) if 'SUB' in inst.op.name else _c(0xFFFFFFFF)
        d0_val = vcc_per_lane.cast(dtypes.bool).where(sat_val, d0_val.cast(dtypes.uint32))
      if d0_val.dtype in (dtypes.uint64, dtypes.int64, dtypes.float64):
        lo, hi = _split64(d0_val)
        vgpr_stores.extend([ctx.wvgpr(vdst_reg, lane3, lo, exec_mask, ext=ctx._fext('v', 'vdst', 0)),
                            ctx.wvgpr(vdst_reg + 1, lane3, hi, exec_mask, ext=ctx._fext('v', 'vdst', 1))])
      else:
        d0_u32 = d0_val.bitcast(dtypes.uint32) if d0_val.dtype in (dtypes.float32, dtypes.half) else d0_val.cast(dtypes.uint32)
        vgpr_stores.append(ctx.wvgpr(vdst_reg, lane3, d0_u32, exec_mask, ext=ctx._fext('v', 'vdst', 0)))
    return UOp.sink(*ctx.wmask(sdst_off, final_vcc, 'sdst'), UOp.group(*vgpr_stores).end(lane3))
  return ctx.compile_vop_pcode(inst.op, srcs, lane, vdst_reg, exec_mask, sdst_reg=sdst_off, sdst_field='sdst')

# MFMA shape -> (lanes per group, lane groups, output regs per lane)
_MFMA_SHAPES = {(16, 16): (16, 4, 4), (32, 32): (32, 2, 16), (4, 4): (4, 16, 4)}

def _compile_mfma(inst: irc.VOP3P|irc.VOP3PX2, ctx: _Ctx) -> UOp:
  """CDNA MFMA matrix multiply-accumulate."""
  op_name, exec_mask = _op_name(inst), ctx.rexec()
  vdst_reg = _field_off(inst, 'vdst') - 256
  src0_off, src1_off, src2_off = _field_off(inst, 'src0'), _field_off(inst, 'src1'), _field_off(inst, 'src2')
  use_acc = bool(_iattr(inst, 'acc_cd'))

  scaled = isinstance(inst, irc.VOP3PX2)
  if scaled:
    assert isinstance(inst, irc.VOP3PX2)
    if int(inst.cbsz) > 1 or int(inst.blgp) > 1: raise RuntimeError(f"unsupported scaled MFMA formats cbsz={inst.cbsz} blgp={inst.blgp}")
    scale0_sel, scale1_sel = _iattr(inst, 'opsel') & 3, _iattr(inst, 'opsel_hi') & 3
    def _scale_exp(fname: str, sel: int, lane: UOp) -> UOp:
      byte = (ctx.rsrc(fname, lane, 32) >> _c(sel * 8, dtypes.uint32)) & _c(0xFF, dtypes.uint32)
      return byte.cast(dtypes.int32) - _c(127, dtypes.int32)
    def scale_factor(lane: UOp) -> UOp:
      return UOp.exp2((_scale_exp('scale_src0', scale0_sel, lane) + _scale_exp('scale_src1', scale1_sel, lane)).cast(dtypes.float32))

  if (m := re.search(r'(\d+)X(\d+)X(\d+)', op_name)) is None: raise ValueError(f"could not parse MFMA dimensions from {op_name}")
  M, N, K = int(m.group(1)), int(m.group(2)), int(m.group(3))
  if (M, N) not in _MFMA_SHAPES: raise RuntimeError(f"unsupported MFMA shape {M}x{N}x{K}")
  grp_size, n_grps, out_per_lane = _MFMA_SHAPES[(M, N)]

  src_type = op_name.rsplit('_', 1)[-1]
  is_bf16, is_fp8 = 'BF16' in op_name, 'FP8' in op_name or 'F8' in op_name
  is_i8, is_f32_src = 'I8' in op_name, src_type == 'F32'
  is_int_out = 'I32' in op_name.split('_')[2]
  vpg = 4 if is_i8 else 1 if is_f32_src else 4 if is_fp8 else 2
  acc_dt = dtypes.int32 if is_int_out else dtypes.float32

  if 'F8F6F4' in op_name:
    assert isinstance(inst, (irc.VOP3P_MFMA, irc.VOP3PX2))
    a_fmt, b_fmt = {0: "fp8", 1: "bf8"}.get(int(inst.cbsz), "fp8"), {0: "fp8", 1: "bf8"}.get(int(inst.blgp), "fp8")
  elif is_fp8:
    a_fmt, b_fmt = ("bf8" if sfx == "BF8" else "fp8" for sfx in op_name.rsplit('_', 2)[-2:])
  else: a_fmt = b_fmt = "fp8"

  k_per_grp = K if M == 4 else K // n_grps
  n_a_elems = n_grps * M * K if M == 4 else M * K
  n_b_elems = n_grps * N * K if M == 4 else N * K
  tmp = UOp.placeholder((n_a_elems + n_b_elems,), dtypes.uint32, slot=0, addrspace=AddrSpace.LOCAL)

  def cvt_elem(raw: UOp, sub_idx: int, fp8_fmt: str) -> UOp:
    if is_i8:
      byte = (raw >> _c(sub_idx * 8)) & _c(0xFF, dtypes.uint32)
      return (byte.cast(dtypes.int32) ^ _c(0x80, dtypes.int32)) - _c(0x80, dtypes.int32)
    if is_f32_src: return raw
    if is_fp8: return _FUNCS[f"{fp8_fmt}_to_f32"](raw >> _c(sub_idx * 8, dtypes.uint32)).bitcast(dtypes.uint32)
    h = (raw >> _c(sub_idx * 16)) & _c(0xFFFF)
    if is_bf16: return h << _c(16)
    return _FUNCS['f16_to_f32'](h).bitcast(dtypes.uint32)

  def mn_idx(lane: UOp) -> UOp:
    if M == 32: return ((lane // _c(16, dtypes.int)) % _c(2, dtypes.int)) * _c(16, dtypes.int) + lane % _c(16, dtypes.int)
    return lane % _c(grp_size, dtypes.int)
  def grp_idx(lane: UOp) -> UOp: return lane // _c(grp_size, dtypes.int)

  read_lane = ctx.range()
  mn, grp = mn_idx(read_lane), grp_idx(read_lane)
  def mat_idx(base: int, dim: int, kl: int) -> UOp:
    if M == 4: return _c(base + kl, dtypes.int) + grp * _c(dim * K, dtypes.int) + mn * _c(K, dtypes.int)
    return _c(base + kl, dtypes.int) + mn * _c(K, dtypes.int) + grp * _c(k_per_grp, dtypes.int)

  read_stores = []
  for kl in range(k_per_grp):
    reg_idx, sub_idx = kl // vpg, kl % vpg
    for fname, off, fmt, base, dim in (('src0', src0_off, a_fmt, 0, M), ('src1', src1_off, b_fmt, n_a_elems, N)):
      raw = ctx.rvgpr(off - 256 + reg_idx, read_lane, ctx._fext('v', fname, reg_idx)) if off >= 256 else ctx.rsrc(fname, _c(0, dtypes.int), 32)
      read_stores.append(tmp.index(mat_idx(base, dim, kl)).store(cvt_elem(raw, sub_idx, fmt)))
  read_phase = UOp.group(*read_stores).end(read_lane)

  src2_is_vgpr = src2_off >= 256
  acc_file = 'a' if use_acc else 'v'
  acc_reader, acc_writer = (ctx.raccvgpr, ctx.waccvgpr) if use_acc else (ctx.rvgpr, ctx.wvgpr)
  if not src2_is_vgpr:
    acc_scalar = ctx.rsrc('src2', None, 32)
    acc_scalar = acc_scalar.cast(dtypes.int32) if is_int_out else acc_scalar.bitcast(dtypes.float32)
  tmp2 = tmp.after(read_phase)

  def _dot_accum(acc: UOp, a_row: UOp, b_row: UOp, lane: UOp) -> UOp:
    def prod(k: int) -> UOp:
      return tmp2.index(a_row + _c(k, dtypes.int)).bitcast(acc_dt) * tmp2.index(b_row + _c(k, dtypes.int)).bitcast(acc_dt)
    if not scaled:
      for k in range(K): acc = acc + prod(k)
      return acc
    dot = prod(0)
    for k in range(1, K): dot = dot + prod(k)
    return acc + dot * scale_factor(lane)

  compute_lane = ctx.range()
  c_mn, c_grp = mn_idx(compute_lane), grp_idx(compute_lane)
  b_off = _c(n_a_elems, dtypes.int)
  def out_ab(out_reg: int) -> tuple[UOp, UOp]:
    if M == 32:
      m_base = c_grp * _c(16, dtypes.int) + _c(out_reg, dtypes.int)
      return m_base * _c(K, dtypes.int), b_off + c_mn * _c(K, dtypes.int)
    if M == 4:
      a_base = c_grp * _c(M * K, dtypes.int) + _c(out_reg * K, dtypes.int)
      return a_base, b_off + (c_grp * _c(N, dtypes.int) + c_mn) * _c(K, dtypes.int)
    m_base = c_grp * _c(out_per_lane, dtypes.int) + _c(out_reg, dtypes.int)
    return m_base * _c(K, dtypes.int), b_off + c_mn * _c(K, dtypes.int)

  compute_stores = []
  for out_reg in range(out_per_lane):
    if src2_is_vgpr:
      acc_in = acc_reader(src2_off - 256 + out_reg, compute_lane, ctx._fext(acc_file, 'src2', out_reg))
      acc_in = acc_in.cast(dtypes.int32) if is_int_out else acc_in.bitcast(dtypes.float32)
    else:
      acc_in = acc_scalar
    a_base, b_base = out_ab(out_reg)
    acc = _dot_accum(acc_in, a_base, b_base, compute_lane)
    out_bits = acc.cast(dtypes.uint32) if is_int_out else acc.bitcast(dtypes.uint32)
    compute_stores.append(acc_writer(vdst_reg + out_reg, compute_lane, out_bits, exec_mask, ext=ctx._fext(acc_file, 'vdst', out_reg)))
  compute_phase = UOp.group(*compute_stores).end(compute_lane)
  return UOp.sink(read_phase, compute_phase)

def _compile_wmma(inst: ir3.VOP3P | ir4.VOP3P | irc.VOP3P, ctx: _Ctx) -> UOp:
  """RDNA3/4 WMMA: snapshot A/B/C before writing D = A@B + C, allowing source and destination registers to overlap."""
  op_name, exec_mask = _op_name(inst), ctx.rexec()
  vdst_reg = _field_off(inst, 'vdst') - 256
  src0_r, src1_r = _field_off(inst, 'src0') - 256, _field_off(inst, 'src1') - 256
  src2_off = _field_off(inst, 'src2')
  is_c_vgpr = src2_off >= 256
  src2_r = src2_off - 256 if is_c_vgpr else 0
  output_type, _, *input_types = op_name.split("WMMA_", 1)[1].split("_")
  a_fmt, b_fmt = input_types if len(input_types) == 2 else input_types * 2
  is_rdna4 = isinstance(inst, ir4.VOP3P)
  sz = 8 if a_fmt in ('IU8', 'FP8', 'BF8') else 16
  n_per_vgpr = 32 // sz
  out_dt = dtypes.int32 if output_type == "I32" else dtypes.float32

  def gval(src: int, fname: str, lane: UOp, vgpr_i: int, ridx: int, *, fmt: str) -> UOp:
    v = ctx.rvgpr(src + vgpr_i, lane, ctx._fext('v', fname, vgpr_i))
    pkd = (v >> _c(ridx * sz)) & _c((1 << sz) - 1)
    if not fmt.startswith('IU'): return _FUNCS[f'{fmt.lower()}_to_f32'](pkd)
    return (pkd << _c(24, dtypes.uint)).bitcast(dtypes.int32) >> _c(24, dtypes.int32)

  def ab_map(i: UOp, k: int) -> tuple[UOp, int, int]:
    elem, lane = ((k & 3) | ((k >> 1) & 4), i + _c(((k >> 2) & 1) * 16, dtypes.int)) if is_rdna4 else (k, i)
    return lane, elem // n_per_vgpr, elem % n_per_vgpr

  def d_map(m: int, n: UOp) -> tuple[UOp, int]:
    lane_bit, vgpr = (m >> 3, m & 7) if is_rdna4 else (m & 1, m >> 1)
    return n + _c(lane_bit * 16, dtypes.int), vgpr

  if not is_c_vgpr:
    cbits = ctx.rsrc('src2', None, 32)
    cval_const = _FUNCS[f'{output_type.lower()}_to_f32'](cbits & _c(0xFFFF)) if output_type in ("F16", "BF16") else cbits.bitcast(out_dt)

  tmp = UOp.alloc((768,), dtypes.uint32, 0, AddrSpace.REG)
  idx16 = ctx.range(16)
  read_stores = []
  for k in range(16):
    read_stores.append(tmp.index(idx16 * 16 + k).store(gval(src0_r, 'src0', *ab_map(idx16, k), fmt=a_fmt).bitcast(dtypes.uint32)))
    read_stores.append(tmp.index(256 + idx16 * 16 + k).store(gval(src1_r, 'src1', *ab_map(idx16, k), fmt=b_fmt).bitcast(dtypes.uint32)))
    if is_c_vgpr:
      c_lane, c_vgpr = d_map(k, idx16)
      cval = gval(src2_r, 'src2', c_lane, *((c_vgpr // 2, c_vgpr % 2) if is_rdna4 else (c_vgpr, 0)), fmt=output_type) \
        if output_type in ("F16", "BF16") else ctx.rvgpr(src2_r + c_vgpr, c_lane, ctx._fext('v', 'src2', c_vgpr)).bitcast(out_dt)
    else:
      cval = cval_const
    read_stores.append(tmp.index(512 + k * 16 + idx16).store(cval.bitcast(dtypes.uint32)))
  read_phase = UOp.group(*read_stores).end(idx16)
  data = tmp.after(read_phase)

  n = ctx.range(16)
  mat_d = [sum(data.index(r*16+k).bitcast(out_dt) * data.index(256+n*16+k).bitcast(out_dt) for k in range(16))
           + data.index(512+r*16+n).bitcast(out_dt) for r in range(16)]

  def w_store(m: int, n: UOp, val: UOp, vgpr_off: int) -> UOp:
    lane_i, _ = d_map(m, n)
    return ctx.wvgpr(vdst_reg + vgpr_off, lane_i, val, exec_mask, ext=ctx._fext('v', 'vdst', vgpr_off))
  if output_type in ("F16", "BF16"):
    def to_bits(v: UOp) -> UOp:
      return ((v.bitcast(dtypes.uint32) >> _c(16, dtypes.uint32)) & _c(0xFFFF)) if output_type == "BF16" \
        else v.cast(dtypes.half).bitcast(dtypes.uint16).cast(dtypes.uint32)
    if is_rdna4:
      stores = [w_store(m, n, to_bits(mat_d[m]) | (to_bits(mat_d[m+1]) << _c(16, dtypes.uint32)), d_map(m, n)[1] // 2) for m in range(0, 16, 2)]
    else:
      stores = [w_store(m, n, to_bits(mat_d[m]), d_map(m, n)[1]) for m in range(16)]
  else:
    stores = [w_store(m, n, mat_d[m].bitcast(dtypes.uint32), d_map(m, n)[1]) for m in range(16)]
  return UOp.sink(UOp.group(*stores).end(n))

def _compile_vop3p(inst: ir3.VOP3P | ir4.VOP3P | irc.VOP3P | irc.VOP3PX2, ctx: _Ctx) -> UOp:
  op_name = _op_name(inst)
  if 'WMMA' in op_name:
    assert not isinstance(inst, irc.VOP3PX2)
    return _compile_wmma(inst, ctx)
  if 'MFMA' in op_name and any(f'{s}X{s}X' in op_name for s in ('4', '16', '32')) and isinstance(inst, (irc.VOP3P, irc.VOP3PX2)):
    return _compile_mfma(inst, ctx)

  ops = inst.operands
  src0_is_acc = ops.get('src0', (None, None, None))[2] in (OpType.OPR_SRC_ACCVGPR, OpType.OPR_ACCVGPR)
  vdst_is_acc = ops.get('vdst', (None, None, None))[2] in (OpType.OPR_ACCVGPR,)
  if src0_is_acc or vdst_is_acc:
    lane, exec_mask = ctx.range(), ctx.rexec()
    vdst_reg, src0_off = _field_off(inst, 'vdst') - 256, _field_off(inst, 'src0')
    if not vdst_is_acc:
      val = ctx.raccvgpr(src0_off - 256, lane, ctx._fext('a', 'src0', 0))
      return UOp.sink(ctx.wvgpr(vdst_reg, lane, val, exec_mask, ext=ctx._fext('v', 'vdst', 0)).end(lane))
    elif not src0_is_acc:
      return UOp.sink(ctx.waccvgpr(vdst_reg, lane, ctx.rsrc('src0', lane, 32), exec_mask, ext=ctx._fext('a', 'vdst', 0)).end(lane))
    else:
      val = ctx.raccvgpr(src0_off - 256, lane, ctx._fext('a', 'src0', 0))
      return UOp.sink(ctx.waccvgpr(vdst_reg, lane, val, exec_mask, ext=ctx._fext('a', 'vdst', 0)).end(lane))

  lane, exec_mask = ctx.range(), ctx.rexec()
  vdst_reg = _field_off(inst, 'vdst') - 256
  is_pk_f32 = 'PK' in op_name and 'F32' in op_name and 'MOV' not in op_name
  is_pk_mov_b32 = 'PK_MOV_B32' in op_name
  do_cast = any(x in op_name for x in ('F16', 'F32', 'BF16')) and 'IU' not in op_name and not is_pk_f32
  opsel, opsel_hi = _iattr(inst, 'opsel'), _iattr(inst, 'opsel_hi', 3)
  opsel_hi2 = _iattr(inst, 'opsel_hi2', 1)
  neg, neg_hi = _iattr(inst, 'neg'), _iattr(inst, 'neg_hi')

  def _pk_sel(fname: str, sel: int) -> UOp:
    off = _field_off(inst, fname)
    if not sel: return ctx.rvgpr(off - 256, lane, ctx._fext('v', fname, 0)) if off >= 256 else ctx.rsrc(fname, lane, 16, do_cast=do_cast)
    if off >= 256: return ctx.rvgpr(off - 256 + 1, lane, ctx._fext('v', fname, 1))
    if off < 128: return ctx.rsgpr(off + 1, ctx._fext('s', fname, 1))
    return ctx.rsrc(fname, lane, 16, do_cast=do_cast)

  if is_pk_mov_b32:
    lo_val, hi_val = _pk_sel('src0', opsel & 1), _pk_sel('src1', opsel & 2)
    stores = [ctx.wvgpr(vdst_reg, lane, lo_val, exec_mask, ext=ctx._fext('v', 'vdst', 0)),
              ctx.wvgpr(vdst_reg + 1, lane, hi_val, exec_mask, ext=ctx._fext('v', 'vdst', 1))]
    return UOp.sink(UOp.group(*stores).end(lane))

  srcs: dict[str, UOp | int] = {}
  if is_pk_f32:
    hi_bits = (opsel_hi & 1, opsel_hi & 2, 1 if opsel_hi2 else 0)
    for i, (bit, fname) in enumerate(zip((1, 2, 4), ('src0', 'src1', 'src2'))):
      lo, hi = _pk_sel(fname, opsel & bit), _pk_sel(fname, hi_bits[i])
      if neg & bit: lo = lo ^ _c(0x80000000, dtypes.uint32)
      if neg_hi & bit: hi = hi ^ _c(0x80000000, dtypes.uint32)
      srcs[f'S{i}'] = _u64(lo, hi)
  elif 'FMA_MIX' in op_name or 'MAD_MIX' in op_name:
    src0, src1, src2 = (ctx.rsrc(fn, lane, 16, do_cast=do_cast) for fn in ('src0', 'src1', 'src2'))
    combined_opsel_hi = (opsel_hi & 0x3) | ((opsel_hi2 & 0x1) << 2)
    def apply_abs(v, bit, opsel_hi_bit, opsel_bit):
      if not (neg_hi & bit): return v
      if not (combined_opsel_hi & opsel_hi_bit): return v & _c(0x7FFFFFFF, dtypes.uint32)
      if opsel & opsel_bit: return v & _c(0x7FFF0000, dtypes.uint32)
      return v & _c(0xFFFF7FFF, dtypes.uint32)
    def apply_neg_mix(v, bit, opsel_hi_bit, opsel_bit):
      if not (neg & bit): return v
      if not (combined_opsel_hi & opsel_hi_bit): return v ^ _c(0x80000000, dtypes.uint32)
      if opsel & opsel_bit: return v ^ _c(0x80000000, dtypes.uint32)
      return v ^ _c(0x00008000, dtypes.uint32)
    srcs = {'S@0': apply_neg_mix(apply_abs(src0, 1, 1, 1), 1, 1, 1),
            'S@1': apply_neg_mix(apply_abs(src1, 2, 2, 2), 2, 2, 2),
            'S@2': apply_neg_mix(apply_abs(src2, 4, 4, 4), 4, 4, 4),
            'OPSEL_HI': _c(combined_opsel_hi, dtypes.uint32), 'OPSEL': _c(opsel, dtypes.uint32)}
  else:
    src0, src1, src2 = (ctx.rsrc(fn, lane, 16, do_cast=do_cast) for fn in ('src0', 'src1', 'src2'))
    def get_half_bits(val: UOp, use_hi: bool, apply_neg: bool = False) -> UOp:
      bits = ((val >> _c(16, dtypes.uint32)) if use_hi else val) & _c(0xFFFF)
      if apply_neg: bits = bits.cast(dtypes.uint16).bitcast(dtypes.half).neg().bitcast(dtypes.uint16).cast(dtypes.uint32)
      return bits
    def build_remapped_src(src: UOp, opsel_lo_bit: int, opsel_hi_bit: int, neg_lo_bit: int, neg_hi_bit: int) -> UOp:
      lo = get_half_bits(src, bool(opsel_lo_bit), bool(neg_lo_bit))
      hi = get_half_bits(src, bool(opsel_hi_bit), bool(neg_hi_bit))
      return lo | (hi << _c(16, dtypes.uint32))
    is_dot_iu = 'DOT' in op_name and 'IU' in op_name
    n0, n1, n2, nh0, nh1, nh2 = (0, 0, 0, 0, 0, 0) if is_dot_iu else (neg & 1, neg & 2, neg & 4, neg_hi & 1, neg_hi & 2, neg_hi & 4)
    srcs = {'S0': build_remapped_src(src0, opsel & 1, opsel_hi & 1, n0, nh0),
            'S1': build_remapped_src(src1, opsel & 2, opsel_hi & 2, n1, nh1),
            'S2': build_remapped_src(src2, opsel & 4, 1 if opsel_hi2 else 0, n2, nh2)}
    if is_dot_iu: srcs['NEG'] = _c(neg, dtypes.uint32)
  return ctx.compile_vop_pcode(inst.op, srcs, lane, vdst_reg, exec_mask)

def _compile_vopd(inst: ir3.VOPD | ir4.VOPD, ctx: _Ctx) -> UOp:
  exec_mask = ctx.rexec()
  vdstx_reg, vdsty_reg = _field_off(inst, 'vdstx') - 256, _field_off(inst, 'vdsty') - 256
  vsrcx1_reg, vsrcy1_reg = _field_off(inst, 'vsrcx1') - 256, _field_off(inst, 'vsrcy1') - 256
  literal = ctx.optional_imm_field('literal')

  lane = ctx.range()
  srcy0 = ctx.rsrc('srcy0', lane)
  srcy1 = ctx.rvgpr(vsrcy1_reg, lane, ctx._fext('v', 'vsrcy1', 0)) if inst.opy.name != 'V_DUAL_MOV_B32' else _c(0)
  d0y = ctx.rvgpr(vdsty_reg, lane, ctx._fext('v', 'vdsty', 0)) if inst.opy.name != 'V_DUAL_MOV_B32' else _c(0)
  srcx0 = ctx.rsrc('srcx0', lane)
  srcx1 = ctx.rvgpr(vsrcx1_reg, lane, ctx._fext('v', 'vsrcx1', 0)) if inst.opx.name != 'V_DUAL_MOV_B32' else _c(0)
  d0x = ctx.rvgpr(vdstx_reg, lane, ctx._fext('v', 'vdstx', 0)) if inst.opx.name != 'V_DUAL_MOV_B32' else _c(0)
  reads = UOp.group(srcx0, srcx1, d0x, srcy0, srcy1, d0y)
  all_stores = []
  for op, s0, s1, d0, vdst_reg, vdst_fn, label in [
      (inst.opx, srcx0, srcx1, d0x, vdstx_reg, 'vdstx', 'X'),
      (inst.opy, srcy0, srcy1, d0y, vdsty_reg, 'vdsty', 'Y')]:
    vop = VOPD_TO_VOP2.get(op)
    assert vop is not None, f"no VOP mapping for VOPD {label}: {op}"
    srcs: dict[str, UOp | int] = {'S0': s0, 'S1': s1, 'D0': d0}
    if vop in (ir3.VOP2Op.V_FMAAK_F32_E32, ir3.VOP2Op.V_FMAMK_F32_E32):
      assert literal is not None
      srcs['SIMM32'] = literal
    srcs.update(ctx.base_srcs(exec_mask, lane), VCC=ctx.rmask(VCC_LO.offset))
    for dest, val in parse_pcode(get_pcode(vop), srcs)[1]:
      if dest.startswith('D0'): all_stores.append(ctx.wvgpr(vdst_reg, lane, _val_to_u32(val), exec_mask, after=reads, ext=ctx._fext('v', vdst_fn, 0)))
  return UOp.sink(UOp.group(*all_stores).end(lane))

def _compile_mem_op(inst: ir3.DS|ir3.FLAT|ir3.GLOBAL|ir3.SCRATCH|ir4.DS|ir4.VFLAT|ir4.VGLOBAL|ir4.VSCRATCH
                    |irc.DS|irc.FLAT|irc.GLOBAL|irc.SCRATCH, ctx: _Ctx) -> UOp:
  """Unified memory operation compiler for DS, FLAT, GLOBAL, SCRATCH."""
  exec_mask, op_name = ctx.rexec(), _op_name(inst)
  pcode = get_pcode(inst.op)
  if isinstance(inst, (irc.GLOBAL, irc.FLAT, irc.SCRATCH, irc.DS, ir4.VFLAT, ir4.VSCRATCH)) and 'Calc' in pcode and 'Addr' in pcode:
    pcode = re.sub(r'addr\s*=\s*Calc\w+Addr\([^)]*\)\s*;?\n?', '', pcode).replace('MEM[addr', 'MEM[ADDR')

  is_lds = isinstance(inst, (ir3.DS, ir4.DS, irc.DS))
  is_scratch = isinstance(inst, (ir3.SCRATCH, ir4.VSCRATCH, irc.SCRATCH))
  use_acc = bool(_iattr(inst, 'acc'))
  data_file = 'a' if use_acc else 'v'
  mem = ctx.lds if is_lds else ctx.scratch if is_scratch else ctx.vmem
  addr_shift = _c(2, dtypes.uint32 if is_lds else dtypes.uint64)

  if is_lds: addr_field, data_field = 'addr', 'data0'
  elif isinstance(inst, (ir4.VGLOBAL, ir4.VSCRATCH, ir4.VFLAT)): addr_field, data_field = 'vaddr', 'vsrc'
  else: addr_field, data_field = 'addr', 'data'
  addr_reg = _field_off(inst, addr_field) - 256
  vdata_reg, vdst_reg = _field_off(inst, data_field) - 256, _field_off(inst, 'vdst') - 256
  if is_lds:
    offset0, offset1 = ctx.imm_field('offset0'), ctx.imm_field('offset1')
    offset, saddr_reg = (offset1 << _c(8)) | offset0, None
  else:
    offset0, offset1 = _c(0), _c(0)
    saddr_reg = None if isinstance(inst, (ir3.FLAT, ir4.VFLAT, irc.FLAT)) or not hasattr(type(inst), 'saddr') else _field_off(inst, 'saddr')
    offset = ctx.imm_field('ioffset' if hasattr(type(inst), 'ioffset') else 'offset', signed=True, dtype=dtypes.int32)
  use_saddr = saddr_reg is not None and saddr_reg < 124

  data_bits_mem = inst.canonical_op_bits.get('data', 32)
  is_atomic, glc = 'ATOMIC' in op_name, _iattr(inst, 'glc')
  data1_reg = _field_off(inst, 'data1') - 256 if is_lds else 0

  if is_lds and op_name == 'DS_SWIZZLE_B32':
    funcs = {'reverse_bits': lambda x: _bitreverse(x, 32) >> _c(27), 'count_ones': _countbits,
             'thread_in': lambda x: ctx.rvgpr(addr_reg, x & _c(ctx.wave_size - 1), ctx._fext('v', addr_field, 0)),
             'thread_valid': lambda x: _lane_active(exec_mask, x & _c(ctx.wave_size - 1))}
    result, _ = parse_pcode(pcode, {'offset0': offset0.cast(dtypes.uint8), 'offset1': offset1.cast(dtypes.uint8)}, funcs)
    values = [result[f'thread_out@{i}'] for i in range(ctx.wave_size)]
    reads = UOp(Ops.STACK, src=tuple(values))
    return UOp.sink(*(ctx.wvgpr(vdst_reg, _c(i), val, exec_mask, after=reads, ext=ctx._fext('v', 'vdst', 0)) for i, val in enumerate(values)))

  if is_lds and 'PERMUTE' in op_name:
    srcs = {'ADDR': _c(addr_reg), 'DATA0': _c(vdata_reg), 'VDST': _c(vdst_reg), 'OFFSET': offset,
            'EXEC': exec_mask.cast(dtypes.uint64), '_vgpr': _VGPRMap(ctx), '_wave_size': ctx.wave_size}
    _, assigns = parse_pcode(pcode, srcs)
    stores = [val[0].store(val[1].cast(dtypes.uint32)) for dest, val in assigns if dest.startswith('VGPR[')]
    return UOp.sink(*stores)

  def make_addr(lane: UOp) -> UOp:
    if is_lds:
      addr = ctx.rvgpr(addr_reg, lane, ctx._fext('v', addr_field, 0))
      if 'OFFSET' not in pcode: addr = addr + offset
      return addr
    offset64 = offset.cast(dtypes.uint64)
    if is_scratch:
      base = lane.cast(dtypes.uint64) * ctx.scratch_stride.cast(dtypes.uint64)
      addr_offset = ctx.rvgpr(addr_reg, lane, ctx._fext('v', addr_field, 0)).cast(dtypes.uint64) if _iattr(inst, 'sve') == 1 else _c(0, dtypes.uint64)
      saddr_contrib = ctx.rsgpr(saddr_reg, ctx._fext('s', 'saddr', 0)).cast(dtypes.uint64) \
        if use_saddr and saddr_reg is not None else _c(0, dtypes.uint64)
      return base + addr_offset + saddr_contrib + offset64
    if use_saddr and saddr_reg is not None:
      saddr_base = _u64(ctx.rsgpr(saddr_reg, ctx._fext('s', 'saddr', 0)), ctx.rsgpr(saddr_reg + 1, ctx._fext('s', 'saddr', 1)))
      return saddr_base + ctx.rvgpr(addr_reg, lane, ctx._fext('v', addr_field, 0)).cast(dtypes.uint64) + offset64
    vaddr_base = _u64(ctx.rvgpr(addr_reg, lane, ctx._fext('v', addr_field, 0)), ctx.rvgpr(addr_reg + 1, lane, ctx._fext('v', addr_field, 1)))
    return vaddr_base + offset64

  def wmem(addr: UOp, val: UOp, active: UOp, data_bits: int = 32, after: UOp | None = None) -> UOp:
    m = mem.after(after) if after is not None else mem
    if data_bits < 32:
      word_addr = addr >> addr_shift
      idx = m.index(word_addr.valid(active))
      byte_pos = addr.cast(dtypes.uint32) & _c(3)
      byte_shift = byte_pos * _c(8)
      size_mask = _c(0xFF if data_bits == 8 else 0xFFFF)
      mask = size_mask << byte_shift
      new_word = (idx & (mask ^ _c(0xFFFFFFFF))) | ((val.cast(dtypes.uint32) & size_mask) << byte_shift)
      return idx.store(active.where(new_word, idx))
    idx = m.index(addr >> addr_shift)
    return idx.store(active.where(val, idx.load()))

  def make_srcs(lane: UOp) -> dict:
    addr = make_addr(lane)
    _rvdata = ctx.raccvgpr if use_acc else ctx.rvgpr
    if is_lds:
      is_lds_load = op_name.startswith('DS_LOAD') or op_name.startswith('DS_READ')
      data: dict[str, UOp] = {}
      if not is_lds_load:
        if data_bits_mem <= 32:
          data = {'DATA': _rvdata(vdata_reg, lane, ctx._fext(data_file, data_field, 0))}
          if '2ADDR' in op_name or 'WRXCHG2' in op_name or 'CMPST' in op_name or '2' in op_name:
            data['DATA2'] = _rvdata(data1_reg, lane, ctx._fext(data_file, 'data1', 0))
        elif data_bits_mem == 64:
          data = {'DATA': _u64(_rvdata(vdata_reg, lane, ctx._fext(data_file, data_field, 0)),
                               _rvdata(vdata_reg + 1, lane, ctx._fext(data_file, data_field, 1)))}
          if '2' in op_name or 'CMPST' in op_name:
            data['DATA2'] = _u64(_rvdata(data1_reg, lane, ctx._fext(data_file, 'data1', 0)),
                                 _rvdata(data1_reg + 1, lane, ctx._fext(data_file, 'data1', 1)))
        else:
          data = {'DATA': _rvdata(vdata_reg, lane, ctx._fext(data_file, data_field, 0)),
                  **{f'DATA{i}': _rvdata(vdata_reg + i, lane, ctx._fext(data_file, data_field, i)) for i in range(1, data_bits_mem // 32)}}
      if 'D16' in op_name: data['RETURN_DATA'] = _rvdata(vdst_reg, lane, ctx._fext(data_file, 'vdst', 0))
      return {'ADDR': addr, 'ADDR_BASE': addr, 'OFFSET': offset, 'OFFSET0': offset0, 'OFFSET1': offset1, '_lds': mem, 'laneId': lane,
              'vgpr_a': ctx.rvgpr(addr_reg, lane, ctx._fext('v', addr_field, 0)), 'offset': offset, 'offset0': offset0, 'offset1': offset1,
              '_active': _lane_active(exec_mask, lane), **data}
    active = _lane_active(exec_mask, lane)
    ioffset64 = offset.cast(dtypes.int64).cast(dtypes.uint64)
    if use_saddr and saddr_reg is not None:
      saddr_base = _u64(ctx.rsgpr(saddr_reg, ctx._fext('s', 'saddr', 0)), ctx.rsgpr(saddr_reg + 1, ctx._fext('s', 'saddr', 1))) if not is_scratch \
        else ctx.rsgpr(saddr_reg, ctx._fext('s', 'saddr', 0)).cast(dtypes.uint64)
      vaddr_base = ctx.rvgpr(addr_reg, lane, ctx._fext('v', addr_field, 0)).cast(dtypes.uint64) + ioffset64 \
        if not is_scratch else _c(0, dtypes.uint64)
    else:
      saddr_base = _c(0, dtypes.uint64)
      vaddr_base = (_u64(ctx.rvgpr(addr_reg, lane, ctx._fext('v', addr_field, 0)), ctx.rvgpr(addr_reg + 1, lane, ctx._fext('v', addr_field, 1)))
                    + ioffset64) if not is_scratch else _c(0, dtypes.uint64)
    if is_atomic:
      atomic_data = _u64(ctx.rvgpr(vdata_reg, lane, ctx._fext('v', data_field, 0)), ctx.rvgpr(vdata_reg + 1, lane, ctx._fext('v', data_field, 1))) \
        if data_bits_mem == 64 else ctx.rvgpr(vdata_reg, lane, ctx._fext('v', data_field, 0))
      return {'ADDR': addr, 'DATA': atomic_data, '_vmem': mem, '_active': active, 'laneId': lane, 'v_addr': vaddr_base, 's_saddr': saddr_base}
    is_store = 'STORE' in op_name
    vdata = _rvdata(vdata_reg, lane, ctx._fext(data_file, data_field, 0)).cast(dtypes.uint64) if is_store \
      else _rvdata(vdst_reg, lane, ctx._fext(data_file, 'vdst', 0)) if 'D16' in op_name else _c(0, dtypes.uint32)
    if is_store and data_bits_mem >= 64:
      vdata = vdata | (_rvdata(vdata_reg + 1, lane, ctx._fext(data_file, data_field, 1)).cast(dtypes.uint64) << _c(32, dtypes.uint64))
    srcs = {'ADDR': addr, 'VDATA': vdata, '_vmem': mem, '_active': active,
            'laneId': lane, 'v_addr': vaddr_base, 's_saddr': saddr_base, 'SADDR': saddr_base, 'OFFSET': offset}
    for i in range(data_bits_mem // 32):
      srcs[f'VDATA{i}'] = _rvdata(vdata_reg + i, lane, ctx._fext(data_file, data_field, i)) if is_store else _c(0, dtypes.uint32)
    return srcs

  def make_stores(dest: str, val: UOp, lane: UOp, active: UOp, writes_return_data: bool, mem_after: UOp | None = None) -> list[UOp]:
    parts = dest.rsplit('.', 1)
    data_bits = int(parts[1][1:]) if len(parts) == 2 else 32
    if dest.startswith('MEM['):
      if is_lds or is_atomic:
        if data_bits < 32 and is_lds: return [wmem(val[0], val[1], active, data_bits, mem_after)]
        return _write_val(data_bits, val[1], lambda a, v, act, after=mem_after: wmem(a, v, act, 32, after), val[0], active, is_mem=True)
      m = (mem if is_scratch else mem.bitcast(dtypes.uint8))
      if mem_after is not None: m = m.after(mem_after)
      return _mem_store_bytes(m, val[0], val[1], active, data_bits)
    if dest.startswith('RETURN_DATA') and writes_return_data:
      write_gpr = ctx.waccvgpr if use_acc else ctx.wvgpr
      def _wdata(r: int, v: UOp, l: UOp, e: UOp) -> UOp:
        return write_gpr(r, l, v, e, ext=ctx._fext(data_file, 'vdst', r - vdst_reg))
      if (m := re.match(r'RETURN_DATA\[(\d+)\s*:\s*(\d+)\]', dest)):
        bit_width, dword_idx = int(m.group(1)) - int(m.group(2)) + 1, int(m.group(2)) // 32
        return _write_val(bit_width, val, _wdata, vdst_reg + dword_idx, lane, exec_mask)
      return _write_val(data_bits, val, _wdata, vdst_reg, lane, exec_mask)
    return []

  if is_lds:
    dummy_lane = ctx.range()
    _, assigns = parse_pcode(pcode, make_srcs(dummy_lane))
    mem_assigns = [d for d, _ in assigns if d.startswith('MEM[')]
    mem_addrs = set(m.group(1) if (m := re.match(r'MEM\[([^\]]+)\]', d)) else d for d in mem_assigns)
    use_separate_ranges = (len(mem_addrs) > 1 or '2ADDR' in op_name) and 'STOREXCHG' not in op_name
    if use_separate_ranges:
      store_assigns = [(i, d) for i, (d, _) in enumerate(assigns) if d.startswith('MEM[')]
      load_assigns = [(i, d) for i, (d, _) in enumerate(assigns) if d.startswith('RETURN_DATA')]
      ended: list[UOp] = []
      for i, dest in store_assigns:
        lane = ctx.range()
        active = _lane_active(exec_mask, lane)
        _, lane_assigns = parse_pcode(pcode, make_srcs(lane))
        ended.extend(s.end(lane) for s in make_stores(dest, lane_assigns[i][1], lane, active, True))
      if load_assigns:
        lane = ctx.range()
        active = _lane_active(exec_mask, lane)
        _, lane_assigns = parse_pcode(pcode, make_srcs(lane))
        load_stores: list[UOp] = []
        for i, dest in load_assigns:
          load_stores.extend(make_stores(dest, lane_assigns[i][1], lane, active, True))
        if load_stores: ended.append(UOp.group(*load_stores).end(lane))
      return UOp.sink(*ended)

  writes_return_data = '_RTN' in op_name or (is_lds and (op_name.startswith('DS_LOAD') or op_name.startswith('DS_READ'))) or bool(is_atomic and glc)
  lane = ctx.range()
  active = _lane_active(exec_mask, lane)
  pcode_vars, assigns = parse_pcode(pcode, make_srcs(lane))
  if is_lds and 'D16' in op_name and writes_return_data: assigns = [('RETURN_DATA.b32', pcode_vars['RETURN_DATA'])]
  ret_stores = [s for dest, val in assigns if dest.startswith('RETURN_DATA') for s in make_stores(dest, val, lane, active, writes_return_data)]
  mem_after = UOp.group(*ret_stores) if ret_stores else None
  mem_stores = [s for dest, val in assigns if not dest.startswith('RETURN_DATA')
                for s in make_stores(dest, val, lane, active, writes_return_data, mem_after)]
  stores = ret_stores + mem_stores

  if not is_lds and not is_atomic:
    _wdst = ctx.waccvgpr if use_acc else ctx.wvgpr
    for dword_idx, val in sorted(_collect_data_slices(assigns, 'VDATA', pcode_vars, op_name).items()):
      stores.append(_wdst(vdst_reg + dword_idx, lane, val, exec_mask, ext=ctx._fext(data_file, 'vdst', dword_idx)))

  return UOp.sink(UOp.group(*stores).end(lane))

def _compile_mubuf(inst: irc.MUBUF, ctx: _Ctx) -> UOp:
  """CDNA MUBUF: linear buffer address = base + soffset + (stride * index) + vgpr_offset + inst_offset"""
  exec_mask, op_name = ctx.rexec(), _op_name(inst)
  use_acc, is_store, is_lds = bool(_iattr(inst, 'acc')), 'STORE' in op_name, bool(_iattr(inst, 'lds'))
  data_file = 'a' if use_acc else 'v'
  n_dwords = 4 if 'X4' in op_name else 2 if 'X2' in op_name else 1

  vdata_reg, vaddr_reg = _field_off(inst, 'vdata') - 256, _field_off(inst, 'vaddr') - 256
  srsrc = _field_off(inst, 'srsrc')
  offset = ctx.imm_field('offset')
  offen, idxen = _field_int(inst, 'offen'), _field_int(inst, 'idxen')

  base = _u64(ctx.rsgpr(srsrc, ctx._fext('s', 'srsrc', 0)), ctx.rsgpr(srsrc + 1, ctx._fext('s', 'srsrc', 1))) & _c(0xFFFFFFFFFFFF, dtypes.uint64)
  num_records = ctx.rsgpr(srsrc + 2, ctx._fext('s', 'srsrc', 2))
  stride = (ctx.rsgpr(srsrc + 3, ctx._fext('s', 'srsrc', 3)) & _c(0x3FFF)).cast(dtypes.uint64)

  lane = ctx.range()
  active = _lane_active(exec_mask, lane)

  soff = ctx.rsrc('soffset', None, 32).cast(dtypes.uint64)
  index = ctx.rvgpr(vaddr_reg, lane, ctx._fext('v', 'vaddr', 0)).cast(dtypes.uint64) if idxen else _c(0, dtypes.uint64)
  voff_delta = 1 if idxen else 0
  voff = ctx.rvgpr(vaddr_reg + voff_delta, lane, ctx._fext('v', 'vaddr', voff_delta)).cast(dtypes.uint64) if offen else _c(0, dtypes.uint64)

  buffer_offset = (stride * index + voff + offset.cast(dtypes.uint64)).cast(dtypes.uint32)
  in_bounds = active & buffer_offset.__lt__(num_records)
  addr = in_bounds.where(base + soff + buffer_offset.cast(dtypes.uint64), _c(0, dtypes.uint64))
  mem = ctx.vmem

  stores: list[UOp] = []
  if is_lds and not is_store:
    lds_base = ctx.rsgpr(124) & _c(0x3FFFF)
    lds_addr = lds_base + lane.cast(dtypes.uint32) * _c(n_dwords * 4)
    for i in range(n_dwords):
      word_addr = (addr + _c(i * 4, dtypes.uint64)) >> _c(2, dtypes.uint64)
      val = in_bounds.where(mem.index(word_addr.cast(dtypes.int64)).load(), _c(0))
      lds_idx = (lds_addr + _c(i * 4)) >> _c(2)
      lds_slot = ctx.lds.index(lds_idx.valid(active))
      stores.append(lds_slot.store(active.where(val, lds_slot)))
  elif is_store:
    for i in range(n_dwords):
      word_addr = (addr + _c(i * 4, dtypes.uint64)) >> _c(2, dtypes.uint64)
      idx = mem.index(word_addr.cast(dtypes.int64).valid(in_bounds))
      val = (ctx.raccvgpr if use_acc else ctx.rvgpr)(vdata_reg + i, lane, ctx._fext(data_file, 'vdata', i))
      stores.append(idx.store(in_bounds.where(_to_u32(val), idx)))
  else:
    for i in range(n_dwords):
      word_addr = (addr + _c(i * 4, dtypes.uint64)) >> _c(2, dtypes.uint64)
      val = in_bounds.where(mem.index(word_addr.cast(dtypes.int64).valid(in_bounds)).load(), _c(0))
      stores.append((ctx.waccvgpr if use_acc else ctx.wvgpr)(vdata_reg + i, lane, val, exec_mask, ext=ctx._fext(data_file, 'vdata', i)))
  return UOp.sink(UOp.group(*stores).end(lane))

# Dispatch table: instruction type -> handler function. Classes are looked up by name across all three archs.
def _inst_kinds(*names: str) -> tuple[type, ...]:
  return tuple(getattr(m, n) for m in (ir3, ir4, irc) for n in names if hasattr(m, n))

_COMMON_HANDLERS: list[tuple[Callable[..., UOp], tuple[str, ...]]] = [
  (_compile_sopp, ('SOPP',)),
  (_compile_smem, ('SMEM',)),
  (_compile_sop, ('SOP1', 'SOP2', 'SOPC', 'SOPK')),
  (_compile_vop12, ('VOP1', 'VOP1_SDST', 'VOP1_DPP16', 'VOP2', 'VOP2_DPP16')),
  (_compile_vopc, ('VOPC', 'VOPC_DPP16')),
  (_compile_vop3, ('VOP3', 'VOP3_SDST')),
  (_compile_vinterp, ('VINTERP',)),
  (_compile_vop3sd, ('VOP3SD',)),
  (_compile_vop3p, ('VOP3P', 'VOP3PX2')),
  (_compile_vopd, ('VOPD',)),
  (_compile_sdwa, ('VOP1_SDWA', 'VOP2_SDWA', 'VOP2_SDWA_SDST', 'VOPC_SDWA_SDST')),
  (_compile_mem_op, ('DS', 'FLAT', 'GLOBAL', 'SCRATCH', 'VFLAT', 'VGLOBAL', 'VSCRATCH')),
]
_INST_HANDLERS: dict[type, Callable[..., UOp]] = {t: h for h, names in _COMMON_HANDLERS for t in _inst_kinds(*names)}
_INST_HANDLERS[irc.MUBUF] = _compile_mubuf  # CDNA only (rdna3 also has a MUBUF class, intentionally unhandled)

def _get_handler(inst: Inst) -> Callable[..., UOp]:
  # Look up handler by type, falling back to base classes for _LIT variants
  handler = _INST_HANDLERS.get(type(inst))
  if handler is not None: return handler
  for cls in type(inst).__mro__:
    if cls in _INST_HANDLERS: return _INST_HANDLERS[cls]
  raise RuntimeError(f"[emu] unimplemented instruction type: {type(inst).__name__} {_op_name(inst)}")

# ═══════════════════════════════════════════════════════════════════════════════
# PROGRAM DECODE AND COMPILATION
# ═══════════════════════════════════════════════════════════════════════════════

_BARRIER_OPS = {ir3.SOPPOp.S_BARRIER, irc.SOPPOp.S_BARRIER, ir4.SOPPOp.S_BARRIER_WAIT}
_BARRIER_SOP1_OPS = {ir4.SOP1Op.S_BARRIER_SIGNAL}

@uopfunc
def emu_loop_active(routes:UOp, active:UOp, header:UOp, waves:UOp):
  w = UOp.range(waves, 0, dtype=dtypes.int)
  return active[0].store(routes[w].load().eq(header).cast(dtypes.u32).reduce(w, arg=Ops.MAX).ne(0)).sink()

def _local_param_name(i:int, b:UOp) -> str | None:
  return f"r{i}" if 0 <= b.arg.slot < 768 else b.arg.name

def lower_body(sink:UOp) -> UOp:
  bufs = list(dict.fromkeys(u for u in sink.toposort() if u.op is Ops.PARAM))
  params = {b:UOp.param(i, b.dtype, b.shape, name=_local_param_name(i, b), addrspace=b.addrspace) for i,b in enumerate(bufs)}
  return sink.substitute(params, walk=True).call(*bufs)

_IMM_FIELDS = {'encoding', 'offset', 'ioffset', 'offset0', 'offset1', 'simm16', 'literal', 'dlc', 'slc', 'th', 'scope', 'cpol'}
_EXEC_SGPRS = {EXEC_LO.offset, EXEC_LO.offset + 1}
_VCC_SGPRS = {VCC_LO.offset, VCC_LO.offset + 1}

def _inst_cache_key(inst: Inst, arch: str, wave_size: int) -> tuple:
  """Canonical cache key for instruction body sharing: captures opcode, static modifiers, operand kinds, and register aliasing."""
  op_name = _op_name(inst)
  is_sop = isinstance(inst, (ir3.SOP1, ir3.SOP2, ir3.SOPC, ir3.SOPK, ir4.SOP1, ir4.SOP2, ir4.SOPC, ir4.SOPK,
                             irc.SOP1, irc.SOP2, irc.SOPC, irc.SOPK))
  special = {124}
  if is_sop:
    special.add(SCC.offset)
    if 'EXEC' in op_name: special |= _EXEC_SGPRS
  else:
    special |= _EXEC_SGPRS
    if isinstance(inst, (ir3.VOP2, ir3.VOPC, ir3.VOPD, ir3.SOPP, ir4.VOP2, ir4.VOPC, ir4.VOPD, ir4.SOPP,
                         irc.VOP2, irc.VOPC, irc.SOPP)) or 'DIV_SCALE' in op_name:
      special |= _VCC_SGPRS
  alias: dict[tuple[str, int], int] = {}
  def reg_id(file: str, idx: int):
    if file == 's' and idx in special: return ('sp', idx)
    return alias.setdefault((file, idx), len(alias))
  ops = inst.operands
  acc_mem = bool(_iattr(inst, 'acc'))
  acc_mfma = bool(_iattr(inst, 'acc_cd'))
  is_acc_mov = 'ACCVGPR_MOV' in op_name
  parts: list = [arch, type(inst).__name__.removesuffix('_LIT')]
  for fname, _ in inst._fields:
    if fname in _IMM_FIELDS or (fname == 'glc' and 'ATOMIC' not in op_name): continue
    if fname == 'vsrcx1' and hasattr(inst, 'opx') and inst.opx.name == 'V_DUAL_MOV_B32': continue
    if fname == 'vsrcy1' and hasattr(inst, 'opy') and inst.opy.name == 'V_DUAL_MOV_B32': continue
    val = getattr(inst, fname)
    if isinstance(val, Reg):
      if not _field_active(fname, ops): continue
      off, sz = val.offset, val.sz
      # SDWA vsrc0/vsrc1 can be SGPR/inline when s0/s1 is set
      if isinstance(inst, (irc.VOP1_SDWA, irc.VOP2_SDWA, irc.VOP2_SDWA_SDST, irc.VOPC_SDWA_SDST)) and \
          ((fname == 'vsrc0' and inst.s0) or (fname == 'vsrc1' and inst.s1)):
        raw = off - 256
        parts.append((fname, 'S', reg_id('s', raw)) if (raw < 128 or raw == SCC.offset) else (fname, 'IMM'))
        continue
      if fname == 'saddr':
        if isinstance(inst, (ir3.FLAT, ir4.VFLAT, irc.FLAT)) or off >= 124: parts.append((fname, 'NULL'))
        else: parts.append((fname, 'S', tuple(reg_id('s', off + d) for d in range(sz))))
        continue
      if off >= 256:
        if fname == 'vdst' and _op_name(inst) in ('V_READLANE_B32', 'V_READFIRSTLANE_B32', 'V_READFIRSTLANE_B32_E32', 'V_READFIRSTLANE_B32_E64'):
          parts.append((fname, 'S', (reg_id('s', off - 256),)))
          continue
        sh = 128 if (off >= 384 and _is_16bit_rdna_hi_field(inst, fname)) else 0
        is_acc = (wave_size == 64) and (
          is_acc_mov or
          (acc_mem and fname in ('vdst', 'data', 'data0', 'data1', 'vdata', 'vsrc')) or
          (acc_mfma and fname in ('vdst', 'src2')) or
          (ops.get(fname, (None, None, None))[2] in (OpType.OPR_ACCVGPR, OpType.OPR_SRC_ACCVGPR)))
        file = 'a' if is_acc else 'v'
        base = off - 256 - sh
        parts.append((fname, 'VH' if sh else file.upper(), tuple(reg_id(file, base + d) for d in range(sz))))
      elif wave_size == 32 and off == 124: parts.append((fname, 'NULL'))
      elif off == SCC.offset: parts.append((fname, 'S', (reg_id('s', SCC.offset),)))
      elif off < 128: parts.append((fname, 'S', tuple(reg_id('s', off + d) for d in range(sz))))
      else: parts.append((fname, 'IMM'))
    else:
      parts.append((fname, val))
  return tuple(parts)

instruction_cache:dict[tuple, tuple[UOp, list[Callable[[Inst], UOp]], UOp|None, list[tuple[UOp, Callable[[Inst], UOp]]]]] = {}

def instruction_call(inst:Inst, arch:str, renderer:Renderer) -> tuple[UOp, UOp|None]:
  wave_size = _wave_size(arch)
  key = (_inst_cache_key(inst, arch, wave_size), type(renderer), renderer.target, *(x.value for x in to_program_config))
  if (cached := instruction_cache.get(key)) is None:
    ctx = _Ctx(inst, wave_size)
    sink = _get_handler(inst)(inst, ctx)
    used = sorted((u for u in sink.toposort() if u.op is Ops.PARAM), key=lambda u: u.arg.slot)
    name = f"{_op_name(inst).lower()}_{len(instruction_cache)}"
    body = sink.replace(arg=KernelInfo(name)).substitute(
      {b: UOp.param(i, b.dtype, b.shape, name=b.arg.name, addrspace=b.addrspace) for i, b in enumerate(used)}, walk=True)
    call_specs = [ctx._param_specs[u] for u in used]
    cond_specs = [(u, ctx._param_specs[u]) for u in sorted((u for u in ctx.branch_cond.toposort() if u.op is Ops.PARAM), key=lambda u: u.arg.slot)] \
      if ctx.branch_cond is not None else []
    cached = instruction_cache[key] = (body, call_specs, ctx.branch_cond, cond_specs)
  body, call_specs, branch_cond, cond_specs = cached
  args = [fn(inst) for fn in call_specs]
  call = UOp.native(inst, body).call(*args)
  cond = branch_cond.substitute({u: fn(inst) for u, fn in cond_specs}) if branch_cond is not None else None
  return call, cond

def instruction_block(instructions:list[UOp]) -> tuple[UOp, list[UOp]]:
  bufs = list(dict.fromkeys(b for call in instructions for b in call.src[1:] if b.op is Ops.PARAM))
  params = {b:UOp.param(i, b.dtype, b.shape, name=_local_param_name(i, b), addrspace=b.addrspace) for i,b in enumerate(bufs)}
  linear = list(UOp.sink(*params.values()).toposort())[:-1]
  seen = set(linear)
  for call in instructions:
    args = [params.get(b, b) for b in call.src[1:]]
    inputs = UOp.sink(*args)
    nodes = inputs.toposort(lambda u:u not in seen)
    nodes.pop(inputs)
    seen.update(nodes)
    linear.extend(nodes)
    linear.append(call.replace(src=(call.body, *args)))
  return UOp(Ops.PROGRAM, src=(sink:=UOp.sink(*linear, arg=KernelInfo("emu_block", optimized=True)), UOp(Ops.LINEAR, src=(*linear, sink)))), bufs

# a block has an empty body; a loop contains its header block and the rest of its iteration.
CFGRegion = tuple[int, list["CFGRegion"]]

def cfg_regions(paths:dict[int, dict[int, int]], entry:int) -> list[CFGRegion]:
  # number the reachable blocks in DFS postorder, without recursion on long instruction streams.
  order:dict[int, int] = {}
  seen, pending = set(), [(entry, False)]
  while pending:
    pc, visited = pending.pop()
    if visited: order[pc] = len(order)
    elif pc not in seen:
      seen.add(pc)
      pending.append((pc, True))
      pending.extend((dst, False) for dst in sorted(paths[pc], reverse=True))
  preds:dict[int, set[int]] = {pc:set() for pc in order}
  for pc in order:
    for dst in paths[pc]: preds[dst].add(pc)
  def build(remaining:set[int]) -> list[CFGRegion]:
    regions: list[CFGRegion] = []
    # reverse postorder and predecessor walks partition this region into SCCs in execution order.
    for pc in sorted(remaining, key=order.__getitem__, reverse=True):
      if pc not in remaining: continue
      component, todo = set(), [pc]
      while todo:
        if (dst:=todo.pop()) not in remaining: continue
        remaining.remove(dst)
        component.add(dst)
        todo.extend(preds[dst])
      body:list[CFGRegion] = []
      if len(component) > 1 or pc in paths[pc]:
        # Bourdoncle WTO: removing the max-postorder head exposes nested loops; the original DFS order still applies,
        # and after one pass through body every wave still in component is guaranteed to be at pc.
        body = [(pc, [])] + build(component - {pc})
      regions.append((pc, body))
    return regions
  return build(set(order))

RENDER = ContextVar("RENDER", 0) # render lifted ast back to assembly

def linearize_basic_block(call:UOp):
  return UOp(Ops.LINEAR, src=tuple(y for x in call.body.toposort() if x.op is Ops.LINEAR for y in x.src if y.op is Ops.BINARY))

pm_render = PatternMatcher([
  (UPat(Ops.NATIVE, name="native").call(allow_any_len=True), lambda native: UOp(Ops.BINARY, arg=native.arg.code.to_bytes())),
  (UPat(Ops.CALL, src=(UPat.any(UPat(Ops.SINK), UPat(Ops.PROGRAM, src=(UPat(Ops.SINK),), allow_any_len=True)),),
        allow_any_len=True, name="call"), linearize_basic_block),
  (UPat(Ops.SINK, name="root"), lambda root: next((x for x in root.toposort() if x.op is Ops.LINEAR), None)
   if isinstance(root.arg, KernelInfo) and root.arg.name.startswith("emu ") else None),
])

pm_remove_native = PatternMatcher([
  (UPat(Ops.NATIVE, name="native"), lambda native: native.src[0]),
])

# instructions that directly read/write PC
PC_INSTS = ("S_GETPC", "S_SETPC")

@rewrite_group(replay="emu_process_replay")
def lift(code:bytes, arch:str, renderer:Renderer, dispatch:tuple, name:str="") -> UOp:
  insts = amd_decode(code, arch)
  assert not any(getattr(inst, "op_name", "").startswith(PC_INSTS) for inst in insts.values()), f"instruction stream cannot contain {PC_INSTS}"
  cfg = get_cfg(insts)
  regions = cfg_regions(cfg["paths"], 0)
  # propagate possible wave PCs across acyclic regions; loops retain runtime routing.
  unconditional:set[int] = set()
  possible:set[int]|None = {0}
  for pc, body in regions:
    if body: possible = None
    elif possible is not None:
      if possible == {pc}: unconditional.add(pc)
      possible = (possible-{pc}) | (set(cfg["paths"][pc]) or {-1})
  routed = len(unconditional) != len(regions)
  axes = itertools.count(sum(inst.size() for inst in insts.values()))
  gx, gy, gz, lx, ly, lz, rsrc2, scratch_size = dispatch
  # init ranges
  wave_size, total_threads = _wave_size(arch), lx*ly*lz
  n_waves = (total_threads+wave_size-1)//wave_size
  wg = UOp.range(gx*gy*gz, 0, dtype=dtypes.u64)
  wave = UOp.range(n_waves, 1, dtype=dtypes.int)
  # pre-build block calls so we allocate only the physical registers actually touched by this program
  route = UOp.param(1003, dtypes.int, (1,), name="route", addrspace=AddrSpace.REG)
  taken, fallthrough = [UOp.param(-20-i, dtypes.int, name=name, addrspace=AddrSpace.ALU) for i,name in enumerate(("taken", "fallthrough"))]
  def _region_blocks(regs:list[CFGRegion]) -> list[int]:
    return [pc for r_pc, r_body in regs for pc in (_region_blocks(r_body) if r_body else [r_pc])]
  block_calls:dict[int, list[UOp]] = {}
  used_regs:set[UOp] = set()
  for block_pc in _region_blocks(regions):
    cond = UOp.const(True)
    instructions = []
    for off in cfg["blocks"][block_pc]:
      call, branch_cond = instruction_call(insts[off], arch, renderer)
      if branch_cond is not None: cond = branch_cond
      if call is not None: instructions.append(call)
    if routed:
      dsts = {kind:dst for dst,kind in cfg["paths"][block_pc].items()}
      target = cond.where(taken, fallthrough) if len(dsts) == 2 else taken
      instructions.append(lower_body(route[0].store(target).sink(arg=KernelInfo("emu_branch"))))
    block_calls[block_pc] = instructions
    for call in instructions:
      for b in call.src[1:]:
        if b.op is Ops.PARAM and 0 <= b.arg.slot < 768: used_regs.add(b)
  # alloc distinct per-register buffers and shared LDS/scratch/route buffers
  lds_size = ((rsrc2 & hsa.AMD_COMPUTE_PGM_RSRC_TWO_GRANULATED_LDS_SIZE) >> hsa.AMD_COMPUTE_PGM_RSRC_TWO_GRANULATED_LDS_SIZE_SHIFT)*512
  lds = UOp.alloc((max(lds_size//4, 1),), dtypes.u32, 3, AddrSpace.REG)
  scratch = UOp.alloc((max(scratch_size*wave_size*n_waves, 1),), dtypes.u8, 4, AddrSpace.REG)
  args_ptr = UOp.variable("args_ptr", 0, dtypes.u64.max, dtypes.u64)
  routes = UOp.alloc((n_waves,), dtypes.int, 6, AddrSpace.REG)
  active = UOp.alloc((1,), dtypes.bool, 7, AddrSpace.REG)
  buffers:dict[UOp, tuple[UOp, int]] = {_Ctx.vmem:(_Ctx.vmem, 0), _Ctx.lds:(lds, 0),
                                        _Ctx.scratch:(scratch, scratch_size*wave_size), route:(routes, 1)}
  next_slot = itertools.count(8)
  for r in sorted(used_regs, key=lambda u: u.arg.slot):
    stride = 1 if r.arg.slot < 256 else wave_size
    buffers[r] = (UOp.alloc((n_waves*stride,), dtypes.u32, next(next_slot), AddrSpace.REG), stride)
  # set per wave registers
  gidx, gidy, gidz = wg%gx, (wg//gx)%gy, wg//(gx*gy)
  n_lanes = (total_threads-wave*wave_size).minimum(wave_size)
  runtime_sgprs = [(0, args_ptr.cast(dtypes.u32)), (1, (args_ptr>>32).cast(dtypes.u32))]
  if arch == "rdna4": runtime_sgprs += [(ttmp[7].offset, (gidy&0xFFFF)|((gidz&0xFFFF)<<16)), (ttmp[9].offset, gidx)]
  else:
    sgpr_id = (rsrc2 & hsa.AMD_COMPUTE_PGM_RSRC_TWO_USER_SGPR_COUNT) >> hsa.AMD_COMPUTE_PGM_RSRC_TWO_USER_SGPR_COUNT_SHIFT
    for enabled, gid in [(hsa.AMD_COMPUTE_PGM_RSRC_TWO_ENABLE_SGPR_WORKGROUP_ID_X, gidx),
                         (hsa.AMD_COMPUTE_PGM_RSRC_TWO_ENABLE_SGPR_WORKGROUP_ID_Y, gidy),
                         (hsa.AMD_COMPUTE_PGM_RSRC_TWO_ENABLE_SGPR_WORKGROUP_ID_Z, gidz)]:
      if rsrc2 & enabled:
        runtime_sgprs.append((sgpr_id, gid))
        sgpr_id += 1
  runtime_sgprs += [(EXEC_LO.offset, ((_c(1, dtypes.u64)<<n_lanes.minimum(32).cast(dtypes.u64))-1).cast(dtypes.u32))]
  if wave_size == 64: runtime_sgprs.append((EXEC_LO.offset+1, ((_c(1, dtypes.u64)<<(n_lanes-32).maximum(0).cast(dtypes.u64))-1).cast(dtypes.u32)))
  init_stores:list[UOp] = []
  if (v0_param := _reg_param('v', 0, wave_size)) in buffers:
    lane = UOp.range(wave_size, 5, dtype=dtypes.int)
    tid = wave*wave_size+lane
    v0_buf = buffers[v0_param][0]
    v0_wave = (v0_buf.shrink(((wave*wave_size, (wave+1)*wave_size),)) if n_waves > 1 else v0_buf).after(wg)
    init_stores.append(v0_wave.index(lane.valid(tid<total_threads)).store((((tid//(lx*ly))<<20)|(((tid//lx)%ly)<<10)|(tid%lx)).cast(dtypes.u32)).end(lane))
  for i, v in dict(runtime_sgprs).items():
    if (s_param := _reg_param('s', i, wave_size)) in buffers:
      s_buf = buffers[s_param][0]
      s_wave = (s_buf.shrink(((wave, wave+1),)) if n_waves > 1 else s_buf).after(wg)
      init_stores.append(s_wave.index(0).store(_c(v)))
  init = UOp.group(*init_stores, wg)
  # construct CALL graph
  initialized = (routes.after(init).index(wave).store(0) if routed else UOp.group(init, wave)).end(wave)
  def emit_block(block_pc:int, end:UOp, scopes:tuple[UOp, ...]) -> UOp:
    instructions = block_calls[block_pc]
    if not instructions: return end
    values = {_Ctx.scratch_stride:_c(scratch_size)}
    if routed:
      dsts = {kind:dst for dst,kind in cfg["paths"][block_pc].items()}
      values.update({taken:_c(dsts[COND_TAKEN], dtypes.int), fallthrough:_c(dsts[COND_NOT_TAKEN], dtypes.int)} if len(dsts) == 2
                    else {taken:_c(next(iter(dsts.values()), -1), dtypes.int)})
    body, bufs = instruction_block(instructions)
    args = [values[b] if b.addrspace is AddrSpace.ALU else buffers[b][0] for b in bufs]
    if n_waves == 1 and block_pc in unconditional:
      return body.call(*(a if b.addrspace is AddrSpace.ALU else a.after(end, *scopes) for b,a in zip(bufs, args)))
    args += [_c(block_pc, dtypes.int).after(end, *scopes)]
    params = [UOp.param(i, a.dtype, a.shape, name=_local_param_name(i, b), addrspace=b.addrspace) for i,(a,b) in enumerate(zip(args, bufs))]
    params.append(UOp.param(len(bufs), dtypes.int, addrspace=AddrSpace.ALU))
    # lower the wave loop with the block, so repeated blocks share its indexing and route check too.
    w = UOp.range(n_waves, 0, dtype=dtypes.int)
    gates = () if block_pc in unconditional else (UOp.range(params[bufs.index(route)][w].load().eq(params[-1]).cast(dtypes.int),
                                                            1, dtype=dtypes.int),)
    call_args = [p if b.addrspace is AddrSpace.ALU else p.after(*gates, w).shrink(((w*s, (w+1)*s),))
                 if (s:=buffers[b][1]) and n_waves > 1 else p.after(*gates, w) for b,p in zip(bufs, params)]
    block = UOp.group(body.call(*call_args), *gates, w).end(*gates).end(w).sink(arg=KernelInfo("emu_waves"))
    return block.call(*args)
  def emit_dispatch(regions:list[CFGRegion], scopes:tuple[UOp, ...], end:UOp) -> UOp:
    for pc, body in regions:
      if body:
        loop = UOp.loop(next(axes)).replace(src=(UOp(Ops.NOOP).after(end),))
        end = emit_dispatch(body, scopes+(loop,), loop)
        # waves that exited keep their route while the remaining waves repeat the loop.
        check = emu_loop_active(routes.after(end, *scopes, loop), active, _c(pc, dtypes.int), _c(n_waves, dtypes.int))
        end = end.backedge(loop, active.after(check, *scopes, loop)[0].load())
      else:
        # complete the block for every participating wave before entering its successors, including barrier successors.
        end = emit_block(pc, end, scopes)
    return end

  ret = emit_dispatch(regions, (wg,), initialized).end(wg).sink(_Ctx.vmem, arg=KernelInfo(name=name, optimized=True))
  if RENDER:
    linear = graph_rewrite(ret, pm_render, name="render", enter_calls=True)
    if VIZ: graph_rewrite(linear, PatternMatcher([]), name="View Rendered Graph")
    assert len(linear.src) == len(insts), f"{len(linear.src)} != {len(insts)}"
    for (pc, inst), x in zip(insts.items(), linear.src):
      out = x.arg if x.op is Ops.BINARY else b"".join(y.arg for y in x.src)
      assert out == inst.to_bytes(), f"{inst.op_name.lower()}: {out.hex()} != {inst.to_bytes().hex()}"
  ret = graph_rewrite(ret, pm_remove_native, name="remove native", enter_calls=True)
  return ret

dispatch_cache:dict[tuple, UOp] = {}

RELIFT = ContextVar("RELIFT", 0) # lift and recompile to assembly N times
REPLAY_EMU = ContextVar("REPLAY_EMU", 0)

def run_asm(lib: int, lib_sz: int, gx: int, gy: int, gz: int, lx: int, ly: int, lz: int, args_ptr: int, rsrc2: int = 0x19c,
            scratch_size: int = 0, arch: str = "rdna3", name: str = "asm") -> int:
  """Execute AMD assembly program. scratch_size is private_segment_fixed_size from kernel descriptor (per-lane)."""
  with Context(DEV=DEV.target('CPU', renderer='LLVM'), NOOPT=1, CHECK_OOB=0, TUPLE_ORDER=0, EMULATED_DTYPES="",
               CAPTURE_PROCESS_REPLAY=REPLAY_EMU.value, DEFAULT_FLOAT="float32", DEFAULT_INT="int32", TRANSCENDENTAL=1):
    code = bytes(to_mv(lib, lib_sz))
    dispatch = (gx, gy, gz, lx, ly, lz, rsrc2, scratch_size)
    renderer = Device['CPU'].renderer
    if (key:=(code, arch, dispatch, name, type(renderer), renderer.target, *(x.value for x in to_program_config))) not in dispatch_cache:
      dispatch_cache[key] = to_program(lift(code, arch, renderer, dispatch, f"emu {name}"), renderer)
      relift_lib = code
      for relift_count in range(1, RELIFT.value+1):
        try:
          ret = to_program(lift(relift_lib, arch, Device["AMD"].renderer, dispatch, f"relift_{relift_count} {name}"), Device["AMD"].renderer)
        except Exception:
          print("relift err", traceback.format_exc())
          break
        relift_lib = get_elf_section(ret.src[3].arg, ".text").content
    prg = dispatch_cache[key]
  vmem_buf = UOp.from_buffer(Buffer('CPU', 1 << 48, options=BufferSpec(external_ptr=0), opaque=0), dtypes.u32)
  args = [vmem_buf] * (max(p.arg.slot for p in prg.kernel_params) + 1)
  for p in prg.kernel_params:
    if p.addrspace is AddrSpace.ALU: args[p.arg.slot] = p.bind(args_ptr)
  with _MXCSRContext():
    run_linear(UOp(Ops.LINEAR, src=(prg.call(*args),)), update_stats=False)
  return 0
