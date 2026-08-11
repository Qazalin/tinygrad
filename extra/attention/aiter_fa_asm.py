# ruff: noqa: E501
"""AITER FlashAttention v3 kernels executed through tinygrad's AMD instruction DSL.

This is deliberately a correctness-first bridge.  The AMD code-object text is
decoded into tinygrad ``Inst`` objects and immediately re-encoded before it is
launched.  Thus the ISA which executes has passed through the same Python DSL
and ELF/runtime path as ``extra/gemm/gemm_mxfp4.py`` while retaining AITER's
exact scheduling.  Keeping the decoder here also gives us a safe baseline from
which to replace regions with authored Python DSL instructions incrementally.

Supported configuration is the one used by MLPerf Llama 3.1 8B on gfx950:
BF16, head dimension 128, causal, batch layout [B, H, S, D], no dropout/GQA.
"""

from __future__ import annotations

import math, os, pathlib, struct
from functools import cache

from tinygrad import Device, Tensor, dtypes
from tinygrad.device import TinyELF
from tinygrad.helpers import ceildiv, round_up
from tinygrad.renderer.amd import detect_format
from tinygrad.renderer.amd.dsl import Inst
from tinygrad.runtime.ops_amd import AMDProgram
from tinygrad.runtime.support.elf import elf_loader
from tinygrad.runtime.support.hcq import HCQArgsState


_DEFAULT_AITER = pathlib.Path(__file__).parents[2] / "build/v6/source/subrepos/TransformerEngine/3rdparty/QoLA/3rdparty/aiter"
_KERNELS = {
  "fwd": ("hsa/gfx950/fmha_v3_fwd/fwd_hd128_bf16_causal.co", "aiter_fa_fwd_hd128_bf16_causal"),
  "odo": ("hsa/gfx950/fmha_v3_bwd/bwd_hd128_odo_bf16.co", "aiter_fa_bwd_hd128_odo_bf16"),
  "bwd": ("hsa/gfx950/fmha_v3_bwd/bwd_hd128_bf16_causal_a16_psskddv.co", "aiter_fa_bwd_hd128_bf16_causal"),
  "dq": ("hsa/gfx950/fmha_v3_bwd/bwd_hd128_dq_shuffle.co", "aiter_fa_bwd_hd128_dq_shuffle"),
}


def aiter_root() -> pathlib.Path:
  return pathlib.Path(os.environ.get("AITER_ROOT", _DEFAULT_AITER))


def code_object_path(kind:str) -> pathlib.Path:
  assert kind in _KERNELS, f"unknown AITER FA kernel {kind!r}"
  path = aiter_root() / _KERNELS[kind][0]
  if not path.is_file():
    raise FileNotFoundError(f"AITER gfx950 code object not found: {path} (set AITER_ROOT)")
  return path


def _text_section(lib:bytes):
  return next(s for s in elf_loader(lib)[1] if s.name == ".text")


def decode_instructions(text:bytes) -> list[Inst]:
  """Losslessly decode one gfx950 text section into tinygrad DSL instructions."""
  ret:list[Inst] = []
  offset = 0
  while offset < len(text):
    inst = detect_format(text[offset:], "cdna").from_bytes(text[offset:])
    encoded = inst.to_bytes()
    if encoded != text[offset:offset+len(encoded)]:
      raise RuntimeError(f"AMDGPU DSL round-trip mismatch at text offset {offset:#x}")
    ret.append(inst)
    offset += len(encoded)
  return ret


@cache
def build_kernel(kind:str) -> tuple[Inst, ...]:
  """Return AITER's kernel as Python AMD-DSL instruction objects."""
  lib = code_object_path(kind).read_bytes()
  return tuple(decode_instructions(bytes(_text_section(lib).content)))


@cache
def build_code_object(kind:str) -> bytes:
  """Re-encode the DSL and place it back into AITER's resource/ABI container."""
  return code_object_from_instructions(kind, build_kernel(kind))


def code_object_from_instructions(kind:str, instructions:tuple[Inst, ...]|list[Inst]) -> bytes:
  """Build an executable code object from an explicitly supplied DSL stream."""
  lib = bytearray(code_object_path(kind).read_bytes())
  section = _text_section(bytes(lib))
  text = b"".join(inst.to_bytes() for inst in instructions)
  assert len(text) == section.header.sh_size
  start = section.header.sh_offset
  lib[start:start+len(text)] = text
  return bytes(lib)


class _PackedAiterArgs(HCQArgsState):
  def __init__(self, buf, prg, bufs, vals=()):
    super().__init__(buf, prg, bufs, vals)
    packed = prg.pack_args(bufs, vals)
    assert len(packed) == prg.kernargs_segment_size
    buf.cpu_view().view(size=len(packed), fmt="B")[:] = packed


class _AiterDSLProgram(AMDProgram):
  def __init__(self, dev, kind:str, pack_args, instructions:tuple[Inst, ...]|list[Inst]|None=None):
    lib = build_code_object(kind) if instructions is None else code_object_from_instructions(kind, instructions)
    super().__init__(dev, TinyELF(lib, _KERNELS[kind][1], dev.renderer.target, ()))
    # The v4 AMDHSA descriptor does not carry kernarg size; AITER keeps it in
    # metadata notes, which tinygrad's minimal ELF loader intentionally ignores.
    self.kernargs_segment_size = self.kernargs_alloc_size = {"fwd":512, "odo":208, "bwd":704, "dq":192}[kind]
    self.args_state_t, self.pack_args = _PackedAiterArgs, pack_args


def _buf(t:Tensor):
  t.realize()
  assert t.uop.base.realized is not None
  return t.uop.base.realized._buf


def _put_ptr(out:bytearray, offset:int, buf) -> None: struct.pack_into("<Q", out, offset, 0 if buf is None else buf.va_addr)
def _put_u32(out:bytearray, offset:int, value:int) -> None: struct.pack_into("<I", out, offset, value)
def _put_i32(out:bytearray, offset:int, value:int) -> None: struct.pack_into("<i", out, offset, value)
def _put_f32(out:bytearray, offset:int, value:float) -> None: struct.pack_into("<f", out, offset, value)


def _check(q:Tensor, k:Tensor, v:Tensor) -> tuple[int, int, int, int]:
  assert q.device == k.device == v.device and isinstance(q.device, str), "single-device tensors required"
  assert q.dtype == k.dtype == v.dtype == dtypes.bfloat16, "AITER FA v3 expects BF16"
  assert q.ndim == k.ndim == v.ndim == 4 and k.shape == v.shape, f"expected Q/K/V [B,H,S,128], got {q.shape}, {k.shape}, {v.shape}"
  batch, q_heads, seqlen, hdim = q.shape
  kv_batch, kv_heads, kv_seqlen, kv_hdim = k.shape
  assert (kv_batch, kv_seqlen, kv_hdim) == (batch, seqlen, hdim)
  assert hdim == 128 and seqlen > 0 and q_heads % kv_heads == 0, \
    f"expected head dimension 128 and integral GQA ratio, got Hq={q_heads}, Hkv={kv_heads}, D={hdim}"
  arch = Device[q.device].renderer.target.arch
  assert arch.startswith("gfx950"), f"AITER FA DSL kernels require gfx950, got {arch}"
  return batch, q_heads, kv_heads, seqlen


def _pack_fwd(bufs, vals) -> bytes:
  batch, q_heads, kv_heads, seqlen = vals
  out = bytearray(512)
  for off, b in zip((0x00, 0x10, 0x20, 0x30, 0x40), bufs): _put_ptr(out, off, b)
  scale, row_bytes = 1.0 / math.sqrt(128), 128 * 2
  _put_f32(out, 0x50, scale)
  values = {
    0x60:seqlen, 0x70:row_bytes, 0x80:256*row_bytes, 0x90:seqlen*row_bytes,
    0xa0:q_heads*seqlen*row_bytes, 0xb0:q_heads//kv_heads, 0xc0:row_bytes, 0xd0:seqlen*row_bytes,
    0xe0:kv_heads*seqlen*row_bytes, 0xf0:(5 if q_heads % 8 == 0 else 3), 0x100:1,
    0x110:seqlen, 0x120:128, 0x130:128, 0x140:q_heads, 0x150:row_bytes,
    0x160:seqlen*row_bytes, 0x170:kv_heads*seqlen*row_bytes, 0x180:row_bytes,
    0x190:seqlen*row_bytes, 0x1a0:q_heads*seqlen*row_bytes, 0x1d0:seqlen*4,
  }
  for off, value in values.items(): _put_u32(out, off, value)
  return bytes(out)


@cache
def _program(device:str, kind:str):
  packers = {"fwd":_pack_fwd, "odo":_pack_odo, "bwd":_pack_bwd, "dq":_pack_dq}
  return _AiterDSLProgram(Device[device], kind, packers[kind])


def aiter_fa_forward(q:Tensor, k:Tensor, v:Tensor, _fwd_program:_AiterDSLProgram|None=None) -> tuple[Tensor, Tensor]:
  """Run exact AITER causal BF16 forward through tinygrad's Python instruction DSL."""
  batch, q_heads, kv_heads, seqlen = _check(q, k, v)
  q, k, v = q.contiguous(), k.contiguous(), v.contiguous()
  out = Tensor.zeros(q.shape, dtype=dtypes.bfloat16, device=q.device).contiguous()
  lse = Tensor.zeros(batch, q_heads, seqlen, dtype=dtypes.float32, device=q.device).contiguous()
  buffers = tuple(_buf(x) for x in (out, q, k, v, lse))
  groups_x = ceildiv(ceildiv(seqlen, 256), 2)  # AITER merges causal head/tail query tiles.
  (_fwd_program or _program(q.device, "fwd"))(*buffers, global_size=(groups_x, q_heads, batch), local_size=(512, 1, 1),
                                               vals=(batch, q_heads, kv_heads, seqlen), wait=True)
  return out, lse


def _pack_odo(bufs, vals) -> bytes:
  batch, q_heads, _kv_heads, seqlen = vals
  out = bytearray(208)
  for off, b in zip((0x00, 0x10, 0x20), bufs): _put_ptr(out, off, b)
  row_bytes = 128 * 2
  for off, value in {0x30:seqlen*row_bytes, 0x40:q_heads*seqlen*row_bytes, 0x50:row_bytes,
                     0x60:seqlen*4, 0x70:q_heads*seqlen*4, 0x80:4, 0x90:seqlen, 0xa0:128}.items(): _put_u32(out, off, value)
  return bytes(out)


def _pack_bwd(bufs, vals) -> bytes:
  batch, q_heads, kv_heads, seqlen = vals
  out = bytearray(704)
  for off, b in zip((0x00,0x10,0x20,0x30,0x40,0x50,0x60,0x70,0x80), bufs): _put_ptr(out, off, b)
  row_bytes, hs = 128*2, seqlen*128*2
  q_bs, kv_bs = q_heads*seqlen*128*2, kv_heads*seqlen*128*2
  _put_f32(out, 0x90, 1.0/math.sqrt(128))
  _put_f32(out, 0xa0, math.log2(math.e))
  values = {
    0xb0:seqlen, 0xc0:256*row_bytes, 0xd0:hs, 0xe0:q_bs, 0xf0:row_bytes,
    0x100:q_heads//kv_heads, 0x110:hs, 0x120:kv_bs, 0x130:row_bytes, 0x140:row_bytes,
    0x150:seqlen, 0x160:128, 0x170:128, 0x180:q_heads,
    0x190:hs, 0x1a0:kv_bs, 0x1b0:row_bytes, 0x1c0:hs, 0x1d0:q_bs,
    0x1e0:row_bytes, 0x1f0:hs, 0x200:kv_bs, 0x210:hs, 0x220:kv_bs,
    0x230:row_bytes, 0x240:seqlen*4, 0x290:round_up(seqlen, 16),
  }
  for off, value in values.items(): _put_u32(out, off, value)
  _put_i32(out, 0x2a0, 0)
  _put_i32(out, 0x2b0, 0)
  return bytes(out)


def _pack_dq(bufs, vals) -> bytes:
  batch, q_heads, _kv_heads, seqlen = vals
  padded = round_up(seqlen, 16)
  out = bytearray(192)
  _put_ptr(out, 0x00, bufs[0])
  _put_ptr(out, 0x10, bufs[1])
  acc_hs, acc_bs, row_bytes = padded*128*2, q_heads*padded*128*2, 128*2
  for off, value in {0x20:acc_hs, 0x30:acc_bs, 0x40:row_bytes, 0x50:seqlen*row_bytes,
                     0x60:q_heads*seqlen*row_bytes, 0x70:row_bytes, 0x80:seqlen, 0x90:128}.items(): _put_u32(out, off, value)
  return bytes(out)


def aiter_fa_backward(q:Tensor, k:Tensor, v:Tensor, out:Tensor, lse:Tensor, grad_out:Tensor) -> tuple[Tensor, Tensor, Tensor]:
  """Run AITER's ODO + fused dQ/dK/dV + dQ-shuffle backward pipeline."""
  batch, q_heads, kv_heads, seqlen = _check(q, k, v)
  assert q_heads == kv_heads, "GQA backward requires AITER's additional dK/dV intermediate layout and is not implemented yet"
  assert out.shape == grad_out.shape == q.shape and out.dtype == grad_out.dtype == dtypes.bfloat16
  assert lse.shape == (batch, q_heads, seqlen) and lse.dtype == dtypes.float32
  q, k, v, out, lse, grad_out = (x.contiguous() for x in (q, k, v, out, lse, grad_out))
  d = Tensor.zeros(batch, q_heads, seqlen, dtype=dtypes.float32, device=q.device).contiguous()
  dq_acc = Tensor.zeros(batch, q_heads, round_up(seqlen, 16), 128, dtype=dtypes.bfloat16, device=q.device).contiguous()
  dq = Tensor.zeros(q.shape, dtype=dtypes.bfloat16, device=q.device).contiguous()
  dk = Tensor.zeros(k.shape, dtype=dtypes.bfloat16, device=q.device).contiguous()
  dv = Tensor.zeros(v.shape, dtype=dtypes.bfloat16, device=q.device).contiguous()

  common = (batch, q_heads, kv_heads, seqlen)
  odo_bufs = tuple(_buf(x) for x in (out, grad_out, d))
  _program(q.device, "odo")(*odo_bufs, global_size=(ceildiv(seqlen, 128), q_heads, batch), local_size=(256,1,1), vals=common, wait=True)

  main_bufs = tuple(_buf(x) for x in (dq_acc, dk, dv, q, k, v, grad_out, lse, d))
  main_groups = ceildiv(ceildiv(seqlen, 256), 2)
  _program(q.device, "bwd")(*main_bufs, global_size=(main_groups, q_heads, batch), local_size=(256,1,1), vals=common, wait=True)

  dq_bufs = tuple(_buf(x) for x in (dq_acc, dq))
  _program(q.device, "dq")(*dq_bufs, global_size=(ceildiv(seqlen, 64), q_heads, batch), local_size=(256,1,1), vals=common, wait=True)
  return dq, dk, dv
