#!/usr/bin/env python3
"""Static safety/resource checks for the pipelined transparent-LDS kernel."""
from extra.gemm.cdna_lib.mxfp4 import LLAMA_SHAPES
from extra.gemm.cdna_lib.phase2_lds import USED_LDS_BYTES
from extra.gemm.cdna_lib.phase2_lds_pipe import STAGE_BYTES, USED_PIPE_LDS_BYTES, LDS_BYTES, build_lds_pipelined_kernel
from extra.gemm.cdna_lib.resources import scan_resources
from extra.gemm.cdna_lib.test_lds_mapping import prove_stage_to_operands, prove_production_bounds


def prove_double_stage_layout() -> None:
  assert STAGE_BYTES == USED_LDS_BYTES == 69632
  assert USED_PIPE_LDS_BYTES == 139264
  assert LDS_BYTES == 139520 and LDS_BYTES < 160*1024
  # Stage 1 is a pure translation of stage 0 and the regions are disjoint.
  s0=range(0, STAGE_BYTES); s1=range(STAGE_BYTES, 2*STAGE_BYTES)
  assert s0.stop == s1.start and s1.stop == USED_PIPE_LDS_BYTES


def prove_isa() -> None:
  insts=build_lds_pipelined_kernel(16384,4096,4096)
  r=scan_resources(insts)
  assert r.regular_vgprs == 128 and r.accvgprs == 128 and r.allocated_combined_vgprs == 256, r
  names=[getattr(x,'op_name','') for x in insts]
  # Static code has initial stage plus one write/read sequence in each alternating loop body.
  assert names.count('S_BARRIER') == 3
  assert names.count('DS_WRITE_B128') == 24 and names.count('DS_WRITE_B32') == 6
  assert names.count('DS_READ_B128') == 48 and names.count('DS_READ_B32') == 12
  # Each body contains one normal 64-MFMA path plus a duplicated 12-MFMA final tail.
  assert names.count('V_MFMA_SCALE_F32_16X16X128_F8F6F4') == 152
  # No direct-to-LDS experiment here: transport is byte-identical v14 loads+writes.
  for x in insts:
    if getattr(x,'op_name','').startswith('BUFFER_LOAD'):
      assert not getattr(x,'lds',0), x
  print('phase2_lds_pipe resources:', r.one_line(), f'lds={USED_PIPE_LDS_BYTES}/{LDS_BYTES}', f'code={sum(x.size() for x in insts)}B')


def main() -> None:
  prove_double_stage_layout()
  for K in sorted({x[2] for x in LLAMA_SHAPES}): prove_stage_to_operands(K)
  for sh in LLAMA_SHAPES: prove_production_bounds(*sh)
  prove_isa()
  print('phase2 LDS pipeline mapping/resources passed')

if __name__ == '__main__': main()
