import unittest, subprocess, platform
from tinygrad.runtime.support.compiler_cpu import ClangCompiler
from tinygrad.runtime.support.elf import elf_loader
from tinygrad.runtime.support.c import DLL

class TestElfLoader(unittest.TestCase):
  def test_load_clang_jit_strtab(self):
    src = '''
      int something; // will be a load from a relocation (needed for .rela.text to exist)
      int test(int x) {
        return something + x;
      }
    '''
    args = ('-x', 'c', '-c', '-target', f'{platform.machine()}-none-unknown-elf', '-march=native', '-fPIC', '-O2', '-ffreestanding', '-nostdlib')
    obj = subprocess.check_output(('clang',) + args + ('-', '-o', '-'), input=src.encode('utf-8'))
    _, sections, _ = elf_loader(obj)
    section_names = [sh.name for sh in sections]
    assert '.text' in section_names and '.rela.text' in section_names, str(section_names)
  def test_clang_jit_compiler_external_raise(self):
    src = '''
      int evil_external_function(int);
      int test(int x) {
        return evil_external_function(x+2)*2;
      }
    '''
    with self.assertRaisesRegex(RuntimeError, 'evil_external_function'):
      elf_loader(ClangCompiler([{'AMD64':'x86_64', 'aarch64':'arm64'}.get(m:=platform.machine(), m), "native"]).compile(src))
  def test_link(self):
    src = '''
      float powf(float, float); // from libm
      float test(float x, float y) { return powf(x, y); }
    '''
    args = ('-x', 'c', '-c', '-target', f'{platform.machine()}-none-unknown-elf', '-march=native', '-fPIC', '-O2', '-ffreestanding', '-nostdlib')
    obj = subprocess.check_output(('clang',) + args + ('-', '-o', '-'), input=src.encode())
    with self.assertRaisesRegex(RuntimeError, 'powf'): elf_loader(obj)
    elf_loader(obj, link_libs=[DLL('m', 'm')])

class TestAMDRegisterAllocation(unittest.TestCase):
  def allocation(self, inst):
    from tinygrad import dtypes
    from tinygrad.uop.ops import UOp, Ops, KernelInfo
    from tinygrad.renderer.amd.elf import assemble_linear
    from tinygrad.runtime.autogen import amdgpu_kd
    lin = UOp(Ops.LINEAR, src=(UOp(Ops.INS, arg=(inst, dtypes.void)),))
    prg = UOp(Ops.PROGRAM, src=(UOp.sink(arg=KernelInfo("register_allocation")), lin))
    _, sections, _ = elf_loader(assemble_linear(prg, lin, "gfx950"))
    desc = amdgpu_kd.llvm_amdhsa_kernel_descriptor_t.from_buffer_copy(next(s.content for s in sections if s.name == ".rodata"))
    total = ((desc.compute_pgm_rsrc1 & 63) + 1) * 8
    offset = ((desc.compute_pgm_rsrc3 & 63) + 1) * 4
    return total, offset

  def test_matrix_register_files(self):
    from tinygrad.runtime.autogen.amd.cdna.ins import v_mfma_f32_16x16x32_bf16, v
    for acc, acc_cd, a, b, c, expected in [(0, 1, 64, 96, 0, (104, 100)), (1, 1, 128, 20, 0, (160, 24)),
                                         (2, 1, 20, 128, 0, (160, 24)), (3, 0, 128, 128, 32, (168, 36))]:
      with self.subTest(acc=acc, acc_cd=acc_cd):
        inst = v_mfma_f32_16x16x32_bf16(v[c:c+3], v[a:a+3], v[b:b+3], v[c:c+3], acc=acc, acc_cd=acc_cd)
        self.assertEqual(self.allocation(inst), expected)

  def test_memory_accumulator_registers(self):
    from tinygrad.runtime.autogen.amd.cdna.ins import buffer_load_dwordx4, buffer_store_dwordx4, ds_read_b128, v, s
    for inst in [buffer_load_dwordx4(v[128:131], v[4], s[0:3], 0, offen=1, acc=1),
                 buffer_store_dwordx4(v[128:131], v[4], s[0:3], 0, offen=1, acc=1), ds_read_b128(v[128:131], v[4], acc=1)]:
      with self.subTest(inst=str(inst)): self.assertEqual(self.allocation(inst), (144, 8))

if __name__ == '__main__':
  unittest.main()
