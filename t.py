from tinygrad.helpers import dtypes
from tinygrad.ops import Device
from tinygrad.tensor import Tensor

Device.DEFAULT = "LLVM"
a = Tensor([1,2,3,4], dtype=dtypes.int8).cast(dtypes.int32)
print(a.numpy())
