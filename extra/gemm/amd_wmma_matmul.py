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
BLOCK_M, BLOCK_N, BLOCK_K = 128, 128, 16
THREADS = 128

LDS_A_SIZE = BLOCK_M * BLOCK_K * 2  # 4096 bytes
LDS_B_SIZE = BLOCK_N * BLOCK_K * 2  # 4096 bytes
LDS_SIZE = LDS_A_SIZE + LDS_B_SIZE
LDS_A_BASE, LDS_B_BASE = 0, LDS_A_SIZE

# =============================================================================
# Scalar Registers
# =============================================================================
S_KERNARG = (0, 1)
S_WORKGROUP_X, S_WORKGROUP_Y = 2, 3
S_A_PTR, S_B_PTR, S_C_PTR = (4, 5), (6, 7), (8, 9)
S_DIM_N, S_LOOP_CTR, S_LOOP_BOUND = 10, 11, 12
S_TILE_M, S_TILE_N = 13, 14
S_B_ROW = 16  # s[16:47] - 16 pairs for B row base addresses

# =============================================================================
# Vector Registers
# =============================================================================
V_LANE_ID, V_ZERO = 0, 1
V_WAVE_ID, V_WAVE_M, V_WAVE_N = 2, 3, 4
V_LANE_MOD32, V_LANE_MOD16 = 5, 6
V_GLOBAL_A_LO, V_GLOBAL_A_HI, V_GLOBAL_B_OFF = 7, 8, 9
V_LDS_A_STORE, V_LDS_B_STORE, V_LDS_A_LOAD, V_LDS_B_LOAD = 10, 11, 12, 13
V_PREFETCH_A = 14   # v[14:21] - 8 regs
V_B_LOAD = 22       # v[22:37] - 16 regs for scattered B loads
V_PREFETCH_B = 38   # v[38:45] - 8 regs for packed B
V_A_TILE = 46       # v[46:77] - 32 regs (4 tiles)
V_B_TILE = 78       # v[78:109] - 32 regs (4 tiles)
V_ACC = 110         # v[110:237] - 128 regs (16 accumulators)
# Epilogue temporaries (reuse prefetch regs)
V_TMP, V_OUT_LO, V_OUT_HI = 14, 22, 23

# =============================================================================
# Kernel Builder
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
    self.emit(s_waitcnt(simm16=7 | (((lgkm if lgkm is not None else 63) & 0x3f) << 4) |
                                   (((vm if vm is not None else 63) & 0x3f) << 10)))
  def finalize(self):
    for inst in self.instructions:
      if inst._target: inst.simm16 = (self.labels[inst._target] - inst._pos - inst.size()) // 4
    return self.instructions

def build_kernel(N, K=None, arch='gfx1100'):
  if K is None: K = N
  assert N % BLOCK_N == 0 and K % BLOCK_K == 0
  k = Kernel(arch)

  # =========================================================================
  # PROLOGUE: load args, compute addresses
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

  # LDS store addresses: tid * 32
  k.emit(v_lshlrev_b32_e32(v[V_LDS_A_STORE], 5, v[V_LANE_ID]))
  k.emit(v_add_nc_u32_e32(v[V_LDS_A_STORE], LDS_A_BASE, v[V_LDS_A_STORE]))
  k.emit(v_lshlrev_b32_e32(v[V_LDS_B_STORE], 5, v[V_LANE_ID]))
  k.emit(v_add_nc_u32_e32(v[V_LDS_B_STORE], LDS_B_BASE, v[V_LDS_B_STORE]))

  # LDS load addresses: (wave_m/n * 64 + lane_mod16) * 32
  k.emit(v_lshlrev_b32_e32(v[V_LDS_A_LOAD], 11, v[V_WAVE_M]))
  k.emit(v_lshlrev_b32_e32(v[V_TMP], 5, v[V_LANE_MOD16]))
  k.emit(v_add_nc_u32_e32(v[V_LDS_A_LOAD], v[V_TMP], v[V_LDS_A_LOAD]))
  k.emit(v_add_nc_u32_e32(v[V_LDS_A_LOAD], LDS_A_BASE, v[V_LDS_A_LOAD]))
  k.emit(v_lshlrev_b32_e32(v[V_LDS_B_LOAD], 11, v[V_WAVE_N]))
  k.emit(v_add_nc_u32_e32(v[V_LDS_B_LOAD], v[V_TMP], v[V_LDS_B_LOAD]))
  k.emit(v_add_nc_u32_e32(v[V_LDS_B_LOAD], LDS_B_BASE, v[V_LDS_B_LOAD]))

  # Global A address: A_ptr + (tile_m + tid) * K * 2
  k.emit(v_add_nc_u32_e32(v[V_TMP+1], s[S_TILE_M], v[V_LANE_ID]))
  k.emit(v_mul_lo_u32(v[V_TMP+1], v[V_TMP+1], K * 2))
  k.emit(v_add_co_u32(v[V_GLOBAL_A_LO], VCC_LO, s[S_A_PTR[0]], v[V_TMP+1]))
  k.emit(v_add_co_ci_u32_e32(v[V_GLOBAL_A_HI], s[S_A_PTR[1]], v[V_ZERO]))

  # B row base addresses in scalar regs: S_B_ROW[k] = B_ptr + k * N * 2
  for i in range(16):
    if i == 0: k.emit(s_mov_b64(s[S_B_ROW:S_B_ROW+1], s[S_B_PTR[0]:S_B_PTR[1]]))
    else:
      k.emit(s_add_u32(s[S_B_ROW + i*2], s[S_B_PTR[0]], i * N * 2))
      k.emit(s_addc_u32(s[S_B_ROW + i*2 + 1], s[S_B_PTR[1]], 0))

  # B col offset: (tile_n + tid) * 2
  k.emit(v_add_nc_u32_e32(v[V_GLOBAL_B_OFF], s[S_TILE_N], v[V_LANE_ID]))
  k.emit(v_lshlrev_b32_e32(v[V_GLOBAL_B_OFF], 1, v[V_GLOBAL_B_OFF]))

  # Zero accumulators
  for i in range(128): k.emit(v_mov_b32_e32(v[V_ACC + i], 0))

  # Initial global loads
  k.emit(global_load_b128(vdst=v[V_PREFETCH_A:V_PREFETCH_A+3], addr=v[V_GLOBAL_A_LO:V_GLOBAL_A_HI], saddr=NULL, offset=0))
  k.emit(global_load_b128(vdst=v[V_PREFETCH_A+4:V_PREFETCH_A+7], addr=v[V_GLOBAL_A_LO:V_GLOBAL_A_HI], saddr=NULL, offset=16))
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

  # Pack B: v_pack_b32_f16 packs two f16 into one reg
  for i in range(8): k.emit(v_pack_b32_f16(v[V_PREFETCH_B + i], v[V_B_LOAD + 2*i], v[V_B_LOAD + 2*i + 1]))

  # Store to LDS
  k.emit(ds_store_b128(addr=v[V_LDS_A_STORE], data0=v[V_PREFETCH_A:V_PREFETCH_A+3], offset0=0))
  k.emit(ds_store_b128(addr=v[V_LDS_A_STORE], data0=v[V_PREFETCH_A+4:V_PREFETCH_A+7], offset0=16))
  k.emit(ds_store_b128(addr=v[V_LDS_B_STORE], data0=v[V_PREFETCH_B:V_PREFETCH_B+3], offset0=0))
  k.emit(ds_store_b128(addr=v[V_LDS_B_STORE], data0=v[V_PREFETCH_B+4:V_PREFETCH_B+7], offset0=16))
  k.waitcnt(lgkm=0)
  k.emit(s_barrier())

  # Prefetch next iteration FIRST - start global loads as early as possible
  k.emit(s_add_i32(s[S_LOOP_CTR], s[S_LOOP_CTR], 1))
  k.emit(s_cmp_lt_i32(s[S_LOOP_CTR], s[S_LOOP_BOUND]))
  k.emit(s_cbranch_scc0(), target='SKIP_PREFETCH')
  k.emit(v_add_nc_u32_e32(v[V_GLOBAL_A_LO], BLOCK_K * 2, v[V_GLOBAL_A_LO]))
  k.emit(v_add_co_ci_u32_e32(v[V_GLOBAL_A_HI], v[V_GLOBAL_A_HI], v[V_ZERO]))
  for i in range(16):
    k.emit(s_add_u32(s[S_B_ROW + i*2], s[S_B_ROW + i*2], BLOCK_K * N * 2))
    k.emit(s_addc_u32(s[S_B_ROW + i*2 + 1], s[S_B_ROW + i*2 + 1], 0))
  k.emit(global_load_b128(vdst=v[V_PREFETCH_A:V_PREFETCH_A+3], addr=v[V_GLOBAL_A_LO:V_GLOBAL_A_HI], saddr=NULL, offset=0))
  k.emit(global_load_b128(vdst=v[V_PREFETCH_A+4:V_PREFETCH_A+7], addr=v[V_GLOBAL_A_LO:V_GLOBAL_A_HI], saddr=NULL, offset=16))
  for i in range(16):
    k.emit(global_load_u16(vdst=v[V_B_LOAD + i], addr=v[V_GLOBAL_B_OFF], saddr=s[S_B_ROW + i*2 : S_B_ROW + i*2 + 1], offset=0))
  k.label('SKIP_PREFETCH')
  k.emit(s_sub_i32(s[S_LOOP_CTR], s[S_LOOP_CTR], 1))

  # Start LDS loads (global prefetch now in flight)
  for wmma_m in range(4):
    for reg4 in range(2):
      off = wmma_m * 16 * 32 + reg4 * 16
      k.emit(ds_load_b128(vdst=v[V_A_TILE + wmma_m*8 + reg4*4 : V_A_TILE + wmma_m*8 + reg4*4 + 3],
                          addr=v[V_LDS_A_LOAD], offset0=off & 0xFF, offset1=off >> 8))
  for wmma_n in range(4):
    for reg4 in range(2):
      off = wmma_n * 16 * 32 + reg4 * 16
      k.emit(ds_load_b128(vdst=v[V_B_TILE + wmma_n*8 + reg4*4 : V_B_TILE + wmma_n*8 + reg4*4 + 3],
                          addr=v[V_LDS_B_LOAD], offset0=off & 0xFF, offset1=off >> 8))

  # Wait for LDS loads
  k.waitcnt(lgkm=0)

  # Execute 16 WMMAs (4x4 grid)
  for m in range(4):
    for n in range(4):
      acc_idx = m * 4 + n
      k.emit(v_wmma_f32_16x16x16_f16(v[V_ACC + acc_idx*8 : V_ACC + acc_idx*8 + 7],
                                      v[V_A_TILE + m*8 : V_A_TILE + m*8 + 7],
                                      v[V_B_TILE + n*8 : V_B_TILE + n*8 + 7],
                                      v[V_ACC + acc_idx*8 : V_ACC + acc_idx*8 + 7]))
  k.emit(s_barrier())
  k.emit(s_branch(), target='LOOP_INC')

  # =========================================================================
  # EPILOGUE: convert f32 accumulators to f16 and store
  # =========================================================================
  k.label('EPILOGUE')
  k.emit(v_mov_b32_e32(v[V_ZERO], 0))

  # Compute base coordinates
  k.emit(v_lshlrev_b32_e32(v[V_TMP], 6, v[V_WAVE_M]))
  k.emit(v_add_nc_u32_e32(v[V_TMP], s[S_TILE_M], v[V_TMP]))
  k.emit(v_lshlrev_b32_e32(v[V_TMP+1], 6, v[V_WAVE_N]))
  k.emit(v_add_nc_u32_e32(v[V_TMP+1], s[S_TILE_N], v[V_TMP+1]))
  k.emit(v_lshrrev_b32_e32(v[V_TMP+2], 4, v[V_LANE_MOD32]))  # m_parity
  k.emit(v_and_b32_e32(v[V_TMP+3], 15, v[V_LANE_MOD32]))     # n_in_tile

  for wmma_m in range(4):
    for wmma_n in range(4):
      acc_idx = wmma_m * 4 + wmma_n
      k.emit(v_add_nc_u32_e32(v[V_TMP+4], wmma_n * 16, v[V_TMP+1]))
      k.emit(v_add_nc_u32_e32(v[V_TMP+4], v[V_TMP+3], v[V_TMP+4]))
      for reg in range(8):
        k.emit(v_add_nc_u32_e32(v[V_TMP+5], wmma_m * 16 + 2*reg, v[V_TMP]))
        k.emit(v_add_nc_u32_e32(v[V_TMP+5], v[V_TMP+2], v[V_TMP+5]))
        k.emit(v_mul_lo_u32(v[V_TMP+6], v[V_TMP+5], s[S_DIM_N]))
        k.emit(v_add_nc_u32_e32(v[V_TMP+6], v[V_TMP+4], v[V_TMP+6]))
        k.emit(v_lshlrev_b32_e32(v[V_TMP+6], 1, v[V_TMP+6]))
        k.emit(v_add_co_u32(v[V_OUT_LO], VCC_LO, s[S_C_PTR[0]], v[V_TMP+6]))
        k.emit(v_add_co_ci_u32_e32(v[V_OUT_HI], s[S_C_PTR[1]], v[V_ZERO]))
        k.emit(v_cvt_f16_f32_e32(v[V_TMP+7], v[V_ACC + acc_idx*8 + reg]))
        k.emit(global_store_b16(addr=v[V_OUT_LO:V_OUT_HI], data=v[V_TMP+7], saddr=NULL, offset=0))

  k.emit(s_sendmsg(simm16=3))
  k.emit(s_endpgm())
  return k.finalize()

# =============================================================================
# Entry Point
# =============================================================================
def get_asm_fxn():
  dev = Device[Device.DEFAULT]
  print(f"Device arch: {dev.renderer.arch}")
  insts = build_kernel(N, N, dev.renderer.arch)
  grid, local = (N // BLOCK_N, N // BLOCK_M, 1), (THREADS, 1, 1)
  print(f"Grid: {grid}, Local: {local}")

  dname = Device.DEFAULT
  def asm_kernel(A:UOp, B:UOp, C:UOp) -> UOp:
    gidxs = [UOp.special(n, f"gidx{i}") for i,n in enumerate(grid)]
    lidxs = [UOp.special(n, f"lidx{i}") for i,n in enumerate(local)]
    lds = UOp(Ops.DEFINE_LOCAL, dtypes.uint8.ptr(size=max(LDS_SIZE, 65536//getenv("LIMIT_OCC", 65536)), addrspace=AddrSpace.LOCAL), (), 'lds')
    sink = UOp.sink(A.base, B.base, C.base, lds, *gidxs, *lidxs,
                    arg=KernelInfo(name=colored("wmma_kernel", "cyan"), estimates=Estimates(ops=N*N*N*2, mem=N*N*2*3)))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=dname), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in insts]))))
  return asm_kernel

if __name__ == "__main__":
  test_matmul(get_asm_fxn(), dtype=dtypes.half)
