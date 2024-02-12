
<stdin>:	file format elf64-amdgpu

Disassembly of section .text:

0000000000001600 <test>:
	v_bfe_u32 v4, v0, 20, 10                                   // 000000001600: D6100004 02292900
	v_mov_b32_e32 v41, 0                                       // 000000001608: 7E520280
	s_load_b128 s[4:7], s[0:1], null                           // 00000000160C: F4080100 F8000000
	s_lshl_b32 s8, s15, 17                                     // 000000001614: 8408910F
	s_load_b64 s[0:1], s[0:1], 0x10                            // 000000001618: F4040000 F8000010
	v_lshlrev_b32_e32 v4, 6, v4                                // 000000001620: 30080886
	v_dual_mov_b32 v42, v41 :: v_dual_and_b32 v3, 0x3ff, v0    // 000000001624: CA240129 2A0200FF 000003FF
	s_lshl_b32 s2, s14, 8                                      // 000000001630: 8402880E
	v_mov_b32_e32 v43, v41                                     // 000000001634: 7E560329
	v_mov_b32_e32 v45, v41                                     // 000000001638: 7E5A0329
	s_delay_alu instid0(VALU_DEP_3)                            // 00000000163C: BF870003
	v_lshl_add_u32 v1, v3, 11, s8                              // 000000001640: D6460001 00211703
	v_add3_u32 v163, s2, v4, v3                                // 000000001648: D65500A3 040E0802
	v_mov_b32_e32 v44, v41                                     // 000000001650: 7E580329
	v_mov_b32_e32 v46, v41                                     // 000000001654: 7E5C0329
	v_mov_b32_e32 v47, v41                                     // 000000001658: 7E5E0329
	v_ashrrev_i32_e32 v2, 31, v1                               // 00000000165C: 3404029F
	v_dual_mov_b32 v161, v163 :: v_dual_mov_b32 v48, v41       // 000000001660: CA1001A3 A1300129
	v_mov_b32_e32 v17, v41                                     // 000000001668: 7E220329
	v_mov_b32_e32 v18, v41                                     // 00000000166C: 7E240329
	s_delay_alu instid0(VALU_DEP_4)                            // 000000001670: BF870004
	v_lshlrev_b64 v[1:2], 1, v[1:2]                            // 000000001674: D73C0001 00020281
	v_mov_b32_e32 v19, v41                                     // 00000000167C: 7E260329
	v_mov_b32_e32 v20, v41                                     // 000000001680: 7E280329
	v_mov_b32_e32 v21, v41                                     // 000000001684: 7E2A0329
	v_mov_b32_e32 v22, v41                                     // 000000001688: 7E2C0329
	v_mov_b32_e32 v23, v41                                     // 00000000168C: 7E2E0329
	s_waitcnt lgkmcnt(0)                                       // 000000001690: BF89FC07
	v_add_co_u32 v164, vcc_lo, s6, v1                          // 000000001694: D7006AA4 00020206
	v_add_co_ci_u32_e32 v165, vcc_lo, s7, v2, vcc_lo           // 00000000169C: 414A0407
	v_mov_b32_e32 v24, v41                                     // 0000000016A0: 7E300329
	v_mov_b32_e32 v9, v41                                      // 0000000016A4: 7E120329
	v_mov_b32_e32 v10, v41                                     // 0000000016A8: 7E140329
	v_mov_b32_e32 v11, v41                                     // 0000000016AC: 7E160329
	v_mov_b32_e32 v12, v41                                     // 0000000016B0: 7E180329
	v_mov_b32_e32 v13, v41                                     // 0000000016B4: 7E1A0329
	v_mov_b32_e32 v14, v41                                     // 0000000016B8: 7E1C0329
	v_mov_b32_e32 v15, v41                                     // 0000000016BC: 7E1E0329
	v_mov_b32_e32 v16, v41                                     // 0000000016C0: 7E200329
	v_mov_b32_e32 v1, v41                                      // 0000000016C4: 7E020329
	v_mov_b32_e32 v2, v41                                      // 0000000016C8: 7E040329
	v_mov_b32_e32 v3, v41                                      // 0000000016CC: 7E060329
	v_mov_b32_e32 v4, v41                                      // 0000000016D0: 7E080329
	v_mov_b32_e32 v5, v41                                      // 0000000016D4: 7E0A0329
	v_mov_b32_e32 v6, v41                                      // 0000000016D8: 7E0C0329
	v_mov_b32_e32 v7, v41                                      // 0000000016DC: 7E0E0329
	v_mov_b32_e32 v8, v41                                      // 0000000016E0: 7E100329
	v_mov_b32_e32 v81, v41                                     // 0000000016E4: 7EA20329
	v_mov_b32_e32 v82, v41                                     // 0000000016E8: 7EA40329
	v_mov_b32_e32 v83, v41                                     // 0000000016EC: 7EA60329
	v_mov_b32_e32 v84, v41                                     // 0000000016F0: 7EA80329
	v_mov_b32_e32 v85, v41                                     // 0000000016F4: 7EAA0329
	v_mov_b32_e32 v86, v41                                     // 0000000016F8: 7EAC0329
	v_mov_b32_e32 v87, v41                                     // 0000000016FC: 7EAE0329
	v_mov_b32_e32 v88, v41                                     // 000000001700: 7EB00329
	v_mov_b32_e32 v49, v41                                     // 000000001704: 7E620329
	v_mov_b32_e32 v50, v41                                     // 000000001708: 7E640329
	v_mov_b32_e32 v51, v41                                     // 00000000170C: 7E660329
	v_mov_b32_e32 v52, v41                                     // 000000001710: 7E680329
	v_mov_b32_e32 v53, v41                                     // 000000001714: 7E6A0329
	v_mov_b32_e32 v54, v41                                     // 000000001718: 7E6C0329
	v_mov_b32_e32 v55, v41                                     // 00000000171C: 7E6E0329
	v_mov_b32_e32 v56, v41                                     // 000000001720: 7E700329
	v_mov_b32_e32 v33, v41                                     // 000000001724: 7E420329
	v_mov_b32_e32 v34, v41                                     // 000000001728: 7E440329
	v_mov_b32_e32 v35, v41                                     // 00000000172C: 7E460329
	v_mov_b32_e32 v36, v41                                     // 000000001730: 7E480329
	v_mov_b32_e32 v37, v41                                     // 000000001734: 7E4A0329
	v_mov_b32_e32 v38, v41                                     // 000000001738: 7E4C0329
	v_mov_b32_e32 v39, v41                                     // 00000000173C: 7E4E0329
	v_mov_b32_e32 v40, v41                                     // 000000001740: 7E500329
	v_mov_b32_e32 v25, v41                                     // 000000001744: 7E320329
	v_mov_b32_e32 v26, v41                                     // 000000001748: 7E340329
	v_mov_b32_e32 v27, v41                                     // 00000000174C: 7E360329
	v_mov_b32_e32 v28, v41                                     // 000000001750: 7E380329
	v_mov_b32_e32 v29, v41                                     // 000000001754: 7E3A0329
	v_mov_b32_e32 v30, v41                                     // 000000001758: 7E3C0329
	v_mov_b32_e32 v31, v41                                     // 00000000175C: 7E3E0329
	v_mov_b32_e32 v32, v41                                     // 000000001760: 7E400329
	v_mov_b32_e32 v113, v41                                    // 000000001764: 7EE20329
	v_mov_b32_e32 v114, v41                                    // 000000001768: 7EE40329
	v_mov_b32_e32 v115, v41                                    // 00000000176C: 7EE60329
	v_mov_b32_e32 v116, v41                                    // 000000001770: 7EE80329
	v_mov_b32_e32 v117, v41                                    // 000000001774: 7EEA0329
	v_mov_b32_e32 v118, v41                                    // 000000001778: 7EEC0329
	v_mov_b32_e32 v119, v41                                    // 00000000177C: 7EEE0329
	v_mov_b32_e32 v120, v41                                    // 000000001780: 7EF00329
	v_mov_b32_e32 v73, v41                                     // 000000001784: 7E920329
	v_mov_b32_e32 v74, v41                                     // 000000001788: 7E940329
	v_mov_b32_e32 v75, v41                                     // 00000000178C: 7E960329
	v_mov_b32_e32 v76, v41                                     // 000000001790: 7E980329
	v_mov_b32_e32 v77, v41                                     // 000000001794: 7E9A0329
	v_mov_b32_e32 v78, v41                                     // 000000001798: 7E9C0329
	v_mov_b32_e32 v79, v41                                     // 00000000179C: 7E9E0329
	v_mov_b32_e32 v80, v41                                     // 0000000017A0: 7EA00329
	v_mov_b32_e32 v65, v41                                     // 0000000017A4: 7E820329
	v_mov_b32_e32 v66, v41                                     // 0000000017A8: 7E840329
	v_mov_b32_e32 v67, v41                                     // 0000000017AC: 7E860329
	v_mov_b32_e32 v68, v41                                     // 0000000017B0: 7E880329
	v_mov_b32_e32 v69, v41                                     // 0000000017B4: 7E8A0329
	v_mov_b32_e32 v70, v41                                     // 0000000017B8: 7E8C0329
	v_mov_b32_e32 v71, v41                                     // 0000000017BC: 7E8E0329
	v_mov_b32_e32 v72, v41                                     // 0000000017C0: 7E900329
	v_mov_b32_e32 v57, v41                                     // 0000000017C4: 7E720329
	v_mov_b32_e32 v58, v41                                     // 0000000017C8: 7E740329
	v_mov_b32_e32 v59, v41                                     // 0000000017CC: 7E760329
	v_mov_b32_e32 v60, v41                                     // 0000000017D0: 7E780329
	v_mov_b32_e32 v61, v41                                     // 0000000017D4: 7E7A0329
	v_mov_b32_e32 v62, v41                                     // 0000000017D8: 7E7C0329
	v_mov_b32_e32 v63, v41                                     // 0000000017DC: 7E7E0329
	v_mov_b32_e32 v64, v41                                     // 0000000017E0: 7E800329
	v_mov_b32_e32 v121, v41                                    // 0000000017E4: 7EF20329
	v_mov_b32_e32 v122, v41                                    // 0000000017E8: 7EF40329
	v_mov_b32_e32 v123, v41                                    // 0000000017EC: 7EF60329
	v_mov_b32_e32 v124, v41                                    // 0000000017F0: 7EF80329
	v_mov_b32_e32 v125, v41                                    // 0000000017F4: 7EFA0329
	v_mov_b32_e32 v126, v41                                    // 0000000017F8: 7EFC0329
	v_mov_b32_e32 v127, v41                                    // 0000000017FC: 7EFE0329
	v_mov_b32_e32 v128, v41                                    // 000000001800: 7F000329
	v_mov_b32_e32 v105, v41                                    // 000000001804: 7ED20329
	v_mov_b32_e32 v106, v41                                    // 000000001808: 7ED40329
	v_mov_b32_e32 v107, v41                                    // 00000000180C: 7ED60329
	v_mov_b32_e32 v108, v41                                    // 000000001810: 7ED80329
	v_mov_b32_e32 v109, v41                                    // 000000001814: 7EDA0329
	v_mov_b32_e32 v110, v41                                    // 000000001818: 7EDC0329
	v_mov_b32_e32 v111, v41                                    // 00000000181C: 7EDE0329
	v_mov_b32_e32 v112, v41                                    // 000000001820: 7EE00329
	v_mov_b32_e32 v97, v41                                     // 000000001824: 7EC20329
	v_mov_b32_e32 v98, v41                                     // 000000001828: 7EC40329
	v_mov_b32_e32 v99, v41                                     // 00000000182C: 7EC60329
	v_mov_b32_e32 v100, v41                                    // 000000001830: 7EC80329
	v_mov_b32_e32 v101, v41                                    // 000000001834: 7ECA0329
	v_mov_b32_e32 v102, v41                                    // 000000001838: 7ECC0329
	v_mov_b32_e32 v103, v41                                    // 00000000183C: 7ECE0329
	v_mov_b32_e32 v104, v41                                    // 000000001840: 7ED00329
	v_mov_b32_e32 v89, v41                                     // 000000001844: 7EB20329
	v_mov_b32_e32 v90, v41                                     // 000000001848: 7EB40329
	v_mov_b32_e32 v91, v41                                     // 00000000184C: 7EB60329
	v_mov_b32_e32 v92, v41                                     // 000000001850: 7EB80329
	v_mov_b32_e32 v93, v41                                     // 000000001854: 7EBA0329
	v_mov_b32_e32 v94, v41                                     // 000000001858: 7EBC0329
	v_mov_b32_e32 v95, v41                                     // 00000000185C: 7EBE0329
	v_mov_b32_e32 v96, v41                                     // 000000001860: 7EC00329
	s_mov_b64 s[2:3], 0                                        // 000000001864: BE820180
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)// 000000001868: BF8701B9
	v_add_co_u32 v134, vcc_lo, v164, s2                        // 00000000186C: D7006A86 000005A4
	v_add_co_ci_u32_e32 v135, vcc_lo, s3, v165, vcc_lo         // 000000001874: 410F4A03
	v_ashrrev_i32_e32 v162, 31, v161                           // 000000001878: 3545429F
	v_add_co_u32 v142, vcc_lo, 0x10000, v134                   // 00000000187C: D7006A8E 00030CFF 00010000
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)// 000000001888: BF870193
	v_add_co_ci_u32_e32 v143, vcc_lo, 0, v135, vcc_lo          // 00000000188C: 411F0E80
	v_lshlrev_b64 v[166:167], 1, v[161:162]                    // 000000001890: D73C00A6 00034281
	v_add_co_u32 v150, vcc_lo, 0x20000, v134                   // 000000001898: D7006A96 00030CFF 00020000
	v_add_co_ci_u32_e32 v151, vcc_lo, 0, v135, vcc_lo          // 0000000018A4: 412F0E80
	v_add_co_u32 v158, vcc_lo, 0x30000, v134                   // 0000000018A8: D7006A9E 00030CFF 00030000
	v_add_co_ci_u32_e32 v159, vcc_lo, 0, v135, vcc_lo          // 0000000018B4: 413F0E80
	v_add_co_u32 v169, vcc_lo, s0, v166                        // 0000000018B8: D7006AA9 00034C00
	v_add_co_ci_u32_e32 v170, vcc_lo, s1, v167, vcc_lo         // 0000000018C0: 41554E01
	s_waitcnt lgkmcnt(0)                                       // 0000000018C4: BF89FC07
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)// 0000000018C8: BF870112
	v_add_co_u32 v198, vcc_lo, 0x1000, v169                    // 0000000018CC: D7006AC6 000352FF 00001000
	v_add_co_ci_u32_e32 v199, vcc_lo, 0, v170, vcc_lo          // 0000000018D8: 418F5480
	v_add_co_u32 v171, vcc_lo, 0x2000, v169                    // 0000000018DC: D7006AAB 000352FF 00002000
	v_add_co_ci_u32_e32 v172, vcc_lo, 0, v170, vcc_lo          // 0000000018E8: 41595480
	v_add_co_u32 v200, vcc_lo, 0x3000, v169                    // 0000000018EC: D7006AC8 000352FF 00003000
	v_add_co_ci_u32_e32 v201, vcc_lo, 0, v170, vcc_lo          // 0000000018F8: 41935480
	v_add_co_u32 v173, vcc_lo, 0x4000, v169                    // 0000000018FC: D7006AAD 000352FF 00004000
	v_add_co_ci_u32_e32 v174, vcc_lo, 0, v170, vcc_lo          // 000000001908: 415D5480
	v_add_co_u32 v202, vcc_lo, 0x5000, v169                    // 00000000190C: D7006ACA 000352FF 00005000
	v_add_co_ci_u32_e32 v203, vcc_lo, 0, v170, vcc_lo          // 000000001918: 41975480
	v_add_co_u32 v179, vcc_lo, 0x6000, v169                    // 00000000191C: D7006AB3 000352FF 00006000
	v_add_co_ci_u32_e32 v180, vcc_lo, 0, v170, vcc_lo          // 000000001928: 41695480
	s_barrier                                                  // 00000000192C: BFBD0000
	s_waitcnt lgkmcnt(0)                                       // 000000001930: BF89FC07
	s_clause 0xb                                               // 000000001934: BF85000B
	global_load_b32 v129, v[134:135], off                      // 000000001938: DC520000 817C0086
	global_load_b128 v[130:133], v[134:135], off offset:4      // 000000001940: DC5E0004 827C0086
	global_load_b96 v[134:136], v[134:135], off offset:20      // 000000001948: DC5A0014 867C0086
	global_load_b32 v137, v[142:143], off                      // 000000001950: DC520000 897C008E
	global_load_b128 v[138:141], v[142:143], off offset:4      // 000000001958: DC5E0004 8A7C008E
	global_load_b96 v[142:144], v[142:143], off offset:20      // 000000001960: DC5A0014 8E7C008E
	global_load_b32 v145, v[150:151], off                      // 000000001968: DC520000 917C0096
	global_load_b128 v[146:149], v[150:151], off offset:4      // 000000001970: DC5E0004 927C0096
	global_load_b96 v[150:152], v[150:151], off offset:20      // 000000001978: DC5A0014 967C0096
	global_load_b32 v153, v[158:159], off                      // 000000001980: DC520000 997C009E
	global_load_b128 v[154:157], v[158:159], off offset:4      // 000000001988: DC5E0004 9A7C009E
	global_load_b96 v[158:160], v[158:159], off offset:20      // 000000001990: DC5A0014 9E7C009E
	s_clause 0x7                                               // 000000001998: BF850007
	global_load_u16 v168, v[173:174], off offset:96            // 00000000199C: DC4A0060 A87C00AD
	global_load_u16 v167, v[171:172], off offset:96            // 0000000019A4: DC4A0060 A77C00AB
	global_load_u16 v176, v[173:174], off offset:64            // 0000000019AC: DC4A0040 B07C00AD
	global_load_u16 v177, v[179:180], off offset:64            // 0000000019B4: DC4A0040 B17C00B3
	global_load_u16 v184, v[173:174], off                      // 0000000019BC: DC4A0000 B87C00AD
	global_load_u16 v183, v[171:172], off                      // 0000000019C4: DC4A0000 B77C00AB
	global_load_u16 v175, v[171:172], off offset:64            // 0000000019CC: DC4A0040 AF7C00AB
	global_load_u16 v191, v[171:172], off offset:32            // 0000000019D4: DC4A0020 BF7C00AB
	v_add_co_u32 v204, vcc_lo, 0x7000, v169                    // 0000000019DC: D7006ACC 000352FF 00007000
	v_add_co_ci_u32_e32 v205, vcc_lo, 0, v170, vcc_lo          // 0000000019E8: 419B5480
	v_add_co_u32 v187, vcc_lo, 0x8000, v169                    // 0000000019EC: D7006ABB 000352FF 00008000
	v_add_co_ci_u32_e32 v188, vcc_lo, 0, v170, vcc_lo          // 0000000019F8: 41795480
	v_add_co_u32 v206, vcc_lo, 0x9000, v169                    // 0000000019FC: D7006ACE 000352FF 00009000
	v_add_co_ci_u32_e32 v207, vcc_lo, 0, v170, vcc_lo          // 000000001A08: 419F5480
	v_add_co_u32 v171, vcc_lo, 0xa000, v169                    // 000000001A0C: D7006AAB 000352FF 0000A000
	v_add_co_ci_u32_e32 v172, vcc_lo, 0, v170, vcc_lo          // 000000001A18: 41595480
	v_add_co_u32 v208, vcc_lo, 0xb000, v169                    // 000000001A1C: D7006AD0 000352FF 0000B000
	v_add_co_ci_u32_e32 v209, vcc_lo, 0, v170, vcc_lo          // 000000001A28: 41A35480
	v_add_co_u32 v210, vcc_lo, 0xc000, v169                    // 000000001A2C: D7006AD2 000352FF 0000C000
	v_add_co_ci_u32_e32 v211, vcc_lo, 0, v170, vcc_lo          // 000000001A38: 41A75480
	v_add_co_u32 v212, vcc_lo, 0xd000, v169                    // 000000001A3C: D7006AD4 000352FF 0000D000
	v_add_co_ci_u32_e32 v213, vcc_lo, 0, v170, vcc_lo          // 000000001A48: 41AB5480
	v_add_co_u32 v214, vcc_lo, 0xe000, v169                    // 000000001A4C: D7006AD6 000352FF 0000E000
	v_add_co_ci_u32_e32 v215, vcc_lo, 0, v170, vcc_lo          // 000000001A58: 41AF5480
	v_add_co_u32 v216, vcc_lo, 0xf000, v169                    // 000000001A5C: D7006AD8 000352FF 0000F000
	v_add_co_ci_u32_e32 v217, vcc_lo, 0, v170, vcc_lo          // 000000001A68: 41B35480
	v_add_nc_u32_e32 v161, 0x8000, v161                        // 000000001A6C: 4B4342FF 00008000
	s_add_u32 s2, s2, 32                                       // 000000001A74: 8002A002
	s_addc_u32 s3, s3, 0                                       // 000000001A78: 82038003
	s_cmpk_eq_i32 s2, 0x1000                                   // 000000001A7C: B1821000
	s_clause 0x37                                              // 000000001A80: BF850037
	global_load_d16_hi_b16 v167, v[200:201], off offset:96     // 000000001A84: DC8E0060 A77C00C8
	global_load_d16_hi_b16 v176, v[202:203], off offset:64     // 000000001A8C: DC8E0040 B07C00CA
	global_load_u16 v192, v[173:174], off offset:32            // 000000001A94: DC4A0020 C07C00AD
	global_load_u16 v182, v[169:170], off                      // 000000001A9C: DC4A0000 B67C00A9
	global_load_u16 v190, v[169:170], off offset:32            // 000000001AA4: DC4A0020 BE7C00A9
	global_load_u16 v166, v[169:170], off offset:96            // 000000001AAC: DC4A0060 A67C00A9
	global_load_u16 v174, v[169:170], off offset:64            // 000000001AB4: DC4A0040 AE7C00A9
	global_load_u16 v178, v[187:188], off offset:64            // 000000001ABC: DC4A0040 B27C00BB
	global_load_u16 v185, v[179:180], off                      // 000000001AC4: DC4A0000 B97C00B3
	global_load_u16 v193, v[179:180], off offset:32            // 000000001ACC: DC4A0020 C17C00B3
	global_load_d16_hi_b16 v177, v[204:205], off offset:64     // 000000001AD4: DC8E0040 B17C00CC
	global_load_u16 v169, v[179:180], off offset:96            // 000000001ADC: DC4A0060 A97C00B3
	global_load_u16 v179, v[171:172], off offset:64            // 000000001AE4: DC4A0040 B37C00AB
	global_load_u16 v186, v[187:188], off                      // 000000001AEC: DC4A0000 BA7C00BB
	global_load_u16 v194, v[187:188], off offset:32            // 000000001AF4: DC4A0020 C27C00BB
	global_load_d16_hi_b16 v178, v[206:207], off offset:64     // 000000001AFC: DC8E0040 B27C00CE
	global_load_u16 v170, v[187:188], off offset:96            // 000000001B04: DC4A0060 AA7C00BB
	global_load_u16 v180, v[210:211], off offset:64            // 000000001B0C: DC4A0040 B47C00D2
	global_load_u16 v187, v[171:172], off                      // 000000001B14: DC4A0000 BB7C00AB
	global_load_u16 v195, v[171:172], off offset:32            // 000000001B1C: DC4A0020 C37C00AB
	global_load_d16_hi_b16 v179, v[208:209], off offset:64     // 000000001B24: DC8E0040 B37C00D0
	global_load_u16 v171, v[171:172], off offset:96            // 000000001B2C: DC4A0060 AB7C00AB
	global_load_u16 v181, v[214:215], off offset:64            // 000000001B34: DC4A0040 B57C00D6
	global_load_u16 v188, v[210:211], off                      // 000000001B3C: DC4A0000 BC7C00D2
	global_load_u16 v196, v[210:211], off offset:32            // 000000001B44: DC4A0020 C47C00D2
	global_load_d16_hi_b16 v180, v[212:213], off offset:64     // 000000001B4C: DC8E0040 B47C00D4
	global_load_u16 v172, v[210:211], off offset:96            // 000000001B54: DC4A0060 AC7C00D2
	global_load_u16 v189, v[214:215], off                      // 000000001B5C: DC4A0000 BD7C00D6
	global_load_u16 v197, v[214:215], off offset:32            // 000000001B64: DC4A0020 C57C00D6
	global_load_d16_hi_b16 v181, v[216:217], off offset:64     // 000000001B6C: DC8E0040 B57C00D8
	global_load_u16 v173, v[214:215], off offset:96            // 000000001B74: DC4A0060 AD7C00D6
	global_load_d16_hi_b16 v184, v[202:203], off               // 000000001B7C: DC8E0000 B87C00CA
	global_load_d16_hi_b16 v185, v[204:205], off               // 000000001B84: DC8E0000 B97C00CC
	global_load_d16_hi_b16 v186, v[206:207], off               // 000000001B8C: DC8E0000 BA7C00CE
	global_load_d16_hi_b16 v187, v[208:209], off               // 000000001B94: DC8E0000 BB7C00D0
	global_load_d16_hi_b16 v188, v[212:213], off               // 000000001B9C: DC8E0000 BC7C00D4
	global_load_d16_hi_b16 v189, v[216:217], off               // 000000001BA4: DC8E0000 BD7C00D8
	global_load_d16_hi_b16 v183, v[200:201], off               // 000000001BAC: DC8E0000 B77C00C8
	global_load_d16_hi_b16 v182, v[198:199], off               // 000000001BB4: DC8E0000 B67C00C6
	global_load_d16_hi_b16 v190, v[198:199], off offset:32     // 000000001BBC: DC8E0020 BE7C00C6
	global_load_d16_hi_b16 v166, v[198:199], off offset:96     // 000000001BC4: DC8E0060 A67C00C6
	global_load_d16_hi_b16 v191, v[200:201], off offset:32     // 000000001BCC: DC8E0020 BF7C00C8
	global_load_d16_hi_b16 v175, v[200:201], off offset:64     // 000000001BD4: DC8E0040 AF7C00C8
	global_load_d16_hi_b16 v192, v[202:203], off offset:32     // 000000001BDC: DC8E0020 C07C00CA
	global_load_d16_hi_b16 v168, v[202:203], off offset:96     // 000000001BE4: DC8E0060 A87C00CA
	global_load_d16_hi_b16 v193, v[204:205], off offset:32     // 000000001BEC: DC8E0020 C17C00CC
	global_load_d16_hi_b16 v169, v[204:205], off offset:96     // 000000001BF4: DC8E0060 A97C00CC
	global_load_d16_hi_b16 v194, v[206:207], off offset:32     // 000000001BFC: DC8E0020 C27C00CE
	global_load_d16_hi_b16 v170, v[206:207], off offset:96     // 000000001C04: DC8E0060 AA7C00CE
	global_load_d16_hi_b16 v195, v[208:209], off offset:32     // 000000001C0C: DC8E0020 C37C00D0
	global_load_d16_hi_b16 v171, v[208:209], off offset:96     // 000000001C14: DC8E0060 AB7C00D0
	global_load_d16_hi_b16 v196, v[212:213], off offset:32     // 000000001C1C: DC8E0020 C47C00D4
	global_load_d16_hi_b16 v172, v[212:213], off offset:96     // 000000001C24: DC8E0060 AC7C00D4
	global_load_d16_hi_b16 v197, v[216:217], off offset:32     // 000000001C2C: DC8E0020 C57C00D8
	global_load_d16_hi_b16 v174, v[198:199], off offset:64     // 000000001C34: DC8E0040 AE7C00C6
	global_load_d16_hi_b16 v173, v[216:217], off offset:96     // 000000001C3C: DC8E0060 AD7C00D8
	s_waitcnt vmcnt(17)                                        // 000000001C44: BF8947F7
	v_wmma_f32_16x16x16_f16 v[41:48], v[129:136], v[182:189], v[41:48]// 000000001C48: CC404029 1CA76D81
	v_wmma_f32_16x16x16_f16 v[17:24], v[137:144], v[182:189], v[17:24]// 000000001C50: CC404011 1C476D89
	v_wmma_f32_16x16x16_f16 v[9:16], v[145:152], v[182:189], v[9:16]// 000000001C58: CC404009 1C276D91
	v_wmma_f32_16x16x16_f16 v[1:8], v[153:160], v[182:189], v[1:8]// 000000001C60: CC404001 1C076D99
	s_waitcnt vmcnt(2)                                         // 000000001C68: BF890BF7
	v_wmma_f32_16x16x16_f16 v[81:88], v[129:136], v[190:197], v[81:88]// 000000001C6C: CC404051 1D477D81
	v_wmma_f32_16x16x16_f16 v[49:56], v[137:144], v[190:197], v[49:56]// 000000001C74: CC404031 1CC77D89
	v_wmma_f32_16x16x16_f16 v[33:40], v[145:152], v[190:197], v[33:40]// 000000001C7C: CC404021 1C877D91
	v_wmma_f32_16x16x16_f16 v[25:32], v[153:160], v[190:197], v[25:32]// 000000001C84: CC404019 1C677D99
	s_waitcnt vmcnt(1)                                         // 000000001C8C: BF8907F7
	v_wmma_f32_16x16x16_f16 v[113:120], v[129:136], v[174:181], v[113:120]// 000000001C90: CC404071 1DC75D81
	v_wmma_f32_16x16x16_f16 v[73:80], v[137:144], v[174:181], v[73:80]// 000000001C98: CC404049 1D275D89
	v_wmma_f32_16x16x16_f16 v[65:72], v[145:152], v[174:181], v[65:72]// 000000001CA0: CC404041 1D075D91
	v_wmma_f32_16x16x16_f16 v[57:64], v[153:160], v[174:181], v[57:64]// 000000001CA8: CC404039 1CE75D99
	s_waitcnt vmcnt(0)                                         // 000000001CB0: BF8903F7
	v_wmma_f32_16x16x16_f16 v[121:128], v[129:136], v[166:173], v[121:128]// 000000001CB4: CC404079 1DE74D81
	v_wmma_f32_16x16x16_f16 v[105:112], v[137:144], v[166:173], v[105:112]// 000000001CBC: CC404069 1DA74D89
	v_wmma_f32_16x16x16_f16 v[97:104], v[145:152], v[166:173], v[97:104]// 000000001CC4: CC404061 1D874D91
	v_wmma_f32_16x16x16_f16 v[89:96], v[153:160], v[166:173], v[89:96]// 000000001CCC: CC404059 1D674D99
	s_cbranch_scc0 65252                                       // 000000001CD4: BFA1FEE4 <test+0x268>
	v_bfe_u32 v0, v0, 10, 10                                   // 000000001CD8: D6100000 02291500
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000001CE0: BF870091
	v_lshlrev_b32_e32 v0, 11, v0                               // 000000001CE4: 3000008B
	v_add3_u32 v129, v163, s8, v0                              // 000000001CE8: D6550081 040011A3
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000001CF0: BF870091
	v_ashrrev_i32_e32 v130, 31, v129                           // 000000001CF4: 3505029F
	v_lshlrev_b64 v[129:130], 2, v[129:130]                    // 000000001CF8: D73C0081 00030282
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000001D00: BF870111
	v_add_co_u32 v129, vcc_lo, s4, v129                        // 000000001D04: D7006A81 00030204
	v_add_co_ci_u32_e32 v130, vcc_lo, s5, v130, vcc_lo         // 000000001D0C: 41050405
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000001D10: BF870112
	v_add_co_u32 v131, vcc_lo, 0x4000, v129                    // 000000001D14: D7006A83 000302FF 00004000
	v_add_co_ci_u32_e32 v132, vcc_lo, 0, v130, vcc_lo          // 000000001D20: 41090480
	v_add_co_u32 v133, vcc_lo, 0x8000, v129                    // 000000001D24: D7006A85 000302FF 00008000
	v_add_co_ci_u32_e32 v134, vcc_lo, 0, v130, vcc_lo          // 000000001D30: 410D0480
	v_add_co_u32 v135, vcc_lo, 0xc000, v129                    // 000000001D34: D7006A87 000302FF 0000C000
	v_add_co_ci_u32_e32 v136, vcc_lo, 0, v130, vcc_lo          // 000000001D40: 41110480
	v_add_co_u32 v137, vcc_lo, 0x10000, v129                   // 000000001D44: D7006A89 000302FF 00010000
	v_add_co_ci_u32_e32 v138, vcc_lo, 0, v130, vcc_lo          // 000000001D50: 41150480
	v_add_co_u32 v139, vcc_lo, 0x14000, v129                   // 000000001D54: D7006A8B 000302FF 00014000
	v_add_co_ci_u32_e32 v140, vcc_lo, 0, v130, vcc_lo          // 000000001D60: 41190480
	v_add_co_u32 v141, vcc_lo, 0x18000, v129                   // 000000001D64: D7006A8D 000302FF 00018000
	v_add_co_ci_u32_e32 v142, vcc_lo, 0, v130, vcc_lo          // 000000001D70: 411D0480
	v_add_co_u32 v143, vcc_lo, 0x1c000, v129                   // 000000001D74: D7006A8F 000302FF 0001C000
	v_add_co_ci_u32_e32 v144, vcc_lo, 0, v130, vcc_lo          // 000000001D80: 41210480
	v_add_co_u32 v145, vcc_lo, 0x20000, v129                   // 000000001D84: D7006A91 000302FF 00020000
	v_add_co_ci_u32_e32 v146, vcc_lo, 0, v130, vcc_lo          // 000000001D90: 41250480
	v_add_co_u32 v147, vcc_lo, 0x24000, v129                   // 000000001D94: D7006A93 000302FF 00024000
	v_add_co_ci_u32_e32 v148, vcc_lo, 0, v130, vcc_lo          // 000000001DA0: 41290480
	v_add_co_u32 v149, vcc_lo, 0x28000, v129                   // 000000001DA4: D7006A95 000302FF 00028000
	v_add_co_ci_u32_e32 v150, vcc_lo, 0, v130, vcc_lo          // 000000001DB0: 412D0480
	v_add_co_u32 v151, vcc_lo, 0x2c000, v129                   // 000000001DB4: D7006A97 000302FF 0002C000
	v_add_co_ci_u32_e32 v152, vcc_lo, 0, v130, vcc_lo          // 000000001DC0: 41310480
	v_add_co_u32 v153, vcc_lo, 0x30000, v129                   // 000000001DC4: D7006A99 000302FF 00030000
	v_add_co_ci_u32_e32 v154, vcc_lo, 0, v130, vcc_lo          // 000000001DD0: 41350480
	v_add_co_u32 v155, vcc_lo, 0x34000, v129                   // 000000001DD4: D7006A9B 000302FF 00034000
	v_add_co_ci_u32_e32 v156, vcc_lo, 0, v130, vcc_lo          // 000000001DE0: 41390480
	v_add_co_u32 v157, vcc_lo, 0x38000, v129                   // 000000001DE4: D7006A9D 000302FF 00038000
	v_add_co_ci_u32_e32 v158, vcc_lo, 0, v130, vcc_lo          // 000000001DF0: 413D0480
	v_add_co_u32 v159, vcc_lo, 0x3c000, v129                   // 000000001DF4: D7006A9F 000302FF 0003C000
	v_add_co_ci_u32_e32 v160, vcc_lo, 0, v130, vcc_lo          // 000000001E00: 41410480
	v_add_co_u32 v161, vcc_lo, 0x40000, v129                   // 000000001E04: D7006AA1 000302FF 00040000
	v_add_co_ci_u32_e32 v162, vcc_lo, 0, v130, vcc_lo          // 000000001E10: 41450480
	v_add_co_u32 v163, vcc_lo, 0x44000, v129                   // 000000001E14: D7006AA3 000302FF 00044000
	v_add_co_ci_u32_e32 v164, vcc_lo, 0, v130, vcc_lo          // 000000001E20: 41490480
	s_clause 0xb                                               // 000000001E24: BF85000B
	global_store_b32 v[133:134], v43, off                      // 000000001E28: DC6A0000 007C2B85
	global_store_b32 v[137:138], v45, off                      // 000000001E30: DC6A0000 007C2D89
	global_store_b32 v[141:142], v47, off                      // 000000001E38: DC6A0000 007C2F8D
	global_store_b32 v[129:130], v41, off                      // 000000001E40: DC6A0000 007C2981
	global_store_b32 v[129:130], v113, off offset:128          // 000000001E48: DC6A0080 007C7181
	global_store_b32 v[129:130], v81, off offset:64            // 000000001E50: DC6A0040 007C5181
	global_store_b32 v[133:134], v115, off offset:128          // 000000001E58: DC6A0080 007C7385
	global_store_b32 v[133:134], v83, off offset:64            // 000000001E60: DC6A0040 007C5385
	global_store_b32 v[137:138], v117, off offset:128          // 000000001E68: DC6A0080 007C7589
	global_store_b32 v[137:138], v85, off offset:64            // 000000001E70: DC6A0040 007C5589
	global_store_b32 v[141:142], v119, off offset:128          // 000000001E78: DC6A0080 007C778D
	global_store_b32 v[141:142], v87, off offset:64            // 000000001E80: DC6A0040 007C578D
	v_add_co_u32 v81, vcc_lo, 0x48000, v129                    // 000000001E88: D7006A51 000302FF 00048000
	s_clause 0x2                                               // 000000001E94: BF850002
	global_store_b32 v[131:132], v82, off offset:64            // 000000001E98: DC6A0040 007C5283
	global_store_b32 v[131:132], v114, off offset:128          // 000000001EA0: DC6A0080 007C7283
	global_store_b32 v[131:132], v122, off offset:192          // 000000001EA8: DC6A00C0 007C7A83
	v_add_co_ci_u32_e32 v82, vcc_lo, 0, v130, vcc_lo           // 000000001EB0: 40A50480
	v_add_co_u32 v113, vcc_lo, 0x4c000, v129                   // 000000001EB4: D7006A71 000302FF 0004C000
	v_add_co_ci_u32_e32 v114, vcc_lo, 0, v130, vcc_lo          // 000000001EC0: 40E50480
	v_add_co_u32 v43, vcc_lo, 0x50000, v129                    // 000000001EC4: D7006A2B 000302FF 00050000
	s_clause 0x4                                               // 000000001ED0: BF850004
	global_store_b32 v[133:134], v123, off offset:192          // 000000001ED4: DC6A00C0 007C7B85
	global_store_b32 v[135:136], v44, off                      // 000000001EDC: DC6A0000 007C2C87
	global_store_b32 v[135:136], v84, off offset:64            // 000000001EE4: DC6A0040 007C5487
	global_store_b32 v[135:136], v116, off offset:128          // 000000001EEC: DC6A0080 007C7487
	global_store_b32 v[135:136], v124, off offset:192          // 000000001EF4: DC6A00C0 007C7C87
	v_add_co_ci_u32_e32 v44, vcc_lo, 0, v130, vcc_lo           // 000000001EFC: 40590480
	v_add_co_u32 v83, vcc_lo, 0x54000, v129                    // 000000001F00: D7006A53 000302FF 00054000
	v_add_co_ci_u32_e32 v84, vcc_lo, 0, v130, vcc_lo           // 000000001F0C: 40A90480
	v_add_co_u32 v45, vcc_lo, 0x58000, v129                    // 000000001F10: D7006A2D 000302FF 00058000
	s_clause 0x4                                               // 000000001F1C: BF850004
	global_store_b32 v[137:138], v125, off offset:192          // 000000001F20: DC6A00C0 007C7D89
	global_store_b32 v[139:140], v46, off                      // 000000001F28: DC6A0000 007C2E8B
	global_store_b32 v[139:140], v86, off offset:64            // 000000001F30: DC6A0040 007C568B
	global_store_b32 v[139:140], v118, off offset:128          // 000000001F38: DC6A0080 007C768B
	global_store_b32 v[139:140], v126, off offset:192          // 000000001F40: DC6A00C0 007C7E8B
	v_add_co_ci_u32_e32 v46, vcc_lo, 0, v130, vcc_lo           // 000000001F48: 405D0480
	v_add_co_u32 v85, vcc_lo, 0x5c000, v129                    // 000000001F4C: D7006A55 000302FF 0005C000
	v_add_co_ci_u32_e32 v86, vcc_lo, 0, v130, vcc_lo           // 000000001F58: 40AD0480
	v_add_co_u32 v47, vcc_lo, 0x60000, v129                    // 000000001F5C: D7006A2F 000302FF 00060000
	s_clause 0x4                                               // 000000001F68: BF850004
	global_store_b32 v[141:142], v127, off offset:192          // 000000001F6C: DC6A00C0 007C7F8D
	global_store_b32 v[143:144], v48, off                      // 000000001F74: DC6A0000 007C308F
	global_store_b32 v[143:144], v88, off offset:64            // 000000001F7C: DC6A0040 007C588F
	global_store_b32 v[143:144], v120, off offset:128          // 000000001F84: DC6A0080 007C788F
	global_store_b32 v[143:144], v128, off offset:192          // 000000001F8C: DC6A00C0 007C808F
	v_add_co_ci_u32_e32 v48, vcc_lo, 0, v130, vcc_lo           // 000000001F94: 40610480
	v_add_co_u32 v41, vcc_lo, 0x64000, v129                    // 000000001F98: D7006A29 000302FF 00064000
	s_clause 0x1                                               // 000000001FA4: BF850001
	global_store_b32 v[131:132], v42, off                      // 000000001FA8: DC6A0000 007C2A83
	global_store_b32 v[129:130], v121, off offset:192          // 000000001FB0: DC6A00C0 007C7981
	v_add_co_ci_u32_e32 v42, vcc_lo, 0, v130, vcc_lo           // 000000001FB8: 40550480
	v_add_co_u32 v87, vcc_lo, 0x68000, v129                    // 000000001FBC: D7006A57 000302FF 00068000
	v_add_co_ci_u32_e32 v88, vcc_lo, 0, v130, vcc_lo           // 000000001FC8: 40B10480
	v_add_co_u32 v115, vcc_lo, 0x6c000, v129                   // 000000001FCC: D7006A73 000302FF 0006C000
	v_add_co_ci_u32_e32 v116, vcc_lo, 0, v130, vcc_lo          // 000000001FD8: 40E90480
	v_add_co_u32 v117, vcc_lo, 0x70000, v129                   // 000000001FDC: D7006A75 000302FF 00070000
	v_add_co_ci_u32_e32 v118, vcc_lo, 0, v130, vcc_lo          // 000000001FE8: 40ED0480
	v_add_co_u32 v119, vcc_lo, 0x74000, v129                   // 000000001FEC: D7006A77 000302FF 00074000
	v_add_co_ci_u32_e32 v120, vcc_lo, 0, v130, vcc_lo          // 000000001FF8: 40F10480
	v_add_co_u32 v121, vcc_lo, 0x78000, v129                   // 000000001FFC: D7006A79 000302FF 00078000
	v_add_co_ci_u32_e32 v122, vcc_lo, 0, v130, vcc_lo          // 000000002008: 40F50480
	v_add_co_u32 v123, vcc_lo, 0x7c000, v129                   // 00000000200C: D7006A7B 000302FF 0007C000
	v_add_co_ci_u32_e32 v124, vcc_lo, 0, v130, vcc_lo          // 000000002018: 40F90480
	s_clause 0x3e                                              // 00000000201C: BF85003E
	global_store_b32 v[145:146], v17, off                      // 000000002020: DC6A0000 007C1191
	global_store_b32 v[145:146], v49, off offset:64            // 000000002028: DC6A0040 007C3191
	global_store_b32 v[145:146], v73, off offset:128           // 000000002030: DC6A0080 007C4991
	global_store_b32 v[145:146], v105, off offset:192          // 000000002038: DC6A00C0 007C6991
	global_store_b32 v[147:148], v18, off                      // 000000002040: DC6A0000 007C1293
	global_store_b32 v[147:148], v50, off offset:64            // 000000002048: DC6A0040 007C3293
	global_store_b32 v[147:148], v74, off offset:128           // 000000002050: DC6A0080 007C4A93
	global_store_b32 v[147:148], v106, off offset:192          // 000000002058: DC6A00C0 007C6A93
	global_store_b32 v[149:150], v19, off                      // 000000002060: DC6A0000 007C1395
	global_store_b32 v[149:150], v51, off offset:64            // 000000002068: DC6A0040 007C3395
	global_store_b32 v[149:150], v75, off offset:128           // 000000002070: DC6A0080 007C4B95
	global_store_b32 v[149:150], v107, off offset:192          // 000000002078: DC6A00C0 007C6B95
	global_store_b32 v[151:152], v20, off                      // 000000002080: DC6A0000 007C1497
	global_store_b32 v[151:152], v52, off offset:64            // 000000002088: DC6A0040 007C3497
	global_store_b32 v[151:152], v76, off offset:128           // 000000002090: DC6A0080 007C4C97
	global_store_b32 v[151:152], v108, off offset:192          // 000000002098: DC6A00C0 007C6C97
	global_store_b32 v[153:154], v21, off                      // 0000000020A0: DC6A0000 007C1599
	global_store_b32 v[153:154], v53, off offset:64            // 0000000020A8: DC6A0040 007C3599
	global_store_b32 v[153:154], v77, off offset:128           // 0000000020B0: DC6A0080 007C4D99
	global_store_b32 v[153:154], v109, off offset:192          // 0000000020B8: DC6A00C0 007C6D99
	global_store_b32 v[155:156], v22, off                      // 0000000020C0: DC6A0000 007C169B
	global_store_b32 v[155:156], v54, off offset:64            // 0000000020C8: DC6A0040 007C369B
	global_store_b32 v[155:156], v78, off offset:128           // 0000000020D0: DC6A0080 007C4E9B
	global_store_b32 v[155:156], v110, off offset:192          // 0000000020D8: DC6A00C0 007C6E9B
	global_store_b32 v[157:158], v23, off                      // 0000000020E0: DC6A0000 007C179D
	global_store_b32 v[157:158], v55, off offset:64            // 0000000020E8: DC6A0040 007C379D
	global_store_b32 v[157:158], v79, off offset:128           // 0000000020F0: DC6A0080 007C4F9D
	global_store_b32 v[157:158], v111, off offset:192          // 0000000020F8: DC6A00C0 007C6F9D
	global_store_b32 v[159:160], v24, off                      // 000000002100: DC6A0000 007C189F
	global_store_b32 v[159:160], v56, off offset:64            // 000000002108: DC6A0040 007C389F
	global_store_b32 v[159:160], v80, off offset:128           // 000000002110: DC6A0080 007C509F
	global_store_b32 v[159:160], v112, off offset:192          // 000000002118: DC6A00C0 007C709F
	global_store_b32 v[161:162], v9, off                       // 000000002120: DC6A0000 007C09A1
	global_store_b32 v[161:162], v33, off offset:64            // 000000002128: DC6A0040 007C21A1
	global_store_b32 v[161:162], v65, off offset:128           // 000000002130: DC6A0080 007C41A1
	global_store_b32 v[161:162], v97, off offset:192           // 000000002138: DC6A00C0 007C61A1
	global_store_b32 v[163:164], v10, off                      // 000000002140: DC6A0000 007C0AA3
	global_store_b32 v[163:164], v34, off offset:64            // 000000002148: DC6A0040 007C22A3
	global_store_b32 v[163:164], v66, off offset:128           // 000000002150: DC6A0080 007C42A3
	global_store_b32 v[163:164], v98, off offset:192           // 000000002158: DC6A00C0 007C62A3
	global_store_b32 v[81:82], v11, off                        // 000000002160: DC6A0000 007C0B51
	global_store_b32 v[81:82], v35, off offset:64              // 000000002168: DC6A0040 007C2351
	global_store_b32 v[81:82], v67, off offset:128             // 000000002170: DC6A0080 007C4351
	global_store_b32 v[81:82], v99, off offset:192             // 000000002178: DC6A00C0 007C6351
	global_store_b32 v[113:114], v12, off                      // 000000002180: DC6A0000 007C0C71
	global_store_b32 v[113:114], v36, off offset:64            // 000000002188: DC6A0040 007C2471
	global_store_b32 v[113:114], v68, off offset:128           // 000000002190: DC6A0080 007C4471
	global_store_b32 v[113:114], v100, off offset:192          // 000000002198: DC6A00C0 007C6471
	global_store_b32 v[43:44], v13, off                        // 0000000021A0: DC6A0000 007C0D2B
	global_store_b32 v[43:44], v37, off offset:64              // 0000000021A8: DC6A0040 007C252B
	global_store_b32 v[43:44], v69, off offset:128             // 0000000021B0: DC6A0080 007C452B
	global_store_b32 v[43:44], v101, off offset:192            // 0000000021B8: DC6A00C0 007C652B
	global_store_b32 v[83:84], v14, off                        // 0000000021C0: DC6A0000 007C0E53
	global_store_b32 v[83:84], v38, off offset:64              // 0000000021C8: DC6A0040 007C2653
	global_store_b32 v[83:84], v70, off offset:128             // 0000000021D0: DC6A0080 007C4653
	global_store_b32 v[83:84], v102, off offset:192            // 0000000021D8: DC6A00C0 007C6653
	global_store_b32 v[45:46], v15, off                        // 0000000021E0: DC6A0000 007C0F2D
	global_store_b32 v[45:46], v39, off offset:64              // 0000000021E8: DC6A0040 007C272D
	global_store_b32 v[45:46], v71, off offset:128             // 0000000021F0: DC6A0080 007C472D
	global_store_b32 v[45:46], v103, off offset:192            // 0000000021F8: DC6A00C0 007C672D
	global_store_b32 v[85:86], v16, off                        // 000000002200: DC6A0000 007C1055
	global_store_b32 v[85:86], v40, off offset:64              // 000000002208: DC6A0040 007C2855
	global_store_b32 v[85:86], v72, off offset:128             // 000000002210: DC6A0080 007C4855
	s_clause 0x20                                              // 000000002218: BF850020
	global_store_b32 v[85:86], v104, off offset:192            // 00000000221C: DC6A00C0 007C6855
	global_store_b32 v[47:48], v1, off                         // 000000002224: DC6A0000 007C012F
	global_store_b32 v[47:48], v25, off offset:64              // 00000000222C: DC6A0040 007C192F
	global_store_b32 v[47:48], v57, off offset:128             // 000000002234: DC6A0080 007C392F
	global_store_b32 v[47:48], v89, off offset:192             // 00000000223C: DC6A00C0 007C592F
	global_store_b32 v[41:42], v2, off                         // 000000002244: DC6A0000 007C0229
	global_store_b32 v[41:42], v26, off offset:64              // 00000000224C: DC6A0040 007C1A29
	global_store_b32 v[41:42], v58, off offset:128             // 000000002254: DC6A0080 007C3A29
	global_store_b32 v[41:42], v90, off offset:192             // 00000000225C: DC6A00C0 007C5A29
	global_store_b32 v[87:88], v3, off                         // 000000002264: DC6A0000 007C0357
	global_store_b32 v[87:88], v27, off offset:64              // 00000000226C: DC6A0040 007C1B57
	global_store_b32 v[87:88], v59, off offset:128             // 000000002274: DC6A0080 007C3B57
	global_store_b32 v[87:88], v91, off offset:192             // 00000000227C: DC6A00C0 007C5B57
	global_store_b32 v[115:116], v4, off                       // 000000002284: DC6A0000 007C0473
	global_store_b32 v[115:116], v28, off offset:64            // 00000000228C: DC6A0040 007C1C73
	global_store_b32 v[115:116], v60, off offset:128           // 000000002294: DC6A0080 007C3C73
	global_store_b32 v[115:116], v92, off offset:192           // 00000000229C: DC6A00C0 007C5C73
	global_store_b32 v[117:118], v5, off                       // 0000000022A4: DC6A0000 007C0575
	global_store_b32 v[117:118], v29, off offset:64            // 0000000022AC: DC6A0040 007C1D75
	global_store_b32 v[117:118], v61, off offset:128           // 0000000022B4: DC6A0080 007C3D75
	global_store_b32 v[117:118], v93, off offset:192           // 0000000022BC: DC6A00C0 007C5D75
	global_store_b32 v[119:120], v6, off                       // 0000000022C4: DC6A0000 007C0677
	global_store_b32 v[119:120], v30, off offset:64            // 0000000022CC: DC6A0040 007C1E77
	global_store_b32 v[119:120], v62, off offset:128           // 0000000022D4: DC6A0080 007C3E77
	global_store_b32 v[119:120], v94, off offset:192           // 0000000022DC: DC6A00C0 007C5E77
	global_store_b32 v[121:122], v7, off                       // 0000000022E4: DC6A0000 007C0779
	global_store_b32 v[121:122], v31, off offset:64            // 0000000022EC: DC6A0040 007C1F79
	global_store_b32 v[121:122], v63, off offset:128           // 0000000022F4: DC6A0080 007C3F79
	global_store_b32 v[121:122], v95, off offset:192           // 0000000022FC: DC6A00C0 007C5F79
	global_store_b32 v[123:124], v8, off                       // 000000002304: DC6A0000 007C087B
	global_store_b32 v[123:124], v32, off offset:64            // 00000000230C: DC6A0040 007C207B
	global_store_b32 v[123:124], v64, off offset:128           // 000000002314: DC6A0080 007C407B
	global_store_b32 v[123:124], v96, off offset:192           // 00000000231C: DC6A00C0 007C607B
	s_nop 0                                                    // 000000002324: BF800000
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)                       // 000000002328: BFB60003
	s_endpgm                                                   // 00000000232C: BFB00000
