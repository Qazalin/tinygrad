
<stdin>:	file format elf64-amdgpu

Disassembly of section .text:

0000000000001700 <wmma_rdna3>:
	s_load_b128 s[4:7], s[0:1], null                           // 000000001700: F4080100 F8000000
	v_and_b32_e32 v9, 15, v0                                   // 000000001708: 3612008F
	s_load_b64 s[0:1], s[0:1], 0x10                            // 00000000170C: F4040000 F8000010
	v_lshlrev_b32_e32 v0, 1, v0                                // 000000001714: 30000081
	s_delay_alu instid0(VALU_DEP_2)                            // 000000001718: BF870002
	v_lshlrev_b32_e32 v17, 1, v9                               // 00000000171C: 30221281
	s_waitcnt lgkmcnt(0)                                       // 000000001720: BF89FC07
	s_clause 0x7                                               // 000000001724: BF850007
	global_load_u16 v1, v17, s[6:7]                            // 000000001728: DC4A0000 01060011
	global_load_u16 v2, v17, s[6:7] offset:64                  // 000000001730: DC4A0040 02060011
	global_load_u16 v3, v17, s[6:7] offset:128                 // 000000001738: DC4A0080 03060011
	global_load_u16 v4, v17, s[6:7] offset:192                 // 000000001740: DC4A00C0 04060011
	global_load_u16 v5, v17, s[6:7] offset:256                 // 000000001748: DC4A0100 05060011
	global_load_u16 v6, v17, s[6:7] offset:320                 // 000000001750: DC4A0140 06060011
	global_load_u16 v7, v17, s[6:7] offset:384                 // 000000001758: DC4A0180 07060011
	global_load_u16 v8, v17, s[6:7] offset:448                 // 000000001760: DC4A01C0 08060011
	v_lshlrev_b32_e32 v13, 5, v9                               // 000000001768: 301A1285
	s_clause 0x1                                               // 00000000176C: BF850001
	global_load_b128 v[9:12], v13, s[4:5]                      // 000000001770: DC5E0000 0904000D
	global_load_b128 v[13:16], v13, s[4:5] offset:16           // 000000001778: DC5E0010 0D04000D
	s_clause 0x7                                               // 000000001780: BF850007
	global_load_d16_hi_b16 v1, v17, s[6:7] offset:32           // 000000001784: DC8E0020 01060011
	global_load_d16_hi_b16 v2, v17, s[6:7] offset:96           // 00000000178C: DC8E0060 02060011
	global_load_d16_hi_b16 v3, v17, s[6:7] offset:160          // 000000001794: DC8E00A0 03060011
	global_load_d16_hi_b16 v4, v17, s[6:7] offset:224          // 00000000179C: DC8E00E0 04060011
	global_load_d16_hi_b16 v5, v17, s[6:7] offset:288          // 0000000017A4: DC8E0120 05060011
	global_load_d16_hi_b16 v6, v17, s[6:7] offset:352          // 0000000017AC: DC8E0160 06060011
	global_load_d16_hi_b16 v7, v17, s[6:7] offset:416          // 0000000017B4: DC8E01A0 07060011
	global_load_d16_hi_b16 v8, v17, s[6:7] offset:480          // 0000000017BC: DC8E01E0 08060011
	v_mov_b32_e32 v17, 0                                       // 0000000017C4: 7E220280
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000017C8: BF870001
	v_mov_b32_e32 v18, v17                                     // 0000000017CC: 7E240311
	v_mov_b32_e32 v19, v17                                     // 0000000017D0: 7E260311
	v_mov_b32_e32 v20, v17                                     // 0000000017D4: 7E280311
	v_mov_b32_e32 v21, v17                                     // 0000000017D8: 7E2A0311
	v_mov_b32_e32 v22, v17                                     // 0000000017DC: 7E2C0311
	v_mov_b32_e32 v23, v17                                     // 0000000017E0: 7E2E0311
	v_mov_b32_e32 v24, v17                                     // 0000000017E4: 7E300311
	s_waitcnt vmcnt(0)                                         // 0000000017E8: BF8903F7
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000017EC: BF870001
	v_wmma_f16_16x16x16_f16 v[17:24], v[9:16], v[1:8], v[17:24]// 0000000017F0: CC424011 1C460309
	s_clause 0x7                                               // 0000000017F8: BF850007
	global_store_b16 v0, v17, s[0:1]                           // 0000000017FC: DC660000 00001100
	global_store_b16 v0, v18, s[0:1] offset:64                 // 000000001804: DC660040 00001200
	global_store_b16 v0, v19, s[0:1] offset:128                // 00000000180C: DC660080 00001300
	global_store_b16 v0, v20, s[0:1] offset:192                // 000000001814: DC6600C0 00001400
	global_store_b16 v0, v21, s[0:1] offset:256                // 00000000181C: DC660100 00001500
	global_store_b16 v0, v22, s[0:1] offset:320                // 000000001824: DC660140 00001600
	global_store_b16 v0, v23, s[0:1] offset:384                // 00000000182C: DC660180 00001700
	global_store_b16 v0, v24, s[0:1] offset:448                // 000000001834: DC6601C0 00001800
	s_nop 0                                                    // 00000000183C: BF800000
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)                       // 000000001840: BFB60003
	s_endpgm                                                   // 000000001844: BFB00000
