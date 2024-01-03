from tinygrad import Tensor, dtypes

dt = dtypes.float

a = Tensor([1.0, 2.0, 3.0])
b = Tensor([1.0, 2.0, 3.0])
out = a * b
out.realize()
