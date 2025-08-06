from tinygrad import Tensor

a = Tensor.empty(4).sum()
a.realize()
