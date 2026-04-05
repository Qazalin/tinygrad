import unittest
import numpy as np
from tinygrad import Tensor, Device, dtypes
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.renderer import Estimates
from tinygrad.dtype import AddrSpace
from tinygrad.runtime.autogen.amd.rdna4.ins import *
from tinygrad.renderer.amd.dsl import s, v, ttmp, Inst

ARCH = "gfx1201"

class dims:
  """Thread and block index extraction from hardware-initialized registers.
  
  RDNA4 initializes at wave launch:
    VGPR0 = {Z[9:0], Y[9:0], X[9:0]}  (30 bits)
    TTMP9 = blockIdx.x
    TTMP7 = {blockIdx.z, blockIdx.y}
  
  These functions emit instructions to extract individual components.
  """
  
  @staticmethod
  def thread_idx(vdst) -> Inst:
    """Extract threadIdx.x (low 10 bits of VGPR0): vdst = v[0] & 0x3FF"""
    return v_and_b32_e32(vdst=vdst, vsrc1=v[0], src0=0x3FF)
  
  @staticmethod
  def thread_idx_y(vdst) -> Inst:
    """Extract threadIdx.y (bits [19:10]): vdst = (v[0] >> 10) & 0x3FF"""
    return v_lshrrev_b32_e32(vdst=vdst, src0=v[0], src1=10)
  
  @staticmethod
  def thread_idx_z(vdst) -> Inst:
    """Extract threadIdx.z (bits [29:20]): vdst = (v[0] >> 20) & 0x3FF"""
    return v_lshrrev_b32_e32(vdst=vdst, src0=v[0], src1=20)
  
  @staticmethod
  def block_idx_x(sdst) -> Inst:
    """Load blockIdx.x from TTMP9: sdst = ttmp[9]"""
    return s_mov_b32(sdst, ttmp[9])
  
  @staticmethod  
  def block_idx_y(sdst) -> Inst:
    """Extract blockIdx.y from TTMP7 (low 16 bits): sdst = ttmp[7] & 0xFFFF"""
    return s_and_b32(sdst, ttmp[7], 0xFFFF)
  
  @staticmethod
  def block_idx_z(sdst) -> Inst:
    """Extract blockIdx.z from TTMP7 (high 16 bits): sdst = ttmp[7] >> 16"""
    return s_lshr_b32(sdst, ttmp[7], 16)

s_kernarg = s[0:1]

class Kernel:
  """Simple kernel builder for RDNA4 assembly tests."""
  def __init__(self, arch='gfx1201'): self.instructions, self.labels, self.pos, self.arch = [], {}, 0, arch
  def label(self, name): self.labels[name] = self.pos

  def emit(self, inst, target=None):
    self.instructions.append(inst)
    inst._target, inst._pos = target, self.pos
    self.pos += inst.size()
    return inst

  def finalize(self):
    """Patch branch offsets and return the finalized instruction list."""
    for inst in self.instructions:
      if inst._target is None: continue
      offset_dwords = (self.labels[inst._target] - inst._pos - inst.size()) // 4
      if not -32768 <= offset_dwords <= 32767: raise ValueError(f"branch to '{inst._target}' offset {offset_dwords} exceeds simm16 range")
      inst.simm16 = offset_dwords
    return self.instructions

def ptr_offset(param: UOp) -> int:
  """
  Returns the SMEM ioffset for loading param's buffer descriptor.

  Kernel arg buffer layout:
    param 0: offset 0
    param 1: offset 8
    param 2: offset 16
    ...
  """
  assert param.op is Ops.PARAM, f"ptr_offset only valid for PARAM, got {param.op}"
  return param.arg * 8

@unittest.skipUnless(Device.DEFAULT == "AMD", "requires AMD device")
class TestCustomKernel(unittest.TestCase):
  def test_nop(self):
    def test(A:UOp) -> UOp:
      threads = UOp.special(A.size, "lidx0")
      k = Kernel(ARCH); e = k.emit
      e(s_nop(1))
      e(s_endpgm())
      sink = UOp.sink(A.base, threads, arg=KernelInfo("test_nop"))
      return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in k.finalize()]))))
    a = Tensor([1]).realize()
    a = Tensor.custom_kernel(a, fxn=test)[0].realize()
    np.testing.assert_equal(a.numpy(), [1])

  def test_copy(self):
    def test(B:UOp, A:UOp) -> UOp:
      threads = UOp.special(A.size, "lidx0")
      k = Kernel(ARCH); e = k.emit
      # Load buffer descriptors
      e(s_load_b64(sdata=s[(b_ptr:=4):b_ptr+1], sbase=s_kernarg, ioffset=ptr_offset(B), soffset=NULL))  # B (dest)
      e(s_load_b64(sdata=s[(a_ptr:=6):a_ptr+1], sbase=s_kernarg, ioffset=ptr_offset(A), soffset=NULL))  # A (source)
      e(s_wait_kmcnt(simm16=0))
      # Extract threadIdx.x for offset
      e(dims.thread_idx(v[tid:=0]))
      # Load from A (source)
      e(global_load_b32(vdst=v[10], vaddr=v[tid:tid+1], saddr=s[a_ptr:a_ptr+1]))
      e(s_wait_loadcnt(simm16=0))
      # Store to B (dest)
      e(global_store_b32(vaddr=v[tid:tid+1], vsrc=v[10], saddr=s[b_ptr:b_ptr+1]))
      e(s_wait_storecnt(simm16=0))
      e(s_endpgm())
      sink = UOp.sink(B.base, A.base, threads, arg=KernelInfo("test_copy"))
      return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in k.finalize()]))))
    a = Tensor([10]).realize()
    b = Tensor([0]).realize()
    b = Tensor.custom_kernel(b, a, fxn=test)[0].realize()
    np.testing.assert_equal(b.numpy(), [10])

  def test_add(self):
    def test(C:UOp, B:UOp, A:UOp) -> UOp:
      threads = UOp.special(A.size, "lidx0")
      k = Kernel(ARCH); e = k.emit
      # Load buffer descriptors for C (dest), B, and A (sources)
      e(s_load_b64(sdata=s[(c_ptr:=4):c_ptr+1], sbase=s_kernarg, ioffset=ptr_offset(C), soffset=NULL))  # C (dest)
      e(s_load_b64(sdata=s[6:7], sbase=s_kernarg, ioffset=ptr_offset(B), soffset=NULL))  # B (source)
      e(s_load_b64(sdata=s[8:9], sbase=s_kernarg, ioffset=ptr_offset(A), soffset=NULL))  # A (source)
      e(s_wait_kmcnt(simm16=0))
      # Load from A and B
      e(dims.thread_idx(v[tid:=0]))
      e(global_load_b32(vdst=v[10], vaddr=v[tid:tid+1], saddr=s[8:9]))  # load A[0]
      e(global_load_b32(vdst=v[11], vaddr=v[tid:tid+1], saddr=s[6:7]))  # load B[0]
      e(s_wait_loadcnt(simm16=0))
      # Add: v[12] = A[0] + B[0] (use int add since tensors are int32)
      e(v_add_nc_u32_e32(vdst=v[12], src0=v[10], vsrc1=v[11]))
      # Store to C
      e(global_store_b32(vaddr=v[tid:tid+1], vsrc=v[12], saddr=s[c_ptr:c_ptr+1]))
      e(s_wait_storecnt(simm16=0))
      e(s_endpgm())
      sink = UOp.sink(C.base, B.base, A.base, threads, arg=KernelInfo("test_add"))
      return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in k.finalize()]))))
    a = Tensor([3]).realize()
    b = Tensor([4]).realize()
    c = Tensor([0]).realize()
    c = Tensor.custom_kernel(c, b, a, fxn=test)[0].realize()
    np.testing.assert_equal(c.numpy(), [7])

  def test_global_load_tr_b128_layout(self):
    """Test GLOBAL_LOAD_TR_B128 produces WMMA-compatible VGPR layout for 16x16 FP16 B-matrix.

    From RDNA4 ISA spec 7.12.2 and 11.6:
    - B-matrix 16x16 of 16-bit data uses 4 VGPRs per lane in wave32 mode
    - Layout: lane = {row[2], col[3:0]}, vgpr = {row[3], row[1]}, startPosn = row[0]
    - Each lane holds 8 elements: 4 columns × 2 rows (packed as 2x16-bit per VGPR)

    Input matrix (column-major memory, unique values for verification):
      Row 0: [  0,  16,  32,  48,  64,  80,  96, 112, 128, 144, 160, 176, 192, 208, 224, 240]
      Row 1: [  1,  17,  33,  49,  65,  81,  97, 113, 129, 145, 161, 177, 193, 209, 225, 241]
      ...

    Expected VGPR layout after transpose (Wave32, lane 0 which handles rows 0,4,8,12):
      VGPR0 = [mem[0], mem[16]]   = [0, 16]   (row0,col0 and row0,col1)
      VGPR1 = [mem[32], mem[48]]  = [32, 48]  (row0,col2 and row0,col3)
      etc.
    """
    def test(VGPR_data:UOp, Matrix_in:UOp) -> UOp:
      threads = UOp.special(32, "lidx0")  # One wave (32 threads) handles entire 16x16 tile
      k = Kernel(ARCH); e = k.emit
      # Load buffer descriptors
      e(s_load_b64(sdata=s[(out_ptr:=4):out_ptr+1], sbase=s_kernarg, ioffset=ptr_offset(VGPR_data), soffset=NULL))
      e(s_load_b64(sdata=s[(in_ptr:=6):in_ptr+1], sbase=s_kernarg, ioffset=ptr_offset(Matrix_in), soffset=NULL))
      e(s_wait_kmcnt(simm16=0))
      # Get lane ID (threadIdx.x determines which rows this lane handles)
      e(dims.thread_idx(v[lane_id:=0]))
      # Compute address: each lane loads 16 bytes (8 x 16-bit elements from its column group)
      # Address = base + lane_id * 16 (each lane handles 8 contiguous elements in column-major)
      e(v_lshlrev_b32_e32(vdst=v[addr:=1], src0=4, vsrc1=v[lane_id]))  # addr = lane_id << 4 = lane_id * 16
      # Load with transpose: 16x16 FP16 matrix transposed from column-major to row-major layout
      # Writes 4 VGPRs (128 bits) per lane
      e(global_load_tr_b128(vdst=v[10:13], vaddr=v[addr:addr+1], saddr=s[in_ptr:in_ptr+1]))
      e(s_wait_loadcnt(simm16=0))
      # Store VGPRs back to verify layout: output is 32 lanes × 4 VGPRs × 4 bytes = 512 bytes
      # Output address = base + lane_id * 16 (each lane writes 4 VGPRs = 16 bytes)
      e(v_lshlrev_b32_e32(vdst=v[out_addr:=2], src0=4, vsrc1=v[lane_id]))
      e(global_store_b128(vaddr=v[out_addr:out_addr+1], vsrc=v[10:13], saddr=s[out_ptr:out_ptr+1]))
      e(s_wait_storecnt(simm16=0))
      e(s_endpgm())
      sink = UOp.sink(VGPR_data.base, Matrix_in.base, threads, arg=KernelInfo("test_global_load_tr_b128_layout"))
      return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in k.finalize()]))))

    # Create 16x16 FP16 test matrix in column-major order with unique values
    # Value at (row, col) = row * 16 + col (stored column-major, so linear index = col * 16 + r)
    # Flatten to 1D for Tensor (256 elements)
    values = np.arange(256, dtype=np.float16).reshape(16, 16)  # row-major numpy
    matrix_flat = values.T.copy().reshape(-1)  # Transpose to column-major, then flatten
    matrix_in = Tensor(matrix_flat, dtype=dtypes.float16).realize()

    # Output buffer: 32 lanes × 4 VGPRs per lane × 4 bytes = 512 bytes = 256 halfs
    vgpr_data = Tensor(np.zeros(256, dtype=np.float16), dtype=dtypes.float16).realize()

    # Run kernel
    vgpr_data = Tensor.custom_kernel(vgpr_data, matrix_in, fxn=test)[0].realize()
    result = vgpr_data.numpy()

    # Verify VGPR layout matches WMMA B-matrix specification
    # From actual hardware (RDNA4 ISA spec 7.12.2, B-matrix 16x16 16-bit wave32):
    #
    # Each lane holds 8 FP16 elements: 2 rows × 4 consecutive columns (cols 0-3)
    # VGPR0: [rowN_col0, rowN+8_col0]
    # VGPR1: [rowN_col1, rowN+8_col1]
    # VGPR2: [rowN_col2, rowN+8_col2]
    # VGPR3: [rowN_col3, rowN+8_col3]
    #
    # Lane N handles rows N and N+8 for columns 0-3 (where N = 0..7)
    # Lane 0: rows 0,8; Lane 1: rows 1,9; Lane 2: rows 2,10; etc.

    lane0 = result[0:8]     # Lane 0: rows 0,8 of cols 0,1,2,3
    lane1 = result[8:16]    # Lane 1: rows 1,9 of cols 0,1,2,3
    lane4 = result[32:40]   # Lane 4: rows 4,12 of cols 0,1,2,3

    # Lane 0: rows 0,8 of cols 0,1,2,3
    self.assertEqual(lane0[0], values[0, 0], f"lane0 VGPR0[0] = row0 col0")
    self.assertEqual(lane0[1], values[8, 0], f"lane0 VGPR0[1] = row8 col0")
    self.assertEqual(lane0[2], values[0, 1], f"lane0 VGPR1[0] = row0 col1")
    self.assertEqual(lane0[3], values[8, 1], f"lane0 VGPR1[1] = row8 col1")
    self.assertEqual(lane0[4], values[0, 2], f"lane0 VGPR2[0] = row0 col2")
    self.assertEqual(lane0[5], values[8, 2], f"lane0 VGPR2[1] = row8 col2")

    # Lane 1: rows 1,9 of cols 0,1,2,3
    self.assertEqual(lane1[0], values[1, 0], f"lane1 VGPR0[0] = row1 col0")
    self.assertEqual(lane1[1], values[9, 0], f"lane1 VGPR0[1] = row9 col0")
    self.assertEqual(lane1[2], values[1, 1], f"lane1 VGPR1[0] = row1 col1")
    self.assertEqual(lane1[3], values[9, 1], f"lane1 VGPR1[1] = row9 col1")

    # Lane 4: rows 4,12 of cols 0,1,2,3
    self.assertEqual(lane4[0], values[4, 0], f"lane4 VGPR0[0] = row4 col0")
    self.assertEqual(lane4[1], values[12, 0], f"lane4 VGPR0[1] = row12 col0")
    self.assertEqual(lane4[2], values[4, 1], f"lane4 VGPR1[0] = row4 col1")
    self.assertEqual(lane4[3], values[12, 1], f"lane4 VGPR1[1] = row12 col1")

if __name__ == "__main__":
  unittest.main()
