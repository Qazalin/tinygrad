import unittest
import ctypes, subprocess, tempfile, pickle, sys, itertools
from tinygrad import dtypes
from tinygrad.dtype import AddrSpace
from tinygrad.helpers import Context
from tinygrad.codegen import to_program
from tinygrad.device import Device, TinyELF
from tinygrad.engine.realize import get_runtime
from tinygrad.uop.ops import UOp, KernelInfo


class TestCallJIT(unittest.TestCase):
  def test_default_names_resolve_to_their_own_module(self):
    out = UOp.param(0, dtypes.int, (2,))
    value = UOp.param(1, dtypes.int, addrspace=AddrSpace.ALU)
    for backend, name in itertools.product(("CPU:LLVM", "CPU:CLANG"), ("test", "asm_waves")):
      with self.subTest(backend=backend, name=name), Context(DEV=backend):
        renderer = Device["CPU"].renderer
        with Context(ALLOW_DEVICE_USAGE=0):
          programs = []
          for v in (7, 19):
            calls = (out[0].store(v).sink().call(out, name=name), out[1].store(value).sink().call(out, UOp.const(v+1, dtypes.int), name=name))
            programs.append(to_program(UOp.sink(*(c.sink().call(out, name=name) for c in calls), arg=KernelInfo(name)), renderer))
        self.assertEqual(programs[0].to_elf().name, programs[1].to_elf().name)
        self.assertEqual(programs[0].src[3].arg, programs[1].src[3].arg)
        if backend == "CPU:CLANG": self.assertIn("extern void __tinygrad_call_", programs[0].src[2].arg)
        for prg, expected in zip(programs, (7, 19)):
          result = (ctypes.c_int * 2)()
          get_runtime("CPU", prg)(ctypes.addressof(result))
          self.assertEqual(list(result), [expected, expected+1])

  @Context(DEV="CPU:LLVM")
  def test_static_functions_are_not_exported(self):
    from tinygrad.runtime.support.elf import elf_sections, elf_symbols
    compiler = Device["CPU"].compiler
    lib = compiler.compile_cached("define internal void @asm_fn_local(ptr %out) noinline { store i32 41, ptr %out\n ret void }\n"
                                  "define void @asm_fn_entry(ptr %out) noinline { call void @asm_fn_local(ptr %out)\n"
                                  "%x = load i32, ptr %out\n %y = add i32 %x, 1\n store i32 %y, ptr %out\n ret void }")
    # ELF permits local and global symbols to share a name; their table indices still identify distinct functions.
    lib = lib.replace(b"asm_fn_entry\x00", b"asm_fn_local\x00")
    runtime = Device["CPU"].runtime(TinyELF(lib, "asm_fn_entry", Device["CPU"].renderer.target, ()))
    symbols = elf_symbols(*elf_sections(lib))
    self.assertEqual([symbols[i][0] for i in runtime.exports], ["asm_fn_local"])
    self.assertEqual(sum(name == "asm_fn_local" for name,_ in symbols), 2)
    result = ctypes.c_int()
    ctypes.CFUNCTYPE(None, ctypes.c_void_p)(runtime.entry)(ctypes.addressof(result))
    self.assertEqual(result.value, 42)

  @Context(DEV="CPU:LLVM")
  def test_program_preserves_elf(self):
    out = UOp.param(0, dtypes.int, (1,))
    prg = to_program(out[0].store(7).sink().call(out, name="store").sink(arg=KernelInfo(name="jit_store")), Device["CPU"].renderer)
    with tempfile.NamedTemporaryFile() as f:
      f.write(prg.src[3].arg)
      f.flush()
      subprocess.run(["objdump", "-d", f.name], check=True)
    result = ctypes.c_int()
    runtime = get_runtime("CPU", prg)
    self.assertEqual(runtime.profile_key, prg.key)
    runtime(ctypes.addressof(result))
    self.assertEqual(result.value, 7)
    # The compiled artifact loads in another process without reconstructing its renderer or compiler caches.
    subprocess.run([sys.executable, "-c", """
import ctypes, pickle, sys
from tinygrad.device import Device
obj = pickle.loads(sys.stdin.buffer.read())
out = ctypes.c_int()
Device['CPU'].runtime(obj)(ctypes.addressof(out))
assert out.value == 7
"""], input=pickle.dumps(prg.to_elf()), check=True)


if __name__ == "__main__": unittest.main()
