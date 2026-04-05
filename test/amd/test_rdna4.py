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
    def test(VGPR_data:UOp, Matrix_in:UOp) -> UOp:
      VGPR_data = VGPR_data.flatten().base
      Matrix_in = Matrix_in.flatten().base
      threads = UOp.special(32, "lidx0")  # One wave (32 threads) handles entire 16x16 tile
      k = Kernel(ARCH); e = k.emit
      # Load buffer descriptors
      e(s_load_b64(sdata=s[(out_ptr:=4):out_ptr+1], sbase=s_kernarg, ioffset=ptr_offset(VGPR_data), soffset=NULL))
      e(s_load_b64(sdata=s[(in_ptr:=6):in_ptr+1], sbase=s_kernarg, ioffset=ptr_offset(Matrix_in), soffset=NULL))
      e(s_wait_kmcnt(simm16=0))
      # Get lane ID (threadIdx.x determines which rows this lane handles)
      e(dims.thread_idx(v[lane_id:=0]))
      # Compute address: each lane loads 16 bytes (8 x 16-bit elements)
      # Address = base + lane_id * 16
      e(v_lshlrev_b32_e32(vdst=v[addr:=1], src0=4, vsrc1=v[lane_id]))  # addr = lane_id << 4 = lane_id * 16
      # Load with transpose: 16x16 FP16 matrix transposed from row-major to column-major layout
      # Writes 4 VGPRs (128 bits) per lane
      e(global_load_tr_b128(vdst=v[10:13], vaddr=v[addr:addr+1], saddr=s[in_ptr:in_ptr+1]))
      e(s_wait_loadcnt(simm16=0))
      # Store VGPRs back: output is 32 lanes × 4 VGPRs × 4 bytes = 512 bytes
      # Output address = base + lane_id * 16
      e(v_lshlrev_b32_e32(vdst=v[out_addr:=2], src0=4, vsrc1=v[lane_id]))
      e(global_store_b128(vaddr=v[out_addr:out_addr+1], vsrc=v[10:13], saddr=s[out_ptr:out_ptr+1]))
      e(s_wait_storecnt(simm16=0))
      e(s_endpgm())
      sink = UOp.sink(VGPR_data.base, Matrix_in.base, threads, arg=KernelInfo("test_global_load_tr_b128_layout"))
      return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in k.finalize()]))))

    # Input: 16x16 row-major matrix
    matrix_in = Tensor(np.arange(256, dtype=np.float16).reshape(16, 16), dtype=dtypes.float16).contiguous().realize()
    # Output: 32 lanes x 8 halfs (256 elements)
    vgpr_data = Tensor(np.zeros(256, dtype=np.float16).reshape(16, 16), dtype=dtypes.float16).contiguous().realize()

    # Run kernel
    vgpr_data = Tensor.custom_kernel(vgpr_data, matrix_in, fxn=test)[0].realize()

    result = vgpr_data.numpy()

    # GLOBAL_LOAD_TR_B128 on row-major input produces the transpose (column-major)
    tinygrad_ref = matrix_in.permute(1, 0)

    np.testing.assert_allclose(result, tinygrad_ref.numpy(), atol=1e-2, rtol=1e-2)

if __name__ == "__main__":
  unittest.main()
