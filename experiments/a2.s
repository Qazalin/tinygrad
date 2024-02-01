
<stdin>:	file format elf64-amdgpu

Disassembly of section .text:

0000000000001800 <test>:
	v_bfe_u32 v1, v0, 10, 10                                   // 000000001800: D6100001 02291500
	v_bfe_u32 v2, v0, 20, 10                                   // 000000001808: D6100002 02292900
	v_and_b32_e32 v133, 0x3ff, v0                              // 000000001810: 370A00FF 000003FF
	s_clause 0x1                                               // 000000001818: BF850001
	s_load_b64 s[4:5], s[0:1], 0x10                            // 00000000181C: F4040100 F8000010
	s_load_b128 s[0:3], s[0:1], null                           // 000000001824: F4080000 F8000000
	v_dual_mov_b32 v0, 0 :: v_dual_lshlrev_b32 v1, 17, v1      // 00000000182C: CA220080 00000291
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000001834: BF870111
	v_dual_mov_b32 v5, v0 :: v_dual_lshlrev_b32 v2, 6, v2      // 000000001838: CA220100 05020486
	v_lshl_add_u32 v128, s14, 18, v1                           // 000000001840: D6460080 0405240E
	v_mov_b32_e32 v1, v0                                       // 000000001848: 7E020300
	s_delay_alu instid0(VALU_DEP_3)                            // 00000000184C: BF870003
	v_lshl_add_u32 v134, s15, 7, v2                            // 000000001850: D6460086 04090E0F
	v_mov_b32_e32 v2, v0                                       // 000000001858: 7E040300
	v_and_b32_e32 v10, 15, v133                                // 00000000185C: 36150A8F
	v_ashrrev_i32_e32 v129, 31, v128                           // 000000001860: 3503009F
	v_mov_b32_e32 v11, v0                                      // 000000001864: 7E160300
	v_ashrrev_i32_e32 v4, 31, v134                             // 000000001868: 34090C9F
	v_mov_b32_e32 v12, v0                                      // 00000000186C: 7E180300
	v_or_b32_e32 v3, v134, v10                                 // 000000001870: 38061586
	v_lshlrev_b64 v[6:7], 1, v[128:129]                        // 000000001874: D73C0006 00030081
	v_mov_b32_e32 v13, v0                                      // 00000000187C: 7E1A0300
	v_mov_b32_e32 v14, v0                                      // 000000001880: 7E1C0300
	v_mov_b32_e32 v15, v0                                      // 000000001884: 7E1E0300
	v_lshlrev_b64 v[8:9], 1, v[3:4]                            // 000000001888: D73C0008 00020681
	v_mov_b32_e32 v3, v0                                       // 000000001890: 7E060300
	v_lshl_or_b32 v6, v10, 12, v6                              // 000000001894: D6560006 0419190A
	v_mov_b32_e32 v4, v0                                       // 00000000189C: 7E080300
	v_mov_b32_e32 v10, v0                                      // 0000000018A0: 7E140300
	v_mov_b32_e32 v16, v0                                      // 0000000018A4: 7E200300
	s_waitcnt lgkmcnt(0)                                       // 0000000018A8: BF89FC07
	v_add_co_u32 v8, vcc_lo, v8, s4                            // 0000000018AC: D7006A08 00000908
	v_add_co_ci_u32_e32 v9, vcc_lo, s5, v9, vcc_lo             // 0000000018B4: 40121205
	v_add_co_u32 v6, vcc_lo, v6, s2                            // 0000000018B8: D7006A06 00000506
	v_add_co_ci_u32_e32 v7, vcc_lo, s3, v7, vcc_lo             // 0000000018C0: 400E0E03
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)// 0000000018C4: BF870214
	v_add_co_u32 v129, vcc_lo, 0xf060, v8                      // 0000000018C8: D7006A81 000210FF 0000F060
	v_add_co_ci_u32_e32 v130, vcc_lo, 0, v9, vcc_lo            // 0000000018D4: 41041280
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)// 0000000018D8: BF870214
	v_add_co_u32 v131, vcc_lo, 0x3001c, v6                     // 0000000018DC: D7006A83 00020CFF 0003001C
	v_add_co_ci_u32_e32 v132, vcc_lo, 0, v7, vcc_lo            // 0000000018E8: 41080E80
	v_mov_b32_e32 v6, v0                                       // 0000000018EC: 7E0C0300
	v_mov_b32_e32 v7, v0                                       // 0000000018F0: 7E0E0300
	v_mov_b32_e32 v8, v0                                       // 0000000018F4: 7E100300
	v_mov_b32_e32 v9, v0                                       // 0000000018F8: 7E120300
	v_mov_b32_e32 v17, v0                                      // 0000000018FC: 7E220300
	v_mov_b32_e32 v18, v0                                      // 000000001900: 7E240300
	v_mov_b32_e32 v19, v0                                      // 000000001904: 7E260300
	v_mov_b32_e32 v20, v0                                      // 000000001908: 7E280300
	v_mov_b32_e32 v21, v0                                      // 00000000190C: 7E2A0300
	v_mov_b32_e32 v22, v0                                      // 000000001910: 7E2C0300
	v_mov_b32_e32 v23, v0                                      // 000000001914: 7E2E0300
	v_mov_b32_e32 v24, v0                                      // 000000001918: 7E300300
	v_mov_b32_e32 v25, v0                                      // 00000000191C: 7E320300
	v_mov_b32_e32 v26, v0                                      // 000000001920: 7E340300
	v_mov_b32_e32 v27, v0                                      // 000000001924: 7E360300
	v_mov_b32_e32 v28, v0                                      // 000000001928: 7E380300
	v_mov_b32_e32 v29, v0                                      // 00000000192C: 7E3A0300
	v_mov_b32_e32 v30, v0                                      // 000000001930: 7E3C0300
	v_mov_b32_e32 v31, v0                                      // 000000001934: 7E3E0300
	v_mov_b32_e32 v32, v0                                      // 000000001938: 7E400300
	v_mov_b32_e32 v33, v0                                      // 00000000193C: 7E420300
	v_mov_b32_e32 v34, v0                                      // 000000001940: 7E440300
	v_mov_b32_e32 v35, v0                                      // 000000001944: 7E460300
	v_mov_b32_e32 v36, v0                                      // 000000001948: 7E480300
	v_mov_b32_e32 v37, v0                                      // 00000000194C: 7E4A0300
	v_mov_b32_e32 v38, v0                                      // 000000001950: 7E4C0300
	v_mov_b32_e32 v39, v0                                      // 000000001954: 7E4E0300
	v_mov_b32_e32 v40, v0                                      // 000000001958: 7E500300
	v_mov_b32_e32 v41, v0                                      // 00000000195C: 7E520300
	v_mov_b32_e32 v42, v0                                      // 000000001960: 7E540300
	v_mov_b32_e32 v43, v0                                      // 000000001964: 7E560300
	v_mov_b32_e32 v44, v0                                      // 000000001968: 7E580300
	v_mov_b32_e32 v45, v0                                      // 00000000196C: 7E5A0300
	v_mov_b32_e32 v46, v0                                      // 000000001970: 7E5C0300
	v_mov_b32_e32 v47, v0                                      // 000000001974: 7E5E0300
	v_mov_b32_e32 v48, v0                                      // 000000001978: 7E600300
	v_mov_b32_e32 v49, v0                                      // 00000000197C: 7E620300
	v_mov_b32_e32 v50, v0                                      // 000000001980: 7E640300
	v_mov_b32_e32 v51, v0                                      // 000000001984: 7E660300
	v_mov_b32_e32 v52, v0                                      // 000000001988: 7E680300
	v_mov_b32_e32 v53, v0                                      // 00000000198C: 7E6A0300
	v_mov_b32_e32 v54, v0                                      // 000000001990: 7E6C0300
	v_mov_b32_e32 v55, v0                                      // 000000001994: 7E6E0300
	v_mov_b32_e32 v56, v0                                      // 000000001998: 7E700300
	v_mov_b32_e32 v57, v0                                      // 00000000199C: 7E720300
	v_mov_b32_e32 v58, v0                                      // 0000000019A0: 7E740300
	v_mov_b32_e32 v59, v0                                      // 0000000019A4: 7E760300
	v_mov_b32_e32 v60, v0                                      // 0000000019A8: 7E780300
	v_mov_b32_e32 v61, v0                                      // 0000000019AC: 7E7A0300
	v_mov_b32_e32 v62, v0                                      // 0000000019B0: 7E7C0300
	v_mov_b32_e32 v63, v0                                      // 0000000019B4: 7E7E0300
	v_mov_b32_e32 v64, v0                                      // 0000000019B8: 7E800300
	v_mov_b32_e32 v65, v0                                      // 0000000019BC: 7E820300
	v_mov_b32_e32 v66, v0                                      // 0000000019C0: 7E840300
	v_mov_b32_e32 v67, v0                                      // 0000000019C4: 7E860300
	v_mov_b32_e32 v68, v0                                      // 0000000019C8: 7E880300
	v_mov_b32_e32 v69, v0                                      // 0000000019CC: 7E8A0300
	v_mov_b32_e32 v70, v0                                      // 0000000019D0: 7E8C0300
	v_mov_b32_e32 v71, v0                                      // 0000000019D4: 7E8E0300
	v_mov_b32_e32 v72, v0                                      // 0000000019D8: 7E900300
	v_mov_b32_e32 v73, v0                                      // 0000000019DC: 7E920300
	v_mov_b32_e32 v74, v0                                      // 0000000019E0: 7E940300
	v_mov_b32_e32 v75, v0                                      // 0000000019E4: 7E960300
	v_mov_b32_e32 v76, v0                                      // 0000000019E8: 7E980300
	v_mov_b32_e32 v77, v0                                      // 0000000019EC: 7E9A0300
	v_mov_b32_e32 v78, v0                                      // 0000000019F0: 7E9C0300
	v_mov_b32_e32 v79, v0                                      // 0000000019F4: 7E9E0300
	v_mov_b32_e32 v80, v0                                      // 0000000019F8: 7EA00300
	v_mov_b32_e32 v81, v0                                      // 0000000019FC: 7EA20300
	v_mov_b32_e32 v82, v0                                      // 000000001A00: 7EA40300
	v_mov_b32_e32 v83, v0                                      // 000000001A04: 7EA60300
	v_mov_b32_e32 v84, v0                                      // 000000001A08: 7EA80300
	v_mov_b32_e32 v85, v0                                      // 000000001A0C: 7EAA0300
	v_mov_b32_e32 v86, v0                                      // 000000001A10: 7EAC0300
	v_mov_b32_e32 v87, v0                                      // 000000001A14: 7EAE0300
	v_mov_b32_e32 v88, v0                                      // 000000001A18: 7EB00300
	v_mov_b32_e32 v89, v0                                      // 000000001A1C: 7EB20300
	v_mov_b32_e32 v90, v0                                      // 000000001A20: 7EB40300
	v_mov_b32_e32 v91, v0                                      // 000000001A24: 7EB60300
	v_mov_b32_e32 v92, v0                                      // 000000001A28: 7EB80300
	v_mov_b32_e32 v93, v0                                      // 000000001A2C: 7EBA0300
	v_mov_b32_e32 v94, v0                                      // 000000001A30: 7EBC0300
	v_mov_b32_e32 v95, v0                                      // 000000001A34: 7EBE0300
	v_mov_b32_e32 v96, v0                                      // 000000001A38: 7EC00300
	v_mov_b32_e32 v97, v0                                      // 000000001A3C: 7EC20300
	v_mov_b32_e32 v98, v0                                      // 000000001A40: 7EC40300
	v_mov_b32_e32 v99, v0                                      // 000000001A44: 7EC60300
	v_mov_b32_e32 v100, v0                                     // 000000001A48: 7EC80300
	v_mov_b32_e32 v101, v0                                     // 000000001A4C: 7ECA0300
	v_mov_b32_e32 v102, v0                                     // 000000001A50: 7ECC0300
	v_mov_b32_e32 v103, v0                                     // 000000001A54: 7ECE0300
	v_mov_b32_e32 v104, v0                                     // 000000001A58: 7ED00300
	v_mov_b32_e32 v105, v0                                     // 000000001A5C: 7ED20300
	v_mov_b32_e32 v106, v0                                     // 000000001A60: 7ED40300
	v_mov_b32_e32 v107, v0                                     // 000000001A64: 7ED60300
	v_mov_b32_e32 v108, v0                                     // 000000001A68: 7ED80300
	v_mov_b32_e32 v109, v0                                     // 000000001A6C: 7EDA0300
	v_mov_b32_e32 v110, v0                                     // 000000001A70: 7EDC0300
	v_mov_b32_e32 v111, v0                                     // 000000001A74: 7EDE0300
	v_mov_b32_e32 v112, v0                                     // 000000001A78: 7EE00300
	v_mov_b32_e32 v113, v0                                     // 000000001A7C: 7EE20300
	v_mov_b32_e32 v114, v0                                     // 000000001A80: 7EE40300
	v_mov_b32_e32 v115, v0                                     // 000000001A84: 7EE60300
	v_mov_b32_e32 v116, v0                                     // 000000001A88: 7EE80300
	v_mov_b32_e32 v117, v0                                     // 000000001A8C: 7EEA0300
	v_mov_b32_e32 v118, v0                                     // 000000001A90: 7EEC0300
	v_mov_b32_e32 v119, v0                                     // 000000001A94: 7EEE0300
	v_mov_b32_e32 v120, v0                                     // 000000001A98: 7EF00300
	v_mov_b32_e32 v121, v0                                     // 000000001A9C: 7EF20300
	v_mov_b32_e32 v122, v0                                     // 000000001AA0: 7EF40300
	v_mov_b32_e32 v123, v0                                     // 000000001AA4: 7EF60300
	v_mov_b32_e32 v124, v0                                     // 000000001AA8: 7EF80300
	v_mov_b32_e32 v125, v0                                     // 000000001AAC: 7EFA0300
	v_mov_b32_e32 v126, v0                                     // 000000001AB0: 7EFC0300
	v_mov_b32_e32 v127, v0                                     // 000000001AB4: 7EFE0300
	s_mov_b32 s2, -16                                          // 000000001AB8: BE8200D0
	v_add_co_u32 v162, vcc_lo, 0xffff3000, v129                // 000000001ABC: D7006AA2 000302FF FFFF3000
	v_add_co_ci_u32_e32 v163, vcc_lo, -1, v130, vcc_lo         // 000000001AC8: 414704C1
	v_add_co_u32 v166, vcc_lo, 0xffff5000, v129                // 000000001ACC: D7006AA6 000302FF FFFF5000
	v_add_co_ci_u32_e32 v167, vcc_lo, -1, v130, vcc_lo         // 000000001AD8: 414F04C1
	v_add_co_u32 v168, vcc_lo, 0xffff7000, v129                // 000000001ADC: D7006AA8 000302FF FFFF7000
	v_add_co_ci_u32_e32 v169, vcc_lo, -1, v130, vcc_lo         // 000000001AE8: 415304C1
	v_add_co_u32 v170, vcc_lo, 0xffff9000, v129                // 000000001AEC: D7006AAA 000302FF FFFF9000
	v_add_co_ci_u32_e32 v171, vcc_lo, -1, v130, vcc_lo         // 000000001AF8: 415704C1
	v_add_co_u32 v164, vcc_lo, 0xffffd000, v129                // 000000001AFC: D7006AA4 000302FF FFFFD000
	v_add_co_ci_u32_e32 v165, vcc_lo, -1, v130, vcc_lo         // 000000001B08: 414B04C1
	v_add_co_u32 v172, vcc_lo, 0xffffb000, v129                // 000000001B0C: D7006AAC 000302FF FFFFB000
	s_waitcnt lgkmcnt(0)                                       // 000000001B18: BF89FC07
	s_barrier                                                  // 000000001B1C: BFBD0000
	s_waitcnt lgkmcnt(0)                                       // 000000001B20: BF89FC07
	v_add_co_ci_u32_e32 v173, vcc_lo, -1, v130, vcc_lo         // 000000001B24: 415B04C1
	s_clause 0xc                                               // 000000001B28: BF85000C
	global_load_u16 v141, v[164:165], off offset:-32           // 000000001B2C: DC4A1FE0 8D7C00A4
	global_load_u16 v149, v[164:165], off offset:-96           // 000000001B34: DC4A1FA0 957C00A4
	global_load_u16 v152, v[162:163], off offset:-64           // 000000001B3C: DC4A1FC0 987C00A2
	global_load_u16 v161, v[166:167], off                      // 000000001B44: DC4A0000 A17C00A6
	global_load_u16 v145, v[166:167], off offset:-96           // 000000001B4C: DC4A1FA0 917C00A6
	global_load_u16 v160, v[162:163], off                      // 000000001B54: DC4A0000 A07C00A2
	global_load_u16 v137, v[166:167], off offset:-32           // 000000001B5C: DC4A1FE0 897C00A6
	global_load_u16 v146, v[168:169], off offset:-96           // 000000001B64: DC4A1FA0 927C00A8
	global_load_u16 v138, v[168:169], off offset:-32           // 000000001B6C: DC4A1FE0 8A7C00A8
	global_load_u16 v147, v[170:171], off offset:-96           // 000000001B74: DC4A1FA0 937C00AA
	global_load_u16 v139, v[170:171], off offset:-32           // 000000001B7C: DC4A1FE0 8B7C00AA
	global_load_u16 v148, v[172:173], off offset:-96           // 000000001B84: DC4A1FA0 947C00AC
	global_load_u16 v140, v[172:173], off offset:-32           // 000000001B8C: DC4A1FE0 8C7C00AC
	v_add_co_u32 v174, vcc_lo, 0xffff1000, v129                // 000000001B94: D7006AAE 000302FF FFFF1000
	v_add_co_ci_u32_e32 v175, vcc_lo, -1, v130, vcc_lo         // 000000001BA0: 415F04C1
	v_add_co_u32 v176, vcc_lo, 0xfffff000, v129                // 000000001BA4: D7006AB0 000302FF FFFFF000
	v_add_co_ci_u32_e32 v177, vcc_lo, -1, v130, vcc_lo         // 000000001BB0: 416304C1
	v_add_co_u32 v178, vcc_lo, 0xffff4000, v129                // 000000001BB4: D7006AB2 000302FF FFFF4000
	v_add_co_ci_u32_e32 v179, vcc_lo, -1, v130, vcc_lo         // 000000001BC0: 416704C1
	v_add_co_u32 v180, vcc_lo, 0xffff6000, v129                // 000000001BC4: D7006AB4 000302FF FFFF6000
	v_add_co_ci_u32_e32 v181, vcc_lo, -1, v130, vcc_lo         // 000000001BD0: 416B04C1
	v_add_co_u32 v182, vcc_lo, 0xffff8000, v129                // 000000001BD4: D7006AB6 000302FF FFFF8000
	v_add_co_ci_u32_e32 v183, vcc_lo, -1, v130, vcc_lo         // 000000001BE0: 416F04C1
	v_add_co_u32 v184, vcc_lo, 0xffffa000, v129                // 000000001BE4: D7006AB8 000302FF FFFFA000
	v_add_co_ci_u32_e32 v185, vcc_lo, -1, v130, vcc_lo         // 000000001BF0: 417304C1
	v_add_co_u32 v186, vcc_lo, 0xffffc000, v129                // 000000001BF4: D7006ABA 000302FF FFFFC000
	v_add_co_ci_u32_e32 v187, vcc_lo, -1, v130, vcc_lo         // 000000001C00: 417704C1
	v_add_co_u32 v188, vcc_lo, 0xffffe000, v129                // 000000001C04: D7006ABC 000302FF FFFFE000
	v_add_co_ci_u32_e32 v189, vcc_lo, -1, v130, vcc_lo         // 000000001C10: 417B04C1
	s_add_i32 s2, s2, 16                                       // 000000001C14: 81029002
	s_clause 0x1c                                              // 000000001C18: BF85001C
	global_load_u16 v144, v[162:163], off offset:-96           // 000000001C1C: DC4A1FA0 907C00A2
	global_load_u16 v150, v[176:177], off offset:-96           // 000000001C24: DC4A1FA0 967C00B0
	global_load_u16 v158, v[176:177], off offset:-64           // 000000001C2C: DC4A1FC0 9E7C00B0
	global_load_u16 v154, v[168:169], off offset:-64           // 000000001C34: DC4A1FC0 9A7C00A8
	global_load_u16 v155, v[170:171], off offset:-64           // 000000001C3C: DC4A1FC0 9B7C00AA
	global_load_u16 v156, v[172:173], off offset:-64           // 000000001C44: DC4A1FC0 9C7C00AC
	global_load_u16 v157, v[164:165], off offset:-64           // 000000001C4C: DC4A1FC0 9D7C00A4
	global_load_u16 v143, v[174:175], off offset:-96           // 000000001C54: DC4A1FA0 8F7C00AE
	global_load_u16 v151, v[174:175], off offset:-64           // 000000001C5C: DC4A1FC0 977C00AE
	global_load_u16 v135, v[174:175], off offset:-32           // 000000001C64: DC4A1FE0 877C00AE
	global_load_u16 v136, v[162:163], off offset:-32           // 000000001C6C: DC4A1FE0 887C00A2
	global_load_u16 v142, v[176:177], off offset:-32           // 000000001C74: DC4A1FE0 8E7C00B0
	global_load_d16_hi_b16 v141, v[188:189], off offset:-32    // 000000001C7C: DC8E1FE0 8D7C00BC
	global_load_u16 v165, v[164:165], off                      // 000000001C84: DC4A0000 A57C00A4
	global_load_d16_hi_b16 v160, v[178:179], off               // 000000001C8C: DC8E0000 A07C00B2
	global_load_u16 v159, v[174:175], off                      // 000000001C94: DC4A0000 9F7C00AE
	global_load_d16_hi_b16 v137, v[180:181], off offset:-32    // 000000001C9C: DC8E1FE0 897C00B4
	global_load_u16 v153, v[166:167], off offset:-64           // 000000001CA4: DC4A1FC0 997C00A6
	global_load_d16_hi_b16 v138, v[182:183], off offset:-32    // 000000001CAC: DC8E1FE0 8A7C00B6
	global_load_u16 v162, v[168:169], off                      // 000000001CB4: DC4A0000 A27C00A8
	global_load_d16_hi_b16 v139, v[184:185], off offset:-32    // 000000001CBC: DC8E1FE0 8B7C00B8
	global_load_u16 v163, v[170:171], off                      // 000000001CC4: DC4A0000 A37C00AA
	global_load_d16_hi_b16 v140, v[186:187], off offset:-32    // 000000001CCC: DC8E1FE0 8C7C00BA
	global_load_u16 v164, v[172:173], off                      // 000000001CD4: DC4A0000 A47C00AC
	global_load_d16_hi_b16 v145, v[180:181], off offset:-96    // 000000001CDC: DC8E1FA0 917C00B4
	global_load_d16_hi_b16 v146, v[182:183], off offset:-96    // 000000001CE4: DC8E1FA0 927C00B6
	global_load_d16_hi_b16 v147, v[184:185], off offset:-96    // 000000001CEC: DC8E1FA0 937C00B8
	global_load_d16_hi_b16 v148, v[186:187], off offset:-96    // 000000001CF4: DC8E1FA0 947C00BA
	global_load_d16_hi_b16 v149, v[188:189], off offset:-96    // 000000001CFC: DC8E1FA0 957C00BC
	v_add_co_u32 v167, vcc_lo, 0xffff2000, v129                // 000000001D04: D7006AA7 000302FF FFFF2000
	v_add_co_ci_u32_e32 v168, vcc_lo, -1, v130, vcc_lo         // 000000001D10: 415104C1
	s_cmpk_lt_u32 s2, 0x7f0                                    // 000000001D14: B68207F0
	s_clause 0x14                                              // 000000001D18: BF850014
	global_load_d16_hi_b16 v144, v[178:179], off offset:-96    // 000000001D1C: DC8E1FA0 907C00B2
	global_load_d16_hi_b16 v150, v[129:130], off offset:-96    // 000000001D24: DC8E1FA0 967C0081
	global_load_d16_hi_b16 v143, v[167:168], off offset:-96    // 000000001D2C: DC8E1FA0 8F7C00A7
	global_load_d16_hi_b16 v151, v[167:168], off offset:-64    // 000000001D34: DC8E1FC0 977C00A7
	global_load_d16_hi_b16 v135, v[167:168], off offset:-32    // 000000001D3C: DC8E1FE0 877C00A7
	global_load_d16_hi_b16 v165, v[188:189], off               // 000000001D44: DC8E0000 A57C00BC
	global_load_d16_hi_b16 v158, v[129:130], off offset:-64    // 000000001D4C: DC8E1FC0 9E7C0081
	global_load_d16_hi_b16 v142, v[129:130], off offset:-32    // 000000001D54: DC8E1FE0 8E7C0081
	global_load_u16 v166, v[129:130], off offset:-4096         // 000000001D5C: DC4A1000 A67C0081
	global_load_d16_hi_b16 v159, v[167:168], off               // 000000001D64: DC8E0000 9F7C00A7
	global_load_d16_hi_b16 v152, v[178:179], off offset:-64    // 000000001D6C: DC8E1FC0 987C00B2
	global_load_d16_hi_b16 v136, v[178:179], off offset:-32    // 000000001D74: DC8E1FE0 887C00B2
	global_load_d16_hi_b16 v153, v[180:181], off offset:-64    // 000000001D7C: DC8E1FC0 997C00B4
	global_load_d16_hi_b16 v161, v[180:181], off               // 000000001D84: DC8E0000 A17C00B4
	global_load_d16_hi_b16 v154, v[182:183], off offset:-64    // 000000001D8C: DC8E1FC0 9A7C00B6
	global_load_d16_hi_b16 v162, v[182:183], off               // 000000001D94: DC8E0000 A27C00B6
	global_load_d16_hi_b16 v155, v[184:185], off offset:-64    // 000000001D9C: DC8E1FC0 9B7C00B8
	global_load_d16_hi_b16 v163, v[184:185], off               // 000000001DA4: DC8E0000 A37C00B8
	global_load_d16_hi_b16 v156, v[186:187], off offset:-64    // 000000001DAC: DC8E1FC0 9C7C00BA
	global_load_d16_hi_b16 v164, v[186:187], off               // 000000001DB4: DC8E0000 A47C00BA
	global_load_d16_hi_b16 v157, v[188:189], off offset:-64    // 000000001DBC: DC8E1FC0 9D7C00BC
	s_clause 0x1                                               // 000000001DC4: BF850001
	global_load_b128 v[167:170], v[131:132], off offset:-28    // 000000001DC8: DC5E1FE4 A77C0083
	global_load_b128 v[171:174], v[131:132], off offset:-12    // 000000001DD0: DC5E1FF4 AB7C0083
	v_add_co_u32 v179, vcc_lo, 0xfffd0000, v131                // 000000001DD8: D7006AB3 000306FF FFFD0000
	v_add_co_ci_u32_e32 v180, vcc_lo, -1, v132, vcc_lo         // 000000001DE4: 416908C1
	v_add_co_u32 v187, vcc_lo, 0xfffe0000, v131                // 000000001DE8: D7006ABB 000306FF FFFE0000
	v_add_co_ci_u32_e32 v188, vcc_lo, -1, v132, vcc_lo         // 000000001DF4: 417908C1
	v_add_co_u32 v195, vcc_lo, 0xffff0000, v131                // 000000001DF8: D7006AC3 000306FF FFFF0000
	v_add_co_ci_u32_e32 v196, vcc_lo, -1, v132, vcc_lo         // 000000001E04: 418908C1
	v_add_co_u32 v131, vcc_lo, v131, 32                        // 000000001E08: D7006A83 00014183
	v_add_co_ci_u32_e32 v132, vcc_lo, 0, v132, vcc_lo          // 000000001E10: 41090880
	s_clause 0x5                                               // 000000001E14: BF850005
	global_load_b128 v[175:178], v[179:180], off offset:-28    // 000000001E18: DC5E1FE4 AF7C00B3
	global_load_b128 v[179:182], v[179:180], off offset:-12    // 000000001E20: DC5E1FF4 B37C00B3
	global_load_b128 v[183:186], v[187:188], off offset:-28    // 000000001E28: DC5E1FE4 B77C00BB
	global_load_b128 v[187:190], v[187:188], off offset:-12    // 000000001E30: DC5E1FF4 BB7C00BB
	global_load_b128 v[191:194], v[195:196], off offset:-28    // 000000001E38: DC5E1FE4 BF7C00C3
	global_load_b128 v[195:198], v[195:196], off offset:-12    // 000000001E40: DC5E1FF4 C37C00C3
	global_load_d16_hi_b16 v166, v[129:130], off               // 000000001E48: DC8E0000 A67C0081
	v_add_co_u32 v129, vcc_lo, 0x10000, v129                   // 000000001E50: D7006A81 000302FF 00010000
	v_add_co_ci_u32_e32 v130, vcc_lo, 0, v130, vcc_lo          // 000000001E5C: 41050480
	s_waitcnt vmcnt(7)                                         // 000000001E60: BF891FF7
	v_wmma_f32_16x16x16_f16 v[96:103], v[167:174], v[143:150], v[96:103]// 000000001E64: CC404060 1D831FA7
	v_wmma_f32_16x16x16_f16 v[64:71], v[167:174], v[151:158], v[64:71]// 000000001E6C: CC404040 1D032FA7
	v_wmma_f32_16x16x16_f16 v[32:39], v[167:174], v[135:142], v[32:39]// 000000001E74: CC404020 1C830FA7
	s_waitcnt vmcnt(5)                                         // 000000001E7C: BF8917F7
	v_wmma_f32_16x16x16_f16 v[120:127], v[175:182], v[143:150], v[120:127]// 000000001E80: CC404078 1DE31FAF
	v_wmma_f32_16x16x16_f16 v[88:95], v[175:182], v[151:158], v[88:95]// 000000001E88: CC404058 1D632FAF
	s_waitcnt vmcnt(3)                                         // 000000001E90: BF890FF7
	v_wmma_f32_16x16x16_f16 v[112:119], v[183:190], v[143:150], v[112:119]// 000000001E94: CC404070 1DC31FB7
	v_wmma_f32_16x16x16_f16 v[80:87], v[183:190], v[151:158], v[80:87]// 000000001E9C: CC404050 1D432FB7
	s_waitcnt vmcnt(1)                                         // 000000001EA4: BF8907F7
	v_wmma_f32_16x16x16_f16 v[104:111], v[191:198], v[143:150], v[104:111]// 000000001EA8: CC404068 1DA31FBF
	v_wmma_f32_16x16x16_f16 v[72:79], v[191:198], v[151:158], v[72:79]// 000000001EB0: CC404048 1D232FBF
	v_wmma_f32_16x16x16_f16 v[56:63], v[175:182], v[135:142], v[56:63]// 000000001EB8: CC404038 1CE30FAF
	v_wmma_f32_16x16x16_f16 v[48:55], v[183:190], v[135:142], v[48:55]// 000000001EC0: CC404030 1CC30FB7
	v_wmma_f32_16x16x16_f16 v[40:47], v[191:198], v[135:142], v[40:47]// 000000001EC8: CC404028 1CA30FBF
	s_waitcnt vmcnt(0)                                         // 000000001ED0: BF8903F7
	v_wmma_f32_16x16x16_f16 v[24:31], v[175:182], v[159:166], v[24:31]// 000000001ED4: CC404018 1C633FAF
	v_wmma_f32_16x16x16_f16 v[16:23], v[183:190], v[159:166], v[16:23]// 000000001EDC: CC404010 1C433FB7
	v_wmma_f32_16x16x16_f16 v[8:15], v[191:198], v[159:166], v[8:15]// 000000001EE4: CC404008 1C233FBF
	v_wmma_f32_16x16x16_f16 v[0:7], v[167:174], v[159:166], v[0:7]// 000000001EEC: CC404000 1C033FA7
	s_cbranch_scc1 65265                                       // 000000001EF4: BFA2FEF1 <test+0x2bc>
	v_lshlrev_b32_e32 v129, 7, v133                            // 000000001EF8: 31030A87
	v_and_or_b32 v130, v133, 15, v134                          // 000000001EFC: D6570082 06191F85
	s_mov_b32 s2, 0                                            // 000000001F04: BE820080
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000001F08: BF870092
	v_and_b32_e32 v129, 0x1f800, v129                          // 000000001F0C: 370302FF 0001F800
	v_add3_u32 v128, v130, v128, v129                          // 000000001F14: D6550080 06070182
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000001F1C: BF870091
	v_ashrrev_i32_e32 v129, 31, v128                           // 000000001F20: 3503009F
	v_lshlrev_b64 v[128:129], 2, v[128:129]                    // 000000001F24: D73C0080 00030082
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000001F2C: BF870111
	v_add_co_u32 v128, vcc_lo, s0, v128                        // 000000001F30: D7006A80 00030000
	v_add_co_ci_u32_e32 v129, vcc_lo, s1, v129, vcc_lo         // 000000001F38: 41030201
	s_mov_b64 s[0:1], 0                                        // 000000001F3C: BE800180
	s_delay_alu instid0(VALU_DEP_2) | instid1(SALU_CYCLE_1)    // 000000001F40: BF870482
	v_add_co_u32 v130, vcc_lo, v128, s0                        // 000000001F44: D7006A82 00000180
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 000000001F4C: BF870122
	v_add_co_ci_u32_e32 v131, vcc_lo, s1, v129, vcc_lo         // 000000001F50: 41070201
	s_mov_b32 m0, s2                                           // 000000001F54: BEFD0002
	v_add_co_u32 v132, vcc_lo, 0x20000, v130                   // 000000001F58: D7006A84 000304FF 00020000
	s_delay_alu instid0(VALU_DEP_2)                            // 000000001F64: BF870002
	v_add_co_ci_u32_e32 v133, vcc_lo, 0, v131, vcc_lo          // 000000001F68: 410B0680
	s_add_i32 s2, s2, 1                                        // 000000001F6C: 81028102
	v_movrels_b32_e32 v138, v120                               // 000000001F70: 7F148778
	v_add_co_u32 v134, vcc_lo, 0x40000, v130                   // 000000001F74: D7006A86 000304FF 00040000
	s_add_u32 s0, s0, 0x4000                                   // 000000001F80: 8000FF00 00004000
	v_movrels_b32_e32 v142, v88                                // 000000001F88: 7F1C8758
	v_movrels_b32_e32 v146, v56                                // 000000001F8C: 7F248738
	s_addc_u32 s1, s1, 0                                       // 000000001F90: 82018001
	v_add_co_ci_u32_e32 v135, vcc_lo, 0, v131, vcc_lo          // 000000001F94: 410F0680
	v_movrels_b32_e32 v140, v104                               // 000000001F98: 7F188768
	s_cmp_lg_u32 s0, 0x20000                                   // 000000001F9C: BF07FF00 00020000
	v_add_co_u32 v136, vcc_lo, 0x60000, v130                   // 000000001FA4: D7006A88 000304FF 00060000
	v_movrels_b32_e32 v144, v72                                // 000000001FB0: 7F208748
	v_movrels_b32_e32 v139, v112                               // 000000001FB4: 7F168770
	v_movrels_b32_e32 v141, v96                                // 000000001FB8: 7F1A8760
	v_movrels_b32_e32 v143, v80                                // 000000001FBC: 7F1E8750
	v_movrels_b32_e32 v145, v64                                // 000000001FC0: 7F228740
	v_movrels_b32_e32 v147, v48                                // 000000001FC4: 7F268730
	v_movrels_b32_e32 v148, v40                                // 000000001FC8: 7F288728
	v_movrels_b32_e32 v149, v32                                // 000000001FCC: 7F2A8720
	v_movrels_b32_e32 v150, v24                                // 000000001FD0: 7F2C8718
	v_movrels_b32_e32 v151, v16                                // 000000001FD4: 7F2E8710
	v_movrels_b32_e32 v152, v8                                 // 000000001FD8: 7F308708
	v_movrels_b32_e32 v153, v0                                 // 000000001FDC: 7F328700
	v_add_co_ci_u32_e32 v137, vcc_lo, 0, v131, vcc_lo          // 000000001FE0: 41130680
	s_clause 0xf                                               // 000000001FE4: BF85000F
	global_store_b32 v[130:131], v138, off                     // 000000001FE8: DC6A0000 007C8A82
	global_store_b32 v[130:131], v142, off offset:64           // 000000001FF0: DC6A0040 007C8E82
	global_store_b32 v[130:131], v146, off offset:128          // 000000001FF8: DC6A0080 007C9282
	global_store_b32 v[134:135], v140, off                     // 000000002000: DC6A0000 007C8C86
	global_store_b32 v[134:135], v144, off offset:64           // 000000002008: DC6A0040 007C9086
	global_store_b32 v[134:135], v148, off offset:128          // 000000002010: DC6A0080 007C9486
	global_store_b32 v[130:131], v150, off offset:192          // 000000002018: DC6A00C0 007C9682
	global_store_b32 v[132:133], v139, off                     // 000000002020: DC6A0000 007C8B84
	global_store_b32 v[132:133], v143, off offset:64           // 000000002028: DC6A0040 007C8F84
	global_store_b32 v[132:133], v147, off offset:128          // 000000002030: DC6A0080 007C9384
	global_store_b32 v[132:133], v151, off offset:192          // 000000002038: DC6A00C0 007C9784
	global_store_b32 v[134:135], v152, off offset:192          // 000000002040: DC6A00C0 007C9886
	global_store_b32 v[136:137], v141, off                     // 000000002048: DC6A0000 007C8D88
	global_store_b32 v[136:137], v145, off offset:64           // 000000002050: DC6A0040 007C9188
	global_store_b32 v[136:137], v149, off offset:128          // 000000002058: DC6A0080 007C9588
	global_store_b32 v[136:137], v153, off offset:192          // 000000002060: DC6A00C0 007C9988
	s_cbranch_scc1 65461                                       // 000000002068: BFA2FFB5 <test+0x740>
	s_nop 0                                                    // 00000000206C: BF800000
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)                       // 000000002070: BFB60003
	s_endpgm                                                   // 000000002074: BFB00000

