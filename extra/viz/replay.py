#!/usr/bin/env python3
import argparse, pathlib, time
from dataclasses import replace
import numpy as np

from tinygrad import Tensor, Context, Device
from tinygrad.dtype import dtypes
from tinygrad.helpers import DEBUG, ansistrip, temp, GlobalCounters
from tinygrad.uop.ops import Ops, UOp
from tinygrad.viz.serve import VizData, _reconstruct, load_pickle

def load_program(kernel_name:str, pickle_path:str|None) -> UOp:
  data = VizData(load_pickle(pickle_path or temp("rewrites.pkl", append_user=True), []))
  for i,k in enumerate(data.trace.keys):
    if ansistrip(k.display_name).endswith(kernel_name): break
  else: raise RuntimeError(f"kernel {kernel_name!r} not found in rewrites")

  assert data.trace.rewrites[i][-1].name == "View Program"
  prg = _reconstruct(data, data.trace.rewrites[i][-1].sink)
  assert prg.op is Ops.PROGRAM, prg.op
  return prg.replace(arg=replace(prg.arg, name=prg.arg.name))

def build_cpp_program(prg:UOp, cpp_path:str, cpp_name:str|None, global_size:tuple[int, ...]|None, local_size:tuple[int, ...]|None) -> UOp:
  code = pathlib.Path(cpp_path).read_text()
  if Device.DEFAULT != "AMD": raise RuntimeError("--cpp currently uses HIPCC and requires Device.DEFAULT=AMD")
  if "#include" in code:
    from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
    lib = HIPCCCompiler(Device[Device.DEFAULT].renderer.target.arch, []).compile_cached(code)
  else:
    lib = Device[Device.DEFAULT].compiler.compile_cached(code)
  if global_size is None: global_size = prg.arg.global_size
  if local_size is None: local_size = prg.arg.local_size
  shape_numbers = str(param_specs(prg)[prg.arg.outs[0]][0])
  name = cpp_name or f"custom_cpp_{pathlib.Path(cpp_path).stem}_{shape_numbers}"
  return prg.replace(src=(*prg.src[:3], UOp(Ops.SOURCE, arg=code), UOp(Ops.BINARY, arg=lib)),
                     arg=replace(prg.arg, name=name, global_size=global_size, local_size=local_size))

def parse_dims(x:str|None) -> tuple[int, ...]|None:
  return None if x is None else tuple(int(y) for y in x.split(","))

def param_specs(prg:UOp) -> list[tuple[int, object]]:
  params = sorted([x for x in prg.src[0].backward_slice if x.op is Ops.PARAM], key=lambda x: x.arg.slot)
  return [(x.max_numel(), x.dtype.base) for x in params]

def make_input(numel:int, dtype, device:str) -> Tensor:
  if dtypes.is_float(dtype): return Tensor.randn(numel, device=device, dtype=dtype).contiguous()
  if dtypes.is_bool(dtype): return Tensor.randint(numel, low=0, high=2, dtype=dtypes.int32, device=device).cast(dtype).contiguous()
  if dtypes.is_int(dtype): return Tensor.randint(numel, low=0, high=17, dtype=dtypes.int32, device=device).cast(dtype).contiguous()
  raise Exception("unsupported dtype")

def make_args(prg:UOp, bases:list[Tensor]|None=None) -> list[Tensor]:
  device = prg.src[1].arg
  outs = set(prg.arg.outs)
  tensors = []
  for i,(numel,dtype) in enumerate(param_specs(prg)):
    if i in outs:
      tensors.append(make_input(numel, dtype, device))
    elif bases is not None:
      tensors.append(bases[i])
    else:
      tensors.append(make_input(numel, dtype, device))
  with Context(DEBUG=0): Tensor.realize(*tensors)
  return tensors

def clear_cache(flush:Tensor|None) -> None:
  if flush is not None:
    with Context(DEBUG=0): flush.assign(flush + 1).realize()
    Device[flush.device].synchronize()

def run_program(prg:UOp, args:list[Tensor], label:str, flush:Tensor|None=None) -> list[Tensor]:
  def fxn(*_): return prg
  clear_cache(flush)
  st = time.perf_counter()
  with Context(DEBUG=max(DEBUG.value, 2)):
    rets = args[0].custom_kernel(*args[1:], fxn=fxn)
    Tensor.realize(*[rets[i] for i in prg.arg.outs])
  return rets

def bench_pair(prg:UOp, cpp_prg:UOp|None, bases:list[Tensor], iters:int, flush:Tensor|None) -> None:
  for i in range(iters):
    run_program(prg, make_args(prg, bases), f"trace iter {i}", flush)
    if cpp_prg is not None: run_program(cpp_prg, make_args(prg, bases), f"cpp iter {i}", flush)

def main():
  parser = argparse.ArgumentParser(description="Replay a traced PROGRAM through the Tensor custom_kernel API")
  parser.add_argument("--kernel", default="E_114688_32_4_2_4", help="kernel display name suffix to load from rewrites.pkl")
  parser.add_argument("--pickle", default=None, help="path to rewrites.pkl, defaults to tinygrad temp path")
  parser.add_argument("--cpp", default=None, help="handwritten HIP/C++ source file with a compatible kernel")
  parser.add_argument("--cpp-name", default=None, help="kernel function name in --cpp, defaults to traced program name")
  parser.add_argument("--cpp-global", default=None, help="comma separated global size for --cpp")
  parser.add_argument("--cpp-local", default=None, help="comma separated local size for --cpp")
  parser.add_argument("--iters", type=int, default=3, help="benchmark iterations after correctness")
  parser.add_argument("--clear-cache-mb", type=int, default=0, help="read/write this many MB before each measured kernel")
  parser.add_argument("--rtol", type=float, default=1e-2)
  parser.add_argument("--atol", type=float, default=1e-2)
  args = parser.parse_args()

  Tensor.manual_seed(0)
  prg = load_program(args.kernel, args.pickle)
  cpp_prg = build_cpp_program(prg, args.cpp, args.cpp_name, parse_dims(args.cpp_global), parse_dims(args.cpp_local)) if args.cpp is not None else None
  flush = Tensor.empty(args.clear_cache_mb*1024*1024//4, device=prg.src[1].arg, dtype=dtypes.float32).contiguous().realize() if args.clear_cache_mb else None

  bases = make_args(prg)
  GlobalCounters.reset()
  ref = run_program(prg, make_args(prg, bases), "trace", flush)
  if cpp_prg is not None:
    got = run_program(cpp_prg, make_args(prg, bases), "cpp", flush)
    for i in prg.arg.outs:
      np.testing.assert_allclose(got[i].numpy(), ref[i].numpy(), rtol=args.rtol, atol=args.atol)
    print("allclose passed")

  GlobalCounters.reset()
  bench_pair(prg, cpp_prg, bases, args.iters, flush)

if __name__ == "__main__": main()
