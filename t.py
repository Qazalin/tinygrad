from tinygrad.helpers import getenv
from tinygrad import Device, Tensor, Device, dtypes, Context
from tinygrad.device import Buffer
import numpy as np
from tinygrad.engine.realize import get_program, lower_schedule, CompiledRunner

Device.DEFAULT = "AMD"
dev = Device[Device.DEFAULT]

import subprocess
if getenv("MOCKGPU"): subprocess.run(["cargo", "build", "--release", "--manifest-path", "./extra/remu/Cargo.toml"], check=True)

with open("test.s", "r") as f: src = f.read()
lib = dev.compiler.compile(src)

t = Tensor.avg_pool2d(Tensor(np.random.randn(1,1,16,16,16), dtype=dtypes.float32).realize(), kernel_size=(8,8,8), stride=5, padding=1, count_include_pad=False)

si = t.schedule()[-1]
si.bufs[0].allocate()
prg = get_program(si.ast, dev.renderer)
fn = CompiledRunner(prg, lib)
fn(si.bufs, wait=True)

print(si.bufs[0].numpy())

# like validate_with_cpu
cpu = Device["CPU"]
cpu_bufs = [Buffer("CPU", b.size, b.dtype) for b in si.bufs]
for cpu_b, gpu_b in zip(cpu_bufs, si.bufs):
  if gpu_b.is_allocated(): cpu_b.ensure_allocated().copyin(gpu_b.as_buffer())
cpu_fn = CompiledRunner(get_program(si.ast, cpu.renderer))
cpu_fn(cpu_bufs, wait=True)
import numpy as np
np.testing.assert_allclose(si.bufs[0].numpy(), cpu_bufs[0].numpy(), rtol=1e-3, atol=1e-3)
