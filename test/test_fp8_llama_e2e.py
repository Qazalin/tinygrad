#!/usr/bin/env python3
import os
os.environ["ASM_GEMM"] = "1"
from tinygrad import Tensor, dtypes, Context
from examples.mlperf.models.flat_llama import matmul

if __name__ == "__main__":
  Tensor.manual_seed(0)
  x = Tensor.randn(1, 8192, 14336, dtype=dtypes.bfloat16)
  w = Tensor.randn(4096, 14336, dtype=dtypes.bfloat16)
  with Context(DEBUG=0):
    Tensor.realize(x, w)
  y, x_amax, w_amax = matmul(x, w, fp8=True)
  Tensor.realize(y, x_amax, w_amax)
