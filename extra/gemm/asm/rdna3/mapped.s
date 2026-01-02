// Fully unrolled assembly with mapped basic blocks
// Original blocks: 165
// Trace instructions: 23364


start:  // trace [1:153]
	s_load_b64 s[28:29], s[0:1], null
	s_load_b64 s[34:35], s[0:1], 0x8
	s_load_b64 s[32:33], s[0:1], 0x10
	s_waitcnt lgkmcnt(0)
	s_mov_b32 s47, 1
	s_mov_b32 s48, 0
	s_mov_b32 s49, 0x2200001
	s_mov_b32 s11, 0xc010008
	s_mov_b32 s50, 0x739
	s_mov_b32 s24, 0x1000
	s_mov_b32 s25, s24
	s_mov_b32 s26, 1
	s_mov_b32 s27, s24
	s_mov_b32 s36, s24
	s_mov_b32 s37, 0
	s_mov_b32 s38, s24
	s_mov_b32 s39, 0
	s_mov_b32 s40, s24
	s_mov_b32 s41, 0
	s_mov_b32 s42, s24
	s_mov_b32 s43, 0
	s_mov_b32 s44, 1.0
	s_mov_b32 s45, 0
	s_and_b32 s10, s49, 0xffff0000
	s_lshr_b32 s10, s10, 16
	s_and_b32 s46, s49, 0xffff
	s_mov_b32 s5, s48
	s_mov_b32 m0, 0x7680
	v_mov_b32_e32 v254, v0
	s_mov_b32 vcc_hi, 0
	s_lshr_b32 s56, s11, 16
	s_ctz_i32_b32 s56, s56
	s_lshr_b32 s57, s11, 22
	s_cmp_gt_i32 s56, 0
	v_and_b32_e32 v1, 31, v254
	v_and_b32_e32 v0, 15, v1
	v_lshrrev_b32_e32 v4, 5, v254
	v_and_b32_e32 v4, 1, v4
	v_lshl_add_u32 v0, v4, 4, v0
	v_and_b32_e32 v2, 31, v254
	v_and_b32_e32 v1, 15, v2
	v_lshlrev_b32_e32 v1, 5, v1
	v_lshrrev_b32_e32 v3, 6, v254
	v_and_b32_e32 v3, 1, v3
	v_lshl_add_u32 v1, v3, 9, v1
	v_lshrrev_b32_e32 v2, 5, v254
	v_lshrrev_b32_e32 v2, 2, v2
	s_mov_b32 s49, 0xc00
	v_mul_lo_u32 v2, s49, v2
	v_add_lshl_u32 v80, v2, v0, 1
	v_mov_b32_e32 v4, 0x2aaaab
	v_mul_hi_u32 v5, v80, v4
	v_mul_lo_u32 v4, v80, v4
	v_lshrrev_b64 v[4:5], 33, v[4:5]
	v_mov_b32_e32 v3, v4
	v_lshl_add_u32 v80, v3, 5, v80
	v_lshrrev_b32_e32 v0, 5, v254
	v_lshrrev_b32_e32 v0, 2, v0
	s_mov_b32 s49, 32
	v_mul_lo_u32 v0, s49, v0
	v_add_lshl_u32 v81, v0, v1, 1
	v_lshrrev_b32_e32 v2, 7, v81
	v_lshl_add_u32 v81, v2, 5, v81
	v_add_co_u32 v81, vcc_lo, 0x1880, v81
	v_lshrrev_b32_e32 v1, 2, v254
	v_and_b32_e32 v0, 3, v254
	v_lshlrev_b32_e32 v0, 3, v0
	v_mov_b32_e32 v4, v1
	v_lshrrev_b32_e32 v2, 2, v254
	v_and_b32_e32 v3, 3, v254
	v_lshlrev_b32_e32 v3, 3, v3
	v_mov_b32_e32 v5, v3
	v_mul_u32_u24_e32 v78, 0x60, v4
	v_add_lshl_u32 v78, v0, v78, 1
	v_mov_b32_e32 v6, 0x2aaaab
	v_mul_hi_u32 v7, v78, v6
	v_mul_lo_u32 v6, v78, v6
	v_lshrrev_b64 v[6:7], 33, v[6:7]
	v_mov_b32_e32 v6, v6
	v_lshl_add_u32 v78, v6, 5, v78
	v_mul_u32_u24_e32 v79, 32, v2
	v_add_lshl_u32 v79, v5, v79, 1
	v_lshrrev_b32_e32 v6, 7, v79
	v_lshl_add_u32 v79, v6, 5, v79
	v_add_co_u32 v79, vcc_lo, 0x1880, v79
	s_waitcnt lgkmcnt(0)
	v_mov_b32_e32 v8, 0x60
	v_mov_b32_e32 v7, s24
	v_cvt_f32_u32_e32 v6, v8
	v_rcp_iflag_f32_e32 v6, v6
	v_cvt_f32_u32_e32 v9, v7
	v_mul_f32_e32 v6, v6, v9
	v_cvt_u32_f32_e32 v6, v6
	v_mul_u32_u24_e32 v9, v6, v8
	v_sub_nc_u32_e32 v9, v7, v9
	v_cmp_ne_u32_e64 vcc_lo, v9, 0
	v_add_co_ci_u32_e64 v6, vcc_lo, v6, 0, vcc_lo
	v_mov_b32_e32 v8, 0x60
	v_mov_b32_e32 v7, s25
	v_readfirstlane_b32 s14, v6
	v_cvt_f32_u32_e32 v6, v8
	v_rcp_iflag_f32_e32 v6, v6
	v_cvt_f32_u32_e32 v9, v7
	v_mul_f32_e32 v6, v6, v9
	v_cvt_u32_f32_e32 v6, v6
	v_mul_u32_u24_e32 v9, v6, v8
	v_sub_nc_u32_e32 v9, v7, v9
	v_cmp_ne_u32_e64 vcc_lo, v9, 0
	v_add_co_ci_u32_e64 v6, vcc_lo, v6, 0, vcc_lo
	v_readfirstlane_b32 s15, v6
	s_mul_i32 s48, s14, s15
	s_and_b32 s49, s46, 0x3fff
	s_mul_i32 s48, s48, s49
	v_cvt_f32_u32_e32 v6, s48
	v_rcp_iflag_f32_e32 v6, v6
	v_cvt_f32_u32_e32 v7, s2
	v_mul_f32_e32 v6, v6, v7
	v_cvt_u32_f32_e32 v6, v6
	v_mul_u32_u24_e64 v7, v6, s48
	v_sub_nc_u32_e32 v7, s2, v7
	v_cmp_eq_u32_e64 vcc_lo, v7, s48
	s_mov_b32 exec_lo, vcc_lo
	v_add_nc_u32_e32 v6, 1, v6
	s_mov_b32 exec_lo, -1
	v_cmp_gt_u32_e64 vcc_lo, v7, s48
	s_mov_b32 exec_lo, vcc_lo
	v_sub_nc_u32_e64 v6, v6, 1
	s_mov_b32 exec_lo, -1
	v_readfirstlane_b32 s48, v6
	s_mov_b32 s4, s48
	s_mul_i32 s48, s15, s14
	s_mul_i32 s48, s48, s4
	s_mul_i32 s48, s48, s49
	s_sub_u32 s2, s2, s48
	v_cvt_f32_u32_e32 v6, s14
	v_rcp_iflag_f32_e32 v6, v6
	v_cvt_f32_u32_e32 v7, s2
	v_mul_f32_e32 v6, v6, v7
	v_cvt_u32_f32_e32 v6, v6
	v_mul_u32_u24_e64 v7, v6, s14
	v_sub_nc_u32_e32 v7, s2, v7
	v_cmp_eq_u32_e64 vcc_lo, v7, s14
	s_mov_b32 exec_lo, vcc_lo
	v_add_nc_u32_e32 v6, 1, v6
	s_mov_b32 exec_lo, -1
	v_cmp_gt_u32_e64 vcc_lo, v7, s14
	s_mov_b32 exec_lo, vcc_lo
	v_sub_nc_u32_e64 v6, v6, 1
	s_mov_b32 exec_lo, -1
	v_readfirstlane_b32 s48, v6
	s_mov_b32 s3, s48
	s_mul_i32 s48, s3, s14
	s_sub_u32 s2, s2, s48

label_NoEarlyStop_wgExceed:  // trace [154:351]
	s_sub_u32 s32, s32, 16
	s_subb_u32 s33, s33, 0
	s_sub_u32 s34, s34, 16
	s_subb_u32 s35, s35, 0
	s_mov_b64 s[6:7], 0
	s_mov_b32 s8, 1
	s_mov_b32 s9, 1
	s_sext_i32_i16 s11, s11
	s_mov_b32 s11, s11
	v_cvt_f32_u32_e32 v6, s11
	v_rcp_iflag_f32_e32 v6, v6
	v_cvt_f32_u32_e32 v7, s3
	v_mul_f32_e32 v6, v6, v7
	v_cvt_u32_f32_e32 v6, v6
	v_mul_u32_u24_e64 v7, v6, s11
	v_sub_nc_u32_e32 v7, s3, v7
	v_cmp_eq_u32_e64 vcc_lo, v7, s11
	s_mov_b32 exec_lo, vcc_lo
	v_add_nc_u32_e32 v6, 1, v6
	s_mov_b32 exec_lo, -1
	v_cmp_gt_u32_e64 vcc_lo, v7, s11
	s_mov_b32 exec_lo, vcc_lo
	v_sub_nc_u32_e64 v6, v6, 1
	s_mov_b32 exec_lo, -1
	v_readfirstlane_b32 s68, v6
	s_mul_i32 s69, s68, s11
	s_sub_u32 s69, s3, s69
	s_mul_i32 s69, s69, s14
	s_add_u32 s69, s69, s2
	v_cvt_f32_u32_e32 v6, s11
	v_rcp_iflag_f32_e32 v6, v6
	v_cvt_f32_u32_e32 v7, s15
	v_mul_f32_e32 v6, v6, v7
	v_cvt_u32_f32_e32 v6, v6
	v_mul_u32_u24_e64 v7, v6, s11
	v_sub_nc_u32_e32 v7, s15, v7
	v_cmp_eq_u32_e64 vcc_lo, v7, s11
	s_mov_b32 exec_lo, vcc_lo
	v_add_nc_u32_e32 v6, 1, v6
	s_mov_b32 exec_lo, -1
	v_cmp_gt_u32_e64 vcc_lo, v7, s11
	s_mov_b32 exec_lo, vcc_lo
	v_sub_nc_u32_e64 v6, v6, 1
	s_mov_b32 exec_lo, -1
	v_readfirstlane_b32 s66, v6
	s_mul_i32 s67, s11, s66
	s_sub_u32 s67, s15, s67
	s_cmp_eq_u32 s67, 0
	s_cmov_b32 s67, s11
	s_cmp_ge_u32 s68, s66
	s_cselect_b32 s66, s67, s11
	v_cvt_f32_u32_e32 v6, s66
	v_rcp_iflag_f32_e32 v6, v6
	v_cvt_f32_u32_e32 v7, s69
	v_mul_f32_e32 v6, v6, v7
	v_cvt_u32_f32_e32 v6, v6
	v_mul_u32_u24_e64 v7, v6, s66
	v_sub_nc_u32_e32 v7, s69, v7
	v_cmp_eq_u32_e64 vcc_lo, v7, s66
	s_mov_b32 exec_lo, vcc_lo
	v_add_nc_u32_e32 v6, 1, v6
	v_mov_b32_e32 v7, 0
	s_mov_b32 exec_lo, -1
	v_cmp_gt_u32_e64 vcc_lo, v7, s66
	s_mov_b32 exec_lo, vcc_lo
	v_sub_nc_u32_e64 v6, v6, 1
	v_mul_u32_u24_e64 v7, v6, s66
	v_sub_nc_u32_e32 v7, s69, v7
	s_mov_b32 exec_lo, -1
	v_readfirstlane_b32 s2, v6
	v_readfirstlane_b32 s3, v7
	s_mul_i32 s3, s2, s66
	s_sub_u32 s3, s69, s3
	s_mul_i32 s68, s68, s11
	s_add_u32 s3, s3, s68
	v_mov_b32_e32 v6, v0
	v_add_co_u32 v7, vcc_lo, 32, v6
	v_add_co_u32 v8, vcc_lo, 32, v7
	v_mov_b32_e32 v9, v2
	v_add_co_u32 v10, vcc_lo, 32, v9
	v_add_co_u32 v11, vcc_lo, 32, v10
	v_mov_b32_e32 v12, v1
	v_mov_b32_e32 v13, v3
	s_mul_i32 s66, s2, 0x60
	s_sub_u32 s66, s24, s66
	s_sub_u32 s66, s66, 8
	v_mov_b32_e32 v14, s66
	v_min_i32_e32 v6, v14, v6
	v_min_i32_e32 v7, v14, v7
	v_min_i32_e32 v8, v14, v8
	v_mul_lo_u32 v14, s40, v12
	v_add_co_u32 v72, vcc_lo, v6, v14
	v_add_nc_u32_e32 v72, 8, v72
	v_lshlrev_b32_e32 v72, 1, v72
	v_mul_lo_u32 v14, s40, v12
	v_add_co_u32 v73, vcc_lo, v7, v14
	v_add_nc_u32_e32 v73, 8, v73
	v_lshlrev_b32_e32 v73, 1, v73
	v_mul_lo_u32 v14, s40, v12
	v_add_co_u32 v74, vcc_lo, v8, v14
	v_add_nc_u32_e32 v74, 8, v74
	v_lshlrev_b32_e32 v74, 1, v74
	v_mul_lo_u32 v6, s42, v9
	v_add_co_u32 v75, vcc_lo, v13, v6
	v_add_nc_u32_e32 v75, 8, v75
	v_lshlrev_b32_e32 v75, 1, v75
	v_mul_lo_u32 v6, s42, v10
	v_add_co_u32 v76, vcc_lo, v13, v6
	v_add_nc_u32_e32 v76, 8, v76
	v_lshlrev_b32_e32 v76, 1, v76
	v_mul_lo_u32 v6, s42, v11
	v_add_co_u32 v77, vcc_lo, v13, v6
	v_add_nc_u32_e32 v77, 8, v77
	v_lshlrev_b32_e32 v77, 1, v77
	s_mul_hi_u32 s69, s2, 0x60
	s_mul_i32 s68, s2, 0x60
	s_mul_hi_u32 s67, 32, s6
	s_mul_i32 s66, 32, s6
	s_mul_hi_u32 s67, s66, s40
	s_mul_i32 s66, s66, s40
	s_add_u32 s68, s68, s66
	s_addc_u32 s69, s69, s67
	s_mov_b64 s[56:57], 1
	s_sub_u32 s66, s24, 1
	s_mul_hi_u32 s67, 1, s66
	s_mul_i32 s66, 1, s66
	s_add_u32 s56, s56, s66
	s_addc_u32 s57, s57, s67
	s_sub_u32 s66, s27, 1
	s_mul_hi_u32 s67, s40, s66
	s_mul_i32 s66, s40, s66
	s_add_u32 s56, s56, s66
	s_addc_u32 s57, s57, s67
	s_sub_u32 s56, s56, s68
	s_subb_u32 s57, s57, s69
	s_lshl_b64 s[56:57], s[56:57], 1
	s_add_u32 s56, s56, 16
	s_addc_u32 s57, s57, 0
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_mul_hi_u32 s67, s41, s4
	s_mul_i32 s66, s41, s4
	s_add_u32 s68, s68, s66
	s_addc_u32 s69, s69, s67
	s_lshl_b64 s[68:69], s[68:69], 1
	s_add_u32 s48, s32, s68
	s_addc_u32 s49, s33, s69
	s_mov_b32 s51, 0x31004000
	s_mul_hi_u32 s69, s3, 0x60
	s_mul_i32 s68, s3, 0x60
	s_mul_hi_u32 s69, s68, s42
	s_mul_i32 s68, s68, s42
	s_mul_hi_u32 s67, 32, s6
	s_mul_i32 s66, 32, s6
	s_add_u32 s68, s68, s66
	s_addc_u32 s69, s69, s67
	s_mov_b64 s[58:59], 1
	s_sub_u32 s66, s27, 1
	s_mul_hi_u32 s67, 1, s66
	s_mul_i32 s66, 1, s66
	s_add_u32 s58, s58, s66
	s_addc_u32 s59, s59, s67
	s_sub_u32 s66, s25, 1
	s_mul_hi_u32 s67, s42, s66
	s_mul_i32 s66, s42, s66
	s_add_u32 s58, s58, s66
	s_addc_u32 s59, s59, s67
	s_sub_u32 s58, s58, s68
	s_subb_u32 s59, s59, s69
	s_lshl_b64 s[58:59], s[58:59], 1
	s_add_u32 s58, s58, 16
	s_addc_u32 s59, s59, 0
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_mul_hi_u32 s67, s43, s4
	s_mul_i32 s66, s43, s4
	s_add_u32 s68, s68, s66
	s_addc_u32 s69, s69, s67
	s_lshl_b64 s[68:69], s[68:69], 1
	s_add_u32 s52, s34, s68
	s_addc_u32 s53, s35, s69
	s_mov_b32 s55, 0x31004000
	s_and_b32 s67, s46, 0x3fff
	s_mul_i32 s67, s67, 64
	s_and_b32 s66, s46, 0x8000
	s_cmov_b32 s67, 64
	s_mul_i32 s64, s67, s40
	s_and_b32 s67, s46, 0x3fff
	s_mul_i32 s67, s67, 64
	s_and_b32 s66, s46, 0x8000
	s_cselect_b32 s65, 64, s67
	s_lshr_b32 s12, s27, 5
	s_mov_b32 s13, s12
	s_and_b32 s68, s10, 0x1f00
	s_lshr_b32 s68, s68, 8
	s_and_b32 s69, s10, 0xe000
	s_and_b32 s10, s10, 0xff
	s_mov_b32 s66, s10

label_beginStaggerUIter:  // trace [352:353]
	s_lshl_b32 s67, s66, s68
	s_cmp_ge_u32 s13, s67
	// s_cbranch_scc1 label_endStaggerUIter
	// -> branch TAKEN to label_endStaggerUIter

label_endStaggerUIter:  // trace [354:357]
	s_sub_u32 s67, s66, 1
	s_cmp_ge_u32 s66, 1
	s_cselect_b32 s47, s67, 0
	s_cmp_eq_u32 s69, 0
	// s_cbranch_scc1 label_StaggerUMapping_1
	// -> branch TAKEN to label_StaggerUMapping_1

label_StaggerUMapping_1:  // trace [358:358]
	s_cmp_eq_u32 s69, 0x2000
	// s_cbranch_scc1 label_StaggerUMapping_2
	// -> branch NOT TAKEN (fell through)

_fallthrough_7:  // trace [359:359]
	s_mov_b32 s66, s3
	// s_branch label_staggerInputEnd
	// -> branch TAKEN to label_staggerInputEnd

label_staggerInputEnd:  // trace [360:387]
	s_and_b32 s47, s47, s66
	s_lshl_b32 s47, s47, s68
	s_mul_hi_i32 s67, s47, s64
	s_mul_i32 s66, s47, s64
	s_mul_hi_i32 s61, s12, s64
	s_mul_i32 s60, s12, s64
	s_sub_u32 s60, s64, s60
	s_subb_u32 s61, 0, s61
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_mul_hi_i32 s67, s47, s65
	s_mul_i32 s66, s47, s65
	s_mul_hi_i32 s63, s12, s65
	s_mul_i32 s62, s12, s65
	s_sub_u32 s62, s65, s62
	s_subb_u32 s63, 0, s63
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_add_u32 s47, s47, 2
	s_cmp_eq_u32 s12, 0
	// s_cbranch_scc1 label_ShadowInitStart
	// -> branch NOT TAKEN (fell through)

_fallthrough_15:  // trace [388:413]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	s_add_u32 s68, s12, 1
	s_cmp_eq_u32 s47, s68
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_add_u32 s68, s12, 1
	s_cmp_eq_u32 s47, s68
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1

label_ShadowInitStart:  // trace [414:513]
	s_mov_b64 s[16:17], s[28:29]
	s_mov_b32 s18, 0x80000000
	s_mov_b32 s19, 0x31004000
	s_mov_b64 s[20:21], s[30:31]
	s_mov_b32 s22, 0x80000000
	s_mov_b32 s23, 0x31004000
	s_mul_i32 s68, 0x60, s3
	s_mul_hi_u32 s67, s68, s38
	s_mul_i32 s66, s68, s38
	s_lshl_b64 s[66:67], s[66:67], s8
	s_add_u32 s20, s30, s66
	s_addc_u32 s21, s31, s67
	s_mul_hi_u32 s67, s68, s36
	s_mul_i32 s66, s68, s36
	s_lshl_b64 s[66:67], s[66:67], s9
	s_add_u32 s16, s28, s66
	s_addc_u32 s17, s29, s67
	s_mul_hi_u32 s67, s4, s39
	s_mul_i32 s66, s4, s39
	s_lshl_b64 s[66:67], s[66:67], s8
	s_add_u32 s20, s20, s66
	s_addc_u32 s21, s21, s67
	s_mul_hi_u32 s67, s4, s37
	s_mul_i32 s66, s4, s37
	s_lshl_b64 s[66:67], s[66:67], s9
	s_add_u32 s16, s16, s66
	s_addc_u32 s17, s17, s67
	v_mov_b32_e32 v0, 0
	v_mov_b32_e32 v1, 0
	v_mov_b32_e32 v2, 0
	v_mov_b32_e32 v3, 0
	v_mov_b32_e32 v4, 0
	v_mov_b32_e32 v5, 0
	v_mov_b32_e32 v6, 0
	v_mov_b32_e32 v7, 0
	v_mov_b32_e32 v8, 0
	v_mov_b32_e32 v9, 0
	v_mov_b32_e32 v10, 0
	v_mov_b32_e32 v11, 0
	v_mov_b32_e32 v12, 0
	v_mov_b32_e32 v13, 0
	v_mov_b32_e32 v14, 0
	v_mov_b32_e32 v15, 0
	v_mov_b32_e32 v16, 0
	v_mov_b32_e32 v17, 0
	v_mov_b32_e32 v18, 0
	v_mov_b32_e32 v19, 0
	v_mov_b32_e32 v20, 0
	v_mov_b32_e32 v21, 0
	v_mov_b32_e32 v22, 0
	v_mov_b32_e32 v23, 0
	v_mov_b32_e32 v24, 0
	v_mov_b32_e32 v25, 0
	v_mov_b32_e32 v26, 0
	v_mov_b32_e32 v27, 0
	v_mov_b32_e32 v28, 0
	v_mov_b32_e32 v29, 0
	v_mov_b32_e32 v30, 0
	v_mov_b32_e32 v31, 0
	v_mov_b32_e32 v32, 0
	v_mov_b32_e32 v33, 0
	v_mov_b32_e32 v34, 0
	v_mov_b32_e32 v35, 0
	v_mov_b32_e32 v36, 0
	v_mov_b32_e32 v37, 0
	v_mov_b32_e32 v38, 0
	v_mov_b32_e32 v39, 0
	v_mov_b32_e32 v40, 0
	v_mov_b32_e32 v41, 0
	v_mov_b32_e32 v42, 0
	v_mov_b32_e32 v43, 0
	v_mov_b32_e32 v44, 0
	v_mov_b32_e32 v45, 0
	v_mov_b32_e32 v46, 0
	v_mov_b32_e32 v47, 0
	v_mov_b32_e32 v48, 0
	v_mov_b32_e32 v49, 0
	v_mov_b32_e32 v50, 0
	v_mov_b32_e32 v51, 0
	v_mov_b32_e32 v52, 0
	v_mov_b32_e32 v53, 0
	v_mov_b32_e32 v54, 0
	v_mov_b32_e32 v55, 0
	v_mov_b32_e32 v56, 0
	v_mov_b32_e32 v57, 0
	v_mov_b32_e32 v58, 0
	v_mov_b32_e32 v59, 0
	v_mov_b32_e32 v60, 0
	v_mov_b32_e32 v61, 0
	v_mov_b32_e32 v62, 0
	v_mov_b32_e32 v63, 0
	v_mov_b32_e32 v64, 0
	v_mov_b32_e32 v65, 0
	v_mov_b32_e32 v66, 0
	v_mov_b32_e32 v67, 0
	v_mov_b32_e32 v68, 0
	v_mov_b32_e32 v69, 0
	v_mov_b32_e32 v70, 0
	v_mov_b32_e32 v71, 0
	s_cmp_eq_u32 s12, 0
	// s_cbranch_scc0 label_NoBranch_2N9UHJ18GAG2UJZG
	// -> branch TAKEN to label_NoBranch_2N9UHJ18GAG2UJZG

label_NoBranch_2N9UHJ18GAG2UJZG:  // trace [514:523]
	s_waitcnt vmcnt(0)
	ds_store_b128 v78, v[230:233]
	ds_store_b128 v78, v[234:237] offset:64
	ds_store_b128 v78, v[238:241] offset:128
	ds_store_b128 v79, v[242:245]
	ds_store_b128 v79, v[246:249] offset:2560
	ds_store_b128 v79, v[250:253] offset:5120
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	s_cmp_eq_u32 s12, 1
	// s_cbranch_scc1 label_skipPGR2
	// -> branch NOT TAKEN (fell through)

_fallthrough_19:  // trace [524:529]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen

label_skipPGR2:  // trace [530:586]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136

label_openLoopL:  // trace [587:587]
	s_cmp_eq_u32 s12, 1
	// s_cbranch_scc1 label_toPGR1
	// -> branch NOT TAKEN (fell through)

_fallthrough_22:  // trace [588:588]
	s_cmp_le_u32 s12, 2
	// s_cbranch_scc1 label_LoopEndL
	// -> branch NOT TAKEN (fell through)

label_LoopBeginL:  // trace [589:762]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter2:  // trace [763:936]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter3:  // trace [937:1110]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter4:  // trace [1111:1284]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter5:  // trace [1285:1458]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter6:  // trace [1459:1632]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter7:  // trace [1633:1806]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter8:  // trace [1807:1980]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter9:  // trace [1981:2154]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter10:  // trace [2155:2328]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter11:  // trace [2329:2502]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter12:  // trace [2503:2676]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter13:  // trace [2677:2850]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter14:  // trace [2851:3024]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter15:  // trace [3025:3198]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter16:  // trace [3199:3372]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter17:  // trace [3373:3546]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter18:  // trace [3547:3720]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter19:  // trace [3721:3894]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter20:  // trace [3895:4068]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter21:  // trace [4069:4242]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter22:  // trace [4243:4416]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter23:  // trace [4417:4590]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter24:  // trace [4591:4764]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter25:  // trace [4765:4938]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter26:  // trace [4939:5112]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter27:  // trace [5113:5286]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter28:  // trace [5287:5460]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter29:  // trace [5461:5634]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter30:  // trace [5635:5808]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter31:  // trace [5809:5982]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter32:  // trace [5983:6156]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter33:  // trace [6157:6330]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter34:  // trace [6331:6504]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter35:  // trace [6505:6678]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter36:  // trace [6679:6852]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter37:  // trace [6853:7026]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter38:  // trace [7027:7200]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter39:  // trace [7201:7374]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter40:  // trace [7375:7548]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter41:  // trace [7549:7722]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter42:  // trace [7723:7896]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter43:  // trace [7897:8070]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter44:  // trace [8071:8244]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter45:  // trace [8245:8418]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter46:  // trace [8419:8592]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter47:  // trace [8593:8766]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter48:  // trace [8767:8940]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter49:  // trace [8941:9114]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter50:  // trace [9115:9288]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter51:  // trace [9289:9462]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter52:  // trace [9463:9636]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter53:  // trace [9637:9810]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter54:  // trace [9811:9984]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter55:  // trace [9985:10158]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter56:  // trace [10159:10332]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter57:  // trace [10333:10506]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter58:  // trace [10507:10680]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter59:  // trace [10681:10854]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter60:  // trace [10855:11028]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter61:  // trace [11029:11202]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter62:  // trace [11203:11376]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter63:  // trace [11377:11550]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter64:  // trace [11551:11724]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter65:  // trace [11725:11898]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter66:  // trace [11899:12072]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter67:  // trace [12073:12246]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter68:  // trace [12247:12420]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter69:  // trace [12421:12594]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter70:  // trace [12595:12768]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter71:  // trace [12769:12942]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter72:  // trace [12943:13116]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter73:  // trace [13117:13290]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter74:  // trace [13291:13464]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter75:  // trace [13465:13638]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter76:  // trace [13639:13812]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter77:  // trace [13813:13986]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter78:  // trace [13987:14160]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter79:  // trace [14161:14334]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter80:  // trace [14335:14508]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter81:  // trace [14509:14682]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter82:  // trace [14683:14856]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter83:  // trace [14857:15030]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter84:  // trace [15031:15204]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter85:  // trace [15205:15378]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter86:  // trace [15379:15552]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter87:  // trace [15553:15726]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter88:  // trace [15727:15900]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter89:  // trace [15901:16074]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter90:  // trace [16075:16248]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter91:  // trace [16249:16422]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter92:  // trace [16423:16596]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter93:  // trace [16597:16770]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter94:  // trace [16771:16944]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter95:  // trace [16945:17118]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter96:  // trace [17119:17292]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter97:  // trace [17293:17466]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter98:  // trace [17467:17640]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter99:  // trace [17641:17814]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter100:  // trace [17815:17988]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter101:  // trace [17989:18162]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter102:  // trace [18163:18336]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter103:  // trace [18337:18510]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter104:  // trace [18511:18684]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter105:  // trace [18685:18858]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter106:  // trace [18859:19032]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter107:  // trace [19033:19206]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter108:  // trace [19207:19380]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter109:  // trace [19381:19554]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter110:  // trace [19555:19728]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter111:  // trace [19729:19902]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter112:  // trace [19903:20076]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter113:  // trace [20077:20250]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter114:  // trace [20251:20424]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter115:  // trace [20425:20598]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter116:  // trace [20599:20772]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter117:  // trace [20773:20946]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter118:  // trace [20947:21120]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter119:  // trace [21121:21294]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter120:  // trace [21295:21468]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter121:  // trace [21469:21642]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter122:  // trace [21643:21816]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter123:  // trace [21817:21990]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter124:  // trace [21991:22164]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter125:  // trace [22165:22338]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch TAKEN to label_LoopBeginL

label_LoopBeginL_iter126:  // trace [22339:22512]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[234:237] offset:64
	buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[238:241] offset:128
	buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[242:245]
	buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[246:249] offset:2560
	buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
	s_waitcnt vmcnt(5)
	ds_store_b128 v79, v[250:253] offset:5120
	buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_sub_u32 s12, s12, 1
	s_cmp_eq_i32 s12, 2
	// s_cbranch_scc0 label_LoopBeginL
	// -> branch NOT TAKEN (fell through)

label_LoopEndL:  // trace [22513:22678]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s60, s64
	s_cselect_b32 s67, s61, 0
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	s_add_u32 s48, s48, s66
	s_addc_u32 s49, s49, s67
	s_sub_u32 s56, s56, s66
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_subb_u32 s57, s57, s67
	s_cmp_eq_u32 s57, 0
	s_cselect_b32 s50, s56, -1
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	s_cmp_eq_u32 s12, s47
	s_cselect_b32 s66, s62, s65
	s_cselect_b32 s67, s63, 0
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	s_add_u32 s52, s52, s66
	s_addc_u32 s53, s53, s67
	s_sub_u32 s58, s58, s66
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	s_subb_u32 s59, s59, s67
	s_cmp_eq_u32 s59, 0
	s_cselect_b32 s54, s58, -1
	s_waitcnt vmcnt(5)
	ds_store_b128 v78, v[230:233]
	s_waitcnt vmcnt(4)
	ds_store_b128 v78, v[234:237] offset:64
	s_waitcnt vmcnt(3)
	ds_store_b128 v78, v[238:241] offset:128
	s_waitcnt vmcnt(2)
	ds_store_b128 v79, v[242:245]
	s_waitcnt vmcnt(1)
	ds_store_b128 v79, v[246:249] offset:2560
	s_waitcnt vmcnt(0)
	ds_store_b128 v79, v[250:253] offset:5120
	v_xor_b32_e32 v78, 0x4000, v78
	v_xor_b32_e32 v79, 0x4000, v79
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_xor_b32_e32 v80, 0x4000, v80
	v_xor_b32_e32 v81, 0x4000, v81
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	ds_load_u16 v84, v80
	ds_load_u16_d16_hi v84, v80 offset:192
	ds_load_u16 v85, v80 offset:384
	ds_load_u16_d16_hi v85, v80 offset:576
	ds_load_u16 v86, v80 offset:768
	ds_load_u16_d16_hi v86, v80 offset:960
	ds_load_u16 v87, v80 offset:1152
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	ds_load_u16_d16_hi v87, v80 offset:1344
	ds_load_u16 v88, v80 offset:1536
	ds_load_u16_d16_hi v88, v80 offset:1728
	ds_load_u16 v89, v80 offset:1920
	ds_load_u16_d16_hi v89, v80 offset:2112
	ds_load_u16 v90, v80 offset:2304
	ds_load_u16_d16_hi v90, v80 offset:2496
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	ds_load_u16 v91, v80 offset:2688
	ds_load_u16_d16_hi v91, v80 offset:2880
	ds_load_b128 v[181:184], v81
	ds_load_b128 v[185:188], v81 offset:16
	ds_load_u16 v92, v80 offset:64
	ds_load_u16_d16_hi v92, v80 offset:256
	ds_load_u16 v93, v80 offset:448
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	ds_load_u16_d16_hi v93, v80 offset:640
	ds_load_u16 v94, v80 offset:832
	ds_load_u16_d16_hi v94, v80 offset:1024
	ds_load_u16 v95, v80 offset:1216
	ds_load_u16_d16_hi v95, v80 offset:1408
	ds_load_u16 v96, v80 offset:1600
	ds_load_u16_d16_hi v96, v80 offset:1792
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	ds_load_u16 v97, v80 offset:1984
	ds_load_u16_d16_hi v97, v80 offset:2176
	ds_load_u16 v98, v80 offset:2368
	ds_load_u16_d16_hi v98, v80 offset:2560
	ds_load_u16 v99, v80 offset:2752
	ds_load_u16_d16_hi v99, v80 offset:2944
	ds_load_u16 v100, v80 offset:128
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	ds_load_u16_d16_hi v100, v80 offset:320
	ds_load_u16 v101, v80 offset:512
	ds_load_u16_d16_hi v101, v80 offset:704
	ds_load_u16 v102, v80 offset:896
	ds_load_u16_d16_hi v102, v80 offset:1088
	ds_load_u16 v103, v80 offset:1280
	ds_load_u16_d16_hi v103, v80 offset:1472
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	ds_load_u16 v104, v80 offset:1664
	ds_load_u16_d16_hi v104, v80 offset:1856
	ds_load_u16 v105, v80 offset:2048
	ds_load_u16_d16_hi v105, v80 offset:2240
	ds_load_u16 v106, v80 offset:2432
	ds_load_u16_d16_hi v106, v80 offset:2624
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	ds_load_u16 v107, v80 offset:2816
	ds_load_u16_d16_hi v107, v80 offset:3008
	ds_load_b128 v[189:192], v81 offset:2560
	ds_load_b128 v[193:196], v81 offset:2576
	ds_load_b128 v[197:200], v81 offset:5120
	ds_load_b128 v[201:204], v81 offset:5136
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]

label_toPGR1:  // trace [22679:22680]
	s_and_b32 s8, s46, 0x3fff
	s_cmp_eq_u32 s8, 1
	// s_cbranch_scc0 label_GSU_3
	// -> branch NOT TAKEN (fell through)

_fallthrough_26:  // trace [22681:22681]
	s_cmpk_eq_u32 s45, 0x0
	// s_cbranch_scc0 label_GSU_3
	// -> branch NOT TAKEN (fell through)

_fallthrough_27:  // trace [22682:22682]
	s_cmp_eq_u32 s44, 1.0
	// s_cbranch_scc0 label_GSU_3
	// -> branch NOT TAKEN (fell through)

_fallthrough_28:  // trace [22683:22696]
	s_mov_b32 s69, 0
	s_mul_i32 s68, 0x555, s24
	s_lshl_b64 s[68:69], s[68:69], 16
	s_mul_i32 s67, s24, 0x5556
	s_add_u32 s68, s67, s68
	s_addc_u32 s69, s69, 0
	s_lshr_b64 s[68:69], s[68:69], 33
	s_mov_b32 s67, s68
	s_mul_i32 s68, s67, 0x60
	s_sub_u32 s66, s24, s68
	s_add_u32 s67, -1, s14
	s_cmp_ge_u32 s2, s67
	s_cselect_b32 s66, s66, 0
	s_cmpk_gt_u32 s66, 0x0
	// s_cbranch_scc1 label_GSU_3
	// -> branch NOT TAKEN (fell through)

_fallthrough_29:  // trace [22697:22710]
	s_mov_b32 s69, 0
	s_mul_i32 s68, 0x555, s25
	s_lshl_b64 s[68:69], s[68:69], 16
	s_mul_i32 s67, s25, 0x5556
	s_add_u32 s68, s67, s68
	s_addc_u32 s69, s69, 0
	s_lshr_b64 s[68:69], s[68:69], 33
	s_mov_b32 s67, s68
	s_mul_i32 s68, s67, 0x60
	s_sub_u32 s66, s25, s68
	s_add_u32 s67, -1, s15
	s_cmp_ge_u32 s3, s67
	s_cselect_b32 s66, s66, 0
	s_cmpk_gt_u32 s66, 0x0
	// s_cbranch_scc1 label_GSU_3
	// -> branch NOT TAKEN (fell through)

_fallthrough_30:  // trace [22711:22712]
	s_and_b32 s67, 31, s27
	s_cmp_eq_u32 s67, 0
	// s_cbranch_scc0 label_GSU_3
	// -> branch TAKEN to label_GSU_3

_fallthrough_31:  // trace [22713:22788]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_f16 v[0:7], v[181:188], v[84:91], v[0:7]
	ds_load_u16 v108, v80 offset:3104
	ds_load_u16_d16_hi v108, v80 offset:3296
	ds_load_u16 v109, v80 offset:3488
	ds_load_u16_d16_hi v109, v80 offset:3680
	ds_load_u16 v110, v80 offset:3872
	ds_load_u16_d16_hi v110, v80 offset:4064
	ds_load_u16 v111, v80 offset:4256
	v_wmma_f32_16x16x16_f16 v[8:15], v[181:188], v[92:99], v[8:15]
	ds_load_u16_d16_hi v111, v80 offset:4448
	ds_load_u16 v112, v80 offset:4640
	ds_load_u16_d16_hi v112, v80 offset:4832
	ds_load_u16 v113, v80 offset:5024
	ds_load_u16_d16_hi v113, v80 offset:5216
	ds_load_u16 v114, v80 offset:5408
	ds_load_u16_d16_hi v114, v80 offset:5600
	v_wmma_f32_16x16x16_f16 v[16:23], v[181:188], v[100:107], v[16:23]
	ds_load_u16 v115, v80 offset:5792
	ds_load_u16_d16_hi v115, v80 offset:5984
	ds_load_b128 v[205:208], v81 offset:32
	ds_load_b128 v[209:212], v81 offset:48
	ds_load_u16 v116, v80 offset:3168
	ds_load_u16_d16_hi v116, v80 offset:3360
	ds_load_u16 v117, v80 offset:3552
	s_waitcnt lgkmcnt(21)
	v_wmma_f32_16x16x16_f16 v[24:31], v[189:196], v[84:91], v[24:31]
	ds_load_u16_d16_hi v117, v80 offset:3744
	ds_load_u16 v118, v80 offset:3936
	ds_load_u16_d16_hi v118, v80 offset:4128
	ds_load_u16 v119, v80 offset:4320
	ds_load_u16_d16_hi v119, v80 offset:4512
	ds_load_u16 v120, v80 offset:4704
	ds_load_u16_d16_hi v120, v80 offset:4896
	v_wmma_f32_16x16x16_f16 v[32:39], v[189:196], v[92:99], v[32:39]
	ds_load_u16 v121, v80 offset:5088
	ds_load_u16_d16_hi v121, v80 offset:5280
	ds_load_u16 v122, v80 offset:5472
	ds_load_u16_d16_hi v122, v80 offset:5664
	ds_load_u16 v123, v80 offset:5856
	ds_load_u16_d16_hi v123, v80 offset:6048
	ds_load_u16 v124, v80 offset:3232
	v_wmma_f32_16x16x16_f16 v[40:47], v[189:196], v[100:107], v[40:47]
	ds_load_u16_d16_hi v124, v80 offset:3424
	ds_load_u16 v125, v80 offset:3616
	ds_load_u16_d16_hi v125, v80 offset:3808
	ds_load_u16 v126, v80 offset:4000
	ds_load_u16_d16_hi v126, v80 offset:4192
	ds_load_u16 v127, v80 offset:4384
	ds_load_u16_d16_hi v127, v80 offset:4576
	v_wmma_f32_16x16x16_f16 v[48:55], v[197:204], v[84:91], v[48:55]
	ds_load_u16 v128, v80 offset:4768
	ds_load_u16_d16_hi v128, v80 offset:4960
	ds_load_u16 v129, v80 offset:5152
	ds_load_u16_d16_hi v129, v80 offset:5344
	ds_load_u16 v130, v80 offset:5536
	ds_load_u16_d16_hi v130, v80 offset:5728
	v_wmma_f32_16x16x16_f16 v[56:63], v[197:204], v[92:99], v[56:63]
	ds_load_u16 v131, v80 offset:5920
	ds_load_u16_d16_hi v131, v80 offset:6112
	ds_load_b128 v[213:216], v81 offset:2592
	ds_load_b128 v[217:220], v81 offset:2608
	ds_load_b128 v[221:224], v81 offset:5152
	ds_load_b128 v[225:228], v81 offset:5168
	v_wmma_f32_16x16x16_f16 v[64:71], v[197:204], v[100:107], v[64:71]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_f16 v[0:7], v[205:212], v[108:115], v[0:7]
	v_wmma_f32_16x16x16_f16 v[8:15], v[205:212], v[116:123], v[8:15]
	v_wmma_f32_16x16x16_f16 v[16:23], v[205:212], v[124:131], v[16:23]
	v_wmma_f32_16x16x16_f16 v[24:31], v[213:220], v[108:115], v[24:31]
	v_wmma_f32_16x16x16_f16 v[32:39], v[213:220], v[116:123], v[32:39]
	v_wmma_f32_16x16x16_f16 v[40:47], v[213:220], v[124:131], v[40:47]
	v_wmma_f32_16x16x16_f16 v[48:55], v[221:228], v[108:115], v[48:55]
	v_wmma_f32_16x16x16_f16 v[56:63], v[221:228], v[116:123], v[56:63]
	v_wmma_f32_16x16x16_f16 v[64:71], v[221:228], v[124:131], v[64:71]
	s_cmp_eq_u32 s5, 2
	// s_cbranch_scc1 label_LoadExternalEpilogueStruct
	// -> branch NOT TAKEN (fell through)

_fallthrough_32:  // trace [22789:22790]
	s_load_b256 s[48:55], s[0:1], 0x58
	s_load_b32 s56, s[0:1], 0x78
	// s_branch label_LoadExternalEpilogueStructEnd
	// -> branch NOT TAKEN (fell through)
	v_lshrrev_b32_e32 v76, 5, v254  // unmatched @ 22791
	v_lshrrev_b32_e32 v77, 1, v76  // unmatched @ 22792
	v_mul_lo_u32 v77, 16, v77  // unmatched @ 22793
	v_and_b32_e32 v73, 31, v254  // unmatched @ 22794
	v_lshrrev_b32_e32 v73, 4, v73  // unmatched @ 22795
	v_add_lshl_u32 v73, v77, v73, 0  // unmatched @ 22796
	v_mul_lo_u32 v74, v73, s38  // unmatched @ 22797
	v_mul_lo_u32 v75, v73, s36  // unmatched @ 22798
	v_and_b32_e32 v72, 1, v76  // unmatched @ 22799
	v_mul_lo_u32 v72, 16, v72  // unmatched @ 22800
	v_and_b32_e32 v77, 15, v254  // unmatched @ 22801
	v_add_lshl_u32 v72, v77, v72, 0  // unmatched @ 22802
	s_mul_i32 s8, 0x60, s2  // unmatched @ 22803
	v_add_nc_u32_e32 v72, s8, v72  // unmatched @ 22804
	s_mul_i32 s8, 0x60, s3  // unmatched @ 22805
	v_add_nc_u32_e32 v73, s8, v73  // unmatched @ 22806
	s_waitcnt lgkmcnt(0)  // unmatched @ 22807
	s_mov_b64 s[32:33], s[48:49]  // unmatched @ 22808
	s_mov_b32 s35, 0x31004000  // unmatched @ 22809

_fallthrough_136:  // trace [22810:22810]
	s_mov_b32 s34, 0
	// s_branch label_ScaleAlphaVec_1AddrValid_End
	// -> branch NOT TAKEN (fell through)
	s_mul_i32 s34, 4, s34  // unmatched @ 22811
	s_add_u32 s8, s4, 1  // unmatched @ 22812
	s_mul_i32 s8, s53, s8  // unmatched @ 22813
	s_cmp_eq_u32 s8, 0  // unmatched @ 22814
	s_cselect_b32 s8, s24, s8  // unmatched @ 22815
	s_mov_b64 s[40:41], s[50:51]  // unmatched @ 22816
	s_mov_b32 s43, 0x31004000  // unmatched @ 22817

_fallthrough_139:  // trace [22818:22818]
	s_mov_b32 s42, 0
	// s_branch label_Bias_1AddrValid_End
	// -> branch NOT TAKEN (fell through)

_fallthrough_142:  // trace [22819:22837]
	s_mul_i32 s8, 0x60, s2
	v_add_nc_u32_e32 v80, s8, v254
	s_mul_i32 s42, 4, s42
	s_mul_i32 s8, s53, s4
	v_add_nc_u32_e32 v78, s8, v80
	v_lshlrev_b32_e32 v78, 2, v78
	v_lshlrev_b32_e32 v79, 2, v80
	s_mul_i32 s8, 0x60, s3
	v_add_nc_u32_e32 v80, s8, v254
	buffer_load_b32 v76, v78, s[40:43], 0 offen
	buffer_load_b32 v77, v79, s[32:35], 0 offen
	v_lshlrev_b32_e32 v80, 2, v254
	s_barrier
	s_waitcnt vmcnt(1)
	ds_store_b32 v80, v76
	v_cmp_gt_u32_e64 s48, s34, 0
	s_waitcnt vmcnt(0)
	v_cndmask_b32_e64 v77, 1.0, v77, s48
	ds_store_b32 v80, v77 offset:512
	// s_branch label_Load_Bias_End_1
	// -> branch NOT TAKEN (fell through)
	s_add_i32 s8, 0xc7cc, 4  // unmatched @ 22838
	s_add_u32 s12, s12, s8  // unmatched @ 22839
	s_addc_u32 s13, s13, 0  // unmatched @ 22840
	s_mul_i32 s8, 0x60, s2  // unmatched @ 22841
	v_sub_nc_u32_e64 v81, v72, s8  // unmatched @ 22842
	v_lshlrev_b32_e32 v81, 2, v81  // unmatched @ 22843
	s_waitcnt lgkmcnt(0)  // unmatched @ 22844
	s_barrier  // unmatched @ 22845
	ds_load_b32 v138, v81  // unmatched @ 22846
	ds_load_b32 v139, v81 offset:512  // unmatched @ 22847
	ds_load_b32 v140, v81 offset:128  // unmatched @ 22848
	ds_load_b32 v141, v81 offset:640  // unmatched @ 22849
	ds_load_b32 v142, v81 offset:256  // unmatched @ 22850
	ds_load_b32 v143, v81 offset:768  // unmatched @ 22851
	v_add_lshl_u32 v79, v75, v72, 1  // unmatched @ 22852
	v_mov_b32_e32 v82, v0  // unmatched @ 22853
	v_mov_b32_e32 v83, v8  // unmatched @ 22854
	v_mov_b32_e32 v84, v16  // unmatched @ 22855
	v_mov_b32_e32 v85, v1  // unmatched @ 22856
	v_mov_b32_e32 v86, v9  // unmatched @ 22857
	v_mov_b32_e32 v87, v17  // unmatched @ 22858
	v_mov_b32_e32 v88, v2  // unmatched @ 22859
	v_mov_b32_e32 v89, v10  // unmatched @ 22860
	v_mov_b32_e32 v90, v18  // unmatched @ 22861
	v_mov_b32_e32 v91, v3  // unmatched @ 22862
	v_mov_b32_e32 v92, v11  // unmatched @ 22863
	v_mov_b32_e32 v93, v19  // unmatched @ 22864
	v_mov_b32_e32 v94, v4  // unmatched @ 22865
	v_mov_b32_e32 v95, v12  // unmatched @ 22866
	v_mov_b32_e32 v96, v20  // unmatched @ 22867
	v_mov_b32_e32 v97, v5  // unmatched @ 22868
	v_mov_b32_e32 v98, v13  // unmatched @ 22869
	v_mov_b32_e32 v99, v21  // unmatched @ 22870
	v_mov_b32_e32 v100, v6  // unmatched @ 22871
	v_mov_b32_e32 v101, v14  // unmatched @ 22872
	v_mov_b32_e32 v102, v22  // unmatched @ 22873
	v_mov_b32_e32 v103, v7  // unmatched @ 22874
	v_mov_b32_e32 v104, v15  // unmatched @ 22875
	v_mov_b32_e32 v105, v23  // unmatched @ 22876
	v_mov_b32_e32 v106, v24  // unmatched @ 22877
	v_mov_b32_e32 v107, v32  // unmatched @ 22878
	v_mov_b32_e32 v108, v40  // unmatched @ 22879
	v_mov_b32_e32 v109, v25  // unmatched @ 22880
	v_mov_b32_e32 v110, v33  // unmatched @ 22881
	v_mov_b32_e32 v111, v41  // unmatched @ 22882
	v_mov_b32_e32 v112, v26  // unmatched @ 22883
	v_mov_b32_e32 v113, v34  // unmatched @ 22884
	v_mov_b32_e32 v114, v42  // unmatched @ 22885
	v_mov_b32_e32 v115, v27  // unmatched @ 22886
	v_mov_b32_e32 v116, v35  // unmatched @ 22887
	v_mov_b32_e32 v117, v43  // unmatched @ 22888
	v_mov_b32_e32 v118, v28  // unmatched @ 22889
	v_mov_b32_e32 v119, v36  // unmatched @ 22890
	v_mov_b32_e32 v120, v44  // unmatched @ 22891
	v_mov_b32_e32 v121, v29  // unmatched @ 22892
	v_mov_b32_e32 v122, v37  // unmatched @ 22893
	v_mov_b32_e32 v123, v45  // unmatched @ 22894
	v_mov_b32_e32 v124, v30  // unmatched @ 22895
	v_mov_b32_e32 v125, v38  // unmatched @ 22896
	v_mov_b32_e32 v126, v46  // unmatched @ 22897
	v_mov_b32_e32 v127, v31  // unmatched @ 22898
	v_mov_b32_e32 v128, v39  // unmatched @ 22899
	v_mov_b32_e32 v129, v47  // unmatched @ 22900
	v_mov_b32_e32 v130, v48  // unmatched @ 22901
	v_mov_b32_e32 v131, v56  // unmatched @ 22902
	v_mov_b32_e32 v132, v64  // unmatched @ 22903
	v_mov_b32_e32 v133, v49  // unmatched @ 22904
	v_mov_b32_e32 v134, v57  // unmatched @ 22905
	v_mov_b32_e32 v135, v65  // unmatched @ 22906
	v_mov_b32_e32 v136, v50  // unmatched @ 22907
	v_mov_b32_e32 v137, v58  // unmatched @ 22908
	s_waitcnt lgkmcnt(4)  // unmatched @ 22909
	v_mul_f32_e32 v82, v139, v82  // unmatched @ 22910
	v_add_f32_e32 v76, v138, v82  // unmatched @ 22911
	v_mov_b32_e32 v82, v76  // unmatched @ 22912
	v_cvt_f16_f32_e32 v82, v82  // unmatched @ 22913
	buffer_store_b16 v82, v79, s[16:19], 0 offen  // unmatched @ 22914
	s_waitcnt lgkmcnt(2)  // unmatched @ 22915
	v_mul_f32_e32 v83, v141, v83  // unmatched @ 22916
	v_add_f32_e32 v76, v140, v83  // unmatched @ 22917
	v_mov_b32_e32 v83, v76  // unmatched @ 22918
	v_cvt_f16_f32_e32 v83, v83  // unmatched @ 22919
	buffer_store_b16 v83, v79, s[16:19], 0 offen offset:64  // unmatched @ 22920
	s_waitcnt lgkmcnt(0)  // unmatched @ 22921
	v_mul_f32_e32 v84, v143, v84  // unmatched @ 22922
	v_add_f32_e32 v76, v142, v84  // unmatched @ 22923
	v_mov_b32_e32 v84, v76  // unmatched @ 22924
	v_cvt_f16_f32_e32 v84, v84  // unmatched @ 22925
	buffer_store_b16 v84, v79, s[16:19], 0 offen offset:128  // unmatched @ 22926
	v_mul_f32_e32 v85, v139, v85  // unmatched @ 22927
	v_add_f32_e32 v76, v138, v85  // unmatched @ 22928
	v_mov_b32_e32 v85, v76  // unmatched @ 22929
	v_cvt_f16_f32_e32 v85, v85  // unmatched @ 22930
	s_mul_i32 s8, s36, 4  // unmatched @ 22931
	s_add_u32 s16, s16, s8  // unmatched @ 22932
	s_addc_u32 s17, s17, 0  // unmatched @ 22933
	buffer_store_b16 v85, v79, s[16:19], 0 offen  // unmatched @ 22934
	v_mul_f32_e32 v86, v141, v86  // unmatched @ 22935
	v_add_f32_e32 v76, v140, v86  // unmatched @ 22936
	v_mov_b32_e32 v86, v76  // unmatched @ 22937
	v_cvt_f16_f32_e32 v86, v86  // unmatched @ 22938
	buffer_store_b16 v86, v79, s[16:19], 0 offen offset:64  // unmatched @ 22939
	v_mul_f32_e32 v87, v143, v87  // unmatched @ 22940
	v_add_f32_e32 v76, v142, v87  // unmatched @ 22941
	v_mov_b32_e32 v87, v76  // unmatched @ 22942
	v_cvt_f16_f32_e32 v87, v87  // unmatched @ 22943
	buffer_store_b16 v87, v79, s[16:19], 0 offen offset:128  // unmatched @ 22944
	v_mul_f32_e32 v88, v139, v88  // unmatched @ 22945
	v_add_f32_e32 v76, v138, v88  // unmatched @ 22946
	v_mov_b32_e32 v88, v76  // unmatched @ 22947
	v_cvt_f16_f32_e32 v88, v88  // unmatched @ 22948
	s_mul_i32 s8, s36, 4  // unmatched @ 22949
	s_add_u32 s16, s16, s8  // unmatched @ 22950
	s_addc_u32 s17, s17, 0  // unmatched @ 22951
	buffer_store_b16 v88, v79, s[16:19], 0 offen  // unmatched @ 22952
	v_mul_f32_e32 v89, v141, v89  // unmatched @ 22953
	v_add_f32_e32 v76, v140, v89  // unmatched @ 22954
	v_mov_b32_e32 v89, v76  // unmatched @ 22955
	v_cvt_f16_f32_e32 v89, v89  // unmatched @ 22956
	buffer_store_b16 v89, v79, s[16:19], 0 offen offset:64  // unmatched @ 22957
	v_mul_f32_e32 v90, v143, v90  // unmatched @ 22958
	v_add_f32_e32 v76, v142, v90  // unmatched @ 22959
	v_mov_b32_e32 v90, v76  // unmatched @ 22960
	v_cvt_f16_f32_e32 v90, v90  // unmatched @ 22961
	buffer_store_b16 v90, v79, s[16:19], 0 offen offset:128  // unmatched @ 22962
	v_mul_f32_e32 v91, v139, v91  // unmatched @ 22963
	v_add_f32_e32 v76, v138, v91  // unmatched @ 22964
	v_mov_b32_e32 v91, v76  // unmatched @ 22965
	v_cvt_f16_f32_e32 v91, v91  // unmatched @ 22966
	s_mul_i32 s8, s36, 4  // unmatched @ 22967
	s_add_u32 s16, s16, s8  // unmatched @ 22968
	s_addc_u32 s17, s17, 0  // unmatched @ 22969
	buffer_store_b16 v91, v79, s[16:19], 0 offen  // unmatched @ 22970
	v_mul_f32_e32 v92, v141, v92  // unmatched @ 22971
	v_add_f32_e32 v76, v140, v92  // unmatched @ 22972
	v_mov_b32_e32 v92, v76  // unmatched @ 22973
	v_cvt_f16_f32_e32 v92, v92  // unmatched @ 22974
	buffer_store_b16 v92, v79, s[16:19], 0 offen offset:64  // unmatched @ 22975
	v_mul_f32_e32 v93, v143, v93  // unmatched @ 22976
	v_add_f32_e32 v76, v142, v93  // unmatched @ 22977
	v_mov_b32_e32 v93, v76  // unmatched @ 22978
	v_cvt_f16_f32_e32 v93, v93  // unmatched @ 22979
	buffer_store_b16 v93, v79, s[16:19], 0 offen offset:128  // unmatched @ 22980
	v_mul_f32_e32 v94, v139, v94  // unmatched @ 22981
	v_add_f32_e32 v76, v138, v94  // unmatched @ 22982
	v_mov_b32_e32 v94, v76  // unmatched @ 22983
	v_cvt_f16_f32_e32 v94, v94  // unmatched @ 22984
	s_mul_i32 s8, s36, 4  // unmatched @ 22985
	s_add_u32 s16, s16, s8  // unmatched @ 22986
	s_addc_u32 s17, s17, 0  // unmatched @ 22987
	buffer_store_b16 v94, v79, s[16:19], 0 offen  // unmatched @ 22988
	v_mul_f32_e32 v95, v141, v95  // unmatched @ 22989
	v_add_f32_e32 v76, v140, v95  // unmatched @ 22990
	v_mov_b32_e32 v95, v76  // unmatched @ 22991
	v_cvt_f16_f32_e32 v95, v95  // unmatched @ 22992
	buffer_store_b16 v95, v79, s[16:19], 0 offen offset:64  // unmatched @ 22993
	v_mul_f32_e32 v96, v143, v96  // unmatched @ 22994
	v_add_f32_e32 v76, v142, v96  // unmatched @ 22995
	v_mov_b32_e32 v96, v76  // unmatched @ 22996
	v_cvt_f16_f32_e32 v96, v96  // unmatched @ 22997
	buffer_store_b16 v96, v79, s[16:19], 0 offen offset:128  // unmatched @ 22998
	v_mul_f32_e32 v97, v139, v97  // unmatched @ 22999
	v_add_f32_e32 v76, v138, v97  // unmatched @ 23000
	v_mov_b32_e32 v97, v76  // unmatched @ 23001
	v_cvt_f16_f32_e32 v97, v97  // unmatched @ 23002
	s_mul_i32 s8, s36, 4  // unmatched @ 23003
	s_add_u32 s16, s16, s8  // unmatched @ 23004
	s_addc_u32 s17, s17, 0  // unmatched @ 23005
	buffer_store_b16 v97, v79, s[16:19], 0 offen  // unmatched @ 23006
	v_mul_f32_e32 v98, v141, v98  // unmatched @ 23007
	v_add_f32_e32 v76, v140, v98  // unmatched @ 23008
	v_mov_b32_e32 v98, v76  // unmatched @ 23009
	v_cvt_f16_f32_e32 v98, v98  // unmatched @ 23010
	buffer_store_b16 v98, v79, s[16:19], 0 offen offset:64  // unmatched @ 23011
	v_mul_f32_e32 v99, v143, v99  // unmatched @ 23012
	v_add_f32_e32 v76, v142, v99  // unmatched @ 23013
	v_mov_b32_e32 v99, v76  // unmatched @ 23014
	v_cvt_f16_f32_e32 v99, v99  // unmatched @ 23015
	buffer_store_b16 v99, v79, s[16:19], 0 offen offset:128  // unmatched @ 23016
	v_mul_f32_e32 v100, v139, v100  // unmatched @ 23017
	v_add_f32_e32 v76, v138, v100  // unmatched @ 23018
	v_mov_b32_e32 v100, v76  // unmatched @ 23019
	v_cvt_f16_f32_e32 v100, v100  // unmatched @ 23020
	s_mul_i32 s8, s36, 4  // unmatched @ 23021
	s_add_u32 s16, s16, s8  // unmatched @ 23022
	s_addc_u32 s17, s17, 0  // unmatched @ 23023
	buffer_store_b16 v100, v79, s[16:19], 0 offen  // unmatched @ 23024
	v_mul_f32_e32 v101, v141, v101  // unmatched @ 23025
	v_add_f32_e32 v76, v140, v101  // unmatched @ 23026
	v_mov_b32_e32 v101, v76  // unmatched @ 23027
	v_cvt_f16_f32_e32 v101, v101  // unmatched @ 23028
	buffer_store_b16 v101, v79, s[16:19], 0 offen offset:64  // unmatched @ 23029
	v_mul_f32_e32 v102, v143, v102  // unmatched @ 23030
	v_add_f32_e32 v76, v142, v102  // unmatched @ 23031
	v_mov_b32_e32 v102, v76  // unmatched @ 23032
	v_cvt_f16_f32_e32 v102, v102  // unmatched @ 23033
	buffer_store_b16 v102, v79, s[16:19], 0 offen offset:128  // unmatched @ 23034
	v_mul_f32_e32 v103, v139, v103  // unmatched @ 23035
	v_add_f32_e32 v76, v138, v103  // unmatched @ 23036
	v_mov_b32_e32 v103, v76  // unmatched @ 23037
	v_cvt_f16_f32_e32 v103, v103  // unmatched @ 23038
	s_mul_i32 s8, s36, 4  // unmatched @ 23039
	s_add_u32 s16, s16, s8  // unmatched @ 23040
	s_addc_u32 s17, s17, 0  // unmatched @ 23041
	buffer_store_b16 v103, v79, s[16:19], 0 offen  // unmatched @ 23042
	v_mul_f32_e32 v104, v141, v104  // unmatched @ 23043
	v_add_f32_e32 v76, v140, v104  // unmatched @ 23044
	v_mov_b32_e32 v104, v76  // unmatched @ 23045
	v_cvt_f16_f32_e32 v104, v104  // unmatched @ 23046
	buffer_store_b16 v104, v79, s[16:19], 0 offen offset:64  // unmatched @ 23047
	v_mul_f32_e32 v105, v143, v105  // unmatched @ 23048
	v_add_f32_e32 v76, v142, v105  // unmatched @ 23049
	v_mov_b32_e32 v105, v76  // unmatched @ 23050
	v_cvt_f16_f32_e32 v105, v105  // unmatched @ 23051
	buffer_store_b16 v105, v79, s[16:19], 0 offen offset:128  // unmatched @ 23052
	v_mul_f32_e32 v106, v139, v106  // unmatched @ 23053
	v_add_f32_e32 v76, v138, v106  // unmatched @ 23054
	v_mov_b32_e32 v106, v76  // unmatched @ 23055
	v_cvt_f16_f32_e32 v106, v106  // unmatched @ 23056
	s_mul_i32 s8, s36, 36  // unmatched @ 23057
	s_add_u32 s16, s16, s8  // unmatched @ 23058
	s_addc_u32 s17, s17, 0  // unmatched @ 23059
	buffer_store_b16 v106, v79, s[16:19], 0 offen  // unmatched @ 23060
	v_mul_f32_e32 v107, v141, v107  // unmatched @ 23061
	v_add_f32_e32 v76, v140, v107  // unmatched @ 23062
	v_mov_b32_e32 v107, v76  // unmatched @ 23063
	v_cvt_f16_f32_e32 v107, v107  // unmatched @ 23064
	buffer_store_b16 v107, v79, s[16:19], 0 offen offset:64  // unmatched @ 23065
	v_mul_f32_e32 v108, v143, v108  // unmatched @ 23066
	v_add_f32_e32 v76, v142, v108  // unmatched @ 23067
	v_mov_b32_e32 v108, v76  // unmatched @ 23068
	v_cvt_f16_f32_e32 v108, v108  // unmatched @ 23069
	buffer_store_b16 v108, v79, s[16:19], 0 offen offset:128  // unmatched @ 23070
	v_mul_f32_e32 v109, v139, v109  // unmatched @ 23071
	v_add_f32_e32 v76, v138, v109  // unmatched @ 23072
	v_mov_b32_e32 v109, v76  // unmatched @ 23073
	v_cvt_f16_f32_e32 v109, v109  // unmatched @ 23074
	s_mul_i32 s8, s36, 4  // unmatched @ 23075
	s_add_u32 s16, s16, s8  // unmatched @ 23076
	s_addc_u32 s17, s17, 0  // unmatched @ 23077
	buffer_store_b16 v109, v79, s[16:19], 0 offen  // unmatched @ 23078
	v_mul_f32_e32 v110, v141, v110  // unmatched @ 23079
	v_add_f32_e32 v76, v140, v110  // unmatched @ 23080
	v_mov_b32_e32 v110, v76  // unmatched @ 23081
	v_cvt_f16_f32_e32 v110, v110  // unmatched @ 23082
	buffer_store_b16 v110, v79, s[16:19], 0 offen offset:64  // unmatched @ 23083
	v_mul_f32_e32 v111, v143, v111  // unmatched @ 23084
	v_add_f32_e32 v76, v142, v111  // unmatched @ 23085
	v_mov_b32_e32 v111, v76  // unmatched @ 23086
	v_cvt_f16_f32_e32 v111, v111  // unmatched @ 23087
	buffer_store_b16 v111, v79, s[16:19], 0 offen offset:128  // unmatched @ 23088
	v_mul_f32_e32 v112, v139, v112  // unmatched @ 23089
	v_add_f32_e32 v76, v138, v112  // unmatched @ 23090
	v_mov_b32_e32 v112, v76  // unmatched @ 23091
	v_cvt_f16_f32_e32 v112, v112  // unmatched @ 23092
	s_mul_i32 s8, s36, 4  // unmatched @ 23093
	s_add_u32 s16, s16, s8  // unmatched @ 23094
	s_addc_u32 s17, s17, 0  // unmatched @ 23095
	buffer_store_b16 v112, v79, s[16:19], 0 offen  // unmatched @ 23096
	v_mul_f32_e32 v113, v141, v113  // unmatched @ 23097
	v_add_f32_e32 v76, v140, v113  // unmatched @ 23098
	v_mov_b32_e32 v113, v76  // unmatched @ 23099
	v_cvt_f16_f32_e32 v113, v113  // unmatched @ 23100
	buffer_store_b16 v113, v79, s[16:19], 0 offen offset:64  // unmatched @ 23101
	v_mul_f32_e32 v114, v143, v114  // unmatched @ 23102
	v_add_f32_e32 v76, v142, v114  // unmatched @ 23103
	v_mov_b32_e32 v114, v76  // unmatched @ 23104
	v_cvt_f16_f32_e32 v114, v114  // unmatched @ 23105
	buffer_store_b16 v114, v79, s[16:19], 0 offen offset:128  // unmatched @ 23106
	v_mul_f32_e32 v115, v139, v115  // unmatched @ 23107
	v_add_f32_e32 v76, v138, v115  // unmatched @ 23108
	v_mov_b32_e32 v115, v76  // unmatched @ 23109
	v_cvt_f16_f32_e32 v115, v115  // unmatched @ 23110
	s_mul_i32 s8, s36, 4  // unmatched @ 23111
	s_add_u32 s16, s16, s8  // unmatched @ 23112
	s_addc_u32 s17, s17, 0  // unmatched @ 23113
	buffer_store_b16 v115, v79, s[16:19], 0 offen  // unmatched @ 23114
	v_mul_f32_e32 v116, v141, v116  // unmatched @ 23115
	v_add_f32_e32 v76, v140, v116  // unmatched @ 23116
	v_mov_b32_e32 v116, v76  // unmatched @ 23117
	v_cvt_f16_f32_e32 v116, v116  // unmatched @ 23118
	buffer_store_b16 v116, v79, s[16:19], 0 offen offset:64  // unmatched @ 23119
	v_mul_f32_e32 v117, v143, v117  // unmatched @ 23120
	v_add_f32_e32 v76, v142, v117  // unmatched @ 23121
	v_mov_b32_e32 v117, v76  // unmatched @ 23122
	v_cvt_f16_f32_e32 v117, v117  // unmatched @ 23123
	buffer_store_b16 v117, v79, s[16:19], 0 offen offset:128  // unmatched @ 23124
	v_mul_f32_e32 v118, v139, v118  // unmatched @ 23125
	v_add_f32_e32 v76, v138, v118  // unmatched @ 23126
	v_mov_b32_e32 v118, v76  // unmatched @ 23127
	v_cvt_f16_f32_e32 v118, v118  // unmatched @ 23128
	s_mul_i32 s8, s36, 4  // unmatched @ 23129
	s_add_u32 s16, s16, s8  // unmatched @ 23130
	s_addc_u32 s17, s17, 0  // unmatched @ 23131
	buffer_store_b16 v118, v79, s[16:19], 0 offen  // unmatched @ 23132
	v_mul_f32_e32 v119, v141, v119  // unmatched @ 23133
	v_add_f32_e32 v76, v140, v119  // unmatched @ 23134
	v_mov_b32_e32 v119, v76  // unmatched @ 23135
	v_cvt_f16_f32_e32 v119, v119  // unmatched @ 23136
	buffer_store_b16 v119, v79, s[16:19], 0 offen offset:64  // unmatched @ 23137
	v_mul_f32_e32 v120, v143, v120  // unmatched @ 23138
	v_add_f32_e32 v76, v142, v120  // unmatched @ 23139
	v_mov_b32_e32 v120, v76  // unmatched @ 23140
	v_cvt_f16_f32_e32 v120, v120  // unmatched @ 23141
	buffer_store_b16 v120, v79, s[16:19], 0 offen offset:128  // unmatched @ 23142
	v_mul_f32_e32 v121, v139, v121  // unmatched @ 23143
	v_add_f32_e32 v76, v138, v121  // unmatched @ 23144
	v_mov_b32_e32 v121, v76  // unmatched @ 23145
	v_cvt_f16_f32_e32 v121, v121  // unmatched @ 23146
	s_mul_i32 s8, s36, 4  // unmatched @ 23147
	s_add_u32 s16, s16, s8  // unmatched @ 23148
	s_addc_u32 s17, s17, 0  // unmatched @ 23149
	buffer_store_b16 v121, v79, s[16:19], 0 offen  // unmatched @ 23150
	v_mul_f32_e32 v122, v141, v122  // unmatched @ 23151
	v_add_f32_e32 v76, v140, v122  // unmatched @ 23152
	v_mov_b32_e32 v122, v76  // unmatched @ 23153
	v_cvt_f16_f32_e32 v122, v122  // unmatched @ 23154
	buffer_store_b16 v122, v79, s[16:19], 0 offen offset:64  // unmatched @ 23155
	v_mul_f32_e32 v123, v143, v123  // unmatched @ 23156
	v_add_f32_e32 v76, v142, v123  // unmatched @ 23157
	v_mov_b32_e32 v123, v76  // unmatched @ 23158
	v_cvt_f16_f32_e32 v123, v123  // unmatched @ 23159
	buffer_store_b16 v123, v79, s[16:19], 0 offen offset:128  // unmatched @ 23160
	v_mul_f32_e32 v124, v139, v124  // unmatched @ 23161
	v_add_f32_e32 v76, v138, v124  // unmatched @ 23162
	v_mov_b32_e32 v124, v76  // unmatched @ 23163
	v_cvt_f16_f32_e32 v124, v124  // unmatched @ 23164
	s_mul_i32 s8, s36, 4  // unmatched @ 23165
	s_add_u32 s16, s16, s8  // unmatched @ 23166
	s_addc_u32 s17, s17, 0  // unmatched @ 23167
	buffer_store_b16 v124, v79, s[16:19], 0 offen  // unmatched @ 23168
	v_mul_f32_e32 v125, v141, v125  // unmatched @ 23169
	v_add_f32_e32 v76, v140, v125  // unmatched @ 23170
	v_mov_b32_e32 v125, v76  // unmatched @ 23171
	v_cvt_f16_f32_e32 v125, v125  // unmatched @ 23172
	buffer_store_b16 v125, v79, s[16:19], 0 offen offset:64  // unmatched @ 23173
	v_mul_f32_e32 v126, v143, v126  // unmatched @ 23174
	v_add_f32_e32 v76, v142, v126  // unmatched @ 23175
	v_mov_b32_e32 v126, v76  // unmatched @ 23176
	v_cvt_f16_f32_e32 v126, v126  // unmatched @ 23177
	buffer_store_b16 v126, v79, s[16:19], 0 offen offset:128  // unmatched @ 23178
	v_mul_f32_e32 v127, v139, v127  // unmatched @ 23179
	v_add_f32_e32 v76, v138, v127  // unmatched @ 23180
	v_mov_b32_e32 v127, v76  // unmatched @ 23181
	v_cvt_f16_f32_e32 v127, v127  // unmatched @ 23182
	s_mul_i32 s8, s36, 4  // unmatched @ 23183
	s_add_u32 s16, s16, s8  // unmatched @ 23184
	s_addc_u32 s17, s17, 0  // unmatched @ 23185
	buffer_store_b16 v127, v79, s[16:19], 0 offen  // unmatched @ 23186
	v_mul_f32_e32 v128, v141, v128  // unmatched @ 23187
	v_add_f32_e32 v76, v140, v128  // unmatched @ 23188
	v_mov_b32_e32 v128, v76  // unmatched @ 23189
	v_cvt_f16_f32_e64 v128, v128  // unmatched @ 23190
	buffer_store_b16 v128, v79, s[16:19], 0 offen offset:64  // unmatched @ 23191
	v_mul_f32_e32 v130, v139, v130  // unmatched @ 23192
	v_add_f32_e32 v76, v138, v130  // unmatched @ 23193
	v_mov_b32_e32 v130, v76  // unmatched @ 23194
	v_cvt_f16_f32_e64 v130, v130  // unmatched @ 23195
	s_mul_i32 s8, s36, 36  // unmatched @ 23196
	s_add_u32 s16, s16, s8  // unmatched @ 23197
	s_addc_u32 s17, s17, 0  // unmatched @ 23198
	buffer_store_b16 v130, v79, s[16:19], 0 offen  // unmatched @ 23199

label_GW_End:  // trace [23200:23200]
	s_endpgm
	v_mul_f32_e32 v131, v141, v131  // unmatched @ 23201
	v_add_f32_e32 v76, v140, v131  // unmatched @ 23202
	v_mov_b32_e32 v131, v76  // unmatched @ 23203
	v_cvt_f16_f32_e64 v131, v131  // unmatched @ 23204
	buffer_store_b16 v131, v79, s[16:19], 0 offen offset:64  // unmatched @ 23205
	v_mul_f32_e32 v132, v143, v132  // unmatched @ 23206
	v_add_f32_e32 v76, v142, v132  // unmatched @ 23207
	v_mov_b32_e32 v132, v76  // unmatched @ 23208
	v_cvt_f16_f32_e64 v132, v132  // unmatched @ 23209
	buffer_store_b16 v132, v79, s[16:19], 0 offen offset:128  // unmatched @ 23210
	v_mul_f32_e32 v133, v139, v133  // unmatched @ 23211
	v_add_f32_e32 v76, v138, v133  // unmatched @ 23212
	v_mov_b32_e32 v133, v76  // unmatched @ 23213
	v_cvt_f16_f32_e64 v133, v133  // unmatched @ 23214
	s_mul_i32 s8, s36, 4  // unmatched @ 23215
	s_add_u32 s16, s16, s8  // unmatched @ 23216
	s_addc_u32 s17, s17, 0  // unmatched @ 23217
	buffer_store_b16 v133, v79, s[16:19], 0 offen  // unmatched @ 23218
	v_mul_f32_e32 v134, v141, v134  // unmatched @ 23219
	v_add_f32_e32 v76, v140, v134  // unmatched @ 23220
	v_mov_b32_e32 v134, v76  // unmatched @ 23221
	v_cvt_f16_f32_e64 v134, v134  // unmatched @ 23222
	buffer_store_b16 v134, v79, s[16:19], 0 offen offset:64  // unmatched @ 23223
	v_mul_f32_e32 v135, v143, v135  // unmatched @ 23224
	v_add_f32_e32 v76, v142, v135  // unmatched @ 23225
	v_mov_b32_e32 v135, v76  // unmatched @ 23226
	v_cvt_f16_f32_e64 v135, v135  // unmatched @ 23227
	buffer_store_b16 v135, v79, s[16:19], 0 offen offset:128  // unmatched @ 23228
	v_mul_f32_e32 v136, v139, v136  // unmatched @ 23229
	v_add_f32_e32 v76, v138, v136  // unmatched @ 23230
	v_mov_b32_e32 v136, v76  // unmatched @ 23231
	v_cvt_f16_f32_e64 v136, v136  // unmatched @ 23232
	s_mul_i32 s8, s36, 4  // unmatched @ 23233
	s_add_u32 s16, s16, s8  // unmatched @ 23234
	s_addc_u32 s17, s17, 0  // unmatched @ 23235
	buffer_store_b16 v136, v79, s[16:19], 0 offen  // unmatched @ 23236
	v_mul_f32_e32 v137, v141, v137  // unmatched @ 23237
	v_add_f32_e32 v76, v140, v137  // unmatched @ 23238
	v_mov_b32_e32 v137, v76  // unmatched @ 23239
	v_cvt_f16_f32_e64 v137, v137  // unmatched @ 23240
	buffer_store_b16 v137, v79, s[16:19], 0 offen offset:64  // unmatched @ 23241
	s_nop 0  // unmatched @ 23242
	ds_load_b32 v98, v81 offset:256  // unmatched @ 23243
	ds_load_b32 v99, v81 offset:768  // unmatched @ 23244
	ds_load_b32 v100, v81  // unmatched @ 23245
	ds_load_b32 v101, v81 offset:512  // unmatched @ 23246
	ds_load_b32 v102, v81 offset:128  // unmatched @ 23247
	ds_load_b32 v103, v81 offset:640  // unmatched @ 23248
	v_mov_b32_e32 v82, v66  // unmatched @ 23249
	v_mov_b32_e32 v83, v51  // unmatched @ 23250
	v_mov_b32_e32 v84, v59  // unmatched @ 23251
	v_mov_b32_e32 v85, v67  // unmatched @ 23252
	v_mov_b32_e32 v86, v52  // unmatched @ 23253
	v_mov_b32_e32 v87, v60  // unmatched @ 23254
	v_mov_b32_e32 v88, v68  // unmatched @ 23255
	v_mov_b32_e32 v89, v53  // unmatched @ 23256
	v_mov_b32_e32 v90, v61  // unmatched @ 23257
	v_mov_b32_e32 v91, v69  // unmatched @ 23258
	v_mov_b32_e32 v92, v54  // unmatched @ 23259
	v_mov_b32_e32 v93, v62  // unmatched @ 23260
	v_mov_b32_e32 v94, v70  // unmatched @ 23261
	v_mov_b32_e32 v95, v55  // unmatched @ 23262
	v_mov_b32_e32 v96, v63  // unmatched @ 23263
	v_mov_b32_e32 v97, v71  // unmatched @ 23264
	s_waitcnt lgkmcnt(4)  // unmatched @ 23265
	v_mul_f32_e32 v82, v99, v82  // unmatched @ 23266
	v_add_f32_e32 v76, v98, v82  // unmatched @ 23267
	v_mov_b32_e32 v82, v76  // unmatched @ 23268
	v_cvt_f16_f32_e32 v82, v82  // unmatched @ 23269
	buffer_store_b16 v82, v79, s[16:19], 0 offen offset:128  // unmatched @ 23270
	s_waitcnt lgkmcnt(2)  // unmatched @ 23271
	v_mul_f32_e32 v83, v101, v83  // unmatched @ 23272
	v_add_f32_e32 v76, v100, v83  // unmatched @ 23273
	v_mov_b32_e32 v83, v76  // unmatched @ 23274
	v_cvt_f16_f32_e32 v83, v83  // unmatched @ 23275
	s_mul_i32 s8, s36, 4  // unmatched @ 23276
	s_add_u32 s16, s16, s8  // unmatched @ 23277
	s_addc_u32 s17, s17, 0  // unmatched @ 23278
	buffer_store_b16 v83, v79, s[16:19], 0 offen  // unmatched @ 23279
	s_waitcnt lgkmcnt(0)  // unmatched @ 23280
	v_mul_f32_e32 v84, v103, v84  // unmatched @ 23281
	v_add_f32_e32 v76, v102, v84  // unmatched @ 23282
	v_mov_b32_e32 v84, v76  // unmatched @ 23283
	v_cvt_f16_f32_e32 v84, v84  // unmatched @ 23284
	buffer_store_b16 v84, v79, s[16:19], 0 offen offset:64  // unmatched @ 23285
	v_mul_f32_e32 v85, v99, v85  // unmatched @ 23286
	v_add_f32_e32 v76, v98, v85  // unmatched @ 23287
	v_mov_b32_e32 v85, v76  // unmatched @ 23288
	v_cvt_f16_f32_e32 v85, v85  // unmatched @ 23289
	buffer_store_b16 v85, v79, s[16:19], 0 offen offset:128  // unmatched @ 23290
	v_mul_f32_e32 v86, v101, v86  // unmatched @ 23291
	v_add_f32_e32 v76, v100, v86  // unmatched @ 23292
	v_mov_b32_e32 v86, v76  // unmatched @ 23293
	v_cvt_f16_f32_e32 v86, v86  // unmatched @ 23294
	s_mul_i32 s8, s36, 4  // unmatched @ 23295
	s_add_u32 s16, s16, s8  // unmatched @ 23296
	s_addc_u32 s17, s17, 0  // unmatched @ 23297
	buffer_store_b16 v86, v79, s[16:19], 0 offen  // unmatched @ 23298
	v_mul_f32_e32 v87, v103, v87  // unmatched @ 23299
	v_add_f32_e32 v76, v102, v87  // unmatched @ 23300
	v_mov_b32_e32 v87, v76  // unmatched @ 23301
	v_cvt_f16_f32_e32 v87, v87  // unmatched @ 23302
	buffer_store_b16 v87, v79, s[16:19], 0 offen offset:64  // unmatched @ 23303
	v_mul_f32_e32 v88, v99, v88  // unmatched @ 23304
	v_add_f32_e32 v76, v98, v88  // unmatched @ 23305
	v_mov_b32_e32 v88, v76  // unmatched @ 23306
	v_cvt_f16_f32_e32 v88, v88  // unmatched @ 23307
	buffer_store_b16 v88, v79, s[16:19], 0 offen offset:128  // unmatched @ 23308
	v_mul_f32_e32 v89, v101, v89  // unmatched @ 23309
	v_add_f32_e32 v76, v100, v89  // unmatched @ 23310
	v_mov_b32_e32 v89, v76  // unmatched @ 23311
	v_cvt_f16_f32_e32 v89, v89  // unmatched @ 23312
	s_mul_i32 s8, s36, 4  // unmatched @ 23313
	s_add_u32 s16, s16, s8  // unmatched @ 23314
	s_addc_u32 s17, s17, 0  // unmatched @ 23315
	buffer_store_b16 v89, v79, s[16:19], 0 offen  // unmatched @ 23316
	v_mul_f32_e32 v90, v103, v90  // unmatched @ 23317
	v_add_f32_e32 v76, v102, v90  // unmatched @ 23318
	v_mov_b32_e32 v90, v76  // unmatched @ 23319
	v_cvt_f16_f32_e32 v90, v90  // unmatched @ 23320
	buffer_store_b16 v90, v79, s[16:19], 0 offen offset:64  // unmatched @ 23321
	v_mul_f32_e32 v91, v99, v91  // unmatched @ 23322
	v_add_f32_e32 v76, v98, v91  // unmatched @ 23323
	v_mov_b32_e32 v91, v76  // unmatched @ 23324
	v_cvt_f16_f32_e32 v91, v91  // unmatched @ 23325
	buffer_store_b16 v91, v79, s[16:19], 0 offen offset:128  // unmatched @ 23326
	v_mul_f32_e32 v92, v101, v92  // unmatched @ 23327
	v_add_f32_e32 v76, v100, v92  // unmatched @ 23328
	v_mov_b32_e32 v92, v76  // unmatched @ 23329
	v_cvt_f16_f32_e32 v92, v92  // unmatched @ 23330
	s_mul_i32 s8, s36, 4  // unmatched @ 23331
	s_add_u32 s16, s16, s8  // unmatched @ 23332
	s_addc_u32 s17, s17, 0  // unmatched @ 23333
	buffer_store_b16 v92, v79, s[16:19], 0 offen  // unmatched @ 23334
	v_mul_f32_e32 v93, v103, v93  // unmatched @ 23335
	v_add_f32_e32 v76, v102, v93  // unmatched @ 23336
	v_mov_b32_e32 v93, v76  // unmatched @ 23337
	v_cvt_f16_f32_e32 v93, v93  // unmatched @ 23338
	buffer_store_b16 v93, v79, s[16:19], 0 offen offset:64  // unmatched @ 23339
	v_mul_f32_e32 v94, v99, v94  // unmatched @ 23340
	v_add_f32_e32 v76, v98, v94  // unmatched @ 23341
	v_mov_b32_e32 v94, v76  // unmatched @ 23342
	v_cvt_f16_f32_e32 v94, v94  // unmatched @ 23343
	buffer_store_b16 v94, v79, s[16:19], 0 offen offset:128  // unmatched @ 23344
	v_mul_f32_e32 v95, v101, v95  // unmatched @ 23345
	v_add_f32_e32 v76, v100, v95  // unmatched @ 23346
	v_mov_b32_e32 v95, v76  // unmatched @ 23347
	v_cvt_f16_f32_e32 v95, v95  // unmatched @ 23348
	s_mul_i32 s8, s36, 4  // unmatched @ 23349
	s_add_u32 s16, s16, s8  // unmatched @ 23350
	s_addc_u32 s17, s17, 0  // unmatched @ 23351
	buffer_store_b16 v95, v79, s[16:19], 0 offen  // unmatched @ 23352
	v_mul_f32_e32 v96, v103, v96  // unmatched @ 23353
	v_add_f32_e32 v76, v102, v96  // unmatched @ 23354
	v_mov_b32_e32 v96, v76  // unmatched @ 23355
	v_cvt_f16_f32_e32 v96, v96  // unmatched @ 23356
	buffer_store_b16 v96, v79, s[16:19], 0 offen offset:64  // unmatched @ 23357
	v_mul_f32_e32 v97, v99, v97  // unmatched @ 23358
	v_add_f32_e32 v76, v98, v97  // unmatched @ 23359
	v_mov_b32_e32 v97, v76  // unmatched @ 23360
	v_cvt_f16_f32_e32 v97, v97  // unmatched @ 23361
	buffer_store_b16 v97, v79, s[16:19], 0 offen offset:128  // unmatched @ 23362
	s_nop 0  // unmatched @ 23363

label_GW_End_iter2:  // trace [23364:23364]
	s_endpgm