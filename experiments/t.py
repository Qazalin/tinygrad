from tinygrad import Tensor, dtypes

dtypes.default_float = dtypes.half
a = Tensor.randn(2048, 2048)
b = Tensor.randn(2048, 2048)
out = Tensor.matmul(a, b)
out.realize()
