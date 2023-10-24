import unittest
from tinygrad.ops import Device
from tinygrad.tensor import Tensor

class TestExample(unittest.TestCase):
  def test_convert_to_cpu(self):
    a = Tensor([[1,2],[3,4]])
    assert a.numpy().shape == (2,2)
    b = a.cpu()
    assert b.numpy().shape == (2,2)

  def test_2_plus_3(self):
    a = Tensor([2])
    b = Tensor([3])
    result = a + b
    print(f"{a.numpy()} + {b.numpy()} = {result.numpy()}")
    assert result.numpy()[0] == 5.

  def test_example_readme(self):
    x = Tensor.eye(3, requires_grad=True)
    y = Tensor([[2.0,0,-2.0]], requires_grad=True)
    z = y.matmul(x).sum()
    z.backward()

    x.grad.numpy()  # dz/dx
    y.grad.numpy()  # dz/dy

    assert x.grad.device == Device.DEFAULT
    assert y.grad.device == Device.DEFAULT

  def test_example_matmul(self):
    x = Tensor.eye(64, requires_grad=True)
    y = Tensor.eye(64, requires_grad=True)
    z = y.matmul(x).sum()
    z.backward()

    x.grad.numpy()  # dz/dx
    y.grad.numpy()  # dz/dy

    assert x.grad.device == Device.DEFAULT
    assert y.grad.device == Device.DEFAULT

if __name__ == '__main__':
  unittest.main()
