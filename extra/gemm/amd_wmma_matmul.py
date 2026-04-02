# RDNA3 WMMA-based GEMM kernel for float16
# Target: >98 TFLOPS (beat torch), approach 120 TFLOPS peak
#
# v_wmma_f32_16x16x16_f16: D[16,16] = A[16,16] @ B[16,16] + C[16,16]
#
# WMMA data layout (RDNA3 wave32):
#   A: lane i (0-15) holds row i, vgpr j holds packed (k=2j, k=2j+1)
#   B: lane j (0-15) holds col j of B, vgpr holds packed k values
#   D: lane = n + (m&1)*16, vgpr = m>>1
#
# LDS layout (both A and B with K contiguous for easy WMMA loading):
#   A: [128, 16] f16 (M rows, K cols), K contiguous, stride 32 bytes
#   B: [128, 16] f16 (N rows, K cols), K contiguous, stride 32 bytes
#       Each row i of LDS_B = col i of matrix B (transposed during copy)
#
# Global->LDS copy:
#   A: straightforward - each thread loads one row
#   B: load col tid of B (scattered), store to row tid of LDS_B (transposed)

import numpy as np
from tinygrad import Tensor, Device, Context, GlobalCounters
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.helpers import getenv, colored
from tinygrad.dtype import dtypes, AddrSpace
from tinygrad.engine.realize import Estimates
from tinygrad.renderer.amd.dsl import s, v, VCC_LO, NULL
from tinygrad.runtime.autogen.amd.rdna3.ins import *
from extra.gemm.amd_asm_matmul import test_matmul, N

# =============================================================================
# Constants
# =============================================================================
WMMA_M, WMMA_N, WMMA_K = 16, 16, 16
BLOCK_M, BLOCK_N, BLOCK_K = 128, 128, 16
THREADS = 128

# LDS: A [128,16], B transposed [128,16] (both with K=16 contiguous)
LDS_A_SIZE = BLOCK_M * BLOCK_K * 2  # 4096 bytes
LDS_B_SIZE = BLOCK_N * BLOCK_K * 2  # 4096 bytes
LDS_SIZE = LDS_A_SIZE + LDS_B_SIZE
LDS_A_BASE = 0
LDS_B_BASE = LDS_A_SIZE
LDS_STRIDE = BLOCK_K * 2  # 32 bytes per row

# =============================================================================
# Registers
# =============================================================================
S_KERNARG = (0, 1)
S_WORKGROUP_X = 2
S_WORKGROUP_Y = 3
S_A_PTR = (4, 5)
S_B_PTR = (6, 7)
S_C_PTR = (8, 9)
S_DIM_N = 10
S_LOOP_CTR = 11
S_LOOP_BOUND = 12
S_TILE_M = 13
S_TILE_N = 14
S_TMP = 15
# 16 B row base addresses (k=0..15), each is 64-bit pointer
S_B_ROW = 16  # s[16:47] - 16 pairs for B[k, *] base addresses

V_LANE_ID = 0
V_ZERO = 1
V_WAVE_ID = 2
V_WAVE_M = 3
V_WAVE_N = 4
V_LANE_MOD32 = 5
V_LANE_MOD16 = 6

V_GLOBAL_A_LO = 7
V_GLOBAL_A_HI = 8
V_GLOBAL_B_OFF = 9   # B column offset only (row base in scalar)

V_LDS_A_STORE = 10
V_LDS_B_STORE = 11
V_LDS_A_LOAD = 12
V_LDS_B_LOAD = 13

# Prefetch registers
V_PREFETCH_A = 14   # v[14:21] - 8 regs for A (contiguous 32 bytes)
# B loads: 16 individual u16 values loaded into separate regs, then packed
V_B_LOAD = 22       # v[22:37] - 16 regs for B k=0..15 loads (u16 each)
V_PREFETCH_B = 38   # v[38:45] - 8 regs for B (final packed f16x2)

V_A_TILE = 46       # v[46:77] - 4 A tiles (32 regs)
V_B_TILE = 78       # v[78:109] - 4 B tiles (32 regs)
V_ACC = 110         # v[110:237] - 16 accumulators (128 regs)

# NOTE: V_TMP must be low enough to avoid VGPR allocation issues
# Using registers after accumulator tiles that are still safe
V_TMP = 14          # v[14:21] are free (prefetch regs are only needed in loop)
V_OUT_LO = 22
V_OUT_HI = 23

# =============================================================================
# Kernel
# =============================================================================
class Kernel:
  def __init__(self, arch='gfx1100'): self.instructions, self.labels, self.pos, self.arch = [], {}, 0, arch
  def label(self, name): self.labels[name] = self.pos
  def emit(self, inst, target=None):
    self.instructions.append(inst)
    inst._target, inst._pos = target, self.pos
    self.pos += inst.size()
    return inst
  def waitcnt(self, lgkm=None, vm=None):
    vmcnt = vm if vm is not None else 63
    lgkmcnt = lgkm if lgkm is not None else 63
    self.emit(s_waitcnt(simm16=7 | ((lgkmcnt & 0x3f) << 4) | ((vmcnt & 0x3f) << 10)))
  def finalize(self):
    for inst in self.instructions:
      if inst._target is None: continue
      inst.simm16 = (self.labels[inst._target] - inst._pos - inst.size()) // 4
    return self.instructions

def build_kernel(N, K=None, arch='gfx1100'):
  if K is None: K = N
  assert N % BLOCK_N == 0 and K % BLOCK_K == 0
  k = Kernel(arch)

  # =========================================================================
  # PROLOGUE
  # =========================================================================
  k.emit(s_load_b128(sdata=s[S_A_PTR[0]:S_B_PTR[1]], sbase=s[S_KERNARG[0]:S_KERNARG[1]], offset=0x0, soffset=NULL))
  k.emit(s_load_b64(sdata=s[S_C_PTR[0]:S_C_PTR[1]], sbase=s[S_KERNARG[0]:S_KERNARG[1]], offset=0x10, soffset=NULL))

  k.emit(s_mov_b32(s[S_DIM_N], N))
  k.emit(s_mov_b32(s[S_LOOP_CTR], 0))
  k.emit(s_mov_b32(s[S_LOOP_BOUND], K // BLOCK_K))
  k.emit(s_lshl_b32(s[S_TILE_M], s[S_WORKGROUP_Y], 7))
  k.emit(s_lshl_b32(s[S_TILE_N], s[S_WORKGROUP_X], 7))

  k.emit(v_mov_b32_e32(v[V_ZERO], 0))

  k.emit(v_lshrrev_b32_e32(v[V_WAVE_ID], 5, v[V_LANE_ID]))
  k.emit(v_and_b32_e32(v[V_LANE_MOD32], 31, v[V_LANE_ID]))
  k.emit(v_and_b32_e32(v[V_LANE_MOD16], 15, v[V_LANE_ID]))
  k.emit(v_lshrrev_b32_e32(v[V_WAVE_M], 1, v[V_WAVE_ID]))
  k.emit(v_and_b32_e32(v[V_WAVE_N], 1, v[V_WAVE_ID]))

  k.waitcnt(lgkm=0)

  # =========================================================================
  # LDS store addresses
  # =========================================================================
  # A: LDS row tid, straightforward
  k.emit(v_lshlrev_b32_e32(v[V_LDS_A_STORE], 5, v[V_LANE_ID]))  # tid * 32
  k.emit(v_add_nc_u32_e32(v[V_LDS_A_STORE], LDS_A_BASE, v[V_LDS_A_STORE]))

  # B: LDS row tid (stores col tid of B transposed)
  k.emit(v_lshlrev_b32_e32(v[V_LDS_B_STORE], 5, v[V_LANE_ID]))  # tid * 32
  k.emit(v_add_nc_u32_e32(v[V_LDS_B_STORE], LDS_B_BASE, v[V_LDS_B_STORE]))

  # =========================================================================
  # LDS load addresses
  # =========================================================================
  # A: wave_m*64 + lane_mod_16 rows, times 32 bytes
  k.emit(v_lshlrev_b32_e32(v[V_LDS_A_LOAD], 11, v[V_WAVE_M]))   # wave_m*2048
  k.emit(v_lshlrev_b32_e32(v[V_TMP], 5, v[V_LANE_MOD16]))       # lane*32
  k.emit(v_add_nc_u32_e32(v[V_LDS_A_LOAD], v[V_TMP], v[V_LDS_A_LOAD]))
  k.emit(v_add_nc_u32_e32(v[V_LDS_A_LOAD], LDS_A_BASE, v[V_LDS_A_LOAD]))

  # B: wave_n*64 + lane_mod_16 rows, times 32 bytes
  k.emit(v_lshlrev_b32_e32(v[V_LDS_B_LOAD], 11, v[V_WAVE_N]))   # wave_n*2048
  k.emit(v_add_nc_u32_e32(v[V_LDS_B_LOAD], v[V_TMP], v[V_LDS_B_LOAD]))
  k.emit(v_add_nc_u32_e32(v[V_LDS_B_LOAD], LDS_B_BASE, v[V_LDS_B_LOAD]))

  # =========================================================================
  # Global load addresses
  # =========================================================================
  # A: row (tile_m + tid), load 16 contiguous f16 values
  k.emit(v_add_nc_u32_e32(v[V_TMP+1], s[S_TILE_M], v[V_LANE_ID]))
  k.emit(v_mul_lo_u32(v[V_TMP+1], v[V_TMP+1], K * 2))
  k.emit(v_add_co_u32(v[V_GLOBAL_A_LO], VCC_LO, s[S_A_PTR[0]], v[V_TMP+1]))
  k.emit(v_add_co_ci_u32_e32(v[V_GLOBAL_A_HI], s[S_A_PTR[1]], v[V_ZERO]))

  # B: compute 16 row base addresses (k=0..15) in scalar registers
  # B[k, col] = B_ptr + k * N * 2 + col * 2
  # S_B_ROW[k] = B_ptr + k * N * 2 (base for row k)
  for i in range(16):
    if i == 0:
      k.emit(s_mov_b64(s[S_B_ROW:S_B_ROW+1], s[S_B_PTR[0]:S_B_PTR[1]]))
    else:
      k.emit(s_add_u32(s[S_B_ROW + i*2], s[S_B_PTR[0]], i * N * 2))
      k.emit(s_addc_u32(s[S_B_ROW + i*2 + 1], s[S_B_PTR[1]], 0))

  # B col offset: (tile_n + tid) * 2 in VGPR
  k.emit(v_add_nc_u32_e32(v[V_GLOBAL_B_OFF], s[S_TILE_N], v[V_LANE_ID]))
  k.emit(v_lshlrev_b32_e32(v[V_GLOBAL_B_OFF], 1, v[V_GLOBAL_B_OFF]))  # (tile_n + tid) * 2

  # =========================================================================
  # Zero accumulators
  # =========================================================================
  for i in range(128):
    k.emit(v_mov_b32_e32(v[V_ACC + i], 0))

  # =========================================================================
  # Initial load
  # =========================================================================
  # A: contiguous 32 bytes (2 x b128)
  k.emit(global_load_b128(vdst=v[V_PREFETCH_A:V_PREFETCH_A+3], addr=v[V_GLOBAL_A_LO:V_GLOBAL_A_HI], saddr=NULL, offset=0))
  k.emit(global_load_b128(vdst=v[V_PREFETCH_A+4:V_PREFETCH_A+7], addr=v[V_GLOBAL_A_LO:V_GLOBAL_A_HI], saddr=NULL, offset=16))

  # B: scattered - load 16 f16 values using scalar row bases, then pack into 8 regs
  # V_GLOBAL_B_OFF holds col offset, S_B_ROW[k] holds row base
  # addr = S_B_ROW[k] + V_GLOBAL_B_OFF = B_ptr + k*N*2 + (tile_n+tid)*2
  for i in range(16):
    k.emit(global_load_u16(vdst=v[V_B_LOAD + i], addr=v[V_GLOBAL_B_OFF], saddr=s[S_B_ROW + i*2 : S_B_ROW + i*2 + 1], offset=0))

  k.emit(s_branch(), target='LOOP_ENTRY')

  # =========================================================================
  # MAIN LOOP
  # =========================================================================
  k.label('LOOP_INC')
  k.emit(s_add_i32(s[S_LOOP_CTR], s[S_LOOP_CTR], 1))
  k.emit(s_cmp_ge_i32(s[S_LOOP_CTR], s[S_LOOP_BOUND]))
  k.emit(s_cbranch_scc1(), target='EPILOGUE')

  k.label('LOOP_ENTRY')

  k.waitcnt(vm=0)

  # Pack B values: V_PREFETCH_B[i] = pack(V_B_LOAD[2*i], V_B_LOAD[2*i+1])
  # v_pack_b32_f16 packs: dst = (src1_lo << 16) | src0_lo
  # So pack(k=2i, k=2i+1) gives us (k=2i+1 << 16) | k=2i = correct format for WMMA
  for i in range(8):
    k.emit(v_pack_b32_f16(v[V_PREFETCH_B + i], v[V_B_LOAD + 2*i], v[V_B_LOAD + 2*i + 1]))

  # Store A to LDS (contiguous, 2 x b128)
  k.emit(ds_store_b128(addr=v[V_LDS_A_STORE], data0=v[V_PREFETCH_A:V_PREFETCH_A+3], offset0=0))
  k.emit(ds_store_b128(addr=v[V_LDS_A_STORE], data0=v[V_PREFETCH_A+4:V_PREFETCH_A+7], offset0=16))

  # Store B to LDS (transposed, 2 x b128)
  k.emit(ds_store_b128(addr=v[V_LDS_B_STORE], data0=v[V_PREFETCH_B:V_PREFETCH_B+3], offset0=0))
  k.emit(ds_store_b128(addr=v[V_LDS_B_STORE], data0=v[V_PREFETCH_B+4:V_PREFETCH_B+7], offset0=16))

  k.waitcnt(lgkm=0)
  k.emit(s_barrier())

  # Prefetch next
  k.emit(s_add_i32(s[S_LOOP_CTR], s[S_LOOP_CTR], 1))
  k.emit(s_cmp_lt_i32(s[S_LOOP_CTR], s[S_LOOP_BOUND]))
  k.emit(s_cbranch_scc0(), target='SKIP_PREFETCH')

  # Advance A address by BLOCK_K * 2 bytes
  k.emit(v_add_nc_u32_e32(v[V_GLOBAL_A_LO], BLOCK_K * 2, v[V_GLOBAL_A_LO]))
  k.emit(v_add_co_ci_u32_e32(v[V_GLOBAL_A_HI], v[V_GLOBAL_A_HI], v[V_ZERO]))

  # Advance B row bases by BLOCK_K rows = BLOCK_K * N * 2 bytes
  for i in range(16):
    k.emit(s_add_u32(s[S_B_ROW + i*2], s[S_B_ROW + i*2], BLOCK_K * N * 2))
    k.emit(s_addc_u32(s[S_B_ROW + i*2 + 1], s[S_B_ROW + i*2 + 1], 0))

  # Prefetch A (2 x b128)
  k.emit(global_load_b128(vdst=v[V_PREFETCH_A:V_PREFETCH_A+3], addr=v[V_GLOBAL_A_LO:V_GLOBAL_A_HI], saddr=NULL, offset=0))
  k.emit(global_load_b128(vdst=v[V_PREFETCH_A+4:V_PREFETCH_A+7], addr=v[V_GLOBAL_A_LO:V_GLOBAL_A_HI], saddr=NULL, offset=16))

  # Prefetch B using scalar row bases
  for i in range(16):
    k.emit(global_load_u16(vdst=v[V_B_LOAD + i], addr=v[V_GLOBAL_B_OFF], saddr=s[S_B_ROW + i*2 : S_B_ROW + i*2 + 1], offset=0))

  k.label('SKIP_PREFETCH')
  k.emit(s_sub_i32(s[S_LOOP_CTR], s[S_LOOP_CTR], 1))

  # =========================================================================
  # Load WMMA tiles from LDS (using b128 for efficiency)
  # =========================================================================
  # A: 4 tiles x 8 regs = 32 regs, load as 8 x b128
  for wmma_m in range(4):
    for reg4 in range(2):
      lds_off = wmma_m * 16 * 32 + reg4 * 16
      k.emit(ds_load_b128(vdst=v[V_A_TILE + wmma_m*8 + reg4*4 : V_A_TILE + wmma_m*8 + reg4*4 + 3],
                          addr=v[V_LDS_A_LOAD], offset0=lds_off & 0xFF, offset1=lds_off >> 8))

  # B: 4 tiles x 8 regs = 32 regs, load as 8 x b128
  for wmma_n in range(4):
    for reg4 in range(2):
      lds_off = wmma_n * 16 * 32 + reg4 * 16
      k.emit(ds_load_b128(vdst=v[V_B_TILE + wmma_n*8 + reg4*4 : V_B_TILE + wmma_n*8 + reg4*4 + 3],
                          addr=v[V_LDS_B_LOAD], offset0=lds_off & 0xFF, offset1=lds_off >> 8))

  k.waitcnt(lgkm=0)

  # Execute WMMAs
  if getenv("DEBUG_CONST", 0):
    # Debug: set ALL accumulators to known constant (42.0)
    k.emit(s_mov_b32(s[S_TMP], 0x42280000))  # 42.0f
    for reg in range(128):
      k.emit(v_mov_b32_e32(v[V_ACC + reg], s[S_TMP]))
  elif getenv("SKIP_WMMA", 0):
    # Debug: copy A tile data to accumulators (just first tile)
    for reg in range(8):
      k.emit(v_cvt_f32_f16_e32(v[V_ACC + reg], v[V_A_TILE + reg]))  # Convert lo half to f32
  elif getenv("SKIP_LDS", 0):
    # Debug: copy prefetch data directly to accumulators
    for reg in range(8):
      k.emit(v_cvt_f32_f16_e32(v[V_ACC + reg], v[V_PREFETCH_A + reg]))  # Convert lo half to f32
  else:
    for m in range(4):
      for n in range(4):
        acc_idx = m * 4 + n
        k.emit(v_wmma_f32_16x16x16_f16(
          v[V_ACC + acc_idx*8 : V_ACC + acc_idx*8 + 7],
          v[V_A_TILE + m*8 : V_A_TILE + m*8 + 7],
          v[V_B_TILE + n*8 : V_B_TILE + n*8 + 7],
          v[V_ACC + acc_idx*8 : V_ACC + acc_idx*8 + 7]))

  k.emit(s_barrier())
  k.emit(s_branch(), target='LOOP_INC')

  # =========================================================================
  # EPILOGUE
  # =========================================================================
  k.label('EPILOGUE')

  # Reset V_ZERO to ensure it's 0
  k.emit(v_mov_b32_e32(v[V_ZERO], 0))

  # wave base: wave_m*64, wave_n*64
  k.emit(v_lshlrev_b32_e32(v[V_TMP], 6, v[V_WAVE_M]))     # wave_m * 64
  k.emit(v_add_nc_u32_e32(v[V_TMP], s[S_TILE_M], v[V_TMP]))  # tile_m + wave_m*64
  k.emit(v_lshlrev_b32_e32(v[V_TMP+1], 6, v[V_WAVE_N]))   # wave_n * 64
  k.emit(v_add_nc_u32_e32(v[V_TMP+1], s[S_TILE_N], v[V_TMP+1]))  # tile_n + wave_n*64

  # WMMA output layout: lane = n + (m&1)*16, vgpr = m>>1
  # lane_mod32 >> 4 gives (m&1) for this lane
  # lane_mod32 & 15 gives n (column within 16x16)
  k.emit(v_lshrrev_b32_e32(v[V_TMP+2], 4, v[V_LANE_MOD32]))  # m_parity = (lane>>4)&1
  k.emit(v_and_b32_e32(v[V_TMP+3], 15, v[V_LANE_MOD32]))     # n_in_tile = lane & 15

  for wmma_m in range(4):
    for wmma_n in range(4):
      acc_idx = wmma_m * 4 + wmma_n

      # col = tile_n + wave_n*64 + wmma_n*16 + n_in_tile
      k.emit(v_add_nc_u32_e32(v[V_TMP+4], wmma_n * 16, v[V_TMP+1]))
      k.emit(v_add_nc_u32_e32(v[V_TMP+4], v[V_TMP+3], v[V_TMP+4]))

      for reg in range(8):
        # row = tile_m + wave_m*64 + wmma_m*16 + 2*reg + m_parity
        # Each VGPR holds 2 consecutive rows: reg gives row 2*reg and 2*reg+1
        # Lanes 0-15 (m_parity=0) hold even rows, lanes 16-31 (m_parity=1) hold odd rows
        k.emit(v_add_nc_u32_e32(v[V_TMP+5], wmma_m * 16 + 2*reg, v[V_TMP]))
        k.emit(v_add_nc_u32_e32(v[V_TMP+5], v[V_TMP+2], v[V_TMP+5]))

        # offset = row * N + col
        k.emit(v_mul_lo_u32(v[V_TMP+6], v[V_TMP+5], s[S_DIM_N]))
        k.emit(v_add_nc_u32_e32(v[V_TMP+6], v[V_TMP+4], v[V_TMP+6]))
        # byte offset = offset * 2 (f16)
        k.emit(v_lshlrev_b32_e32(v[V_TMP+6], 1, v[V_TMP+6]))

        # addr = C_ptr + byte_offset
        k.emit(v_add_co_u32(v[V_OUT_LO], VCC_LO, s[S_C_PTR[0]], v[V_TMP+6]))
        k.emit(v_add_co_ci_u32_e32(v[V_OUT_HI], s[S_C_PTR[1]], v[V_ZERO]))

        # Convert f32 accumulator to f16 and store
        k.emit(v_cvt_f16_f32_e32(v[V_TMP+7], v[V_ACC + acc_idx*8 + reg]))
        k.emit(global_store_b16(addr=v[V_OUT_LO:V_OUT_HI], data=v[V_TMP+7], saddr=NULL, offset=0))

  k.emit(s_sendmsg(simm16=3))
  k.emit(s_endpgm())

  return k.finalize()

def get_asm_fxn():
  dev = Device[Device.DEFAULT]
  print(f"Device arch: {dev.renderer.arch}")

  insts = build_kernel(N, N, dev.renderer.arch)

  grid = (N // BLOCK_N, N // BLOCK_M, 1)
  local = (THREADS, 1, 1)
  print(f"Grid: {grid}, Local: {local}")

  dname = Device.DEFAULT
  def asm_kernel(A:UOp, B:UOp, C:UOp) -> UOp:
    gidxs = [UOp.special(n, f"gidx{i}") for i,n in enumerate(grid)]
    lidxs = [UOp.special(n, f"lidx{i}") for i,n in enumerate(local)]
    lds = UOp(Ops.DEFINE_LOCAL, dtypes.uint8.ptr(size=max(LDS_SIZE, 65536//getenv("LIMIT_OCC", 65536)), addrspace=AddrSpace.LOCAL), (), 'lds')
    sink = UOp.sink(A.base, B.base, C.base, lds, *gidxs, *lidxs, arg=KernelInfo(name=colored("wmma_kernel", "cyan"),
                                                                                  estimates=Estimates(ops=N*N*N*2, mem=N*N*2*3)))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=dname), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in insts]))))
  return asm_kernel

if __name__ == "__main__":
  test_matmul(get_asm_fxn())
