from test.test_linearizer import helper_linearizer_opt
from tinygrad import Tensor
from tinygrad.device import Device

N = 64
Tensor.manual_seed(1552)
tc = Device[Device.DEFAULT].renderer.tensor_cores[0]
[a, b, c, d] = [Tensor.randn(N, N, dtype=tc.dtype_in).realize() for _ in range(4)]
r0 = a.matmul(b, acc_dtype=tc.dtype_out)
r1 = c.matmul(r0, acc_dtype=tc.dtype_out)
helper_linearizer_opt(r1, opts=[[]], apply_tc=1)
#check_fused_tc_opt(tc, r0, r1, [a, b, c, d])
