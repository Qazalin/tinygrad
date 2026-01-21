import pathlib, ctypes
from tinygrad import Tensor, Device, dtypes
from tinygrad.helpers import system, temp, getenv

class KernArgs(ctypes.Structure):
  _pack_ = 1
  _fields_ = [
    ("Gemm_info", ctypes.c_uint32),                 # 0
    ("kernel_info0", ctypes.c_uint32),              # 4
    ("kernel_info1", ctypes.c_uint32),              # 8
    ("numWG", ctypes.c_uint32),                     # 12
    ("SizesFree0", ctypes.c_uint32),                # 16
    ("SizesFree1", ctypes.c_uint32),                # 20
    ("SizesFree2", ctypes.c_uint32),                # 24
    ("SizesSum0", ctypes.c_uint32),                 # 28

    ("D", ctypes.c_void_p),                         # 32 (global_buffer f16)
    ("C", ctypes.c_void_p),                         # 40 (global_buffer f16)
    ("A", ctypes.c_void_p),                         # 48 (global_buffer f16)
    ("B", ctypes.c_void_p),                         # 56 (global_buffer f16)
    ("AddressWS", ctypes.c_void_p),                 # 64 (global_buffer f32)
    ("AddressFlags", ctypes.c_void_p),              # 72 (global_buffer f16)

    ("strideD0", ctypes.c_uint32),                  # 80
    ("strideD1", ctypes.c_uint32),                  # 84
    ("strideC0", ctypes.c_uint32),                  # 88
    ("strideC1", ctypes.c_uint32),                  # 92
    ("strideA0", ctypes.c_uint32),                  # 96
    ("strideA1", ctypes.c_uint32),                  # 100
    ("strideB0", ctypes.c_uint32),                  # 104
    ("strideB1", ctypes.c_uint32),                  # 108

    ("alpha", ctypes.c_float),                      # 112
    ("beta", ctypes.c_float),                       # 116

    ("ItersPerTile", ctypes.c_uint32),              # 120
    ("MagicNumberItersPerTile", ctypes.c_uint32),   # 124
    ("MagicShiftItersPerTile", ctypes.c_uint32),    # 128
    ("TotalIters", ctypes.c_uint32),                # 132
    ("SKItersPerWG", ctypes.c_uint32),              # 136
    ("skGrid", ctypes.c_uint32),                    # 140
    ("skTiles", ctypes.c_uint32),                   # 144

    ("AddressScaleAlphaVec", ctypes.c_void_p),      # 148 (global_buffer f32)

    ("bias", ctypes.c_void_p),                      # 156 (global_buffer void)
    ("biasType", ctypes.c_uint32),                  # 164
    ("StrideBias", ctypes.c_uint32),                # 168

    ("activationAlpha", ctypes.c_float),            # 172
    ("activationBeta", ctypes.c_float),             # 176
    ("activationType", ctypes.c_uint32),            # 180
  ]

# ** assemble

asm = pathlib.Path(__file__).parent/"gemm2.s"
system(f"clang -x assembler -target amdgcn-amd-amdhsa -mcpu=gfx950 -mcode-object-version=5 -c {str(asm)} -o {temp('test.o')}")
system(f"ld.lld -shared -o {temp('test.hsaco')} {temp('test.o')}")
with open(temp('test.hsaco'), 'rb') as f: lib:bytes = f.read()
name:str = "gemm"

Device.DEFAULT = "HIP"
dev = Device[Device.DEFAULT]

# ** construct launch args

def build_kernel_args(bufs):
  # bufs: [out, A, B]
  args = KernelArgs()

  args.gemm_info = 0
  # ... more here

  blob = ctypes.string_at(ctypes.addressof(args), ctypes.sizeof(args))
  return args, blob

def pack_kernel_args(args:KernelArgs):
  arg_size = ctypes.c_size_t(ctypes.sizeof(args))
  blob = (ctypes.c_ubyte * ctypes.sizeof(args)).from_buffer_copy(ctypes.string_at(ctypes.addressof(args), ctypes.sizeof(args)))
  extra = (ctypes.c_void_p * 5)(1, ctypes.cast(ctypes.byref(blob), ctypes.c_void_p), 2,
                                ctypes.cast(ctypes.pointer(arg_size), ctypes.c_void_p), 3)
  return extra, blob, arg_size  # keepalives: blob + arg_size

M = 612
N = 1024
K = 1024
dtype = dtypes.half
A = Tensor.empty(B, M, N, dtype=dtype).contiguous()
B = Tensor.empty(K, N, dtype=dtype).contiguous()
C = A @ B
out = Tensor.empty_like(C).uop.buffer.allocate()
bufs = [b._buf for b in [out, Tensor(A).realize().uop.buffer, Tensor(B).realize().uop.buffer]]
args, _ = build_kernel_args(bufs)
extra, _blob_keep, _sz_keep = pack_kernel_args(args)

# ** run

prg = dev.runtime(name, lib)
prg.vargs = extra
et = prg(global_size=[TODO, 1, 1], local_size=[TODO, 1, 1], wait=True)
print(f"gemm finished in {et*1e3:9.2f} ms")

# ** correctness

import torch
asm_out = torch.from_numpy(out.numpy()).view(torch.bfloat16).reshape(ref_out.shape)
print(asm_out)
print(ref_out)
assert torch.allclose(asm_out, ref_out, rtol=1e-2, atol=1e-3)
