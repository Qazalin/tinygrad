
<stdin>:	file format elf64-amdgpu

Disassembly of section .text:

0000000000001700 <E_975_3>:
	s_load_b256 s[0:7], s[0:1], null                           // 000000001700: F40C0000 F8000000
	v_mad_u64_u32 v[1:2], null, s15, 3, v[0:1]                 // 000000001708: D6FE7C01 0401060F
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000001710: BF870091
	v_ashrrev_i32_e32 v2, 31, v1                               // 000000001714: 3404029F
	v_lshlrev_b64 v[0:1], 2, v[1:2]                            // 000000001718: D73C0000 00020282
	s_waitcnt lgkmcnt(0)                                       // 000000001720: BF89FC07
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000001724: BF870111
	v_add_co_u32 v2, vcc_lo, s2, v0                            // 000000001728: D7006A02 00020002
	v_add_co_ci_u32_e32 v3, vcc_lo, s3, v1, vcc_lo             // 000000001730: 40060203
	v_add_co_u32 v4, vcc_lo, s4, v0                            // 000000001734: D7006A04 00020004
	v_add_co_ci_u32_e32 v5, vcc_lo, s5, v1, vcc_lo             // 00000000173C: 400A0205
	v_add_co_u32 v6, vcc_lo, s6, v0                            // 000000001740: D7006A06 00020006
	v_add_co_ci_u32_e32 v7, vcc_lo, s7, v1, vcc_lo             // 000000001748: 400E0207
	global_load_b32 v2, v[2:3], off                            // 00000000174C: DC520000 027C0002
	global_load_b32 v3, v[4:5], off                            // 000000001754: DC520000 037C0004
	global_load_b32 v4, v[6:7], off                            // 00000000175C: DC520000 047C0006
	v_add_co_u32 v0, vcc_lo, s0, v0                            // 000000001764: D7006A00 00020000
	v_add_co_ci_u32_e32 v1, vcc_lo, s1, v1, vcc_lo             // 00000000176C: 40020201
	s_waitcnt vmcnt(1)                                         // 000000001770: BF8907F7
	v_add_f32_e32 v2, v2, v3                                   // 000000001774: 06040702
	s_waitcnt vmcnt(0)                                         // 000000001778: BF8903F7
	s_delay_alu instid0(VALU_DEP_1)                            // 00000000177C: BF870001
	v_add_f32_e32 v2, v2, v4                                   // 000000001780: 06040902
	global_store_b32 v[0:1], v2, off                           // 000000001784: DC6A0000 007C0200
	s_nop 0                                                    // 00000000178C: BF800000
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)                       // 000000001790: BFB60003
	s_endpgm                                                   // 000000001794: BFB00000
