import torch
import numpy as np
from tinygrad.tensor import Tensor

shps = [(32,8,16,64), (32,8,16,64), (32,8,16,64)]
a = -0.5
b = 3
ts = [torch.tensor((np.random.random(size=x) + a) * b, requires_grad=True, dtype=torch.float32) for x in shps]
tst = [Tensor(x.detach().numpy(), requires_grad=True) for x in ts]
x, y, z = tst
out = Tensor.scaled_dot_product_attention(x,y,z,is_causal=True)
print(out.numpy())
