from tinygrad import Tensor

a = Tensor.empty(32).add(1)
a.realize()
