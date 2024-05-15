import numpy as np
from tinygrad import Tensor
from tinygrad.dtype import dtypes

a = Tensor(np.ones((4, 4)), dtype=dtypes.float)
b = a.pad(((1, 1), (1, 1))).expand(2, 6, 6)
c = Tensor(np.ones((6, 6)), dtype=dtypes.float)
d = b + c
d.realize()
