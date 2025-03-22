from tinygrad import Tensor


a = Tensor.empty(4, 4)
b = Tensor.empty(4, 4)


add = (a+b).contiguous()
mul = (a*b).contiguous()

add_child = add+2
mul_child = mul+2

out = add_child.contiguous()+mul_child.contiguous()
out.realize()
