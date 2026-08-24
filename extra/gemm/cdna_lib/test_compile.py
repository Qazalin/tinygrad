#!/usr/bin/env python3
"""Compile cdna_lib kernels through tinygrad's real handwritten-ASM ELF path.

Run without an AMD GPU:
  DEV=NULL:NULL:gfx950 PYTHONPATH=. python extra/gemm/cdna_lib/test_compile.py

This is intentionally stronger than instruction serialization: it constructs Tensor.custom_kernel,
schedules it, lowers it, assembles the CDNA instructions, and packs the gfx950 ELF/kernel descriptor.
"""

from tinygrad import Device
from tinygrad.engine.realize import compile_linear
from tinygrad.uop.ops import Ops
from extra.gemm.cdna_lib.bench_mxfp4 import launch_tensor, make_empty_quantized, valid_variant
from extra.gemm.cdna_lib.mxfp4 import LLAMA_SHAPES
from extra.gemm.cdna_asm_gemm import _mxfp4_gemm_quantized

VARIANTS = ("reference", "auto", "identity", "wgm8", "wgm16")


def extract_binary(compiled):
  assert compiled.op is Ops.LINEAR and len(compiled.src) == 1
  call = compiled.src[0]
  assert call.op is Ops.CALL and call.src[0].op is Ops.PROGRAM
  binaries = [x.arg for x in call.src[0].src if x.op is Ops.BINARY]
  assert len(binaries) == 1
  binary = binaries[0]
  assert isinstance(binary, bytes) and binary.startswith(b"\x7fELF\x02") and len(binary) > 1024
  return binary, call.src[0].arg


def main():
  dev = Device[Device.DEFAULT]
  assert dev.renderer.target.arch.startswith("gfx950"), \
    f"use DEV=NULL:NULL:gfx950 (or a gfx950 AMD device), got {dev.renderer.target}"

  compiled_count = 0
  for M, N, K in LLAMA_SHAPES:
    bufs = make_empty_quantized(M, N, K, Device.DEFAULT)

    # Our reference wrapper must compile to exactly the same ELF as tinygrad's production MXFP4 path.
    prod_binary, prod_info = extract_binary(compile_linear(_mxfp4_gemm_quantized(
      bufs.a_q, bufs.b_q, bufs.scale_a, bufs.scale_b).schedule_linear()))
    ref_binary, ref_info = extract_binary(compile_linear(launch_tensor(
      bufs.a_q, bufs.b_q, bufs.scale_a, bufs.scale_b, "reference").schedule_linear()))
    assert ref_binary == prod_binary, (M, N, K, len(ref_binary), len(prod_binary))
    assert ref_info.global_size == prod_info.global_size and ref_info.local_size == prod_info.local_size

    for variant in VARIANTS:
      if not valid_variant(variant, N, M, K): continue
      out = launch_tensor(bufs.a_q, bufs.b_q, bufs.scale_a, bufs.scale_b, variant)
      binary, info = extract_binary(compile_linear(out.schedule_linear()))
      assert info.global_size == (N // 256, M // 256, 1), info.global_size
      assert info.local_size == (256, 1, 1), info.local_size
      print(f"compiled {M:5d}x{N:5d}x{K:5d} {variant:9s} ELF={len(binary):5d} B")
      compiled_count += 1


  # Phase 2: compile staged probes plus the full higher-residency 8-wave kernel.
  for M in (256, 16384):
    N, K = 4096, 4096
    bufs = make_empty_quantized(M, N, K, Device.DEFAULT)
    for variant in ("phase2_8w_barrier", "phase2_8w_store", "phase2_8w_load", "phase2_8w_acczero", "phase2_8w_waveid_raw", "phase2_8w_wavefill",
                    "phase2_8w_accscalar", "phase2_8w_accscalar128", "phase2_8w_accscalar252",
                    "phase2_8w_accwave", "phase2_8w_accwave128", "phase2_8w_accwave252",
                    "phase2_8w_acc128", "phase2_8w_acc252", "phase2_8w_refregs", "phase2_8w_refgap", "phase2_8w_nop7", "phase2_8w_postgap", "phase2_8w"):
      out = launch_tensor(bufs.a_q, bufs.b_q, bufs.scale_a, bufs.scale_b, variant)
      binary, info = extract_binary(compile_linear(out.schedule_linear()))
      assert info.global_size == (16, M // 256, 1), info.global_size
      assert info.local_size == (512, 1, 1), info.local_size
      print(f"compiled {M:5d}x{N:5d}x{K:5d} {variant:18s} ELF={len(binary):5d} B")
      compiled_count += 1

  # Direct-load Phase 2: compile both correctness-first and fast candidates on every Llama shape.
  for M, N, K in LLAMA_SHAPES:
    bufs = make_empty_quantized(M, N, K, Device.DEFAULT)
    for variant in ("phase2_direct", "phase2_direct_pingpong", "phase2_direct_fast"):
      out = launch_tensor(bufs.a_q, bufs.b_q, bufs.scale_a, bufs.scale_b, variant)
      binary, info = extract_binary(compile_linear(out.schedule_linear()))
      assert info.global_size == (N // 256, M // 256, 1), info.global_size
      assert info.local_size == (512, 1, 1), info.local_size
      print(f"compiled {M:5d}x{N:5d}x{K:5d} {variant:18s} ELF={len(binary):5d} B")
      compiled_count += 1


  # Transparent-LDS 8-wave Phase 2: compile serialized and software-pipelined candidates on all Llama shapes.
  for M, N, K in LLAMA_SHAPES:
    bufs = make_empty_quantized(M, N, K, Device.DEFAULT)
    for variant in ("phase2_lds", "phase2_lds_pipe"):
      out = launch_tensor(bufs.a_q, bufs.b_q, bufs.scale_a, bufs.scale_b, variant)
      binary, info = extract_binary(compile_linear(out.schedule_linear()))
      assert info.global_size == (N // 256, M // 256, 1), info.global_size
      assert info.local_size == (512, 1, 1), info.local_size
      print(f"compiled {M:5d}x{N:5d}x{K:5d} {variant:18s} ELF={len(binary):5d} B")
      compiled_count += 1


  # 4-wave 128x256 Phase 2: compile both safe and direct-to-LDS transport on all Llama shapes.
  for M, N, K in LLAMA_SHAPES:
    bufs = make_empty_quantized(M, N, K, Device.DEFAULT)
    for variant in ("phase2_4w", "phase2_4w_d2l"):
      out = launch_tensor(bufs.a_q, bufs.b_q, bufs.scale_a, bufs.scale_b, variant)
      binary, info = extract_binary(compile_linear(out.schedule_linear()))
      assert info.global_size == (N // 256, M // 128, 1), info.global_size
      assert info.local_size == (256, 1, 1), info.local_size
      print(f"compiled {M:5d}x{N:5d}x{K:5d} {variant:18s} ELF={len(binary):5d} B")
      compiled_count += 1

  print(f"gfx950 compile checks passed: {compiled_count} kernels")


if __name__ == "__main__": main()
