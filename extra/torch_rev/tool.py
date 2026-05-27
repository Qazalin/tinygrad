#!/usr/bin/env python3
"""Small helpers for reverse engineering Torch/ROCm kernel launches.

Typical flow:
  LD_PRELOAD=$PWD/libhiptrace.so python repro.py
  args = latest_kernargs("trace", KernArgs)
  print_kernargs(args)
  a = hip_copy(args.A, (8192, 8192), "bf16")  # same process only
"""
from __future__ import annotations

import ctypes, glob, os
from pathlib import Path
from typing import Any, Iterable, TypeVar

KernArgsT = TypeVar("KernArgsT", bound=ctypes.Structure)

_DTYPES: dict[str, tuple[str, str, int]] = {
  "bool": ("bool", "bool", 1),
  "u8": ("uint8", "uint8", 1),
  "i8": ("int8", "int8", 1),
  "u16": ("uint16", "uint16", 2),
  "i16": ("int16", "int16", 2),
  "f16": ("uint16", "float16", 2),
  "bf16": ("uint16", "bfloat16", 2),
  "u32": ("uint32", "uint32", 4),
  "i32": ("int32", "int32", 4),
  "f32": ("float32", "float32", 4),
  "u64": ("uint64", "uint64", 8),
  "i64": ("int64", "int64", 8),
}

def trace_files(trace_dir: str | os.PathLike = "trace", pattern: str = "*.kernargs.bin") -> list[Path]:
  return sorted((Path(p) for p in glob.glob(str(Path(trace_dir) / pattern))), key=lambda p: p.stat().st_mtime)

def latest_trace_file(trace_dir: str | os.PathLike = "trace", pattern: str = "*.kernargs.bin") -> Path:
  files = trace_files(trace_dir, pattern)
  if not files: raise FileNotFoundError(f"no {pattern} files found in {trace_dir}")
  return files[-1]

def read_kernargs(path: str | os.PathLike, struct: type[KernArgsT], *, strict: bool = False) -> KernArgsT:
  raw = Path(path).read_bytes()
  need = ctypes.sizeof(struct)
  if len(raw) < need: raise ValueError(f"{path} is {len(raw)} bytes, smaller than {struct.__name__} ({need} bytes)")
  if strict and len(raw) != need: raise ValueError(f"{path} is {len(raw)} bytes, expected {need} bytes")
  return struct.from_buffer_copy(raw[:need])

def latest_kernargs(trace_dir: str | os.PathLike, struct: type[KernArgsT], *, pattern: str = "*.kernargs.bin", strict: bool = False) -> KernArgsT:
  return read_kernargs(latest_trace_file(trace_dir, pattern), struct, strict=strict)

def kernarg_items(args: ctypes.Structure) -> Iterable[tuple[str, Any, type[Any]]]:
  for name, ty in args._fields_:
    yield name, getattr(args, name), ty

def format_kernarg(name: str, value: Any, ty: type[Any]) -> str:
  if ty in (ctypes.c_void_p, ctypes.c_uint64): return f"{name:24s} = 0x{int(value or 0):016x}"
  if ty in (ctypes.c_uint32, ctypes.c_int32): return f"{name:24s} = {int(value)} (0x{int(value) & 0xffffffff:08x})"
  if ty in (ctypes.c_uint16, ctypes.c_int16, ctypes.c_uint8, ctypes.c_int8): return f"{name:24s} = {int(value)}"
  if ty in (ctypes.c_float, ctypes.c_double): return f"{name:24s} = {float(value)}"
  return f"{name:24s} = {value}"

def print_kernargs(args: ctypes.Structure) -> None:
  print(f"sizeof({type(args).__name__})={ctypes.sizeof(type(args))}")
  for name, value, ty in kernarg_items(args): print(format_kernarg(name, value, ty))

def pointer_map(*named_tensors: tuple[str, Any]) -> dict[int, tuple[str, Any]]:
  """Map Torch tensor data_ptr values to (name, tensor) for matching kernarg pointers."""
  return {int(t.data_ptr()): (name, t) for name, t in named_tensors}

def match_pointers(args: ctypes.Structure, live: dict[int, tuple[str, Any]]) -> dict[str, tuple[str, Any]]:
  ret = {}
  for name, value, ty in kernarg_items(args):
    if ty is ctypes.c_void_p and value in live: ret[name] = live[value]
  return ret

_hip = None
def _hip_lib():
  global _hip
  if _hip is None:
    _hip = ctypes.cdll.LoadLibrary("libamdhip64.so")
    _hip.hipMemcpy.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_size_t, ctypes.c_int]
    _hip.hipMemcpy.restype = ctypes.c_int
  return _hip

def hip_copy(ptr: int, shape: tuple[int, ...] | int, dtype: str = "bf16"):
  """Copy a HIP device pointer to a Torch tensor. The owning HIP context must still be alive."""
  import numpy as np, torch
  if isinstance(shape, int): shape = (shape,)
  np_dtype, torch_dtype, itemsize = _DTYPES[dtype]
  numel = 1
  for x in shape: numel *= x
  host = np.empty(numel, dtype=getattr(np, np_dtype))
  err = _hip_lib().hipMemcpy(ctypes.c_void_p(host.ctypes.data), ctypes.c_void_p(int(ptr)), ctypes.c_size_t(numel * itemsize), 2)
  if err != 0: raise RuntimeError(f"hipMemcpy failed with error code {err}")
  return torch.from_numpy(host).view(getattr(torch, torch_dtype)).reshape(shape)

def hip_copy_like(ptr: int, tensor: Any):
  dtype = str(tensor.dtype).removeprefix("torch.").replace("float16", "f16").replace("bfloat16", "bf16")
  return hip_copy(ptr, tuple(tensor.shape), dtype)

def cli() -> None:
  import argparse, importlib
  parser = argparse.ArgumentParser(description="Print a dumped HIP kernargs buffer using a ctypes schema")
  parser.add_argument("schema", help="module:Class, for example extra.gemm.asm.kernargs:KernArgs")
  parser.add_argument("path", nargs="?", default="trace", help="kernargs file or trace directory")
  args = parser.parse_args()
  mod_name, cls_name = args.schema.split(":", 1)
  struct = getattr(importlib.import_module(mod_name), cls_name)
  path = latest_trace_file(args.path) if Path(args.path).is_dir() else Path(args.path)
  print(path)
  print_kernargs(read_kernargs(path, struct))

if __name__ == "__main__": cli()
