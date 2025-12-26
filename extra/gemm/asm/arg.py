import ctypes

class KernelArgs(ctypes.Structure):
  _pack_ = 1
  _fields_ = [
    ("gemm_info", ctypes.c_uint32),      # offset 0
    ("kernel_info0", ctypes.c_uint32),   # offset 4
    ("kernel_info1", ctypes.c_uint32),   # offset 8
    ("numWG", ctypes.c_uint32),          # offset 12
    ("sizesFree0", ctypes.c_uint32),     # offset 16
    ("sizesFree1", ctypes.c_uint32),     # offset 20
    ("sizesFree2", ctypes.c_uint32),     # offset 24
    ("sizesSum0", ctypes.c_uint32),      # offset 28

    ("D", ctypes.c_void_p),              # offset 32 (global_buffer bf16)
    ("C", ctypes.c_void_p),              # offset 40 (global_buffer bf16)
    ("A", ctypes.c_void_p),              # offset 48 (global_buffer bf16)
    ("B", ctypes.c_void_p),              # offset 56 (global_buffer bf16)

    ("strideD0", ctypes.c_uint32),       # offset 64
    ("strideD1", ctypes.c_uint32),       # offset 68
    ("strideC0", ctypes.c_uint32),       # offset 72
    ("strideC1", ctypes.c_uint32),       # offset 76
    ("strideA0", ctypes.c_uint32),       # offset 80
    ("strideA1", ctypes.c_uint32),       # offset 84
    ("strideB0", ctypes.c_uint32),       # offset 88
    ("strideB1", ctypes.c_uint32),       # offset 92

    ("alpha", ctypes.c_float),           # offset 96
    ("beta", ctypes.c_float),            # offset 100
  ]

assert ctypes.sizeof(KernelArgs) == 104
#assert ctypes.alignment(KernelArgs) == 8
