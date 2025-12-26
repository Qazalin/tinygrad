# reinstall torch: pip3 install --pre torch --index-url https://download.pytorch.org/whl/nightly/rocm7.1
import torch
import csv, os, subprocess, sys
from glob import glob
from tinygrad.helpers import getenv, temp

def gemm():
  N = 8192
  scale = 10.0
  gpu = "cuda:0"
  dtype = torch.bfloat16
  torch.manual_seed(0)

  A = (torch.randn(N, N, dtype=torch.float32, device="cpu") / scale).to(dtype).contiguous()
  B = (torch.randn(N, N, dtype=torch.float32, device="cpu") / scale).to(dtype).contiguous()

  C_cpu = A@B.t()

  C_gpu = A.to(gpu)@B.to(gpu).t()

  assert torch.allclose(C_gpu.to("cpu"), C_cpu, rtol=1e-2, atol=1e-3)
  print("** Correctness passed")

if __name__ == "__main__":
  if getenv("PROFILE", 1):
    OUT_DIR = temp("rocprof", append_user=True)
    subprocess.run(["rocprofv3","--kernel-trace","--stats","--output-format","csv","--output-directory",OUT_DIR,"--",sys.executable,__file__],
                   check=True, env={**os.environ, "PROFILE":"0"}, stderr=subprocess.DEVNULL)
    with open(max(glob(f"{OUT_DIR}/*/*kernel_trace*.csv"), key=os.path.getmtime), newline="") as f:
      for row in csv.DictReader(f):
        print(f"{row['Kernel_Name']}: {(int(row['End_Timestamp'])-int(row['Start_Timestamp'])) / 1e6:.3f} ms")
  else: gemm()
