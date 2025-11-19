.text
.rodata
.p2align 6
.amdhsa_kernel E_3
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_next_free_vgpr .amdgcn.next_free_vgpr
  .amdhsa_next_free_sgpr .amdgcn.next_free_sgpr
  .amdhsa_wavefront_size32 1
.end_amdhsa_kernel
.globl E_3
.p2align 8
.type E_3,@function
E_3:
	s_clause 0x1                                               // 000000001600: BF850001
	s_load_b128 s[4:7], s[0:1], null                           // 000000001604: F4080100 F8000000
	s_load_b64 s[0:1], s[0:1], 0x10                            // 00000000160C: F4040000 F8000010
	v_lshlrev_b32_e32 v0, 2, v0                                // 000000001614: 30000082
	s_waitcnt lgkmcnt(0)                                       // 000000001618: BF89FC07
	s_clause 0x1                                               // 00000000161C: BF850001
	global_load_b32 v1, v0, s[6:7]                             // 000000001620: DC520000 01060000
	global_load_b32 v2, v0, s[0:1]                             // 000000001628: DC520000 02000000
	s_waitcnt vmcnt(0)                                         // 000000001630: BF8903F7
	// v_mul_f32_e32 v1, v1, v2                                   // 000000001634: 06020501
	v_add_f32_e32 v1, v1, v2                                   // 000000001634: 06020501
	global_store_b32 v0, v1, s[4:5]                            // 000000001638: DC6A0000 00040100
	s_nop 0                                                    // 000000001640: BF800000
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)                       // 000000001644: BFB60003
	s_endpgm                                                   // 000000001648: BFB00000
.amdgpu_metadata
---
amdhsa.kernels:
  - .args:
      - .address_space:  global
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         8
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         16
        .size:           8
        .value_kind:     global_buffer
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 24
    .language:       OpenCL C
    .language_version:
      - 2
      - 0
    .max_flat_workgroup_size: 3
    .name:           E_3
    .private_segment_fixed_size: 0
    .sgpr_count:     8
    .sgpr_spill_count: 0
    .symbol:         E_3.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     3
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx1100
amdhsa.version:
  - 1
  - 2
...
.end_amdgpu_metadata
