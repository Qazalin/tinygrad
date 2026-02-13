# assembly attention kernels (forward and backward) using aiter FMHA kernels
import pathlib, struct, ctypes, atexit, functools, math
from tinygrad import Tensor, dtypes
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.renderer import Estimates
from tinygrad.helpers import DEBUG

def float_to_u32(f:float) -> int:
  return struct.unpack('I', struct.pack('f', f))[0]

CO_DIR = pathlib.Path(__file__).parent / "co"

class FwdArgs(ctypes.Structure):
  _pack_ = 1
  _fields_ = [
    ("R", ctypes.c_uint64), ("R_pad", ctypes.c_uint64),
    ("Q", ctypes.c_uint64), ("Q_pad", ctypes.c_uint64),
    ("K", ctypes.c_uint64), ("K_pad", ctypes.c_uint64),
    ("V", ctypes.c_uint64), ("V_pad", ctypes.c_uint64),
    ("LSE", ctypes.c_uint64), ("LSE_pad", ctypes.c_uint64),
    ("scalar", ctypes.c_uint32), ("scalar_pad", ctypes.c_uint32 * 3),
    ("seq_len", ctypes.c_uint32), ("seq_len_pad", ctypes.c_uint32 * 3),
    ("Seqs", ctypes.c_uint32), ("Seqs_pad", ctypes.c_uint32 * 3),
    ("Ts", ctypes.c_uint32), ("Ts_pad", ctypes.c_uint32 * 3),
    ("Hs", ctypes.c_uint32), ("Hs_pad", ctypes.c_uint32 * 3),
    ("Bs", ctypes.c_uint32), ("Bs_pad", ctypes.c_uint32 * 3),
    ("gqa", ctypes.c_uint32), ("gqa_pad", ctypes.c_uint32 * 3),
    ("k_Seqs", ctypes.c_uint32), ("k_Seqs_pad", ctypes.c_uint32 * 3),
    ("k_Hs", ctypes.c_uint32), ("k_Hs_pad", ctypes.c_uint32 * 3),
    ("k_Bs", ctypes.c_uint32), ("k_Bs_pad", ctypes.c_uint32 * 3),
    ("msk_opt", ctypes.c_uint32), ("msk_opt_pad", ctypes.c_uint32 * 3),
    ("lse", ctypes.c_uint32), ("lse_pad", ctypes.c_uint32 * 3),
    ("kv_seq_len", ctypes.c_uint32), ("kv_seq_len_pad", ctypes.c_uint32 * 3),
    ("qk_head_dim", ctypes.c_uint32), ("qk_head_dim_pad", ctypes.c_uint32 * 3),
    ("v_head_dim", ctypes.c_uint32), ("v_head_dim_pad", ctypes.c_uint32 * 3),
    ("q_head_num", ctypes.c_uint32), ("q_head_num_pad", ctypes.c_uint32 * 3),
    ("v_Seqs", ctypes.c_uint32), ("v_Seqs_pad", ctypes.c_uint32 * 3),
    ("v_Hs", ctypes.c_uint32), ("v_Hs_pad", ctypes.c_uint32 * 3),
    ("v_Bs", ctypes.c_uint32), ("v_Bs_pad", ctypes.c_uint32 * 3),
    ("r_Seqs", ctypes.c_uint32), ("r_Seqs_pad", ctypes.c_uint32 * 3),
    ("r_Hs", ctypes.c_uint32), ("r_Hs_pad", ctypes.c_uint32 * 3),
    ("r_Bs", ctypes.c_uint32), ("r_Bs_pad", ctypes.c_uint32 * 3),
    ("ptr_qseq", ctypes.c_uint64), ("ptr_qseq_pad", ctypes.c_uint64),
    ("ptr_kseq", ctypes.c_uint64), ("ptr_kseq_pad", ctypes.c_uint64),
    ("lse_Hs", ctypes.c_uint32), ("lse_Hs_pad", ctypes.c_uint32 * 3),
    ("ptr_qseq_padding", ctypes.c_uint64), ("ptr_qseq_padding_pad", ctypes.c_uint64),
    ("ptr_kseq_padding", ctypes.c_uint64), ("ptr_kseq_padding_pad", ctypes.c_uint64),
  ]
assert ctypes.sizeof(FwdArgs) == 512

def vaddr(b) -> int:
  try: return b.va_addr
  except AttributeError: return 1

def build_fwd_kernargs(B, H, S, D, bufs, var_vals) -> bytes:
  """Build raw kernargs for the forward kernel from HCQ buffers."""
  args = FwdArgs()
  args.R, args.Q, args.K, args.V, args.LSE = vaddr(bufs[0]), vaddr(bufs[1]), vaddr(bufs[2]), vaddr(bufs[3]), vaddr(bufs[4])
  args.ptr_qseq, args.ptr_kseq, args.ptr_qseq_padding, args.ptr_kseq_padding = 0, 0, 0, 0
  args.scalar, args.seq_len, args.kv_seq_len = float_to_u32(1.0 / math.sqrt(D)), S, S
  args.qk_head_dim, args.v_head_dim, args.q_head_num, args.gqa = D, D, H, 1
  args.msk_opt, args.lse, args.lse_Hs = 5, 1, S * 4  # causal mask
  elem_size = 2
  Seqs_stride, Hs_stride, Bs_stride = H * D * elem_size, D * elem_size, S * H * D * elem_size
  args.Seqs, args.Ts, args.Hs, args.Bs = Seqs_stride, S * D // 2, Hs_stride, Bs_stride
  args.k_Seqs, args.k_Hs, args.k_Bs = Seqs_stride, Hs_stride, Bs_stride
  args.v_Seqs, args.v_Hs, args.v_Bs = Seqs_stride, Hs_stride, Bs_stride
  args.r_Seqs, args.r_Hs, args.r_Bs = Seqs_stride, Hs_stride, Bs_stride
  return bytes(ctypes.string_at(ctypes.addressof(args), ctypes.sizeof(args)))

def aiter_fmha_fwd(out:UOp, q:UOp, k:UOp, v:UOp, lse:UOp, dname:str) -> UOp:
  """Create the PROGRAM UOp for aiter FMHA forward kernel."""
  B, S, H, D = out.shape
  binary = (CO_DIR / "fwd_hd128_bf16_causal.co").read_bytes()
  gidx0, gidx1, gidx2 = UOp.special(S // 512, "gidx0"), UOp.special(H, "gidx1"), UOp.special(B, "gidx2")
  lidx0 = UOp.special(512, "lidx0")
  kernargs_builder = functools.partial(build_fwd_kernargs, B, H, S, D)
  name = "aiter_fmha_fwd_hd128_bf16_causal"
  ops, mem = B * H * S * S * D * 2, (out.size + q.size + k.size + v.size + lse.size) * 2
  sink = UOp.sink(out.base, q.base, k.base, v.base, lse.base, gidx0, gidx1, gidx2, lidx0,
                  arg=KernelInfo(name=name, estimates=Estimates(ops=ops, mem=mem), kernargs_builder=kernargs_builder))
  src = f"; prebuilt aiter kernel: {name}"
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg=dname), UOp(Ops.LINEAR, src=(*sink.src, sink)),
                               UOp(Ops.SOURCE, arg=src), UOp(Ops.BINARY, arg=binary)))

counters = {"used":0, "todos":[]}
def todo(msg:str) -> bool: counters["todos"].append(msg); return False
atexit.register(lambda: print(f'asm_atn: {counters["used"]} used, {len(counters["todos"])} not used'))

def can_use_asm_atn(q:Tensor, k:Tensor, v:Tensor, attn_mask:Tensor|None=None, dropout_p:float=0.0, is_causal:bool=False, enable_gqa:bool=False):
  if isinstance(q.device, tuple): return todo("no multi yet")
  return True

def asm_atn(q:Tensor, k:Tensor, v:Tensor, **kwargs) -> Tensor:
  assert can_use_asm_atn(q, k, v, **kwargs), counters["todos"][0]
  B, H, S, D = q.shape
  if DEBUG >= 2: print("[asm_atn]", q.shape, k.shape, v.shape)
  dname = q.device[0]
  # asm computes with BSHD
  q_perm, k_perm, v_perm = q.permute(0, 2, 1, 3), k.permute(0, 2, 1, 3), v.permute(0, 2, 1, 3)
  out = Tensor.empty_like(q_perm)
  lse = Tensor.empty((B, H, S), dtype=dtypes.float32)
  out = Tensor.custom_kernel(out, q_perm, k_perm, v_perm, lse, fxn=functools.partial(aiter_fmha_fwd, dname=dname))[0]
  return out.permute(0, 2, 1, 3)
