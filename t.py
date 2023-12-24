from tinygrad import Tensor


a = Tensor([1,2,3,4])
b = Tensor([1,2,3,4])

out = a + b
out.realize()
