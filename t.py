from tinygrad import Tensor

N = 256
a = Tensor.empty(N, N)
a.assign(Tensor.full_like(a, 2)).realize()
