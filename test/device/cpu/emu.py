"""Small x86-64 emulator: Capstone -> CALL(NATIVE) -> UOp instruction bodies -> CPU kernels.

This is a functional emulator for leaf functions, not a system emulator. Instructions and control flow are lifted to
UOps and compiled by tinygrad's CPU/LLVM backend using the same instruction/block/CFG helpers as the AMD emulator.
"""
import ctypes, functools, itertools, re
from capstone import Cs, CsInsn, CS_ARCH_X86, CS_MODE_64
from capstone import x86 as cs_x86

from tinygrad.codegen import to_program
from tinygrad.device import Buffer, BufferSpec, Device
from tinygrad.dtype import dtypes, AddrSpace
from tinygrad.helpers import Context
from tinygrad.uop.ops import UOp, KernelInfo, Ops
from test.emulator.lifter import lower_body, instruction_block, cfg_regions, emit_cfg, run_program

REGS = UOp.param(0, dtypes.uint64, 16, name="regs", volatile=True)
XMM = UOp.param(1, dtypes.uint64, 256, name="xmm", volatile=True)  # 32 vector registers, up to 64 bytes each
FLAGS = UOp.param(2, dtypes.uint64, 6, name="flags", volatile=True)
VMEM = UOp.param(3, dtypes.uint8, 1 << 48, name="vmem", volatile=True)
MASKS = UOp.param(4, dtypes.uint64, 8, name="masks", volatile=True)
STATE = (REGS, XMM, FLAGS, VMEM, MASKS)
GPR_NAMES = ("rax", "rcx", "rdx", "rbx", "rsp", "rbp", "rsi", "rdi", "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15")
CF, PF, AF, ZF, SF, OF = range(6)

# Capstone register ID -> (GPR slot, byte width, is_high_byte). 32-bit writes zero the upper half; narrower writes merge.
_ALIASES = {
  "rax": ("rax", "eax", "ax", "al", "ah"), "rcx": ("rcx", "ecx", "cx", "cl", "ch"),
  "rdx": ("rdx", "edx", "dx", "dl", "dh"), "rbx": ("rbx", "ebx", "bx", "bl", "bh"),
  "rsp": ("rsp", "esp", "sp", "spl"), "rbp": ("rbp", "ebp", "bp", "bpl"),
  "rsi": ("rsi", "esi", "si", "sil"), "rdi": ("rdi", "edi", "di", "dil"),
  **{f"r{i}": (f"r{i}", f"r{i}d", f"r{i}w", f"r{i}b") for i in range(8, 16)},
}
REG_INFO = {}
for _slot, _name in enumerate(GPR_NAMES):
  for _alias in _ALIASES[_name]:
    _width = 8 if _alias == _name else 4 if _alias.startswith("e") or _alias.endswith("d") else 1 if _alias[-1] in "blh" else 2
    REG_INFO[getattr(cs_x86, f"X86_REG_{_alias.upper()}")] = (_slot, _width, _alias in ("ah", "ch", "dh", "bh"))

UINT_DT = {1: dtypes.uint8, 2: dtypes.uint16, 4: dtypes.uint32, 8: dtypes.uint64}
SINT_DT = {1: dtypes.int8, 2: dtypes.int16, 4: dtypes.int32, 8: dtypes.int64}

def _c(v:int, dt=dtypes.uint64) -> UOp: return UOp.const(v, dt)
def _mask(size:int) -> int: return (1 << (size * 8)) - 1
def _bool(v:UOp) -> UOp: return v if v.dtype == dtypes.bool else v.ne(_c(0, v.dtype))

@functools.cache
def _decoder():
  md = Cs(CS_ARCH_X86, CS_MODE_64)
  md.detail = True
  return md

@functools.cache
def _libm_symbols() -> dict[int, tuple[str, object, list[object]]]:
  from tinygrad.runtime.support.c import DLL
  lib = DLL("m", "m")
  symbols = {}
  for base_name in ("exp2", "exp", "log2", "log", "pow", "sin", "cos", "tanh", "sqrt", "fmod"):
    for suffix, dt in (("", dtypes.float64), ("f", dtypes.float32)):
      name = base_name + suffix
      try: address = ctypes.cast(getattr(lib, name), ctypes.c_void_p).value
      except AttributeError: continue
      argc = 2 if base_name in ("pow", "fmod") else 1
      symbols[address] = (name, dt, [dt] * argc)
  return symbols

def _external_symbol(target:int):
  try: return _libm_symbols()[target]
  except KeyError: raise NotImplementedError(f"external call to {target:#x} is not implemented") from None

def decode(code:bytes, base:int=0) -> list[UOp]:
  """Decode every instruction to CALL(NATIVE(CsInsn), register/XMM/flag/memory state)."""
  return [UOp.native(insn).call(*STATE) for insn in _decoder().disasm(code, base)]

def attach_body(call:UOp) -> UOp:
  """Attach the instruction's UOp SINK to its NATIVE node, preserving the decoded CALL and its arguments."""
  assert call.op is Ops.CALL and call.body.op is Ops.NATIVE
  compiler = _Instruction(call.body.arg.code)
  body = compiler.compile()
  native_src = (body,) if compiler.branch_cond is None else (body, compiler.branch_cond)
  return call.replace(src=(call.body.replace(src=native_src),)+call.src[1:])

def instruction_call(call:UOp) -> tuple[UOp, UOp|None]:
  """Lower a decoded CALL(NATIVE) to the same CALL(SINK) form used by the AMD instruction lifter."""
  attached = attach_body(call)
  insn = call.body.arg.code
  body = attached.body.src[0]
  return lower_body(UOp.sink(body), f"x86_{insn.mnemonic}_{insn.address:x}"), attached.body.src[1] if len(attached.body.src) > 1 else None

class _Instruction:
  def __init__(self, insn:CsInsn):
    self.insn, self.stores, self.branch_cond = insn, [], None

  def compile(self) -> UOp:
    m = self.insn.mnemonic
    if m in ("nop", "endbr64", "ret", "retq", "vzeroupper", "vzeroall") or m == "jmp": return UOp.sink()
    if m.startswith("j"):
      self.branch_cond = self._condition(m[1:])
      return UOp.sink()
    if m in ("mov", "movabs"): self._mov()
    elif m == "lea": self._write_operand(self.insn.operands[0], self._address(self.insn.operands[1].mem))
    elif m in ("movzx", "movsx", "movsxd"): self._extend(m != "movzx")
    elif m in ("add", "sub", "and", "or", "xor", "cmp", "test", "adc", "sbb"): self._binary(m)
    elif m in ("inc", "dec", "neg", "not"): self._unary(m)
    elif m == "imul": self._imul()
    elif m == "mulx": self._mulx()
    elif m in ("shl", "sal", "shr", "sar"): self._shift(m)
    elif m in ("rorx", "rol", "ror"): self._rotate(m)
    elif m in ("bextr", "andn", "blsi", "blsr", "blsmsk"): self._bmi(m)
    elif m in ("cdq", "cqo", "cdqe"): self._sign_extend_rax(m)
    elif m in ("idiv", "div"): self._div(m == "idiv")
    elif m == "push": self._push()
    elif m == "pop": self._pop()
    elif m.startswith("cmov"): self._cmov(m[4:])
    elif m.startswith("set"): self._setcc(m[3:])
    elif m in ("movss", "movsd", "vmovss", "vmovsd"): self._move_xmm(m)
    elif m in ("addss", "addsd", "subss", "subsd", "mulss", "mulsd", "divss", "divsd", "minss", "minsd", "maxss", "maxsd",
               "vaddss", "vaddsd", "vsubss", "vsubsd", "vmulss", "vmulsd", "vdivss", "vdivsd",
               "vminss", "vminsd", "vmaxss", "vmaxsd"): self._binary_xmm(m)
    elif m in ("ucomiss", "ucomisd", "comiss", "comisd", "vucomiss", "vucomisd", "vcomiss", "vcomisd"): self._compare_xmm(m)
    elif m in ("movups", "movaps", "movupd", "movapd", "vmovups", "vmovaps", "vmovupd", "vmovapd", "movlps", "movlpd",
               "vmovlps", "vmovlpd", "movdqa", "movdqu", "vmovdqa", "vmovdqu", "vmovdqu64", "vmovdqu32",
               "vmovdqu16", "vmovdqu8", "vmovdqa64", "vmovdqa32", "vmovdqa16", "vmovdqa8"): self._move_vector(m)
    elif m in ("xorps", "xorpd", "pxor", "vxorps", "vxorpd", "vpxor", "andps", "andpd", "vandps", "vandpd",
               "andnps", "andnpd", "vandnps", "vandnpd", "pandn", "vpandn"): self._logic_vector(m)
    elif m in ("addps", "addpd", "subps", "subpd", "mulps", "mulpd", "divps", "divpd", "minps", "minpd", "maxps", "maxpd",
               "vaddps", "vaddpd", "vsubps", "vsubpd", "vmulps", "vmulpd", "vdivps", "vdivpd",
               "vminps", "vminpd", "vmaxps", "vmaxpd"): self._binary_vector(m)
    elif m in ("vbroadcastss", "vbroadcastsd", "vbroadcastf128", "vbroadcasti128", "vbroadcastf32x4", "vbroadcasti32x4",
               "vpbroadcastb", "vpbroadcastw", "vpbroadcastd", "vpbroadcastq"): self._broadcast(m)
    elif m in ("haddps", "vhaddps"): self._horizontal_add(m)
    elif m in ("movshdup", "movsldup", "vmovshdup", "vmovsldup", "movddup", "vmovddup"): self._shuffle_dup(m)
    elif m in ("insertps", "vinsertps"): self._insert_ps(m)
    elif m in ("pinsrw", "pinsrd", "vpinsrw", "vpinsrd"): self._insert_int(m)
    elif m in ("pextrw", "pextrd", "vpextrw", "vpextrd", "pextrb", "vpextrb", "extractps", "vextractps"): self._extract_int(m)
    elif m in ("shufps", "shufpd", "vshufps", "vshufpd"): self._shuffle(m)
    elif m in ("movlhps", "movhlps", "vmovlhps", "vmovhlps"): self._move_low_high(m)
    elif m in ("vgatherdps", "vgatherdpd", "vgatherqps", "vgatherqpd"): self._gather(m)
    elif m in ("vinserti128", "vinsertf128", "vextracti128", "vextractf128", "vinserti32x4", "vinsertf32x4",
               "vextracti32x4", "vextractf32x4", "vinserti64x4", "vinsertf64x4", "vextracti64x4", "vextractf64x4",
               "vinserti32x8", "vinsertf32x8", "vextracti32x8", "vextractf32x8"): self._insert_extract_128(m)
    elif m == "vpermq": self._permute_qwords(m)
    elif m in ("vpermt2ps", "vpermt2pd", "vpermt2d", "vpermt2q"): self._permute_two(m)
    elif m in ("vpermps", "vpermpd"): self._permute_qwords(m) if self.insn.operands[-1].type == cs_x86.X86_OP_IMM else self._permute_variable(m)
    elif m in ("blendps", "blendpd", "vblendps", "vblendpd", "pblendd", "vpblendd"): self._blend(m)
    elif m in ("blendvps", "blendvpd", "vblendvps", "vblendvpd", "pblendvb", "vpblendvb"): self._blend_variable(m)
    elif m in ("sqrtss", "sqrtsd", "sqrtps", "sqrtpd", "vsqrtss", "vsqrtsd", "vsqrtps", "vsqrtpd"): self._sqrt_vector(m)
    elif m in ("pshufd", "vpshufd"): self._shuffle_dwords(m)
    elif m == "vpshufb": self._shuffle_bytes(m)
    elif m in ("vshuff64x2", "vshuff32x4", "vshufi64x2", "vshufi32x4"): self._shuffle_chunks(m)
    elif m.startswith(("punpck", "vpunpck", "unpck", "vunpck")): self._unpack(m)
    elif m.startswith("vfmadd") or m.startswith("vfmsub"): self._fma_vector(m)
    elif m.startswith(("cvt", "vcvt")): self._convert(m)
    elif m.startswith(("vpadd", "vpsub", "vpmul", "vpand", "vpor", "vpxor")): self._integer_vector(m)
    elif m in ("vpackssdw", "vpacksswb"): self._pack_saturated(m)
    elif m.startswith(("vmaskmov", "vpmaskmov")): self._masked_store(m)
    elif m.startswith(("vpsrl", "vpsll", "vpsra", "vprol", "vpror")): self._shift_vector(m)
    elif m.startswith("vpmovm2"): self._mask_to_vector(m)
    elif m == "vpmovmskb": self._byte_mask(m)
    elif m.startswith("vpmov"): self._extend_vector(m)
    elif m == "call": self._call()
    elif m in ("vmovd", "vmovq", "movd", "movq"): self._move_between_gpr_xmm(m)
    elif m.startswith("vpcmp"): self._compare_integer_mask(m)
    elif m.startswith("vcmp") and self.insn.reg_name(self.insn.operands[0].reg).startswith("k"): self._compare_vector_mask(m)
    elif m.startswith("vcmp"): self._compare_vector_xmm(m)
    elif m.startswith("kmov"): self._move_mask(m)
    elif m.startswith("kshift"): self._shift_mask(m)
    elif m.startswith(("kor", "kand", "kxor", "knot", "kxnor")): self._logic_mask(m)
    else: raise NotImplementedError(f"{self.insn.address:#x}: {self.insn.mnemonic} {self.insn.op_str}")
    return UOp.sink(*self.stores)

  def _read_gpr(self, reg:int, size:int|None=None) -> UOp:
    slot, width, high = REG_INFO[reg]
    value = REGS.index(_c(slot)).load()
    if high: value = value >> _c(8)
    dt = UINT_DT[width if size is None else size]
    return value.cast(dt)

  def _write_gpr(self, reg:int, value:UOp) -> None:
    slot, width, high = REG_INFO[reg]
    index = REGS.index(_c(slot))
    if high:
      old = index.load()
      value = (old & _c(~0xff00 & _mask(8))) | ((value.cast(dtypes.uint64) & _c(0xff)) << _c(8))
    elif width == 4: value = value.cast(dtypes.uint32).cast(dtypes.uint64)  # x86-64 zero-extends every 32-bit GPR write
    elif width < 8:
      old = index.load()
      value = (old & _c(~_mask(width) & _mask(8))) | (value.cast(dtypes.uint64) & _c(_mask(width)))
    self.stores.append(index.store(value.cast(dtypes.uint64)))

  def _address(self, mem) -> UOp:
    address = _c(0)
    if mem.base == cs_x86.X86_REG_RIP: address = _c(self.insn.address + self.insn.size)
    elif mem.base: address = self._read_gpr(mem.base, 8).cast(dtypes.uint64)
    if mem.index: address = address + self._read_gpr(mem.index, 8).cast(dtypes.uint64) * _c(mem.scale)
    return address + _c(mem.disp & _mask(8))

  def _load(self, address:UOp, size:int) -> UOp:
    dt = UINT_DT[size]
    value = _c(0, dt)
    for i in range(size):
      byte = VMEM.index(address + _c(i)).load().cast(dt)
      value = value | (byte << _c(i * 8, dt)) if i else byte
    return value

  def _store(self, address:UOp, value:UOp, size:int) -> None:
    value = value.cast(dtypes.uint64)
    for i in range(size):
      byte = (value >> _c(i * 8)) & _c(0xff)
      self.stores.append(VMEM.index(address + _c(i)).store(byte.cast(dtypes.uint8)))

  def _read_operand(self, op, size:int|None=None) -> UOp:
    size = op.size if size is None else size
    if op.type == cs_x86.X86_OP_REG: return self._read_gpr(op.reg, size)
    if op.type == cs_x86.X86_OP_IMM: return _c(op.imm & _mask(size), UINT_DT[size])
    if op.type == cs_x86.X86_OP_MEM: return self._load(self._address(op.mem), size)
    raise NotImplementedError(f"operand type {op.type} in {self.insn.mnemonic} {self.insn.op_str}")

  def _write_operand(self, op, value:UOp) -> None:
    if op.type == cs_x86.X86_OP_REG: self._write_gpr(op.reg, value)
    elif op.type == cs_x86.X86_OP_MEM: self._store(self._address(op.mem), value, op.size)
    else: raise NotImplementedError(f"destination type {op.type} in {self.insn.mnemonic} {self.insn.op_str}")

  def _mov(self) -> None:
    dst, src = self.insn.operands
    self._write_operand(dst, self._read_operand(src, dst.size))

  def _extend(self, signed:bool) -> None:
    dst, src = self.insn.operands
    value = self._read_operand(src)
    value = value.cast(SINT_DT[src.size] if signed else UINT_DT[src.size]).cast(UINT_DT[dst.size])
    self._write_operand(dst, value)

  def _flag(self, flag:int) -> UOp: return FLAGS.index(_c(flag)).load().ne(_c(0))
  def _set_flag(self, flag:int, value:UOp) -> None: self.stores.append(FLAGS.index(_c(flag)).store(_bool(value).cast(dtypes.uint64)))

  def _common_flags(self, result:UOp, size:int) -> None:
    low = result.cast(dtypes.uint8)
    parity = _c(0, dtypes.uint8)
    for i in range(8): parity = parity ^ ((low >> _c(i, dtypes.uint8)) & _c(1, dtypes.uint8))
    self._set_flag(PF, parity.eq(_c(0, dtypes.uint8)))
    self._set_flag(ZF, result.eq(_c(0, result.dtype)))
    self._set_flag(SF, (result & _c(1 << (size * 8 - 1), result.dtype)).ne(_c(0, result.dtype)))

  def _binary(self, m:str) -> None:
    dst, src = self.insn.operands
    a, b = self._read_operand(dst), self._read_operand(src, dst.size)
    if m in ("adc", "sbb"): b = b + self._flag(CF).cast(b.dtype)
    if m in ("add", "adc"): result = a + b
    elif m in ("sub", "sbb", "cmp"): result = a - b
    elif m in ("and", "test"): result = a & b
    elif m == "or": result = a | b
    else: result = a ^ b
    result = result.cast(a.dtype)
    self._common_flags(result, dst.size)
    sign = _c(1 << (dst.size * 8 - 1), a.dtype)
    if m in ("add", "adc", "sub", "sbb", "cmp"):
      self._set_flag(AF, ((a ^ b ^ result) & _c(0x10, a.dtype)).ne(_c(0, a.dtype)))
      if m in ("add", "adc"):
        self._set_flag(CF, result < a if m == "add" else (result <= a) & b.ne(_c(0, b.dtype)))
        self._set_flag(OF, ((a ^ result) & (b ^ result) & sign).ne(_c(0, a.dtype)))
      else:
        self._set_flag(CF, a < b)
        self._set_flag(OF, ((a ^ b) & (a ^ result) & sign).ne(_c(0, a.dtype)))
    else:
      self._set_flag(CF, _c(0, dtypes.bool))
      self._set_flag(OF, _c(0, dtypes.bool))
      self._set_flag(AF, _c(0, dtypes.bool))
    if m not in ("cmp", "test"): self._write_operand(dst, result)

  def _unary(self, m:str) -> None:
    op = self.insn.operands[0]
    old = self._read_operand(op)
    if m == "not": return self._write_operand(op, old ^ _c(_mask(op.size), old.dtype))
    result = (old + _c(1, old.dtype)) if m == "inc" else (old - _c(1, old.dtype)) if m == "dec" else -old
    result = result.cast(old.dtype)
    self._common_flags(result, op.size)
    sign = _c(1 << (op.size * 8 - 1), old.dtype)
    if m == "neg":
      self._set_flag(CF, old.ne(_c(0, old.dtype)))
      self._set_flag(OF, old.eq(sign))
      self._set_flag(AF, ((old ^ result) & _c(0x10, old.dtype)).ne(_c(0, old.dtype)))
    else:
      self._set_flag(OF, result.eq(sign) if m == "inc" else old.eq(sign))
      self._set_flag(AF, ((old ^ result) & _c(0x10, old.dtype)).ne(_c(0, old.dtype)))
    self._write_operand(op, result)

  def _imul(self) -> None:
    ops = self.insn.operands
    dst = ops[0]
    src1, src2 = (dst, ops[1]) if len(ops) == 2 else (ops[1], ops[2])
    a, b = self._read_operand(src1, dst.size), self._read_operand(src2, dst.size)
    result = (a * b).cast(a.dtype)
    self._write_operand(dst, result)
    if dst.size < 8:
      wide = a.cast(SINT_DT[dst.size]).cast(dtypes.int64) * b.cast(SINT_DT[dst.size]).cast(dtypes.int64)
      overflow = wide.ne(result.cast(SINT_DT[dst.size]).cast(dtypes.int64))
    else:
      # Unsigned 128-bit high half in 32-bit limbs, then adjust for two signed inputs.
      a0, a1 = a.cast(dtypes.uint32).cast(dtypes.uint64), (a >> _c(32)).cast(dtypes.uint32).cast(dtypes.uint64)
      b0, b1 = b.cast(dtypes.uint32).cast(dtypes.uint64), (b >> _c(32)).cast(dtypes.uint32).cast(dtypes.uint64)
      p00, p01, p10, p11 = a0*b0, a0*b1, a1*b0, a1*b1
      middle = (p00 >> _c(32)) + (p01 & _c(0xffffffff)) + (p10 & _c(0xffffffff))
      high = p11 + (p01 >> _c(32)) + (p10 >> _c(32)) + (middle >> _c(32))
      sign = _c(1 << 63)
      high = high - (a & sign).ne(_c(0)).where(b, _c(0)) - (b & sign).ne(_c(0)).where(a, _c(0))
      overflow = high.ne(result.cast(SINT_DT[8]).__rshift__(_c(63, SINT_DT[8])).cast(dtypes.uint64))
    self._set_flag(CF, overflow)
    self._set_flag(OF, overflow)

  def _unsigned_mul_high(self, a:UOp, b:UOp) -> UOp:
    a0, a1 = a.cast(dtypes.uint32).cast(dtypes.uint64), (a >> _c(32)).cast(dtypes.uint32).cast(dtypes.uint64)
    b0, b1 = b.cast(dtypes.uint32).cast(dtypes.uint64), (b >> _c(32)).cast(dtypes.uint32).cast(dtypes.uint64)
    p00, p01, p10, p11 = a0*b0, a0*b1, a1*b0, a1*b1
    middle = (p00 >> _c(32)) + (p01 & _c(0xffffffff)) + (p10 & _c(0xffffffff))
    return p11 + (p01 >> _c(32)) + (p10 >> _c(32)) + (middle >> _c(32))

  def _mulx(self) -> None:
    hi, lo, src = self.insn.operands
    a = self._read_gpr(cs_x86.X86_REG_RDX, src.size)
    b = self._read_operand(src)
    if src.size < 8:
      product = a.cast(dtypes.uint64) * b.cast(dtypes.uint64)
      high, low = product >> _c(32), product
    else: high, low = self._unsigned_mul_high(a, b), a*b
    if hi.type == cs_x86.X86_OP_REG and lo.type == cs_x86.X86_OP_REG and hi.reg == lo.reg:
      self._write_operand(hi, high)  # same destination is used by magic-division sequences to keep the high half
    else:
      self._write_operand(lo, low)
      self._write_operand(hi, high)

  def _shift(self, m:str) -> None:
    dst = self.insn.operands[0]
    old = self._read_operand(dst)
    count = _c(1, dtypes.uint32) if len(self.insn.operands) == 1 else self._read_operand(self.insn.operands[1]).cast(dtypes.uint32)
    count = count & _c(0x3f if dst.size == 8 else 0x1f, dtypes.uint32)
    count = count.cast(old.dtype)
    if m in ("shl", "sal"): result = old << count
    elif m == "shr": result = old >> count
    else: result = (old.cast(SINT_DT[dst.size]) >> count.cast(SINT_DT[dst.size])).cast(old.dtype)
    result = result.cast(old.dtype)
    self._write_operand(dst, result)
    self._common_flags(result, dst.size)
    safe_count = count.maximum(_c(1, old.dtype))
    shifted_out = (old >> (safe_count - _c(1, old.dtype))) & _c(1, old.dtype) if m in ("shr", "sar") else \
                  (old >> (_c(dst.size * 8, old.dtype) - safe_count)) & _c(1, old.dtype)
    self._set_flag(CF, count.ne(_c(0, old.dtype)) & shifted_out.ne(_c(0, old.dtype)))
    self._set_flag(OF, _c(0, dtypes.bool))
    self._set_flag(AF, _c(0, dtypes.bool))

  def _rotate(self, m:str) -> None:
    dst, src = self.insn.operands[:2]
    value = self._read_operand(src)
    bits = dst.size * 8
    count = _c(self.insn.operands[2].imm if len(self.insn.operands) > 2 else 1, value.dtype)
    count = count & _c(bits - 1, value.dtype)
    reverse = _c(-1, value.dtype)
    if m == "rol": result = (value << count) | (value >> ((reverse*count) & _c(bits-1, value.dtype)))
    else: result = (value >> count) | (value << ((reverse*count) & _c(bits-1, value.dtype)))
    self._write_operand(dst, result)

  def _bmi(self, m:str) -> None:
    dst = self.insn.operands[0]
    if m == "bextr":
      src, control = self.insn.operands[1:3]
      value, control = self._read_operand(src), self._read_operand(control)
      start, length = control & _c(0xff, control.dtype), (control >> _c(8, control.dtype)) & _c(0xff, control.dtype)
      bits = src.size * 8
      mask = (length >= _c(bits, length.dtype)).where(_c(_mask(src.size), value.dtype),
        (_c(1, value.dtype) << length.cast(value.dtype)) - _c(1, value.dtype))
      value = (value >> start.cast(value.dtype).minimum(_c(bits-1, value.dtype))) & mask
      value = (start < _c(bits, start.dtype)).where(value, _c(0, value.dtype))
    else:
      left, right = self.insn.operands[1:3]
      a, b = self._read_operand(left), self._read_operand(right)
      if m == "andn": value = (a ^ _c(_mask(dst.size), a.dtype)) & b
      elif m == "blsi": value = a & (-a)
      elif m == "blsr": value = a & (a - _c(1, a.dtype))
      else: value = a ^ (a - _c(1, a.dtype))
    self._write_operand(dst, value)

  def _sign_extend_rax(self, m:str) -> None:
    if m == "cdqe":
      value = self._read_gpr(cs_x86.X86_REG_EAX).cast(dtypes.int32).cast(dtypes.int64).cast(dtypes.uint64)
      self._write_gpr(cs_x86.X86_REG_RAX, value)
    else:
      src = cs_x86.X86_REG_RAX if m == "cqo" else cs_x86.X86_REG_EAX
      dst = cs_x86.X86_REG_RDX if m == "cqo" else cs_x86.X86_REG_EDX
      size = 8 if m == "cqo" else 4
      sign = self._read_gpr(src).cast(SINT_DT[size]) >> _c(size * 8 - 1, SINT_DT[size])
      self._write_gpr(dst, sign.cast(UINT_DT[size]))

  def _div(self, signed:bool) -> None:
    op = self.insn.operands[0]
    if op.size != 4: raise NotImplementedError("only 32-bit div/idiv is implemented")
    hi = self._read_gpr(cs_x86.X86_REG_EDX).cast(dtypes.uint64) << _c(32)
    lo = self._read_gpr(cs_x86.X86_REG_EAX).cast(dtypes.uint64)
    divisor = self._read_operand(op).cast(dtypes.uint32)
    if signed:
      dividend = (hi | lo).bitcast(dtypes.int64)
      divisor = divisor.cast(dtypes.int32).cast(dtypes.int64)
    else: dividend = hi | lo
    quotient = dividend.alu(Ops.TRUNCDIV, divisor)
    remainder = dividend.alu(Ops.TRUNCMOD, divisor)
    self._write_gpr(cs_x86.X86_REG_EAX, quotient.cast(dtypes.uint32))
    self._write_gpr(cs_x86.X86_REG_EDX, remainder.cast(dtypes.uint32))

  def _push(self) -> None:
    op = self.insn.operands[0]
    rsp = self._read_gpr(cs_x86.X86_REG_RSP) - _c(8)
    self._write_gpr(cs_x86.X86_REG_RSP, rsp)
    self._store(rsp, self._read_operand(op, 8), 8)

  def _pop(self) -> None:
    op = self.insn.operands[0]
    rsp = self._read_gpr(cs_x86.X86_REG_RSP)
    self._write_operand(op, self._load(rsp, 8))
    self._write_gpr(cs_x86.X86_REG_RSP, rsp + _c(8))

  def _condition(self, cc:str) -> UOp:
    if cc in ("e", "z"): return self._flag(ZF)
    if cc in ("ne", "nz"): return self._flag(ZF).logical_not()
    if cc in ("s",): return self._flag(SF)
    if cc in ("ns",): return self._flag(SF).logical_not()
    if cc in ("o",): return self._flag(OF)
    if cc in ("no",): return self._flag(OF).logical_not()
    if cc in ("b", "c", "nae"): return self._flag(CF)
    if cc in ("ae", "nb", "nc"): return self._flag(CF).logical_not()
    if cc in ("be", "na"): return self._flag(CF) | self._flag(ZF)
    if cc in ("a", "nbe"): return self._flag(CF).logical_not() & self._flag(ZF).logical_not()
    if cc in ("l", "nge"): return self._flag(SF) ^ self._flag(OF)
    if cc in ("ge", "nl"): return self._flag(SF).eq(self._flag(OF))
    if cc in ("le", "ng"): return self._flag(ZF) | (self._flag(SF) ^ self._flag(OF))
    if cc in ("g", "nle"): return self._flag(ZF).logical_not() & self._flag(SF).eq(self._flag(OF))
    if cc in ("p", "pe"): return self._flag(PF)
    if cc in ("np", "po"): return self._flag(PF).logical_not()
    raise NotImplementedError(f"condition code {cc}")

  def _cmov(self, cc:str) -> None:
    dst, src = self.insn.operands
    self._write_operand(dst, self._condition(cc).where(self._read_operand(src, dst.size), self._read_operand(dst)))

  def _setcc(self, cc:str) -> None:
    self._write_operand(self.insn.operands[0], self._condition(cc).cast(dtypes.uint8))

  def _xmm_number(self, reg:int) -> int:
    name = self.insn.reg_name(reg)
    return int(name.removeprefix("xmm").removeprefix("ymm").removeprefix("zmm"))
  def _float_type(self, m:str): return dtypes.float32 if m.endswith(("ss", "ps")) else dtypes.float64
  def _vector_size(self, reg:int) -> int:
    return {"x":16, "y":32, "z":64}[self.insn.reg_name(reg)[0]]
  def _vec_read(self, reg:int, size:int, count:int|None=None) -> list[UOp]:
    count = self._vector_size(reg) // size if count is None else count
    values = []
    for i in range(count):
      bit = i * size * 8
      raw = XMM.index(_c(self._xmm_number(reg) * 8 + bit // 64)).load()
      values.append((raw >> _c(bit % 64)).cast(UINT_DT[size]))
    return values
  def _vec_write(self, reg:int, values:list[UOp], size:int) -> None:
    if (mask_match := re.search(r"\{k([0-7])\}", self.insn.op_str)) is not None:
      mask = MASKS.index(_c(int(mask_match[1]))).load()
      zeroing = "{z}" in self.insn.op_str
      old = self._vec_read(reg, size, len(values))
      values = [((mask >> _c(i)) & _c(1)).ne(_c(0)).where(value, _c(0, UINT_DT[size]) if zeroing else previous)
                for i,(value,previous) in enumerate(zip(values, old))]
    words:dict[int, UOp] = {}
    for i, value in enumerate(values):
      bit = i * size * 8
      word, shift = bit // 64, bit % 64
      if word not in words: words[word] = XMM.index(_c(self._xmm_number(reg) * 8 + word)).load()
      mask = _c(_mask(size) << shift)
      bits = value.cast(UINT_DT[size]).cast(dtypes.uint64) << _c(shift)
      words[word] = (words[word] & (mask ^ _c(_mask(8)))) | bits
    for word, value in words.items(): self.stores.append(XMM.index(_c(self._xmm_number(reg) * 8 + word)).store(value))
  def _read_vector_operand(self, op, size:int, count:int) -> list[UOp]:
    if op.type == cs_x86.X86_OP_REG: return self._vec_read(op.reg, size, count)
    broadcast = "{1to" in self.insn.op_str
    values = [self._load(self._address(op.mem) + _c(i * size), size) for i in range(1 if broadcast else count)]
    return values * count if broadcast else values
  def _vector_operands(self, m:str) -> tuple:
    ops = [op for op in self.insn.operands if op.type != cs_x86.X86_OP_REG or not self.insn.reg_name(op.reg).startswith("k")]
    return (ops[0], ops[0], ops[1]) if len(ops) == 2 else (ops[0], ops[1], ops[2])
  def _move_vector(self, m:str) -> None:
    dst, src = [op for op in self.insn.operands if op.type != cs_x86.X86_OP_REG or not self.insn.reg_name(op.reg).startswith("k")]
    size = 4 if m.endswith(("ups", "aps", "lps", "dqa", "dqu", "dqu64", "dqu32", "dqu16", "dqu8",
                            "dqa64", "dqa32", "dqa16", "dqa8")) else 8
    count = (dst.size if dst.type == cs_x86.X86_OP_MEM else src.size if src.type == cs_x86.X86_OP_MEM else self._vector_size(dst.reg)) // size
    values = self._read_vector_operand(src, size, count)
    if dst.type == cs_x86.X86_OP_REG: self._vec_write(dst.reg, values, size)
    else:
      for i, value in enumerate(values): self._store(self._address(dst.mem) + _c(i * size), value, size)
  def _integer_vector(self, m:str) -> None:
    dst, left, right = self._vector_operands(m)
    size = 4 if m in ("vpand", "vpor", "vpxor") else {"b":1, "w":2, "d":4, "q":8}[m[-1]]
    count = self._vector_size(dst.reg) // size
    a, b = self._read_vector_operand(left, size, count), self._read_vector_operand(right, size, count)
    if m.startswith("vpadd"): values = [x+y for x,y in zip(a,b)]
    elif m.startswith("vpsub"): values = [x-y for x,y in zip(a,b)]
    elif m.startswith("vpmul"): values = [x*y for x,y in zip(a,b)]
    elif m.startswith("vpand"): values = [x&y for x,y in zip(a,b)]
    elif m.startswith("vpor"): values = [x|y for x,y in zip(a,b)]
    else: values = [x^y for x,y in zip(a,b)]
    self._vec_write(dst.reg, values, size)

  def _shift_vector(self, m:str) -> None:
    if m.endswith("dq"): return self._shift_lanes(m)
    dst, left, right = self._vector_operands(m)
    size = {"w":2, "d":4, "q":8}[m[-1]]
    count = self._vector_size(dst.reg) // size
    values = self._read_vector_operand(left, size, count)
    amount = _c(right.imm, UINT_DT[size]) if right.type == cs_x86.X86_OP_IMM else self._read_vector_operand(right, size, 1)[0]
    shifted = []
    for value in values:
      if m.startswith("vprol"): result = (value << amount) | (value >> ((_c(-1, UINT_DT[size])*amount) & _c(size*8-1, UINT_DT[size])))
      elif m.startswith("vpror"): result = (value >> amount) | (value << ((_c(-1, UINT_DT[size])*amount) & _c(size*8-1, UINT_DT[size])))
      elif m.startswith("vpsll"): result = value << amount
      elif m.startswith("vpsrl"): result = value >> amount
      else: result = value.cast(SINT_DT[size]) >> amount.cast(SINT_DT[size])
      shifted.append(result.cast(UINT_DT[size]))
    self._vec_write(dst.reg, shifted, size)

  def _shift_lanes(self, m:str) -> None:
    """vpslldq / vpsrldq: shift each 128-bit lane left/right by an immediate number of bytes, zero-filling."""
    ops = self.insn.operands
    dst, src, imm = (ops[0], ops[0], ops[1]) if len(ops) == 2 else ops
    count = self._vector_size(dst.reg)
    values = self._read_vector_operand(src, 1, count)
    n = min(imm.imm, 16)
    out = []
    for lane in range(count // 16):
      sel = values[lane * 16:(lane + 1) * 16]
      if m.startswith("vpsrl"): out += [sel[i + n] if i + n < 16 else _c(0, dtypes.uint8) for i in range(16)]
      else: out += [sel[i - n] if i >= n else _c(0, dtypes.uint8) for i in range(16)]
    self._vec_write(dst.reg, out, 1)

  def _byte_mask(self, m:str) -> None:
    dst, src = self.insn.operands
    bits = _c(0)
    for i, byte in enumerate(self._vec_read(src.reg, 1, self._vector_size(src.reg))):
      bits = bits | ((byte & _c(0x80)).ne(_c(0)).cast(dtypes.uint64) << _c(i))
    self._write_operand(dst, bits)

  def _mask_to_vector(self, m:str) -> None:
    dst, src = self.insn.operands
    size = 4 if m.endswith("d") else 8
    mask = MASKS.index(_c(int(self.insn.reg_name(src.reg)[1:]))).load()
    values = [((mask >> _c(i)) & _c(1)).cast(UINT_DT[size]) * _c(_mask(size), UINT_DT[size]) for i in range(self._vector_size(dst.reg)//size)]
    self._vec_write(dst.reg, values, size)

  def _pack_saturated(self, m:str) -> None:
    dst, left, right = self._vector_operands(m)
    src_size, dst_size = (4, 2) if m.endswith("dw") else (2, 1)
    lanes = self._vector_size(dst.reg) // 16
    per_lane = 16 // src_size
    srcs = [self._read_vector_operand(src, src_size, lanes * per_lane) for src in (left, right)]
    lo, hi = -(1 << (dst_size * 8 - 1)), (1 << (dst_size * 8 - 1)) - 1
    def sat(x:UOp) -> UOp:
      return x.cast(SINT_DT[src_size]).maximum(_c(lo, SINT_DT[src_size])).minimum(_c(hi, SINT_DT[src_size])).cast(UINT_DT[dst_size])
    values = []
    for lane in range(lanes):
      for src in srcs: values += [sat(x) for x in src[lane * per_lane:(lane + 1) * per_lane]]
    self._vec_write(dst.reg, values, dst_size)

  def _extend_vector(self, m:str) -> None:
    dst, src = self.insn.operands
    signed = m.startswith("vpmovs")
    src_size = {"b":1, "w":2, "d":4}[m[-2]]
    dst_size = {"d":4, "q":8}[m[-1]]
    count = self._vector_size(dst.reg) // dst_size
    values = self._read_vector_operand(src, src_size, count)
    values = [value.cast(SINT_DT[src_size] if signed else UINT_DT[src_size]).cast(UINT_DT[dst_size]) for value in values]
    self._vec_write(dst.reg, values, dst_size)

  def _logic_vector(self, m:str) -> None:
    dst, left, right = self._vector_operands(m)
    size = 8 if m.endswith("pd") else 4
    count = self._vector_size(dst.reg) // size
    a, b = self._read_vector_operand(left, size, count), self._read_vector_operand(right, size, count)
    if m.startswith(("andn", "vandn", "pandn")): values = [(x ^ _c(_mask(size), UINT_DT[size])) & y for x,y in zip(a,b)]
    elif m.startswith(("and", "vand")): values = [x & y for x,y in zip(a,b)]
    else: values = [x ^ y for x,y in zip(a,b)]
    self._vec_write(dst.reg, values, size)
  def _binary_vector(self, m:str) -> None:
    dst, left, right = self._vector_operands(m)
    dt, size = self._float_type(m), 4 if m.endswith("ps") else 8
    count = self._vector_size(dst.reg) // size
    a = [x.bitcast(dt) for x in self._read_vector_operand(left, size, count)]
    b = [x.bitcast(dt) for x in self._read_vector_operand(right, size, count)]
    op = m.removeprefix("v")
    values = [x+y if op.startswith("add") else x-y if op.startswith("sub") else x*y if op.startswith("mul") else x/y if op.startswith("div")
              else x.minimum(y) if op.startswith("min") else x.maximum(y) for x,y in zip(a,b)]
    self._vec_write(dst.reg, [x.bitcast(UINT_DT[size]) for x in values], size)
  def _broadcast(self, m:str) -> None:
    dst, src = [op for op in self.insn.operands if op.type != cs_x86.X86_OP_REG or not self.insn.reg_name(op.reg).startswith("k")]
    if m.endswith(("128", "x4")):
      values = self._read_vector_operand(src, 4, 4)
      return self._vec_write(dst.reg, values * (self._vector_size(dst.reg) // 16), 4)
    size = {"b":1, "w":2}.get(m[-1], 4 if m.endswith(("ss", "d")) else 8)
    count = self._vector_size(dst.reg) // size
    if src.type == cs_x86.X86_OP_REG and not self.insn.reg_name(src.reg).startswith(("xmm", "ymm", "zmm")):
      values = [self._read_gpr(src.reg, size)]
    else: values = self._read_vector_operand(src, size, 1)
    self._vec_write(dst.reg, values * count, size)
  def _horizontal_add(self, m:str) -> None:
    dst, left, right = self._vector_operands(m)
    count = self._vector_size(dst.reg) // 4
    a = [x.bitcast(dtypes.float32) for x in self._read_vector_operand(left, 4, count)]
    b = [x.bitcast(dtypes.float32) for x in self._read_vector_operand(right, 4, count)]
    values = []
    for base in range(0, count, 4): values += [a[base]+a[base+1], a[base+2]+a[base+3], b[base]+b[base+1], b[base+2]+b[base+3]]
    self._vec_write(dst.reg, [x.bitcast(dtypes.uint32) for x in values], 4)

  def _fma_vector(self, m:str) -> None:
    ops = [op for op in self.insn.operands if op.type != cs_x86.X86_OP_REG or not self.insn.reg_name(op.reg).startswith("k")]
    dst, left, right = ops
    dt, size = self._float_type(m), 4 if m.endswith(("ss", "ps")) else 8
    count = 1 if m.endswith(("ss", "sd")) else self._vector_size(dst.reg) // size
    a = [x.bitcast(dt) for x in self._read_vector_operand(dst, size, count)]
    b = [x.bitcast(dt) for x in self._read_vector_operand(left, size, count)]
    c = [x.bitcast(dt) for x in self._read_vector_operand(right, size, count)]
    form = int(m[6:9])  # 132, 213, or 231
    if form == 132: values = [x*z+y for x,y,z in zip(a,b,c)]
    elif form == 213: values = [y*x+z for x,y,z in zip(a,b,c)]
    else: values = [y*z+x for x,y,z in zip(a,b,c)]
    self._vec_write(dst.reg, [x.bitcast(UINT_DT[size]) for x in values], size)
  def _move_between_gpr_xmm(self, m:str) -> None:
    dst, src = self.insn.operands
    size = 4 if m.endswith("d") else 8
    if dst.type == cs_x86.X86_OP_REG and self.insn.reg_name(dst.reg).startswith(("xmm", "ymm", "zmm")):
      value = self._read_operand(src, size)
      self._vec_write(dst.reg, [value], size)
    else:
      value = self._vec_read(src.reg, size, 1)[0]
      self._write_operand(dst, value)

  def _convert(self, m:str) -> None:
    name = m.removeprefix("v").removeprefix("cvt")
    ops = self.insn.operands
    dst, src = ops[0], ops[1]
    if name.startswith("t") and name.endswith("2si"):
      dt = dtypes.float32 if "ss2" in name else dtypes.float64
      value = UOp(Ops.TRUNC, src=(self._read_xmm(src, "ss" if dt == dtypes.float32 else "sd"),)).cast(SINT_DT[dst.size])
      return self._write_operand(dst, value)
    if "si2" in name:
      dt = dtypes.float32 if name.endswith("ss") else dtypes.float64
      value = self._read_operand(src).cast(SINT_DT[src.size]).cast(dt)
      return self._write_xmm(dst.reg, value, "ss" if dt == dtypes.float32 else "sd")
    if name in ("ss2sd", "sd2ss"):
      dt = dtypes.float64 if name == "ss2sd" else dtypes.float32
      value = self._read_xmm(src, "ss" if name == "ss2sd" else "sd").cast(dt)
      return self._write_xmm(dst.reg, value, "sd" if name == "ss2sd" else "ss")
    vector_conversions = {
      "dq2ps":(4, 4, dtypes.float32, True), "ps2dq":(4, 4, dtypes.int32, False), "tps2dq":(4, 4, dtypes.int32, False),
      "dq2pd":(4, 8, dtypes.float64, True), "pd2ps":(8, 4, dtypes.float32, False), "ps2pd":(4, 8, dtypes.float64, False),
      "ph2ps":(2, 4, dtypes.float32, False), "ps2ph":(4, 2, dtypes.half, False),
    }
    if name not in vector_conversions: raise NotImplementedError(f"conversion {m}")
    src_size, dst_size, dst_dt, signed = vector_conversions[name]
    src_dt = dtypes.half if src_size == 2 else dtypes.float32 if src_size == 4 and "ps" in name.split("2")[0] else \
      dtypes.float64 if src_size == 8 else dtypes.int32 if signed else dtypes.uint32
    count = self._vector_size(dst.reg) // dst_size
    values = self._read_vector_operand(src, src_size, count)
    converted = []
    for value in values:
      value = value.bitcast(src_dt) if src_dt in (dtypes.half, dtypes.float32, dtypes.float64) else value.cast(src_dt)
      if name == "tps2dq": value = UOp(Ops.TRUNC, src=(value,))
      elif name == "ps2dq": value = value.round()
      converted.append(value.cast(dst_dt).bitcast(UINT_DT[dst_size]) if dst_dt in (dtypes.half, dtypes.float32, dtypes.float64)
                       else value.cast(dst_dt).cast(UINT_DT[dst_size]))
    self._vec_write(dst.reg, converted, dst_size)

  def _call(self) -> None:
    target = self.insn.operands[0].imm
    symbol, ret_dt, arg_dts = _external_symbol(target)
    args = [self._vec_read(getattr(cs_x86, f"X86_REG_XMM{i}"), dt.itemsize, 1)[0].bitcast(dt) for i,dt in enumerate(arg_dts)]
    result = UOp.native(symbol, dtype=ret_dt).call(*args)
    self._write_xmm(cs_x86.X86_REG_XMM0, result, "ss" if ret_dt == dtypes.float32 else "sd")

  def _compare_vector_mask(self, m:str) -> None:
    dst, left, right = self.insn.operands
    size = 4 if m.endswith(("ss", "ps")) else 8
    count = 1 if m.endswith(("ss", "sd")) else self._vector_size(left.reg) // size
    dt = dtypes.float32 if size == 4 else dtypes.float64
    a = [x.bitcast(dt) for x in self._read_vector_operand(left, size, count)]
    b = [x.bitcast(dt) for x in self._read_vector_operand(right, size, count)]
    bits = _c(0)
    for i,(x,y) in enumerate(zip(a,b)):
      bits = bits | (self._float_cond(m[4:-2], x, y).cast(dtypes.uint64) << _c(i))
    self.stores.append(MASKS.index(_c(int(self.insn.reg_name(dst.reg)[1:]))).store(bits))

  def _float_cond(self, cc:str, x:UOp, y:UOp) -> UOp:
    """Predicate from vcmp mnemonics (e.g. eq, lt, unord, nle), true when the comparison holds."""
    cc = cc.removesuffix("_oq").removesuffix("_uq").removesuffix("_q")
    unordered = x.ne(x) | y.ne(y)
    ordered = unordered.logical_not()
    if cc in ("eq", "o", "ord"): return ordered & x.eq(y) if cc == "eq" else ordered
    elif cc in ("ne", "neq", "unord"): return unordered | x.ne(y) if cc != "unord" else unordered
    elif cc == "lt": return ordered & (x < y)
    elif cc == "le": return ordered & (x <= y)
    elif cc == "gt": return ordered & (x > y)
    elif cc == "ge": return ordered & (x >= y)
    elif cc == "nlt": return unordered | (x >= y)
    elif cc == "nle": return unordered | (x > y)
    elif cc == "ngt": return unordered | (x <= y)
    elif cc == "nge": return unordered | (x < y)
    else: raise NotImplementedError(f"vector comparison {cc}")

  def _compare_vector_xmm(self, m:str) -> None:
    """AVX form of cmpps/cmpss: element-wise compare writing 0/-1 masks into the XMM/YMM dst."""
    dst, left, right = self.insn.operands
    size = 4 if m.endswith(("ss", "ps")) else 8
    count = 1 if m.endswith(("ss", "sd")) else self._vector_size(dst.reg) // size
    dt = dtypes.float32 if size == 4 else dtypes.float64
    a = [x.bitcast(dt) for x in self._read_vector_operand(left, size, count)]
    b = [x.bitcast(dt) for x in self._read_vector_operand(right, size, count)]
    values = [self._float_cond(m[4:-2], x, y).cast(UINT_DT[size]) * _c(_mask(size), UINT_DT[size]) for x,y in zip(a,b)]
    if m.endswith(("ss", "sd")): values += self._vec_read(dst.reg, size, self._vector_size(dst.reg) // size)[1:]
    self._vec_write(dst.reg, values, size)

  def _shuffle_dup(self, m:str) -> None:
    dst, src = self.insn.operands
    size = 8 if m.endswith("ddup") else 4
    values = self._read_vector_operand(src, size, self._vector_size(dst.reg) // size)
    odd = m.endswith("shdup")
    self._vec_write(dst.reg, [values[(i | 1) if odd else (i & ~1)] for i in range(len(values))], size)

  def _insert_ps(self, m:str) -> None:
    dst, left, right, imm = self.insn.operands
    values = self._vec_read(left.reg, 4)
    source = self._read_vector_operand(right, 4, 4)
    values[(imm.imm >> 4) & 3] = source[(imm.imm >> 6) & 3]
    for i in range(4):
      if imm.imm & (1 << i): values[i] = _c(0, dtypes.uint32)
    self._vec_write(dst.reg, values, 4)

  def _compare_integer_mask(self, m:str) -> None:
    dst, left, right = self.insn.operands
    size = {"b":1, "w":2, "d":4, "q":8}[m[-1]]
    body = m[5:-1]
    cc = next((cc for cc in ("neq", "nle", "nlt", "ult", "ule", "ugt", "uge", "eq", "lt", "le", "gt", "ge") if body == cc), None)
    if cc is None: raise NotImplementedError(f"integer vector comparison {m}")
    count = self._vector_size(left.reg) // size
    a, b = self._read_vector_operand(left, size, count), self._read_vector_operand(right, size, count)
    if cc[0] != "u":
      a = [x.cast(SINT_DT[size]) for x in a]
      b = [x.cast(SINT_DT[size]) for x in b]
    bits = _c(0)
    for i,(x,y) in enumerate(zip(a,b)):
      op = cc[-2:]
      cond = x.eq(y) if op == "eq" and cc != "neq" else x.ne(y) if cc == "neq" else x < y if op == "lt" else \
        x <= y if op == "le" else x > y if op == "gt" else x >= y
      bits = bits | (cond.cast(dtypes.uint64) << _c(i))
    self.stores.append(MASKS.index(_c(int(self.insn.reg_name(dst.reg)[1:]))).store(bits))

  def _insert_int(self, m:str) -> None:
    dst, left, right, imm = self.insn.operands
    size = 2 if m.endswith("w") else 4
    values = self._vec_read(left.reg, size)
    values[imm.imm] = self._read_operand(right, size)
    self._vec_write(dst.reg, values, size)

  def _extract_int(self, m:str) -> None:
    dst, src, imm = self.insn.operands
    size = 1 if m.endswith("b") else 2 if m.endswith("w") else 4
    self._write_operand(dst, self._vec_read(src.reg, size)[imm.imm])

  def _shuffle(self, m:str) -> None:
    dst, left, right, imm = self.insn.operands
    size = 4 if m.endswith("ps") else 8
    count = self._vector_size(dst.reg) // size
    a, b = self._read_vector_operand(left, size, count), self._read_vector_operand(right, size, count)
    values = []
    for base in range(0, count, 16 // size):
      if size == 4: values += [a[base+(imm.imm&3)], a[base+((imm.imm>>2)&3)], b[base+((imm.imm>>4)&3)], b[base+((imm.imm>>6)&3)]]
      else: values += [a[base+(imm.imm&1)], b[base+((imm.imm>>1)&1)]]
    self._vec_write(dst.reg, values, size)

  def _move_low_high(self, m:str) -> None:
    dst, left, right = self._vector_operands(m)
    a, b = self._vec_read(left.reg, 4), self._vec_read(right.reg, 4)
    values = a[:2] + b[:2] if m.endswith("lhps") else b[2:] + a[2:]
    self._vec_write(dst.reg, values, 4)

  def _gather(self, m:str) -> None:
    dst = self.insn.operands[0]
    mem = next(op for op in self.insn.operands if op.type == cs_x86.X86_OP_MEM)
    size = 4 if m.endswith("ps") else 8
    count = self._vector_size(dst.reg) // size
    indices = self._vec_read(mem.mem.index, 4 if m.startswith("vgatherd") else 8, count)
    base = _c(self.insn.address + self.insn.size) if mem.mem.base == cs_x86.X86_REG_RIP else \
      self._read_gpr(mem.mem.base, 8) if mem.mem.base else _c(0)
    values = []
    for index in indices:
      address = base + index.cast(dtypes.uint64) * _c(mem.mem.scale) + _c(mem.mem.disp & _mask(8))
      values.append(self._load(address, size))
    self._vec_write(dst.reg, values, size)

  def _masked_store(self, m:str) -> None:
    dst, mask, src = self.insn.operands
    size = 8 if m.endswith(("pd", "q")) else 4
    count = self._vector_size(src.reg) // size
    sign = _c(1 << (size * 8 - 1), UINT_DT[size])
    masks, values = self._vec_read(mask.reg, size, count), self._read_vector_operand(src, size, count)
    selected = [m & sign for m in masks]
    if dst.type == cs_x86.X86_OP_REG:  # masked load: masked-out elements are zeroed
      self._vec_write(dst.reg, [cond.ne(_c(0, UINT_DT[size])).where(value, _c(0, UINT_DT[size]))
                                for cond, value in zip(selected, values)], size)
    else:  # masked store: masked-out elements are left untouched
      for i, (cond, value) in enumerate(zip(selected, values)):
        address = self._address(dst.mem) + _c(i * size)
        self._store(address, cond.ne(_c(0, UINT_DT[size])).where(value, self._load(address, size)), size)

  def _insert_extract_128(self, m:str) -> None:
    dst, src, imm = self.insn.operands[-3:]
    chunk = 8 if "64x4" in m or "32x8" in m else 4
    if m.startswith("vinsert"):
      left = self.insn.operands[1]
      values = self._vec_read(left.reg, 4)
      values[imm.imm*chunk:imm.imm*chunk+chunk] = self._read_vector_operand(src, 4, chunk)
      return self._vec_write(dst.reg, values, 4)
    values = self._read_vector_operand(src, 4, self._vector_size(src.reg) // 4)[imm.imm*chunk:imm.imm*chunk+chunk]
    if dst.type == cs_x86.X86_OP_REG: return self._vec_write(dst.reg, values, 4)
    for i,value in enumerate(values): self._store(self._address(dst.mem) + _c(i*4), value, 4)

  def _permute_qwords(self, m:str) -> None:
    dst, src, imm = self.insn.operands
    values = self._read_vector_operand(src, 8, self._vector_size(src.reg) // 8)
    self._vec_write(dst.reg, [values[(imm.imm >> (2*(i%4))) & 3] for i in range(self._vector_size(dst.reg)//8)], 8)

  def _permute_two(self, m:str) -> None:
    dst, left, right = self._vector_operands(m)
    size = 4 if m.endswith(("ps", "d")) else 8
    count = self._vector_size(dst.reg) // size
    indices = self._vec_read(dst.reg, size, count)
    values = self._read_vector_operand(left, size, count) + self._read_vector_operand(right, size, count)
    permuted = []
    for index in indices:
      value = values[0]
      for i, candidate in enumerate(values[1:], 1): value = index.eq(_c(i)).where(candidate, value)
      permuted.append(value)
    self._vec_write(dst.reg, permuted, size)

  def _permute_variable(self, m:str) -> None:
    dst, indices, src = self._vector_operands(m)
    size = 4 if m.endswith("ps") else 8
    count = self._vector_size(dst.reg) // size
    source = self._read_vector_operand(src, size, count)
    values = []
    for index in self._read_vector_operand(indices, size, count):
      value = source[0]
      for i,candidate in enumerate(source[1:], 1): value = index.eq(_c(i)).where(candidate, value)
      values.append(value)
    self._vec_write(dst.reg, values, size)

  def _blend(self, m:str) -> None:
    dst, left, right, imm = self.insn.operands
    size = 4 if m.endswith(("ps", "d")) else 8
    count = self._vector_size(dst.reg) // size
    a, b = self._read_vector_operand(left, size, count), self._read_vector_operand(right, size, count)
    self._vec_write(dst.reg, [y if imm.imm & (1 << i) else x for i,(x,y) in enumerate(zip(a,b))], size)

  def _blend_variable(self, m:str) -> None:
    dst, left, right, mask = self.insn.operands
    size = 4 if m.endswith("ps") else 8
    count = self._vector_size(dst.reg) // size
    a, b = self._read_vector_operand(left, size, count), self._read_vector_operand(right, size, count)
    sign = _c(1 << (size * 8 - 1), UINT_DT[size])
    selectors = self._vec_read(mask.reg, size, count)
    self._vec_write(dst.reg, [(s & sign).ne(_c(0, UINT_DT[size])).where(y, x) for s, x, y in zip(selectors, a, b)], size)

  def _sqrt_vector(self, m:str) -> None:
    dst, src = self.insn.operands[0], self.insn.operands[-1]
    dt, size = self._float_type(m), 4 if m.endswith(("ss", "ps")) else 8
    count = 1 if m.endswith(("ss", "sd")) else self._vector_size(dst.reg) // size
    values = [value.bitcast(dt).sqrt().bitcast(UINT_DT[size]) for value in self._read_vector_operand(src, size, count)]
    self._vec_write(dst.reg, values, size)

  def _shuffle_dwords(self, m:str) -> None:
    dst, src, imm = self.insn.operands
    values = self._read_vector_operand(src, 4, self._vector_size(src.reg) // 4)
    shuffled = []
    for base in range(0, len(values), 4): shuffled += [values[base+((imm.imm >> (2*i)) & 3)] for i in range(4)]
    self._vec_write(dst.reg, shuffled, 4)

  def _shuffle_bytes(self, m:str) -> None:
    dst, src, control = self.insn.operands
    count = self._vector_size(dst.reg)
    data, controls = self._read_vector_operand(src, 1, count), self._read_vector_operand(control, 1, count)
    values = []
    for lane in range(count // 16):
      sel = data[lane * 16:(lane + 1) * 16]
      for c in controls[lane * 16:(lane + 1) * 16]:
        value = sel[0]
        for i, candidate in enumerate(sel[1:], 1): value = (c & _c(0x0f)).eq(_c(i)).where(candidate, value)
        values.append((c & _c(0x80)).eq(_c(0)).where(value, _c(0, dtypes.uint8)))
    self._vec_write(dst.reg, values, 1)

  def _shuffle_chunks(self, m:str) -> None:
    dst, left, right, imm = self.insn.operands
    count = self._vector_size(dst.reg) // 4
    a, b = self._read_vector_operand(left, 4, count), self._read_vector_operand(right, 4, count)
    values = []
    for i in range(count // 4):
      source = a if i < count // 8 else b
      selected = (imm.imm >> (2*i)) & 3
      values += source[selected*4:selected*4+4]
    self._vec_write(dst.reg, values, 4)

  def _unpack(self, m:str) -> None:
    dst, left, right = self._vector_operands(m)
    kind = m.removeprefix("v").removeprefix("punpck").removeprefix("unpck")
    size = {"bw":1, "wd":2, "dq":4, "qdq":8, "ps":4, "pd":8}[kind[1:]]
    count = self._vector_size(dst.reg) // size
    a, b = self._read_vector_operand(left, size, count), self._read_vector_operand(right, size, count)
    values = []
    for base in range(0, count, 16 // size):
      half = 8 // size
      start = base if kind.startswith("l") else base + half
      for i in range(half): values += [a[start+i], b[start+i]]
    self._vec_write(dst.reg, values, size)

  def _move_mask(self, m:str) -> None:
    dst, src = self.insn.operands
    if dst.type == cs_x86.X86_OP_MEM:
      value = MASKS.index(_c(int(self.insn.reg_name(src.reg)[1:]))).load()
      return self._store(self._address(dst.mem), value, dst.size)
    if src.type == cs_x86.X86_OP_MEM:
      value = self._load(self._address(src.mem), src.size).cast(dtypes.uint64)
      return self.stores.append(MASKS.index(_c(int(self.insn.reg_name(dst.reg)[1:]))).store(value))
    if self.insn.reg_name(dst.reg).startswith("k"):
      value = MASKS.index(_c(int(self.insn.reg_name(src.reg)[1:]))).load() if self.insn.reg_name(src.reg).startswith("k") else \
        self._read_operand(src).cast(dtypes.uint64)
      self.stores.append(MASKS.index(_c(int(self.insn.reg_name(dst.reg)[1:]))).store(value))
    else:
      value = MASKS.index(_c(int(self.insn.reg_name(src.reg)[1:]))).load()
      self._write_operand(dst, value)

  def _shift_mask(self, m:str) -> None:
    dst, src, amount = self.insn.operands
    value = MASKS.index(_c(int(self.insn.reg_name(src.reg)[1:]))).load()
    value = value << _c(amount.imm) if m.startswith("kshiftl") else value >> _c(amount.imm)
    self.stores.append(MASKS.index(_c(int(self.insn.reg_name(dst.reg)[1:]))).store(value))

  def _logic_mask(self, m:str) -> None:
    if m.startswith("knot"):
      dst, src = self.insn.operands
      values = [~MASKS.index(_c(int(self.insn.reg_name(src.reg)[1:]))).load()]
    else:
      dst, left, right = self.insn.operands
      a = MASKS.index(_c(int(self.insn.reg_name(left.reg)[1:]))).load()
      b = MASKS.index(_c(int(self.insn.reg_name(right.reg)[1:]))).load()
      values = [(a | b) if m.startswith("kor") else (a & b) if m.startswith("kand") else ~(a ^ b) if m.startswith("kxnor") else (a ^ b)]
    self.stores.append(MASKS.index(_c(int(self.insn.reg_name(dst.reg)[1:]))).store(values[0]))

  def _read_xmm(self, op, m:str) -> UOp:
    dt, size = self._float_type(m), 4 if m.endswith("ss") else 8
    if op.type == cs_x86.X86_OP_REG:
      bits = XMM.index(_c(self._xmm_number(op.reg) * 8)).load()
      return bits.cast(dtypes.uint32).bitcast(dt) if size == 4 else bits.bitcast(dt)
    bits = self._read_operand(op, size)
    return bits.bitcast(dt)

  def _write_xmm(self, reg:int, value:UOp, m:str) -> None:
    self._vec_write(reg, [value.bitcast(dtypes.uint32 if m.endswith("ss") else dtypes.uint64)], 4 if m.endswith("ss") else 8)

  def _move_xmm(self, m:str) -> None:
    ops = [op for op in self.insn.operands if op.type != cs_x86.X86_OP_REG or not self.insn.reg_name(op.reg).startswith("k")]
    dst, src = ops[0], ops[-1]
    value = self._read_xmm(src, m)
    if dst.type == cs_x86.X86_OP_REG: self._write_xmm(dst.reg, value, m)
    else: self._store(self._address(dst.mem), value.bitcast(UINT_DT[dst.size]), dst.size)

  def _binary_xmm(self, m:str) -> None:
    ops = [op for op in self.insn.operands if op.type != cs_x86.X86_OP_REG or not self.insn.reg_name(op.reg).startswith("k")]
    dst, left, right = (ops[0], ops[0], ops[1]) if len(ops) == 2 else (ops[0], ops[1], ops[2])
    a, b = self._read_xmm(left, m), self._read_xmm(right, m)
    op = m.removeprefix("v")
    result = a + b if op.startswith("add") else a - b if op.startswith("sub") else a * b if op.startswith("mul") else \
      a / b if op.startswith("div") else a.minimum(b) if op.startswith("min") else a.maximum(b)
    self._write_xmm(dst.reg, result, m)

  def _compare_xmm(self, m:str) -> None:
    a, b = [self._read_xmm(op, m) for op in self.insn.operands]
    unordered = a.ne(a) | b.ne(b)
    self._set_flag(ZF, unordered | a.eq(b))
    self._set_flag(PF, unordered)
    self._set_flag(CF, unordered | (a < b))
    for flag in (OF, SF, AF): self._set_flag(flag, _c(0, dtypes.bool))

COND_TAKEN, COND_NOT_TAKEN, UNCOND = range(3)

def lift(calls:list[UOp], base:int=0, name:str="x86") -> UOp:
  """Lift decoded x86 CALLs into the routed CFG structure shared with the AMD emulator."""
  insts = {call.body.arg.code.address:call.body.arg.code for call in calls}
  leaders = {base}
  for insn in insts.values():
    if X86Machine._is_branch(insn):
      if insn.group(cs_x86.X86_GRP_JUMP) and insn.operands[0].type == cs_x86.X86_OP_IMM: leaders.add(insn.operands[0].imm)
      leaders.add(insn.address + insn.size)
  starts = sorted(leaders & insts.keys())
  blocks:dict[int, list[int]] = {}
  paths:dict[int, dict[int, int]] = {}
  for i, start in enumerate(starts):
    end = starts[i+1] if i+1 < len(starts) else calls[-1].body.arg.code.address + calls[-1].body.arg.code.size
    blocks[start] = [pc for pc in insts if start <= pc < end]
    last = insts[blocks[start][-1]]
    fallthrough = last.address + last.size
    if last.group(cs_x86.X86_GRP_RET): paths[start] = {}
    elif last.group(cs_x86.X86_GRP_CALL): paths[start] = {fallthrough:UNCOND}
    elif last.group(cs_x86.X86_GRP_JUMP):
      target = last.operands[0].imm
      paths[start] = {target:UNCOND} if last.mnemonic == "jmp" else {target:COND_TAKEN, fallthrough:COND_NOT_TAKEN}
    else: paths[start] = {fallthrough:UNCOND} if fallthrough in insts else {}
  regions = cfg_regions(paths, base)

  # One route slot is the x86 RIP. AMD uses the same structure with one route per wave.
  routes = UOp.alloc((1,), dtypes.uint64, 6, AddrSpace.REG)
  active = UOp.alloc((1,), dtypes.bool, 7, AddrSpace.REG)
  route = UOp.param(6, dtypes.uint64, (1,), name="route")
  taken = UOp.param(7, dtypes.uint64, name="taken", addrspace=AddrSpace.ALU)
  fallthrough = UOp.param(8, dtypes.uint64, name="fallthrough", addrspace=AddrSpace.ALU)
  buffers = {REGS:REGS, XMM:XMM, FLAGS:FLAGS, VMEM:VMEM, MASKS:MASKS, route:routes}
  initialized = routes.index(_c(0, dtypes.int)).store(_c(base))
  axes = itertools.count(10)

  def emit_block(block_pc:int, end:UOp, scopes:tuple[UOp, ...]) -> UOp:
    cond = UOp.const(True)
    instructions = []
    by_address = {call.body.arg.code.address:call for call in calls}
    for pc in blocks[block_pc]:
      call, branch_cond = instruction_call(by_address[pc])
      if branch_cond is not None: cond = branch_cond
      instructions.append(call)
    values:dict[UOp, UOp] = {}
    dsts = {kind:dst for dst,kind in paths[block_pc].items()}
    target = cond.where(taken, fallthrough) if len(dsts) == 2 else taken
    values.update({taken:_c(dsts[COND_TAKEN]), fallthrough:_c(dsts[COND_NOT_TAKEN])} if len(dsts) == 2
                  else {taken:_c(next(iter(dsts.values()), -1))})
    instructions.append(lower_body(route[0].store(target).sink(), "x86_branch"))
    body, bufs = instruction_block(instructions, STATE)
    args = [values[b] if b.addrspace is AddrSpace.ALU else buffers[b] for b in bufs]
    args += [_c(block_pc).after(end, *scopes)]
    params = [UOp.param(i, a.dtype, a.shape, addrspace=AddrSpace.ALU if i >= len(bufs) or bufs[i].addrspace is AddrSpace.ALU
                        else AddrSpace.GLOBAL, name=bufs[i].arg.name if i < len(bufs) else None) for i,a in enumerate(args)]
    w = UOp.range(1, 0, dtype=dtypes.int)
    gates = (UOp.range(params[bufs.index(route)][0].load().eq(params[-1]).cast(dtypes.uint64), 1, dtype=dtypes.int),)
    call_args = [p if b.addrspace is AddrSpace.ALU else p.after(*gates, w) for b,p in zip(bufs, params)]
    block = UOp.group(body.call(*call_args), *gates, w).end(*gates).end(w).sink(arg=KernelInfo("x86_block", optimized=True))
    return block.call(*args)

  return emit_cfg(regions, routes, active, _c(1), axes, emit_block, initialized).sink(VMEM, arg=KernelInfo(name, optimized=True))

class X86Machine:
  """A decoded function lifted to one CPU program. Integer arguments use the SysV register ABI."""
  def __init__(self, code:bytes, base:int=0):
    self.code, self.base = code, base
    self.calls = decode(code, base)
    self.insns = {call.body.arg.code.address:call.body.arg.code for call in self.calls}
    with Context(DEV="CPU:CLANG", NOOPT=1, CHECK_OOB=0, EMULATED_DTYPES=""):
      self.prg = to_program(lift(self.calls, base, "x86_function"), Device["CPU"].renderer)

  @staticmethod
  def _is_branch(insn:CsInsn) -> bool:
    return insn.group(cs_x86.X86_GRP_JUMP) or insn.group(cs_x86.X86_GRP_RET) or insn.group(cs_x86.X86_GRP_CALL)

  def _buffer(self, ptr:int, size:int, dt) -> UOp:
    return UOp.from_buffer(Buffer("CPU", size * dt.itemsize, options=BufferSpec(external_ptr=ptr), preallocate=True), dt)

  def reset(self, stack_size:int=4096) -> None:
    self._regs, self._xmm = (ctypes.c_uint64 * 16)(), (ctypes.c_uint64 * 256)()
    self._flags, self._masks = (ctypes.c_uint64 * 6)(), (ctypes.c_uint64 * 8)()
    self._stack = (ctypes.c_uint8 * stack_size)()
    stack_top = ((ctypes.addressof(self._stack) + stack_size - 16) & ~0xf) + 8  # SysV function-entry alignment
    self._regs[GPR_NAMES.index("rsp")] = stack_top
    self._state = {
      0:self._buffer(ctypes.addressof(self._regs), 16, dtypes.uint64),
      1:self._buffer(ctypes.addressof(self._xmm), 256, dtypes.uint64),
      2:self._buffer(ctypes.addressof(self._flags), 6, dtypes.uint64),
      3:self._buffer(0, 1 << 48, dtypes.uint8),
      4:self._buffer(ctypes.addressof(self._masks), 8, dtypes.uint64),
    }

  def run(self, *args:int) -> int:
    self.reset()
    for reg, value in zip(("rdi", "rsi", "rdx", "rcx", "r8", "r9"), args): self._regs[GPR_NAMES.index(reg)] = value & _mask(8)
    return self._run()

  def run_abi(self, args_ptr:int) -> int:
    """Run a tinygrad CPU kernel, whose sole System V argument is the packed kernargs pointer."""
    self.reset()
    self._regs[GPR_NAMES.index("rdi")] = args_ptr
    return self._run()

  def run_i32(self, *args:int) -> int: return ctypes.c_int32(self.run(*args)).value
  def run_f32(self, *args:float) -> float:
    self.reset()
    for i, value in enumerate(args): self._xmm[i*8] = ctypes.c_uint32.from_buffer(ctypes.c_float(value)).value
    self._run()
    return ctypes.c_float.from_buffer(ctypes.c_uint32(self._xmm[0] & 0xffffffff)).value

  def run_f64(self, *args:float) -> float:
    self.reset()
    for i, value in enumerate(args): self._xmm[i*8] = ctypes.c_uint64.from_buffer(ctypes.c_double(value)).value
    self._run()
    return ctypes.c_double.from_buffer(ctypes.c_uint64(self._xmm[0])).value

  def _run(self) -> int:
    with Context(DEV="CPU:LLVM", NOOPT=1, CHECK_OOB=0, EMULATED_DTYPES=""):
      args = [self._state[3]] * (max(p.arg.slot for p in self.prg.kernel_params) + 1)
      for p in self.prg.kernel_params: args[p.arg.slot] = self._state[p.arg.slot]
      run_program(self.prg, args)
    return self._regs[0]
