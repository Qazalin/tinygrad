from tinygrad import Tensor

a = Tensor([1])+(Tensor.ones(1)*1)
a.assign(a+2)
b = a+2
b.realize()
print(a.uop)
c = a+3
c.realize()

#print(b.numpy())
#print(c.numpy())
