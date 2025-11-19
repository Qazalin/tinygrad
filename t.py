import os
os.environ["TUPLE_ORDER"] = "0"

import numpy as np
from tinygrad.helpers import getenv, system2, system
from tinygrad import Device, Tensor, Device, dtypes, Context
from tinygrad.device import Buffer
from tinygrad.engine.realize import get_program, lower_schedule, CompiledRunner

Device.DEFAULT = "AMD"
dev = Device[Device.DEFAULT]

# test case
t = Tensor.avg_pool2d(Tensor(np.random.randn(1,1,16,16,16), dtype=dtypes.float32).realize(), kernel_size=(8,8,8), stride=5, padding=1, count_include_pad=False)
si = t.schedule()[-1]

# compile
def get_fn(lib:bytes|None=None):
  if lib is None:
    prg = get_program(si.ast, dev.renderer)
    lib = dev.compiler.compile(prg.src.replace(prg.function_name, "my_kernel"))
  return dev.runtime("my_kernel", lib)

def run(fn):
  # setup runtime
  import subprocess
  if getenv("MOCKGPU"): subprocess.run(["cargo", "build", "--release", "--manifest-path", "./extra/remu/Cargo.toml"], check=True)
  # run on gpu
  fn(*[b.ensure_allocated()._buf for b in si.bufs], global_size=(1,1,1), local_size=(1,1,1), wait=True)
  # validate
  cpu = Device["CPU"]
  cpu_bufs = [Buffer("CPU", b.size, b.dtype) for b in si.bufs]
  for cpu_b, gpu_b in zip(cpu_bufs, si.bufs):
    if gpu_b.is_allocated(): cpu_b.ensure_allocated().copyin(gpu_b.as_buffer())
  cpu_fn = CompiledRunner(get_program(si.ast, cpu.renderer))
  cpu_fn(cpu_bufs, wait=True)
  np.testing.assert_allclose(si.bufs[0].numpy(), cpu_bufs[0].numpy(), rtol=1e-3, atol=1e-3)

fn = get_fn()
run(fn)
#system2(f"llvm-readelf -d -", input=fn.lib)
