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
s_lshl_b32 s67, s66, s68
s_cmp_ge_u32 s13, s67
s_sub_u32 s67, s66, 1
s_cmp_ge_u32 s66, 1
s_cselect_b32 s47, s67, 0
s_cmp_eq_u32 s69, 0
s_cmp_eq_u32 s69, 0x2000
s_mov_b32 s66, s3
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
buffer_load_b128 v[230:233], v72, s[48:51], 0 offen
buffer_load_b128 v[234:237], v73, s[48:51], 0 offen
buffer_load_b128 v[238:241], v74, s[48:51], 0 offen
buffer_load_b128 v[242:245], v75, s[52:55], 0 offen
buffer_load_b128 v[246:249], v76, s[52:55], 0 offen
buffer_load_b128 v[250:253], v77, s[52:55], 0 offen
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
s_cmp_eq_u32 s12, 1
s_cmp_le_u32 s12, 2
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
s_and_b32 s8, s46, 0x3fff
s_cmp_eq_u32 s8, 1
s_cmpk_eq_u32 s45, 0x0
s_cmp_eq_u32 s44, 1.0
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
s_and_b32 s67, 31, s27
s_cmp_eq_u32 s67, 0
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
s_load_b256 s[48:55], s[0:1], 0x58
s_load_b32 s56, s[0:1], 0x78
v_lshrrev_b32_e32 v76, 5, v254
v_lshrrev_b32_e32 v77, 1, v76
v_mul_lo_u32 v77, 16, v77
v_and_b32_e32 v73, 31, v254
v_lshrrev_b32_e32 v73, 4, v73
v_add_lshl_u32 v73, v77, v73, 0
v_mul_lo_u32 v74, v73, s38
v_mul_lo_u32 v75, v73, s36
v_and_b32_e32 v72, 1, v76
v_mul_lo_u32 v72, 16, v72
v_and_b32_e32 v77, 15, v254
v_add_lshl_u32 v72, v77, v72, 0
s_mul_i32 s8, 0x60, s2
v_add_nc_u32_e32 v72, s8, v72
s_mul_i32 s8, 0x60, s3
v_add_nc_u32_e32 v73, s8, v73
s_waitcnt lgkmcnt(0)
s_mov_b64 s[32:33], s[48:49]
s_mov_b32 s35, 0x31004000
s_mov_b32 s34, 0
s_mul_i32 s34, 4, s34
s_add_u32 s8, s4, 1
s_mul_i32 s8, s53, s8
s_cmp_eq_u32 s8, 0
s_cselect_b32 s8, s24, s8
s_mov_b64 s[40:41], s[50:51]
s_mov_b32 s43, 0x31004000
s_mov_b32 s42, 0
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
s_add_i32 s8, 0xc7cc, 4
s_add_u32 s12, s12, s8
s_addc_u32 s13, s13, 0
s_mul_i32 s8, 0x60, s2
v_sub_nc_u32_e64 v81, v72, s8
v_lshlrev_b32_e32 v81, 2, v81
s_waitcnt lgkmcnt(0)
s_barrier
ds_load_b32 v138, v81
ds_load_b32 v139, v81 offset:512
ds_load_b32 v140, v81 offset:128
ds_load_b32 v141, v81 offset:640
ds_load_b32 v142, v81 offset:256
ds_load_b32 v143, v81 offset:768
v_add_lshl_u32 v79, v75, v72, 1
v_mov_b32_e32 v82, v0
v_mov_b32_e32 v83, v8
v_mov_b32_e32 v84, v16
v_mov_b32_e32 v85, v1
v_mov_b32_e32 v86, v9
v_mov_b32_e32 v87, v17
v_mov_b32_e32 v88, v2
v_mov_b32_e32 v89, v10
v_mov_b32_e32 v90, v18
v_mov_b32_e32 v91, v3
v_mov_b32_e32 v92, v11
v_mov_b32_e32 v93, v19
v_mov_b32_e32 v94, v4
v_mov_b32_e32 v95, v12
v_mov_b32_e32 v96, v20
v_mov_b32_e32 v97, v5
v_mov_b32_e32 v98, v13
v_mov_b32_e32 v99, v21
v_mov_b32_e32 v100, v6
v_mov_b32_e32 v101, v14
v_mov_b32_e32 v102, v22
v_mov_b32_e32 v103, v7
v_mov_b32_e32 v104, v15
v_mov_b32_e32 v105, v23
v_mov_b32_e32 v106, v24
v_mov_b32_e32 v107, v32
v_mov_b32_e32 v108, v40
v_mov_b32_e32 v109, v25
v_mov_b32_e32 v110, v33
v_mov_b32_e32 v111, v41
v_mov_b32_e32 v112, v26
v_mov_b32_e32 v113, v34
v_mov_b32_e32 v114, v42
v_mov_b32_e32 v115, v27
v_mov_b32_e32 v116, v35
v_mov_b32_e32 v117, v43
v_mov_b32_e32 v118, v28
v_mov_b32_e32 v119, v36
v_mov_b32_e32 v120, v44
v_mov_b32_e32 v121, v29
v_mov_b32_e32 v122, v37
v_mov_b32_e32 v123, v45
v_mov_b32_e32 v124, v30
v_mov_b32_e32 v125, v38
v_mov_b32_e32 v126, v46
v_mov_b32_e32 v127, v31
v_mov_b32_e32 v128, v39
v_mov_b32_e32 v129, v47
v_mov_b32_e32 v130, v48
v_mov_b32_e32 v131, v56
v_mov_b32_e32 v132, v64
v_mov_b32_e32 v133, v49
v_mov_b32_e32 v134, v57
v_mov_b32_e32 v135, v65
v_mov_b32_e32 v136, v50
v_mov_b32_e32 v137, v58
s_waitcnt lgkmcnt(4)
v_mul_f32_e32 v82, v139, v82
v_add_f32_e32 v76, v138, v82
v_mov_b32_e32 v82, v76
v_cvt_f16_f32_e32 v82, v82
v_mov_b32 v82 0x3C003C00
buffer_store_b16 v82, v79, s[16:19], 0 offen
s_endpgm
s_waitcnt lgkmcnt(2)
v_mul_f32_e32 v83, v141, v83
v_add_f32_e32 v76, v140, v83
v_mov_b32_e32 v83, v76
v_cvt_f16_f32_e32 v83, v83
buffer_store_b16 v83, v79, s[16:19], 0 offen offset:64
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v84, v143, v84
v_add_f32_e32 v76, v142, v84
v_mov_b32_e32 v84, v76
v_cvt_f16_f32_e32 v84, v84
buffer_store_b16 v84, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v85, v139, v85
v_add_f32_e32 v76, v138, v85
v_mov_b32_e32 v85, v76
v_cvt_f16_f32_e32 v85, v85
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v85, v79, s[16:19], 0 offen
v_mul_f32_e32 v86, v141, v86
v_add_f32_e32 v76, v140, v86
v_mov_b32_e32 v86, v76
v_cvt_f16_f32_e32 v86, v86
buffer_store_b16 v86, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v87, v143, v87
v_add_f32_e32 v76, v142, v87
v_mov_b32_e32 v87, v76
v_cvt_f16_f32_e32 v87, v87
buffer_store_b16 v87, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v88, v139, v88
v_add_f32_e32 v76, v138, v88
v_mov_b32_e32 v88, v76
v_cvt_f16_f32_e32 v88, v88
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v88, v79, s[16:19], 0 offen
v_mul_f32_e32 v89, v141, v89
v_add_f32_e32 v76, v140, v89
v_mov_b32_e32 v89, v76
v_cvt_f16_f32_e32 v89, v89
buffer_store_b16 v89, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v90, v143, v90
v_add_f32_e32 v76, v142, v90
v_mov_b32_e32 v90, v76
v_cvt_f16_f32_e32 v90, v90
buffer_store_b16 v90, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v91, v139, v91
v_add_f32_e32 v76, v138, v91
v_mov_b32_e32 v91, v76
v_cvt_f16_f32_e32 v91, v91
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v91, v79, s[16:19], 0 offen
v_mul_f32_e32 v92, v141, v92
v_add_f32_e32 v76, v140, v92
v_mov_b32_e32 v92, v76
v_cvt_f16_f32_e32 v92, v92
buffer_store_b16 v92, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v93, v143, v93
v_add_f32_e32 v76, v142, v93
v_mov_b32_e32 v93, v76
v_cvt_f16_f32_e32 v93, v93
buffer_store_b16 v93, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v94, v139, v94
v_add_f32_e32 v76, v138, v94
v_mov_b32_e32 v94, v76
v_cvt_f16_f32_e32 v94, v94
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v94, v79, s[16:19], 0 offen
v_mul_f32_e32 v95, v141, v95
v_add_f32_e32 v76, v140, v95
v_mov_b32_e32 v95, v76
v_cvt_f16_f32_e32 v95, v95
buffer_store_b16 v95, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v96, v143, v96
v_add_f32_e32 v76, v142, v96
v_mov_b32_e32 v96, v76
v_cvt_f16_f32_e32 v96, v96
buffer_store_b16 v96, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v97, v139, v97
v_add_f32_e32 v76, v138, v97
v_mov_b32_e32 v97, v76
v_cvt_f16_f32_e32 v97, v97
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v97, v79, s[16:19], 0 offen
v_mul_f32_e32 v98, v141, v98
v_add_f32_e32 v76, v140, v98
v_mov_b32_e32 v98, v76
v_cvt_f16_f32_e32 v98, v98
buffer_store_b16 v98, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v99, v143, v99
v_add_f32_e32 v76, v142, v99
v_mov_b32_e32 v99, v76
v_cvt_f16_f32_e32 v99, v99
buffer_store_b16 v99, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v100, v139, v100
v_add_f32_e32 v76, v138, v100
v_mov_b32_e32 v100, v76
v_cvt_f16_f32_e32 v100, v100
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v100, v79, s[16:19], 0 offen
v_mul_f32_e32 v101, v141, v101
v_add_f32_e32 v76, v140, v101
v_mov_b32_e32 v101, v76
v_cvt_f16_f32_e32 v101, v101
buffer_store_b16 v101, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v102, v143, v102
v_add_f32_e32 v76, v142, v102
v_mov_b32_e32 v102, v76
v_cvt_f16_f32_e32 v102, v102
buffer_store_b16 v102, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v103, v139, v103
v_add_f32_e32 v76, v138, v103
v_mov_b32_e32 v103, v76
v_cvt_f16_f32_e32 v103, v103
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v103, v79, s[16:19], 0 offen
v_mul_f32_e32 v104, v141, v104
v_add_f32_e32 v76, v140, v104
v_mov_b32_e32 v104, v76
v_cvt_f16_f32_e32 v104, v104
buffer_store_b16 v104, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v105, v143, v105
v_add_f32_e32 v76, v142, v105
v_mov_b32_e32 v105, v76
v_cvt_f16_f32_e32 v105, v105
buffer_store_b16 v105, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v106, v139, v106
v_add_f32_e32 v76, v138, v106
v_mov_b32_e32 v106, v76
v_cvt_f16_f32_e32 v106, v106
s_mul_i32 s8, s36, 36
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v106, v79, s[16:19], 0 offen
v_mul_f32_e32 v107, v141, v107
v_add_f32_e32 v76, v140, v107
v_mov_b32_e32 v107, v76
v_cvt_f16_f32_e32 v107, v107
buffer_store_b16 v107, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v108, v143, v108
v_add_f32_e32 v76, v142, v108
v_mov_b32_e32 v108, v76
v_cvt_f16_f32_e32 v108, v108
buffer_store_b16 v108, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v109, v139, v109
v_add_f32_e32 v76, v138, v109
v_mov_b32_e32 v109, v76
v_cvt_f16_f32_e32 v109, v109
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v109, v79, s[16:19], 0 offen
v_mul_f32_e32 v110, v141, v110
v_add_f32_e32 v76, v140, v110
v_mov_b32_e32 v110, v76
v_cvt_f16_f32_e32 v110, v110
buffer_store_b16 v110, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v111, v143, v111
v_add_f32_e32 v76, v142, v111
v_mov_b32_e32 v111, v76
v_cvt_f16_f32_e32 v111, v111
buffer_store_b16 v111, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v112, v139, v112
v_add_f32_e32 v76, v138, v112
v_mov_b32_e32 v112, v76
v_cvt_f16_f32_e32 v112, v112
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v112, v79, s[16:19], 0 offen
v_mul_f32_e32 v113, v141, v113
v_add_f32_e32 v76, v140, v113
v_mov_b32_e32 v113, v76
v_cvt_f16_f32_e32 v113, v113
buffer_store_b16 v113, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v114, v143, v114
v_add_f32_e32 v76, v142, v114
v_mov_b32_e32 v114, v76
v_cvt_f16_f32_e32 v114, v114
buffer_store_b16 v114, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v115, v139, v115
v_add_f32_e32 v76, v138, v115
v_mov_b32_e32 v115, v76
v_cvt_f16_f32_e32 v115, v115
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v115, v79, s[16:19], 0 offen
v_mul_f32_e32 v116, v141, v116
v_add_f32_e32 v76, v140, v116
v_mov_b32_e32 v116, v76
v_cvt_f16_f32_e32 v116, v116
buffer_store_b16 v116, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v117, v143, v117
v_add_f32_e32 v76, v142, v117
v_mov_b32_e32 v117, v76
v_cvt_f16_f32_e32 v117, v117
buffer_store_b16 v117, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v118, v139, v118
v_add_f32_e32 v76, v138, v118
v_mov_b32_e32 v118, v76
v_cvt_f16_f32_e32 v118, v118
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v118, v79, s[16:19], 0 offen
v_mul_f32_e32 v119, v141, v119
v_add_f32_e32 v76, v140, v119
v_mov_b32_e32 v119, v76
v_cvt_f16_f32_e32 v119, v119
buffer_store_b16 v119, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v120, v143, v120
v_add_f32_e32 v76, v142, v120
v_mov_b32_e32 v120, v76
v_cvt_f16_f32_e32 v120, v120
buffer_store_b16 v120, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v121, v139, v121
v_add_f32_e32 v76, v138, v121
v_mov_b32_e32 v121, v76
v_cvt_f16_f32_e32 v121, v121
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v121, v79, s[16:19], 0 offen
v_mul_f32_e32 v122, v141, v122
v_add_f32_e32 v76, v140, v122
v_mov_b32_e32 v122, v76
v_cvt_f16_f32_e32 v122, v122
buffer_store_b16 v122, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v123, v143, v123
v_add_f32_e32 v76, v142, v123
v_mov_b32_e32 v123, v76
v_cvt_f16_f32_e32 v123, v123
buffer_store_b16 v123, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v124, v139, v124
v_add_f32_e32 v76, v138, v124
v_mov_b32_e32 v124, v76
v_cvt_f16_f32_e32 v124, v124
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v124, v79, s[16:19], 0 offen
v_mul_f32_e32 v125, v141, v125
v_add_f32_e32 v76, v140, v125
v_mov_b32_e32 v125, v76
v_cvt_f16_f32_e32 v125, v125
buffer_store_b16 v125, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v126, v143, v126
v_add_f32_e32 v76, v142, v126
v_mov_b32_e32 v126, v76
v_cvt_f16_f32_e32 v126, v126
buffer_store_b16 v126, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v127, v139, v127
v_add_f32_e32 v76, v138, v127
v_mov_b32_e32 v127, v76
v_cvt_f16_f32_e32 v127, v127
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v127, v79, s[16:19], 0 offen
v_mul_f32_e32 v128, v141, v128
v_add_f32_e32 v76, v140, v128
v_mov_b32_e32 v128, v76
v_cvt_f16_f32_e64 v128, v128
buffer_store_b16 v128, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v129, v143, v129
v_add_f32_e32 v76, v142, v129
v_mov_b32_e32 v129, v76
v_cvt_f16_f32_e64 v129, v129
buffer_store_b16 v129, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v130, v139, v130
v_add_f32_e32 v76, v138, v130
v_mov_b32_e32 v130, v76
v_cvt_f16_f32_e64 v130, v130
s_mul_i32 s8, s36, 36
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v130, v79, s[16:19], 0 offen
v_mul_f32_e32 v131, v141, v131
v_add_f32_e32 v76, v140, v131
v_mov_b32_e32 v131, v76
v_cvt_f16_f32_e64 v131, v131
buffer_store_b16 v131, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v132, v143, v132
v_add_f32_e32 v76, v142, v132
v_mov_b32_e32 v132, v76
v_cvt_f16_f32_e64 v132, v132
buffer_store_b16 v132, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v133, v139, v133
v_add_f32_e32 v76, v138, v133
v_mov_b32_e32 v133, v76
v_cvt_f16_f32_e64 v133, v133
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v133, v79, s[16:19], 0 offen
v_mul_f32_e32 v134, v141, v134
v_add_f32_e32 v76, v140, v134
v_mov_b32_e32 v134, v76
v_cvt_f16_f32_e64 v134, v134
buffer_store_b16 v134, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v135, v143, v135
v_add_f32_e32 v76, v142, v135
v_mov_b32_e32 v135, v76
v_cvt_f16_f32_e64 v135, v135
buffer_store_b16 v135, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v136, v139, v136
v_add_f32_e32 v76, v138, v136
v_mov_b32_e32 v136, v76
v_cvt_f16_f32_e64 v136, v136
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v136, v79, s[16:19], 0 offen
v_mul_f32_e32 v137, v141, v137
v_add_f32_e32 v76, v140, v137
v_mov_b32_e32 v137, v76
v_cvt_f16_f32_e64 v137, v137
buffer_store_b16 v137, v79, s[16:19], 0 offen offset:64
s_nop 0
ds_load_b32 v98, v81 offset:256
ds_load_b32 v99, v81 offset:768
ds_load_b32 v100, v81
ds_load_b32 v101, v81 offset:512
ds_load_b32 v102, v81 offset:128
ds_load_b32 v103, v81 offset:640
v_mov_b32_e32 v82, v66
v_mov_b32_e32 v83, v51
v_mov_b32_e32 v84, v59
v_mov_b32_e32 v85, v67
v_mov_b32_e32 v86, v52
v_mov_b32_e32 v87, v60
v_mov_b32_e32 v88, v68
v_mov_b32_e32 v89, v53
v_mov_b32_e32 v90, v61
v_mov_b32_e32 v91, v69
v_mov_b32_e32 v92, v54
v_mov_b32_e32 v93, v62
v_mov_b32_e32 v94, v70
v_mov_b32_e32 v95, v55
v_mov_b32_e32 v96, v63
v_mov_b32_e32 v97, v71
s_waitcnt lgkmcnt(4)
v_mul_f32_e32 v82, v99, v82
v_add_f32_e32 v76, v98, v82
v_mov_b32_e32 v82, v76
v_cvt_f16_f32_e32 v82, v82
buffer_store_b16 v82, v79, s[16:19], 0 offen offset:128
s_waitcnt lgkmcnt(2)
v_mul_f32_e32 v83, v101, v83
v_add_f32_e32 v76, v100, v83
v_mov_b32_e32 v83, v76
v_cvt_f16_f32_e32 v83, v83
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v83, v79, s[16:19], 0 offen
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v84, v103, v84
v_add_f32_e32 v76, v102, v84
v_mov_b32_e32 v84, v76
v_cvt_f16_f32_e32 v84, v84
buffer_store_b16 v84, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v85, v99, v85
v_add_f32_e32 v76, v98, v85
v_mov_b32_e32 v85, v76
v_cvt_f16_f32_e32 v85, v85
buffer_store_b16 v85, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v86, v101, v86
v_add_f32_e32 v76, v100, v86
v_mov_b32_e32 v86, v76
v_cvt_f16_f32_e32 v86, v86
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v86, v79, s[16:19], 0 offen
v_mul_f32_e32 v87, v103, v87
v_add_f32_e32 v76, v102, v87
v_mov_b32_e32 v87, v76
v_cvt_f16_f32_e32 v87, v87
buffer_store_b16 v87, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v88, v99, v88
v_add_f32_e32 v76, v98, v88
v_mov_b32_e32 v88, v76
v_cvt_f16_f32_e32 v88, v88
buffer_store_b16 v88, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v89, v101, v89
v_add_f32_e32 v76, v100, v89
v_mov_b32_e32 v89, v76
v_cvt_f16_f32_e32 v89, v89
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v89, v79, s[16:19], 0 offen
v_mul_f32_e32 v90, v103, v90
v_add_f32_e32 v76, v102, v90
v_mov_b32_e32 v90, v76
v_cvt_f16_f32_e32 v90, v90
buffer_store_b16 v90, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v91, v99, v91
v_add_f32_e32 v76, v98, v91
v_mov_b32_e32 v91, v76
v_cvt_f16_f32_e32 v91, v91
buffer_store_b16 v91, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v92, v101, v92
v_add_f32_e32 v76, v100, v92
v_mov_b32_e32 v92, v76
v_cvt_f16_f32_e32 v92, v92
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v92, v79, s[16:19], 0 offen
v_mul_f32_e32 v93, v103, v93
v_add_f32_e32 v76, v102, v93
v_mov_b32_e32 v93, v76
v_cvt_f16_f32_e32 v93, v93
buffer_store_b16 v93, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v94, v99, v94
v_add_f32_e32 v76, v98, v94
v_mov_b32_e32 v94, v76
v_cvt_f16_f32_e32 v94, v94
buffer_store_b16 v94, v79, s[16:19], 0 offen offset:128
v_mul_f32_e32 v95, v101, v95
v_add_f32_e32 v76, v100, v95
v_mov_b32_e32 v95, v76
v_cvt_f16_f32_e32 v95, v95
s_mul_i32 s8, s36, 4
s_add_u32 s16, s16, s8
s_addc_u32 s17, s17, 0
buffer_store_b16 v95, v79, s[16:19], 0 offen
v_mul_f32_e32 v96, v103, v96
v_add_f32_e32 v76, v102, v96
v_mov_b32_e32 v96, v76
v_cvt_f16_f32_e32 v96, v96
buffer_store_b16 v96, v79, s[16:19], 0 offen offset:64
v_mul_f32_e32 v97, v99, v97
v_add_f32_e32 v76, v98, v97
v_mov_b32_e32 v97, v76
v_cvt_f16_f32_e32 v97, v97
buffer_store_b16 v97, v79, s[16:19], 0 offen offset:128
s_nop 0
s_endpgm
