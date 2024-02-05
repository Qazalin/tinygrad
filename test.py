from tinygrad import Tensor

a = Tensor.ones(10,10)
b = Tensor.ones(10,10)
out = a + b
print(out.numpy())
