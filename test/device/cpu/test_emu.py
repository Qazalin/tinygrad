import ctypes, platform, shutil, subprocess, tempfile, unittest
from pathlib import Path

from tinygrad.uop import Ops
from test.device.cpu.emu import X86Machine, decode, attach_body, instruction_call

CLANG_FLAGS = ["-fno-stack-protector", "-fno-asynchronous-unwind-tables", "-fcf-protection=none"]

def compile_program(source:str, opt:str="-O1", language:str="c") -> tuple[bytes, ctypes.CDLL]:
  """Return raw .text and a native shared-library reference for one function named entry."""
  with tempfile.TemporaryDirectory() as td:
    obj, lib = Path(td)/"program.o", Path(td)/"program.so"
    subprocess.run(["clang", "-x", language, opt, *CLANG_FLAGS, "-c", "-", "-o", str(obj)], input=source.encode(), check=True)
    code = subprocess.check_output(["objcopy", "-O", "binary", "--only-section=.text", str(obj), "/dev/stdout"])
    subprocess.run(["clang", "-x", language, opt, *CLANG_FLAGS, "-shared", "-fPIC", "-", "-o", str(lib)], input=source.encode(), check=True)
    return code, ctypes.CDLL(str(lib))

@unittest.skipUnless(platform.machine().lower() in ("x86_64", "amd64") and shutil.which("clang") and shutil.which("objcopy"),
                     "needs x86-64, clang, and objcopy")
class TestX86Emulator(unittest.TestCase):
  def test_native_decode_and_uop_bodies(self):
    calls = decode(bytes.fromhex("8d0437c3"))  # lea eax, [rdi+rsi]; ret
    self.assertTrue(all(call.op is Ops.CALL and call.body.op is Ops.NATIVE for call in calls))
    attached = [attach_body(call) for call in calls]
    self.assertTrue(all(call.body.op is Ops.NATIVE and call.body.src[0].op is Ops.SINK for call in attached))
    lowered = [instruction_call(call)[0] for call in calls]
    self.assertFalse(any(u.op is Ops.NATIVE for call in lowered for u in call.toposort()))
    self.assertEqual(X86Machine(bytes.fromhex("8d0437c3")).run_i32(20, 22), 42)

  def test_clang_integer_arithmetic(self):
    code, lib = compile_program("long entry(long a, long b, long c) { return (a*b+c) ^ (a >> 3); }")
    fn = lib.entry
    fn.argtypes, fn.restype = [ctypes.c_int64]*3, ctypes.c_int64
    machine = X86Machine(code)
    for args in ((2, 3, 4), (-19, 7, 123), (0x12345678, -99, 1000)):
      with self.subTest(args=args):
        self.assertEqual(ctypes.c_int64(machine.run(*args)).value, fn(*args))

  def test_clang_conditional_move(self):
    code, lib = compile_program("int entry(int a, int b) { return a > b ? a : b; }")
    fn = lib.entry
    fn.argtypes, fn.restype = [ctypes.c_int]*2, ctypes.c_int
    machine = X86Machine(code)
    for args in ((3, 9), (9, 3), (-2, -7), (-7, -2), (4, 4)):
      with self.subTest(args=args): self.assertEqual(machine.run_i32(*args), fn(*args))

  def test_clang_loop(self):
    code, lib = compile_program("int entry(int n) { int a=0,b=1; while(n--) { int t=a+b; a=b; b=t; } return a; }")
    fn = lib.entry
    fn.argtypes, fn.restype = [ctypes.c_int], ctypes.c_int
    machine = X86Machine(code)
    for n in (0, 1, 2, 10, 20):
      with self.subTest(n=n): self.assertEqual(machine.run_i32(n), fn(n))

  def test_clang_memory(self):
    code, lib = compile_program("int entry(int *a, const int *b) { *a += *b; return *a; }")
    fn = lib.entry
    fn.argtypes, fn.restype = [ctypes.POINTER(ctypes.c_int), ctypes.POINTER(ctypes.c_int)], ctypes.c_int
    machine = X86Machine(code)
    for x, y in ((20, 22), (-10, 3), (100, -7)):
      a0, a1, b = ctypes.c_int(x), ctypes.c_int(x), ctypes.c_int(y)
      expected = fn(ctypes.byref(a0), ctypes.byref(b))
      got = machine.run_i32(ctypes.addressof(a1), ctypes.addressof(b))
      with self.subTest(x=x, y=y): self.assertEqual((got, a1.value), (expected, a0.value))

  def test_clang_o0_stack_frame(self):
    code, lib = compile_program("int entry(int a, int b) { return a+b; }", opt="-O0")
    fn = lib.entry
    fn.argtypes, fn.restype = [ctypes.c_int]*2, ctypes.c_int
    machine = X86Machine(code)
    self.assertIn("push", [call.body.arg.code.mnemonic for call in machine.calls])
    for args in ((20, 22), (-100, 3)):
      with self.subTest(args=args): self.assertEqual(machine.run_i32(*args), fn(*args))

  def test_clang_signed_division(self):
    code, lib = compile_program("int entry(int a, int b) { return a/b + a%b; }")
    fn = lib.entry
    fn.argtypes, fn.restype = [ctypes.c_int]*2, ctypes.c_int
    machine = X86Machine(code)
    for args in ((100, 7), (-100, 7), (100, -7), (-100, -7)):
      with self.subTest(args=args): self.assertEqual(machine.run_i32(*args), fn(*args))

  def test_clang_scalar_sse(self):
    f32, lib32 = compile_program("float entry(float a, float b, float c) { return a*b+c; }")
    fn32 = lib32.entry
    fn32.argtypes, fn32.restype = [ctypes.c_float]*3, ctypes.c_float
    machine32 = X86Machine(f32)
    self.assertAlmostEqual(machine32.run_f32(1.5, 2.0, 3.25), fn32(1.5, 2.0, 3.25), places=6)

    f64, lib64 = compile_program("double entry(double a, double b) { return a/b; }")
    fn64 = lib64.entry
    fn64.argtypes, fn64.restype = [ctypes.c_double]*2, ctypes.c_double
    machine64 = X86Machine(f64)
    self.assertAlmostEqual(machine64.run_f64(7.0, 2.0), fn64(7.0, 2.0), places=12)

  def test_llvm_ir(self):
    code, lib = compile_program("""
      define i32 @entry(i32 %a, i32 %b) {
      start:
        %sum = add i32 %a, %b
        %positive = icmp sgt i32 %sum, 0
        br i1 %positive, label %yes, label %no
      yes:
        ret i32 %sum
      no:
        %neg = sub i32 0, %sum
        ret i32 %neg
      }
    """, language="ir")
    fn = lib.entry
    fn.argtypes, fn.restype = [ctypes.c_int]*2, ctypes.c_int
    machine = X86Machine(code)
    for args in ((20, 22), (-20, 3), (5, -9), (-4, 4)):
      with self.subTest(args=args): self.assertEqual(machine.run_i32(*args), fn(*args))

if __name__ == "__main__": unittest.main()
