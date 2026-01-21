# reinstall torch: pip3 install --pre torch --index-url https://download.pytorch.org/whl/nightly/rocm7.1
# setcap!
import torch
import csv, os, subprocess, sys
from glob import glob
from tinygrad.helpers import getenv, temp, system

def gemm():
  system("rm -rf trace")
  M = 612
  N = 1024
  K = 1024
  scale = 10.0
  gpu = "cuda:5"
  dtype = torch.half

  B = getenv("B", 6)
  print("BATCH", B)

  A = torch.empty(B, M, N, dtype=dtype).contiguous()
  B = torch.empty(K, N, dtype=dtype).contiguous()

  C_gpu = A.to(gpu)@B.to(gpu)
  C_gpu.cpu()

  #load_arg()

def load_arg():
  if not getenv("LD_PRELOAD", ""): return
  import ctypes
  import glob
  import os

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

  def load_latest(dirpath):
    files = glob.glob(os.path.join(dirpath, "*.kernargs.bin"))
    if not files:
      raise RuntimeError("no .kernargs.bin files found")
    files.sort(key=lambda p: os.stat(p).st_mtime, reverse=True)
    return files[0]

  path = load_latest("trace")
  raw = open(path, "rb").read()
  need = ctypes.sizeof(KernArgs)
  if len(raw) != need:
    print(f"warning: file is {len(raw)} bytes, struct is {need} bytes")
  ka = KernArgs.from_buffer_copy(raw[:need])

  print(path)
  print(f"sizeof(KernArgs)={need}")
  for name, ty in KernArgs._fields_:
    v = getattr(ka, name)
    if ty == ctypes.c_uint64:
      print(f"{name:12s} = 0x{int(v):016x}")
    elif ty == ctypes.c_uint32:
      print(f"{name:12s} = {int(v)} (0x{int(v):08x})")
    elif ty == ctypes.c_float:
      print(f"{name:12s} = {float(v)}")
    else:
      print(f"{name:12s} = {v}")


if __name__ == "__main__":
  if getenv("PROFILE", 1):
    OUT_DIR = temp("rocprof", append_user=True)
    subprocess.run(["rocprofv3","--kernel-trace","--stats","--output-format","csv","--output-directory",OUT_DIR,"--",sys.executable,__file__],
                   check=True, env={**os.environ, "PROFILE":"0"}, stderr=subprocess.DEVNULL)
    with open(max(glob(f"{OUT_DIR}/*/*kernel_trace*.csv"), key=os.path.getmtime), newline="") as f:
      for row in csv.DictReader(f):
        print(f"{row['Kernel_Name']}: {(int(row['End_Timestamp'])-int(row['Start_Timestamp'])) / 1e6:.3f} ms")
  else: gemm()
