import numpy as np
import os
os.environ["LATE_ALLREDUCE"] = "0"
from tinygrad import Tensor, Device, Context, dtypes
from tinygrad.uop.ops import UOp, Ops

np.random.seed(0)
devices = tuple(f"{Device.DEFAULT}:{i}" for i in range(0,4))
t = Tensor(np.random.randn(256,256), dtype=dtypes.float).shard(devices,0).realize()
b = Tensor(UOp.allreduce(t.uop, Ops.ADD, t.device))
with Context(ALL2ALL=2): b = b.realize()
print(b.numpy())
