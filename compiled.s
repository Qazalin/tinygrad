
<stdin>:	file format elf64-amdgpu

Disassembly of section .text:

0000000000001600 <r_256_16_16>:
	s_not_b32 s3, s15                                          // 000000001600: BE831E0F
	v_mul_i32_i24_e32 v1, -16, v0                              // 000000001604: 120200D0
	v_mad_i32_i24 v2, v0, -16, s3                              // 000000001608: D60A0002 000DA100
	s_mov_b32 s2, s15                                          // 000000001610: BE82000F
	v_lshlrev_b32_e32 v0, 2, v0                                // 000000001614: 30000082
	s_load_b64 s[0:1], s[0:1], null                            // 000000001618: F4040000 F8000000
	v_subrev_nc_u32_e32 v1, s2, v1                             // 000000001620: 4E020202
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v2                    // 000000001624: 7C8804FF FFFFFF02
	s_ashr_i32 s3, s15, 31                                     // 00000000162C: 86039F0F
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000001630: BF870119
	s_lshl_b64 s[2:3], s[2:3], 2                               // 000000001634: 84828202
	v_add_nc_u32_e32 v3, -2, v1                                // 000000001638: 4A0602C2
	v_cndmask_b32_e64 v2, 0, 1, vcc_lo                         // 00000000163C: D5010002 01A90280
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v1                    // 000000001644: 7C8802FF FFFFFF02
	v_add_nc_u32_e32 v5, -4, v1                                // 00000000164C: 4A0A02C4
	v_add_nc_u32_e32 v4, -3, v1                                // 000000001650: 4A0802C3
	v_add_nc_u32_e32 v7, -6, v1                                // 000000001654: 4A0E02C6
	v_add_nc_u32_e32 v6, -5, v1                                // 000000001658: 4A0C02C5
	v_add_co_ci_u32_e32 v2, vcc_lo, 0, v2, vcc_lo              // 00000000165C: 40040480
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v3                    // 000000001660: 7C8806FF FFFFFF02
	v_add_nc_u32_e32 v9, -8, v1                                // 000000001668: 4A1202C8
	v_add_nc_u32_e32 v8, -7, v1                                // 00000000166C: 4A1002C7
	v_cndmask_b32_e64 v3, 0, 1, vcc_lo                         // 000000001670: D5010003 01A90280
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v5                    // 000000001678: 7C880AFF FFFFFF02
	s_waitcnt lgkmcnt(0)                                       // 000000001680: BF89FC07
	s_add_u32 s0, s0, s2                                       // 000000001684: 80000200
	s_addc_u32 s1, s1, s3                                      // 000000001688: 82010301
	v_cndmask_b32_e64 v5, 0, 1, vcc_lo                         // 00000000168C: D5010005 01A90280
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v4                    // 000000001694: 7C8808FF FFFFFF02
	v_add_co_ci_u32_e32 v2, vcc_lo, v2, v3, vcc_lo             // 00000000169C: 40040702
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v7                    // 0000000016A0: 7C880EFF FFFFFF02
	v_cndmask_b32_e64 v3, 0, 1, vcc_lo                         // 0000000016A8: D5010003 01A90280
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v6                    // 0000000016B0: 7C880CFF FFFFFF02
	s_delay_alu instid0(VALU_DEP_4)                            // 0000000016B8: BF870004
	v_add_co_ci_u32_e32 v2, vcc_lo, v2, v5, vcc_lo             // 0000000016BC: 40040B02
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v9                    // 0000000016C0: 7C8812FF FFFFFF02
	v_add_nc_u32_e32 v5, -9, v1                                // 0000000016C8: 4A0A02C9
	v_cndmask_b32_e64 v4, 0, 1, vcc_lo                         // 0000000016CC: D5010004 01A90280
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v8                    // 0000000016D4: 7C8810FF FFFFFF02
	v_mov_b32_e32 v8, 0                                        // 0000000016DC: 7E100280
	v_add_co_ci_u32_e32 v2, vcc_lo, v2, v3, vcc_lo             // 0000000016E0: 40040702
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v5                    // 0000000016E4: 7C880AFF FFFFFF02
	v_add_nc_u32_e32 v3, -10, v1                               // 0000000016EC: 4A0602CA
	v_add_nc_u32_e32 v5, -12, v1                               // 0000000016F0: 4A0A02CC
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_4)// 0000000016F4: BF870224
	v_add_co_ci_u32_e32 v2, vcc_lo, v2, v4, vcc_lo             // 0000000016F8: 40040902
	v_add_nc_u32_e32 v4, -11, v1                               // 0000000016FC: 4A0802CB
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v3                    // 000000001700: 7C8806FF FFFFFF02
	v_cndmask_b32_e64 v3, 0, 1, vcc_lo                         // 000000001708: D5010003 01A90280
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000001710: BF870113
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v4                    // 000000001714: 7C8808FF FFFFFF02
	v_add_co_ci_u32_e32 v2, vcc_lo, v2, v3, vcc_lo             // 00000000171C: 40040702
	v_add_nc_u32_e32 v3, -13, v1                               // 000000001720: 4A0602CD
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v5                    // 000000001724: 7C880AFF FFFFFF02
	v_add_nc_u32_e32 v5, -14, v1                               // 00000000172C: 4A0A02CE
	v_add_nc_u32_e32 v1, -15, v1                               // 000000001730: 4A0202CF
	v_cndmask_b32_e64 v4, 0, 1, vcc_lo                         // 000000001734: D5010004 01A90280
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v3                    // 00000000173C: 7C8806FF FFFFFF02
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)// 000000001744: BF870142
	v_add_co_ci_u32_e32 v2, vcc_lo, v2, v4, vcc_lo             // 000000001748: 40040902
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v5                    // 00000000174C: 7C880AFF FFFFFF02
	v_cndmask_b32_e64 v3, 0, 1, vcc_lo                         // 000000001754: D5010003 01A90280
	v_cmp_gt_i32_e32 vcc_lo, 0xffffff02, v1                    // 00000000175C: 7C8802FF FFFFFF02
	v_add_co_ci_u32_e32 v1, vcc_lo, v2, v3, vcc_lo             // 000000001764: 40020702
	ds_store_b32 v0, v1                                        // 000000001768: D8340000 00000100
	s_waitcnt lgkmcnt(0)                                       // 000000001770: BF89FC07
	s_waitcnt lgkmcnt(0)                                       // 000000001774: BF89FC07
	ds_load_b128 v[0:3], v8                                    // 000000001778: DBFC0000 00000008
	ds_load_b128 v[4:7], v8 offset:16                          // 000000001780: DBFC0010 04000008
	s_waitcnt lgkmcnt(1)                                       // 000000001788: BF89FC17
	v_add_nc_u32_e32 v0, v1, v0                                // 00000000178C: 4A000101
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000001790: BF870091
	v_add_nc_u32_e32 v0, v2, v0                                // 000000001794: 4A000102
	v_add_nc_u32_e32 v0, v3, v0                                // 000000001798: 4A000103
	s_waitcnt lgkmcnt(0)                                       // 00000000179C: BF89FC07
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_1)// 0000000017A0: BF8700B1
	v_add_nc_u32_e32 v4, v4, v0                                // 0000000017A4: 4A080104
	ds_load_b128 v[0:3], v8 offset:32                          // 0000000017A8: DBFC0020 00000008
	v_add_nc_u32_e32 v4, v5, v4                                // 0000000017B0: 4A080905
	v_add_nc_u32_e32 v4, v6, v4                                // 0000000017B4: 4A080906
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)// 0000000017B8: BF8700C1
	v_add_nc_u32_e32 v9, v7, v4                                // 0000000017BC: 4A120907
	ds_load_b128 v[4:7], v8 offset:48                          // 0000000017C0: DBFC0030 04000008
	s_waitcnt lgkmcnt(1)                                       // 0000000017C8: BF89FC17
	v_add_nc_u32_e32 v0, v0, v9                                // 0000000017CC: 4A001300
	v_add_nc_u32_e32 v0, v1, v0                                // 0000000017D0: 4A000101
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 0000000017D4: BF870091
	v_add_nc_u32_e32 v0, v2, v0                                // 0000000017D8: 4A000102
	v_add_nc_u32_e32 v0, v3, v0                                // 0000000017DC: 4A000103
	s_waitcnt lgkmcnt(0)                                       // 0000000017E0: BF89FC07
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 0000000017E4: BF870091
	v_add_nc_u32_e32 v0, v4, v0                                // 0000000017E8: 4A000104
	v_add_nc_u32_e32 v0, v5, v0                                // 0000000017EC: 4A000105
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 0000000017F0: BF870091
	v_add_nc_u32_e32 v0, v6, v0                                // 0000000017F4: 4A000106
	v_add_nc_u32_e32 v0, v7, v0                                // 0000000017F8: 4A000107
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000017FC: BF870001
	v_add_nc_u32_e32 v0, -1, v0                                // 000000001800: 4A0000C1
	global_store_b32 v8, v0, s[0:1]                            // 000000001804: DC6A0000 00000008
	s_nop 0                                                    // 00000000180C: BF800000
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)                       // 000000001810: BFB60003
	s_endpgm                                                   // 000000001814: BFB00000
