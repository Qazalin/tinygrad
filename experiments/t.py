import numpy as np
from tinygrad import Tensor, dtypes

nb = np.array([[4,2], [6,3]], dtype=np.half)
nc = np.array([[4,2], [5,4]], dtype=np.half)
dtypes.default_float = dtypes.half
a = Tensor(nb)
b = Tensor(nc)
out = Tensor.matmul(a, b)
out.realize()
print(out.numpy())
