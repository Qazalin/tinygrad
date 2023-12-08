import numpy as np
from tinygrad.helpers import dtypes
from tinygrad.tensor import Tensor

a0 = 8.507061647788125e+27
b0 = 8.507060187143942e+37

a = Tensor([a0], dtype=dtypes.float32)
b = Tensor([b0], dtype=dtypes.float32)
out = a / b
print(out.numpy())


a = np.array([a0], dtype=np.float32)
b = np.array([b0], dtype=np.float32)
out = a / b
print(out)
