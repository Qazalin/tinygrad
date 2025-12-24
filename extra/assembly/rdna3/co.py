# codeobject V3 kernel descriptor for RDNA3
# https://rocm.docs.amd.com/projects/llvm-project/en/latest/LLVM/llvm/html/AMDGPUUsage.html#code-object-v3-kernel-descriptor
import textwrap

template = """.text
.globl fn_name
.p2align 8
.type fn_name,@function
fn_name:
  INSTRUCTION

.rodata
.p2align 6
.amdhsa_kernel fn_name
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_next_free_vgpr .amdgcn.next_free_vgpr
  .amdhsa_next_free_sgpr .amdgcn.next_free_sgpr
  .amdhsa_wavefront_size32 1
.end_amdhsa_kernel

.amdgpu_metadata
---
amdhsa.version:
  - 1
  - 0
amdhsa.kernels:
  - .name: fn_name
    .symbol: fn_name.kd
    .group_segment_fixed_size: 0
    .private_segment_fixed_size: 0
    .wavefront_size: 32
    .sgpr_count: 8
    .vgpr_count: 8
    .max_flat_workgroup_size: 1024
    .kernarg_segment_align: 8
    .kernarg_segment_size: 8
    .args:
      - .address_space:  global
        .name:           a
        .offset:         0
        .size:           8
        .type_name:      'float*'
        .value_kind:     global_buffer
...
.end_amdgpu_metadata
"""

def fmt_asm(src:str, name:str="test") -> str: return template.replace("fn_name", name).replace("INSTRUCTION", textwrap.dedent(src))
