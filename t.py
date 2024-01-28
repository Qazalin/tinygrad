from tinygrad import Tensor
from tinygrad.dtype import dtypes

a = Tensor([-1.0], dtype=dtypes.half).sin()
a.realize()
print(a.numpy())
