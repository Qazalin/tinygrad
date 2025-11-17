from tinygrad import Device, Tensor, Device, dtypes, Context
import numpy as np
from tinygrad.engine.realize import get_program

Device.DEFAULT = "AMD"
dev = Device[Device.DEFAULT]

t = Tensor.avg_pool2d(Tensor(np.random.randn(1,1,16,16,16), dtype=dtypes.float32), kernel_size=(8,8,8), stride=5, padding=1, count_include_pad=False)
with Context(TUPLE_ORDER=0):
  t.realize()
