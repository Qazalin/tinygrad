
<stdin>:	file format elf64-amdgpu

Disassembly of section .text:

0000000000001600 <r_32_8_4_2_16_128_16_8_4_4>:
	v_bfe_u32 v4, v0, 20, 10                                   // 000000001600: D6100004 02292900
	v_mov_b32_e32 v121, 0                                      // 000000001608: 7EF20280
	s_load_b128 s[4:7], s[0:1], null                           // 00000000160C: F4080100 F8000000
	s_lshl_b32 s8, s15, 17                                     // 000000001614: 8408910F
	s_load_b64 s[0:1], s[0:1], 0x10                            // 000000001618: F4040000 F8000010
	v_lshlrev_b32_e32 v4, 6, v4                                // 000000001620: 30080886
	v_dual_mov_b32 v122, v121 :: v_dual_and_b32 v3, 0x3ff, v0  // 000000001624: CA240179 7A0200FF 000003FF
	s_lshl_b32 s2, s14, 8                                      // 000000001630: 8402880E
	v_mov_b32_e32 v123, v121                                   // 000000001634: 7EF60379
	v_mov_b32_e32 v125, v121                                   // 000000001638: 7EFA0379
	s_delay_alu instid0(VALU_DEP_3)                            // 00000000163C: BF870003
	v_lshl_add_u32 v1, v3, 11, s8                              // 000000001640: D6460001 00211703
	v_add3_u32 v163, s2, v4, v3                                // 000000001648: D65500A3 040E0802
	v_mov_b32_e32 v124, v121                                   // 000000001650: 7EF80379
	v_mov_b32_e32 v126, v121                                   // 000000001654: 7EFC0379
	v_mov_b32_e32 v127, v121                                   // 000000001658: 7EFE0379
	v_ashrrev_i32_e32 v2, 31, v1                               // 00000000165C: 3404029F
	v_dual_mov_b32 v161, v163 :: v_dual_mov_b32 v128, v121     // 000000001660: CA1001A3 A1800179
	v_mov_b32_e32 v113, v121                                   // 000000001668: 7EE20379
	v_mov_b32_e32 v114, v121                                   // 00000000166C: 7EE40379
	s_delay_alu instid0(VALU_DEP_4)                            // 000000001670: BF870004
	v_lshlrev_b64 v[1:2], 1, v[1:2]                            // 000000001674: D73C0001 00020281
	v_mov_b32_e32 v115, v121                                   // 00000000167C: 7EE60379
	v_mov_b32_e32 v116, v121                                   // 000000001680: 7EE80379
	v_mov_b32_e32 v117, v121                                   // 000000001684: 7EEA0379
	v_mov_b32_e32 v118, v121                                   // 000000001688: 7EEC0379
	v_mov_b32_e32 v119, v121                                   // 00000000168C: 7EEE0379
	s_waitcnt lgkmcnt(0)                                       // 000000001690: BF89FC07
	v_add_co_u32 v164, vcc_lo, s6, v1                          // 000000001694: D7006AA4 00020206
	v_add_co_ci_u32_e32 v165, vcc_lo, s7, v2, vcc_lo           // 00000000169C: 414A0407
	v_mov_b32_e32 v120, v121                                   // 0000000016A0: 7EF00379
	v_mov_b32_e32 v105, v121                                   // 0000000016A4: 7ED20379
	v_mov_b32_e32 v106, v121                                   // 0000000016A8: 7ED40379
	v_mov_b32_e32 v107, v121                                   // 0000000016AC: 7ED60379
	v_mov_b32_e32 v108, v121                                   // 0000000016B0: 7ED80379
	v_mov_b32_e32 v109, v121                                   // 0000000016B4: 7EDA0379
	v_mov_b32_e32 v110, v121                                   // 0000000016B8: 7EDC0379
	v_mov_b32_e32 v111, v121                                   // 0000000016BC: 7EDE0379
	v_mov_b32_e32 v112, v121                                   // 0000000016C0: 7EE00379
	v_mov_b32_e32 v97, v121                                    // 0000000016C4: 7EC20379
	v_mov_b32_e32 v98, v121                                    // 0000000016C8: 7EC40379
	v_mov_b32_e32 v99, v121                                    // 0000000016CC: 7EC60379
	v_mov_b32_e32 v100, v121                                   // 0000000016D0: 7EC80379
	v_mov_b32_e32 v101, v121                                   // 0000000016D4: 7ECA0379
	v_mov_b32_e32 v102, v121                                   // 0000000016D8: 7ECC0379
	v_mov_b32_e32 v103, v121                                   // 0000000016DC: 7ECE0379
	v_mov_b32_e32 v104, v121                                   // 0000000016E0: 7ED00379
	v_mov_b32_e32 v89, v121                                    // 0000000016E4: 7EB20379
	v_mov_b32_e32 v90, v121                                    // 0000000016E8: 7EB40379
	v_mov_b32_e32 v91, v121                                    // 0000000016EC: 7EB60379
	v_mov_b32_e32 v92, v121                                    // 0000000016F0: 7EB80379
	v_mov_b32_e32 v93, v121                                    // 0000000016F4: 7EBA0379
	v_mov_b32_e32 v94, v121                                    // 0000000016F8: 7EBC0379
	v_mov_b32_e32 v95, v121                                    // 0000000016FC: 7EBE0379
	v_mov_b32_e32 v96, v121                                    // 000000001700: 7EC00379
	v_mov_b32_e32 v81, v121                                    // 000000001704: 7EA20379
	v_mov_b32_e32 v82, v121                                    // 000000001708: 7EA40379
	v_mov_b32_e32 v83, v121                                    // 00000000170C: 7EA60379
	v_mov_b32_e32 v84, v121                                    // 000000001710: 7EA80379
	v_mov_b32_e32 v85, v121                                    // 000000001714: 7EAA0379
	v_mov_b32_e32 v86, v121                                    // 000000001718: 7EAC0379
	v_mov_b32_e32 v87, v121                                    // 00000000171C: 7EAE0379
	v_mov_b32_e32 v88, v121                                    // 000000001720: 7EB00379
	v_mov_b32_e32 v73, v121                                    // 000000001724: 7E920379
	v_mov_b32_e32 v74, v121                                    // 000000001728: 7E940379
	v_mov_b32_e32 v75, v121                                    // 00000000172C: 7E960379
	v_mov_b32_e32 v76, v121                                    // 000000001730: 7E980379
	v_mov_b32_e32 v77, v121                                    // 000000001734: 7E9A0379
	v_mov_b32_e32 v78, v121                                    // 000000001738: 7E9C0379
	v_mov_b32_e32 v79, v121                                    // 00000000173C: 7E9E0379
	v_mov_b32_e32 v80, v121                                    // 000000001740: 7EA00379
	v_mov_b32_e32 v65, v121                                    // 000000001744: 7E820379
	v_mov_b32_e32 v66, v121                                    // 000000001748: 7E840379
	v_mov_b32_e32 v67, v121                                    // 00000000174C: 7E860379
	v_mov_b32_e32 v68, v121                                    // 000000001750: 7E880379
	v_mov_b32_e32 v69, v121                                    // 000000001754: 7E8A0379
	v_mov_b32_e32 v70, v121                                    // 000000001758: 7E8C0379
	v_mov_b32_e32 v71, v121                                    // 00000000175C: 7E8E0379
	v_mov_b32_e32 v72, v121                                    // 000000001760: 7E900379
	v_mov_b32_e32 v57, v121                                    // 000000001764: 7E720379
	v_mov_b32_e32 v58, v121                                    // 000000001768: 7E740379
	v_mov_b32_e32 v59, v121                                    // 00000000176C: 7E760379
	v_mov_b32_e32 v60, v121                                    // 000000001770: 7E780379
	v_mov_b32_e32 v61, v121                                    // 000000001774: 7E7A0379
	v_mov_b32_e32 v62, v121                                    // 000000001778: 7E7C0379
	v_mov_b32_e32 v63, v121                                    // 00000000177C: 7E7E0379
	v_mov_b32_e32 v64, v121                                    // 000000001780: 7E800379
	v_mov_b32_e32 v49, v121                                    // 000000001784: 7E620379
	v_mov_b32_e32 v50, v121                                    // 000000001788: 7E640379
	v_mov_b32_e32 v51, v121                                    // 00000000178C: 7E660379
	v_mov_b32_e32 v52, v121                                    // 000000001790: 7E680379
	v_mov_b32_e32 v53, v121                                    // 000000001794: 7E6A0379
	v_mov_b32_e32 v54, v121                                    // 000000001798: 7E6C0379
	v_mov_b32_e32 v55, v121                                    // 00000000179C: 7E6E0379
	v_mov_b32_e32 v56, v121                                    // 0000000017A0: 7E700379
	v_mov_b32_e32 v41, v121                                    // 0000000017A4: 7E520379
	v_mov_b32_e32 v42, v121                                    // 0000000017A8: 7E540379
	v_mov_b32_e32 v43, v121                                    // 0000000017AC: 7E560379
	v_mov_b32_e32 v44, v121                                    // 0000000017B0: 7E580379
	v_mov_b32_e32 v45, v121                                    // 0000000017B4: 7E5A0379
	v_mov_b32_e32 v46, v121                                    // 0000000017B8: 7E5C0379
	v_mov_b32_e32 v47, v121                                    // 0000000017BC: 7E5E0379
	v_mov_b32_e32 v48, v121                                    // 0000000017C0: 7E600379
	v_mov_b32_e32 v33, v121                                    // 0000000017C4: 7E420379
	v_mov_b32_e32 v34, v121                                    // 0000000017C8: 7E440379
	v_mov_b32_e32 v35, v121                                    // 0000000017CC: 7E460379
	v_mov_b32_e32 v36, v121                                    // 0000000017D0: 7E480379
	v_mov_b32_e32 v37, v121                                    // 0000000017D4: 7E4A0379
	v_mov_b32_e32 v38, v121                                    // 0000000017D8: 7E4C0379
	v_mov_b32_e32 v39, v121                                    // 0000000017DC: 7E4E0379
	v_mov_b32_e32 v40, v121                                    // 0000000017E0: 7E500379
	v_mov_b32_e32 v25, v121                                    // 0000000017E4: 7E320379
	v_mov_b32_e32 v26, v121                                    // 0000000017E8: 7E340379
	v_mov_b32_e32 v27, v121                                    // 0000000017EC: 7E360379
	v_mov_b32_e32 v28, v121                                    // 0000000017F0: 7E380379
	v_mov_b32_e32 v29, v121                                    // 0000000017F4: 7E3A0379
	v_mov_b32_e32 v30, v121                                    // 0000000017F8: 7E3C0379
	v_mov_b32_e32 v31, v121                                    // 0000000017FC: 7E3E0379
	v_mov_b32_e32 v32, v121                                    // 000000001800: 7E400379
	v_mov_b32_e32 v17, v121                                    // 000000001804: 7E220379
	v_mov_b32_e32 v18, v121                                    // 000000001808: 7E240379
	v_mov_b32_e32 v19, v121                                    // 00000000180C: 7E260379
	v_mov_b32_e32 v20, v121                                    // 000000001810: 7E280379
	v_mov_b32_e32 v21, v121                                    // 000000001814: 7E2A0379
	v_mov_b32_e32 v22, v121                                    // 000000001818: 7E2C0379
	v_mov_b32_e32 v23, v121                                    // 00000000181C: 7E2E0379
	v_mov_b32_e32 v24, v121                                    // 000000001820: 7E300379
	v_mov_b32_e32 v9, v121                                     // 000000001824: 7E120379
	v_mov_b32_e32 v10, v121                                    // 000000001828: 7E140379
	v_mov_b32_e32 v11, v121                                    // 00000000182C: 7E160379
	v_mov_b32_e32 v12, v121                                    // 000000001830: 7E180379
	v_mov_b32_e32 v13, v121                                    // 000000001834: 7E1A0379
	v_mov_b32_e32 v14, v121                                    // 000000001838: 7E1C0379
	v_mov_b32_e32 v15, v121                                    // 00000000183C: 7E1E0379
	v_mov_b32_e32 v16, v121                                    // 000000001840: 7E200379
	v_mov_b32_e32 v1, v121                                     // 000000001844: 7E020379
	v_mov_b32_e32 v2, v121                                     // 000000001848: 7E040379
	v_mov_b32_e32 v3, v121                                     // 00000000184C: 7E060379
	v_mov_b32_e32 v4, v121                                     // 000000001850: 7E080379
	v_mov_b32_e32 v5, v121                                     // 000000001854: 7E0A0379
	v_mov_b32_e32 v6, v121                                     // 000000001858: 7E0C0379
	v_mov_b32_e32 v7, v121                                     // 00000000185C: 7E0E0379
	v_mov_b32_e32 v8, v121                                     // 000000001860: 7E100379
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
	v_wmma_f32_16x16x16_f16 v[121:128], v[129:136], v[182:189], v[121:128]// 000000001C48: CC404079 1DE76D81
	v_wmma_f32_16x16x16_f16 v[113:120], v[137:144], v[182:189], v[113:120]// 000000001C50: CC404071 1DC76D89
	v_wmma_f32_16x16x16_f16 v[105:112], v[145:152], v[182:189], v[105:112]// 000000001C58: CC404069 1DA76D91
	v_wmma_f32_16x16x16_f16 v[97:104], v[153:160], v[182:189], v[97:104]// 000000001C60: CC404061 1D876D99
	s_waitcnt vmcnt(2)                                         // 000000001C68: BF890BF7
	v_wmma_f32_16x16x16_f16 v[89:96], v[129:136], v[190:197], v[89:96]// 000000001C6C: CC404059 1D677D81
	v_wmma_f32_16x16x16_f16 v[81:88], v[137:144], v[190:197], v[81:88]// 000000001C74: CC404051 1D477D89
	v_wmma_f32_16x16x16_f16 v[73:80], v[145:152], v[190:197], v[73:80]// 000000001C7C: CC404049 1D277D91
	v_wmma_f32_16x16x16_f16 v[65:72], v[153:160], v[190:197], v[65:72]// 000000001C84: CC404041 1D077D99
	s_waitcnt vmcnt(1)                                         // 000000001C8C: BF8907F7
	v_wmma_f32_16x16x16_f16 v[57:64], v[129:136], v[174:181], v[57:64]// 000000001C90: CC404039 1CE75D81
	v_wmma_f32_16x16x16_f16 v[49:56], v[137:144], v[174:181], v[49:56]// 000000001C98: CC404031 1CC75D89
	v_wmma_f32_16x16x16_f16 v[41:48], v[145:152], v[174:181], v[41:48]// 000000001CA0: CC404029 1CA75D91
	v_wmma_f32_16x16x16_f16 v[33:40], v[153:160], v[174:181], v[33:40]// 000000001CA8: CC404021 1C875D99
	s_waitcnt vmcnt(0)                                         // 000000001CB0: BF8903F7
	v_wmma_f32_16x16x16_f16 v[25:32], v[129:136], v[166:173], v[25:32]// 000000001CB4: CC404019 1C674D81
	v_wmma_f32_16x16x16_f16 v[17:24], v[137:144], v[166:173], v[17:24]// 000000001CBC: CC404011 1C474D89
	v_wmma_f32_16x16x16_f16 v[9:16], v[145:152], v[166:173], v[9:16]// 000000001CC4: CC404009 1C274D91
	v_wmma_f32_16x16x16_f16 v[1:8], v[153:160], v[166:173], v[1:8]// 000000001CCC: CC404001 1C074D99
	s_cbranch_scc0 65252                                       // 000000001CD4: BFA1FEE4 <r_32_8_4_2_16_128_16_8_4_4+0x268>
	v_bfe_u32 v0, v0, 10, 10                                   // 000000001CD8: D6100000 02291500
	v_cvt_f16_f32_e64 v129, v121                               // 000000001CE0: D58A0081 00000179
	v_cvt_f16_f32_e64 v130, v122                               // 000000001CE8: D58A0082 0000017A
	v_cvt_f16_f32_e64 v131, v114                               // 000000001CF0: D58A0083 00000172
	v_cvt_f16_f32_e64 v172, v33                                // 000000001CF8: D58A00AC 00000121
	v_lshlrev_b32_e32 v0, 11, v0                               // 000000001D00: 3000008B
	v_cvt_f16_f32_e64 v173, v34                                // 000000001D04: D58A00AD 00000122
	v_cvt_f16_f32_e64 v174, v35                                // 000000001D0C: D58A00AE 00000123
	v_cvt_f16_f32_e64 v175, v36                                // 000000001D14: D58A00AF 00000124
	v_cvt_f16_f32_e64 v176, v37                                // 000000001D1C: D58A00B0 00000125
	v_add3_u32 v121, v163, s8, v0                              // 000000001D24: D6550079 040011A3
	v_cvt_f16_f32_e32 v0, v127                                 // 000000001D2C: 7E00157F
	v_cvt_f16_f32_e64 v127, v128                               // 000000001D30: D58A007F 00000180
	v_cvt_f16_f32_e64 v128, v113                               // 000000001D38: D58A0080 00000171
	v_cvt_f16_f32_e64 v177, v38                                // 000000001D40: D58A00B1 00000126
	v_ashrrev_i32_e32 v122, 31, v121                           // 000000001D48: 34F4F29F
	v_cvt_f16_f32_e64 v178, v39                                // 000000001D4C: D58A00B2 00000127
	v_cvt_f16_f32_e64 v179, v40                                // 000000001D54: D58A00B3 00000128
	v_cvt_f16_f32_e64 v164, v41                                // 000000001D5C: D58A00A4 00000129
	v_cvt_f16_f32_e64 v165, v42                                // 000000001D64: D58A00A5 0000012A
	v_lshlrev_b64 v[113:114], 1, v[121:122]                    // 000000001D6C: D73C0071 0002F281
	v_cvt_f16_f32_e32 v121, v105                               // 000000001D74: 7EF21569
	v_cvt_f16_f32_e32 v122, v106                               // 000000001D78: 7EF4156A
	v_cvt_f16_f32_e64 v166, v43                                // 000000001D7C: D58A00A6 0000012B
	v_cvt_f16_f32_e32 v90, v90                                 // 000000001D84: 7EB4155A
	v_cvt_f16_f32_e32 v89, v89                                 // 000000001D88: 7EB21559
	v_add_co_u32 v105, vcc_lo, s4, v113                        // 000000001D8C: D7006A69 0002E204
	v_add_co_ci_u32_e32 v106, vcc_lo, s5, v114, vcc_lo         // 000000001D94: 40D4E405
	v_cvt_f16_f32_e32 v58, v58                                 // 000000001D98: 7E74153A
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)// 000000001D9C: BF870193
	v_add_co_u32 v113, vcc_lo, 0x2000, v105                    // 000000001DA0: D7006A71 0002D2FF 00002000
	v_add_co_ci_u32_e32 v114, vcc_lo, 0, v106, vcc_lo          // 000000001DAC: 40E4D480
	v_add_co_u32 v33, vcc_lo, 0x4000, v105                     // 000000001DB0: D7006A21 0002D2FF 00004000
	v_add_co_ci_u32_e32 v34, vcc_lo, 0, v106, vcc_lo           // 000000001DBC: 4044D480
	v_add_co_u32 v35, vcc_lo, 0x6000, v105                     // 000000001DC0: D7006A23 0002D2FF 00006000
	v_add_co_ci_u32_e32 v36, vcc_lo, 0, v106, vcc_lo           // 000000001DCC: 4048D480
	v_add_co_u32 v37, vcc_lo, 0x8000, v105                     // 000000001DD0: D7006A25 0002D2FF 00008000
	v_add_co_ci_u32_e32 v38, vcc_lo, 0, v106, vcc_lo           // 000000001DDC: 404CD480
	v_add_co_u32 v39, vcc_lo, 0xa000, v105                     // 000000001DE0: D7006A27 0002D2FF 0000A000
	v_add_co_ci_u32_e32 v40, vcc_lo, 0, v106, vcc_lo           // 000000001DEC: 4050D480
	v_add_co_u32 v41, vcc_lo, 0xc000, v105                     // 000000001DF0: D7006A29 0002D2FF 0000C000
	v_add_co_ci_u32_e32 v42, vcc_lo, 0, v106, vcc_lo           // 000000001DFC: 4054D480
	v_add_co_u32 v43, vcc_lo, 0xe000, v105                     // 000000001E00: D7006A2B 0002D2FF 0000E000
	v_cvt_f16_f32_e64 v167, v44                                // 000000001E0C: D58A00A7 0000012C
	v_add_co_ci_u32_e32 v44, vcc_lo, 0, v106, vcc_lo           // 000000001E14: 4058D480
	v_cvt_f16_f32_e32 v57, v57                                 // 000000001E18: 7E721539
	v_cvt_f16_f32_e64 v162, v55                                // 000000001E1C: D58A00A2 00000137
	v_cvt_f16_f32_e64 v168, v45                                // 000000001E24: D58A00A8 0000012D
	v_cvt_f16_f32_e32 v55, v25                                 // 000000001E2C: 7E6E1519
	v_cvt_f16_f32_e32 v45, v26                                 // 000000001E30: 7E5A151A
	v_add_co_u32 v25, vcc_lo, 0x10000, v105                    // 000000001E34: D7006A19 0002D2FF 00010000
	v_add_co_ci_u32_e32 v26, vcc_lo, 0, v106, vcc_lo           // 000000001E40: 4034D480
	s_clause 0x5                                               // 000000001E44: BF850005
	global_store_b16 v[105:106], v129, off                     // 000000001E48: DC660000 007C8169
	global_store_b16 v[105:106], v89, off offset:32            // 000000001E50: DC660020 007C5969
	global_store_b16 v[105:106], v57, off offset:64            // 000000001E58: DC660040 007C3969
	global_store_b16 v[113:114], v90, off offset:32            // 000000001E60: DC660020 007C5A71
	global_store_b16 v[113:114], v58, off offset:64            // 000000001E68: DC660040 007C3A71
	global_store_b16 v[113:114], v45, off offset:96            // 000000001E70: DC660060 007C2D71
	v_add_co_u32 v45, vcc_lo, 0x12000, v105                    // 000000001E78: D7006A2D 0002D2FF 00012000
	v_cvt_f16_f32_e64 v169, v46                                // 000000001E84: D58A00A9 0000012E
	v_add_co_ci_u32_e32 v46, vcc_lo, 0, v106, vcc_lo           // 000000001E8C: 405CD480
	v_cvt_f16_f32_e64 v170, v47                                // 000000001E90: D58A00AA 0000012F
	v_add_co_u32 v47, vcc_lo, 0x14000, v105                    // 000000001E98: D7006A2F 0002D2FF 00014000
	v_cvt_f16_f32_e64 v171, v48                                // 000000001EA4: D58A00AB 00000130
	v_add_co_ci_u32_e32 v48, vcc_lo, 0, v106, vcc_lo           // 000000001EAC: 4060D480
	v_cvt_f16_f32_e64 v156, v49                                // 000000001EB0: D58A009C 00000131
	v_add_co_u32 v49, vcc_lo, 0x16000, v105                    // 000000001EB8: D7006A31 0002D2FF 00016000
	v_cvt_f16_f32_e64 v157, v50                                // 000000001EC4: D58A009D 00000132
	v_add_co_ci_u32_e32 v50, vcc_lo, 0, v106, vcc_lo           // 000000001ECC: 4064D480
	v_cvt_f16_f32_e64 v158, v51                                // 000000001ED0: D58A009E 00000133
	v_add_co_u32 v51, vcc_lo, 0x18000, v105                    // 000000001ED8: D7006A33 0002D2FF 00018000
	v_cvt_f16_f32_e32 v123, v123                               // 000000001EE4: 7EF6157B
	v_cvt_f16_f32_e32 v91, v91                                 // 000000001EE8: 7EB6155B
	v_cvt_f16_f32_e64 v159, v52                                // 000000001EEC: D58A009F 00000134
	v_add_co_ci_u32_e32 v52, vcc_lo, 0, v106, vcc_lo           // 000000001EF4: 4068D480
	v_cvt_f16_f32_e32 v59, v59                                 // 000000001EF8: 7E76153B
	v_cvt_f16_f32_e64 v160, v53                                // 000000001EFC: D58A00A0 00000135
	v_cvt_f16_f32_e32 v53, v27                                 // 000000001F04: 7E6A151B
	v_add_co_u32 v27, vcc_lo, 0x1a000, v105                    // 000000001F08: D7006A1B 0002D2FF 0001A000
	v_cvt_f16_f32_e32 v124, v124                               // 000000001F14: 7EF8157C
	v_cvt_f16_f32_e64 v161, v54                                // 000000001F18: D58A00A1 00000136
	v_cvt_f16_f32_e32 v54, v28                                 // 000000001F20: 7E6C151C
	v_add_co_ci_u32_e32 v28, vcc_lo, 0, v106, vcc_lo           // 000000001F24: 4038D480
	v_cvt_f16_f32_e32 v92, v92                                 // 000000001F28: 7EB8155C
	v_cvt_f16_f32_e32 v60, v60                                 // 000000001F2C: 7E78153C
	s_clause 0x7                                               // 000000001F30: BF850007
	global_store_b16 v[33:34], v123, off                       // 000000001F34: DC660000 007C7B21
	global_store_b16 v[33:34], v91, off offset:32              // 000000001F3C: DC660020 007C5B21
	global_store_b16 v[33:34], v59, off offset:64              // 000000001F44: DC660040 007C3B21
	global_store_b16 v[33:34], v53, off offset:96              // 000000001F4C: DC660060 007C3521
	global_store_b16 v[35:36], v124, off                       // 000000001F54: DC660000 007C7C23
	global_store_b16 v[35:36], v92, off offset:32              // 000000001F5C: DC660020 007C5C23
	global_store_b16 v[35:36], v60, off offset:64              // 000000001F64: DC660040 007C3C23
	global_store_b16 v[35:36], v54, off offset:96              // 000000001F6C: DC660060 007C3623
	v_add_co_u32 v33, vcc_lo, 0x1c000, v105                    // 000000001F74: D7006A21 0002D2FF 0001C000
	v_add_co_ci_u32_e32 v34, vcc_lo, 0, v106, vcc_lo           // 000000001F80: 4044D480
	v_add_co_u32 v35, vcc_lo, 0x1e000, v105                    // 000000001F84: D7006A23 0002D2FF 0001E000
	v_add_co_ci_u32_e32 v36, vcc_lo, 0, v106, vcc_lo           // 000000001F90: 4048D480
	v_add_co_u32 v53, vcc_lo, 0x20000, v105                    // 000000001F94: D7006A35 0002D2FF 00020000
	v_add_co_ci_u32_e32 v54, vcc_lo, 0, v106, vcc_lo           // 000000001FA0: 406CD480
	s_clause 0x1                                               // 000000001FA4: BF850001
	global_store_b16 v[113:114], v130, off                     // 000000001FA8: DC660000 007C8271
	global_store_b16 v[105:106], v55, off offset:96            // 000000001FB0: DC660060 007C3769
	v_add_co_u32 v55, vcc_lo, 0x22000, v105                    // 000000001FB8: D7006A37 0002D2FF 00022000
	v_cvt_f16_f32_e64 v163, v56                                // 000000001FC4: D58A00A3 00000138
	v_add_co_ci_u32_e32 v56, vcc_lo, 0, v106, vcc_lo           // 000000001FCC: 4070D480
	v_add_co_u32 v57, vcc_lo, 0x24000, v105                    // 000000001FD0: D7006A39 0002D2FF 00024000
	v_add_co_ci_u32_e32 v58, vcc_lo, 0, v106, vcc_lo           // 000000001FDC: 4074D480
	v_add_co_u32 v59, vcc_lo, 0x26000, v105                    // 000000001FE0: D7006A3B 0002D2FF 00026000
	v_add_co_ci_u32_e32 v60, vcc_lo, 0, v106, vcc_lo           // 000000001FEC: 4078D480
	v_cvt_f16_f32_e64 v152, v61                                // 000000001FF0: D58A0098 0000013D
	v_add_co_u32 v61, vcc_lo, 0x28000, v105                    // 000000001FF8: D7006A3D 0002D2FF 00028000
	v_cvt_f16_f32_e64 v153, v62                                // 000000002004: D58A0099 0000013E
	v_add_co_ci_u32_e32 v62, vcc_lo, 0, v106, vcc_lo           // 00000000200C: 407CD480
	v_cvt_f16_f32_e64 v154, v63                                // 000000002010: D58A009A 0000013F
	v_add_co_u32 v63, vcc_lo, 0x2a000, v105                    // 000000002018: D7006A3F 0002D2FF 0002A000
	v_cvt_f16_f32_e64 v155, v64                                // 000000002024: D58A009B 00000140
	v_add_co_ci_u32_e32 v64, vcc_lo, 0, v106, vcc_lo           // 00000000202C: 4080D480
	v_cvt_f16_f32_e64 v144, v65                                // 000000002030: D58A0090 00000141
	v_add_co_u32 v65, vcc_lo, 0x2c000, v105                    // 000000002038: D7006A41 0002D2FF 0002C000
	v_cvt_f16_f32_e64 v145, v66                                // 000000002044: D58A0091 00000142
	v_add_co_ci_u32_e32 v66, vcc_lo, 0, v106, vcc_lo           // 00000000204C: 4084D480
	v_cvt_f16_f32_e64 v146, v67                                // 000000002050: D58A0092 00000143
	v_add_co_u32 v67, vcc_lo, 0x2e000, v105                    // 000000002058: D7006A43 0002D2FF 0002E000
	v_cvt_f16_f32_e64 v147, v68                                // 000000002064: D58A0093 00000144
	v_add_co_ci_u32_e32 v68, vcc_lo, 0, v106, vcc_lo           // 00000000206C: 4088D480
	v_cvt_f16_f32_e64 v148, v69                                // 000000002070: D58A0094 00000145
	v_add_co_u32 v69, vcc_lo, 0x30000, v105                    // 000000002078: D7006A45 0002D2FF 00030000
	v_cvt_f16_f32_e64 v149, v70                                // 000000002084: D58A0095 00000146
	v_add_co_ci_u32_e32 v70, vcc_lo, 0, v106, vcc_lo           // 00000000208C: 408CD480
	v_cvt_f16_f32_e64 v150, v71                                // 000000002090: D58A0096 00000147
	v_add_co_u32 v71, vcc_lo, 0x32000, v105                    // 000000002098: D7006A47 0002D2FF 00032000
	v_cvt_f16_f32_e64 v151, v72                                // 0000000020A4: D58A0097 00000148
	v_add_co_ci_u32_e32 v72, vcc_lo, 0, v106, vcc_lo           // 0000000020AC: 4090D480
	v_cvt_f16_f32_e64 v136, v73                                // 0000000020B0: D58A0088 00000149
	v_add_co_u32 v73, vcc_lo, 0x34000, v105                    // 0000000020B8: D7006A49 0002D2FF 00034000
	v_cvt_f16_f32_e64 v137, v74                                // 0000000020C4: D58A0089 0000014A
	v_add_co_ci_u32_e32 v74, vcc_lo, 0, v106, vcc_lo           // 0000000020CC: 4094D480
	v_cvt_f16_f32_e32 v125, v125                               // 0000000020D0: 7EFA157D
	v_cvt_f16_f32_e64 v138, v75                                // 0000000020D4: D58A008A 0000014B
	v_add_co_u32 v75, vcc_lo, 0x36000, v105                    // 0000000020DC: D7006A4B 0002D2FF 00036000
	v_cvt_f16_f32_e32 v93, v93                                 // 0000000020E8: 7EBA155D
	v_cvt_f16_f32_e32 v95, v95                                 // 0000000020EC: 7EBE155F
	v_cvt_f16_f32_e32 v115, v115                               // 0000000020F0: 7EE61573
	v_cvt_f16_f32_e64 v132, v81                                // 0000000020F4: D58A0084 00000151
	v_cvt_f16_f32_e64 v139, v76                                // 0000000020FC: D58A008B 0000014C
	v_add_co_ci_u32_e32 v76, vcc_lo, 0, v106, vcc_lo           // 000000002104: 4098D480
	v_cvt_f16_f32_e32 v117, v117                               // 000000002108: 7EEA1575
	v_cvt_f16_f32_e64 v134, v83                                // 00000000210C: D58A0086 00000153
	v_cvt_f16_f32_e64 v140, v77                                // 000000002114: D58A008C 0000014D
	v_cvt_f16_f32_e32 v29, v29                                 // 00000000211C: 7E3A151D
	v_add_co_u32 v77, vcc_lo, 0x38000, v105                    // 000000002120: D7006A4D 0002D2FF 00038000
	v_cvt_f16_f32_e32 v31, v31                                 // 00000000212C: 7E3E151F
	v_cvt_f16_f32_e32 v126, v126                               // 000000002130: 7EFC157E
	v_cvt_f16_f32_e32 v119, v119                               // 000000002134: 7EEE1577
	v_cvt_f16_f32_e32 v85, v85                                 // 000000002138: 7EAA1555
	v_cvt_f16_f32_e32 v17, v17                                 // 00000000213C: 7E221511
	v_cvt_f16_f32_e32 v94, v94                                 // 000000002140: 7EBC155E
	v_cvt_f16_f32_e32 v96, v96                                 // 000000002144: 7EC01560
	v_cvt_f16_f32_e32 v87, v87                                 // 000000002148: 7EAE1557
	v_cvt_f16_f32_e64 v141, v78                                // 00000000214C: D58A008D 0000014E
	v_add_co_ci_u32_e32 v78, vcc_lo, 0, v106, vcc_lo           // 000000002154: 409CD480
	v_cvt_f16_f32_e32 v19, v19                                 // 000000002158: 7E261513
	v_cvt_f16_f32_e32 v30, v30                                 // 00000000215C: 7E3C151E
	s_clause 0x7                                               // 000000002160: BF850007
	global_store_b16 v[37:38], v125, off                       // 000000002164: DC660000 007C7D25
	global_store_b16 v[37:38], v93, off offset:32              // 00000000216C: DC660020 007C5D25
	global_store_b16 v[37:38], v152, off offset:64             // 000000002174: DC660040 007C9825
	global_store_b16 v[37:38], v29, off offset:96              // 00000000217C: DC660060 007C1D25
	global_store_b16 v[39:40], v126, off                       // 000000002184: DC660000 007C7E27
	global_store_b16 v[39:40], v94, off offset:32              // 00000000218C: DC660020 007C5E27
	global_store_b16 v[39:40], v153, off offset:64             // 000000002194: DC660040 007C9927
	global_store_b16 v[39:40], v30, off offset:96              // 00000000219C: DC660060 007C1E27
	v_cvt_f16_f32_e32 v29, v32                                 // 0000000021A4: 7E3A1520
	s_clause 0x7                                               // 0000000021A8: BF850007
	global_store_b16 v[41:42], v0, off                         // 0000000021AC: DC660000 007C0029
	global_store_b16 v[41:42], v95, off offset:32              // 0000000021B4: DC660020 007C5F29
	global_store_b16 v[41:42], v154, off offset:64             // 0000000021BC: DC660040 007C9A29
	global_store_b16 v[41:42], v31, off offset:96              // 0000000021C4: DC660060 007C1F29
	global_store_b16 v[43:44], v127, off                       // 0000000021CC: DC660000 007C7F2B
	global_store_b16 v[43:44], v96, off offset:32              // 0000000021D4: DC660020 007C602B
	global_store_b16 v[43:44], v155, off offset:64             // 0000000021DC: DC660040 007C9B2B
	global_store_b16 v[43:44], v29, off offset:96              // 0000000021E4: DC660060 007C1D2B
	v_cvt_f16_f32_e32 v0, v18                                  // 0000000021EC: 7E001512
	v_cvt_f16_f32_e32 v116, v116                               // 0000000021F0: 7EE81574
	v_cvt_f16_f32_e32 v107, v107                               // 0000000021F4: 7ED6156B
	v_cvt_f16_f32_e64 v133, v82                                // 0000000021F8: D58A0085 00000152
	v_cvt_f16_f32_e64 v142, v79                                // 000000002200: D58A008E 0000014F
	v_add_co_u32 v79, vcc_lo, 0x3a000, v105                    // 000000002208: D7006A4F 0002D2FF 0003A000
	v_cvt_f16_f32_e32 v21, v21                                 // 000000002214: 7E2A1515
	s_clause 0x7                                               // 000000002218: BF850007
	global_store_b16 v[25:26], v128, off                       // 00000000221C: DC660000 007C8019
	global_store_b16 v[25:26], v132, off offset:32             // 000000002224: DC660020 007C8419
	global_store_b16 v[25:26], v156, off offset:64             // 00000000222C: DC660040 007C9C19
	global_store_b16 v[25:26], v17, off offset:96              // 000000002234: DC660060 007C1119
	global_store_b16 v[45:46], v131, off                       // 00000000223C: DC660000 007C832D
	global_store_b16 v[45:46], v133, off offset:32             // 000000002244: DC660020 007C852D
	global_store_b16 v[45:46], v157, off offset:64             // 00000000224C: DC660040 007C9D2D
	global_store_b16 v[45:46], v0, off offset:96               // 000000002254: DC660060 007C002D
	v_cvt_f16_f32_e32 v0, v20                                  // 00000000225C: 7E001514
	v_cvt_f16_f32_e32 v118, v118                               // 000000002260: 7EEC1576
	v_cvt_f16_f32_e32 v109, v109                               // 000000002264: 7EDA156D
	v_cvt_f16_f32_e64 v135, v84                                // 000000002268: D58A0087 00000154
	v_cvt_f16_f32_e32 v23, v23                                 // 000000002270: 7E2E1517
	s_clause 0x7                                               // 000000002274: BF850007
	global_store_b16 v[47:48], v115, off                       // 000000002278: DC660000 007C732F
	global_store_b16 v[47:48], v134, off offset:32             // 000000002280: DC660020 007C862F
	global_store_b16 v[47:48], v158, off offset:64             // 000000002288: DC660040 007C9E2F
	global_store_b16 v[47:48], v19, off offset:96              // 000000002290: DC660060 007C132F
	global_store_b16 v[49:50], v116, off                       // 000000002298: DC660000 007C7431
	global_store_b16 v[49:50], v135, off offset:32             // 0000000022A0: DC660020 007C8731
	global_store_b16 v[49:50], v159, off offset:64             // 0000000022A8: DC660040 007C9F31
	global_store_b16 v[49:50], v0, off offset:96               // 0000000022B0: DC660060 007C0031
	v_cvt_f16_f32_e32 v0, v22                                  // 0000000022B8: 7E001516
	v_cvt_f16_f32_e32 v120, v120                               // 0000000022BC: 7EF01578
	v_cvt_f16_f32_e32 v111, v111                               // 0000000022C0: 7EDE156F
	v_cvt_f16_f32_e32 v86, v86                                 // 0000000022C4: 7EAC1556
	v_cvt_f16_f32_e64 v143, v80                                // 0000000022C8: D58A008F 00000150
	v_add_co_ci_u32_e32 v80, vcc_lo, 0, v106, vcc_lo           // 0000000022D0: 40A0D480
	v_cvt_f16_f32_e32 v9, v9                                   // 0000000022D4: 7E121509
	s_clause 0x7                                               // 0000000022D8: BF850007
	global_store_b16 v[51:52], v117, off                       // 0000000022DC: DC660000 007C7533
	global_store_b16 v[51:52], v85, off offset:32              // 0000000022E4: DC660020 007C5533
	global_store_b16 v[51:52], v160, off offset:64             // 0000000022EC: DC660040 007CA033
	global_store_b16 v[51:52], v21, off offset:96              // 0000000022F4: DC660060 007C1533
	global_store_b16 v[27:28], v118, off                       // 0000000022FC: DC660000 007C761B
	global_store_b16 v[27:28], v86, off offset:32              // 000000002304: DC660020 007C561B
	global_store_b16 v[27:28], v161, off offset:64             // 00000000230C: DC660040 007CA11B
	global_store_b16 v[27:28], v0, off offset:96               // 000000002314: DC660060 007C001B
	v_cvt_f16_f32_e32 v0, v24                                  // 00000000231C: 7E001518
	v_cvt_f16_f32_e32 v97, v97                                 // 000000002320: 7EC21561
	v_cvt_f16_f32_e32 v88, v88                                 // 000000002324: 7EB01558
	v_add_co_u32 v81, vcc_lo, 0x3c000, v105                    // 000000002328: D7006A51 0002D2FF 0003C000
	v_cvt_f16_f32_e32 v11, v11                                 // 000000002334: 7E16150B
	s_clause 0x7                                               // 000000002338: BF850007
	global_store_b16 v[33:34], v119, off                       // 00000000233C: DC660000 007C7721
	global_store_b16 v[33:34], v87, off offset:32              // 000000002344: DC660020 007C5721
	global_store_b16 v[33:34], v162, off offset:64             // 00000000234C: DC660040 007CA221
	global_store_b16 v[33:34], v23, off offset:96              // 000000002354: DC660060 007C1721
	global_store_b16 v[35:36], v120, off                       // 00000000235C: DC660000 007C7823
	global_store_b16 v[35:36], v88, off offset:32              // 000000002364: DC660020 007C5823
	global_store_b16 v[35:36], v163, off offset:64             // 00000000236C: DC660040 007CA323
	global_store_b16 v[35:36], v0, off offset:96               // 000000002374: DC660060 007C0023
	v_cvt_f16_f32_e32 v0, v10                                  // 00000000237C: 7E00150A
	v_cvt_f16_f32_e32 v108, v108                               // 000000002380: 7ED8156C
	v_cvt_f16_f32_e32 v99, v99                                 // 000000002384: 7EC61563
	v_cvt_f16_f32_e32 v13, v13                                 // 000000002388: 7E1A150D
	s_clause 0x7                                               // 00000000238C: BF850007
	global_store_b16 v[53:54], v121, off                       // 000000002390: DC660000 007C7935
	global_store_b16 v[53:54], v136, off offset:32             // 000000002398: DC660020 007C8835
	global_store_b16 v[53:54], v164, off offset:64             // 0000000023A0: DC660040 007CA435
	global_store_b16 v[53:54], v9, off offset:96               // 0000000023A8: DC660060 007C0935
	global_store_b16 v[55:56], v122, off                       // 0000000023B0: DC660000 007C7A37
	global_store_b16 v[55:56], v137, off offset:32             // 0000000023B8: DC660020 007C8937
	global_store_b16 v[55:56], v165, off offset:64             // 0000000023C0: DC660040 007CA537
	global_store_b16 v[55:56], v0, off offset:96               // 0000000023C8: DC660060 007C0037
	v_cvt_f16_f32_e32 v0, v12                                  // 0000000023D0: 7E00150C
	v_cvt_f16_f32_e32 v110, v110                               // 0000000023D4: 7EDC156E
	v_cvt_f16_f32_e32 v101, v101                               // 0000000023D8: 7ECA1565
	v_cvt_f16_f32_e32 v103, v103                               // 0000000023DC: 7ECE1567
	v_add_co_ci_u32_e32 v82, vcc_lo, 0, v106, vcc_lo           // 0000000023E0: 40A4D480
	v_cvt_f16_f32_e32 v15, v15                                 // 0000000023E4: 7E1E150F
	s_clause 0x7                                               // 0000000023E8: BF850007
	global_store_b16 v[57:58], v107, off                       // 0000000023EC: DC660000 007C6B39
	global_store_b16 v[57:58], v138, off offset:32             // 0000000023F4: DC660020 007C8A39
	global_store_b16 v[57:58], v166, off offset:64             // 0000000023FC: DC660040 007CA639
	global_store_b16 v[57:58], v11, off offset:96              // 000000002404: DC660060 007C0B39
	global_store_b16 v[59:60], v108, off                       // 00000000240C: DC660000 007C6C3B
	global_store_b16 v[59:60], v139, off offset:32             // 000000002414: DC660020 007C8B3B
	global_store_b16 v[59:60], v167, off offset:64             // 00000000241C: DC660040 007CA73B
	global_store_b16 v[59:60], v0, off offset:96               // 000000002424: DC660060 007C003B
	v_cvt_f16_f32_e32 v0, v14                                  // 00000000242C: 7E00150E
	v_cvt_f16_f32_e32 v112, v112                               // 000000002430: 7EE01570
	v_cvt_f16_f32_e32 v1, v1                                   // 000000002434: 7E021501
	s_clause 0x7                                               // 000000002438: BF850007
	global_store_b16 v[61:62], v109, off                       // 00000000243C: DC660000 007C6D3D
	global_store_b16 v[61:62], v140, off offset:32             // 000000002444: DC660020 007C8C3D
	global_store_b16 v[61:62], v168, off offset:64             // 00000000244C: DC660040 007CA83D
	global_store_b16 v[61:62], v13, off offset:96              // 000000002454: DC660060 007C0D3D
	global_store_b16 v[63:64], v110, off                       // 00000000245C: DC660000 007C6E3F
	global_store_b16 v[63:64], v141, off offset:32             // 000000002464: DC660020 007C8D3F
	global_store_b16 v[63:64], v169, off offset:64             // 00000000246C: DC660040 007CA93F
	global_store_b16 v[63:64], v0, off offset:96               // 000000002474: DC660060 007C003F
	v_cvt_f16_f32_e32 v0, v16                                  // 00000000247C: 7E001510
	v_cvt_f16_f32_e32 v98, v98                                 // 000000002480: 7EC41562
	v_add_co_u32 v83, vcc_lo, 0x3e000, v105                    // 000000002484: D7006A53 0002D2FF 0003E000
	v_cvt_f16_f32_e32 v3, v3                                   // 000000002490: 7E061503
	s_clause 0x7                                               // 000000002494: BF850007
	global_store_b16 v[65:66], v111, off                       // 000000002498: DC660000 007C6F41
	global_store_b16 v[65:66], v142, off offset:32             // 0000000024A0: DC660020 007C8E41
	global_store_b16 v[65:66], v170, off offset:64             // 0000000024A8: DC660040 007CAA41
	global_store_b16 v[65:66], v15, off offset:96              // 0000000024B0: DC660060 007C0F41
	global_store_b16 v[67:68], v112, off                       // 0000000024B8: DC660000 007C7043
	global_store_b16 v[67:68], v143, off offset:32             // 0000000024C0: DC660020 007C8F43
	global_store_b16 v[67:68], v171, off offset:64             // 0000000024C8: DC660040 007CAB43
	global_store_b16 v[67:68], v0, off offset:96               // 0000000024D0: DC660060 007C0043
	v_cvt_f16_f32_e32 v0, v2                                   // 0000000024D8: 7E001502
	v_cvt_f16_f32_e32 v100, v100                               // 0000000024DC: 7EC81564
	v_cvt_f16_f32_e32 v5, v5                                   // 0000000024E0: 7E0A1505
	v_cvt_f16_f32_e32 v7, v7                                   // 0000000024E4: 7E0E1507
	s_clause 0x7                                               // 0000000024E8: BF850007
	global_store_b16 v[69:70], v97, off                        // 0000000024EC: DC660000 007C6145
	global_store_b16 v[69:70], v144, off offset:32             // 0000000024F4: DC660020 007C9045
	global_store_b16 v[69:70], v172, off offset:64             // 0000000024FC: DC660040 007CAC45
	global_store_b16 v[69:70], v1, off offset:96               // 000000002504: DC660060 007C0145
	global_store_b16 v[71:72], v98, off                        // 00000000250C: DC660000 007C6247
	global_store_b16 v[71:72], v145, off offset:32             // 000000002514: DC660020 007C9147
	global_store_b16 v[71:72], v173, off offset:64             // 00000000251C: DC660040 007CAD47
	global_store_b16 v[71:72], v0, off offset:96               // 000000002524: DC660060 007C0047
	v_cvt_f16_f32_e32 v0, v4                                   // 00000000252C: 7E001504
	v_cvt_f16_f32_e32 v102, v102                               // 000000002530: 7ECC1566
	v_cvt_f16_f32_e32 v104, v104                               // 000000002534: 7ED01568
	v_add_co_ci_u32_e32 v84, vcc_lo, 0, v106, vcc_lo           // 000000002538: 40A8D480
	s_clause 0x7                                               // 00000000253C: BF850007
	global_store_b16 v[73:74], v99, off                        // 000000002540: DC660000 007C6349
	global_store_b16 v[73:74], v146, off offset:32             // 000000002548: DC660020 007C9249
	global_store_b16 v[73:74], v174, off offset:64             // 000000002550: DC660040 007CAE49
	global_store_b16 v[73:74], v3, off offset:96               // 000000002558: DC660060 007C0349
	global_store_b16 v[75:76], v100, off                       // 000000002560: DC660000 007C644B
	global_store_b16 v[75:76], v147, off offset:32             // 000000002568: DC660020 007C934B
	global_store_b16 v[75:76], v175, off offset:64             // 000000002570: DC660040 007CAF4B
	global_store_b16 v[75:76], v0, off offset:96               // 000000002578: DC660060 007C004B
	v_cvt_f16_f32_e32 v0, v6                                   // 000000002580: 7E001506
	s_clause 0x7                                               // 000000002584: BF850007
	global_store_b16 v[77:78], v101, off                       // 000000002588: DC660000 007C654D
	global_store_b16 v[77:78], v148, off offset:32             // 000000002590: DC660020 007C944D
	global_store_b16 v[77:78], v176, off offset:64             // 000000002598: DC660040 007CB04D
	global_store_b16 v[77:78], v5, off offset:96               // 0000000025A0: DC660060 007C054D
	global_store_b16 v[79:80], v102, off                       // 0000000025A8: DC660000 007C664F
	global_store_b16 v[79:80], v149, off offset:32             // 0000000025B0: DC660020 007C954F
	global_store_b16 v[79:80], v177, off offset:64             // 0000000025B8: DC660040 007CB14F
	global_store_b16 v[79:80], v0, off offset:96               // 0000000025C0: DC660060 007C004F
	v_cvt_f16_f32_e32 v0, v8                                   // 0000000025C8: 7E001508
	s_clause 0x7                                               // 0000000025CC: BF850007
	global_store_b16 v[81:82], v103, off                       // 0000000025D0: DC660000 007C6751
	global_store_b16 v[81:82], v150, off offset:32             // 0000000025D8: DC660020 007C9651
	global_store_b16 v[81:82], v178, off offset:64             // 0000000025E0: DC660040 007CB251
	global_store_b16 v[81:82], v7, off offset:96               // 0000000025E8: DC660060 007C0751
	global_store_b16 v[83:84], v104, off                       // 0000000025F0: DC660000 007C6853
	global_store_b16 v[83:84], v151, off offset:32             // 0000000025F8: DC660020 007C9753
	global_store_b16 v[83:84], v179, off offset:64             // 000000002600: DC660040 007CB353
	global_store_b16 v[83:84], v0, off offset:96               // 000000002608: DC660060 007C0053
	s_nop 0                                                    // 000000002610: BF800000
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)                       // 000000002614: BFB60003
	s_endpgm                                                   // 000000002618: BFB00000

   4194304    210.63 us, would be  81564.21 GFLOPS matmul, 238.96 GB/s
0.0002106300016748719
[518.  519.  520.5 ... 524.5 514.  516. ]
