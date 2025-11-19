from tinygrad import Device, Tensor
from tinygrad.device import Buffer
from tinygrad.engine.realize import get_program, CompiledRunner

Device.DEFAULT = "AMD"
dev = Device[Device.DEFAULT]

with open("test.s", "r") as f: src = f.read()
lib = dev.compiler.compile(src)

out = Tensor([1.,2,3]).realize() + Tensor([4.,5,6]).realize()
si = out.schedule()[-1]
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

"""
a = Tensor.empty(1)
p = get_program()
dev.runtime(p.function_name, self.lib)
import subprocess
from tinygrad.helpers import getenv
from tinygrad import Device, Tensor, Device, dtypes, Context
import numpy as np
from tinygrad.engine.realize import get_program

if getenv("MOCKGPU"): subprocess.run(["cargo", "build", "--release", "--manifest-path", "./extra/remu/Cargo.toml"], check=True)

t = Tensor.avg_pool2d(Tensor(np.random.randn(1,1,16,16,16), dtype=dtypes.float32), kernel_size=(8,8,8), stride=5, padding=1, count_include_pad=False)
with Context(TUPLE_ORDER=0, VALIDATE_WITH_CPU=1):
  t.realize()
"""
