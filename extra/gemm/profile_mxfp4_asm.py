# ruff: noqa: F403,F405
"""Small gfx950 assembly probes used to build a cycle model for MXFP4 GEMM."""
import os
import statistics
from tinygrad import Context, Device, Tensor, dtypes
from tinygrad.dtype import AddrSpace
from tinygrad.engine.realize import run_linear
from tinygrad.helpers import GlobalCounters, getenv
from tinygrad.renderer import Estimates
from tinygrad.uop.ops import KernelInfo, Ops, UOp
from tinygrad.runtime.autogen.amd.cdna.ins import *
from extra.gemm.gemm_mxfp4 import Kernel, v_mfma_fp4

GROUPS, THREADS = getenv("GROUPS", 256), getenv("THREADS", 64)
ITERS, ACCS = getenv("ITERS", 512), getenv("ACCS", 16)
STAGES = getenv("STAGES", 8)
LDS_SWIZZLE = getenv("LDS_SWIZZLE", 0)
WIDE_M = getenv("WIDE_M", 0)
LDS_TR = getenv("LDS_TR", 0)
MFMA32 = getenv("MFMA32", 0)
KSLABS = getenv("KSLABS", 8)
MODE = os.getenv("MODE", "mfma")

def build_mfma_probe():
  """Independent scaled-FP4 MFMAs, with loop overhead amortized across ACCS ops."""
  assert 1 <= ACCS <= (16 if MFMA32 else 64) and ACCS % 2 == 0
  k = Kernel()
  k.emit(s_mov_b32(s[8], ITERS))
  for r in range(10): k.emit(v_mov_b32_e32(v[r], 0))
  for r in range(ACCS*4): k.emit(v_accvgpr_write(v[r], 0))
  k.label("loop")
  for i in range(ACCS):
    if MFMA32:
      k.emit(v_mfma_scale_f32_32x32x64_f8f6f4(v[i*16:i*16+15], v[0:3], v[4:7], v[i*16:i*16+15],
                                               0, 0, 0, 0, 4, 1, 1, 0, 4, 0xD3AC, 8, 9))
    else:
      k.emit(v_mfma_fp4(v[i*4:i*4+3], v[0:3], v[4:7], (i & 1)*2, 0, v[8], v[9]))
  k.emit(s_sub_u32(s[8], s[8], 1))
  k.emit(s_cmp_lg_u32(s[8], 0))
  k.emit(s_cbranch_scc1(), target="loop")
  k.emit(s_waitcnt())
  k.emit(s_endpgm())
  return k.finalize()

def build_lds_probe():
  """128x256-wave compute skeleton: eight K512 stages, four K128 slabs/stage.

  This deliberately excludes VMEM and address generation.  It measures whether
  128 accumulator registers leave enough residency to hide the LDS/barrier cost
  of the proposed architecture before the full kernel is built.
  """
  k = Kernel()
  for r in range(128): k.emit(v_accvgpr_write(v[r], 0))
  # Each wave reads a private lane-strided area. Values are immaterial here.
  k.emit(v_and_b32_e32(v[0], 63, v[0]))
  if LDS_SWIZZLE == 3:
    # Lane map used by the conflict-free production 256x256 kernel.
    k.emit(v_and_b32_e32(v[100], 15, v[0]))
    k.emit(v_lshrrev_b32_e32(v[2], 3, v[100]))
    k.emit(v_lshlrev_b32_e32(v[2], 1, v[2]))
    k.emit(v_and_b32_e32(v[3], 3, v[100]))
    k.emit(v_lshrrev_b32_e32(v[3], 1, v[3]))
    k.emit(v_add_u32_e32(v[2], v[2], v[3]))
    k.emit(v_mul_i32_i24_e32(v[100], LIT, v[2], 1056))
    k.emit(v_and_b32_e32(v[2], 7, v[0]))
    k.emit(v_lshrrev_b32_e32(v[2], 2, v[2]))
    k.emit(v_lshlrev_b32_e32(v[2], 8, v[2]))
    k.emit(v_add_u32_e32(v[100], v[100], v[2]))
    k.emit(v_and_b32_e32(v[2], 1, v[0]))
    k.emit(v_lshlrev_b32_e32(v[2], 7, v[2]))
    k.emit(v_add_u32_e32(v[100], v[100], v[2]))
    k.emit(v_lshrrev_b32_e32(v[2], 4, v[0]))
    k.emit(v_lshlrev_b32_e32(v[2], 4, v[2]))
    k.emit(v_add_u32_e32(v[100], v[100], v[2]))
  elif LDS_SWIZZLE == 2:
    # CDNA4 conflict-free ds_read_b128 mapping from AMD's row-XOR guidance:
    # row=lane%16, col=(lane/16)*16, addr=row*128+col, then XOR 16B columns.
    k.emit(v_and_b32_e32(v[100], 15, v[0]))
    k.emit(v_lshrrev_b32_e32(v[2], 4, v[0]))
    k.emit(v_lshlrev_b32_e32(v[100], 7, v[100]))
    k.emit(v_lshlrev_b32_e32(v[2], 4, v[2]))
    k.emit(v_add_u32_e32(v[100], v[100], v[2]))
    k.emit(v_and_b32_e32(v[2], 1792, v[100]))
    k.emit(v_lshrrev_b32_e32(v[2], 4, v[2]))
    k.emit(v_xor_b32_e32(v[100], v[100], v[2]))
  elif LDS_SWIZZLE:
    k.emit(v_and_b32_e32(v[100], 15, v[0]))
    k.emit(v_lshrrev_b32_e32(v[2], 4, v[0]))
    k.emit(v_lshlrev_b32_e32(v[100], 6, v[100]))
    k.emit(v_lshlrev_b32_e32(v[2], 2, v[2]))
    k.emit(v_add_u32_e32(v[100], v[100], v[2]))
  else:
    k.emit(v_lshlrev_b32_e32(v[100], 4, v[0]))
  am, bn = (4, 8) if WIDE_M else (2, 16)
  k.emit(s_mov_b32(s[8], STAGES))
  k.label("stage")
  def read_fp4(dst, off):
    if LDS_TR:
      k.emit(ds_read_b64_tr_b4(v[dst:dst+1], v[100], offset0=off&255, offset1=off>>8))
      k.emit(ds_read_b64_tr_b4(v[dst+2:dst+3], v[100], offset0=(off+8)&255, offset1=(off+8)>>8))
    else:
      k.emit(ds_read_b128(v[dst:dst+3], v[100], offset0=off&255, offset1=off>>8))

  def read_a(slab, bank):
    abase, ascale = (0, 64) if bank == 0 else (16, 68)
    for m in range(am):
      off = (slab*am+m)*1024
      read_fp4(abase+m*4, off)
      off = (slab*am+m)*256
      k.emit(ds_read_b32(v[ascale+m], v[100], offset0=off&255, offset1=off>>8))

  def read_b(slab, n):
    off = (16384 + (slab*bn+n)*1024) & 32767
    read_fp4(32+n*4, off)
    off = 8192 + (slab*bn+n)*256
    k.emit(ds_read_b32(v[72+n], v[100], offset0=off&255, offset1=off>>8))

  read_a(0, 0)
  for n in range(bn): read_b(0, n)
  k.emit(s_waitcnt(0))
  for slab in range(4):
    bank = slab & 1
    if slab < 3: read_a(slab+1, bank^1)
    for n in range(bn):
      for m in range(am):
        acc = (m*bn+n)*4
        abase, ascale = (0, 64) if bank == 0 else (16, 68)
        k.emit(v_mfma_fp4(v[acc:acc+3], v[abase+m*4:abase+3+m*4], v[32+n*4:35+n*4], 0, 0, v[ascale+m], v[72+n]))
      if slab < 3: read_b(slab+1, n)
    if slab < 3: k.emit(s_waitcnt(0))
  k.emit(s_barrier())
  k.emit(s_sub_u32(s[8], s[8], 1))
  k.emit(s_cmp_lg_u32(s[8], 0))
  k.emit(s_cbranch_scc1(), target="stage")
  k.emit(s_waitcnt(0))
  k.emit(s_endpgm())
  return k.finalize()

def build_lds32_probe():
  """256x128 tile skeleton using eight 32x32x64 scaled-FP4 MFMAs/wave/slab."""
  k = Kernel()
  am, bn = (4, 4) if WIDE_M else (2, 4)
  for r in range(am*bn*16): k.emit(v_accvgpr_write(v[r], 0))
  k.emit(v_and_b32_e32(v[0], 63, v[0]))
  if LDS_SWIZZLE == 3:
    k.emit(v_and_b32_e32(v[100], 15, v[0]))
    k.emit(v_lshrrev_b32_e32(v[2], 3, v[100]))
    k.emit(v_lshlrev_b32_e32(v[2], 1, v[2]))
    k.emit(v_and_b32_e32(v[3], 3, v[100]))
    k.emit(v_lshrrev_b32_e32(v[3], 1, v[3]))
    k.emit(v_add_u32_e32(v[2], v[2], v[3]))
    k.emit(v_mul_i32_i24_e32(v[100], LIT, v[2], 1056))
    k.emit(v_and_b32_e32(v[2], 7, v[0]))
    k.emit(v_lshrrev_b32_e32(v[2], 2, v[2]))
    k.emit(v_lshlrev_b32_e32(v[2], 8, v[2]))
    k.emit(v_add_u32_e32(v[100], v[100], v[2]))
    k.emit(v_and_b32_e32(v[2], 1, v[0]))
    k.emit(v_lshlrev_b32_e32(v[2], 7, v[2]))
    k.emit(v_add_u32_e32(v[100], v[100], v[2]))
    k.emit(v_lshrrev_b32_e32(v[2], 4, v[0]))
    k.emit(v_lshlrev_b32_e32(v[2], 4, v[2]))
    k.emit(v_add_u32_e32(v[100], v[100], v[2]))
  else:
    k.emit(v_lshlrev_b32_e32(v[100], 4, v[0]))
  k.emit(s_mov_b32(s[8], STAGES))

  def read_fp4(dst:int, off:int):
    if LDS_TR:
      k.emit(ds_read_b64_tr_b4(v[dst:dst+1], v[100], offset0=off&255, offset1=off>>8))
      k.emit(ds_read_b64_tr_b4(v[dst+2:dst+3], v[100], offset0=(off+8)&255, offset1=(off+8)>>8))
    else:
      k.emit(ds_read_b128(v[dst:dst+3], v[100], offset0=off&255, offset1=off>>8))

  def read_a(slab, bank):
    abase, ascale = (0, 32) if bank == 0 else (16, 36)
    for m in range(am):
      off = (slab*am+m)*1024
      read_fp4(abase+m*4, off)
      off = (slab*am+m)*256
      k.emit(ds_read_b32(v[ascale+m], v[100], offset0=off&255, offset1=off>>8))

  def read_b(slab, n):
    off = (16384 + (slab*4+n)*1024) & 32767
    read_fp4(16+n*4, off)
    off = 8192 + (slab*4+n)*256
    k.emit(ds_read_b32(v[40+n], v[100], offset0=off&255, offset1=off>>8))

  def wait_lgkm(count):
    k.emit(s_waitcnt(7 | (count << 4) | (63 << 10)))

  k.label("stage")
  read_a(0, 0)
  for n in range(4): read_b(0, n)
  k.emit(s_waitcnt(0))
  for slab in range(KSLABS):
    bank = slab & 1
    if slab < KSLABS-1: read_a(slab+1, bank^1)
    for n in range(4):
      if slab == KSLABS-1 and n: wait_lgkm(6-2*n)
      elif 0 < slab < KSLABS-1 and n: wait_lgkm(10)
      for m in range(am):
        acc = (m*bn+n)*16
        abase, ascale = (0, 32) if bank == 0 else (16, 36)
        k.emit(v_mfma_scale_f32_32x32x64_f8f6f4(v[acc:acc+15], v[abase+m*4:abase+m*4+3], v[16+n*4:16+n*4+3],
                                                 v[acc:acc+15], 0, 0, 0, 0, 4, 1, 1, 0, 4, 0xD3AC, ascale+m, 40+n))
      if slab < KSLABS-1: read_b(slab+1, n)
    if slab < KSLABS-1: wait_lgkm(6)
  k.emit(s_barrier())
  k.emit(s_sub_u32(s[8], s[8], 1))
  k.emit(s_cmp_lg_u32(s[8], 0))
  k.emit(s_cbranch_scc1(), target="stage")
  k.emit(s_waitcnt(0))
  k.emit(s_endpgm())
  return k.finalize()

def make_probe(C:UOp) -> UOp:
  insts = (build_lds32_probe() if MFMA32 else build_lds_probe()) if MODE == "lds" else build_mfma_probe()
  threads, groups = UOp.special(THREADS, "lidx0"), UOp.special(GROUPS, "gidx0")
  lds_bytes = KSLABS*13056 if MODE == "lds" and MFMA32 else (32768 if MODE == "lds" else 1024)
  lds = UOp.placeholder((lds_bytes,), dtypes.uint8, 0, AddrSpace.LOCAL)
  stage_mfmas = KSLABS*(16 if WIDE_M else 8) if MFMA32 else 128
  ops = GROUPS * (THREADS//64) * (STAGES*stage_mfmas if MODE == "lds" else ITERS * ACCS) * (131072 if MFMA32 else 65536)
  sink = UOp.sink(C.base, lds, threads, groups,
                  arg=KernelInfo(f"mxfp4_{MODE}_probe", estimates=Estimates(ops=ops, mem=0)))
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.LINEAR, src=tuple(UOp(Ops.INS, arg=(x, dtypes.void)) for x in insts))))

if __name__ == "__main__":
  out = Tensor.empty(1, device=Device.DEFAULT)
  out = Tensor.custom_kernel(out, fxn=make_probe)[0]
  linear = out.schedule_linear()
  times = []
  with Context(DEBUG=2):
    for _ in range(getenv("CNT", 9)):
      st = GlobalCounters.time_sum_s
      run_linear(linear)
      times.append(GlobalCounters.time_sum_s-st)
  tm = statistics.median(times)
  stage_mfmas = KSLABS*(16 if WIDE_M else 8) if MFMA32 else 128
  ops = GROUPS * (THREADS//64) * (STAGES*stage_mfmas if MODE == "lds" else ITERS * ACCS) * (131072 if MFMA32 else 65536)
  print(f"{MODE.upper()} probe: {tm*1e6:.2f} us, {ops/tm/1e15:.3f} POP/s, {ops/tm/9.2e15:.1%} of 9.2P")
