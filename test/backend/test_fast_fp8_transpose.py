import statistics, unittest

from tinygrad import Device
from tinygrad.device import Buffer
from tinygrad.dtype import dtypes
from tinygrad.helpers import ceildiv
from tinygrad.codegen import fp8_transpose_source

FP8_TRANSPOSE_SHAPES = ((16384, 28672), (4096, 14336), (28672, 4096), (4096, 4096), (6144, 4096), (16384, 4096), (16384, 6144))

def compile_kernel(name:str, source:str): return Device[Device.DEFAULT].runtime(name, Device[Device.DEFAULT].compiler.compile_cached(source))

def fill_source(name:str, numel:int) -> str:
  return f'''typedef long unsigned int size_t;
typedef unsigned char uint8_t;
extern "C" __attribute__((device, const)) size_t __ockl_get_local_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_group_id(unsigned int);
extern "C" __attribute__((global)) void __attribute__((amdgpu_flat_work_group_size(1, 256))) {name}(uint8_t* out) {{
  int idx = __ockl_get_group_id(0)*256 + __ockl_get_local_id(0);
  if (idx < {numel}) out[idx] = (uint8_t)((idx ^ (idx >> 8) ^ (idx >> 16)) & 255);
}}'''

def baseline_source(name:str, rows:int, cols:int) -> str:
  numel = rows * cols
  return f'''typedef long unsigned int size_t;
typedef unsigned char uint8_t;
extern "C" __attribute__((device, const)) size_t __ockl_get_local_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_group_id(unsigned int);
extern "C" __attribute__((global)) void __attribute__((amdgpu_flat_work_group_size(1, 256))) {name}(uint8_t* out, uint8_t* in) {{
  int idx = __ockl_get_group_id(0)*256 + __ockl_get_local_id(0);
  if (idx < {numel}) {{
    int r = idx / {cols};
    int c = idx - r * {cols};
    out[c * {rows} + r] = in[idx];
  }}
}}'''

@unittest.skipUnless(Device.DEFAULT == "AMD", "requires real AMD timings and execution")
class TestFastFP8Transpose(unittest.TestCase):
  def test_supported_shapes_correct_and_faster_than_baseline(self):
    for rows, cols in FP8_TRANSPOSE_SHAPES:
      with self.subTest(rows=rows, cols=cols):
        numel = rows * cols
        inp = Buffer(Device.DEFAULT, numel, dtypes.uint8).allocate()
        ref = Buffer(Device.DEFAULT, numel, dtypes.uint8).allocate()
        out = Buffer(Device.DEFAULT, numel, dtypes.uint8).allocate()

        fill = compile_kernel(f"fill_fp8_transpose_{rows}_{cols}", fill_source(f"fill_fp8_transpose_{rows}_{cols}", numel))
        baseline = compile_kernel(f"baseline_fp8_transpose_{rows}_{cols}", baseline_source(f"baseline_fp8_transpose_{rows}_{cols}", rows, cols))
        fast = compile_kernel(f"custom_fp8_transpose_{rows}_{cols}", fp8_transpose_source(f"custom_fp8_transpose_{rows}_{cols}", rows, cols))

        fill(inp._buf, global_size=(ceildiv(numel, 256), 1, 1), local_size=(256, 1, 1), wait=True)
        baseline(ref._buf, inp._buf, global_size=(ceildiv(numel, 256), 1, 1), local_size=(256, 1, 1), wait=True)
        fast(out._buf, inp._buf, global_size=(rows//512, cols//512, 1), local_size=(16, 16, 4), wait=True)

        got, exp = bytearray(numel), bytearray(numel)
        out.copyout(memoryview(got)); ref.copyout(memoryview(exp))
        self.assertEqual(got, exp)

        baseline_times = [baseline(ref._buf, inp._buf, global_size=(ceildiv(numel, 256), 1, 1), local_size=(256, 1, 1), wait=True) for _ in range(5)]
        fast_times = [fast(out._buf, inp._buf, global_size=(rows//512, cols//512, 1), local_size=(16, 16, 4), wait=True) for _ in range(5)]
        self.assertLess(statistics.median(fast_times), statistics.median(baseline_times))

if __name__ == "__main__": unittest.main()
