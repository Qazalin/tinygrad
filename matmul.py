from tinygrad import Tensor, dtypes

dtypes.default_float = dtypes.half
Tensor.manual_seed(1337)

a = Tensor.rand(2048, 2048)
b = Tensor.rand(2048, 2048)

result = Tensor.matmul(a, b, acc_dtype=dtypes.float)
print(result.shape)
print(result.numpy())
