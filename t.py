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

Device.DEFAULT = "HIP"
dev = Device[Device.DEFAULT]

asm = pathlib.Path(__file__).parent/"kernel.s"
lib = dev.compiler.compile(asm.read_text())
name = "gemm"

# ** construct launch args

def ceildiv(a, b): return -(-a // b)

def build_kernel_args(bufs, ws_buf, flags_buf, M, N, K, B, MT0, MT1, KT):
  # bufs: [out, A, B]
  args = KernArgs()

  # Calculate tile counts and work groups
  BM = B * M  # flattened batch*M dimension
  tiles_N = ceildiv(N, MT0)
  tiles_BM = ceildiv(BM, MT1)
  numWG = tiles_N * tiles_BM
  iters_per_tile = K // KT
  total_iters = numWG * iters_per_tile

  args.Gemm_info = 1
  args.kernel_info0 = 0
  args.kernel_info1 = 0x40010006
  args.numWG = numWG
  args.SizesFree0 = N
  args.SizesFree1 = BM
  args.SizesFree2 = 1
  args.SizesSum0 = K

  args.D = bufs[0].value
  args.C = bufs[0].value  # same as D
  args.A = bufs[2].value
  args.B = bufs[1].value
  args.AddressWS = ws_buf
  args.AddressFlags = flags_buf

  args.strideD0 = N
  args.strideD1 = 0
  args.strideC0 = N
  args.strideC1 = 0
  args.strideA0 = N
  args.strideA1 = 0
  args.strideB0 = N
  args.strideB1 = 0

  args.alpha = 1.0
  args.beta = 0.0

  args.ItersPerTile = iters_per_tile
  args.MagicNumberItersPerTile = 0x10000000
  args.MagicShiftItersPerTile = 0
  args.TotalIters = total_iters
  args.SKItersPerWG = iters_per_tile
  args.skGrid = numWG
  args.skTiles = numWG

  args.AddressScaleAlphaVec = None
  args.bias = None
  args.biasType = 0
  args.StrideBias = 0
  args.activationAlpha = 0.0
  args.activationBeta = 0.0
  args.activationType = 0

  blob = ctypes.string_at(ctypes.addressof(args), ctypes.sizeof(args))
  return args, blob, numWG

def pack_kernel_args(args:KernArgs):
  arg_size = ctypes.c_size_t(ctypes.sizeof(args))
  blob = (ctypes.c_ubyte * ctypes.sizeof(args)).from_buffer_copy(ctypes.string_at(ctypes.addressof(args), ctypes.sizeof(args)))
  extra = (ctypes.c_void_p * 5)(1, ctypes.cast(ctypes.byref(blob), ctypes.c_void_p), 2,
                                ctypes.cast(ctypes.pointer(arg_size), ctypes.c_void_p), 3)
  return extra, blob, arg_size  # keepalives: blob + arg_size

# Read dimensions from env variables (defaults match original)
M = getenv("M", 612)
N = getenv("N", 1024)
K = getenv("K", 1024)
B = getenv("B", 6)
dtype = dtypes.half

# MT128x128x64 kernel tile sizes
MT0, MT1, KT = 128, 128, 64
WORKGROUP_SIZE = 256

import numpy as np
rng = np.random.default_rng(0)
inp_A = Tensor(rng.random((B, M, N), dtype=np.float32)-0.5, dtype=dtype)
inp_B = Tensor(rng.random((K, N), dtype=np.float32)-0.5, dtype=dtype)
expected = inp_A @ inp_B
Tensor.realize(inp_A, inp_B)
out = Tensor.empty_like(expected)

# allocate workspace and flags buffers
ws_buf = Tensor.empty(1024*1024, dtype=dtypes.float32).uop.buffer.allocate()
flags_buf = Tensor.empty(1024*1024, dtype=dtypes.half).uop.buffer.allocate()

bufs = [b._buf for b in [out.uop.buffer.allocate(), inp_A.uop.buffer.ensure_allocated(), inp_B.uop.buffer.ensure_allocated()]]
args, _, numWG = build_kernel_args(bufs, ws_buf._buf, flags_buf._buf, M, N, K, B, MT0, MT1, KT)
extra, _blob_keep, _sz_keep = pack_kernel_args(args)

print(f"M={M} N={N} K={K} B={B} => numWG={numWG} global_size={numWG*WORKGROUP_SIZE}")

# ** run

prg = dev.runtime(name, lib)
prg.vargs = extra
et = prg(global_size=[numWG*WORKGROUP_SIZE, 1, 1], local_size=[WORKGROUP_SIZE, 1, 1], wait=True)
print(f"gemm finished in {et*1e3:9.2f} ms")
np.testing.assert_allclose(out.numpy(), expected.numpy(), rtol=1e-3, atol=1e-2)
print(out.flatten().numpy()[:8])
print(expected.flatten().numpy()[:8])
