#!/usr/bin/env python3
# usage: cat ast.py | extra/replay.py
import sys, numpy as np
from dataclasses import replace
from tinygrad import Device, Context
from tinygrad.device import Buffer
from tinygrad.codegen import get_program
from tinygrad.engine.realize import CompiledRunner, ExecItem
from tinygrad.uop.ops import UOp, Ops, KernelInfo, AxisType
from tinygrad.dtype import dtypes, Invalid, _to_np_dtype

ns = {"UOp": UOp, "Ops": Ops, "KernelInfo": KernelInfo, "AxisType": AxisType, "dtypes": dtypes, "Invalid": Invalid}
exec(sys.stdin.read(), ns)
ast: UOp = ns["ast"]

dev = Device[Device.DEFAULT]
p = get_program(ast, dev.renderer)
prg = CompiledRunner(replace(p, device=Device.DEFAULT))

params: dict[int, UOp] = {}
for u in ast.toposort():
  if u.op is Ops.PARAM: params[u.arg] = u

bufs: list[Buffer|None] = [None]*(max(params)+1)
for slot, u in params.items():
  pd = u.dtype
  base, size = pd.base, pd.size
  buf = Buffer(Device.DEFAULT, size, base).allocate()
  np_dt = _to_np_dtype(base)
  if dtypes.is_float(base): data = np.random.randn(size).astype(np_dt)
  elif dtypes.is_int(base): data = np.random.randint(0, min(np.iinfo(np_dt).max, 127)+1, size=size, dtype=np_dt)
  else: data = np.random.randint(0, 2, size=size, dtype=np_dt)
  buf.copyin(memoryview(data.tobytes()))
  bufs[slot] = buf

with Context(DEBUG=2):
  ExecItem(ast, bufs, prg=prg).run(wait=True)
