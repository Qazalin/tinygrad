# ruff: noqa: F403,F405
from extra.gemm.gemm_mxfp4 import Kernel, build_kernel as build_generic
from tinygrad.helpers import getenv
from tinygrad.runtime.autogen.amd.cdna.ins import *

LDS_BYTES = 81920

def get_launch_config(M:int, N:int, K:int):
  assert M == 16384 and N in (14336, 28672) and K == 4096
  groups = getenv("MXFP4_SK_GROUPS", 256)
  assert groups >= 32 and groups % 32 == 0
  grid_x = getenv("MXFP4_SK_GRID_X", 32)
  assert groups % grid_x == 0
  return 256, (grid_x, groups//grid_x)

def build_kernel(M:int, N:int, K:int):
  """Persistent short-K kernel with next-tile input prefetch under the C epilogue."""
  groups = get_launch_config(M, N, K)[1][0] * get_launch_config(M, N, K)[1][1]
  insts = build_generic(M, N, K, 256, 256, persist_groups_override=groups)
  positions = {x._pos:i for i,x in enumerate(insts)}
  labels = {}
  for x in insts:
    if x._target is not None:
      delta = x.simm16 if x.simm16 < 32768 else x.simm16-65536
      labels[x._target] = positions[x._pos+x.size()+4*delta]
  labels_at = {i:[name for name, pos in labels.items() if pos == i] for i in labels.values()}
  first_lds = next(i for i,x in enumerate(insts) if x.op_name == 'DS_READ_B128')
  epilogue = labels['L2_3B10']
  transition = next(i for i in range(epilogue, len(insts))
                    if insts[i].op_name == 'S_ADD_U32' and str(insts[i]) == 's_add_u32(s[65], s[65], s[66])')
  assert insts[first_lds-2].op_name == 'S_WAITCNT' and insts[first_lds-1].op_name == 'S_BARRIER'
  assert insts[epilogue].op_name == 'S_WAITCNT' and insts[epilogue+1].op_name == 'S_BARRIER'

  k = Kernel()
  def copy(start:int, end:int, suffix:str, transform=None):
    for i in range(start, end):
      for name in labels_at.get(i, []): k.label(name+suffix)
      old = insts[i]
      x = type(old).from_bytes(old.to_bytes())
      if transform is not None and (x:=transform(x)) is None: continue
      k.emit(x, target=old._target+suffix if old._target is not None else None)

  copy(0, first_lds, '_first')
  k.label('compute_tile')
  copy(first_lds, epilogue+2, '_compute')
  k.emit(s_add_u32(s[65], s[65], s[66]))
  k.emit(s_cmp_lt_u32(s[65], s[67]))
  k.emit(s_cbranch_scc0(), target='final_epilogue')
  for j in range(4): k.emit(s_mov_b32(s[84+j], s[4+j]))
  for live, saved in ((4, 68), (12, 70), (16, 72), (20, 74), (24, 76)):
    k.emit(s_mov_b64(s[live:live+1], s[saved:saved+1]))
  for reg, value in ((36, N), (37, K), (38, K), (39, K//32), (40, K//32), (45, K)):
    k.emit(s_mov_b32(s[reg], value))

  def prefetch(x): return None if x.op_name == 'V_ACCVGPR_WRITE' else x
  copy(labels['L2_TILE'], first_lds-2, '_next', prefetch)

  for i in range(epilogue+2, transition):
    old = insts[i]
    x = type(old).from_bytes(old.to_bytes())
    if x.op_name == 'BUFFER_STORE_DWORDX4': x.srsrc = s[84:87]
    k.emit(x)
    if x.op_name == 'V_ACCVGPR_READ': k.emit(v_accvgpr_write(x.src0, 0))
  k.emit(s_waitcnt(20345))
  k.emit(s_barrier())
  k.emit(s_branch(), target='compute_tile')

  k.label('final_epilogue')
  copy(epilogue+2, transition, '_final')
  k.emit(s_waitcnt())
  k.emit(s_endpgm())
  return k.finalize()
