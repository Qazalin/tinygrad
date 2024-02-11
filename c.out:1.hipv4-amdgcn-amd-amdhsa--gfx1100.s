
<stdin>:	file format elf64-amdgpu

Disassembly of section .text:

0000000000001700 <_Z6kernelPiS_S_>:
	s_load_b128 s[0:3], s[0:1], null                           // 000000001700: F4080000 F8000000
	s_mov_b32 s4, s15                                          // 000000001708: BE84000F
	s_ashr_i32 s5, s15, 31                                     // 00000000170C: 86059F0F
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000001710: BF870009
	s_lshl_b64 s[4:5], s[4:5], 2                               // 000000001714: 84848204
	s_waitcnt lgkmcnt(0)                                       // 000000001718: BF89FC07
	s_add_u32 s2, s2, s4                                       // 00000000171C: 80020402
	s_addc_u32 s3, s3, s5                                      // 000000001720: 82030503
	s_add_u32 s0, s0, s4                                       // 000000001724: 80000400
	s_load_b32 s2, s[2:3], null                                // 000000001728: F4000081 F8000000
	v_mov_b32_e32 v0, 0                                        // 000000001730: 7E000280
	s_addc_u32 s1, s1, s5                                      // 000000001734: 82010501
	s_waitcnt lgkmcnt(0)                                       // 000000001738: BF89FC07
	v_mov_b32_e32 v1, s2                                       // 00000000173C: 7E020202
	global_store_b32 v0, v1, s[0:1]                            // 000000001740: DC6A0000 00000100
	s_nop 0                                                    // 000000001748: BF800000
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)                       // 00000000174C: BFB60003
	s_endpgm                                                   // 000000001750: BFB00000
	s_code_end                                                 // 000000001754: BF9F0000
	s_code_end                                                 // 000000001758: BF9F0000
	s_code_end                                                 // 00000000175C: BF9F0000
	s_code_end                                                 // 000000001760: BF9F0000
	s_code_end                                                 // 000000001764: BF9F0000
	s_code_end                                                 // 000000001768: BF9F0000
	s_code_end                                                 // 00000000176C: BF9F0000
	s_code_end                                                 // 000000001770: BF9F0000
	s_code_end                                                 // 000000001774: BF9F0000
	s_code_end                                                 // 000000001778: BF9F0000
	s_code_end                                                 // 00000000177C: BF9F0000
	s_code_end                                                 // 000000001780: BF9F0000
	s_code_end                                                 // 000000001784: BF9F0000
	s_code_end                                                 // 000000001788: BF9F0000
	s_code_end                                                 // 00000000178C: BF9F0000
	s_code_end                                                 // 000000001790: BF9F0000
	s_code_end                                                 // 000000001794: BF9F0000
	s_code_end                                                 // 000000001798: BF9F0000
	s_code_end                                                 // 00000000179C: BF9F0000
	s_code_end                                                 // 0000000017A0: BF9F0000
	s_code_end                                                 // 0000000017A4: BF9F0000
	s_code_end                                                 // 0000000017A8: BF9F0000
	s_code_end                                                 // 0000000017AC: BF9F0000
	s_code_end                                                 // 0000000017B0: BF9F0000
	s_code_end                                                 // 0000000017B4: BF9F0000
	s_code_end                                                 // 0000000017B8: BF9F0000
	s_code_end                                                 // 0000000017BC: BF9F0000
	s_code_end                                                 // 0000000017C0: BF9F0000
	s_code_end                                                 // 0000000017C4: BF9F0000
	s_code_end                                                 // 0000000017C8: BF9F0000
	s_code_end                                                 // 0000000017CC: BF9F0000
	s_code_end                                                 // 0000000017D0: BF9F0000
	s_code_end                                                 // 0000000017D4: BF9F0000
	s_code_end                                                 // 0000000017D8: BF9F0000
	s_code_end                                                 // 0000000017DC: BF9F0000
	s_code_end                                                 // 0000000017E0: BF9F0000
	s_code_end                                                 // 0000000017E4: BF9F0000
	s_code_end                                                 // 0000000017E8: BF9F0000
	s_code_end                                                 // 0000000017EC: BF9F0000
	s_code_end                                                 // 0000000017F0: BF9F0000
	s_code_end                                                 // 0000000017F4: BF9F0000
	s_code_end                                                 // 0000000017F8: BF9F0000
	s_code_end                                                 // 0000000017FC: BF9F0000
	s_code_end                                                 // 000000001800: BF9F0000
	s_code_end                                                 // 000000001804: BF9F0000
	s_code_end                                                 // 000000001808: BF9F0000
	s_code_end                                                 // 00000000180C: BF9F0000
	s_code_end                                                 // 000000001810: BF9F0000
	s_code_end                                                 // 000000001814: BF9F0000
	s_code_end                                                 // 000000001818: BF9F0000
	s_code_end                                                 // 00000000181C: BF9F0000
	s_code_end                                                 // 000000001820: BF9F0000
	s_code_end                                                 // 000000001824: BF9F0000
	s_code_end                                                 // 000000001828: BF9F0000
	s_code_end                                                 // 00000000182C: BF9F0000
	s_code_end                                                 // 000000001830: BF9F0000
	s_code_end                                                 // 000000001834: BF9F0000
	s_code_end                                                 // 000000001838: BF9F0000
	s_code_end                                                 // 00000000183C: BF9F0000
	s_code_end                                                 // 000000001840: BF9F0000
	s_code_end                                                 // 000000001844: BF9F0000
	s_code_end                                                 // 000000001848: BF9F0000
	s_code_end                                                 // 00000000184C: BF9F0000
	s_code_end                                                 // 000000001850: BF9F0000
	s_code_end                                                 // 000000001854: BF9F0000
	s_code_end                                                 // 000000001858: BF9F0000
	s_code_end                                                 // 00000000185C: BF9F0000
	s_code_end                                                 // 000000001860: BF9F0000
	s_code_end                                                 // 000000001864: BF9F0000
	s_code_end                                                 // 000000001868: BF9F0000
	s_code_end                                                 // 00000000186C: BF9F0000
	s_code_end                                                 // 000000001870: BF9F0000
	s_code_end                                                 // 000000001874: BF9F0000
	s_code_end                                                 // 000000001878: BF9F0000
	s_code_end                                                 // 00000000187C: BF9F0000
	s_code_end                                                 // 000000001880: BF9F0000
	s_code_end                                                 // 000000001884: BF9F0000
	s_code_end                                                 // 000000001888: BF9F0000
	s_code_end                                                 // 00000000188C: BF9F0000
	s_code_end                                                 // 000000001890: BF9F0000
	s_code_end                                                 // 000000001894: BF9F0000
	s_code_end                                                 // 000000001898: BF9F0000
	s_code_end                                                 // 00000000189C: BF9F0000
	s_code_end                                                 // 0000000018A0: BF9F0000
	s_code_end                                                 // 0000000018A4: BF9F0000
	s_code_end                                                 // 0000000018A8: BF9F0000
	s_code_end                                                 // 0000000018AC: BF9F0000
	s_code_end                                                 // 0000000018B0: BF9F0000
	s_code_end                                                 // 0000000018B4: BF9F0000
	s_code_end                                                 // 0000000018B8: BF9F0000
	s_code_end                                                 // 0000000018BC: BF9F0000
	s_code_end                                                 // 0000000018C0: BF9F0000
	s_code_end                                                 // 0000000018C4: BF9F0000
	s_code_end                                                 // 0000000018C8: BF9F0000
	s_code_end                                                 // 0000000018CC: BF9F0000
	s_code_end                                                 // 0000000018D0: BF9F0000
	s_code_end                                                 // 0000000018D4: BF9F0000
	s_code_end                                                 // 0000000018D8: BF9F0000
	s_code_end                                                 // 0000000018DC: BF9F0000
	s_code_end                                                 // 0000000018E0: BF9F0000
	s_code_end                                                 // 0000000018E4: BF9F0000
	s_code_end                                                 // 0000000018E8: BF9F0000
	s_code_end                                                 // 0000000018EC: BF9F0000
	s_code_end                                                 // 0000000018F0: BF9F0000
	s_code_end                                                 // 0000000018F4: BF9F0000
	s_code_end                                                 // 0000000018F8: BF9F0000
	s_code_end                                                 // 0000000018FC: BF9F0000
