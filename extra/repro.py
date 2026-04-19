#!/usr/bin/env python3
# usage: NO_COLOR=1 python extra/viz/cli.py --rewrites -s "r_2_2_8_16_3_4_20_4_2_32" -i "View Base AST" | python extra/repro.py
#
# Like extra/replay.py, but matches the *real* JIT-time Buffer layout observed when the benchmark hangs:
# each kernel param is a view at a specific offset into a shared base buffer, not a fresh standalone allocation.
# See /tmp/inspect_hang.log for the actual sizes/offsets captured from the live run.
import sys
from dataclasses import replace
from tinygrad import Device
from tinygrad.device import Buffer, BufferSpec
from tinygrad.codegen import get_program
from tinygrad.engine.realize import CompiledRunner, ExecItem
from tinygrad.uop.ops import UOp, Ops, KernelInfo, AxisType
from tinygrad.dtype import dtypes, Invalid

ns = {"UOp": UOp, "Ops": Ops, "KernelInfo": KernelInfo, "AxisType": AxisType, "dtypes": dtypes, "Invalid": Invalid}
exec(sys.stdin.read(), ns)
ast: UOp = ns["ast"]

dev_name = Device.DEFAULT
dev = Device[dev_name]
p = get_program(ast, dev.renderer)
prg = CompiledRunner(replace(p, device=dev_name))

params: dict[int, UOp] = {}
for u in ast.toposort():
  if u.op is Ops.PARAM: params[u.arg] = u

# Exact layout from /tmp/inspect_hang.log.  slot -> (base_size, offset, dtype_element_count)
# None base_size => fresh standalone allocation (like replay.py does for everything)
LAYOUT = {
  0: (3376640,          25088,      6144),      # half*6144
  1: (3376640,          256,        6144),      # float*6144
  2: (3376640,          24832,      48),        # float*48
  3: (16740812704,      1996970272, 512),       # uchar*512
  4: (None,             0,          5120),      # float*5120 standalone
  5: (3376640,          0,          1),         # float*1
  6: (16740812704,      1786814368, 20480),     # uchar*20480
  7: (16740812704,      1769119648, 17694720),  # uchar*17694720 (the suspected fault buffer)
}

# Group params by base_size so we allocate one shared base buffer per group.
# Use dtypes.uint8 for the base — views re-interpret with the param's declared dtype.
bases: dict[int, Buffer] = {}
for slot, (base_size, _, _) in LAYOUT.items():
  if base_size is None: continue
  if base_size not in bases:
    # the 16.7 GB base exceeds VRAM, so for big bases use host-allocated (SAM/IOMMU) memory — this matches the live run,
    # where the GGUF weight file is backed by host memory and views into it are handed to the kernel as pointer+offset.
    opts = BufferSpec(host=True) if base_size > 1 << 32 else None
    print(f"allocating base buffer on {dev_name}: {base_size} bytes ({base_size/1e9:.2f} GB) opts={opts}", flush=True)
    bases[base_size] = Buffer(dev_name, base_size, dtypes.uint8, options=opts).allocate()

bufs: list[Buffer | None] = [None] * (max(params) + 1)
for slot, u in params.items():
  base_size, offset, size = LAYOUT[slot]
  base_dtype = u.dtype.base  # element dtype of the PARAM ptr
  if base_size is None:
    buf = Buffer(dev_name, size, base_dtype).allocate()
  else:
    buf = Buffer(dev_name, size, base_dtype, base=bases[base_size], offset=offset).allocate()
  bufs[slot] = buf
  print(f"  param[{slot}]: dtype={base_dtype} size={size} nbytes={buf.nbytes} offset={offset} "
        f"base_nbytes={bases[base_size].nbytes if base_size else 0}", flush=True)

print("\nrunning kernel via ExecItem...", flush=True)
ExecItem(ast, bufs, prg=prg).run(wait=True)
print("kernel finished ok — does NOT reproduce the hang", flush=True)
