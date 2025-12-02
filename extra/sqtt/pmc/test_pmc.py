import os
os.environ["PYTHONPATH"] = "."
os.environ["PMC"] = "1"
if "DEV" not in os.environ: os.environ["DEV"] = "AMD"
os.environ["PROFILE"] = "1"
os.environ["AMD_LLVM"] = "0"

from tinygrad import Tensor

# use Tensor.custom_kernel to get DEBUG features for free
def custom_c_kernel(*args:tuple[UOp, ...], code:str="", global_size:tuple[int,int,int]=(1,1,1), local_size:tuple[int,int,int]=(1,1,1)):
  c = UOp(Ops.CUSTOM, arg=code)
  launch_args = [*[UOp.special(v, f"gidx{i}") for i,v in enumerate(global_size)], *[UOp.special(v, f"lidx{i}") for i,v in enumerate(local_size)]]
  return UOp.sink(c, *args, *launch_args, arg=KernelInfo("kernel", opts_to_apply=()))
