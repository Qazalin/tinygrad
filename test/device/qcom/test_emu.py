import ctypes, os, struct, tempfile, unittest
import numpy as np
from tinygrad import Tensor, dtypes
from tinygrad.codegen import to_program
from tinygrad.helpers import Target
from tinygrad.renderer import TinyELF
from tinygrad.runtime.autogen import libc, mesa
from tinygrad.uop.ops import Ops
from test.mockgpu.qcom.ins import IR3Cond, IR3Type
from test.mockgpu.qcom.emu import decode_inst, decode_insts, instruction_call, ir3, lift, run_qcom_asm

def _msrc(val:int, kind:str = "reg", neg:bool = False, ab:bool = False) -> int:
  k, m = (0x1000, 0x7ff) if kind == "const" else ((0x2000, 0xfff) if kind == "imm" else (0, 0xff))
  return k | (0x4000 if neg else 0) | (0x8000 if ab else 0) | (val & m)
def _movi(dst:int, src:int, t:IR3Type = IR3Type.U32): return ir3("mov-immed", src_type=t, dst_type=t, dst=dst, src=src)
def _load_ptr(dst:int, ptr:int): return [_movi(dst, ptr & 0xffffffff), _movi(dst + 1, (ptr >> 32) & 0xffffffff)]
def _stib_2d(src:int, coord:int, uav:int, is_f16:bool = False):
  return ir3("stib.b", src1=src, src2=coord, ssbo=uav, type=IR3Type.F16 if is_f16 else IR3Type.F32, typed=1, d_minus_one=1, type_size_minus_one=3)

def _tex_desc(ptr:int, w:int, h:int, pitch:int, esz:int) -> bytes:
  fmt = mesa.FMT6_32_32_32_32_FLOAT if esz == 4 else mesa.FMT6_16_16_16_16_FLOAT
  w0 = (fmt << mesa.A6XX_TEX_CONST_0_FMT__SHIFT) & mesa.A6XX_TEX_CONST_0_FMT__MASK
  w1 = (((w << mesa.A6XX_TEX_CONST_1_WIDTH__SHIFT) & mesa.A6XX_TEX_CONST_1_WIDTH__MASK) |
        ((h << mesa.A6XX_TEX_CONST_1_HEIGHT__SHIFT) & mesa.A6XX_TEX_CONST_1_HEIGHT__MASK))
  w2 = (pitch << mesa.A6XX_TEX_CONST_2_PITCH__SHIFT) & mesa.A6XX_TEX_CONST_2_PITCH__MASK
  return struct.pack("<16I", w0, w1, w2, 0, ptr & 0xffffffff, (ptr >> 32) & 0xffffffff, *([0] * 10))

def _exec(insts, lx=1, tex_desc=b"", n_tex=0, ibo_desc=b"", n_ibo=0, shmem=0, pvtmem=0, mergedregs=False):
  bufs = [ctypes.create_string_buffer(b) if b else None for b in (b"".join(x.to_bytes() for x in insts), tex_desc, ibo_desc)]
  addrs = [ctypes.addressof(b) if b is not None else 0 for b in bufs]
  run_qcom_asm(addrs[0], len(insts) * 8, 1, 1, 1, lx, 1, 1, tex_addr=addrs[1], n_tex=n_tex, ibo_addr=addrs[2], n_ibo=n_ibo,
               shmem=shmem, pvtmem=pvtmem, mergedregs=mergedregs)

class TestQCOMEmu(unittest.TestCase):
  def test_decode_mesa_disasm_and_roundtrip(self):
    samples = [
      ir3("nop", repeat=2, ss=1, sy=1, jp=1), ir3("end"), ir3("jump", immed=-4), ir3("br", immed=3, inv1=1, comp1=2),
      ir3("brao", immed=2, comp1=0, comp2=1, inv2=1), ir3("predt"), ir3("predf"), ir3("prede"), ir3("bar", w=1, r=1, l=1, g=1),
      ir3("mov-gpr", src_type=IR3Type.U8, dst_type=IR3Type.S16, dst=4, src=8),
      ir3("mov-gpr", src_type=IR3Type.U8_32, dst_type=IR3Type.U32, dst=4, src=8), _movi(4, 0x12345678),
      ir3("swz", src_type=IR3Type.U32, dst_type=IR3Type.U32, dst0=4, dst1=5, src0=6, src1=7),
      ir3("add.f", dst=4, src1=_msrc(0x803, "imm"), src2=_msrc(8, "reg", neg=True, ab=True), full=1, sat=1),
      ir3("cmps.s", dst=0xf8, src1=0, src2=_msrc(-5, "imm"), full=1, cond=IR3Cond.GE),
      ir3("mad.f32", dst=4, src1=8, src2=12, src3=16, sat=1), ir3("shrg", dst=4, src1=0x101e, src2=8, src3=12, full=1),
      ir3("exp2", dst=4, src=8, full=1, sat=1), ir3("isam", dst=4, src1=8, tex=1, samp=0, type=IR3Type.F32, _1d=1, wrmask=0xf, full=1),
      ir3("ldg", dst=4, src1=8, size=4, off=-16, type=IR3Type.U32), ir3("ldg", dst=4, src1=8, size=1, off=0, type=IR3Type.U8_32),
      ir3("stp", dst=4, src=8, size=1, off_lo=(-64) & 0xff, off_hi=(-64) >> 8, type=IR3Type.U32), _stib_2d(4, 8, 2),
    ]
    raw = b"".join(s.to_bytes() for s in samples)
    self.assertEqual(len(decode_insts(raw)), len(samples))
    for ins in samples:
      self.assertEqual(decode_inst(ins.to_bytes()), ins)
      if (call := instruction_call(ins)[0]) is not None:
        self.assertEqual((call.op, call.body.op, call.body.arg.code, call.body.src[0].op), (Ops.CALL, Ops.NATIVE, ins, Ops.SINK))
    # Dynamic register/sync bits share one compiled body; reg >= 128 (r48/p0) stays distinct
    c1, c2 = instruction_call(ir3("add.u", dst=4, src1=8, src2=12, full=1, sy=1))[0], instruction_call(ir3("add.u", dst=9, src1=2, src2=3, full=1))[0]
    c_hi = instruction_call(ir3("add.u", dst=4, src1=0xc0, src2=12, full=1))[0]
    assert c1 is not None and c2 is not None and c_hi is not None
    self.assertIs(c1.body.src[0], c2.body.src[0])
    self.assertIsNot(c1.body.src[0], c_hi.body.src[0])
    try:
      from tinygrad.renderer.nir import IR3Renderer
      from tinygrad.runtime.support.compiler_mesa import IR3Compiler
      with tempfile.TemporaryFile() as f:
        fp = libc.fdopen(os.dup(f.fileno()), b"w+")
        try:
          buf = (ctypes.c_uint32 * (len(raw) // 4)).from_buffer_copy(raw)
          mesa.ir3_isa_disasm(buf, len(raw), ctypes.cast(fp, ctypes.POINTER(mesa.struct__IO_FILE)),
                              ctypes.byref(mesa.struct_isa_decode_options(gpu_id=630, show_errors=True)))
          libc.fflush(fp)
        finally: libc.fclose(fp)
        f.seek(0)
        dis = f.read().decode("utf-8")
      for bad in ("no match", "WARNING", "dontcare"): self.assertNotIn(bad, dis)
      renderer = IR3Renderer(Target("QCOM", "IR3", "a630"))
      for t in ((Tensor.empty(16) + Tensor.empty(16)).elu(), Tensor.empty(16, dtype=dtypes.int8) < Tensor.empty(16, dtype=dtypes.int8),
                Tensor.empty(16, dtype=dtypes.int64).cast(dtypes.float32), Tensor.empty(64, 64).sum()):
        insts = decode_insts(IR3Compiler.unpack_lib(TinyELF.from_program(to_program(t.schedule_linear().src[-1].src[0], renderer)).lib)[3])
        self.assertTrue(insts and all(decode_inst(i.to_bytes()) == i for i in insts))
    except (ImportError, OSError): self.skipTest("tinymesa not installed")

  def test_error_guards_and_mergedregs(self):
    for ins in (ir3("mov-relgpr", src_type=IR3Type.U32, dst_type=IR3Type.U32, dst=0, src=0),
                ir3("sam", dst=0, src1=0, tex=0, samp=0, type=IR3Type.F32, wrmask=0xf), ir3("ldlw", dst=0, src=0, size=1, off=0, type=IR3Type.U32),
                ir3("atomic.b.add", src1=0, src2=0, ssbo=0, type=IR3Type.U32), ir3("stib.b", src1=0, src2=0, ssbo=0, type=IR3Type.U32, typed=0),
                ir3("add.f", dst=0, src1=_msrc(0x80f, "imm"), src2=0, full=1), ir3("bany", immed=1)):
      with self.assertRaises(NotImplementedError): instruction_call(ins)
    with self.assertRaises(ValueError): instruction_call(_movi(0xd0, 0))
    with self.assertRaises(ValueError):
      lift(b"".join(x.to_bytes() for x in [ir3("br", immed=99), ir3("end")]), (1, 1, 1, 1, 1, 1, 0, 0, False, 0xc0, 0))
    for merged in (False, True):
      out = (ctypes.c_uint32 * 1)()
      _exec([*_load_ptr(4, ctypes.addressof(out)), _movi(0, 0x11223344), _movi(0, 0xaaaa, IR3Type.U16),
             ir3("stg", src1=4, src3=0, size=1, off_lo=0, off_hi=0, type=IR3Type.U32), ir3("end")], mergedregs=merged)
      self.assertEqual(out[0], 0x1122aaaa if merged else 0x11223344)
    # Early END + trailing garbage ignored; OOB LDS/PVT reads return 0 without faulting
    out = (ctypes.c_uint32 * 3)(0xdeadbeef, 0xdeadbeef, 0xdeadbeef)
    insts = [*_load_ptr(4, ctypes.addressof(out)), ir3("cmps.s", dst=0xf8, src1=0, src2=_msrc(0, "imm"), full=1, cond=IR3Cond.EQ),
             ir3("br", immed=2), ir3("end"), _movi(6, 4096), _movi(7, 42),
             ir3("stl", dst=6, src=7, size=1, off_lo=0, off_hi=0, type=IR3Type.U32), ir3("ldl", dst=8, src=6, size=1, off=0, type=IR3Type.U32),
             ir3("stp", dst=6, src=7, size=1, off_lo=0, off_hi=0, type=IR3Type.U32), ir3("ldp", dst=9, src=6, size=1, off=0, type=IR3Type.U32),
             ir3("stg", src1=4, src3=7, size=3, off_lo=0, off_hi=0, type=IR3Type.U32), ir3("end")]
    raw = b"".join(x.to_bytes() for x in insts) + b"\xff" * 16
    buf = ctypes.create_string_buffer(raw)
    run_qcom_asm(ctypes.addressof(buf), len(raw), 1, 1, 1, 1, 1, 1, shmem=16, pvtmem=16)
    self.assertEqual(list(out), [42, 0, 0])

  def test_private_neg_offset_and_image_uav_border(self):
    out = (ctypes.c_uint32 * 1)()
    _exec([*_load_ptr(4, ctypes.addressof(out)), _movi(6, 64), ir3("add.u", dst=7, src1=0, src2=_msrc(1, "imm"), full=1),
           ir3("stp", dst=6, src=7, size=1, off_lo=(-64) & 0xff, off_hi=(-64) >> 8, type=IR3Type.U32),
           ir3("ldp", dst=8, src=6, size=1, off=-64, type=IR3Type.U32),
           ir3("shl.b", dst=9, src1=0, src2=_msrc(2, "imm"), full=1), ir3("stl", dst=9, src=8, size=1, off_lo=0, off_hi=0, type=IR3Type.U32),
           ir3("bar", w=1, r=1, l=1, g=1), ir3("cmps.s", dst=0xf8, src1=0, src2=_msrc(0, "imm"), full=1, cond=IR3Cond.EQ),
           ir3("predt"), _movi(6, 0), ir3("ldl", dst=10, src=6, size=4, off=0, type=IR3Type.U32),
           ir3("add.u", dst=10, src1=10, src2=11, full=1), ir3("add.u", dst=10, src1=10, src2=12, full=1),
           ir3("add.u", dst=10, src1=10, src2=13, full=1), ir3("stg", src1=4, src3=10, size=1, off_lo=0, off_hi=0, type=IR3Type.U32),
           ir3("prede"), ir3("end")], lx=4, shmem=1024, pvtmem=512)
    self.assertEqual(out[0], 10)
    tex, uav = np.arange(16, dtype=np.float32).reshape(2, 2, 4), np.full((2, 2, 4), -1.0, dtype=np.float32)
    _exec([ir3("add.u", dst=4, src1=0, src2=_msrc(1, "imm"), full=1), ir3("sub.u", dst=5, src1=_msrc(1, "imm"), src2=0, full=1),
           ir3("isam", dst=8, src1=4, tex=0, samp=0, type=IR3Type.F32, _1d=1, wrmask=0xf, full=1),
           ir3("mov-gpr", src_type=IR3Type.U32, dst_type=IR3Type.U32, dst=6, src=0), _movi(7, 0), _stib_2d(8, 6, uav=1), ir3("end")],
          lx=2, tex_desc=_tex_desc(int(tex.ctypes.data), 2, 2, 32, 4), n_tex=1,
          ibo_desc=bytes(64) + _tex_desc(int(uav.ctypes.data), 2, 2, 32, 4), n_ibo=2)
    np.testing.assert_array_equal(uav[0, 0], tex[1, 1])
    np.testing.assert_array_equal(uav[0, 1], np.zeros(4, dtype=np.float32))
    np.testing.assert_array_equal(uav[1, 0], np.full(4, -1.0, dtype=np.float32))
    for cx, tex_slot, is_f16, tdesc, ntex in ((5, 0, True, _tex_desc(0, 2, 2, 16, 2), 1), (0, 5, False, b"", 0)):
      uav_z = np.full((1, 1, 4), -1.0, dtype=np.float32)
      dt = IR3Type.F16 if is_f16 else IR3Type.F32
      _exec([_movi(4, cx), _movi(5, 0), ir3("isam", dst=8, src1=4, tex=tex_slot, samp=0, type=dt, _1d=1, wrmask=0xf, full=1),
             _movi(6, 0), _movi(7, 0), _stib_2d(8, 6, uav=0, is_f16=is_f16), ir3("end")],
            tex_desc=tdesc, n_tex=ntex, ibo_desc=_tex_desc(int(uav_z.ctypes.data), 1, 1, 16, 4), n_ibo=1)
      np.testing.assert_array_equal(uav_z[0, 0], np.zeros(4, dtype=np.float32))

if __name__ == "__main__":
  unittest.main()
