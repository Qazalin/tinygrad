import os
os.environ["AMD_IFACE"] = "PCI"
os.environ["AM_RESET"] = "1"
os.environ["AMD"] = "1"
os.environ["PROFILE"] = "1"
os.environ["SQTT"] = "1"
os.environ["DEBUG"] = "2"

from tinygrad import Tensor
a = Tensor.empty(32, 32)
b = Tensor.empty(32, 32)
(a@b).realize()
