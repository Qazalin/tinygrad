import torch
from tinygrad import Tensor
from test.test_ops import TestOps, helper_test_op

helper_test_op([(2,4,9,9,9), (4,4,3,3,3)],
  lambda x,w: torch.nn.functional.conv_transpose3d(x,w).relu(),
  lambda x,w: Tensor.conv_transpose2d(x,w).relu(), atol=1e-4, grad_rtol=1e-5)

