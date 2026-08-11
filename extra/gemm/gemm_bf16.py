# ruff: noqa: E501
"""BF16 GEMM instruction streams exposed through tinygrad's AMD Python DSL.

The current scheduling is inherited from the HIP Kittens kernels.  We compile
the shape-specialized source, losslessly decode its gfx950 text into ``Inst``
objects, and hand that stream to tinygrad's native AMD program builder.  This
is the bridge needed to move the kernels from HIP source to authored DSL a
region at a time without changing their scheduling or performance baseline.
"""

from __future__ import annotations

import pathlib
from functools import cache

from tinygrad.renderer.amd import detect_format
from tinygrad.renderer.amd.dsl import Inst
from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
from tinygrad.runtime.support.elf import elf_loader


_KITTENS_PATH = pathlib.Path(__file__).parent.parent / "thunder" / "amd"
_SOURCES = {"ab": "gemm_bf16.cpp", "atb": "gemm_bf16_atb.cpp"}


def decode_instructions(text:bytes) -> tuple[Inst, ...]:
  """Losslessly decode a gfx950 text section into AMD DSL instructions."""
  ret:list[Inst] = []
  offset = 0
  while offset < len(text):
    inst = detect_format(text[offset:], "cdna").from_bytes(text[offset:])
    encoded = inst.to_bytes()
    if encoded != text[offset:offset+len(encoded)]:
      raise RuntimeError(f"AMDGPU DSL round-trip mismatch at text offset {offset:#x}")
    ret.append(inst)
    offset += len(encoded)
  return tuple(ret)


@cache
def code_object_text(M:int, N:int, K:int, kind:str="ab") -> bytes:
  """Compile and return the original shape-specialized gfx950 text section."""
  assert kind in _SOURCES, f"unknown BF16 GEMM kind {kind!r}"
  assert M % 256 == N % 256 == 0 and K % 64 == 0, f"invalid BF16 GEMM shape {(M, N, K)}"
  src = (_KITTENS_PATH / _SOURCES[kind]).read_text()
  opts = [f"-I{(_KITTENS_PATH/'include').as_posix()}", "-std=c++20", "-DKITTENS_CDNA4", "-ffast-math",
          "-DHIP_ENABLE_WARP_SYNC_BUILTINS", f"-DGEMM_M={M}", f"-DGEMM_N={N}", f"-DGEMM_K={K}"]
  lib = HIPCCCompiler("gfx950", opts).compile_cached(src)
  return bytes(next(section for section in elf_loader(lib)[1] if section.name == ".text").content)


@cache
def build_kernel(M:int, N:int, K:int, kind:str="ab") -> tuple[Inst, ...]:
  """Build the shape-specialized Kittens kernel as Python DSL instructions."""
  return decode_instructions(code_object_text(M, N, K, kind))
