.text
.section .text.gemm
.global gemm
.p2align 8
.type gemm,@function

gemm:
label_ASM_Start:
  s_load_dword s28, s[0:1], 0x00   // A_lo
  s_load_dword s29, s[0:1], 0x04   // A_hi
  s_load_dword s30, s[0:1], 0x08   // B_lo
  s_load_dword s31, s[0:1], 0x0c   // B_hi
  s_load_dword s24, s[0:1], 0x10   // D_lo
  s_load_dword s25, s[0:1], 0x14   // D_hi
  s_load_dword s32, s[0:1], 0x18   // AddressWS_lo
  s_load_dword s33, s[0:1], 0x1c   // AddressWS_hi
  s_load_dword s34, s[0:1], 0x20   // AddressFlags_lo
  s_load_dword s35, s[0:1], 0x24   // AddressFlags_hi

  s_load_dword s58, s[0:1], 0x28   // Gemm_info
  s_load_dword s64, s[0:1], 0x2c   // kernel_info0
  s_load_dword s7,  s[0:1], 0x30   // kernel_info1
  s_load_dword s65, s[0:1], 0x34   // numWG

  s_load_dword s20, s[0:1], 0x38   // SizesFree0
  s_load_dword s21, s[0:1], 0x3c   // SizesFree1
  s_load_dword s22, s[0:1], 0x40   // SizesFree2
  s_load_dword s23, s[0:1], 0x44   // SizesSum0

  s_load_dword s36, s[0:1], 0x48   // strideD0
  s_load_dword s37, s[0:1], 0x4c   // strideD1
  s_load_dword s38, s[0:1], 0x50   // strideC0
  s_load_dword s39, s[0:1], 0x54   // strideC1
  s_load_dword s40, s[0:1], 0x58   // strideA0
  s_load_dword s41, s[0:1], 0x5c   // strideA1
  s_load_dword s42, s[0:1], 0x60   // strideB0
  s_load_dword s43, s[0:1], 0x64   // strideB1

  s_load_dword s44, s[0:1], 0x68   // alpha
  s_load_dword s45, s[0:1], 0x6c   // beta

  s_load_dword s46, s[0:1], 0x70   // ItersPerTile
  s_load_dword s47, s[0:1], 0x74   // MagicNumberItersPerTile
  s_load_dword s48, s[0:1], 0x78   // MagicShiftItersPerTile
  s_load_dword s49, s[0:1], 0x7c   // TotalIters
  s_load_dword s50, s[0:1], 0x80   // SKItersPerWG
  s_load_dword s51, s[0:1], 0x84   // skGrid
  s_load_dword s52, s[0:1], 0x88   // skTiles

  s_add_u32 s0, s0, 16
  s_addc_u32 s1, s1, 0
  s_waitcnt lgkmcnt(0)
  s_lshr_b32 s59, s58, 30
  s_and_b32 s6, s64, 0xffff0000
  s_lshr_b32 s6, s6, 16
  s_mov_b32 s5, s59
  s_mov_b32 m0, 0x8400
  v_mov_b32_e32 v124, v0
  s_lshr_b32 s70, s7, 16
  s_ff1_i32_b32 s70, s70
  s_lshr_b32 s71, s7, 22
  s_cmp_gt_i32 s70, 0
  s_cbranch_scc0 label_skip_WGMXCC
  s_lshr_b32 s67, s65, s70
  s_lshl_b32 s67, s67, s70
  s_cmp_ge_u32 s2, s67
  s_cbranch_scc1 label_skip_WGMXCC
  s_cmp_eq_u32 s71, 0
  s_cbranch_scc0 label_XCCG_nonzero
  s_lshr_b32 s67, s2, s70
  s_bfm_b32 s68, s70, 0
  s_and_b32 s68, s2, s68
  s_lshr_b32 s69, s65, s70
  s_mul_i32 s68, s68, s69
  s_add_u32 s2, s67, s68
  s_branch label_skip_WGMXCC
label_XCCG_nonzero:
  v_cvt_f32_u32_e32 v12, s71
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v13, s2
  v_mul_f32_e32 v12, v12, v13
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e64 v13, v12, s71
  v_sub_u32_e32 v13, s2, v13
  v_cmpx_eq_u32_e64 exec, v13, s71
  v_add_u32_e32 v12, 1, v12
  v_mov_b32_e32 v13, 0
  s_mov_b64 exec, -1
  v_cmpx_gt_u32_e64 exec, v13, s71
  v_sub_u32_e64 v12, v12, 1
  v_mul_u32_u24_e64 v13, v12, s71
  v_sub_u32_e32 v13, s2, v13
  s_mov_b64 exec, -1
  v_readfirstlane_b32 s67, v12
  v_readfirstlane_b32 s68, v13
  s_mul_i32 s67, s67, s71
  s_lshr_b32 s68, s68, s70
  s_add_u32 s67, s67, s68
  v_cvt_f32_u32_e32 v12, s71
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v13, s65
  v_mul_f32_e32 v12, v12, v13
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e64 v13, v12, s71
  v_sub_u32_e32 v13, s65, v13
  v_cmpx_eq_u32_e64 exec, v13, s71
  v_add_u32_e32 v12, 1, v12
  s_mov_b64 exec, -1
  v_cmpx_gt_u32_e64 exec, v13, s71
  v_sub_u32_e64 v12, v12, 1
  s_mov_b64 exec, -1
  v_readfirstlane_b32 s68, v12
  s_mul_i32 s68, s68, s71
  s_sub_u32 s69, s65, s68
  s_cmp_gt_u32 s2, s68
  s_cselect_b32 s68, s69, s71
  s_lshr_b32 s68, s68, s70
  s_bfm_b32 s69, s70, 0
  s_and_b32 s69, s2, s69
  s_mul_i32 s68, s68, s69
  s_add_u32 s2, s67, s68
label_skip_WGMXCC:
  s_cmp_eq_u32 s59, 0
  s_cbranch_scc0 label_MultiGemm
  v_mov_b32_e32 v14, 0x80
  v_mov_b32_e32 v13, s20
  v_cvt_f32_u32_e32 v12, v14
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v15, v13
  v_mul_f32_e32 v12, v12, v15
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e32 v15, v12, v14
  v_sub_u32_e32 v15, v13, v15
  v_cmp_ne_u32_e64 vcc, v15, 0
  v_addc_co_u32_e64 v12, vcc, v12, 0, vcc
  v_mov_b32_e32 v14, 0x80
  v_mov_b32_e32 v13, s21
  v_readfirstlane_b32 s10, v12
  v_cvt_f32_u32_e32 v12, v14
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v15, v13
  v_mul_f32_e32 v12, v12, v15
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e32 v15, v12, v14
  v_sub_u32_e32 v15, v13, v15
  v_cmp_ne_u32_e64 vcc, v15, 0
  v_addc_co_u32_e64 v12, vcc, v12, 0, vcc
  s_nop 0
  v_readfirstlane_b32 s11, v12
  s_waitcnt lgkmcnt(0)
  s_branch label_MultiGemmEnd
label_MultiGemm:
  s_cmp_eq_u32 s5, 2
  s_cbranch_scc1 label_IsExternalValid
  s_mov_b32 s11, 0xa8
  s_mul_i32 s70, s58, 4
  s_mov_b64 s[64:65], s[0:1]
  s_branch label_IsExternalValidEnd
label_IsExternalValid:
  s_mov_b32 s11, 0xe0
  s_mov_b32 s70, 0
  s_mov_b64 s[64:65], s[0:1]
label_IsExternalValidEnd:
  s_mov_b32 s10, 1
  s_mov_b32 s71, 0
  s_load_dwordx4 s[20:23], s[64:65], s70
  s_cmpk_eq_u32 s58, 0x1
  s_cbranch_scc1 label_wgTable_noLoadLoop
label_Loop_GemmCount:
  s_waitcnt lgkmcnt(0)
  s_lshr_b32 s68, s20, 7
  s_and_b32 s66, 0x7f, s20
  s_addc_u32 s68, s68, 0
  s_lshr_b32 s69, s21, 7
  s_and_b32 s66, 0x7f, s21
  s_addc_u32 s69, s69, 0
  s_mul_i32 s68, s68, s69
  s_mul_i32 s68, s68, s22
  s_add_u32 s71, s71, s68
  s_cmp_lt_u32 s2, s71
  s_cbranch_scc1 label_FOUND
  s_add_u32 s70, s70, s11
  s_load_dwordx4 s[20:23], s[64:65], s70
  s_add_u32 s10, s10, 1
  s_cmp_lt_u32 s10, s58
  s_cbranch_scc1 label_Loop_GemmCount
label_wgTable_noLoadLoop:
  s_waitcnt lgkmcnt(0)
  s_lshr_b32 s68, s20, 7
  s_and_b32 s66, 0x7f, s20
  s_addc_u32 s68, s68, 0
  s_lshr_b32 s69, s21, 7
  s_and_b32 s66, 0x7f, s21
  s_addc_u32 s69, s69, 0
  s_mul_i32 s68, s68, s69
  s_mul_i32 s68, s68, s22
  s_add_u32 s71, s71, s68
label_FOUND:
  s_sub_u32 s65, s10, 1
  s_sub_u32 s64, s71, s68
  s_sub_u32 s2, s2, s64
  s_cmp_eq_u32 s5, 2
  s_cbranch_scc1 label_LoadExternalStruct
  s_lshl2_add_u32 s0, s58, s0
  s_addc_u32 s1, s1, 0
  s_mul_i32 s65, s65, 0xa8
  s_add_u32 s0, s0, s65
  s_addc_u32 s1, s1, 0
  s_load_dwordx16 s[24:39], s[0:1], 0x10
  s_load_dwordx8 s[40:47], s[0:1], 0x50
  s_load_dwordx4 s[48:51], s[0:1], 0x70
  s_load_dword s52, s[0:1], 0x80
  s_branch label_LoadExternalStructEnd
label_LoadExternalStruct:
  s_mul_i32 s65, s65, 0xe0
  s_add_u32 s0, s0, s65
  s_addc_u32 s1, s1, 0
  s_load_dwordx16 s[24:39], s[0:1], 0x10
  s_load_dwordx8 s[40:47], s[0:1], 0x50
  s_load_dwordx4 s[48:51], s[0:1], 0x70
  s_load_dword s45, s[0:1], 0x8c
label_LoadExternalStructEnd:
  v_mov_b32_e32 v14, 0x80
  v_mov_b32_e32 v13, s20
  v_cvt_f32_u32_e32 v12, v14
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v15, v13
  v_mul_f32_e32 v12, v12, v15
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e32 v15, v12, v14
  v_sub_u32_e32 v15, v13, v15
  v_cmp_ne_u32_e64 vcc, v15, 0
  v_addc_co_u32_e64 v12, vcc, v12, 0, vcc
  v_mov_b32_e32 v14, 0x80
  v_mov_b32_e32 v13, s21
  v_readfirstlane_b32 s10, v12
  v_cvt_f32_u32_e32 v12, v14
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v15, v13
  v_mul_f32_e32 v12, v12, v15
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e32 v15, v12, v14
  v_sub_u32_e32 v15, v13, v15
  v_cmp_ne_u32_e64 vcc, v15, 0
  v_addc_co_u32_e64 v12, vcc, v12, 0, vcc
  s_nop 0
  v_readfirstlane_b32 s11, v12
  s_waitcnt lgkmcnt(0)
  s_cmp_eq_u32 s21, 0
  s_cbranch_scc0 label_MultiGemmEnd
label_EarlyStop_if_N_is_0:
  s_endpgm
label_MultiGemmEnd:
label_NoEarlyStop_N0:
  s_mov_b32 s81, 0x5040100
  s_mov_b32 s82, 0x7060302
  s_sub_u32 s28, s28, 16
  s_subb_u32 s29, s29, 0
  s_sub_u32 s30, s30, 16
  s_subb_u32 s31, s31, 0
  v_cmp_eq_f32_e64 vcc, s44, 0
  s_cbranch_vccz label_AlphaNonZero
  s_mov_b32 s23, 0
label_AlphaNonZero:
  s_add_u32 s85, s51, 7
  s_lshr_b32 s85, s85, 3
  s_lshr_b32 s86, s51, 3
  s_and_b32 s87, 7, s51
  s_and_b32 s84, 7, s2
  s_cmp_lt_u32 s84, s87
  s_cselect_b32 s85, s85, s86
  s_cselect_b32 s87, 0, s87
  s_lshr_b32 s2, s2, 3
  s_mul_i32 s84, s84, s85
  s_add_u32 s2, s2, s84
  s_add_u32 s2, s2, s87
  s_mov_b32 s53, s2
  s_cmp_eq_u64 s[34:35], 0
  s_cbranch_scc0 label_SK_SplitInit
  v_cvt_f32_u32_e32 v12, s52
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v13, s53
  v_mul_f32_e32 v12, v12, v13
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e64 v13, v12, s52
  v_sub_u32_e32 v13, s53, v13
  v_cmpx_eq_u32_e64 exec, v13, s52
  v_add_u32_e32 v12, 1, v12
  v_mov_b32_e32 v13, 0
  s_mov_b64 exec, -1
  v_cmpx_gt_u32_e64 exec, v13, s52
  v_sub_u32_e64 v12, v12, 1
  v_mul_u32_u24_e64 v13, v12, s52
  v_sub_u32_e32 v13, s53, v13
  s_mov_b64 exec, -1
  v_readfirstlane_b32 s83, v12
  v_readfirstlane_b32 s84, v13
  s_mul_i32 s85, s52, s50
  s_sub_u32 s85, s46, s85
  s_mul_i32 s54, s84, s50
  s_cmp_lt_u32 s84, s85
  s_cbranch_scc1 label_SK_HasExtra
  s_add_u32 s54, s54, s85
  s_add_u32 s55, s54, s50
  s_branch label_SK_DoneExtra
label_SK_HasExtra:
  s_add_u32 s54, s54, s84
  s_add_u32 s55, s54, s50
  s_add_u32 s55, s55, 1
label_SK_DoneExtra:
  s_mul_i32 s83, s83, s46
  s_add_u32 s54, s54, s83
  s_add_u32 s55, s55, s83
  s_mov_b32 s45, s84
  s_branch label_SK_InitDone
label_SK_SplitInit:
  s_mul_i32 s54, s53, s46
  s_mov_b32 s55, s49
  s_mul_i32 s83, s52, s46
  s_cmp_lt_u32 s83, s49
  s_cbranch_scc1 label_SK_InitDone
  s_mul_i32 s83, s52, s46
  s_mul_i32 s84, s50, s51
  s_sub_u32 s83, s83, s84
  s_mul_i32 s54, s53, s50
  s_add_u32 s54, s54, s83
  s_add_u32 s55, s54, s50
  s_add_u32 s85, s50, 1
  s_mul_i32 s84, s53, s85
  s_add_u32 s85, s84, s85
  s_cmp_lt_u32 s53, s83
  s_cselect_b32 s54, s84, s54
  s_cselect_b32 s55, s85, s55
  s_mul_i32 s83, s52, s46
  s_min_u32 s55, s55, s83
label_SK_InitDone:
  s_cmp_lt_u32 s54, s49
  s_cbranch_scc1 label_NoBranch_CHYJCRWXZZ776U5R
  s_getpc_b64 s[84:85]
  s_add_i32 s86, 0xe64c, 4
  s_add_u32 s84, s84, s86
  s_addc_u32 s85, s85, 0
  s_setpc_b64 s[84:85]
label_NoBranch_CHYJCRWXZZ776U5R:
label_PersistentLoopStart:
  s_mul_hi_u32 s85, s54, s47
  s_lshr_b32 s86, s48, 31
  s_mul_i32 s84, s54, s86
  s_add_u32 s84, s84, s85
  s_and_b32 s86, s48, 0x7fffffff
  s_lshr_b32 s84, s84, s86
  s_mul_i32 s85, s84, s46
  s_add_u32 s86, s85, s46
  s_sub_u32 s56, s54, s85
  s_min_u32 s57, s55, s86
  s_sub_u32 s57, s57, s85
  s_cmp_eq_u64 s[34:35], 0
  s_cbranch_scc0 label_SK_SplitUpdate
  s_mov_b32 s85, s55
  s_branch label_NoBranch_LMQ4JS78HK6E4HB8
label_SK_SplitUpdate:
  s_mul_i32 s87, s52, s46
  s_sub_u32 s87, s49, s87
  s_mul_i32 s85, s51, s46
  s_add_u32 s85, s85, s54
  s_cmp_lt_u32 s85, s87
  s_cbranch_scc1 label_NoBranch_LMQ4JS78HK6E4HB8
  s_mov_b32 s85, s86
  s_cmp_le_u32 s87, s54
  s_cbranch_scc1 label_NoBranch_LMQ4JS78HK6E4HB8
  s_mul_i32 s83, s52, s46
  s_mul_i32 s88, s50, s51
  s_sub_u32 s83, s83, s88
  s_mul_i32 s54, s53, s50
  s_add_u32 s54, s54, s83
  s_add_u32 s55, s54, s50
  s_add_u32 s89, s50, 1
  s_mul_i32 s88, s53, s89
  s_add_u32 s89, s88, s89
  s_cmp_lt_u32 s53, s83
  s_cselect_b32 s54, s88, s54
  s_cselect_b32 s55, s89, s55
  s_add_u32 s85, s54, s87
  s_add_u32 s55, s55, s87
  s_min_u32 s55, s55, s49
  s_cmp_lt_u32 s54, s49
  s_cbranch_scc1 label_NoBranch_LMQ4JS78HK6E4HB8
  s_getpc_b64 s[88:89]
  s_add_i32 s90, 0xe58c, 4
  s_add_u32 s88, s88, s90
  s_addc_u32 s89, s89, 0
  s_setpc_b64 s[88:89]
label_SK_UpdateDone:
label_NoBranch_LMQ4JS78HK6E4HB8:
  s_mov_b32 s54, s85
  s_mul_i32 s85, s10, s11
  v_cvt_f32_u32_e32 v12, s85
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v13, s84
  v_mul_f32_e32 v12, v12, v13
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e64 v13, v12, s85
  v_sub_u32_e32 v13, s84, v13
  v_cmpx_eq_u32_e64 exec, v13, s85
  v_add_u32_e32 v12, 1, v12
  v_mov_b32_e32 v13, 0
  s_mov_b64 exec, -1
  v_cmpx_gt_u32_e64 exec, v13, s85
  v_sub_u32_e64 v12, v12, 1
  v_mul_u32_u24_e64 v13, v12, s85
  v_sub_u32_e32 v13, s84, v13
  s_mov_b64 exec, -1
  v_readfirstlane_b32 s4, v12
  v_readfirstlane_b32 s86, v13
  v_cvt_f32_u32_e32 v12, s10
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v13, s86
  v_mul_f32_e32 v12, v12, v13
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e64 v13, v12, s10
  v_sub_u32_e32 v13, s86, v13
  v_cmpx_eq_u32_e64 exec, v13, s10
  v_add_u32_e32 v12, 1, v12
  v_mov_b32_e32 v13, 0
  s_mov_b64 exec, -1
  v_cmpx_gt_u32_e64 exec, v13, s10
  v_sub_u32_e64 v12, v12, 1
  v_mul_u32_u24_e64 v13, v12, s10
  v_sub_u32_e32 v13, s86, v13
  s_mov_b64 exec, -1
  v_readfirstlane_b32 s3, v12
  v_readfirstlane_b32 s2, v13
  v_cmp_eq_f32_e64 vcc, s44, 0
  s_cbranch_vccz label_SKAlphaCheck
  s_cmp_eq_u32 s56, 0
  s_cbranch_scc1 label_NoBranch_FGAOY7NMHZQR6R6P
  s_getpc_b64 s[88:89]
  s_add_i32 s90, 0xe47c, 4
  s_add_u32 s88, s88, s90
  s_addc_u32 s89, s89, 0
  s_setpc_b64 s[88:89]
label_NoBranch_FGAOY7NMHZQR6R6P:
  s_mov_b32 s57, s46
label_SKAlphaCheck:
  s_sext_i32_i16 s7, s7
  s_cmp_gt_i32 s7, 1
  s_cbranch_scc1 label_WGMPositive
  s_cmp_ge_i32 s7, 0
  s_cbranch_scc1 label_WGM
  s_abs_i32 s87, s7
  v_cvt_f32_u32_e32 v12, s87
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v13, s2
  v_mul_f32_e32 v12, v12, v13
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e64 v13, v12, s87
  v_sub_u32_e32 v13, s2, v13
  v_cmpx_eq_u32_e64 exec, v13, s87
  v_add_u32_e32 v12, 1, v12
  s_mov_b64 exec, -1
  v_cmpx_gt_u32_e64 exec, v13, s87
  v_sub_u32_e64 v12, v12, 1
  s_mov_b64 exec, -1
  v_readfirstlane_b32 s83, v12
  s_mul_i32 s86, s83, s87
  s_sub_u32 s86, s2, s86
  s_mul_i32 s86, s86, s11
  s_add_u32 s86, s86, s3
  v_cvt_f32_u32_e32 v12, s87
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v13, s10
  v_mul_f32_e32 v12, v12, v13
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e64 v13, v12, s87
  v_sub_u32_e32 v13, s10, v13
  v_cmpx_eq_u32_e64 exec, v13, s87
  v_add_u32_e32 v12, 1, v12
  s_mov_b64 exec, -1
  v_cmpx_gt_u32_e64 exec, v13, s87
  v_sub_u32_e64 v12, v12, 1
  s_mov_b64 exec, -1
  v_readfirstlane_b32 s84, v12
  s_mul_i32 s85, s87, s84
  s_sub_u32 s85, s10, s85
  s_cmp_eq_u32 s85, 0
  s_cmov_b32 s85, s87
  s_cmp_ge_u32 s83, s84
  s_cselect_b32 s84, s85, s87
  v_cvt_f32_u32_e32 v12, s84
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v13, s86
  v_mul_f32_e32 v12, v12, v13
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e64 v13, v12, s84
  v_sub_u32_e32 v13, s86, v13
  v_cmpx_eq_u32_e64 exec, v13, s84
  v_add_u32_e32 v12, 1, v12
  v_mov_b32_e32 v13, 0
  s_mov_b64 exec, -1
  v_cmpx_gt_u32_e64 exec, v13, s84
  v_sub_u32_e64 v12, v12, 1
  v_mul_u32_u24_e64 v13, v12, s84
  v_sub_u32_e32 v13, s86, v13
  s_mov_b64 exec, -1
  v_readfirstlane_b32 s3, v12
  v_readfirstlane_b32 s2, v13
  s_mul_i32 s2, s3, s84
  s_sub_u32 s2, s86, s2
  s_mul_i32 s83, s83, s87
  s_add_u32 s2, s2, s83
  s_branch label_WGM
label_WGMPositive:
  s_mov_b32 s87, s7
  v_cvt_f32_u32_e32 v12, s87
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v13, s3
  v_mul_f32_e32 v12, v12, v13
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e64 v13, v12, s87
  v_sub_u32_e32 v13, s3, v13
  v_cmpx_eq_u32_e64 exec, v13, s87
  v_add_u32_e32 v12, 1, v12
  s_mov_b64 exec, -1
  v_cmpx_gt_u32_e64 exec, v13, s87
  v_sub_u32_e64 v12, v12, 1
  s_mov_b64 exec, -1
  v_readfirstlane_b32 s83, v12
  s_mul_i32 s86, s83, s87
  s_sub_u32 s86, s3, s86
  s_mul_i32 s86, s86, s10
  s_add_u32 s86, s86, s2
  v_cvt_f32_u32_e32 v12, s87
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v13, s11
  v_mul_f32_e32 v12, v12, v13
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e64 v13, v12, s87
  v_sub_u32_e32 v13, s11, v13
  v_cmpx_eq_u32_e64 exec, v13, s87
  v_add_u32_e32 v12, 1, v12
  s_mov_b64 exec, -1
  v_cmpx_gt_u32_e64 exec, v13, s87
  v_sub_u32_e64 v12, v12, 1
  s_mov_b64 exec, -1
  v_readfirstlane_b32 s84, v12
  s_mul_i32 s85, s87, s84
  s_sub_u32 s85, s11, s85
  s_cmp_eq_u32 s85, 0
  s_cmov_b32 s85, s87
  s_cmp_ge_u32 s83, s84
  s_cselect_b32 s84, s85, s87
  v_cvt_f32_u32_e32 v12, s84
  v_rcp_iflag_f32_e32 v12, v12
  v_cvt_f32_u32_e32 v13, s86
  v_mul_f32_e32 v12, v12, v13
  v_cvt_u32_f32_e32 v12, v12
  v_mul_u32_u24_e64 v13, v12, s84
  v_sub_u32_e32 v13, s86, v13
  v_cmpx_eq_u32_e64 exec, v13, s84
  v_add_u32_e32 v12, 1, v12
  v_mov_b32_e32 v13, 0
  s_mov_b64 exec, -1
  v_cmpx_gt_u32_e64 exec, v13, s84
  v_sub_u32_e64 v12, v12, 1
  v_mul_u32_u24_e64 v13, v12, s84
  v_sub_u32_e32 v13, s86, v13
  s_mov_b64 exec, -1
  v_readfirstlane_b32 s2, v12
  v_readfirstlane_b32 s3, v13
  s_mul_i32 s3, s2, s84
  s_sub_u32 s3, s86, s3
  s_mul_i32 s83, s83, s87
  s_add_u32 s3, s3, s83
label_WGM:
  v_and_b32_e32 v13, 63, v124
  v_and_b32_e32 v12, 15, v13
  v_lshlrev_b32_e32 v12, 2, v12
  v_lshrrev_b32_e32 v13, 4, v13
  v_lshl_add_u32 v12, v13, 10, v12
  v_lshrrev_b32_e32 v16, 6, v124
  v_and_b32_e32 v16, 1, v16
  v_lshl_add_u32 v12, v16, 6, v12
  v_and_b32_e32 v14, 63, v124
  v_and_b32_e32 v13, 15, v14
  v_lshlrev_b32_e32 v13, 6, v13
  v_lshlrev_b32_e32 v13, 2, v13
  v_lshrrev_b32_e32 v14, 4, v14
  v_lshl_add_u32 v13, v14, 3, v13
  v_lshrrev_b32_e32 v15, 7, v124
  v_and_b32_e32 v15, 1, v15
  v_lshl_add_u32 v13, v15, 12, v13
  v_lshrrev_b32_e32 v14, 6, v124
  v_lshrrev_b32_e32 v14, 2, v14
  s_mov_b32 s83, 0x2000
  v_mul_lo_u32 v14, s83, v14
  v_add_lshl_u32 v10, v14, v12, 1
  v_lshrrev_b32_e32 v12, 6, v124
  v_lshrrev_b32_e32 v12, 2, v12
  s_mov_b32 s83, 64
  v_mul_lo_u32 v12, s83, v12
  v_add_lshl_u32 v11, v12, v13, 1
  v_lshrrev_b32_e32 v14, 9, v11
  v_lshl_add_u32 v11, v14, 5, v11
  v_add_co_u32_e32 v11, vcc, 0x4000, v11
  v_lshrrev_b32_e32 v13, 4, v124
  v_and_b32_e32 v12, 15, v124
  v_lshlrev_b32_e32 v12, 3, v12
  v_mov_b32_e32 v16, v13
  v_lshrrev_b32_e32 v14, 3, v124
  v_and_b32_e32 v15, 7, v124
  v_lshlrev_b32_e32 v15, 3, v15
  v_mov_b32_e32 v17, v15
  v_mul_u32_u24_e32 v8, 0x80, v16
  v_add_lshl_u32 v8, v12, v8, 1
  v_mul_u32_u24_e32 v9, 64, v14
  v_add_lshl_u32 v9, v17, v9, 1
  v_lshrrev_b32_e32 v18, 9, v9
  v_lshl_add_u32 v9, v18, 5, v9
  v_add_co_u32_e32 v9, vcc, 0x4000, v9
  v_mov_b32_e32 v18, v12
  v_mov_b32_e32 v19, v14
  v_add_co_u32_e32 v20, vcc, 32, v19
  v_add_co_u32_e32 v21, vcc, 32, v20
  v_add_co_u32_e32 v22, vcc, 32, v21
  v_mov_b32_e32 v23, v13
  v_add_co_u32_e32 v24, vcc, 16, v23
  v_add_co_u32_e32 v25, vcc, 16, v24
  v_add_co_u32_e32 v26, vcc, 16, v25
  v_mov_b32_e32 v27, v15
  s_mul_i32 s83, s2, 0x80
  s_sub_u32 s83, s20, s83
  s_sub_u32 s83, s83, 8
  v_mov_b32_e32 v28, s83
  v_min_i32_e32 v18, v28, v18
  v_mul_lo_u32 v28, s40, v23
  v_add_co_u32_e32 v0, vcc, v18, v28
  v_add_u32_e32 v0, 8, v0
  v_lshlrev_b32_e32 v0, 1, v0
  v_mul_lo_u32 v28, s40, v24
  v_add_co_u32_e32 v1, vcc, v18, v28
  v_add_u32_e32 v1, 8, v1
  v_lshlrev_b32_e32 v1, 1, v1
  v_mul_lo_u32 v28, s40, v25
  v_add_co_u32_e32 v2, vcc, v18, v28
  v_add_u32_e32 v2, 8, v2
  v_lshlrev_b32_e32 v2, 1, v2
  v_mul_lo_u32 v28, s40, v26
  v_add_co_u32_e32 v3, vcc, v18, v28
  v_add_u32_e32 v3, 8, v3
  v_lshlrev_b32_e32 v3, 1, v3
  v_mul_lo_u32 v23, s42, v19
  v_add_co_u32_e32 v4, vcc, v27, v23
  v_add_u32_e32 v4, 8, v4
  v_lshlrev_b32_e32 v4, 1, v4
  v_mul_lo_u32 v23, s42, v20
  v_add_co_u32_e32 v5, vcc, v27, v23
  v_add_u32_e32 v5, 8, v5
  v_lshlrev_b32_e32 v5, 1, v5
  v_mul_lo_u32 v23, s42, v21
  v_add_co_u32_e32 v6, vcc, v27, v23
  v_add_u32_e32 v6, 8, v6
  v_lshlrev_b32_e32 v6, 1, v6
  v_mul_lo_u32 v23, s42, v22
  v_add_co_u32_e32 v7, vcc, v27, v23
  v_add_u32_e32 v7, 8, v7
  v_lshlrev_b32_e32 v7, 1, v7
  s_mul_hi_u32 s87, s2, 0x80
  s_mul_i32 s86, s2, 0x80
  s_mul_i32 s84, s56, 64
  s_mul_hi_u32 s85, s84, s40
  s_mul_i32 s84, s84, s40
  s_add_u32 s86, s86, s84
  s_addc_u32 s87, s87, s85
  s_mov_b64 s[58:59], 1
  s_sub_u32 s84, s20, 1
  s_mul_hi_u32 s85, 1, s84
  s_mul_i32 s84, 1, s84
  s_add_u32 s58, s58, s84
  s_addc_u32 s59, s59, s85
  s_sub_u32 s84, s23, 1
  s_mul_hi_u32 s85, s40, s84
  s_mul_i32 s84, s40, s84
  s_add_u32 s58, s58, s84
  s_addc_u32 s59, s59, s85
  s_sub_u32 s58, s58, s86
  s_subb_u32 s59, s59, s87
  s_lshl_b64 s[58:59], s[58:59], 1
  s_add_u32 s58, s58, 16
  s_addc_u32 s59, s59, 0
  s_cmp_eq_u32 s59, 0
  s_cselect_b32 s66, s58, -1
  s_mul_hi_u32 s85, s41, s4
  s_mul_i32 s84, s41, s4
  s_add_u32 s86, s86, s84
  s_addc_u32 s87, s87, s85
  s_lshl_b64 s[86:87], s[86:87], 1
  s_add_u32 s64, s28, s86
  s_addc_u32 s65, s29, s87
  s_mov_b32 s67, 0x20000
  s_mul_hi_u32 s87, s3, 0x80
  s_mul_i32 s86, s3, 0x80
  s_mul_hi_u32 s87, s86, s42
  s_mul_i32 s86, s86, s42
  s_mul_i32 s84, s56, 64
  s_mul_hi_u32 s85, s84, 1
  s_mul_i32 s84, s84, 1
  s_add_u32 s86, s86, s84
  s_addc_u32 s87, s87, s85
  s_mov_b64 s[72:73], 1
  s_sub_u32 s84, s23, 1
  s_mul_hi_u32 s85, 1, s84
  s_mul_i32 s84, 1, s84
  s_add_u32 s72, s72, s84
  s_addc_u32 s73, s73, s85
  s_sub_u32 s84, s21, 1
  s_mul_hi_u32 s85, s42, s84
  s_mul_i32 s84, s42, s84
  s_add_u32 s72, s72, s84
  s_addc_u32 s73, s73, s85
  s_sub_u32 s72, s72, s86
  s_subb_u32 s73, s73, s87
  s_lshl_b64 s[72:73], s[72:73], 1
  s_add_u32 s72, s72, 16
  s_addc_u32 s73, s73, 0
  s_cmp_eq_u32 s73, 0
  s_cselect_b32 s70, s72, -1
  s_mul_hi_u32 s85, s43, s4
  s_mul_i32 s84, s43, s4
  s_add_u32 s86, s86, s84
  s_addc_u32 s87, s87, s85
  s_lshl_b64 s[86:87], s[86:87], 1
  s_add_u32 s68, s30, s86
  s_addc_u32 s69, s31, s87
  s_mov_b32 s71, 0x20000
  s_mul_i32 s79, 0x80, s40
  s_mov_b32 s80, 0x80
  s_sub_u32 s8, s57, s56
  v_cmp_eq_f32_e64 vcc, s44, 0
  s_cbranch_vccz label_SKAlphaCheck2
  s_mov_b32 s8, 0
label_SKAlphaCheck2:
  s_and_b32 s85, 63, s23
  s_cmp_eq_u32 s85, 0
  s_cselect_b32 s84, 0, 1
  s_cmp_eq_u32 s57, s46
  s_cselect_b32 s84, s84, 0
  s_sub_u32 s8, s8, s84
  s_mov_b32 s9, s8
  s_and_b32 s86, s6, 0x1f00
  s_lshr_b32 s86, s86, 8
  s_and_b32 s87, s6, 0xe000
  s_and_b32 s6, s6, 0xff
  s_mov_b32 s84, s6
label_beginStaggerUIter:
  s_lshl_b32 s85, s84, s86
  s_cmp_ge_u32 s9, s85
  s_cbranch_scc1 label_endStaggerUIter
  s_lshr_b32 s84, s84, 1
  s_branch label_beginStaggerUIter
label_endStaggerUIter:
  s_sub_u32 s85, s84, 1
  s_cmp_ge_u32 s84, 1
  s_cselect_b32 s74, s85, 0
  s_cmp_eq_u32 s87, 0
  s_cbranch_scc1 label_StaggerUMapping_1
  s_mov_b32 s84, s2
  s_branch label_staggerInputEnd
label_StaggerUMapping_1:
  s_cmp_eq_u32 s87, 0x2000
  s_cbranch_scc1 label_StaggerUMapping_2
  s_mov_b32 s84, s3
  s_branch label_staggerInputEnd
label_StaggerUMapping_2:
  s_cmp_eq_u32 s87, 0x4000
  s_cbranch_scc1 label_StaggerUMapping_3
  s_mov_b32 s84, -1
  s_branch label_staggerInputEnd
label_StaggerUMapping_3:
  s_cmp_eq_u32 s87, 0x6000
  s_cbranch_scc1 label_StaggerUMapping_4
  s_mul_i32 s85, s10, s3
  s_add_u32 s84, s84, s85
  s_add_u32 s84, s84, s2
  s_branch label_staggerInputEnd
label_StaggerUMapping_4:
  s_cmp_eq_u32 s87, 0x8000
  s_cbranch_scc1 label_staggerInputEnd
  s_mov_b32 s84, -1
  s_branch label_staggerInputEnd
label_staggerInputEnd:
  s_and_b32 s74, s74, s84
  s_lshl_b32 s74, s74, s86
  s_cmp_gt_u32 s56, 0
  s_cmov_b32 s74, 0
  s_cmp_lt_u32 s57, s46
  s_cmov_b32 s74, 0
  s_mul_hi_i32 s85, s74, s79
  s_mul_i32 s84, s74, s79
  s_mul_hi_i32 s76, s8, s79
  s_mul_i32 s75, s8, s79
  s_sub_u32 s75, s79, s75
  s_subb_u32 s76, 0, s76
  s_add_u32 s64, s64, s84
  s_addc_u32 s65, s65, s85
  s_sub_u32 s58, s58, s84
  s_subb_u32 s59, s59, s85
  s_cmp_eq_u32 s59, 0
  s_cselect_b32 s66, s58, -1
  s_mul_hi_i32 s85, s74, s80
  s_mul_i32 s84, s74, s80
  s_mul_hi_i32 s78, s8, s80
  s_mul_i32 s77, s8, s80
  s_sub_u32 s77, s80, s77
  s_subb_u32 s78, 0, s78
  s_add_u32 s68, s68, s84
  s_addc_u32 s69, s69, s85
  s_sub_u32 s72, s72, s84
  s_subb_u32 s73, s73, s85
  s_cmp_eq_u32 s73, 0
  s_cselect_b32 s70, s72, -1
  s_add_u32 s74, s74, 2
  s_cmp_eq_u32 s8, 0
  s_cbranch_scc1 label_ShadowInitStart
  buffer_load_dwordx4 v[92:95], v0, s[64:67], 0 offen
  buffer_load_dwordx4 v[96:99], v1, s[64:67], 0 offen
  buffer_load_dwordx4 v[100:103], v2, s[64:67], 0 offen
  buffer_load_dwordx4 v[104:107], v3, s[64:67], 0 offen
  buffer_load_dwordx4 v[108:111], v4, s[68:71], 0 offen
  buffer_load_dwordx4 v[112:115], v5, s[68:71], 0 offen
  buffer_load_dwordx4 v[116:119], v6, s[68:71], 0 offen
  buffer_load_dwordx4 v[120:123], v7, s[68:71], 0 offen
  s_add_u32 s86, s8, 1
  s_cmp_eq_u32 s74, s86
  s_cselect_b32 s84, s75, s79
  s_cselect_b32 s85, s76, 0
  s_add_u32 s64, s64, s84
  s_addc_u32 s65, s65, s85
  s_sub_u32 s58, s58, s84
  s_subb_u32 s59, s59, s85
  s_cmp_eq_u32 s59, 0
  s_cselect_b32 s66, s58, -1
  s_add_u32 s86, s8, 1
  s_cmp_eq_u32 s74, s86
  s_cselect_b32 s84, s77, s80
  s_cselect_b32 s85, s78, 0
  s_add_u32 s68, s68, s84
  s_addc_u32 s69, s69, s85
  s_sub_u32 s72, s72, s84
  s_subb_u32 s73, s73, s85
  s_cmp_eq_u32 s73, 0
  s_cselect_b32 s70, s72, -1
label_ShadowInitStart:
  s_mov_b64 s[12:13], s[24:25]
  s_mov_b32 s14, 0x80000000
  s_mov_b32 s15, 0x20000
  s_mov_b64 s[16:17], s[26:27]
  s_mov_b32 s18, 0x80000000
  s_mov_b32 s19, 0x20000
  s_mov_b32 s83, 1
  s_mov_b32 s84, 1
  s_cmp_eq_u64 s[34:35], 0
  s_cbranch_scc0 label_BPEDone
  s_cmp_eq_u32 s52, 1
  s_cbranch_scc1 label_BPEDone
  s_mov_b32 s83, 1
  s_mov_b32 s84, 2
label_BPEDone:
  s_mul_i32 s88, 0x80, s3
  s_mul_hi_u32 s87, s88, s38
  s_mul_i32 s86, s88, s38
  s_lshl_b64 s[86:87], s[86:87], s83
  s_add_u32 s16, s26, s86
  s_addc_u32 s17, s27, s87
  s_mul_hi_u32 s87, s88, s36
  s_mul_i32 s86, s88, s36
  s_lshl_b64 s[86:87], s[86:87], s84
  s_add_u32 s12, s24, s86
  s_addc_u32 s13, s25, s87
  s_mul_hi_u32 s87, s4, s39
  s_mul_i32 s86, s4, s39
  s_lshl_b64 s[86:87], s[86:87], s83
  s_add_u32 s16, s16, s86
  s_addc_u32 s17, s17, s87
  s_mul_hi_u32 s87, s4, s37
  s_mul_i32 s86, s4, s37
  s_lshl_b64 s[86:87], s[86:87], s84
  s_add_u32 s12, s12, s86
  s_addc_u32 s13, s13, s87
  s_cmp_eq_u64 s[34:35], 0
  s_cbranch_scc0 label_SK_SplitSrd
  s_cmp_eq_u32 s52, 1
  s_cbranch_scc1 label_SK_SplitSrd
  s_mul_hi_u32 s87, s20, s45
  s_mul_i32 s86, s20, s45
  s_sub_u32 s85, s21, 1
  s_mul_i32 s85, s85, s45
  s_mul_hi_u32 s88, s85, s38
  s_mul_i32 s85, s85, s38
  s_add_u32 s86, s86, s85
  s_addc_u32 s87, s87, s88
  s_sub_u32 s85, s22, 1
  s_mul_i32 s85, s85, s45
  s_mul_hi_u32 s88, s85, s39
  s_mul_i32 s85, s85, s39
  s_add_u32 s86, s86, s85
  s_addc_u32 s87, s87, s88
  s_lshl_b64 s[86:87], s[86:87], 2
  s_add_u32 s12, s12, s86
  s_addc_u32 s13, s13, s87
label_SK_SplitSrd:
  v_accvgpr_write_b32 a0, 0
  v_accvgpr_write_b32 a1, 0
  v_accvgpr_write_b32 a2, 0
  v_accvgpr_write_b32 a3, 0
  v_accvgpr_write_b32 a4, 0
  v_accvgpr_write_b32 a5, 0
  v_accvgpr_write_b32 a6, 0
  v_accvgpr_write_b32 a7, 0
  v_accvgpr_write_b32 a8, 0
  v_accvgpr_write_b32 a9, 0
  v_accvgpr_write_b32 a10, 0
  v_accvgpr_write_b32 a11, 0
  v_accvgpr_write_b32 a12, 0
  v_accvgpr_write_b32 a13, 0
  v_accvgpr_write_b32 a14, 0
  v_accvgpr_write_b32 a15, 0
  v_accvgpr_write_b32 a16, 0
  v_accvgpr_write_b32 a17, 0
  v_accvgpr_write_b32 a18, 0
  v_accvgpr_write_b32 a19, 0
  v_accvgpr_write_b32 a20, 0
  v_accvgpr_write_b32 a21, 0
  v_accvgpr_write_b32 a22, 0
  v_accvgpr_write_b32 a23, 0
  v_accvgpr_write_b32 a24, 0
  v_accvgpr_write_b32 a25, 0
  v_accvgpr_write_b32 a26, 0
  v_accvgpr_write_b32 a27, 0
  v_accvgpr_write_b32 a28, 0
  v_accvgpr_write_b32 a29, 0
  v_accvgpr_write_b32 a30, 0
  v_accvgpr_write_b32 a31, 0
  v_accvgpr_write_b32 a32, 0
  v_accvgpr_write_b32 a33, 0
  v_accvgpr_write_b32 a34, 0
  v_accvgpr_write_b32 a35, 0
  v_accvgpr_write_b32 a36, 0
  v_accvgpr_write_b32 a37, 0
  v_accvgpr_write_b32 a38, 0
  v_accvgpr_write_b32 a39, 0
  v_accvgpr_write_b32 a40, 0
  v_accvgpr_write_b32 a41, 0
  v_accvgpr_write_b32 a42, 0
  v_accvgpr_write_b32 a43, 0
  v_accvgpr_write_b32 a44, 0
  v_accvgpr_write_b32 a45, 0
  v_accvgpr_write_b32 a46, 0
  v_accvgpr_write_b32 a47, 0
  v_accvgpr_write_b32 a48, 0
  v_accvgpr_write_b32 a49, 0
  v_accvgpr_write_b32 a50, 0
  v_accvgpr_write_b32 a51, 0
  v_accvgpr_write_b32 a52, 0
  v_accvgpr_write_b32 a53, 0
  v_accvgpr_write_b32 a54, 0
  v_accvgpr_write_b32 a55, 0
  v_accvgpr_write_b32 a56, 0
  v_accvgpr_write_b32 a57, 0
  v_accvgpr_write_b32 a58, 0
  v_accvgpr_write_b32 a59, 0
  v_accvgpr_write_b32 a60, 0
  v_accvgpr_write_b32 a61, 0
  v_accvgpr_write_b32 a62, 0
  v_accvgpr_write_b32 a63, 0
  s_cmp_eq_u32 s8, 0
  s_cbranch_scc0 label_NoBranch_4ZU9C71JCHH8ED32
  s_getpc_b64 s[84:85]
  s_add_i32 s86, 0xaf8, 4
  s_add_u32 s84, s84, s86
  s_addc_u32 s85, s85, 0
  s_setpc_b64 s[84:85]
label_NoBranch_4ZU9C71JCHH8ED32:
  s_waitcnt vmcnt(0)
  s_barrier
  ds_write_b128 v8, v[92:95]
  ds_write_b128 v8, v[96:99] offset:4096
  ds_write_b128 v8, v[100:103] offset:8192
  ds_write_b128 v8, v[104:107] offset:12288
  ds_write_b128 v9, v[108:111]
  ds_write_b128 v9, v[112:115] offset:4352
  ds_write_b128 v9, v[116:119] offset:8704
  ds_write_b128 v9, v[120:123] offset:13056
  s_cmp_eq_u32 s8, 1
  s_cbranch_scc1 label_skipPGR2
  buffer_load_dwordx4 v[92:95], v0, s[64:67], 0 offen
  buffer_load_dwordx4 v[96:99], v1, s[64:67], 0 offen
  buffer_load_dwordx4 v[100:103], v2, s[64:67], 0 offen
  buffer_load_dwordx4 v[104:107], v3, s[64:67], 0 offen
  buffer_load_dwordx4 v[108:111], v4, s[68:71], 0 offen
  buffer_load_dwordx4 v[112:115], v5, s[68:71], 0 offen
  buffer_load_dwordx4 v[116:119], v6, s[68:71], 0 offen
  buffer_load_dwordx4 v[120:123], v7, s[68:71], 0 offen
label_skipPGR2:
  s_waitcnt lgkmcnt(0)
  s_barrier
  ds_read_b64 v[28:29], v10
  ds_read_b64 v[30:31], v10 offset:256
  ds_read_b64 v[32:33], v10 offset:512
  ds_read_b64 v[34:35], v10 offset:768
  ds_read_b64 v[36:37], v10 offset:1024
  ds_read_b64 v[38:39], v10 offset:1280
  ds_read_b64 v[40:41], v10 offset:1536
  ds_read_b64 v[42:43], v10 offset:1792
  ds_read_b128 v[60:63], v11
  ds_read_b128 v[64:67], v11 offset:128
  ds_read_b128 v[68:71], v11 offset:256
  ds_read_b128 v[72:75], v11 offset:384
label_openLoopL:
  s_cmp_eq_u32 s8, 1
  s_cbranch_scc1 label_toPGR1
  s_cmp_le_u32 s8, 2
  s_cbranch_scc1 label_LoopEndL
label_LoopBeginL:
  s_waitcnt lgkmcnt(3)
  v_perm_b32 v12, v30, v28, s81
  v_perm_b32 v13, v34, v32, s81
  v_perm_b32 v14, v38, v36, s81
  v_perm_b32 v15, v42, v40, s81
  v_perm_b32 v16, v30, v28, s82
  v_perm_b32 v17, v34, v32, s82
  v_mfma_f32_16x16x32_f16 a[0:3], v[60:63], v[12:15], a[0:3]
  ds_read_b64 v[44:45], v10 offset:8192
  ds_read_b64 v[46:47], v10 offset:8448
  s_cmp_eq_u32 s8, s74
  s_cselect_b32 s84, s75, s79
  s_cselect_b32 s85, s76, 0
  v_perm_b32 v18, v38, v36, s82
  v_perm_b32 v19, v42, v40, s82
  v_perm_b32 v20, v31, v29, s81
  v_perm_b32 v21, v35, v33, s81
  v_mfma_f32_16x16x32_f16 a[4:7], v[60:63], v[16:19], a[4:7]
  ds_read_b64 v[48:49], v10 offset:8704
  ds_read_b64 v[50:51], v10 offset:8960
  s_add_u32 s64, s64, s84
  s_addc_u32 s65, s65, s85
  s_sub_u32 s58, s58, s84
  v_perm_b32 v22, v39, v37, s81
  v_perm_b32 v23, v43, v41, s81
  v_perm_b32 v24, v31, v29, s82
  v_perm_b32 v25, v35, v33, s82
  v_mfma_f32_16x16x32_f16 a[8:11], v[60:63], v[20:23], a[8:11]
  ds_read_b64 v[52:53], v10 offset:9216
  ds_read_b64 v[54:55], v10 offset:9472
  s_subb_u32 s59, s59, s85
  s_cmp_eq_u32 s59, 0
  s_cselect_b32 s66, s58, -1
  v_perm_b32 v26, v39, v37, s82
  v_perm_b32 v27, v43, v41, s82
  s_nop 1
  v_mfma_f32_16x16x32_f16 a[12:15], v[60:63], v[24:27], a[12:15]
  ds_read_b64 v[56:57], v10 offset:9728
  ds_read_b64 v[58:59], v10 offset:9984
  s_cmp_eq_u32 s8, s74
  s_cselect_b32 s84, s77, s80
  s_cselect_b32 s85, s78, 0
  s_waitcnt lgkmcnt(8)
  v_mfma_f32_16x16x32_f16 a[16:19], v[64:67], v[12:15], a[16:19]
  ds_read_b128 v[76:79], v11 offset:64
  s_add_u32 s68, s68, s84
  s_addc_u32 s69, s69, s85
  s_sub_u32 s72, s72, s84
  v_mfma_f32_16x16x32_f16 a[20:23], v[64:67], v[16:19], a[20:23]
  ds_read_b128 v[80:83], v11 offset:192
  s_subb_u32 s73, s73, s85
  s_cmp_eq_u32 s73, 0
  s_cselect_b32 s70, s72, -1
  v_mfma_f32_16x16x32_f16 a[24:27], v[64:67], v[20:23], a[24:27]
  ds_read_b128 v[84:87], v11 offset:320
  v_mfma_f32_16x16x32_f16 a[28:31], v[64:67], v[24:27], a[28:31]
  ds_read_b128 v[88:91], v11 offset:448
  v_mfma_f32_16x16x32_f16 a[32:35], v[68:71], v[12:15], a[32:35]
  v_mfma_f32_16x16x32_f16 a[36:39], v[68:71], v[16:19], a[36:39]
  v_mfma_f32_16x16x32_f16 a[40:43], v[68:71], v[20:23], a[40:43]
  v_mfma_f32_16x16x32_f16 a[44:47], v[68:71], v[24:27], a[44:47]
  v_mfma_f32_16x16x32_f16 a[48:51], v[72:75], v[12:15], a[48:51]
  s_waitcnt lgkmcnt(0)
  s_barrier
  v_mfma_f32_16x16x32_f16 a[52:55], v[72:75], v[16:19], a[52:55]
  s_waitcnt vmcnt(7)
  ds_write_b128 v8, v[92:95]
  buffer_load_dwordx4 v[92:95], v0, s[64:67], 0 offen
  s_waitcnt vmcnt(7)
  ds_write_b128 v8, v[96:99] offset:4096
  v_mfma_f32_16x16x32_f16 a[56:59], v[72:75], v[20:23], a[56:59]
  buffer_load_dwordx4 v[96:99], v1, s[64:67], 0 offen
  s_waitcnt vmcnt(7)
  ds_write_b128 v8, v[100:103] offset:8192
  buffer_load_dwordx4 v[100:103], v2, s[64:67], 0 offen
  v_mfma_f32_16x16x32_f16 a[60:63], v[72:75], v[24:27], a[60:63]
  s_waitcnt vmcnt(7)
  ds_write_b128 v8, v[104:107] offset:12288
  buffer_load_dwordx4 v[104:107], v3, s[64:67], 0 offen
  s_waitcnt vmcnt(7)
  ds_write_b128 v9, v[108:111]
  s_waitcnt lgkmcnt(5)
  v_perm_b32 v12, v46, v44, s81
  v_perm_b32 v13, v50, v48, s81
  v_perm_b32 v14, v54, v52, s81
  v_perm_b32 v15, v58, v56, s81
  v_perm_b32 v16, v46, v44, s82
  v_perm_b32 v17, v50, v48, s82
  v_mfma_f32_16x16x32_f16 a[0:3], v[76:79], v[12:15], a[0:3]
  buffer_load_dwordx4 v[108:111], v4, s[68:71], 0 offen
  s_waitcnt vmcnt(7)
  ds_write_b128 v9, v[112:115] offset:4352
  buffer_load_dwordx4 v[112:115], v5, s[68:71], 0 offen
  v_perm_b32 v18, v54, v52, s82
  v_perm_b32 v19, v58, v56, s82
  v_perm_b32 v20, v47, v45, s81
  v_perm_b32 v21, v51, v49, s81
  v_mfma_f32_16x16x32_f16 a[4:7], v[76:79], v[16:19], a[4:7]
  s_waitcnt vmcnt(7)
  ds_write_b128 v9, v[116:119] offset:8704
  buffer_load_dwordx4 v[116:119], v6, s[68:71], 0 offen
  s_waitcnt vmcnt(7)
  ds_write_b128 v9, v[120:123] offset:13056
  v_perm_b32 v22, v55, v53, s81
  v_perm_b32 v23, v59, v57, s81
  v_perm_b32 v24, v47, v45, s82
  v_perm_b32 v25, v51, v49, s82
  v_mfma_f32_16x16x32_f16 a[8:11], v[76:79], v[20:23], a[8:11]
  buffer_load_dwordx4 v[120:123], v7, s[68:71], 0 offen
  v_perm_b32 v26, v55, v53, s82
  v_perm_b32 v27, v59, v57, s82
  s_nop 1
  v_mfma_f32_16x16x32_f16 a[12:15], v[76:79], v[24:27], a[12:15]
  v_mfma_f32_16x16x32_f16 a[16:19], v[80:83], v[12:15], a[16:19]
  s_waitcnt lgkmcnt(0)
  s_barrier
  v_mfma_f32_16x16x32_f16 a[20:23], v[80:83], v[16:19], a[20:23]
  ds_read_b64 v[28:29], v10
  ds_read_b64 v[30:31], v10 offset:256
  v_mfma_f32_16x16x32_f16 a[24:27], v[80:83], v[20:23], a[24:27]
  ds_read_b64 v[32:33], v10 offset:512
  ds_read_b64 v[34:35], v10 offset:768
  v_mfma_f32_16x16x32_f16 a[28:31], v[80:83], v[24:27], a[28:31]
  ds_read_b64 v[36:37], v10 offset:1024
  ds_read_b64 v[38:39], v10 offset:1280
  v_mfma_f32_16x16x32_f16 a[32:35], v[84:87], v[12:15], a[32:35]
  ds_read_b64 v[40:41], v10 offset:1536
  ds_read_b64 v[42:43], v10 offset:1792
  v_mfma_f32_16x16x32_f16 a[36:39], v[84:87], v[16:19], a[36:39]
  ds_read_b128 v[60:63], v11
  v_mfma_f32_16x16x32_f16 a[40:43], v[84:87], v[20:23], a[40:43]
  ds_read_b128 v[64:67], v11 offset:128
  v_mfma_f32_16x16x32_f16 a[44:47], v[84:87], v[24:27], a[44:47]
  ds_read_b128 v[68:71], v11 offset:256
  v_mfma_f32_16x16x32_f16 a[48:51], v[88:91], v[12:15], a[48:51]
  ds_read_b128 v[72:75], v11 offset:384
  v_mfma_f32_16x16x32_f16 a[52:55], v[88:91], v[16:19], a[52:55]
  v_mfma_f32_16x16x32_f16 a[56:59], v[88:91], v[20:23], a[56:59]
  v_mfma_f32_16x16x32_f16 a[60:63], v[88:91], v[24:27], a[60:63]
  s_sub_u32 s8, s8, 1
  s_cmp_eq_i32 s8, 2
  s_cbranch_scc0 label_LoopBeginL
label_LoopEndL:
  s_waitcnt lgkmcnt(3)
  v_perm_b32 v12, v30, v28, s81
  v_perm_b32 v13, v34, v32, s81
  v_perm_b32 v14, v38, v36, s81
  v_perm_b32 v15, v42, v40, s81
  v_perm_b32 v16, v30, v28, s82
  v_perm_b32 v17, v34, v32, s82
  v_mfma_f32_16x16x32_f16 a[0:3], v[60:63], v[12:15], a[0:3]
  ds_read_b64 v[44:45], v10 offset:8192
  ds_read_b64 v[46:47], v10 offset:8448
  s_cmp_eq_u32 s8, s74
  s_cselect_b32 s84, s75, s79
  s_cselect_b32 s85, s76, 0
  v_perm_b32 v18, v38, v36, s82
  v_perm_b32 v19, v42, v40, s82
  v_perm_b32 v20, v31, v29, s81
  v_perm_b32 v21, v35, v33, s81
  v_mfma_f32_16x16x32_f16 a[4:7], v[60:63], v[16:19], a[4:7]
  ds_read_b64 v[48:49], v10 offset:8704
  ds_read_b64 v[50:51], v10 offset:8960
  s_add_u32 s64, s64, s84
  s_addc_u32 s65, s65, s85
  s_sub_u32 s58, s58, s84
  v_perm_b32 v22, v39, v37, s81
  v_perm_b32 v23, v43, v41, s81
  v_perm_b32 v24, v31, v29, s82
  v_perm_b32 v25, v35, v33, s82
  v_mfma_f32_16x16x32_f16 a[8:11], v[60:63], v[20:23], a[8:11]
  ds_read_b64 v[52:53], v10 offset:9216
  ds_read_b64 v[54:55], v10 offset:9472
  s_subb_u32 s59, s59, s85
  s_cmp_eq_u32 s59, 0
  s_cselect_b32 s66, s58, -1
  v_perm_b32 v26, v39, v37, s82
  v_perm_b32 v27, v43, v41, s82
  s_nop 1
  v_mfma_f32_16x16x32_f16 a[12:15], v[60:63], v[24:27], a[12:15]
  ds_read_b64 v[56:57], v10 offset:9728
  ds_read_b64 v[58:59], v10 offset:9984
  s_cmp_eq_u32 s8, s74
  s_cselect_b32 s84, s77, s80
  s_cselect_b32 s85, s78, 0
  s_waitcnt lgkmcnt(8)
  v_mfma_f32_16x16x32_f16 a[16:19], v[64:67], v[12:15], a[16:19]
  ds_read_b128 v[76:79], v11 offset:64
  s_add_u32 s68, s68, s84
  s_addc_u32 s69, s69, s85
  s_sub_u32 s72, s72, s84
  v_mfma_f32_16x16x32_f16 a[20:23], v[64:67], v[16:19], a[20:23]
  ds_read_b128 v[80:83], v11 offset:192
  s_subb_u32 s73, s73, s85
  s_cmp_eq_u32 s73, 0
  s_cselect_b32 s70, s72, -1
  v_mfma_f32_16x16x32_f16 a[24:27], v[64:67], v[20:23], a[24:27]
  ds_read_b128 v[84:87], v11 offset:320
  v_mfma_f32_16x16x32_f16 a[28:31], v[64:67], v[24:27], a[28:31]
  ds_read_b128 v[88:91], v11 offset:448
  v_mfma_f32_16x16x32_f16 a[32:35], v[68:71], v[12:15], a[32:35]
  v_mfma_f32_16x16x32_f16 a[36:39], v[68:71], v[16:19], a[36:39]
  v_mfma_f32_16x16x32_f16 a[40:43], v[68:71], v[20:23], a[40:43]
  v_mfma_f32_16x16x32_f16 a[44:47], v[68:71], v[24:27], a[44:47]
  v_mfma_f32_16x16x32_f16 a[48:51], v[72:75], v[12:15], a[48:51]
  s_waitcnt lgkmcnt(0)
  s_barrier
  v_mfma_f32_16x16x32_f16 a[52:55], v[72:75], v[16:19], a[52:55]
  s_waitcnt vmcnt(7)
  ds_write_b128 v8, v[92:95]
  s_waitcnt vmcnt(6)
  ds_write_b128 v8, v[96:99] offset:4096
  v_mfma_f32_16x16x32_f16 a[56:59], v[72:75], v[20:23], a[56:59]
  s_waitcnt vmcnt(5)
  ds_write_b128 v8, v[100:103] offset:8192
  v_mfma_f32_16x16x32_f16 a[60:63], v[72:75], v[24:27], a[60:63]
  s_waitcnt vmcnt(4)
  ds_write_b128 v8, v[104:107] offset:12288
  s_waitcnt vmcnt(3)
  ds_write_b128 v9, v[108:111]
  s_waitcnt lgkmcnt(5)
  v_perm_b32 v12, v46, v44, s81
  v_perm_b32 v13, v50, v48, s81
  v_perm_b32 v14, v54, v52, s81
  v_perm_b32 v15, v58, v56, s81
  v_perm_b32 v16, v46, v44, s82
  v_perm_b32 v17, v50, v48, s82
  v_mfma_f32_16x16x32_f16 a[0:3], v[76:79], v[12:15], a[0:3]
  s_waitcnt vmcnt(2)
  ds_write_b128 v9, v[112:115] offset:4352
  v_perm_b32 v18, v54, v52, s82
  v_perm_b32 v19, v58, v56, s82
  v_perm_b32 v20, v47, v45, s81
  v_perm_b32 v21, v51, v49, s81
  v_mfma_f32_16x16x32_f16 a[4:7], v[76:79], v[16:19], a[4:7]
  s_waitcnt vmcnt(1)
  ds_write_b128 v9, v[116:119] offset:8704
  s_waitcnt vmcnt(0)
  ds_write_b128 v9, v[120:123] offset:13056
  v_perm_b32 v22, v55, v53, s81
  v_perm_b32 v23, v59, v57, s81
  v_perm_b32 v24, v47, v45, s82
  v_perm_b32 v25, v51, v49, s82
  v_mfma_f32_16x16x32_f16 a[8:11], v[76:79], v[20:23], a[8:11]
  v_perm_b32 v26, v55, v53, s82
  v_perm_b32 v27, v59, v57, s82
  s_nop 1
  v_mfma_f32_16x16x32_f16 a[12:15], v[76:79], v[24:27], a[12:15]
  v_mfma_f32_16x16x32_f16 a[16:19], v[80:83], v[12:15], a[16:19]
  s_waitcnt lgkmcnt(0)
  s_barrier
  v_mfma_f32_16x16x32_f16 a[20:23], v[80:83], v[16:19], a[20:23]
  ds_read_b64 v[28:29], v10
  ds_read_b64 v[30:31], v10 offset:256
  v_mfma_f32_16x16x32_f16 a[24:27], v[80:83], v[20:23], a[24:27]
  ds_read_b64 v[32:33], v10 offset:512
  ds_read_b64 v[34:35], v10 offset:768
  v_mfma_f32_16x16x32_f16 a[28:31], v[80:83], v[24:27], a[28:31]
  ds_read_b64 v[36:37], v10 offset:1024
  ds_read_b64 v[38:39], v10 offset:1280
  v_mfma_f32_16x16x32_f16 a[32:35], v[84:87], v[12:15], a[32:35]
  ds_read_b64 v[40:41], v10 offset:1536
  ds_read_b64 v[42:43], v10 offset:1792
  v_mfma_f32_16x16x32_f16 a[36:39], v[84:87], v[16:19], a[36:39]
  ds_read_b128 v[60:63], v11
  v_mfma_f32_16x16x32_f16 a[40:43], v[84:87], v[20:23], a[40:43]
  ds_read_b128 v[64:67], v11 offset:128
  v_mfma_f32_16x16x32_f16 a[44:47], v[84:87], v[24:27], a[44:47]
  ds_read_b128 v[68:71], v11 offset:256
  v_mfma_f32_16x16x32_f16 a[48:51], v[88:91], v[12:15], a[48:51]
  ds_read_b128 v[72:75], v11 offset:384
  v_mfma_f32_16x16x32_f16 a[52:55], v[88:91], v[16:19], a[52:55]
  v_mfma_f32_16x16x32_f16 a[56:59], v[88:91], v[20:23], a[56:59]
  v_mfma_f32_16x16x32_f16 a[60:63], v[88:91], v[24:27], a[60:63]
label_toPGR1:
  s_waitcnt lgkmcnt(3)
  v_perm_b32 v12, v30, v28, s81
  v_perm_b32 v13, v34, v32, s81
  v_perm_b32 v14, v38, v36, s81
  v_perm_b32 v15, v42, v40, s81
  v_perm_b32 v16, v30, v28, s82
  v_perm_b32 v17, v34, v32, s82
  v_mfma_f32_16x16x32_f16 a[0:3], v[60:63], v[12:15], a[0:3]
  ds_read_b64 v[44:45], v10 offset:8192
  ds_read_b64 v[46:47], v10 offset:8448
  v_perm_b32 v18, v38, v36, s82
  v_perm_b32 v19, v42, v40, s82
  v_perm_b32 v20, v31, v29, s81
  v_perm_b32 v21, v35, v33, s81
  v_mfma_f32_16x16x32_f16 a[4:7], v[60:63], v[16:19], a[4:7]
  ds_read_b64 v[48:49], v10 offset:8704
  ds_read_b64 v[50:51], v10 offset:8960
  v_perm_b32 v22, v39, v37, s81
  v_perm_b32 v23, v43, v41, s81
  v_perm_b32 v24, v31, v29, s82
  v_perm_b32 v25, v35, v33, s82
  v_mfma_f32_16x16x32_f16 a[8:11], v[60:63], v[20:23], a[8:11]
  ds_read_b64 v[52:53], v10 offset:9216
  ds_read_b64 v[54:55], v10 offset:9472
  v_perm_b32 v26, v39, v37, s82
  v_perm_b32 v27, v43, v41, s82
  s_nop 1
  v_mfma_f32_16x16x32_f16 a[12:15], v[60:63], v[24:27], a[12:15]
  ds_read_b64 v[56:57], v10 offset:9728
  ds_read_b64 v[58:59], v10 offset:9984
  s_waitcnt lgkmcnt(8)
  v_mfma_f32_16x16x32_f16 a[16:19], v[64:67], v[12:15], a[16:19]
  ds_read_b128 v[76:79], v11 offset:64
  v_mfma_f32_16x16x32_f16 a[20:23], v[64:67], v[16:19], a[20:23]
  ds_read_b128 v[80:83], v11 offset:192
  v_mfma_f32_16x16x32_f16 a[24:27], v[64:67], v[20:23], a[24:27]
  ds_read_b128 v[84:87], v11 offset:320
  v_mfma_f32_16x16x32_f16 a[28:31], v[64:67], v[24:27], a[28:31]
  ds_read_b128 v[88:91], v11 offset:448
  v_mfma_f32_16x16x32_f16 a[32:35], v[68:71], v[12:15], a[32:35]
  v_mfma_f32_16x16x32_f16 a[36:39], v[68:71], v[16:19], a[36:39]
  v_mfma_f32_16x16x32_f16 a[40:43], v[68:71], v[20:23], a[40:43]
  v_mfma_f32_16x16x32_f16 a[44:47], v[68:71], v[24:27], a[44:47]
  v_mfma_f32_16x16x32_f16 a[48:51], v[72:75], v[12:15], a[48:51]
  v_mfma_f32_16x16x32_f16 a[52:55], v[72:75], v[16:19], a[52:55]
  s_waitcnt lgkmcnt(0)
  s_barrier
  v_mfma_f32_16x16x32_f16 a[56:59], v[72:75], v[20:23], a[56:59]
  v_mfma_f32_16x16x32_f16 a[60:63], v[72:75], v[24:27], a[60:63]
  s_waitcnt lgkmcnt(0)
  v_perm_b32 v12, v46, v44, s81
  v_perm_b32 v13, v50, v48, s81
  v_perm_b32 v14, v54, v52, s81
  v_perm_b32 v15, v58, v56, s81
  v_perm_b32 v16, v46, v44, s82
  v_perm_b32 v17, v50, v48, s82
  v_mfma_f32_16x16x32_f16 a[0:3], v[76:79], v[12:15], a[0:3]
  v_perm_b32 v18, v54, v52, s82
  v_perm_b32 v19, v58, v56, s82
  v_perm_b32 v20, v47, v45, s81
  v_perm_b32 v21, v51, v49, s81
  v_mfma_f32_16x16x32_f16 a[4:7], v[76:79], v[16:19], a[4:7]
  v_perm_b32 v22, v55, v53, s81
  v_perm_b32 v23, v59, v57, s81
  v_perm_b32 v24, v47, v45, s82
  v_perm_b32 v25, v51, v49, s82
  v_mfma_f32_16x16x32_f16 a[8:11], v[76:79], v[20:23], a[8:11]
  v_perm_b32 v26, v55, v53, s82
  v_perm_b32 v27, v59, v57, s82
  s_nop 1
  v_mfma_f32_16x16x32_f16 a[12:15], v[76:79], v[24:27], a[12:15]
  v_mfma_f32_16x16x32_f16 a[16:19], v[80:83], v[12:15], a[16:19]
  v_mfma_f32_16x16x32_f16 a[20:23], v[80:83], v[16:19], a[20:23]
  v_mfma_f32_16x16x32_f16 a[24:27], v[80:83], v[20:23], a[24:27]
  v_mfma_f32_16x16x32_f16 a[28:31], v[80:83], v[24:27], a[28:31]
  v_mfma_f32_16x16x32_f16 a[32:35], v[84:87], v[12:15], a[32:35]
  v_mfma_f32_16x16x32_f16 a[36:39], v[84:87], v[16:19], a[36:39]
  v_mfma_f32_16x16x32_f16 a[40:43], v[84:87], v[20:23], a[40:43]
  v_mfma_f32_16x16x32_f16 a[44:47], v[84:87], v[24:27], a[44:47]
  v_mfma_f32_16x16x32_f16 a[48:51], v[88:91], v[12:15], a[48:51]
  v_mfma_f32_16x16x32_f16 a[52:55], v[88:91], v[16:19], a[52:55]
  v_mfma_f32_16x16x32_f16 a[56:59], v[88:91], v[20:23], a[56:59]
  v_mfma_f32_16x16x32_f16 a[60:63], v[88:91], v[24:27], a[60:63]
label_PrefetchGlobalLastIterEnd:
label_toPGR1end_OrdNLL:
  s_and_b32 s8, 63, s23
  s_cmp_lt_u32 s57, s46
  s_cmov_b32 s8, 0
  s_cmp_eq_u32 s8, 0
  s_mov_b32 s9, 0
  s_cbranch_scc1 label_SkipTailLoopL
  s_sub_i32 s84, 3, s74
  s_cmp_ge_i32 s84, 0
  s_cbranch_scc0 label_Negative_ZUW27NR9AE7UXHMS
  s_mul_hi_u32 s85, s84, s79
  s_mul_i32 s84, s84, s79
  s_branch label_MultiplyDone_8LNAOC1I0RDD7U0D
label_Negative_ZUW27NR9AE7UXHMS:
  s_abs_i32 s84, s84
  s_mul_hi_u32 s85, s84, s79
  s_mul_i32 s84, s84, s79
  s_xor_b32 s84, s84, -1
  s_xor_b32 s85, s85, -1
  s_add_u32 s84, s84, 1
  s_addc_u32 s85, s85, 0
label_MultiplyDone_8LNAOC1I0RDD7U0D:
  s_sub_u32 s84, s84, s75
  s_subb_u32 s85, s85, s76
  s_add_u32 s64, s64, s84
  s_addc_u32 s65, s65, s85
  s_sub_u32 s58, s58, s84
  s_subb_u32 s59, s59, s85
  s_cmp_eq_u32 s59, 0
  s_cselect_b32 s66, s58, -1
  s_sub_i32 s84, 3, s74
  s_cmp_ge_i32 s84, 0
  s_cbranch_scc0 label_Negative_EMLSFIRVN5FQS89Q
  s_mul_hi_u32 s85, s84, s80
  s_mul_i32 s84, s84, s80
  s_branch label_MultiplyDone_ZMQD4X2VULES54VA
label_Negative_EMLSFIRVN5FQS89Q:
  s_abs_i32 s84, s84
  s_mul_hi_u32 s85, s84, s80
  s_mul_i32 s84, s84, s80
  s_xor_b32 s84, s84, -1
  s_xor_b32 s85, s85, -1
  s_add_u32 s84, s84, 1
  s_addc_u32 s85, s85, 0
label_MultiplyDone_ZMQD4X2VULES54VA:
  s_sub_u32 s84, s84, s77
  s_subb_u32 s85, s85, s78
  s_add_u32 s68, s68, s84
  s_addc_u32 s69, s69, s85
  s_sub_u32 s72, s72, s84
  s_subb_u32 s73, s73, s85
  s_cmp_eq_u32 s73, 0
  s_cselect_b32 s70, s72, -1
  buffer_load_dwordx4 v[12:15], v0, s[64:67], 0 offen
  buffer_load_dwordx4 v[16:19], v1, s[64:67], 0 offen
  buffer_load_dwordx4 v[20:23], v2, s[64:67], 0 offen
  buffer_load_dwordx4 v[24:27], v3, s[64:67], 0 offen
  buffer_load_dwordx4 v[28:31], v4, s[68:71], 0 offen
  buffer_load_dwordx4 v[32:35], v5, s[68:71], 0 offen
  buffer_load_dwordx4 v[36:39], v6, s[68:71], 0 offen
  buffer_load_dwordx4 v[40:43], v7, s[68:71], 0 offen
  s_lshr_b32 s75, s21, 7
  s_and_b32 s75, 0x7f, s21
  s_cmp_eq_u32 s75, 0
  s_cmov_b32 s75, 0x80
  s_and_b32 s79, s23, 63
  s_lshr_b32 s88, s79, 6
  s_mul_i32 s83, s75, s79
  s_mul_i32 s83, s83, 2
  s_sub_u32 s79, s21, 1
  s_lshr_b32 s75, s79, 7
  s_and_b32 s75, 0x7f, s79
  s_lshr_b32 s75, s75, 5
  s_mul_i32 s75, s75, 1
  s_add_i32 s75, s75, s88
  s_and_b32 s79, 63, s23
  s_and_b32 s79, s79, 7
  s_and_b32 s77, s79, 1
  s_mov_b32 s84, 0
label_LoadB:
  s_cmp_eq_u32 s77, 0
  s_cbranch_scc1 label_MergeB
  s_cmp_eq_u32 s75, 3
  s_cbranch_scc1 label_LOAD_B3
  s_cmp_eq_u32 s75, 2
  s_cbranch_scc1 label_LOAD_B2
  s_cmp_eq_u32 s75, 1
  s_cbranch_scc1 label_LOAD_B1
label_LOAD_B0:
label_LOAD_B0_K1:
  s_cmp_ge_u32 s79, 1
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v48, v4, s[68:71], 0 offen
label_LOAD_B0_K3:
  s_cmp_ge_u32 s79, 3
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v49, v4, s[68:71], 0 offen offset:4
label_LOAD_B0_K5:
  s_cmp_ge_u32 s79, 5
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v50, v4, s[68:71], 0 offen offset:8
label_LOAD_B0_K7:
  s_cmp_ge_u32 s79, 7
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v51, v4, s[68:71], 0 offen offset:12
  s_branch label_MergeB
label_LOAD_B1:
label_LOAD_B1_K1:
  s_cmp_ge_u32 s79, 1
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v48, v5, s[68:71], 0 offen
label_LOAD_B1_K3:
  s_cmp_ge_u32 s79, 3
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v49, v5, s[68:71], 0 offen offset:4
label_LOAD_B1_K5:
  s_cmp_ge_u32 s79, 5
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v50, v5, s[68:71], 0 offen offset:8
label_LOAD_B1_K7:
  s_cmp_ge_u32 s79, 7
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v51, v5, s[68:71], 0 offen offset:12
  s_branch label_MergeB
label_LOAD_B2:
label_LOAD_B2_K1:
  s_cmp_ge_u32 s79, 1
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v48, v6, s[68:71], 0 offen
label_LOAD_B2_K3:
  s_cmp_ge_u32 s79, 3
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v49, v6, s[68:71], 0 offen offset:4
label_LOAD_B2_K5:
  s_cmp_ge_u32 s79, 5
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v50, v6, s[68:71], 0 offen offset:8
label_LOAD_B2_K7:
  s_cmp_ge_u32 s79, 7
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v51, v6, s[68:71], 0 offen offset:12
  s_branch label_MergeB
label_LOAD_B3:
label_LOAD_B3_K1:
  s_cmp_ge_u32 s79, 1
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v48, v7, s[68:71], 0 offen
label_LOAD_B3_K3:
  s_cmp_ge_u32 s79, 3
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v49, v7, s[68:71], 0 offen offset:4
label_LOAD_B3_K5:
  s_cmp_ge_u32 s79, 5
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v50, v7, s[68:71], 0 offen offset:8
label_LOAD_B3_K7:
  s_cmp_ge_u32 s79, 7
  s_cbranch_scc0 label_MergeB
  buffer_load_short_d16 v51, v7, s[68:71], 0 offen offset:12
  s_branch label_MergeB
label_MergeB:
  s_cmp_eq_u32 s77, 0
  s_cbranch_scc1 label_CheckOtherLoadA
  s_cmp_eq_u32 s75, 3
  s_cbranch_scc1 label_MERGE_B3
  s_cmp_eq_u32 s75, 2
  s_cbranch_scc1 label_MERGE_B2
  s_cmp_eq_u32 s75, 1
  s_cbranch_scc1 label_MERGE_B1
label_MERGE_B0:
label_MERGE_B0_K1:
  s_cmp_ge_u32 s79, 1
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v28, v28, v48
label_MERGE_B0_K3:
  s_cmp_ge_u32 s79, 3
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v29, v29, v49
label_MERGE_B0_K5:
  s_cmp_ge_u32 s79, 5
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v30, v30, v50
label_MERGE_B0_K7:
  s_cmp_ge_u32 s79, 7
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v31, v31, v51
  s_branch label_CheckOtherLoadA
label_MERGE_B1:
label_MERGE_B1_K1:
  s_cmp_ge_u32 s79, 1
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v32, v32, v48
label_MERGE_B1_K3:
  s_cmp_ge_u32 s79, 3
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v33, v33, v49
label_MERGE_B1_K5:
  s_cmp_ge_u32 s79, 5
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v34, v34, v50
label_MERGE_B1_K7:
  s_cmp_ge_u32 s79, 7
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v35, v35, v51
  s_branch label_CheckOtherLoadA
label_MERGE_B2:
label_MERGE_B2_K1:
  s_cmp_ge_u32 s79, 1
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v36, v36, v48
label_MERGE_B2_K3:
  s_cmp_ge_u32 s79, 3
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v37, v37, v49
label_MERGE_B2_K5:
  s_cmp_ge_u32 s79, 5
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v38, v38, v50
label_MERGE_B2_K7:
  s_cmp_ge_u32 s79, 7
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v39, v39, v51
  s_branch label_CheckOtherLoadA
label_MERGE_B3:
label_MERGE_B3_K1:
  s_cmp_ge_u32 s79, 1
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v40, v40, v48
label_MERGE_B3_K3:
  s_cmp_ge_u32 s79, 3
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v41, v41, v49
label_MERGE_B3_K5:
  s_cmp_ge_u32 s79, 5
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v42, v42, v50
label_MERGE_B3_K7:
  s_cmp_ge_u32 s79, 7
  s_cbranch_scc0 label_CheckOtherLoadA
  s_waitcnt vmcnt(0)
  v_or_b32_e32 v43, v43, v51
  s_branch label_CheckOtherLoadA
label_CheckOtherLoadB:
label_CheckOtherLoadA:
  s_cmp_eq_u32 s77, 0
  s_cbranch_scc1 label_TailGlobalLoadEnd
  s_add_u32 s84, s84, 1
  s_cmp_eq_u32 s84, 4
  s_cbranch_scc1 label_TailGlobalLoadEnd
  s_sub_i32 s75, s75, 1
  s_cmp_lt_i32 s75, 0
  s_cselect_b32 s86, 4, 0
  s_add_i32 s75, s75, s86
  s_cmp_eq_u32 s75, 3
  s_cbranch_scc1 label_B3
  s_cmp_eq_u32 s75, 2
  s_cbranch_scc1 label_B2
  s_cmp_eq_u32 s75, 1
  s_cbranch_scc1 label_B1
label_B0:
  v_mov_b32_e32 v44, v4
  s_branch label_CheckAddrB
label_B1:
  v_mov_b32_e32 v44, v5
  s_branch label_CheckAddrB
label_B2:
  v_mov_b32_e32 v44, v6
  s_branch label_CheckAddrB
label_B3:
  v_mov_b32_e32 v44, v7
label_CheckAddrB:
  v_sub_u32_e64 v44, v44, 16
  v_add_u32_e64 v45, v44, 15
  v_cmp_lt_i32_e64 s[86:87], v44, s83
  v_cmp_ge_i32_e64 s[88:89], v45, s83
  s_and_b32 s86, s86, s88
  s_and_b32 s87, s87, s89
  s_add_u32 s86, s86, s87
  s_cmp_lg_u32 s86, 0
  s_cbranch_scc1 label_LoadB
label_TailGlobalLoadEnd:
  s_waitcnt vmcnt(0)
  s_barrier
  ds_write_b128 v8, v[12:15]
  ds_write_b128 v8, v[16:19] offset:4096
  ds_write_b128 v8, v[20:23] offset:8192
  ds_write_b128 v8, v[24:27] offset:12288
  ds_write_b128 v9, v[28:31]
  ds_write_b128 v9, v[32:35] offset:4352
  ds_write_b128 v9, v[36:39] offset:8704
  ds_write_b128 v9, v[40:43] offset:13056
  s_waitcnt lgkmcnt(0)
  s_barrier
label_TailLoopBeginL:
  ds_read_b64 v[28:29], v10
  ds_read_b64 v[30:31], v10 offset:256
  ds_read_b64 v[32:33], v10 offset:512
  ds_read_b64 v[34:35], v10 offset:768
  ds_read_b64 v[36:37], v10 offset:1024
  ds_read_b64 v[38:39], v10 offset:1280
  ds_read_b64 v[40:41], v10 offset:1536
  ds_read_b64 v[42:43], v10 offset:1792
  ds_read_b128 v[60:63], v11
  ds_read_b128 v[64:67], v11 offset:128
  ds_read_b128 v[68:71], v11 offset:256
  ds_read_b128 v[72:75], v11 offset:384
  s_mov_b32 s74, 0x2000
  v_add_co_u32_e32 v10, vcc, s74, v10
  s_mov_b32 s74, 64
  v_add_co_u32_e32 v11, vcc, s74, v11
  s_waitcnt lgkmcnt(0)
  v_perm_b32 v12, v30, v28, s81
  v_perm_b32 v13, v34, v32, s81
  v_perm_b32 v14, v38, v36, s81
  v_perm_b32 v15, v42, v40, s81
  v_perm_b32 v16, v30, v28, s82
  v_perm_b32 v17, v34, v32, s82
  v_perm_b32 v18, v38, v36, s82
  v_perm_b32 v19, v42, v40, s82
  v_perm_b32 v20, v31, v29, s81
  v_perm_b32 v21, v35, v33, s81
  v_perm_b32 v22, v39, v37, s81
  v_perm_b32 v23, v43, v41, s81
  v_perm_b32 v24, v31, v29, s82
  v_perm_b32 v25, v35, v33, s82
  v_perm_b32 v26, v39, v37, s82
  v_perm_b32 v27, v43, v41, s82
  v_and_b32_e32 v92, 63, v124
  v_lshrrev_b32_e32 v92, 4, v92
  v_lshlrev_b32_e32 v92, 3, v92
  v_add_u32_e64 v93, v92, 0
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v12, v12, 0, s[74:75]
  v_cndmask_b32_e64 v16, v16, 0, s[74:75]
  v_cndmask_b32_e64 v20, v20, 0, s[74:75]
  v_cndmask_b32_e64 v24, v24, 0, s[74:75]
  v_cndmask_b32_e64 v13, v13, 0, s[74:75]
  v_cndmask_b32_e64 v17, v17, 0, s[74:75]
  v_cndmask_b32_e64 v21, v21, 0, s[74:75]
  v_cndmask_b32_e64 v25, v25, 0, s[74:75]
  v_add_u32_e64 v93, v93, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v14, v14, 0, s[74:75]
  v_cndmask_b32_e64 v18, v18, 0, s[74:75]
  v_cndmask_b32_e64 v22, v22, 0, s[74:75]
  v_cndmask_b32_e64 v26, v26, 0, s[74:75]
  v_cndmask_b32_e64 v15, v15, 0, s[74:75]
  v_cndmask_b32_e64 v19, v19, 0, s[74:75]
  v_cndmask_b32_e64 v23, v23, 0, s[74:75]
  v_cndmask_b32_e64 v27, v27, 0, s[74:75]
  v_and_b32_e32 v92, 63, v124
  v_lshrrev_b32_e32 v92, 4, v92
  v_lshlrev_b32_e32 v92, 3, v92
  v_add_u32_e64 v93, v92, 0
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v60, v60, 0, s[74:75]
  v_cndmask_b32_e64 v64, v64, 0, s[74:75]
  v_cndmask_b32_e64 v68, v68, 0, s[74:75]
  v_cndmask_b32_e64 v72, v72, 0, s[74:75]
  v_cndmask_b32_e64 v61, v61, 0, s[74:75]
  v_cndmask_b32_e64 v65, v65, 0, s[74:75]
  v_cndmask_b32_e64 v69, v69, 0, s[74:75]
  v_cndmask_b32_e64 v73, v73, 0, s[74:75]
  v_add_u32_e64 v93, v93, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v62, v62, 0, s[74:75]
  v_cndmask_b32_e64 v66, v66, 0, s[74:75]
  v_cndmask_b32_e64 v70, v70, 0, s[74:75]
  v_cndmask_b32_e64 v74, v74, 0, s[74:75]
  v_cndmask_b32_e64 v63, v63, 0, s[74:75]
  v_cndmask_b32_e64 v67, v67, 0, s[74:75]
  v_cndmask_b32_e64 v71, v71, 0, s[74:75]
  v_cndmask_b32_e64 v75, v75, 0, s[74:75]
  s_and_b32 s76, s23, 7
  s_cmp_eq_u32 s76, 0
  s_cbranch_scc1 label_TailLoop_SkipZeroOutMask_W68HU527GN4Y13ER
  s_and_b32 s76, s8, 7
  s_sub_u32 s76, 8, s76
  s_lshl_b32 s76, s76, 4
  v_lshlrev_b64 v[94:95], s76, v[12:13]
  v_lshlrev_b64 v[96:97], s76, v[14:15]
  v_add_u32_e64 v93, v92, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v12, v12, v94, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v13, v13, v95, s[74:75]
  v_add_u32_e64 v93, v93, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v14, v14, v96, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v15, v15, v97, s[74:75]
  v_lshlrev_b64 v[94:95], s76, v[16:17]
  v_lshlrev_b64 v[96:97], s76, v[18:19]
  v_add_u32_e64 v93, v92, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v16, v16, v94, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v17, v17, v95, s[74:75]
  v_add_u32_e64 v93, v93, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v18, v18, v96, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v19, v19, v97, s[74:75]
  v_lshlrev_b64 v[94:95], s76, v[20:21]
  v_lshlrev_b64 v[96:97], s76, v[22:23]
  v_add_u32_e64 v93, v92, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v20, v20, v94, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v21, v21, v95, s[74:75]
  v_add_u32_e64 v93, v93, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v22, v22, v96, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v23, v23, v97, s[74:75]
  v_lshlrev_b64 v[94:95], s76, v[24:25]
  v_lshlrev_b64 v[96:97], s76, v[26:27]
  v_add_u32_e64 v93, v92, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v24, v24, v94, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v25, v25, v95, s[74:75]
  v_add_u32_e64 v93, v93, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v26, v26, v96, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v27, v27, v97, s[74:75]
  v_lshlrev_b64 v[94:95], s76, v[60:61]
  v_lshlrev_b64 v[96:97], s76, v[62:63]
  v_add_u32_e64 v93, v92, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v60, v60, v94, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v61, v61, v95, s[74:75]
  v_add_u32_e64 v93, v93, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v62, v62, v96, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v63, v63, v97, s[74:75]
  v_lshlrev_b64 v[94:95], s76, v[64:65]
  v_lshlrev_b64 v[96:97], s76, v[66:67]
  v_add_u32_e64 v93, v92, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v64, v64, v94, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v65, v65, v95, s[74:75]
  v_add_u32_e64 v93, v93, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v66, v66, v96, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v67, v67, v97, s[74:75]
  v_lshlrev_b64 v[94:95], s76, v[68:69]
  v_lshlrev_b64 v[96:97], s76, v[70:71]
  v_add_u32_e64 v93, v92, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v68, v68, v94, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v69, v69, v95, s[74:75]
  v_add_u32_e64 v93, v93, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v70, v70, v96, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v71, v71, v97, s[74:75]
  v_lshlrev_b64 v[94:95], s76, v[72:73]
  v_lshlrev_b64 v[96:97], s76, v[74:75]
  v_add_u32_e64 v93, v92, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v72, v72, v94, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v73, v73, v95, s[74:75]
  v_add_u32_e64 v93, v93, 4
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v74, v74, v96, s[74:75]
  v_cmp_ge_i32_e64 s[74:75], v93, s8
  v_cndmask_b32_e64 v75, v75, v97, s[74:75]
label_TailLoop_SkipZeroOutMask_W68HU527GN4Y13ER:
  s_nop 1
  v_mfma_f32_16x16x32_f16 a[0:3], v[60:63], v[12:15], a[0:3]
  v_mfma_f32_16x16x32_f16 a[4:7], v[60:63], v[16:19], a[4:7]
  v_mfma_f32_16x16x32_f16 a[8:11], v[60:63], v[20:23], a[8:11]
  v_mfma_f32_16x16x32_f16 a[12:15], v[60:63], v[24:27], a[12:15]
  v_mfma_f32_16x16x32_f16 a[16:19], v[64:67], v[12:15], a[16:19]
  v_mfma_f32_16x16x32_f16 a[20:23], v[64:67], v[16:19], a[20:23]
  v_mfma_f32_16x16x32_f16 a[24:27], v[64:67], v[20:23], a[24:27]
  v_mfma_f32_16x16x32_f16 a[28:31], v[64:67], v[24:27], a[28:31]
  v_mfma_f32_16x16x32_f16 a[32:35], v[68:71], v[12:15], a[32:35]
  v_mfma_f32_16x16x32_f16 a[36:39], v[68:71], v[16:19], a[36:39]
  v_mfma_f32_16x16x32_f16 a[40:43], v[68:71], v[20:23], a[40:43]
  v_mfma_f32_16x16x32_f16 a[44:47], v[68:71], v[24:27], a[44:47]
  v_mfma_f32_16x16x32_f16 a[48:51], v[72:75], v[12:15], a[48:51]
  v_mfma_f32_16x16x32_f16 a[52:55], v[72:75], v[16:19], a[52:55]
  v_mfma_f32_16x16x32_f16 a[56:59], v[72:75], v[20:23], a[56:59]
  v_mfma_f32_16x16x32_f16 a[60:63], v[72:75], v[24:27], a[60:63]
  s_sub_i32 s8, s8, 32
  s_add_u32 s9, s9, 32
  s_cmp_le_i32 s8, 0
  s_cbranch_scc0 label_TailLoopBeginL
label_TailLoopEndL:
  s_mov_b32 s74, 0x100
  s_mul_i32 s74, s9, s74
  v_sub_u32_e64 v10, v10, s74
  s_mov_b32 s74, 2
  s_mul_i32 s74, s9, s74
  v_sub_u32_e64 v11, v11, s74
label_SkipTailLoopL:
label_Summation_End_VUAPX2QIEA0941P6:
  s_cmp_eq_u32 s5, 2
  s_cbranch_scc1 label_LoadExternalEpilogueStruct
  s_load_dwordx8 s[64:71], s[0:1], 0x84
  s_load_dword s72, s[0:1], 0xa4
  s_branch label_LoadExternalEpilogueStructEnd
label_LoadExternalEpilogueStruct:
  s_load_dwordx4 s[64:67], s[0:1], 0xbc
  s_load_dwordx2 s[68:69], s[0:1], 0xcc
  s_load_dwordx2 s[70:71], s[0:1], 0xe4
  s_load_dword s72, s[0:1], 0xec
label_LoadExternalEpilogueStructEnd:
  v_mov_b32_e32 v3, s2
  v_mul_i32_i24_e32 v3, 0xffffff80, v3
  v_add_co_u32_e32 v3, vcc, s20, v3
  v_mov_b32_e32 v4, 0x80
  v_cmp_lt_u32_e64 s[8:9], v3, v4
  v_cndmask_b32_e64 v3, v4, v3, s[8:9]
  v_lshrrev_b32_e32 v5, 6, v124
  v_and_b32_e32 v5, 1, v5
  v_lshrrev_b32_e32 v6, 6, v3
  v_and_b32_e32 v6, 1, v6
  v_cmp_eq_u32_e64 s[8:9], v6, v5
  v_cndmask_b32_e64 v3, v4, v3, s[8:9]
  v_lshrrev_b32_e32 v4, 6, v3
  v_lshlrev_b32_e32 v6, 0, v5
  v_sub_u32_e32 v4, v4, v6
  v_lshrrev_b32_e32 v6, 3, v3
  v_lshrrev_b32_e32 v7, 0, v124
  v_and_b32_e32 v7, 15, v7
  v_lshlrev_b32_e32 v7, 2, v7
  v_lshrrev_b32_e32 v7, 3, v7
  v_lshlrev_b32_e32 v5, 3, v5
  v_add_co_u32_e32 v7, vcc, v5, v7
  v_sub_u32_e32 v6, v6, v7
  v_and_b32_e32 v5, 3, v3
  v_lshrrev_b32_e32 v5, 3, v5
  v_and_b32_e32 v7, 7, v3
  v_cmp_eq_u32_e64 vcc, v7, 1
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW1
  v_cmp_eq_u32_e64 vcc, v7, 2
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW2
  v_cmp_eq_u32_e64 vcc, v7, 3
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW3
  v_cmp_eq_u32_e64 vcc, v7, 4
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW4
  v_cmp_eq_u32_e64 vcc, v7, 5
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW5
  v_cmp_eq_u32_e64 vcc, v7, 6
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW6
  v_cmp_eq_u32_e64 vcc, v7, 7
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW7
  s_branch label_ShiftVectorComponents0_GLVW0
label_ShiftVectorComponents0_GLVW1:
  v_cmp_eq_u32_e64 vcc, v4, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW1_BM0
label_ShiftVectorComponents0_GLVW2:
  v_cmp_eq_u32_e64 vcc, v4, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW2_BM0
label_ShiftVectorComponents0_GLVW3:
  v_cmp_eq_u32_e64 vcc, v4, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW3_BM0
label_ShiftVectorComponents0_GLVW4:
  v_cmp_eq_u32_e64 vcc, v4, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW4_BM0
label_ShiftVectorComponents0_GLVW5:
  v_cmp_eq_u32_e64 vcc, v4, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW5_BM0
label_ShiftVectorComponents0_GLVW6:
  v_cmp_eq_u32_e64 vcc, v4, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW6_BM0
label_ShiftVectorComponents0_GLVW7:
  v_cmp_eq_u32_e64 vcc, v4, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW7_BM0
label_ShiftVectorComponents0_GLVW1_BM0:
  v_cmp_eq_u32_e64 vcc, v5, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW1_BM0_VW0
label_ShiftVectorComponents0_GLVW2_BM0:
  v_cmp_eq_u32_e64 vcc, v5, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW2_BM0_VW0
label_ShiftVectorComponents0_GLVW3_BM0:
  v_cmp_eq_u32_e64 vcc, v5, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW3_BM0_VW0
label_ShiftVectorComponents0_GLVW4_BM0:
  v_cmp_eq_u32_e64 vcc, v5, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW4_BM0_VW0
label_ShiftVectorComponents0_GLVW5_BM0:
  v_cmp_eq_u32_e64 vcc, v5, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW5_BM0_VW0
label_ShiftVectorComponents0_GLVW6_BM0:
  v_cmp_eq_u32_e64 vcc, v5, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW6_BM0_VW0
label_ShiftVectorComponents0_GLVW7_BM0:
  v_cmp_eq_u32_e64 vcc, v5, 0
  s_cbranch_vccnz label_ShiftVectorComponents0_GLVW7_BM0_VW0
label_ShiftVectorComponents0_GLVW1_BM0_VW0:
  s_mov_b32 s8, 0
  v_cmpx_eq_u32_e64 s[8:9], v6, s8
  v_and_b32_e32 v0, 63, v124
  v_lshlrev_b32_e32 v0, 2, v0
  v_accvgpr_read_b32 v7, a12
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a0, v7
  v_accvgpr_read_b32 v7, a28
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a16, v7
  v_accvgpr_read_b32 v7, a44
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a32, v7
  v_accvgpr_read_b32 v7, a60
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a48, v7
  v_accvgpr_read_b32 v7, a13
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a1, v7
  v_accvgpr_read_b32 v7, a29
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a17, v7
  v_accvgpr_read_b32 v7, a45
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a33, v7
  v_accvgpr_read_b32 v7, a61
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a49, v7
  v_accvgpr_read_b32 v7, a14
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a2, v7
  v_accvgpr_read_b32 v7, a30
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a18, v7
  v_accvgpr_read_b32 v7, a46
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a34, v7
  v_accvgpr_read_b32 v7, a62
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a50, v7
  v_accvgpr_read_b32 v7, a15
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a3, v7
  v_accvgpr_read_b32 v7, a31
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a19, v7
  v_accvgpr_read_b32 v7, a47
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a35, v7
  v_accvgpr_read_b32 v7, a63
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a51, v7
  s_mov_b64 s[8:9], -1
  s_or_saveexec_b64 vcc, s[8:9]
  s_branch label_ShiftVectorComponents0_GLVW0
label_ShiftVectorComponents0_GLVW2_BM0_VW0:
  s_mov_b32 s8, 0
  v_cmpx_eq_u32_e64 s[8:9], v6, s8
  v_and_b32_e32 v0, 63, v124
  v_lshlrev_b32_e32 v0, 2, v0
  v_accvgpr_read_b32 v7, a8
  v_accvgpr_read_b32 v8, a12
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a0, v7
  v_accvgpr_write_b32 a4, v8
  v_accvgpr_read_b32 v7, a24
  v_accvgpr_read_b32 v8, a28
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a16, v7
  v_accvgpr_write_b32 a20, v8
  v_accvgpr_read_b32 v7, a40
  v_accvgpr_read_b32 v8, a44
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a32, v7
  v_accvgpr_write_b32 a36, v8
  v_accvgpr_read_b32 v7, a56
  v_accvgpr_read_b32 v8, a60
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a48, v7
  v_accvgpr_write_b32 a52, v8
  v_accvgpr_read_b32 v7, a9
  v_accvgpr_read_b32 v8, a13
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a1, v7
  v_accvgpr_write_b32 a5, v8
  v_accvgpr_read_b32 v7, a25
  v_accvgpr_read_b32 v8, a29
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a17, v7
  v_accvgpr_write_b32 a21, v8
  v_accvgpr_read_b32 v7, a41
  v_accvgpr_read_b32 v8, a45
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a33, v7
  v_accvgpr_write_b32 a37, v8
  v_accvgpr_read_b32 v7, a57
  v_accvgpr_read_b32 v8, a61
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a49, v7
  v_accvgpr_write_b32 a53, v8
  v_accvgpr_read_b32 v7, a10
  v_accvgpr_read_b32 v8, a14
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a2, v7
  v_accvgpr_write_b32 a6, v8
  v_accvgpr_read_b32 v7, a26
  v_accvgpr_read_b32 v8, a30
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a18, v7
  v_accvgpr_write_b32 a22, v8
  v_accvgpr_read_b32 v7, a42
  v_accvgpr_read_b32 v8, a46
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a34, v7
  v_accvgpr_write_b32 a38, v8
  v_accvgpr_read_b32 v7, a58
  v_accvgpr_read_b32 v8, a62
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a50, v7
  v_accvgpr_write_b32 a54, v8
  v_accvgpr_read_b32 v7, a11
  v_accvgpr_read_b32 v8, a15
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a3, v7
  v_accvgpr_write_b32 a7, v8
  v_accvgpr_read_b32 v7, a27
  v_accvgpr_read_b32 v8, a31
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a19, v7
  v_accvgpr_write_b32 a23, v8
  v_accvgpr_read_b32 v7, a43
  v_accvgpr_read_b32 v8, a47
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a35, v7
  v_accvgpr_write_b32 a39, v8
  v_accvgpr_read_b32 v7, a59
  v_accvgpr_read_b32 v8, a63
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a51, v7
  v_accvgpr_write_b32 a55, v8
  s_mov_b64 s[8:9], -1
  s_or_saveexec_b64 vcc, s[8:9]
  s_branch label_ShiftVectorComponents0_GLVW0
label_ShiftVectorComponents0_GLVW3_BM0_VW0:
  s_mov_b32 s8, 0
  v_cmpx_eq_u32_e64 s[8:9], v6, s8
  v_and_b32_e32 v0, 63, v124
  v_lshlrev_b32_e32 v0, 2, v0
  v_accvgpr_read_b32 v7, a4
  v_accvgpr_read_b32 v8, a8
  v_accvgpr_read_b32 v9, a12
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a0, v7
  v_accvgpr_write_b32 a4, v8
  v_accvgpr_write_b32 a8, v9
  v_accvgpr_read_b32 v7, a20
  v_accvgpr_read_b32 v8, a24
  v_accvgpr_read_b32 v9, a28
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a16, v7
  v_accvgpr_write_b32 a20, v8
  v_accvgpr_write_b32 a24, v9
  v_accvgpr_read_b32 v7, a36
  v_accvgpr_read_b32 v8, a40
  v_accvgpr_read_b32 v9, a44
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a32, v7
  v_accvgpr_write_b32 a36, v8
  v_accvgpr_write_b32 a40, v9
  v_accvgpr_read_b32 v7, a52
  v_accvgpr_read_b32 v8, a56
  v_accvgpr_read_b32 v9, a60
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a48, v7
  v_accvgpr_write_b32 a52, v8
  v_accvgpr_write_b32 a56, v9
  v_accvgpr_read_b32 v7, a5
  v_accvgpr_read_b32 v8, a9
  v_accvgpr_read_b32 v9, a13
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a1, v7
  v_accvgpr_write_b32 a5, v8
  v_accvgpr_write_b32 a9, v9
  v_accvgpr_read_b32 v7, a21
  v_accvgpr_read_b32 v8, a25
  v_accvgpr_read_b32 v9, a29
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a17, v7
  v_accvgpr_write_b32 a21, v8
  v_accvgpr_write_b32 a25, v9
  v_accvgpr_read_b32 v7, a37
  v_accvgpr_read_b32 v8, a41
  v_accvgpr_read_b32 v9, a45
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a33, v7
  v_accvgpr_write_b32 a37, v8
  v_accvgpr_write_b32 a41, v9
  v_accvgpr_read_b32 v7, a53
  v_accvgpr_read_b32 v8, a57
  v_accvgpr_read_b32 v9, a61
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a49, v7
  v_accvgpr_write_b32 a53, v8
  v_accvgpr_write_b32 a57, v9
  v_accvgpr_read_b32 v7, a6
  v_accvgpr_read_b32 v8, a10
  v_accvgpr_read_b32 v9, a14
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a2, v7
  v_accvgpr_write_b32 a6, v8
  v_accvgpr_write_b32 a10, v9
  v_accvgpr_read_b32 v7, a22
  v_accvgpr_read_b32 v8, a26
  v_accvgpr_read_b32 v9, a30
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a18, v7
  v_accvgpr_write_b32 a22, v8
  v_accvgpr_write_b32 a26, v9
  v_accvgpr_read_b32 v7, a38
  v_accvgpr_read_b32 v8, a42
  v_accvgpr_read_b32 v9, a46
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a34, v7
  v_accvgpr_write_b32 a38, v8
  v_accvgpr_write_b32 a42, v9
  v_accvgpr_read_b32 v7, a54
  v_accvgpr_read_b32 v8, a58
  v_accvgpr_read_b32 v9, a62
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a50, v7
  v_accvgpr_write_b32 a54, v8
  v_accvgpr_write_b32 a58, v9
  v_accvgpr_read_b32 v7, a7
  v_accvgpr_read_b32 v8, a11
  v_accvgpr_read_b32 v9, a15
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a3, v7
  v_accvgpr_write_b32 a7, v8
  v_accvgpr_write_b32 a11, v9
  v_accvgpr_read_b32 v7, a23
  v_accvgpr_read_b32 v8, a27
  v_accvgpr_read_b32 v9, a31
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a19, v7
  v_accvgpr_write_b32 a23, v8
  v_accvgpr_write_b32 a27, v9
  v_accvgpr_read_b32 v7, a39
  v_accvgpr_read_b32 v8, a43
  v_accvgpr_read_b32 v9, a47
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a35, v7
  v_accvgpr_write_b32 a39, v8
  v_accvgpr_write_b32 a43, v9
  v_accvgpr_read_b32 v7, a55
  v_accvgpr_read_b32 v8, a59
  v_accvgpr_read_b32 v9, a63
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a51, v7
  v_accvgpr_write_b32 a55, v8
  v_accvgpr_write_b32 a59, v9
  s_mov_b64 s[8:9], -1
  s_or_saveexec_b64 vcc, s[8:9]
  s_branch label_ShiftVectorComponents0_GLVW0
label_ShiftVectorComponents0_GLVW4_BM0_VW0:
  s_mov_b32 s8, 0
  v_cmpx_eq_u32_e64 s[8:9], v6, s8
  v_and_b32_e32 v0, 63, v124
  v_lshlrev_b32_e32 v0, 2, v0
  v_accvgpr_read_b32 v7, a0
  v_accvgpr_read_b32 v8, a4
  v_accvgpr_read_b32 v9, a8
  v_accvgpr_read_b32 v10, a12
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a0, v7
  v_accvgpr_write_b32 a4, v8
  v_accvgpr_write_b32 a8, v9
  v_accvgpr_write_b32 a12, v10
  v_accvgpr_read_b32 v7, a16
  v_accvgpr_read_b32 v8, a20
  v_accvgpr_read_b32 v9, a24
  v_accvgpr_read_b32 v10, a28
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a16, v7
  v_accvgpr_write_b32 a20, v8
  v_accvgpr_write_b32 a24, v9
  v_accvgpr_write_b32 a28, v10
  v_accvgpr_read_b32 v7, a32
  v_accvgpr_read_b32 v8, a36
  v_accvgpr_read_b32 v9, a40
  v_accvgpr_read_b32 v10, a44
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a32, v7
  v_accvgpr_write_b32 a36, v8
  v_accvgpr_write_b32 a40, v9
  v_accvgpr_write_b32 a44, v10
  v_accvgpr_read_b32 v7, a48
  v_accvgpr_read_b32 v8, a52
  v_accvgpr_read_b32 v9, a56
  v_accvgpr_read_b32 v10, a60
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a48, v7
  v_accvgpr_write_b32 a52, v8
  v_accvgpr_write_b32 a56, v9
  v_accvgpr_write_b32 a60, v10
  v_accvgpr_read_b32 v7, a1
  v_accvgpr_read_b32 v8, a5
  v_accvgpr_read_b32 v9, a9
  v_accvgpr_read_b32 v10, a13
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a1, v7
  v_accvgpr_write_b32 a5, v8
  v_accvgpr_write_b32 a9, v9
  v_accvgpr_write_b32 a13, v10
  v_accvgpr_read_b32 v7, a17
  v_accvgpr_read_b32 v8, a21
  v_accvgpr_read_b32 v9, a25
  v_accvgpr_read_b32 v10, a29
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a17, v7
  v_accvgpr_write_b32 a21, v8
  v_accvgpr_write_b32 a25, v9
  v_accvgpr_write_b32 a29, v10
  v_accvgpr_read_b32 v7, a33
  v_accvgpr_read_b32 v8, a37
  v_accvgpr_read_b32 v9, a41
  v_accvgpr_read_b32 v10, a45
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a33, v7
  v_accvgpr_write_b32 a37, v8
  v_accvgpr_write_b32 a41, v9
  v_accvgpr_write_b32 a45, v10
  v_accvgpr_read_b32 v7, a49
  v_accvgpr_read_b32 v8, a53
  v_accvgpr_read_b32 v9, a57
  v_accvgpr_read_b32 v10, a61
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a49, v7
  v_accvgpr_write_b32 a53, v8
  v_accvgpr_write_b32 a57, v9
  v_accvgpr_write_b32 a61, v10
  v_accvgpr_read_b32 v7, a2
  v_accvgpr_read_b32 v8, a6
  v_accvgpr_read_b32 v9, a10
  v_accvgpr_read_b32 v10, a14
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a2, v7
  v_accvgpr_write_b32 a6, v8
  v_accvgpr_write_b32 a10, v9
  v_accvgpr_write_b32 a14, v10
  v_accvgpr_read_b32 v7, a18
  v_accvgpr_read_b32 v8, a22
  v_accvgpr_read_b32 v9, a26
  v_accvgpr_read_b32 v10, a30
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a18, v7
  v_accvgpr_write_b32 a22, v8
  v_accvgpr_write_b32 a26, v9
  v_accvgpr_write_b32 a30, v10
  v_accvgpr_read_b32 v7, a34
  v_accvgpr_read_b32 v8, a38
  v_accvgpr_read_b32 v9, a42
  v_accvgpr_read_b32 v10, a46
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a34, v7
  v_accvgpr_write_b32 a38, v8
  v_accvgpr_write_b32 a42, v9
  v_accvgpr_write_b32 a46, v10
  v_accvgpr_read_b32 v7, a50
  v_accvgpr_read_b32 v8, a54
  v_accvgpr_read_b32 v9, a58
  v_accvgpr_read_b32 v10, a62
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a50, v7
  v_accvgpr_write_b32 a54, v8
  v_accvgpr_write_b32 a58, v9
  v_accvgpr_write_b32 a62, v10
  v_accvgpr_read_b32 v7, a3
  v_accvgpr_read_b32 v8, a7
  v_accvgpr_read_b32 v9, a11
  v_accvgpr_read_b32 v10, a15
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a3, v7
  v_accvgpr_write_b32 a7, v8
  v_accvgpr_write_b32 a11, v9
  v_accvgpr_write_b32 a15, v10
  v_accvgpr_read_b32 v7, a19
  v_accvgpr_read_b32 v8, a23
  v_accvgpr_read_b32 v9, a27
  v_accvgpr_read_b32 v10, a31
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a19, v7
  v_accvgpr_write_b32 a23, v8
  v_accvgpr_write_b32 a27, v9
  v_accvgpr_write_b32 a31, v10
  v_accvgpr_read_b32 v7, a35
  v_accvgpr_read_b32 v8, a39
  v_accvgpr_read_b32 v9, a43
  v_accvgpr_read_b32 v10, a47
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a35, v7
  v_accvgpr_write_b32 a39, v8
  v_accvgpr_write_b32 a43, v9
  v_accvgpr_write_b32 a47, v10
  v_accvgpr_read_b32 v7, a51
  v_accvgpr_read_b32 v8, a55
  v_accvgpr_read_b32 v9, a59
  v_accvgpr_read_b32 v10, a63
  s_nop 1
  ds_bpermute_b32 v7, v0, v7 offset:4
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a51, v7
  v_accvgpr_write_b32 a55, v8
  v_accvgpr_write_b32 a59, v9
  v_accvgpr_write_b32 a63, v10
  s_mov_b64 s[8:9], -1
  s_or_saveexec_b64 vcc, s[8:9]
  s_branch label_ShiftVectorComponents0_GLVW0
label_ShiftVectorComponents0_GLVW5_BM0_VW0:
  s_mov_b32 s8, 0
  v_cmpx_eq_u32_e64 s[8:9], v6, s8
  v_and_b32_e32 v0, 63, v124
  v_lshlrev_b32_e32 v0, 2, v0
  v_accvgpr_read_b32 v7, a12
  v_accvgpr_read_b32 v8, a0
  v_accvgpr_read_b32 v9, a4
  v_accvgpr_read_b32 v10, a8
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a0, v7
  v_accvgpr_write_b32 a4, v8
  v_accvgpr_write_b32 a8, v9
  v_accvgpr_write_b32 a12, v10
  v_accvgpr_read_b32 v7, a28
  v_accvgpr_read_b32 v8, a16
  v_accvgpr_read_b32 v9, a20
  v_accvgpr_read_b32 v10, a24
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a16, v7
  v_accvgpr_write_b32 a20, v8
  v_accvgpr_write_b32 a24, v9
  v_accvgpr_write_b32 a28, v10
  v_accvgpr_read_b32 v7, a44
  v_accvgpr_read_b32 v8, a32
  v_accvgpr_read_b32 v9, a36
  v_accvgpr_read_b32 v10, a40
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a32, v7
  v_accvgpr_write_b32 a36, v8
  v_accvgpr_write_b32 a40, v9
  v_accvgpr_write_b32 a44, v10
  v_accvgpr_read_b32 v7, a60
  v_accvgpr_read_b32 v8, a48
  v_accvgpr_read_b32 v9, a52
  v_accvgpr_read_b32 v10, a56
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a48, v7
  v_accvgpr_write_b32 a52, v8
  v_accvgpr_write_b32 a56, v9
  v_accvgpr_write_b32 a60, v10
  v_accvgpr_read_b32 v7, a13
  v_accvgpr_read_b32 v8, a1
  v_accvgpr_read_b32 v9, a5
  v_accvgpr_read_b32 v10, a9
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a1, v7
  v_accvgpr_write_b32 a5, v8
  v_accvgpr_write_b32 a9, v9
  v_accvgpr_write_b32 a13, v10
  v_accvgpr_read_b32 v7, a29
  v_accvgpr_read_b32 v8, a17
  v_accvgpr_read_b32 v9, a21
  v_accvgpr_read_b32 v10, a25
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a17, v7
  v_accvgpr_write_b32 a21, v8
  v_accvgpr_write_b32 a25, v9
  v_accvgpr_write_b32 a29, v10
  v_accvgpr_read_b32 v7, a45
  v_accvgpr_read_b32 v8, a33
  v_accvgpr_read_b32 v9, a37
  v_accvgpr_read_b32 v10, a41
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a33, v7
  v_accvgpr_write_b32 a37, v8
  v_accvgpr_write_b32 a41, v9
  v_accvgpr_write_b32 a45, v10
  v_accvgpr_read_b32 v7, a61
  v_accvgpr_read_b32 v8, a49
  v_accvgpr_read_b32 v9, a53
  v_accvgpr_read_b32 v10, a57
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a49, v7
  v_accvgpr_write_b32 a53, v8
  v_accvgpr_write_b32 a57, v9
  v_accvgpr_write_b32 a61, v10
  v_accvgpr_read_b32 v7, a14
  v_accvgpr_read_b32 v8, a2
  v_accvgpr_read_b32 v9, a6
  v_accvgpr_read_b32 v10, a10
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a2, v7
  v_accvgpr_write_b32 a6, v8
  v_accvgpr_write_b32 a10, v9
  v_accvgpr_write_b32 a14, v10
  v_accvgpr_read_b32 v7, a30
  v_accvgpr_read_b32 v8, a18
  v_accvgpr_read_b32 v9, a22
  v_accvgpr_read_b32 v10, a26
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a18, v7
  v_accvgpr_write_b32 a22, v8
  v_accvgpr_write_b32 a26, v9
  v_accvgpr_write_b32 a30, v10
  v_accvgpr_read_b32 v7, a46
  v_accvgpr_read_b32 v8, a34
  v_accvgpr_read_b32 v9, a38
  v_accvgpr_read_b32 v10, a42
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a34, v7
  v_accvgpr_write_b32 a38, v8
  v_accvgpr_write_b32 a42, v9
  v_accvgpr_write_b32 a46, v10
  v_accvgpr_read_b32 v7, a62
  v_accvgpr_read_b32 v8, a50
  v_accvgpr_read_b32 v9, a54
  v_accvgpr_read_b32 v10, a58
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a50, v7
  v_accvgpr_write_b32 a54, v8
  v_accvgpr_write_b32 a58, v9
  v_accvgpr_write_b32 a62, v10
  v_accvgpr_read_b32 v7, a15
  v_accvgpr_read_b32 v8, a3
  v_accvgpr_read_b32 v9, a7
  v_accvgpr_read_b32 v10, a11
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a3, v7
  v_accvgpr_write_b32 a7, v8
  v_accvgpr_write_b32 a11, v9
  v_accvgpr_write_b32 a15, v10
  v_accvgpr_read_b32 v7, a31
  v_accvgpr_read_b32 v8, a19
  v_accvgpr_read_b32 v9, a23
  v_accvgpr_read_b32 v10, a27
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a19, v7
  v_accvgpr_write_b32 a23, v8
  v_accvgpr_write_b32 a27, v9
  v_accvgpr_write_b32 a31, v10
  v_accvgpr_read_b32 v7, a47
  v_accvgpr_read_b32 v8, a35
  v_accvgpr_read_b32 v9, a39
  v_accvgpr_read_b32 v10, a43
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a35, v7
  v_accvgpr_write_b32 a39, v8
  v_accvgpr_write_b32 a43, v9
  v_accvgpr_write_b32 a47, v10
  v_accvgpr_read_b32 v7, a63
  v_accvgpr_read_b32 v8, a51
  v_accvgpr_read_b32 v9, a55
  v_accvgpr_read_b32 v10, a59
  s_nop 1
  ds_bpermute_b32 v8, v0, v8 offset:4
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a51, v7
  v_accvgpr_write_b32 a55, v8
  v_accvgpr_write_b32 a59, v9
  v_accvgpr_write_b32 a63, v10
  s_mov_b64 s[8:9], -1
  s_or_saveexec_b64 vcc, s[8:9]
  s_branch label_ShiftVectorComponents0_GLVW0
label_ShiftVectorComponents0_GLVW6_BM0_VW0:
  s_mov_b32 s8, 0
  v_cmpx_eq_u32_e64 s[8:9], v6, s8
  v_and_b32_e32 v0, 63, v124
  v_lshlrev_b32_e32 v0, 2, v0
  v_accvgpr_read_b32 v7, a8
  v_accvgpr_read_b32 v8, a12
  v_accvgpr_read_b32 v9, a0
  v_accvgpr_read_b32 v10, a4
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a0, v7
  v_accvgpr_write_b32 a4, v8
  v_accvgpr_write_b32 a8, v9
  v_accvgpr_write_b32 a12, v10
  v_accvgpr_read_b32 v7, a24
  v_accvgpr_read_b32 v8, a28
  v_accvgpr_read_b32 v9, a16
  v_accvgpr_read_b32 v10, a20
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a16, v7
  v_accvgpr_write_b32 a20, v8
  v_accvgpr_write_b32 a24, v9
  v_accvgpr_write_b32 a28, v10
  v_accvgpr_read_b32 v7, a40
  v_accvgpr_read_b32 v8, a44
  v_accvgpr_read_b32 v9, a32
  v_accvgpr_read_b32 v10, a36
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a32, v7
  v_accvgpr_write_b32 a36, v8
  v_accvgpr_write_b32 a40, v9
  v_accvgpr_write_b32 a44, v10
  v_accvgpr_read_b32 v7, a56
  v_accvgpr_read_b32 v8, a60
  v_accvgpr_read_b32 v9, a48
  v_accvgpr_read_b32 v10, a52
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a48, v7
  v_accvgpr_write_b32 a52, v8
  v_accvgpr_write_b32 a56, v9
  v_accvgpr_write_b32 a60, v10
  v_accvgpr_read_b32 v7, a9
  v_accvgpr_read_b32 v8, a13
  v_accvgpr_read_b32 v9, a1
  v_accvgpr_read_b32 v10, a5
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a1, v7
  v_accvgpr_write_b32 a5, v8
  v_accvgpr_write_b32 a9, v9
  v_accvgpr_write_b32 a13, v10
  v_accvgpr_read_b32 v7, a25
  v_accvgpr_read_b32 v8, a29
  v_accvgpr_read_b32 v9, a17
  v_accvgpr_read_b32 v10, a21
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a17, v7
  v_accvgpr_write_b32 a21, v8
  v_accvgpr_write_b32 a25, v9
  v_accvgpr_write_b32 a29, v10
  v_accvgpr_read_b32 v7, a41
  v_accvgpr_read_b32 v8, a45
  v_accvgpr_read_b32 v9, a33
  v_accvgpr_read_b32 v10, a37
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a33, v7
  v_accvgpr_write_b32 a37, v8
  v_accvgpr_write_b32 a41, v9
  v_accvgpr_write_b32 a45, v10
  v_accvgpr_read_b32 v7, a57
  v_accvgpr_read_b32 v8, a61
  v_accvgpr_read_b32 v9, a49
  v_accvgpr_read_b32 v10, a53
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a49, v7
  v_accvgpr_write_b32 a53, v8
  v_accvgpr_write_b32 a57, v9
  v_accvgpr_write_b32 a61, v10
  v_accvgpr_read_b32 v7, a10
  v_accvgpr_read_b32 v8, a14
  v_accvgpr_read_b32 v9, a2
  v_accvgpr_read_b32 v10, a6
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a2, v7
  v_accvgpr_write_b32 a6, v8
  v_accvgpr_write_b32 a10, v9
  v_accvgpr_write_b32 a14, v10
  v_accvgpr_read_b32 v7, a26
  v_accvgpr_read_b32 v8, a30
  v_accvgpr_read_b32 v9, a18
  v_accvgpr_read_b32 v10, a22
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a18, v7
  v_accvgpr_write_b32 a22, v8
  v_accvgpr_write_b32 a26, v9
  v_accvgpr_write_b32 a30, v10
  v_accvgpr_read_b32 v7, a42
  v_accvgpr_read_b32 v8, a46
  v_accvgpr_read_b32 v9, a34
  v_accvgpr_read_b32 v10, a38
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a34, v7
  v_accvgpr_write_b32 a38, v8
  v_accvgpr_write_b32 a42, v9
  v_accvgpr_write_b32 a46, v10
  v_accvgpr_read_b32 v7, a58
  v_accvgpr_read_b32 v8, a62
  v_accvgpr_read_b32 v9, a50
  v_accvgpr_read_b32 v10, a54
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a50, v7
  v_accvgpr_write_b32 a54, v8
  v_accvgpr_write_b32 a58, v9
  v_accvgpr_write_b32 a62, v10
  v_accvgpr_read_b32 v7, a11
  v_accvgpr_read_b32 v8, a15
  v_accvgpr_read_b32 v9, a3
  v_accvgpr_read_b32 v10, a7
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a3, v7
  v_accvgpr_write_b32 a7, v8
  v_accvgpr_write_b32 a11, v9
  v_accvgpr_write_b32 a15, v10
  v_accvgpr_read_b32 v7, a27
  v_accvgpr_read_b32 v8, a31
  v_accvgpr_read_b32 v9, a19
  v_accvgpr_read_b32 v10, a23
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a19, v7
  v_accvgpr_write_b32 a23, v8
  v_accvgpr_write_b32 a27, v9
  v_accvgpr_write_b32 a31, v10
  v_accvgpr_read_b32 v7, a43
  v_accvgpr_read_b32 v8, a47
  v_accvgpr_read_b32 v9, a35
  v_accvgpr_read_b32 v10, a39
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a35, v7
  v_accvgpr_write_b32 a39, v8
  v_accvgpr_write_b32 a43, v9
  v_accvgpr_write_b32 a47, v10
  v_accvgpr_read_b32 v7, a59
  v_accvgpr_read_b32 v8, a63
  v_accvgpr_read_b32 v9, a51
  v_accvgpr_read_b32 v10, a55
  s_nop 1
  ds_bpermute_b32 v9, v0, v9 offset:4
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a51, v7
  v_accvgpr_write_b32 a55, v8
  v_accvgpr_write_b32 a59, v9
  v_accvgpr_write_b32 a63, v10
  s_mov_b64 s[8:9], -1
  s_or_saveexec_b64 vcc, s[8:9]
  s_branch label_ShiftVectorComponents0_GLVW0
label_ShiftVectorComponents0_GLVW7_BM0_VW0:
  s_mov_b32 s8, 0
  v_cmpx_eq_u32_e64 s[8:9], v6, s8
  v_and_b32_e32 v0, 63, v124
  v_lshlrev_b32_e32 v0, 2, v0
  v_accvgpr_read_b32 v7, a4
  v_accvgpr_read_b32 v8, a8
  v_accvgpr_read_b32 v9, a12
  v_accvgpr_read_b32 v10, a0
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a0, v7
  v_accvgpr_write_b32 a4, v8
  v_accvgpr_write_b32 a8, v9
  v_accvgpr_write_b32 a12, v10
  v_accvgpr_read_b32 v7, a20
  v_accvgpr_read_b32 v8, a24
  v_accvgpr_read_b32 v9, a28
  v_accvgpr_read_b32 v10, a16
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a16, v7
  v_accvgpr_write_b32 a20, v8
  v_accvgpr_write_b32 a24, v9
  v_accvgpr_write_b32 a28, v10
  v_accvgpr_read_b32 v7, a36
  v_accvgpr_read_b32 v8, a40
  v_accvgpr_read_b32 v9, a44
  v_accvgpr_read_b32 v10, a32
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a32, v7
  v_accvgpr_write_b32 a36, v8
  v_accvgpr_write_b32 a40, v9
  v_accvgpr_write_b32 a44, v10
  v_accvgpr_read_b32 v7, a52
  v_accvgpr_read_b32 v8, a56
  v_accvgpr_read_b32 v9, a60
  v_accvgpr_read_b32 v10, a48
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a48, v7
  v_accvgpr_write_b32 a52, v8
  v_accvgpr_write_b32 a56, v9
  v_accvgpr_write_b32 a60, v10
  v_accvgpr_read_b32 v7, a5
  v_accvgpr_read_b32 v8, a9
  v_accvgpr_read_b32 v9, a13
  v_accvgpr_read_b32 v10, a1
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a1, v7
  v_accvgpr_write_b32 a5, v8
  v_accvgpr_write_b32 a9, v9
  v_accvgpr_write_b32 a13, v10
  v_accvgpr_read_b32 v7, a21
  v_accvgpr_read_b32 v8, a25
  v_accvgpr_read_b32 v9, a29
  v_accvgpr_read_b32 v10, a17
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a17, v7
  v_accvgpr_write_b32 a21, v8
  v_accvgpr_write_b32 a25, v9
  v_accvgpr_write_b32 a29, v10
  v_accvgpr_read_b32 v7, a37
  v_accvgpr_read_b32 v8, a41
  v_accvgpr_read_b32 v9, a45
  v_accvgpr_read_b32 v10, a33
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a33, v7
  v_accvgpr_write_b32 a37, v8
  v_accvgpr_write_b32 a41, v9
  v_accvgpr_write_b32 a45, v10
  v_accvgpr_read_b32 v7, a53
  v_accvgpr_read_b32 v8, a57
  v_accvgpr_read_b32 v9, a61
  v_accvgpr_read_b32 v10, a49
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a49, v7
  v_accvgpr_write_b32 a53, v8
  v_accvgpr_write_b32 a57, v9
  v_accvgpr_write_b32 a61, v10
  v_accvgpr_read_b32 v7, a6
  v_accvgpr_read_b32 v8, a10
  v_accvgpr_read_b32 v9, a14
  v_accvgpr_read_b32 v10, a2
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a2, v7
  v_accvgpr_write_b32 a6, v8
  v_accvgpr_write_b32 a10, v9
  v_accvgpr_write_b32 a14, v10
  v_accvgpr_read_b32 v7, a22
  v_accvgpr_read_b32 v8, a26
  v_accvgpr_read_b32 v9, a30
  v_accvgpr_read_b32 v10, a18
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a18, v7
  v_accvgpr_write_b32 a22, v8
  v_accvgpr_write_b32 a26, v9
  v_accvgpr_write_b32 a30, v10
  v_accvgpr_read_b32 v7, a38
  v_accvgpr_read_b32 v8, a42
  v_accvgpr_read_b32 v9, a46
  v_accvgpr_read_b32 v10, a34
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a34, v7
  v_accvgpr_write_b32 a38, v8
  v_accvgpr_write_b32 a42, v9
  v_accvgpr_write_b32 a46, v10
  v_accvgpr_read_b32 v7, a54
  v_accvgpr_read_b32 v8, a58
  v_accvgpr_read_b32 v9, a62
  v_accvgpr_read_b32 v10, a50
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a50, v7
  v_accvgpr_write_b32 a54, v8
  v_accvgpr_write_b32 a58, v9
  v_accvgpr_write_b32 a62, v10
  v_accvgpr_read_b32 v7, a7
  v_accvgpr_read_b32 v8, a11
  v_accvgpr_read_b32 v9, a15
  v_accvgpr_read_b32 v10, a3
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a3, v7
  v_accvgpr_write_b32 a7, v8
  v_accvgpr_write_b32 a11, v9
  v_accvgpr_write_b32 a15, v10
  v_accvgpr_read_b32 v7, a23
  v_accvgpr_read_b32 v8, a27
  v_accvgpr_read_b32 v9, a31
  v_accvgpr_read_b32 v10, a19
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a19, v7
  v_accvgpr_write_b32 a23, v8
  v_accvgpr_write_b32 a27, v9
  v_accvgpr_write_b32 a31, v10
  v_accvgpr_read_b32 v7, a39
  v_accvgpr_read_b32 v8, a43
  v_accvgpr_read_b32 v9, a47
  v_accvgpr_read_b32 v10, a35
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a35, v7
  v_accvgpr_write_b32 a39, v8
  v_accvgpr_write_b32 a43, v9
  v_accvgpr_write_b32 a47, v10
  v_accvgpr_read_b32 v7, a55
  v_accvgpr_read_b32 v8, a59
  v_accvgpr_read_b32 v9, a63
  v_accvgpr_read_b32 v10, a51
  s_nop 1
  ds_bpermute_b32 v10, v0, v10 offset:4
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_accvgpr_write_b32 a51, v7
  v_accvgpr_write_b32 a55, v8
  v_accvgpr_write_b32 a59, v9
  v_accvgpr_write_b32 a63, v10
  s_mov_b64 s[8:9], -1
  s_or_saveexec_b64 vcc, s[8:9]
  s_branch label_ShiftVectorComponents0_GLVW0
label_ShiftVectorComponents0_GLVW0:
  v_lshrrev_b32_e32 v4, 6, v124
  v_lshrrev_b32_e32 v5, 1, v4
  v_mul_lo_u32 v5, 16, v5
  v_and_b32_e32 v1, 63, v124
  v_lshrrev_b32_e32 v1, 4, v1
  v_lshlrev_b32_e32 v1, 2, v1
  v_add_lshl_u32 v1, v5, v1, 2
  v_mul_lo_u32 v2, v1, s38
  v_mul_lo_u32 v3, v1, s36
  v_and_b32_e32 v0, 1, v4
  v_mul_lo_u32 v0, 16, v0
  v_and_b32_e32 v5, 15, v124
  v_add_lshl_u32 v0, v5, v0, 2
  s_mul_i32 s8, 0x80, s2
  v_add_u32_e32 v0, s8, v0
  s_mul_i32 s8, 0x80, s3
  v_add_u32_e32 v1, s8, v1
  s_waitcnt lgkmcnt(0)
  s_cmp_eq_u64 s[34:35], 0
  s_cbranch_scc0 label_GSU
  s_cmp_eq_u32 s52, 1
  s_cbranch_scc1 label_GSU
  s_and_b32 s74, 0x7f, s20
  s_add_u32 s75, -1, s10
  s_cmp_ge_u32 s2, s75
  s_cselect_b32 s74, s74, 0
  s_cmpk_gt_u32 s74, 0x0
  s_cbranch_scc1 label_GW_B0_E1_M
  s_and_b32 s74, 0x7f, s21
  s_add_u32 s75, -1, s11
  s_cmp_ge_u32 s3, s75
  s_cselect_b32 s74, s74, 0
  s_cmpk_gt_u32 s74, 0x0
  s_cbranch_scc1 label_GW_B0_E1_N
label_GW_B0_E0:
  v_add_lshl_u32 v7, v3, v0, 2
  v_accvgpr_read_b32 v12, a0
  v_accvgpr_read_b32 v13, a4
  v_accvgpr_read_b32 v14, a8
  v_accvgpr_read_b32 v15, a12
  v_accvgpr_read_b32 v16, a16
  v_accvgpr_read_b32 v17, a20
  v_accvgpr_read_b32 v18, a24
  v_accvgpr_read_b32 v19, a28
  v_accvgpr_read_b32 v20, a32
  v_accvgpr_read_b32 v21, a36
  v_accvgpr_read_b32 v22, a40
  v_accvgpr_read_b32 v23, a44
  v_accvgpr_read_b32 v24, a48
  v_accvgpr_read_b32 v25, a52
  v_accvgpr_read_b32 v26, a56
  v_accvgpr_read_b32 v27, a60
  v_accvgpr_read_b32 v28, a1
  v_accvgpr_read_b32 v29, a5
  v_accvgpr_read_b32 v30, a9
  v_accvgpr_read_b32 v31, a13
  v_accvgpr_read_b32 v32, a17
  v_accvgpr_read_b32 v33, a21
  v_accvgpr_read_b32 v34, a25
  v_accvgpr_read_b32 v35, a29
  v_accvgpr_read_b32 v36, a33
  v_accvgpr_read_b32 v37, a37
  v_accvgpr_read_b32 v38, a41
  v_accvgpr_read_b32 v39, a45
  v_accvgpr_read_b32 v40, a49
  v_accvgpr_read_b32 v41, a53
  v_accvgpr_read_b32 v42, a57
  v_accvgpr_read_b32 v43, a61
  v_accvgpr_read_b32 v44, a2
  v_accvgpr_read_b32 v45, a6
  v_accvgpr_read_b32 v46, a10
  v_accvgpr_read_b32 v47, a14
  v_accvgpr_read_b32 v48, a18
  v_accvgpr_read_b32 v49, a22
  v_accvgpr_read_b32 v50, a26
  v_accvgpr_read_b32 v51, a30
  v_accvgpr_read_b32 v52, a34
  v_accvgpr_read_b32 v53, a38
  v_accvgpr_read_b32 v54, a42
  v_accvgpr_read_b32 v55, a46
  v_accvgpr_read_b32 v56, a50
  v_accvgpr_read_b32 v57, a54
  v_accvgpr_read_b32 v58, a58
  v_accvgpr_read_b32 v59, a62
  v_accvgpr_read_b32 v60, a3
  v_accvgpr_read_b32 v61, a7
  v_accvgpr_read_b32 v62, a11
  v_accvgpr_read_b32 v63, a15
  v_accvgpr_read_b32 v64, a19
  v_accvgpr_read_b32 v65, a23
  v_accvgpr_read_b32 v66, a27
  v_accvgpr_read_b32 v67, a31
  v_accvgpr_read_b32 v68, a35
  v_accvgpr_read_b32 v69, a39
  v_accvgpr_read_b32 v70, a43
  v_accvgpr_read_b32 v71, a47
  v_accvgpr_read_b32 v72, a51
  v_accvgpr_read_b32 v73, a55
  v_accvgpr_read_b32 v74, a59
  v_accvgpr_read_b32 v75, a63
  buffer_store_dwordx4 v[12:15], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[16:19], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[20:23], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[24:27], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[28:31], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[32:35], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[36:39], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[40:43], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[44:47], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[48:51], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[52:55], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[56:59], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[60:63], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[64:67], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[68:71], v7, s[12:15], 0 offen
  s_lshl_b32 s8, s36, 2
  s_add_u32 s12, s12, s8
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx4 v[72:75], v7, s[12:15], 0 offen
  s_nop 0
  s_branch label_GW_End
label_GW_B0_E1_N:
  v_mov_b32_e32 v6, 0x80000000
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v7, v3, v0, 2
  v_cndmask_b32_e64 v7, v6, v7, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v72, v3, v0, 2
  v_cndmask_b32_e64 v72, v6, v72, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v73, v3, v0, 2
  v_cndmask_b32_e64 v73, v6, v73, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v74, v3, v0, 2
  v_cndmask_b32_e64 v74, v6, v74, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v75, v3, v0, 2
  v_cndmask_b32_e64 v75, v6, v75, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v76, v3, v0, 2
  v_cndmask_b32_e64 v76, v6, v76, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v77, v3, v0, 2
  v_cndmask_b32_e64 v77, v6, v77, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v78, v3, v0, 2
  v_cndmask_b32_e64 v78, v6, v78, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v79, v3, v0, 2
  v_cndmask_b32_e64 v79, v6, v79, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v80, v3, v0, 2
  v_cndmask_b32_e64 v80, v6, v80, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v81, v3, v0, 2
  v_cndmask_b32_e64 v81, v6, v81, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v82, v3, v0, 2
  v_cndmask_b32_e64 v82, v6, v82, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v83, v3, v0, 2
  v_cndmask_b32_e64 v83, v6, v83, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v84, v3, v0, 2
  v_cndmask_b32_e64 v84, v6, v84, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v85, v3, v0, 2
  v_cndmask_b32_e64 v85, v6, v85, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v86, v3, v0, 2
  v_cndmask_b32_e64 v86, v6, v86, s[78:79]
  v_accvgpr_read_b32 v8, a0
  v_accvgpr_read_b32 v9, a4
  v_accvgpr_read_b32 v10, a8
  v_accvgpr_read_b32 v11, a12
  v_accvgpr_read_b32 v12, a16
  v_accvgpr_read_b32 v13, a20
  v_accvgpr_read_b32 v14, a24
  v_accvgpr_read_b32 v15, a28
  v_accvgpr_read_b32 v16, a32
  v_accvgpr_read_b32 v17, a36
  v_accvgpr_read_b32 v18, a40
  v_accvgpr_read_b32 v19, a44
  v_accvgpr_read_b32 v20, a48
  v_accvgpr_read_b32 v21, a52
  v_accvgpr_read_b32 v22, a56
  v_accvgpr_read_b32 v23, a60
  v_accvgpr_read_b32 v24, a1
  v_accvgpr_read_b32 v25, a5
  v_accvgpr_read_b32 v26, a9
  v_accvgpr_read_b32 v27, a13
  v_accvgpr_read_b32 v28, a17
  v_accvgpr_read_b32 v29, a21
  v_accvgpr_read_b32 v30, a25
  v_accvgpr_read_b32 v31, a29
  v_accvgpr_read_b32 v32, a33
  v_accvgpr_read_b32 v33, a37
  v_accvgpr_read_b32 v34, a41
  v_accvgpr_read_b32 v35, a45
  v_accvgpr_read_b32 v36, a49
  v_accvgpr_read_b32 v37, a53
  v_accvgpr_read_b32 v38, a57
  v_accvgpr_read_b32 v39, a61
  v_accvgpr_read_b32 v40, a2
  v_accvgpr_read_b32 v41, a6
  v_accvgpr_read_b32 v42, a10
  v_accvgpr_read_b32 v43, a14
  v_accvgpr_read_b32 v44, a18
  v_accvgpr_read_b32 v45, a22
  v_accvgpr_read_b32 v46, a26
  v_accvgpr_read_b32 v47, a30
  v_accvgpr_read_b32 v48, a34
  v_accvgpr_read_b32 v49, a38
  v_accvgpr_read_b32 v50, a42
  v_accvgpr_read_b32 v51, a46
  v_accvgpr_read_b32 v52, a50
  v_accvgpr_read_b32 v53, a54
  v_accvgpr_read_b32 v54, a58
  v_accvgpr_read_b32 v55, a62
  v_accvgpr_read_b32 v56, a3
  v_accvgpr_read_b32 v57, a7
  v_accvgpr_read_b32 v58, a11
  v_accvgpr_read_b32 v59, a15
  v_accvgpr_read_b32 v60, a19
  v_accvgpr_read_b32 v61, a23
  v_accvgpr_read_b32 v62, a27
  v_accvgpr_read_b32 v63, a31
  v_accvgpr_read_b32 v64, a35
  v_accvgpr_read_b32 v65, a39
  v_accvgpr_read_b32 v66, a43
  v_accvgpr_read_b32 v67, a47
  v_accvgpr_read_b32 v68, a51
  v_accvgpr_read_b32 v69, a55
  v_accvgpr_read_b32 v70, a59
  v_accvgpr_read_b32 v71, a63
  buffer_store_dwordx4 v[8:11], v7, s[12:15], 0 offen
  buffer_store_dwordx4 v[12:15], v72, s[12:15], 0 offen
  buffer_store_dwordx4 v[16:19], v73, s[12:15], 0 offen
  buffer_store_dwordx4 v[20:23], v74, s[12:15], 0 offen
  buffer_store_dwordx4 v[24:27], v75, s[12:15], 0 offen
  buffer_store_dwordx4 v[28:31], v76, s[12:15], 0 offen
  buffer_store_dwordx4 v[32:35], v77, s[12:15], 0 offen
  buffer_store_dwordx4 v[36:39], v78, s[12:15], 0 offen
  buffer_store_dwordx4 v[40:43], v79, s[12:15], 0 offen
  buffer_store_dwordx4 v[44:47], v80, s[12:15], 0 offen
  buffer_store_dwordx4 v[48:51], v81, s[12:15], 0 offen
  buffer_store_dwordx4 v[52:55], v82, s[12:15], 0 offen
  buffer_store_dwordx4 v[56:59], v83, s[12:15], 0 offen
  buffer_store_dwordx4 v[60:63], v84, s[12:15], 0 offen
  buffer_store_dwordx4 v[64:67], v85, s[12:15], 0 offen
  buffer_store_dwordx4 v[68:71], v86, s[12:15], 0 offen
  s_nop 0
  s_branch label_GW_End
label_GW_B0_E1_M:
  v_mov_b32_e32 v6, 0x80000000
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v71, v3, v0, 2
  v_cndmask_b32_e64 v71, v6, v71, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v72, v3, v4, 2
  v_cndmask_b32_e64 v72, v6, v72, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v73, v3, v4, 2
  v_cndmask_b32_e64 v73, v6, v73, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v74, v3, v4, 2
  v_cndmask_b32_e64 v74, v6, v74, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v75, v3, v0, 2
  v_cndmask_b32_e64 v75, v6, v75, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v76, v3, v4, 2
  v_cndmask_b32_e64 v76, v6, v76, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v77, v3, v4, 2
  v_cndmask_b32_e64 v77, v6, v77, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v78, v3, v4, 2
  v_cndmask_b32_e64 v78, v6, v78, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v79, v3, v0, 2
  v_cndmask_b32_e64 v79, v6, v79, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v80, v3, v4, 2
  v_cndmask_b32_e64 v80, v6, v80, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v81, v3, v4, 2
  v_cndmask_b32_e64 v81, v6, v81, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v82, v3, v4, 2
  v_cndmask_b32_e64 v82, v6, v82, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v83, v3, v0, 2
  v_cndmask_b32_e64 v83, v6, v83, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v84, v3, v4, 2
  v_cndmask_b32_e64 v84, v6, v84, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v85, v3, v4, 2
  v_cndmask_b32_e64 v85, v6, v85, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v86, v3, v4, 2
  v_cndmask_b32_e64 v86, v6, v86, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v87, v3, v0, 2
  v_cndmask_b32_e64 v87, v6, v87, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v88, v3, v4, 2
  v_cndmask_b32_e64 v88, v6, v88, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v89, v3, v4, 2
  v_cndmask_b32_e64 v89, v6, v89, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v90, v3, v4, 2
  v_cndmask_b32_e64 v90, v6, v90, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v91, v3, v0, 2
  v_cndmask_b32_e64 v91, v6, v91, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v92, v3, v4, 2
  v_cndmask_b32_e64 v92, v6, v92, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v93, v3, v4, 2
  v_cndmask_b32_e64 v93, v6, v93, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v94, v3, v4, 2
  v_cndmask_b32_e64 v94, v6, v94, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v95, v3, v0, 2
  v_cndmask_b32_e64 v95, v6, v95, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v96, v3, v4, 2
  v_cndmask_b32_e64 v96, v6, v96, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v97, v3, v4, 2
  v_cndmask_b32_e64 v97, v6, v97, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v98, v3, v4, 2
  v_cndmask_b32_e64 v98, v6, v98, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v99, v3, v0, 2
  v_cndmask_b32_e64 v99, v6, v99, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v100, v3, v4, 2
  v_cndmask_b32_e64 v100, v6, v100, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v101, v3, v4, 2
  v_cndmask_b32_e64 v101, v6, v101, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v102, v3, v4, 2
  v_cndmask_b32_e64 v102, v6, v102, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v103, v3, v0, 2
  v_cndmask_b32_e64 v103, v6, v103, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v104, v3, v4, 2
  v_cndmask_b32_e64 v104, v6, v104, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v105, v3, v4, 2
  v_cndmask_b32_e64 v105, v6, v105, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v106, v3, v4, 2
  v_cndmask_b32_e64 v106, v6, v106, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v107, v3, v0, 2
  v_cndmask_b32_e64 v107, v6, v107, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v108, v3, v4, 2
  v_cndmask_b32_e64 v108, v6, v108, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v109, v3, v4, 2
  v_cndmask_b32_e64 v109, v6, v109, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v110, v3, v4, 2
  v_cndmask_b32_e64 v110, v6, v110, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v111, v3, v0, 2
  v_cndmask_b32_e64 v111, v6, v111, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v112, v3, v4, 2
  v_cndmask_b32_e64 v112, v6, v112, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v113, v3, v4, 2
  v_cndmask_b32_e64 v113, v6, v113, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v114, v3, v4, 2
  v_cndmask_b32_e64 v114, v6, v114, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v115, v3, v0, 2
  v_cndmask_b32_e64 v115, v6, v115, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v116, v3, v4, 2
  v_cndmask_b32_e64 v116, v6, v116, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v117, v3, v4, 2
  v_cndmask_b32_e64 v117, v6, v117, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v118, v3, v4, 2
  v_cndmask_b32_e64 v118, v6, v118, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v119, v3, v0, 2
  v_cndmask_b32_e64 v119, v6, v119, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v120, v3, v4, 2
  v_cndmask_b32_e64 v120, v6, v120, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v121, v3, v4, 2
  v_cndmask_b32_e64 v121, v6, v121, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v122, v3, v4, 2
  v_cndmask_b32_e64 v122, v6, v122, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v123, v3, v0, 2
  v_cndmask_b32_e64 v123, v6, v123, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v125, v3, v4, 2
  v_cndmask_b32_e64 v125, v6, v125, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v126, v3, v4, 2
  v_cndmask_b32_e64 v126, v6, v126, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v127, v3, v4, 2
  v_cndmask_b32_e64 v127, v6, v127, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v128, v3, v0, 2
  v_cndmask_b32_e64 v128, v6, v128, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v129, v3, v4, 2
  v_cndmask_b32_e64 v129, v6, v129, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v130, v3, v4, 2
  v_cndmask_b32_e64 v130, v6, v130, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v131, v3, v4, 2
  v_cndmask_b32_e64 v131, v6, v131, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v132, v3, v0, 2
  v_cndmask_b32_e64 v132, v6, v132, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v133, v3, v4, 2
  v_cndmask_b32_e64 v133, v6, v133, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v134, v3, v4, 2
  v_cndmask_b32_e64 v134, v6, v134, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v135, v3, v4, 2
  v_cndmask_b32_e64 v135, v6, v135, s[78:79]
  v_accvgpr_read_b32 v7, a0
  v_accvgpr_read_b32 v8, a4
  v_accvgpr_read_b32 v9, a8
  v_accvgpr_read_b32 v10, a12
  v_accvgpr_read_b32 v11, a16
  v_accvgpr_read_b32 v12, a20
  v_accvgpr_read_b32 v13, a24
  v_accvgpr_read_b32 v14, a28
  v_accvgpr_read_b32 v15, a32
  v_accvgpr_read_b32 v16, a36
  v_accvgpr_read_b32 v17, a40
  v_accvgpr_read_b32 v18, a44
  v_accvgpr_read_b32 v19, a48
  v_accvgpr_read_b32 v20, a52
  v_accvgpr_read_b32 v21, a56
  v_accvgpr_read_b32 v22, a60
  v_accvgpr_read_b32 v23, a1
  v_accvgpr_read_b32 v24, a5
  v_accvgpr_read_b32 v25, a9
  v_accvgpr_read_b32 v26, a13
  v_accvgpr_read_b32 v27, a17
  v_accvgpr_read_b32 v28, a21
  v_accvgpr_read_b32 v29, a25
  v_accvgpr_read_b32 v30, a29
  v_accvgpr_read_b32 v31, a33
  v_accvgpr_read_b32 v32, a37
  v_accvgpr_read_b32 v33, a41
  v_accvgpr_read_b32 v34, a45
  v_accvgpr_read_b32 v35, a49
  v_accvgpr_read_b32 v36, a53
  v_accvgpr_read_b32 v37, a57
  v_accvgpr_read_b32 v38, a61
  v_accvgpr_read_b32 v39, a2
  v_accvgpr_read_b32 v40, a6
  v_accvgpr_read_b32 v41, a10
  v_accvgpr_read_b32 v42, a14
  v_accvgpr_read_b32 v43, a18
  v_accvgpr_read_b32 v44, a22
  v_accvgpr_read_b32 v45, a26
  v_accvgpr_read_b32 v46, a30
  v_accvgpr_read_b32 v47, a34
  v_accvgpr_read_b32 v48, a38
  v_accvgpr_read_b32 v49, a42
  v_accvgpr_read_b32 v50, a46
  v_accvgpr_read_b32 v51, a50
  v_accvgpr_read_b32 v52, a54
  v_accvgpr_read_b32 v53, a58
  v_accvgpr_read_b32 v54, a62
  v_accvgpr_read_b32 v55, a3
  v_accvgpr_read_b32 v56, a7
  v_accvgpr_read_b32 v57, a11
  v_accvgpr_read_b32 v58, a15
  v_accvgpr_read_b32 v59, a19
  v_accvgpr_read_b32 v60, a23
  v_accvgpr_read_b32 v61, a27
  v_accvgpr_read_b32 v62, a31
  v_accvgpr_read_b32 v63, a35
  v_accvgpr_read_b32 v64, a39
  v_accvgpr_read_b32 v65, a43
  v_accvgpr_read_b32 v66, a47
  v_accvgpr_read_b32 v67, a51
  v_accvgpr_read_b32 v68, a55
  v_accvgpr_read_b32 v69, a59
  v_accvgpr_read_b32 v70, a63
  buffer_store_dword v7, v71, s[12:15], 0 offen
  buffer_store_dword v8, v72, s[12:15], 0 offen
  buffer_store_dword v9, v73, s[12:15], 0 offen
  buffer_store_dword v10, v74, s[12:15], 0 offen
  buffer_store_dword v11, v75, s[12:15], 0 offen
  buffer_store_dword v12, v76, s[12:15], 0 offen
  buffer_store_dword v13, v77, s[12:15], 0 offen
  buffer_store_dword v14, v78, s[12:15], 0 offen
  buffer_store_dword v15, v79, s[12:15], 0 offen
  buffer_store_dword v16, v80, s[12:15], 0 offen
  buffer_store_dword v17, v81, s[12:15], 0 offen
  buffer_store_dword v18, v82, s[12:15], 0 offen
  buffer_store_dword v19, v83, s[12:15], 0 offen
  buffer_store_dword v20, v84, s[12:15], 0 offen
  buffer_store_dword v21, v85, s[12:15], 0 offen
  buffer_store_dword v22, v86, s[12:15], 0 offen
  buffer_store_dword v23, v87, s[12:15], 0 offen
  buffer_store_dword v24, v88, s[12:15], 0 offen
  buffer_store_dword v25, v89, s[12:15], 0 offen
  buffer_store_dword v26, v90, s[12:15], 0 offen
  buffer_store_dword v27, v91, s[12:15], 0 offen
  buffer_store_dword v28, v92, s[12:15], 0 offen
  buffer_store_dword v29, v93, s[12:15], 0 offen
  buffer_store_dword v30, v94, s[12:15], 0 offen
  buffer_store_dword v31, v95, s[12:15], 0 offen
  buffer_store_dword v32, v96, s[12:15], 0 offen
  buffer_store_dword v33, v97, s[12:15], 0 offen
  buffer_store_dword v34, v98, s[12:15], 0 offen
  buffer_store_dword v35, v99, s[12:15], 0 offen
  buffer_store_dword v36, v100, s[12:15], 0 offen
  buffer_store_dword v37, v101, s[12:15], 0 offen
  buffer_store_dword v38, v102, s[12:15], 0 offen
  buffer_store_dword v39, v103, s[12:15], 0 offen
  buffer_store_dword v40, v104, s[12:15], 0 offen
  buffer_store_dword v41, v105, s[12:15], 0 offen
  buffer_store_dword v42, v106, s[12:15], 0 offen
  buffer_store_dword v43, v107, s[12:15], 0 offen
  buffer_store_dword v44, v108, s[12:15], 0 offen
  buffer_store_dword v45, v109, s[12:15], 0 offen
  buffer_store_dword v46, v110, s[12:15], 0 offen
  buffer_store_dword v47, v111, s[12:15], 0 offen
  buffer_store_dword v48, v112, s[12:15], 0 offen
  buffer_store_dword v49, v113, s[12:15], 0 offen
  buffer_store_dword v50, v114, s[12:15], 0 offen
  buffer_store_dword v51, v115, s[12:15], 0 offen
  buffer_store_dword v52, v116, s[12:15], 0 offen
  buffer_store_dword v53, v117, s[12:15], 0 offen
  buffer_store_dword v54, v118, s[12:15], 0 offen
  buffer_store_dword v55, v119, s[12:15], 0 offen
  buffer_store_dword v56, v120, s[12:15], 0 offen
  buffer_store_dword v57, v121, s[12:15], 0 offen
  buffer_store_dword v58, v122, s[12:15], 0 offen
  buffer_store_dword v59, v123, s[12:15], 0 offen
  buffer_store_dword v60, v125, s[12:15], 0 offen
  buffer_store_dword v61, v126, s[12:15], 0 offen
  buffer_store_dword v62, v127, s[12:15], 0 offen
  buffer_store_dword v63, v128, s[12:15], 0 offen
  buffer_store_dword v64, v129, s[12:15], 0 offen
  buffer_store_dword v65, v130, s[12:15], 0 offen
  buffer_store_dword v66, v131, s[12:15], 0 offen
  buffer_store_dword v67, v132, s[12:15], 0 offen
  buffer_store_dword v68, v133, s[12:15], 0 offen
  buffer_store_dword v69, v134, s[12:15], 0 offen
  buffer_store_dword v70, v135, s[12:15], 0 offen
  s_nop 0
  s_branch label_GW_End
label_GW_End:
  s_getpc_b64 s[74:75]
  s_add_i32 s76, 0x8638, 4
  s_add_u32 s74, s74, s76
  s_addc_u32 s75, s75, 0
  s_setpc_b64 s[74:75]
label_GSU:
  s_mov_b64 s[76:77], s[64:65]
  s_mov_b32 s79, 0x20000
  s_cmp_eq_u64 s[64:65], 0
  s_cbranch_scc0 label_ScaleAlphaVecAddrValid
  s_mov_b32 s78, 0
  s_branch label_ScaleAlphaVecAddrValid_End
label_ScaleAlphaVecAddrValid:
  s_mov_b32 s78, s20
label_ScaleAlphaVecAddrValid_End:
  s_mul_i32 s78, 4, s78
  s_add_u32 s8, s4, 1
  s_mul_i32 s8, s69, s8
  s_cmp_eq_u32 s8, 0
  s_cselect_b32 s8, s20, s8
  s_mov_b64 s[84:85], s[66:67]
  s_mov_b32 s87, 0x20000
  s_cmp_eq_u64 s[66:67], 0
  s_cbranch_scc0 label_BiasAddrValid
  s_mov_b32 s86, 0
  s_branch label_BiasAddrValid_End
label_BiasAddrValid:
  s_mov_b32 s86, s8
label_BiasAddrValid_End:
label_Load_Biasf32_0:
  s_cmpk_lg_u32 s68, 0x0
  s_cbranch_scc1 label_Load_Biasf16_0
  s_mul_i32 s8, 0x80, s2
  v_add_u32_e32 v8, s8, v124
  s_mul_i32 s86, 4, s86
  s_mul_i32 s8, s69, s4
  v_add_u32_e32 v6, s8, v8
  v_lshlrev_b32_e32 v6, 2, v6
  v_lshlrev_b32_e32 v7, 2, v8
  s_mul_i32 s8, 0x80, s3
  v_add_u32_e32 v8, s8, v124
  buffer_load_dword v4, v6, s[84:87], 0 offen
  buffer_load_dword v5, v7, s[76:79], 0 offen
  v_lshlrev_b32_e32 v8, 2, v124
  s_barrier
  s_waitcnt vmcnt(1)
  ds_write_b32 v8, v4
  v_cmp_gt_u32_e64 s[64:65], s78, 0
  s_waitcnt vmcnt(0)
  v_cndmask_b32_e64 v5, 1.0, v5, s[64:65]
  ds_write_b32 v8, v5 offset:1024
  s_branch label_Load_Bias_End
label_Load_Biasf16_0:
  s_cmpk_lg_u32 s68, 0x4
  s_cbranch_scc1 label_Load_Bias_End
  s_mul_i32 s8, 0x80, s2
  v_add_u32_e32 v8, s8, v124
  s_mul_i32 s86, 2, s86
  s_mul_i32 s8, s69, s4
  v_add_u32_e32 v6, s8, v8
  v_lshlrev_b32_e32 v6, 1, v6
  v_lshlrev_b32_e32 v7, 2, v8
  s_mul_i32 s8, 0x80, s3
  v_add_u32_e32 v8, s8, v124
  buffer_load_short_d16 v4, v6, s[84:87], 0 offen
  buffer_load_dword v5, v7, s[76:79], 0 offen
  v_lshlrev_b32_e32 v8, 2, v124
  s_barrier
  s_waitcnt vmcnt(1)
  v_cvt_f32_f16_e32 v4, v4
  ds_write_b32 v8, v4
  v_cmp_gt_u32_e64 s[64:65], s78, 0
  s_waitcnt vmcnt(0)
  v_cndmask_b32_e64 v5, 1.0, v5, s[64:65]
  ds_write_b32 v8, v5 offset:1024
  s_branch label_Load_Bias_End
label_Load_Bias_End:
  s_cmp_eq_u32 s56, 0
  s_cbranch_scc1 label_NoBranch_DNDXZLV5F5U6YY3J
  s_getpc_b64 s[78:79]
  s_add_i32 s80, 0x8154, 4
  s_add_u32 s78, s78, s80
  s_addc_u32 s79, s79, 0
  s_setpc_b64 s[78:79]
label_NoBranch_DNDXZLV5F5U6YY3J:
  s_cmp_eq_u32 s57, s46
  s_cbranch_scc1 label_SK_Store
  s_add_u32 s64, s53, 1
  s_mul_hi_u32 s74, s55, s47
  s_lshr_b32 s75, s48, 31
  s_mul_i32 s73, s55, s75
  s_add_u32 s73, s73, s74
  s_and_b32 s75, s48, 0x7fffffff
  s_lshr_b32 s73, s73, s75
  s_mul_i32 s73, s73, s46
  s_sub_u32 s65, s55, s73
label_SK_Fixup:
  s_lshl_b32 s73, s64, 2
  s_load_dword s75, s[34:35], s73 glc
  s_waitcnt lgkmcnt(0)
  s_cmp_eq_u32 s75, 1
  s_cbranch_scc0 label_SK_Fixup
  s_barrier
  v_readfirstlane_b32 s75, v124
  s_cmp_eq_u32 s75, 0
  s_cbranch_scc0 label_Fixup_E0
  s_store_dword s75, s[34:35], s73 glc
label_SK_SkipFlagReset:
label_Fixup_E0:
  s_mov_b64 s[60:61], s[32:33]
  s_mov_b32 s62, 0x80000000
  s_mov_b32 s63, 0x20000
  s_mul_i32 s74, 0x10000, s64
  s_add_u32 s60, s60, s74
  s_addc_u32 s61, s61, 0
  v_lshlrev_b32_e32 v10, 4, v124
  s_mov_b32 s74, 0
  buffer_load_dwordx4 v[76:79], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[80:83], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[84:87], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[88:91], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[92:95], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[96:99], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[100:103], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[104:107], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[108:111], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[112:115], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[116:119], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[120:123], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[128:131], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[132:135], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[136:139], v10, s[60:63], s74 offen
  s_add_u32 s74, s74, 0x1000
  buffer_load_dwordx4 v[140:143], v10, s[60:63], s74 offen
  v_accvgpr_read_b32 v12, a0
  v_accvgpr_read_b32 v13, a4
  v_accvgpr_read_b32 v14, a8
  v_accvgpr_read_b32 v15, a12
  v_accvgpr_read_b32 v16, a16
  v_accvgpr_read_b32 v17, a20
  v_accvgpr_read_b32 v18, a24
  v_accvgpr_read_b32 v19, a28
  v_accvgpr_read_b32 v20, a32
  v_accvgpr_read_b32 v21, a36
  v_accvgpr_read_b32 v22, a40
  v_accvgpr_read_b32 v23, a44
  v_accvgpr_read_b32 v24, a48
  v_accvgpr_read_b32 v25, a52
  v_accvgpr_read_b32 v26, a56
  v_accvgpr_read_b32 v27, a60
  v_accvgpr_read_b32 v28, a1
  v_accvgpr_read_b32 v29, a5
  v_accvgpr_read_b32 v30, a9
  v_accvgpr_read_b32 v31, a13
  v_accvgpr_read_b32 v32, a17
  v_accvgpr_read_b32 v33, a21
  v_accvgpr_read_b32 v34, a25
  v_accvgpr_read_b32 v35, a29
  v_accvgpr_read_b32 v36, a33
  v_accvgpr_read_b32 v37, a37
  v_accvgpr_read_b32 v38, a41
  v_accvgpr_read_b32 v39, a45
  v_accvgpr_read_b32 v40, a49
  v_accvgpr_read_b32 v41, a53
  v_accvgpr_read_b32 v42, a57
  v_accvgpr_read_b32 v43, a61
  v_accvgpr_read_b32 v44, a2
  v_accvgpr_read_b32 v45, a6
  v_accvgpr_read_b32 v46, a10
  v_accvgpr_read_b32 v47, a14
  v_accvgpr_read_b32 v48, a18
  v_accvgpr_read_b32 v49, a22
  v_accvgpr_read_b32 v50, a26
  v_accvgpr_read_b32 v51, a30
  v_accvgpr_read_b32 v52, a34
  v_accvgpr_read_b32 v53, a38
  v_accvgpr_read_b32 v54, a42
  v_accvgpr_read_b32 v55, a46
  v_accvgpr_read_b32 v56, a50
  v_accvgpr_read_b32 v57, a54
  v_accvgpr_read_b32 v58, a58
  v_accvgpr_read_b32 v59, a62
  v_accvgpr_read_b32 v60, a3
  v_accvgpr_read_b32 v61, a7
  v_accvgpr_read_b32 v62, a11
  v_accvgpr_read_b32 v63, a15
  v_accvgpr_read_b32 v64, a19
  v_accvgpr_read_b32 v65, a23
  v_accvgpr_read_b32 v66, a27
  v_accvgpr_read_b32 v67, a31
  v_accvgpr_read_b32 v68, a35
  v_accvgpr_read_b32 v69, a39
  v_accvgpr_read_b32 v70, a43
  v_accvgpr_read_b32 v71, a47
  v_accvgpr_read_b32 v72, a51
  v_accvgpr_read_b32 v73, a55
  v_accvgpr_read_b32 v74, a59
  v_accvgpr_read_b32 v75, a63
  s_nop 1
  s_waitcnt vmcnt(15)
  v_add_f32_e32 v12, v12, v76
  v_add_f32_e32 v13, v13, v77
  v_add_f32_e32 v14, v14, v78
  v_add_f32_e32 v15, v15, v79
  s_waitcnt vmcnt(14)
  v_add_f32_e32 v16, v16, v80
  v_add_f32_e32 v17, v17, v81
  v_add_f32_e32 v18, v18, v82
  v_add_f32_e32 v19, v19, v83
  s_waitcnt vmcnt(13)
  v_add_f32_e32 v20, v20, v84
  v_add_f32_e32 v21, v21, v85
  v_add_f32_e32 v22, v22, v86
  v_add_f32_e32 v23, v23, v87
  s_waitcnt vmcnt(12)
  v_add_f32_e32 v24, v24, v88
  v_add_f32_e32 v25, v25, v89
  v_add_f32_e32 v26, v26, v90
  v_add_f32_e32 v27, v27, v91
  s_waitcnt vmcnt(11)
  v_add_f32_e32 v28, v28, v92
  v_add_f32_e32 v29, v29, v93
  v_add_f32_e32 v30, v30, v94
  v_add_f32_e32 v31, v31, v95
  s_waitcnt vmcnt(10)
  v_add_f32_e32 v32, v32, v96
  v_add_f32_e32 v33, v33, v97
  v_add_f32_e32 v34, v34, v98
  v_add_f32_e32 v35, v35, v99
  s_waitcnt vmcnt(9)
  v_add_f32_e32 v36, v36, v100
  v_add_f32_e32 v37, v37, v101
  v_add_f32_e32 v38, v38, v102
  v_add_f32_e32 v39, v39, v103
  s_waitcnt vmcnt(8)
  v_add_f32_e32 v40, v40, v104
  v_add_f32_e32 v41, v41, v105
  v_add_f32_e32 v42, v42, v106
  v_add_f32_e32 v43, v43, v107
  s_waitcnt vmcnt(7)
  v_add_f32_e32 v44, v44, v108
  v_add_f32_e32 v45, v45, v109
  v_add_f32_e32 v46, v46, v110
  v_add_f32_e32 v47, v47, v111
  s_waitcnt vmcnt(6)
  v_add_f32_e32 v48, v48, v112
  v_add_f32_e32 v49, v49, v113
  v_add_f32_e32 v50, v50, v114
  v_add_f32_e32 v51, v51, v115
  s_waitcnt vmcnt(5)
  v_add_f32_e32 v52, v52, v116
  v_add_f32_e32 v53, v53, v117
  v_add_f32_e32 v54, v54, v118
  v_add_f32_e32 v55, v55, v119
  s_waitcnt vmcnt(4)
  v_add_f32_e32 v56, v56, v120
  v_add_f32_e32 v57, v57, v121
  v_add_f32_e32 v58, v58, v122
  v_add_f32_e32 v59, v59, v123
  s_waitcnt vmcnt(3)
  v_add_f32_e32 v60, v60, v128
  v_add_f32_e32 v61, v61, v129
  v_add_f32_e32 v62, v62, v130
  v_add_f32_e32 v63, v63, v131
  s_waitcnt vmcnt(2)
  v_add_f32_e32 v64, v64, v132
  v_add_f32_e32 v65, v65, v133
  v_add_f32_e32 v66, v66, v134
  v_add_f32_e32 v67, v67, v135
  s_waitcnt vmcnt(1)
  v_add_f32_e32 v68, v68, v136
  v_add_f32_e32 v69, v69, v137
  v_add_f32_e32 v70, v70, v138
  v_add_f32_e32 v71, v71, v139
  s_waitcnt vmcnt(0)
  v_add_f32_e32 v72, v72, v140
  v_add_f32_e32 v73, v73, v141
  v_add_f32_e32 v74, v74, v142
  v_add_f32_e32 v75, v75, v143
  v_accvgpr_write_b32 a0, v12
  v_accvgpr_write_b32 a4, v13
  v_accvgpr_write_b32 a8, v14
  v_accvgpr_write_b32 a12, v15
  v_accvgpr_write_b32 a16, v16
  v_accvgpr_write_b32 a20, v17
  v_accvgpr_write_b32 a24, v18
  v_accvgpr_write_b32 a28, v19
  v_accvgpr_write_b32 a32, v20
  v_accvgpr_write_b32 a36, v21
  v_accvgpr_write_b32 a40, v22
  v_accvgpr_write_b32 a44, v23
  v_accvgpr_write_b32 a48, v24
  v_accvgpr_write_b32 a52, v25
  v_accvgpr_write_b32 a56, v26
  v_accvgpr_write_b32 a60, v27
  v_accvgpr_write_b32 a1, v28
  v_accvgpr_write_b32 a5, v29
  v_accvgpr_write_b32 a9, v30
  v_accvgpr_write_b32 a13, v31
  v_accvgpr_write_b32 a17, v32
  v_accvgpr_write_b32 a21, v33
  v_accvgpr_write_b32 a25, v34
  v_accvgpr_write_b32 a29, v35
  v_accvgpr_write_b32 a33, v36
  v_accvgpr_write_b32 a37, v37
  v_accvgpr_write_b32 a41, v38
  v_accvgpr_write_b32 a45, v39
  v_accvgpr_write_b32 a49, v40
  v_accvgpr_write_b32 a53, v41
  v_accvgpr_write_b32 a57, v42
  v_accvgpr_write_b32 a61, v43
  v_accvgpr_write_b32 a2, v44
  v_accvgpr_write_b32 a6, v45
  v_accvgpr_write_b32 a10, v46
  v_accvgpr_write_b32 a14, v47
  v_accvgpr_write_b32 a18, v48
  v_accvgpr_write_b32 a22, v49
  v_accvgpr_write_b32 a26, v50
  v_accvgpr_write_b32 a30, v51
  v_accvgpr_write_b32 a34, v52
  v_accvgpr_write_b32 a38, v53
  v_accvgpr_write_b32 a42, v54
  v_accvgpr_write_b32 a46, v55
  v_accvgpr_write_b32 a50, v56
  v_accvgpr_write_b32 a54, v57
  v_accvgpr_write_b32 a58, v58
  v_accvgpr_write_b32 a62, v59
  v_accvgpr_write_b32 a3, v60
  v_accvgpr_write_b32 a7, v61
  v_accvgpr_write_b32 a11, v62
  v_accvgpr_write_b32 a15, v63
  v_accvgpr_write_b32 a19, v64
  v_accvgpr_write_b32 a23, v65
  v_accvgpr_write_b32 a27, v66
  v_accvgpr_write_b32 a31, v67
  v_accvgpr_write_b32 a35, v68
  v_accvgpr_write_b32 a39, v69
  v_accvgpr_write_b32 a43, v70
  v_accvgpr_write_b32 a47, v71
  v_accvgpr_write_b32 a51, v72
  v_accvgpr_write_b32 a55, v73
  v_accvgpr_write_b32 a59, v74
  v_accvgpr_write_b32 a63, v75
  s_nop 1
  s_nop 0
  s_mul_i32 s73, s52, s46
  s_mul_i32 s74, s50, s51
  s_sub_u32 s73, s73, s74
  s_add_u32 s74, s50, 1
  s_cmp_lt_u32 s64, s73
  s_cselect_b32 s74, s74, s50
  s_add_u32 s65, s65, s74
  s_add_u32 s64, s64, 1
  s_cmp_lt_u32 s65, s46
  s_cbranch_scc1 label_SK_Fixup
label_SK_Store:
  s_cmpk_eq_u32 s45, 0x0
  s_cbranch_scc0 label_GW_Beta_1
  s_and_b32 s74, 0x7f, s20
  s_add_u32 s75, -1, s10
  s_cmp_ge_u32 s2, s75
  s_cselect_b32 s74, s74, 0
  s_cmpk_gt_u32 s74, 0x0
  s_cbranch_scc1 label_GW_B0_E1_M_1
  s_and_b32 s74, 0x7f, s21
  s_add_u32 s75, -1, s11
  s_cmp_ge_u32 s3, s75
  s_cselect_b32 s74, s74, 0
  s_cmpk_gt_u32 s74, 0x0
  s_cbranch_scc1 label_GW_B0_E1_N_1
label_GW_B0_E0_1:
  s_cmpk_eq_u32 s72, 0x3
  s_cbranch_scc1 label_To_Activation_Gelu_VW4_beta_0_edge_0
  s_cmpk_eq_u32 s72, 0x5
  s_cbranch_scc1 label_To_Activation_Relu_VW4_beta_0_edge_0
  s_cmpk_eq_u32 s72, 0xa
  s_cbranch_scc1 label_To_Activation_Silu_VW4_beta_0_edge_0
  s_cmpk_eq_u32 s72, 0xc
  s_cbranch_scc1 label_To_Activation_Clamp_VW4_beta_0_edge_0
label_To_Activation_None_VW4_beta_0_edge_0:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x778c, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_5
label_To_Activation_Gelu_VW4_beta_0_edge_0:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x7778, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_5
label_To_Activation_Relu_VW4_beta_0_edge_0:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x7864, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_5
label_To_Activation_Silu_VW4_beta_0_edge_0:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x7870, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_5
label_To_Activation_Clamp_VW4_beta_0_edge_0:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x78dc, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_5
label_ActivationSetPCAddrEnd_5:
  s_mul_i32 s64, 0x80, s2
  v_sub_u32_e64 v11, v0, s64
  v_lshlrev_b32_e32 v11, 2, v11
  s_waitcnt lgkmcnt(0)
  s_barrier
  ds_read_b128 v[68:71], v11
  ds_read_b128 v[72:75], v11 offset:1024
  v_add_lshl_u32 v9, v3, v0, 1
  v_accvgpr_read_b32 v12, a0
  v_accvgpr_read_b32 v13, a4
  v_accvgpr_read_b32 v14, a8
  v_accvgpr_read_b32 v15, a12
  v_accvgpr_read_b32 v16, a16
  v_accvgpr_read_b32 v17, a20
  v_accvgpr_read_b32 v18, a24
  v_accvgpr_read_b32 v19, a28
  v_accvgpr_read_b32 v20, a32
  v_accvgpr_read_b32 v21, a36
  v_accvgpr_read_b32 v22, a40
  v_accvgpr_read_b32 v23, a44
  v_accvgpr_read_b32 v24, a48
  v_accvgpr_read_b32 v25, a52
  v_accvgpr_read_b32 v26, a56
  v_accvgpr_read_b32 v27, a60
  v_accvgpr_read_b32 v28, a1
  v_accvgpr_read_b32 v29, a5
  v_accvgpr_read_b32 v30, a9
  v_accvgpr_read_b32 v31, a13
  v_accvgpr_read_b32 v32, a17
  v_accvgpr_read_b32 v33, a21
  v_accvgpr_read_b32 v34, a25
  v_accvgpr_read_b32 v35, a29
  v_accvgpr_read_b32 v36, a33
  v_accvgpr_read_b32 v37, a37
  v_accvgpr_read_b32 v38, a41
  v_accvgpr_read_b32 v39, a45
  v_accvgpr_read_b32 v40, a49
  v_accvgpr_read_b32 v41, a53
  v_accvgpr_read_b32 v42, a57
  v_accvgpr_read_b32 v43, a61
  v_accvgpr_read_b32 v44, a2
  v_accvgpr_read_b32 v45, a6
  v_accvgpr_read_b32 v46, a10
  v_accvgpr_read_b32 v47, a14
  v_accvgpr_read_b32 v48, a18
  v_accvgpr_read_b32 v49, a22
  v_accvgpr_read_b32 v50, a26
  v_accvgpr_read_b32 v51, a30
  v_accvgpr_read_b32 v52, a34
  v_accvgpr_read_b32 v53, a38
  v_accvgpr_read_b32 v54, a42
  v_accvgpr_read_b32 v55, a46
  v_accvgpr_read_b32 v56, a50
  v_accvgpr_read_b32 v57, a54
  v_accvgpr_read_b32 v58, a58
  v_accvgpr_read_b32 v59, a62
  v_accvgpr_read_b32 v60, a3
  v_accvgpr_read_b32 v61, a7
  v_accvgpr_read_b32 v62, a11
  v_accvgpr_read_b32 v63, a15
  v_accvgpr_read_b32 v64, a19
  v_accvgpr_read_b32 v65, a23
  v_accvgpr_read_b32 v66, a27
  v_accvgpr_read_b32 v67, a31
  v_pk_mul_f32 v[12:13], s[44:45], v[12:13] op_sel_hi:[0,1]
  v_pk_mul_f32 v[14:15], s[44:45], v[14:15] op_sel_hi:[0,1]
  v_pk_mul_f32 v[16:17], s[44:45], v[16:17] op_sel_hi:[0,1]
  v_pk_mul_f32 v[18:19], s[44:45], v[18:19] op_sel_hi:[0,1]
  v_pk_mul_f32 v[20:21], s[44:45], v[20:21] op_sel_hi:[0,1]
  v_pk_mul_f32 v[22:23], s[44:45], v[22:23] op_sel_hi:[0,1]
  v_pk_mul_f32 v[24:25], s[44:45], v[24:25] op_sel_hi:[0,1]
  v_pk_mul_f32 v[26:27], s[44:45], v[26:27] op_sel_hi:[0,1]
  v_pk_mul_f32 v[28:29], s[44:45], v[28:29] op_sel_hi:[0,1]
  v_pk_mul_f32 v[30:31], s[44:45], v[30:31] op_sel_hi:[0,1]
  v_pk_mul_f32 v[32:33], s[44:45], v[32:33] op_sel_hi:[0,1]
  v_pk_mul_f32 v[34:35], s[44:45], v[34:35] op_sel_hi:[0,1]
  v_pk_mul_f32 v[36:37], s[44:45], v[36:37] op_sel_hi:[0,1]
  v_pk_mul_f32 v[38:39], s[44:45], v[38:39] op_sel_hi:[0,1]
  v_pk_mul_f32 v[40:41], s[44:45], v[40:41] op_sel_hi:[0,1]
  v_pk_mul_f32 v[42:43], s[44:45], v[42:43] op_sel_hi:[0,1]
  v_pk_mul_f32 v[44:45], s[44:45], v[44:45] op_sel_hi:[0,1]
  v_pk_mul_f32 v[46:47], s[44:45], v[46:47] op_sel_hi:[0,1]
  v_pk_mul_f32 v[48:49], s[44:45], v[48:49] op_sel_hi:[0,1]
  v_pk_mul_f32 v[50:51], s[44:45], v[50:51] op_sel_hi:[0,1]
  v_pk_mul_f32 v[52:53], s[44:45], v[52:53] op_sel_hi:[0,1]
  v_pk_mul_f32 v[54:55], s[44:45], v[54:55] op_sel_hi:[0,1]
  v_pk_mul_f32 v[56:57], s[44:45], v[56:57] op_sel_hi:[0,1]
  v_pk_mul_f32 v[58:59], s[44:45], v[58:59] op_sel_hi:[0,1]
  v_pk_mul_f32 v[60:61], s[44:45], v[60:61] op_sel_hi:[0,1]
  v_pk_mul_f32 v[62:63], s[44:45], v[62:63] op_sel_hi:[0,1]
  v_pk_mul_f32 v[64:65], s[44:45], v[64:65] op_sel_hi:[0,1]
  v_pk_mul_f32 v[66:67], s[44:45], v[66:67] op_sel_hi:[0,1]
  s_waitcnt lgkmcnt(0)
  v_pk_mul_f32 v[12:13], v[72:73], v[12:13]
  v_pk_mul_f32 v[14:15], v[74:75], v[14:15]
  v_pk_add_f32 v[4:5], v[68:69], v[12:13]
  v_pk_add_f32 v[6:7], v[70:71], v[14:15]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[12:13], v[4:5]
  v_mov_b64_e32 v[14:15], v[6:7]
  v_cvt_f16_f32_e32 v12, v12
  v_cvt_f16_f32_e32 v13, v13
  v_pack_b32_f16 v12, v12, v13
  v_cvt_f16_f32_e32 v14, v14
  v_cvt_f16_f32_e32 v15, v15
  v_pack_b32_f16 v13, v14, v15
  buffer_store_dwordx2 v[12:13], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[16:17], v[72:73], v[16:17]
  v_pk_mul_f32 v[18:19], v[74:75], v[18:19]
  v_pk_add_f32 v[4:5], v[68:69], v[16:17]
  v_pk_add_f32 v[6:7], v[70:71], v[18:19]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[16:17], v[4:5]
  v_mov_b64_e32 v[18:19], v[6:7]
  v_cvt_f16_f32_e32 v16, v16
  v_cvt_f16_f32_e32 v17, v17
  v_pack_b32_f16 v16, v16, v17
  v_cvt_f16_f32_e32 v18, v18
  v_cvt_f16_f32_e32 v19, v19
  v_pack_b32_f16 v17, v18, v19
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[16:17], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[20:21], v[72:73], v[20:21]
  v_pk_mul_f32 v[22:23], v[74:75], v[22:23]
  v_pk_add_f32 v[4:5], v[68:69], v[20:21]
  v_pk_add_f32 v[6:7], v[70:71], v[22:23]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[20:21], v[4:5]
  v_mov_b64_e32 v[22:23], v[6:7]
  v_cvt_f16_f32_e32 v20, v20
  v_cvt_f16_f32_e32 v21, v21
  v_pack_b32_f16 v20, v20, v21
  v_cvt_f16_f32_e32 v22, v22
  v_cvt_f16_f32_e32 v23, v23
  v_pack_b32_f16 v21, v22, v23
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[20:21], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[24:25], v[72:73], v[24:25]
  v_pk_mul_f32 v[26:27], v[74:75], v[26:27]
  v_pk_add_f32 v[4:5], v[68:69], v[24:25]
  v_pk_add_f32 v[6:7], v[70:71], v[26:27]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[24:25], v[4:5]
  v_mov_b64_e32 v[26:27], v[6:7]
  v_cvt_f16_f32_e32 v24, v24
  v_cvt_f16_f32_e32 v25, v25
  v_pack_b32_f16 v24, v24, v25
  v_cvt_f16_f32_e32 v26, v26
  v_cvt_f16_f32_e32 v27, v27
  v_pack_b32_f16 v25, v26, v27
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[24:25], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[28:29], v[72:73], v[28:29]
  v_pk_mul_f32 v[30:31], v[74:75], v[30:31]
  v_pk_add_f32 v[4:5], v[68:69], v[28:29]
  v_pk_add_f32 v[6:7], v[70:71], v[30:31]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[28:29], v[4:5]
  v_mov_b64_e32 v[30:31], v[6:7]
  v_cvt_f16_f32_e32 v28, v28
  v_cvt_f16_f32_e32 v29, v29
  v_pack_b32_f16 v28, v28, v29
  v_cvt_f16_f32_e32 v30, v30
  v_cvt_f16_f32_e32 v31, v31
  v_pack_b32_f16 v29, v30, v31
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[28:29], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[32:33], v[72:73], v[32:33]
  v_pk_mul_f32 v[34:35], v[74:75], v[34:35]
  v_pk_add_f32 v[4:5], v[68:69], v[32:33]
  v_pk_add_f32 v[6:7], v[70:71], v[34:35]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[32:33], v[4:5]
  v_mov_b64_e32 v[34:35], v[6:7]
  v_cvt_f16_f32_e32 v32, v32
  v_cvt_f16_f32_e32 v33, v33
  v_pack_b32_f16 v32, v32, v33
  v_cvt_f16_f32_e32 v34, v34
  v_cvt_f16_f32_e32 v35, v35
  v_pack_b32_f16 v33, v34, v35
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[32:33], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[36:37], v[72:73], v[36:37]
  v_pk_mul_f32 v[38:39], v[74:75], v[38:39]
  v_pk_add_f32 v[4:5], v[68:69], v[36:37]
  v_pk_add_f32 v[6:7], v[70:71], v[38:39]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[36:37], v[4:5]
  v_mov_b64_e32 v[38:39], v[6:7]
  v_cvt_f16_f32_e32 v36, v36
  v_cvt_f16_f32_e32 v37, v37
  v_pack_b32_f16 v36, v36, v37
  v_cvt_f16_f32_e32 v38, v38
  v_cvt_f16_f32_e32 v39, v39
  v_pack_b32_f16 v37, v38, v39
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[36:37], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[40:41], v[72:73], v[40:41]
  v_pk_mul_f32 v[42:43], v[74:75], v[42:43]
  v_pk_add_f32 v[4:5], v[68:69], v[40:41]
  v_pk_add_f32 v[6:7], v[70:71], v[42:43]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[40:41], v[4:5]
  v_mov_b64_e32 v[42:43], v[6:7]
  v_cvt_f16_f32_e32 v40, v40
  v_cvt_f16_f32_e32 v41, v41
  v_pack_b32_f16 v40, v40, v41
  v_cvt_f16_f32_e32 v42, v42
  v_cvt_f16_f32_e32 v43, v43
  v_pack_b32_f16 v41, v42, v43
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[40:41], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[44:45], v[72:73], v[44:45]
  v_pk_mul_f32 v[46:47], v[74:75], v[46:47]
  v_pk_add_f32 v[4:5], v[68:69], v[44:45]
  v_pk_add_f32 v[6:7], v[70:71], v[46:47]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[44:45], v[4:5]
  v_mov_b64_e32 v[46:47], v[6:7]
  v_cvt_f16_f32_e32 v44, v44
  v_cvt_f16_f32_e32 v45, v45
  v_pack_b32_f16 v44, v44, v45
  v_cvt_f16_f32_e32 v46, v46
  v_cvt_f16_f32_e32 v47, v47
  v_pack_b32_f16 v45, v46, v47
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[44:45], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[48:49], v[72:73], v[48:49]
  v_pk_mul_f32 v[50:51], v[74:75], v[50:51]
  v_pk_add_f32 v[4:5], v[68:69], v[48:49]
  v_pk_add_f32 v[6:7], v[70:71], v[50:51]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[48:49], v[4:5]
  v_mov_b64_e32 v[50:51], v[6:7]
  v_cvt_f16_f32_e32 v48, v48
  v_cvt_f16_f32_e32 v49, v49
  v_pack_b32_f16 v48, v48, v49
  v_cvt_f16_f32_e32 v50, v50
  v_cvt_f16_f32_e32 v51, v51
  v_pack_b32_f16 v49, v50, v51
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[48:49], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[52:53], v[72:73], v[52:53]
  v_pk_mul_f32 v[54:55], v[74:75], v[54:55]
  v_pk_add_f32 v[4:5], v[68:69], v[52:53]
  v_pk_add_f32 v[6:7], v[70:71], v[54:55]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[52:53], v[4:5]
  v_mov_b64_e32 v[54:55], v[6:7]
  v_cvt_f16_f32_e32 v52, v52
  v_cvt_f16_f32_e32 v53, v53
  v_pack_b32_f16 v52, v52, v53
  v_cvt_f16_f32_e32 v54, v54
  v_cvt_f16_f32_e32 v55, v55
  v_pack_b32_f16 v53, v54, v55
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[52:53], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[56:57], v[72:73], v[56:57]
  v_pk_mul_f32 v[58:59], v[74:75], v[58:59]
  v_pk_add_f32 v[4:5], v[68:69], v[56:57]
  v_pk_add_f32 v[6:7], v[70:71], v[58:59]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[56:57], v[4:5]
  v_mov_b64_e32 v[58:59], v[6:7]
  v_cvt_f16_f32_e32 v56, v56
  v_cvt_f16_f32_e32 v57, v57
  v_pack_b32_f16 v56, v56, v57
  v_cvt_f16_f32_e32 v58, v58
  v_cvt_f16_f32_e32 v59, v59
  v_pack_b32_f16 v57, v58, v59
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[56:57], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[60:61], v[72:73], v[60:61]
  v_pk_mul_f32 v[62:63], v[74:75], v[62:63]
  v_pk_add_f32 v[4:5], v[68:69], v[60:61]
  v_pk_add_f32 v[6:7], v[70:71], v[62:63]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[60:61], v[4:5]
  v_mov_b64_e32 v[62:63], v[6:7]
  v_cvt_f16_f32_e32 v60, v60
  v_cvt_f16_f32_e32 v61, v61
  v_pack_b32_f16 v60, v60, v61
  v_cvt_f16_f32_e32 v62, v62
  v_cvt_f16_f32_e32 v63, v63
  v_pack_b32_f16 v61, v62, v63
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[60:61], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[64:65], v[72:73], v[64:65]
  v_pk_mul_f32 v[66:67], v[74:75], v[66:67]
  v_pk_add_f32 v[4:5], v[68:69], v[64:65]
  v_pk_add_f32 v[6:7], v[70:71], v[66:67]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[64:65], v[4:5]
  v_mov_b64_e32 v[66:67], v[6:7]
  v_cvt_f16_f32_e32 v64, v64
  v_cvt_f16_f32_e32 v65, v65
  v_pack_b32_f16 v64, v64, v65
  v_cvt_f16_f32_e32 v66, v66
  v_cvt_f16_f32_e32 v67, v67
  v_pack_b32_f16 v65, v66, v67
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[64:65], v9, s[12:15], 0 offen
  s_nop 0
  ds_read_b128 v[20:23], v11
  ds_read_b128 v[24:27], v11 offset:1024
  v_accvgpr_read_b32 v12, a35
  v_accvgpr_read_b32 v13, a39
  v_accvgpr_read_b32 v14, a43
  v_accvgpr_read_b32 v15, a47
  v_accvgpr_read_b32 v16, a51
  v_accvgpr_read_b32 v17, a55
  v_accvgpr_read_b32 v18, a59
  v_accvgpr_read_b32 v19, a63
  v_pk_mul_f32 v[12:13], s[44:45], v[12:13] op_sel_hi:[0,1]
  v_pk_mul_f32 v[14:15], s[44:45], v[14:15] op_sel_hi:[0,1]
  v_pk_mul_f32 v[16:17], s[44:45], v[16:17] op_sel_hi:[0,1]
  v_pk_mul_f32 v[18:19], s[44:45], v[18:19] op_sel_hi:[0,1]
  s_waitcnt lgkmcnt(0)
  v_pk_mul_f32 v[12:13], v[24:25], v[12:13]
  v_pk_mul_f32 v[14:15], v[26:27], v[14:15]
  v_pk_add_f32 v[4:5], v[20:21], v[12:13]
  v_pk_add_f32 v[6:7], v[22:23], v[14:15]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[12:13], v[4:5]
  v_mov_b64_e32 v[14:15], v[6:7]
  v_cvt_f16_f32_e32 v12, v12
  v_cvt_f16_f32_e32 v13, v13
  v_pack_b32_f16 v12, v12, v13
  v_cvt_f16_f32_e32 v14, v14
  v_cvt_f16_f32_e32 v15, v15
  v_pack_b32_f16 v13, v14, v15
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[12:13], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[16:17], v[24:25], v[16:17]
  v_pk_mul_f32 v[18:19], v[26:27], v[18:19]
  v_pk_add_f32 v[4:5], v[20:21], v[16:17]
  v_pk_add_f32 v[6:7], v[22:23], v[18:19]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[16:17], v[4:5]
  v_mov_b64_e32 v[18:19], v[6:7]
  v_cvt_f16_f32_e32 v16, v16
  v_cvt_f16_f32_e32 v17, v17
  v_pack_b32_f16 v16, v16, v17
  v_cvt_f16_f32_e32 v18, v18
  v_cvt_f16_f32_e32 v19, v19
  v_pack_b32_f16 v17, v18, v19
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[16:17], v9, s[12:15], 0 offen
  s_nop 0
  s_branch label_GW_End_1
label_GW_B0_E1_N_1:
  s_cmpk_eq_u32 s72, 0x3
  s_cbranch_scc1 label_To_Activation_Gelu_VW4_beta_0_edge_1
  s_cmpk_eq_u32 s72, 0x5
  s_cbranch_scc1 label_To_Activation_Relu_VW4_beta_0_edge_1
  s_cmpk_eq_u32 s72, 0xa
  s_cbranch_scc1 label_To_Activation_Silu_VW4_beta_0_edge_1
  s_cmpk_eq_u32 s72, 0xc
  s_cbranch_scc1 label_To_Activation_Clamp_VW4_beta_0_edge_1
label_To_Activation_None_VW4_beta_0_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x6da8, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_4
label_To_Activation_Gelu_VW4_beta_0_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x6d94, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_4
label_To_Activation_Relu_VW4_beta_0_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x6e80, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_4
label_To_Activation_Silu_VW4_beta_0_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x6e8c, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_4
label_To_Activation_Clamp_VW4_beta_0_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x6ef8, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_4
label_ActivationSetPCAddrEnd_4:
  v_mov_b32_e32 v8, 0x80000000
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v10, v0, s74
  v_lshlrev_b32_e32 v10, 2, v10
  s_waitcnt lgkmcnt(0)
  s_barrier
  ds_read_b128 v[60:63], v10
  ds_read_b128 v[64:67], v10 offset:1024
  v_add_lshl_u32 v9, v3, v0, 1
  v_cndmask_b32_e64 v9, v8, v9, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v68, v0, s74
  v_lshlrev_b32_e32 v68, 2, v68
  v_add_lshl_u32 v11, v3, v0, 1
  v_cndmask_b32_e64 v11, v8, v11, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v70, v0, s74
  v_lshlrev_b32_e32 v70, 2, v70
  v_add_lshl_u32 v69, v3, v0, 1
  v_cndmask_b32_e64 v69, v8, v69, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v72, v0, s74
  v_lshlrev_b32_e32 v72, 2, v72
  v_add_lshl_u32 v71, v3, v0, 1
  v_cndmask_b32_e64 v71, v8, v71, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v74, v0, s74
  v_lshlrev_b32_e32 v74, 2, v74
  v_add_lshl_u32 v73, v3, v0, 1
  v_cndmask_b32_e64 v73, v8, v73, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v76, v0, s74
  v_lshlrev_b32_e32 v76, 2, v76
  v_add_lshl_u32 v75, v3, v0, 1
  v_cndmask_b32_e64 v75, v8, v75, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v78, v0, s74
  v_lshlrev_b32_e32 v78, 2, v78
  v_add_lshl_u32 v77, v3, v0, 1
  v_cndmask_b32_e64 v77, v8, v77, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v80, v0, s74
  v_lshlrev_b32_e32 v80, 2, v80
  v_add_lshl_u32 v79, v3, v0, 1
  v_cndmask_b32_e64 v79, v8, v79, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v82, v0, s74
  v_lshlrev_b32_e32 v82, 2, v82
  v_add_lshl_u32 v81, v3, v0, 1
  v_cndmask_b32_e64 v81, v8, v81, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v84, v0, s74
  v_lshlrev_b32_e32 v84, 2, v84
  v_add_lshl_u32 v83, v3, v0, 1
  v_cndmask_b32_e64 v83, v8, v83, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v86, v0, s74
  v_lshlrev_b32_e32 v86, 2, v86
  v_add_lshl_u32 v85, v3, v0, 1
  v_cndmask_b32_e64 v85, v8, v85, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v88, v0, s74
  v_lshlrev_b32_e32 v88, 2, v88
  v_add_lshl_u32 v87, v3, v0, 1
  v_cndmask_b32_e64 v87, v8, v87, s[78:79]
  v_accvgpr_read_b32 v12, a0
  v_accvgpr_read_b32 v13, a4
  v_accvgpr_read_b32 v14, a8
  v_accvgpr_read_b32 v15, a12
  v_accvgpr_read_b32 v16, a16
  v_accvgpr_read_b32 v17, a20
  v_accvgpr_read_b32 v18, a24
  v_accvgpr_read_b32 v19, a28
  v_accvgpr_read_b32 v20, a32
  v_accvgpr_read_b32 v21, a36
  v_accvgpr_read_b32 v22, a40
  v_accvgpr_read_b32 v23, a44
  v_accvgpr_read_b32 v24, a48
  v_accvgpr_read_b32 v25, a52
  v_accvgpr_read_b32 v26, a56
  v_accvgpr_read_b32 v27, a60
  v_accvgpr_read_b32 v28, a1
  v_accvgpr_read_b32 v29, a5
  v_accvgpr_read_b32 v30, a9
  v_accvgpr_read_b32 v31, a13
  v_accvgpr_read_b32 v32, a17
  v_accvgpr_read_b32 v33, a21
  v_accvgpr_read_b32 v34, a25
  v_accvgpr_read_b32 v35, a29
  v_accvgpr_read_b32 v36, a33
  v_accvgpr_read_b32 v37, a37
  v_accvgpr_read_b32 v38, a41
  v_accvgpr_read_b32 v39, a45
  v_accvgpr_read_b32 v40, a49
  v_accvgpr_read_b32 v41, a53
  v_accvgpr_read_b32 v42, a57
  v_accvgpr_read_b32 v43, a61
  v_accvgpr_read_b32 v44, a2
  v_accvgpr_read_b32 v45, a6
  v_accvgpr_read_b32 v46, a10
  v_accvgpr_read_b32 v47, a14
  v_accvgpr_read_b32 v48, a18
  v_accvgpr_read_b32 v49, a22
  v_accvgpr_read_b32 v50, a26
  v_accvgpr_read_b32 v51, a30
  v_accvgpr_read_b32 v52, a34
  v_accvgpr_read_b32 v53, a38
  v_accvgpr_read_b32 v54, a42
  v_accvgpr_read_b32 v55, a46
  v_accvgpr_read_b32 v56, a50
  v_accvgpr_read_b32 v57, a54
  v_accvgpr_read_b32 v58, a58
  v_accvgpr_read_b32 v59, a62
  v_pk_mul_f32 v[12:13], s[44:45], v[12:13] op_sel_hi:[0,1]
  v_pk_mul_f32 v[14:15], s[44:45], v[14:15] op_sel_hi:[0,1]
  v_pk_mul_f32 v[16:17], s[44:45], v[16:17] op_sel_hi:[0,1]
  v_pk_mul_f32 v[18:19], s[44:45], v[18:19] op_sel_hi:[0,1]
  v_pk_mul_f32 v[20:21], s[44:45], v[20:21] op_sel_hi:[0,1]
  v_pk_mul_f32 v[22:23], s[44:45], v[22:23] op_sel_hi:[0,1]
  v_pk_mul_f32 v[24:25], s[44:45], v[24:25] op_sel_hi:[0,1]
  v_pk_mul_f32 v[26:27], s[44:45], v[26:27] op_sel_hi:[0,1]
  v_pk_mul_f32 v[28:29], s[44:45], v[28:29] op_sel_hi:[0,1]
  v_pk_mul_f32 v[30:31], s[44:45], v[30:31] op_sel_hi:[0,1]
  v_pk_mul_f32 v[32:33], s[44:45], v[32:33] op_sel_hi:[0,1]
  v_pk_mul_f32 v[34:35], s[44:45], v[34:35] op_sel_hi:[0,1]
  v_pk_mul_f32 v[36:37], s[44:45], v[36:37] op_sel_hi:[0,1]
  v_pk_mul_f32 v[38:39], s[44:45], v[38:39] op_sel_hi:[0,1]
  v_pk_mul_f32 v[40:41], s[44:45], v[40:41] op_sel_hi:[0,1]
  v_pk_mul_f32 v[42:43], s[44:45], v[42:43] op_sel_hi:[0,1]
  v_pk_mul_f32 v[44:45], s[44:45], v[44:45] op_sel_hi:[0,1]
  v_pk_mul_f32 v[46:47], s[44:45], v[46:47] op_sel_hi:[0,1]
  v_pk_mul_f32 v[48:49], s[44:45], v[48:49] op_sel_hi:[0,1]
  v_pk_mul_f32 v[50:51], s[44:45], v[50:51] op_sel_hi:[0,1]
  v_pk_mul_f32 v[52:53], s[44:45], v[52:53] op_sel_hi:[0,1]
  v_pk_mul_f32 v[54:55], s[44:45], v[54:55] op_sel_hi:[0,1]
  v_pk_mul_f32 v[56:57], s[44:45], v[56:57] op_sel_hi:[0,1]
  v_pk_mul_f32 v[58:59], s[44:45], v[58:59] op_sel_hi:[0,1]
  s_waitcnt lgkmcnt(0)
  v_pk_mul_f32 v[12:13], v[64:65], v[12:13]
  v_pk_mul_f32 v[14:15], v[66:67], v[14:15]
  v_pk_add_f32 v[4:5], v[60:61], v[12:13]
  v_pk_add_f32 v[6:7], v[62:63], v[14:15]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[12:13], v[4:5]
  v_mov_b64_e32 v[14:15], v[6:7]
  v_cvt_f16_f32_e32 v12, v12
  v_cvt_f16_f32_e32 v13, v13
  v_pack_b32_f16 v12, v12, v13
  v_cvt_f16_f32_e32 v14, v14
  v_cvt_f16_f32_e32 v15, v15
  v_pack_b32_f16 v13, v14, v15
  buffer_store_dwordx2 v[12:13], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[16:17], v[64:65], v[16:17]
  v_pk_mul_f32 v[18:19], v[66:67], v[18:19]
  v_pk_add_f32 v[4:5], v[60:61], v[16:17]
  v_pk_add_f32 v[6:7], v[62:63], v[18:19]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[16:17], v[4:5]
  v_mov_b64_e32 v[18:19], v[6:7]
  v_cvt_f16_f32_e32 v16, v16
  v_cvt_f16_f32_e32 v17, v17
  v_pack_b32_f16 v16, v16, v17
  v_cvt_f16_f32_e32 v18, v18
  v_cvt_f16_f32_e32 v19, v19
  v_pack_b32_f16 v17, v18, v19
  buffer_store_dwordx2 v[16:17], v11, s[12:15], 0 offen
  v_pk_mul_f32 v[20:21], v[64:65], v[20:21]
  v_pk_mul_f32 v[22:23], v[66:67], v[22:23]
  v_pk_add_f32 v[4:5], v[60:61], v[20:21]
  v_pk_add_f32 v[6:7], v[62:63], v[22:23]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[20:21], v[4:5]
  v_mov_b64_e32 v[22:23], v[6:7]
  v_cvt_f16_f32_e32 v20, v20
  v_cvt_f16_f32_e32 v21, v21
  v_pack_b32_f16 v20, v20, v21
  v_cvt_f16_f32_e32 v22, v22
  v_cvt_f16_f32_e32 v23, v23
  v_pack_b32_f16 v21, v22, v23
  buffer_store_dwordx2 v[20:21], v69, s[12:15], 0 offen
  v_pk_mul_f32 v[24:25], v[64:65], v[24:25]
  v_pk_mul_f32 v[26:27], v[66:67], v[26:27]
  v_pk_add_f32 v[4:5], v[60:61], v[24:25]
  v_pk_add_f32 v[6:7], v[62:63], v[26:27]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[24:25], v[4:5]
  v_mov_b64_e32 v[26:27], v[6:7]
  v_cvt_f16_f32_e32 v24, v24
  v_cvt_f16_f32_e32 v25, v25
  v_pack_b32_f16 v24, v24, v25
  v_cvt_f16_f32_e32 v26, v26
  v_cvt_f16_f32_e32 v27, v27
  v_pack_b32_f16 v25, v26, v27
  buffer_store_dwordx2 v[24:25], v71, s[12:15], 0 offen
  v_pk_mul_f32 v[28:29], v[64:65], v[28:29]
  v_pk_mul_f32 v[30:31], v[66:67], v[30:31]
  v_pk_add_f32 v[4:5], v[60:61], v[28:29]
  v_pk_add_f32 v[6:7], v[62:63], v[30:31]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[28:29], v[4:5]
  v_mov_b64_e32 v[30:31], v[6:7]
  v_cvt_f16_f32_e32 v28, v28
  v_cvt_f16_f32_e32 v29, v29
  v_pack_b32_f16 v28, v28, v29
  v_cvt_f16_f32_e32 v30, v30
  v_cvt_f16_f32_e32 v31, v31
  v_pack_b32_f16 v29, v30, v31
  buffer_store_dwordx2 v[28:29], v73, s[12:15], 0 offen
  v_pk_mul_f32 v[32:33], v[64:65], v[32:33]
  v_pk_mul_f32 v[34:35], v[66:67], v[34:35]
  v_pk_add_f32 v[4:5], v[60:61], v[32:33]
  v_pk_add_f32 v[6:7], v[62:63], v[34:35]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[32:33], v[4:5]
  v_mov_b64_e32 v[34:35], v[6:7]
  v_cvt_f16_f32_e32 v32, v32
  v_cvt_f16_f32_e32 v33, v33
  v_pack_b32_f16 v32, v32, v33
  v_cvt_f16_f32_e32 v34, v34
  v_cvt_f16_f32_e32 v35, v35
  v_pack_b32_f16 v33, v34, v35
  buffer_store_dwordx2 v[32:33], v75, s[12:15], 0 offen
  v_pk_mul_f32 v[36:37], v[64:65], v[36:37]
  v_pk_mul_f32 v[38:39], v[66:67], v[38:39]
  v_pk_add_f32 v[4:5], v[60:61], v[36:37]
  v_pk_add_f32 v[6:7], v[62:63], v[38:39]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[36:37], v[4:5]
  v_mov_b64_e32 v[38:39], v[6:7]
  v_cvt_f16_f32_e32 v36, v36
  v_cvt_f16_f32_e32 v37, v37
  v_pack_b32_f16 v36, v36, v37
  v_cvt_f16_f32_e32 v38, v38
  v_cvt_f16_f32_e32 v39, v39
  v_pack_b32_f16 v37, v38, v39
  buffer_store_dwordx2 v[36:37], v77, s[12:15], 0 offen
  v_pk_mul_f32 v[40:41], v[64:65], v[40:41]
  v_pk_mul_f32 v[42:43], v[66:67], v[42:43]
  v_pk_add_f32 v[4:5], v[60:61], v[40:41]
  v_pk_add_f32 v[6:7], v[62:63], v[42:43]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[40:41], v[4:5]
  v_mov_b64_e32 v[42:43], v[6:7]
  v_cvt_f16_f32_e32 v40, v40
  v_cvt_f16_f32_e32 v41, v41
  v_pack_b32_f16 v40, v40, v41
  v_cvt_f16_f32_e32 v42, v42
  v_cvt_f16_f32_e32 v43, v43
  v_pack_b32_f16 v41, v42, v43
  buffer_store_dwordx2 v[40:41], v79, s[12:15], 0 offen
  v_pk_mul_f32 v[44:45], v[64:65], v[44:45]
  v_pk_mul_f32 v[46:47], v[66:67], v[46:47]
  v_pk_add_f32 v[4:5], v[60:61], v[44:45]
  v_pk_add_f32 v[6:7], v[62:63], v[46:47]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[44:45], v[4:5]
  v_mov_b64_e32 v[46:47], v[6:7]
  v_cvt_f16_f32_e32 v44, v44
  v_cvt_f16_f32_e32 v45, v45
  v_pack_b32_f16 v44, v44, v45
  v_cvt_f16_f32_e32 v46, v46
  v_cvt_f16_f32_e32 v47, v47
  v_pack_b32_f16 v45, v46, v47
  buffer_store_dwordx2 v[44:45], v81, s[12:15], 0 offen
  v_pk_mul_f32 v[48:49], v[64:65], v[48:49]
  v_pk_mul_f32 v[50:51], v[66:67], v[50:51]
  v_pk_add_f32 v[4:5], v[60:61], v[48:49]
  v_pk_add_f32 v[6:7], v[62:63], v[50:51]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[48:49], v[4:5]
  v_mov_b64_e32 v[50:51], v[6:7]
  v_cvt_f16_f32_e32 v48, v48
  v_cvt_f16_f32_e32 v49, v49
  v_pack_b32_f16 v48, v48, v49
  v_cvt_f16_f32_e32 v50, v50
  v_cvt_f16_f32_e32 v51, v51
  v_pack_b32_f16 v49, v50, v51
  buffer_store_dwordx2 v[48:49], v83, s[12:15], 0 offen
  v_pk_mul_f32 v[52:53], v[64:65], v[52:53]
  v_pk_mul_f32 v[54:55], v[66:67], v[54:55]
  v_pk_add_f32 v[4:5], v[60:61], v[52:53]
  v_pk_add_f32 v[6:7], v[62:63], v[54:55]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[52:53], v[4:5]
  v_mov_b64_e32 v[54:55], v[6:7]
  v_cvt_f16_f32_e32 v52, v52
  v_cvt_f16_f32_e32 v53, v53
  v_pack_b32_f16 v52, v52, v53
  v_cvt_f16_f32_e32 v54, v54
  v_cvt_f16_f32_e32 v55, v55
  v_pack_b32_f16 v53, v54, v55
  buffer_store_dwordx2 v[52:53], v85, s[12:15], 0 offen
  v_pk_mul_f32 v[56:57], v[64:65], v[56:57]
  v_pk_mul_f32 v[58:59], v[66:67], v[58:59]
  v_pk_add_f32 v[4:5], v[60:61], v[56:57]
  v_pk_add_f32 v[6:7], v[62:63], v[58:59]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[56:57], v[4:5]
  v_mov_b64_e32 v[58:59], v[6:7]
  v_cvt_f16_f32_e32 v56, v56
  v_cvt_f16_f32_e32 v57, v57
  v_pack_b32_f16 v56, v56, v57
  v_cvt_f16_f32_e32 v58, v58
  v_cvt_f16_f32_e32 v59, v59
  v_pack_b32_f16 v57, v58, v59
  buffer_store_dwordx2 v[56:57], v87, s[12:15], 0 offen
  s_nop 0
  v_mov_b32_e32 v8, 0x80000000
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v10, v0, s74
  v_lshlrev_b32_e32 v10, 2, v10
  ds_read_b128 v[28:31], v10
  ds_read_b128 v[32:35], v10 offset:1024
  v_add_lshl_u32 v9, v3, v0, 1
  v_cndmask_b32_e64 v9, v8, v9, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v36, v0, s74
  v_lshlrev_b32_e32 v36, 2, v36
  v_add_lshl_u32 v11, v3, v0, 1
  v_cndmask_b32_e64 v11, v8, v11, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v38, v0, s74
  v_lshlrev_b32_e32 v38, 2, v38
  v_add_lshl_u32 v37, v3, v0, 1
  v_cndmask_b32_e64 v37, v8, v37, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v40, v0, s74
  v_lshlrev_b32_e32 v40, 2, v40
  v_add_lshl_u32 v39, v3, v0, 1
  v_cndmask_b32_e64 v39, v8, v39, s[78:79]
  v_accvgpr_read_b32 v12, a3
  v_accvgpr_read_b32 v13, a7
  v_accvgpr_read_b32 v14, a11
  v_accvgpr_read_b32 v15, a15
  v_accvgpr_read_b32 v16, a19
  v_accvgpr_read_b32 v17, a23
  v_accvgpr_read_b32 v18, a27
  v_accvgpr_read_b32 v19, a31
  v_accvgpr_read_b32 v20, a35
  v_accvgpr_read_b32 v21, a39
  v_accvgpr_read_b32 v22, a43
  v_accvgpr_read_b32 v23, a47
  v_accvgpr_read_b32 v24, a51
  v_accvgpr_read_b32 v25, a55
  v_accvgpr_read_b32 v26, a59
  v_accvgpr_read_b32 v27, a63
  v_pk_mul_f32 v[12:13], s[44:45], v[12:13] op_sel_hi:[0,1]
  v_pk_mul_f32 v[14:15], s[44:45], v[14:15] op_sel_hi:[0,1]
  v_pk_mul_f32 v[16:17], s[44:45], v[16:17] op_sel_hi:[0,1]
  v_pk_mul_f32 v[18:19], s[44:45], v[18:19] op_sel_hi:[0,1]
  v_pk_mul_f32 v[20:21], s[44:45], v[20:21] op_sel_hi:[0,1]
  v_pk_mul_f32 v[22:23], s[44:45], v[22:23] op_sel_hi:[0,1]
  v_pk_mul_f32 v[24:25], s[44:45], v[24:25] op_sel_hi:[0,1]
  v_pk_mul_f32 v[26:27], s[44:45], v[26:27] op_sel_hi:[0,1]
  s_waitcnt lgkmcnt(0)
  v_pk_mul_f32 v[12:13], v[32:33], v[12:13]
  v_pk_mul_f32 v[14:15], v[34:35], v[14:15]
  v_pk_add_f32 v[4:5], v[28:29], v[12:13]
  v_pk_add_f32 v[6:7], v[30:31], v[14:15]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[12:13], v[4:5]
  v_mov_b64_e32 v[14:15], v[6:7]
  v_cvt_f16_f32_e32 v12, v12
  v_cvt_f16_f32_e32 v13, v13
  v_pack_b32_f16 v12, v12, v13
  v_cvt_f16_f32_e32 v14, v14
  v_cvt_f16_f32_e32 v15, v15
  v_pack_b32_f16 v13, v14, v15
  buffer_store_dwordx2 v[12:13], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[16:17], v[32:33], v[16:17]
  v_pk_mul_f32 v[18:19], v[34:35], v[18:19]
  v_pk_add_f32 v[4:5], v[28:29], v[16:17]
  v_pk_add_f32 v[6:7], v[30:31], v[18:19]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[16:17], v[4:5]
  v_mov_b64_e32 v[18:19], v[6:7]
  v_cvt_f16_f32_e32 v16, v16
  v_cvt_f16_f32_e32 v17, v17
  v_pack_b32_f16 v16, v16, v17
  v_cvt_f16_f32_e32 v18, v18
  v_cvt_f16_f32_e32 v19, v19
  v_pack_b32_f16 v17, v18, v19
  buffer_store_dwordx2 v[16:17], v11, s[12:15], 0 offen
  v_pk_mul_f32 v[20:21], v[32:33], v[20:21]
  v_pk_mul_f32 v[22:23], v[34:35], v[22:23]
  v_pk_add_f32 v[4:5], v[28:29], v[20:21]
  v_pk_add_f32 v[6:7], v[30:31], v[22:23]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[20:21], v[4:5]
  v_mov_b64_e32 v[22:23], v[6:7]
  v_cvt_f16_f32_e32 v20, v20
  v_cvt_f16_f32_e32 v21, v21
  v_pack_b32_f16 v20, v20, v21
  v_cvt_f16_f32_e32 v22, v22
  v_cvt_f16_f32_e32 v23, v23
  v_pack_b32_f16 v21, v22, v23
  buffer_store_dwordx2 v[20:21], v37, s[12:15], 0 offen
  v_pk_mul_f32 v[24:25], v[32:33], v[24:25]
  v_pk_mul_f32 v[26:27], v[34:35], v[26:27]
  v_pk_add_f32 v[4:5], v[28:29], v[24:25]
  v_pk_add_f32 v[6:7], v[30:31], v[26:27]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[24:25], v[4:5]
  v_mov_b64_e32 v[26:27], v[6:7]
  v_cvt_f16_f32_e32 v24, v24
  v_cvt_f16_f32_e32 v25, v25
  v_pack_b32_f16 v24, v24, v25
  v_cvt_f16_f32_e32 v26, v26
  v_cvt_f16_f32_e32 v27, v27
  v_pack_b32_f16 v25, v26, v27
  buffer_store_dwordx2 v[24:25], v39, s[12:15], 0 offen
  s_nop 0
  s_branch label_GW_End_1
label_GW_B0_E1_M_1:
  s_cmpk_eq_u32 s72, 0x3
  s_cbranch_scc1 label_To_Activation_Gelu_VW1_beta_0_edge_1
  s_cmpk_eq_u32 s72, 0x5
  s_cbranch_scc1 label_To_Activation_Relu_VW1_beta_0_edge_1
  s_cmpk_eq_u32 s72, 0xa
  s_cbranch_scc1 label_To_Activation_Silu_VW1_beta_0_edge_1
  s_cmpk_eq_u32 s72, 0xc
  s_cbranch_scc1 label_To_Activation_Clamp_VW1_beta_0_edge_1
label_To_Activation_None_VW1_beta_0_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x6170, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_3
label_To_Activation_Gelu_VW1_beta_0_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x615c, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_3
label_To_Activation_Relu_VW1_beta_0_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x6188, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_3
label_To_Activation_Silu_VW1_beta_0_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x617c, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_3
label_To_Activation_Clamp_VW1_beta_0_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x6188, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_3
label_ActivationSetPCAddrEnd_3:
  v_mov_b32_e32 v8, 0x80000000
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v48, v0, s74
  v_lshlrev_b32_e32 v48, 2, v48
  s_waitcnt lgkmcnt(0)
  s_barrier
  ds_read_b32 v45, v48
  ds_read_b32 v46, v48 offset:1024
  v_add_lshl_u32 v47, v3, v0, 1
  v_cndmask_b32_e64 v47, v8, v47, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v52, v4, s74
  v_lshlrev_b32_e32 v52, 2, v52
  ds_read_b32 v49, v52
  ds_read_b32 v50, v52 offset:1024
  v_add_lshl_u32 v51, v3, v4, 1
  v_cndmask_b32_e64 v51, v8, v51, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v56, v4, s74
  v_lshlrev_b32_e32 v56, 2, v56
  ds_read_b32 v53, v56
  ds_read_b32 v54, v56 offset:1024
  v_add_lshl_u32 v55, v3, v4, 1
  v_cndmask_b32_e64 v55, v8, v55, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v60, v4, s74
  v_lshlrev_b32_e32 v60, 2, v60
  ds_read_b32 v57, v60
  ds_read_b32 v58, v60 offset:1024
  v_add_lshl_u32 v59, v3, v4, 1
  v_cndmask_b32_e64 v59, v8, v59, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v62, v0, s74
  v_lshlrev_b32_e32 v62, 2, v62
  v_add_lshl_u32 v61, v3, v0, 1
  v_cndmask_b32_e64 v61, v8, v61, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v64, v4, s74
  v_lshlrev_b32_e32 v64, 2, v64
  v_add_lshl_u32 v63, v3, v4, 1
  v_cndmask_b32_e64 v63, v8, v63, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v66, v4, s74
  v_lshlrev_b32_e32 v66, 2, v66
  v_add_lshl_u32 v65, v3, v4, 1
  v_cndmask_b32_e64 v65, v8, v65, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v68, v4, s74
  v_lshlrev_b32_e32 v68, 2, v68
  v_add_lshl_u32 v67, v3, v4, 1
  v_cndmask_b32_e64 v67, v8, v67, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v70, v0, s74
  v_lshlrev_b32_e32 v70, 2, v70
  v_add_lshl_u32 v69, v3, v0, 1
  v_cndmask_b32_e64 v69, v8, v69, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v72, v4, s74
  v_lshlrev_b32_e32 v72, 2, v72
  v_add_lshl_u32 v71, v3, v4, 1
  v_cndmask_b32_e64 v71, v8, v71, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v74, v4, s74
  v_lshlrev_b32_e32 v74, 2, v74
  v_add_lshl_u32 v73, v3, v4, 1
  v_cndmask_b32_e64 v73, v8, v73, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v76, v4, s74
  v_lshlrev_b32_e32 v76, 2, v76
  v_add_lshl_u32 v75, v3, v4, 1
  v_cndmask_b32_e64 v75, v8, v75, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v78, v0, s74
  v_lshlrev_b32_e32 v78, 2, v78
  v_add_lshl_u32 v77, v3, v0, 1
  v_cndmask_b32_e64 v77, v8, v77, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v80, v4, s74
  v_lshlrev_b32_e32 v80, 2, v80
  v_add_lshl_u32 v79, v3, v4, 1
  v_cndmask_b32_e64 v79, v8, v79, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v82, v4, s74
  v_lshlrev_b32_e32 v82, 2, v82
  v_add_lshl_u32 v81, v3, v4, 1
  v_cndmask_b32_e64 v81, v8, v81, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v84, v4, s74
  v_lshlrev_b32_e32 v84, 2, v84
  v_add_lshl_u32 v83, v3, v4, 1
  v_cndmask_b32_e64 v83, v8, v83, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v86, v0, s74
  v_lshlrev_b32_e32 v86, 2, v86
  v_add_lshl_u32 v85, v3, v0, 1
  v_cndmask_b32_e64 v85, v8, v85, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v88, v4, s74
  v_lshlrev_b32_e32 v88, 2, v88
  v_add_lshl_u32 v87, v3, v4, 1
  v_cndmask_b32_e64 v87, v8, v87, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v90, v4, s74
  v_lshlrev_b32_e32 v90, 2, v90
  v_add_lshl_u32 v89, v3, v4, 1
  v_cndmask_b32_e64 v89, v8, v89, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v92, v4, s74
  v_lshlrev_b32_e32 v92, 2, v92
  v_add_lshl_u32 v91, v3, v4, 1
  v_cndmask_b32_e64 v91, v8, v91, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v94, v0, s74
  v_lshlrev_b32_e32 v94, 2, v94
  v_add_lshl_u32 v93, v3, v0, 1
  v_cndmask_b32_e64 v93, v8, v93, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v96, v4, s74
  v_lshlrev_b32_e32 v96, 2, v96
  v_add_lshl_u32 v95, v3, v4, 1
  v_cndmask_b32_e64 v95, v8, v95, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v98, v4, s74
  v_lshlrev_b32_e32 v98, 2, v98
  v_add_lshl_u32 v97, v3, v4, 1
  v_cndmask_b32_e64 v97, v8, v97, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v100, v4, s74
  v_lshlrev_b32_e32 v100, 2, v100
  v_add_lshl_u32 v99, v3, v4, 1
  v_cndmask_b32_e64 v99, v8, v99, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v102, v0, s74
  v_lshlrev_b32_e32 v102, 2, v102
  v_add_lshl_u32 v101, v3, v0, 1
  v_cndmask_b32_e64 v101, v8, v101, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v104, v4, s74
  v_lshlrev_b32_e32 v104, 2, v104
  v_add_lshl_u32 v103, v3, v4, 1
  v_cndmask_b32_e64 v103, v8, v103, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v106, v4, s74
  v_lshlrev_b32_e32 v106, 2, v106
  v_add_lshl_u32 v105, v3, v4, 1
  v_cndmask_b32_e64 v105, v8, v105, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v108, v4, s74
  v_lshlrev_b32_e32 v108, 2, v108
  v_add_lshl_u32 v107, v3, v4, 1
  v_cndmask_b32_e64 v107, v8, v107, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v110, v0, s74
  v_lshlrev_b32_e32 v110, 2, v110
  v_add_lshl_u32 v109, v3, v0, 1
  v_cndmask_b32_e64 v109, v8, v109, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v112, v4, s74
  v_lshlrev_b32_e32 v112, 2, v112
  v_add_lshl_u32 v111, v3, v4, 1
  v_cndmask_b32_e64 v111, v8, v111, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v114, v4, s74
  v_lshlrev_b32_e32 v114, 2, v114
  v_add_lshl_u32 v113, v3, v4, 1
  v_cndmask_b32_e64 v113, v8, v113, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v116, v4, s74
  v_lshlrev_b32_e32 v116, 2, v116
  v_add_lshl_u32 v115, v3, v4, 1
  v_cndmask_b32_e64 v115, v8, v115, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v118, v0, s74
  v_lshlrev_b32_e32 v118, 2, v118
  v_add_lshl_u32 v117, v3, v0, 1
  v_cndmask_b32_e64 v117, v8, v117, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v120, v4, s74
  v_lshlrev_b32_e32 v120, 2, v120
  v_add_lshl_u32 v119, v3, v4, 1
  v_cndmask_b32_e64 v119, v8, v119, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v122, v4, s74
  v_lshlrev_b32_e32 v122, 2, v122
  v_add_lshl_u32 v121, v3, v4, 1
  v_cndmask_b32_e64 v121, v8, v121, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v125, v4, s74
  v_lshlrev_b32_e32 v125, 2, v125
  v_add_lshl_u32 v123, v3, v4, 1
  v_cndmask_b32_e64 v123, v8, v123, s[78:79]
  v_accvgpr_read_b32 v9, a0
  v_accvgpr_read_b32 v10, a4
  v_accvgpr_read_b32 v11, a8
  v_accvgpr_read_b32 v12, a12
  v_accvgpr_read_b32 v13, a16
  v_accvgpr_read_b32 v14, a20
  v_accvgpr_read_b32 v15, a24
  v_accvgpr_read_b32 v16, a28
  v_accvgpr_read_b32 v17, a32
  v_accvgpr_read_b32 v18, a36
  v_accvgpr_read_b32 v19, a40
  v_accvgpr_read_b32 v20, a44
  v_accvgpr_read_b32 v21, a48
  v_accvgpr_read_b32 v22, a52
  v_accvgpr_read_b32 v23, a56
  v_accvgpr_read_b32 v24, a60
  v_accvgpr_read_b32 v25, a1
  v_accvgpr_read_b32 v26, a5
  v_accvgpr_read_b32 v27, a9
  v_accvgpr_read_b32 v28, a13
  v_accvgpr_read_b32 v29, a17
  v_accvgpr_read_b32 v30, a21
  v_accvgpr_read_b32 v31, a25
  v_accvgpr_read_b32 v32, a29
  v_accvgpr_read_b32 v33, a33
  v_accvgpr_read_b32 v34, a37
  v_accvgpr_read_b32 v35, a41
  v_accvgpr_read_b32 v36, a45
  v_accvgpr_read_b32 v37, a49
  v_accvgpr_read_b32 v38, a53
  v_accvgpr_read_b32 v39, a57
  v_accvgpr_read_b32 v40, a61
  v_accvgpr_read_b32 v41, a2
  v_accvgpr_read_b32 v42, a6
  v_accvgpr_read_b32 v43, a10
  v_accvgpr_read_b32 v44, a14
  v_mul_f32_e32 v9, s44, v9
  v_pk_mul_f32 v[10:11], s[44:45], v[10:11] op_sel_hi:[0,1]
  v_pk_mul_f32 v[12:13], s[44:45], v[12:13] op_sel_hi:[0,1]
  v_pk_mul_f32 v[14:15], s[44:45], v[14:15] op_sel_hi:[0,1]
  v_pk_mul_f32 v[16:17], s[44:45], v[16:17] op_sel_hi:[0,1]
  v_pk_mul_f32 v[18:19], s[44:45], v[18:19] op_sel_hi:[0,1]
  v_pk_mul_f32 v[20:21], s[44:45], v[20:21] op_sel_hi:[0,1]
  v_pk_mul_f32 v[22:23], s[44:45], v[22:23] op_sel_hi:[0,1]
  v_pk_mul_f32 v[24:25], s[44:45], v[24:25] op_sel_hi:[0,1]
  v_pk_mul_f32 v[26:27], s[44:45], v[26:27] op_sel_hi:[0,1]
  v_pk_mul_f32 v[28:29], s[44:45], v[28:29] op_sel_hi:[0,1]
  v_pk_mul_f32 v[30:31], s[44:45], v[30:31] op_sel_hi:[0,1]
  v_pk_mul_f32 v[32:33], s[44:45], v[32:33] op_sel_hi:[0,1]
  v_pk_mul_f32 v[34:35], s[44:45], v[34:35] op_sel_hi:[0,1]
  v_pk_mul_f32 v[36:37], s[44:45], v[36:37] op_sel_hi:[0,1]
  v_pk_mul_f32 v[38:39], s[44:45], v[38:39] op_sel_hi:[0,1]
  v_pk_mul_f32 v[40:41], s[44:45], v[40:41] op_sel_hi:[0,1]
  v_pk_mul_f32 v[42:43], s[44:45], v[42:43] op_sel_hi:[0,1]
  v_mul_f32_e32 v44, s44, v44
  s_waitcnt lgkmcnt(0)
  v_mul_f32_e32 v9, v46, v9
  v_add_f32_e32 v4, v45, v9
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v9, v4
  v_cvt_f16_f32_e32 v9, v9
  buffer_store_short v9, v47, s[12:15], 0 offen
  v_mul_f32_e32 v10, v50, v10
  v_add_f32_e32 v4, v49, v10
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v10, v4
  v_cvt_f16_f32_e32 v10, v10
  buffer_store_short v10, v51, s[12:15], 0 offen
  v_mul_f32_e32 v11, v54, v11
  v_add_f32_e32 v4, v53, v11
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v11, v4
  v_cvt_f16_f32_e32 v11, v11
  buffer_store_short v11, v55, s[12:15], 0 offen
  v_mul_f32_e32 v12, v58, v12
  v_add_f32_e32 v4, v57, v12
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v12, v4
  v_cvt_f16_f32_e32 v12, v12
  buffer_store_short v12, v59, s[12:15], 0 offen
  v_mul_f32_e32 v13, v46, v13
  v_add_f32_e32 v4, v45, v13
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v13, v4
  v_cvt_f16_f32_e32 v13, v13
  buffer_store_short v13, v61, s[12:15], 0 offen
  v_mul_f32_e32 v14, v50, v14
  v_add_f32_e32 v4, v49, v14
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v14, v4
  v_cvt_f16_f32_e32 v14, v14
  buffer_store_short v14, v63, s[12:15], 0 offen
  v_mul_f32_e32 v15, v54, v15
  v_add_f32_e32 v4, v53, v15
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v15, v4
  v_cvt_f16_f32_e32 v15, v15
  buffer_store_short v15, v65, s[12:15], 0 offen
  v_mul_f32_e32 v16, v58, v16
  v_add_f32_e32 v4, v57, v16
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v16, v4
  v_cvt_f16_f32_e32 v16, v16
  buffer_store_short v16, v67, s[12:15], 0 offen
  v_mul_f32_e32 v17, v46, v17
  v_add_f32_e32 v4, v45, v17
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v17, v4
  v_cvt_f16_f32_e32 v17, v17
  buffer_store_short v17, v69, s[12:15], 0 offen
  v_mul_f32_e32 v18, v50, v18
  v_add_f32_e32 v4, v49, v18
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v18, v4
  v_cvt_f16_f32_e32 v18, v18
  buffer_store_short v18, v71, s[12:15], 0 offen
  v_mul_f32_e32 v19, v54, v19
  v_add_f32_e32 v4, v53, v19
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v19, v4
  v_cvt_f16_f32_e32 v19, v19
  buffer_store_short v19, v73, s[12:15], 0 offen
  v_mul_f32_e32 v20, v58, v20
  v_add_f32_e32 v4, v57, v20
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v20, v4
  v_cvt_f16_f32_e32 v20, v20
  buffer_store_short v20, v75, s[12:15], 0 offen
  v_mul_f32_e32 v21, v46, v21
  v_add_f32_e32 v4, v45, v21
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v21, v4
  v_cvt_f16_f32_e32 v21, v21
  buffer_store_short v21, v77, s[12:15], 0 offen
  v_mul_f32_e32 v22, v50, v22
  v_add_f32_e32 v4, v49, v22
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v22, v4
  v_cvt_f16_f32_e32 v22, v22
  buffer_store_short v22, v79, s[12:15], 0 offen
  v_mul_f32_e32 v23, v54, v23
  v_add_f32_e32 v4, v53, v23
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v23, v4
  v_cvt_f16_f32_e32 v23, v23
  buffer_store_short v23, v81, s[12:15], 0 offen
  v_mul_f32_e32 v24, v58, v24
  v_add_f32_e32 v4, v57, v24
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v24, v4
  v_cvt_f16_f32_e32 v24, v24
  buffer_store_short v24, v83, s[12:15], 0 offen
  v_mul_f32_e32 v25, v46, v25
  v_add_f32_e32 v4, v45, v25
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v25, v4
  v_cvt_f16_f32_e32 v25, v25
  buffer_store_short v25, v85, s[12:15], 0 offen
  v_mul_f32_e32 v26, v50, v26
  v_add_f32_e32 v4, v49, v26
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v26, v4
  v_cvt_f16_f32_e32 v26, v26
  buffer_store_short v26, v87, s[12:15], 0 offen
  v_mul_f32_e32 v27, v54, v27
  v_add_f32_e32 v4, v53, v27
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v27, v4
  v_cvt_f16_f32_e32 v27, v27
  buffer_store_short v27, v89, s[12:15], 0 offen
  v_mul_f32_e32 v28, v58, v28
  v_add_f32_e32 v4, v57, v28
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v28, v4
  v_cvt_f16_f32_e32 v28, v28
  buffer_store_short v28, v91, s[12:15], 0 offen
  v_mul_f32_e32 v29, v46, v29
  v_add_f32_e32 v4, v45, v29
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v29, v4
  v_cvt_f16_f32_e32 v29, v29
  buffer_store_short v29, v93, s[12:15], 0 offen
  v_mul_f32_e32 v30, v50, v30
  v_add_f32_e32 v4, v49, v30
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v30, v4
  v_cvt_f16_f32_e32 v30, v30
  buffer_store_short v30, v95, s[12:15], 0 offen
  v_mul_f32_e32 v31, v54, v31
  v_add_f32_e32 v4, v53, v31
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v31, v4
  v_cvt_f16_f32_e32 v31, v31
  buffer_store_short v31, v97, s[12:15], 0 offen
  v_mul_f32_e32 v32, v58, v32
  v_add_f32_e32 v4, v57, v32
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v32, v4
  v_cvt_f16_f32_e32 v32, v32
  buffer_store_short v32, v99, s[12:15], 0 offen
  v_mul_f32_e32 v33, v46, v33
  v_add_f32_e32 v4, v45, v33
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v33, v4
  v_cvt_f16_f32_e32 v33, v33
  buffer_store_short v33, v101, s[12:15], 0 offen
  v_mul_f32_e32 v34, v50, v34
  v_add_f32_e32 v4, v49, v34
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v34, v4
  v_cvt_f16_f32_e32 v34, v34
  buffer_store_short v34, v103, s[12:15], 0 offen
  v_mul_f32_e32 v35, v54, v35
  v_add_f32_e32 v4, v53, v35
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v35, v4
  v_cvt_f16_f32_e32 v35, v35
  buffer_store_short v35, v105, s[12:15], 0 offen
  v_mul_f32_e32 v36, v58, v36
  v_add_f32_e32 v4, v57, v36
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v36, v4
  v_cvt_f16_f32_e32 v36, v36
  buffer_store_short v36, v107, s[12:15], 0 offen
  v_mul_f32_e32 v37, v46, v37
  v_add_f32_e32 v4, v45, v37
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v37, v4
  v_cvt_f16_f32_e32 v37, v37
  buffer_store_short v37, v109, s[12:15], 0 offen
  v_mul_f32_e32 v38, v50, v38
  v_add_f32_e32 v4, v49, v38
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v38, v4
  v_cvt_f16_f32_e32 v38, v38
  buffer_store_short v38, v111, s[12:15], 0 offen
  v_mul_f32_e32 v39, v54, v39
  v_add_f32_e32 v4, v53, v39
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v39, v4
  v_cvt_f16_f32_e32 v39, v39
  buffer_store_short v39, v113, s[12:15], 0 offen
  v_mul_f32_e32 v40, v58, v40
  v_add_f32_e32 v4, v57, v40
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v40, v4
  v_cvt_f16_f32_e32 v40, v40
  buffer_store_short v40, v115, s[12:15], 0 offen
  v_mul_f32_e32 v41, v46, v41
  v_add_f32_e32 v4, v45, v41
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v41, v4
  v_cvt_f16_f32_e32 v41, v41
  buffer_store_short v41, v117, s[12:15], 0 offen
  v_mul_f32_e32 v42, v50, v42
  v_add_f32_e32 v4, v49, v42
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v42, v4
  v_cvt_f16_f32_e32 v42, v42
  buffer_store_short v42, v119, s[12:15], 0 offen
  v_mul_f32_e32 v43, v54, v43
  v_add_f32_e32 v4, v53, v43
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v43, v4
  v_cvt_f16_f32_e32 v43, v43
  buffer_store_short v43, v121, s[12:15], 0 offen
  v_mul_f32_e32 v44, v58, v44
  v_add_f32_e32 v4, v57, v44
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v44, v4
  v_cvt_f16_f32_e32 v44, v44
  buffer_store_short v44, v123, s[12:15], 0 offen
  s_nop 0
  v_mov_b32_e32 v8, 0x80000000
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v40, v0, s74
  v_lshlrev_b32_e32 v40, 2, v40
  ds_read_b32 v37, v40
  ds_read_b32 v38, v40 offset:1024
  v_add_lshl_u32 v39, v3, v0, 1
  v_cndmask_b32_e64 v39, v8, v39, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v44, v4, s74
  v_lshlrev_b32_e32 v44, 2, v44
  ds_read_b32 v41, v44
  ds_read_b32 v42, v44 offset:1024
  v_add_lshl_u32 v43, v3, v4, 1
  v_cndmask_b32_e64 v43, v8, v43, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v48, v4, s74
  v_lshlrev_b32_e32 v48, 2, v48
  ds_read_b32 v45, v48
  ds_read_b32 v46, v48 offset:1024
  v_add_lshl_u32 v47, v3, v4, 1
  v_cndmask_b32_e64 v47, v8, v47, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v52, v4, s74
  v_lshlrev_b32_e32 v52, 2, v52
  ds_read_b32 v49, v52
  ds_read_b32 v50, v52 offset:1024
  v_add_lshl_u32 v51, v3, v4, 1
  v_cndmask_b32_e64 v51, v8, v51, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v54, v0, s74
  v_lshlrev_b32_e32 v54, 2, v54
  v_add_lshl_u32 v53, v3, v0, 1
  v_cndmask_b32_e64 v53, v8, v53, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v56, v4, s74
  v_lshlrev_b32_e32 v56, 2, v56
  v_add_lshl_u32 v55, v3, v4, 1
  v_cndmask_b32_e64 v55, v8, v55, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v58, v4, s74
  v_lshlrev_b32_e32 v58, 2, v58
  v_add_lshl_u32 v57, v3, v4, 1
  v_cndmask_b32_e64 v57, v8, v57, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v60, v4, s74
  v_lshlrev_b32_e32 v60, 2, v60
  v_add_lshl_u32 v59, v3, v4, 1
  v_cndmask_b32_e64 v59, v8, v59, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v62, v0, s74
  v_lshlrev_b32_e32 v62, 2, v62
  v_add_lshl_u32 v61, v3, v0, 1
  v_cndmask_b32_e64 v61, v8, v61, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v64, v4, s74
  v_lshlrev_b32_e32 v64, 2, v64
  v_add_lshl_u32 v63, v3, v4, 1
  v_cndmask_b32_e64 v63, v8, v63, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v66, v4, s74
  v_lshlrev_b32_e32 v66, 2, v66
  v_add_lshl_u32 v65, v3, v4, 1
  v_cndmask_b32_e64 v65, v8, v65, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v68, v4, s74
  v_lshlrev_b32_e32 v68, 2, v68
  v_add_lshl_u32 v67, v3, v4, 1
  v_cndmask_b32_e64 v67, v8, v67, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v70, v0, s74
  v_lshlrev_b32_e32 v70, 2, v70
  v_add_lshl_u32 v69, v3, v0, 1
  v_cndmask_b32_e64 v69, v8, v69, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v72, v4, s74
  v_lshlrev_b32_e32 v72, 2, v72
  v_add_lshl_u32 v71, v3, v4, 1
  v_cndmask_b32_e64 v71, v8, v71, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v74, v4, s74
  v_lshlrev_b32_e32 v74, 2, v74
  v_add_lshl_u32 v73, v3, v4, 1
  v_cndmask_b32_e64 v73, v8, v73, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v76, v4, s74
  v_lshlrev_b32_e32 v76, 2, v76
  v_add_lshl_u32 v75, v3, v4, 1
  v_cndmask_b32_e64 v75, v8, v75, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v78, v0, s74
  v_lshlrev_b32_e32 v78, 2, v78
  v_add_lshl_u32 v77, v3, v0, 1
  v_cndmask_b32_e64 v77, v8, v77, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v80, v4, s74
  v_lshlrev_b32_e32 v80, 2, v80
  v_add_lshl_u32 v79, v3, v4, 1
  v_cndmask_b32_e64 v79, v8, v79, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v82, v4, s74
  v_lshlrev_b32_e32 v82, 2, v82
  v_add_lshl_u32 v81, v3, v4, 1
  v_cndmask_b32_e64 v81, v8, v81, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v84, v4, s74
  v_lshlrev_b32_e32 v84, 2, v84
  v_add_lshl_u32 v83, v3, v4, 1
  v_cndmask_b32_e64 v83, v8, v83, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v86, v0, s74
  v_lshlrev_b32_e32 v86, 2, v86
  v_add_lshl_u32 v85, v3, v0, 1
  v_cndmask_b32_e64 v85, v8, v85, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v88, v4, s74
  v_lshlrev_b32_e32 v88, 2, v88
  v_add_lshl_u32 v87, v3, v4, 1
  v_cndmask_b32_e64 v87, v8, v87, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v90, v4, s74
  v_lshlrev_b32_e32 v90, 2, v90
  v_add_lshl_u32 v89, v3, v4, 1
  v_cndmask_b32_e64 v89, v8, v89, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v92, v4, s74
  v_lshlrev_b32_e32 v92, 2, v92
  v_add_lshl_u32 v91, v3, v4, 1
  v_cndmask_b32_e64 v91, v8, v91, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v94, v0, s74
  v_lshlrev_b32_e32 v94, 2, v94
  v_add_lshl_u32 v93, v3, v0, 1
  v_cndmask_b32_e64 v93, v8, v93, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v96, v4, s74
  v_lshlrev_b32_e32 v96, 2, v96
  v_add_lshl_u32 v95, v3, v4, 1
  v_cndmask_b32_e64 v95, v8, v95, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v98, v4, s74
  v_lshlrev_b32_e32 v98, 2, v98
  v_add_lshl_u32 v97, v3, v4, 1
  v_cndmask_b32_e64 v97, v8, v97, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v100, v4, s74
  v_lshlrev_b32_e32 v100, 2, v100
  v_add_lshl_u32 v99, v3, v4, 1
  v_cndmask_b32_e64 v99, v8, v99, s[78:79]
  v_accvgpr_read_b32 v9, a18
  v_accvgpr_read_b32 v10, a22
  v_accvgpr_read_b32 v11, a26
  v_accvgpr_read_b32 v12, a30
  v_accvgpr_read_b32 v13, a34
  v_accvgpr_read_b32 v14, a38
  v_accvgpr_read_b32 v15, a42
  v_accvgpr_read_b32 v16, a46
  v_accvgpr_read_b32 v17, a50
  v_accvgpr_read_b32 v18, a54
  v_accvgpr_read_b32 v19, a58
  v_accvgpr_read_b32 v20, a62
  v_accvgpr_read_b32 v21, a3
  v_accvgpr_read_b32 v22, a7
  v_accvgpr_read_b32 v23, a11
  v_accvgpr_read_b32 v24, a15
  v_accvgpr_read_b32 v25, a19
  v_accvgpr_read_b32 v26, a23
  v_accvgpr_read_b32 v27, a27
  v_accvgpr_read_b32 v28, a31
  v_accvgpr_read_b32 v29, a35
  v_accvgpr_read_b32 v30, a39
  v_accvgpr_read_b32 v31, a43
  v_accvgpr_read_b32 v32, a47
  v_accvgpr_read_b32 v33, a51
  v_accvgpr_read_b32 v34, a55
  v_accvgpr_read_b32 v35, a59
  v_accvgpr_read_b32 v36, a63
  v_mul_f32_e32 v9, s44, v9
  v_pk_mul_f32 v[10:11], s[44:45], v[10:11] op_sel_hi:[0,1]
  v_pk_mul_f32 v[12:13], s[44:45], v[12:13] op_sel_hi:[0,1]
  v_pk_mul_f32 v[14:15], s[44:45], v[14:15] op_sel_hi:[0,1]
  v_pk_mul_f32 v[16:17], s[44:45], v[16:17] op_sel_hi:[0,1]
  v_pk_mul_f32 v[18:19], s[44:45], v[18:19] op_sel_hi:[0,1]
  v_pk_mul_f32 v[20:21], s[44:45], v[20:21] op_sel_hi:[0,1]
  v_pk_mul_f32 v[22:23], s[44:45], v[22:23] op_sel_hi:[0,1]
  v_pk_mul_f32 v[24:25], s[44:45], v[24:25] op_sel_hi:[0,1]
  v_pk_mul_f32 v[26:27], s[44:45], v[26:27] op_sel_hi:[0,1]
  v_pk_mul_f32 v[28:29], s[44:45], v[28:29] op_sel_hi:[0,1]
  v_pk_mul_f32 v[30:31], s[44:45], v[30:31] op_sel_hi:[0,1]
  v_pk_mul_f32 v[32:33], s[44:45], v[32:33] op_sel_hi:[0,1]
  v_pk_mul_f32 v[34:35], s[44:45], v[34:35] op_sel_hi:[0,1]
  v_mul_f32_e32 v36, s44, v36
  s_waitcnt lgkmcnt(0)
  v_mul_f32_e32 v9, v38, v9
  v_add_f32_e32 v4, v37, v9
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v9, v4
  v_cvt_f16_f32_e32 v9, v9
  buffer_store_short v9, v39, s[12:15], 0 offen
  v_mul_f32_e32 v10, v42, v10
  v_add_f32_e32 v4, v41, v10
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v10, v4
  v_cvt_f16_f32_e32 v10, v10
  buffer_store_short v10, v43, s[12:15], 0 offen
  v_mul_f32_e32 v11, v46, v11
  v_add_f32_e32 v4, v45, v11
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v11, v4
  v_cvt_f16_f32_e32 v11, v11
  buffer_store_short v11, v47, s[12:15], 0 offen
  v_mul_f32_e32 v12, v50, v12
  v_add_f32_e32 v4, v49, v12
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v12, v4
  v_cvt_f16_f32_e32 v12, v12
  buffer_store_short v12, v51, s[12:15], 0 offen
  v_mul_f32_e32 v13, v38, v13
  v_add_f32_e32 v4, v37, v13
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v13, v4
  v_cvt_f16_f32_e32 v13, v13
  buffer_store_short v13, v53, s[12:15], 0 offen
  v_mul_f32_e32 v14, v42, v14
  v_add_f32_e32 v4, v41, v14
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v14, v4
  v_cvt_f16_f32_e32 v14, v14
  buffer_store_short v14, v55, s[12:15], 0 offen
  v_mul_f32_e32 v15, v46, v15
  v_add_f32_e32 v4, v45, v15
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v15, v4
  v_cvt_f16_f32_e32 v15, v15
  buffer_store_short v15, v57, s[12:15], 0 offen
  v_mul_f32_e32 v16, v50, v16
  v_add_f32_e32 v4, v49, v16
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v16, v4
  v_cvt_f16_f32_e32 v16, v16
  buffer_store_short v16, v59, s[12:15], 0 offen
  v_mul_f32_e32 v17, v38, v17
  v_add_f32_e32 v4, v37, v17
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v17, v4
  v_cvt_f16_f32_e32 v17, v17
  buffer_store_short v17, v61, s[12:15], 0 offen
  v_mul_f32_e32 v18, v42, v18
  v_add_f32_e32 v4, v41, v18
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v18, v4
  v_cvt_f16_f32_e32 v18, v18
  buffer_store_short v18, v63, s[12:15], 0 offen
  v_mul_f32_e32 v19, v46, v19
  v_add_f32_e32 v4, v45, v19
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v19, v4
  v_cvt_f16_f32_e32 v19, v19
  buffer_store_short v19, v65, s[12:15], 0 offen
  v_mul_f32_e32 v20, v50, v20
  v_add_f32_e32 v4, v49, v20
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v20, v4
  v_cvt_f16_f32_e32 v20, v20
  buffer_store_short v20, v67, s[12:15], 0 offen
  v_mul_f32_e32 v21, v38, v21
  v_add_f32_e32 v4, v37, v21
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v21, v4
  v_cvt_f16_f32_e32 v21, v21
  buffer_store_short v21, v69, s[12:15], 0 offen
  v_mul_f32_e32 v22, v42, v22
  v_add_f32_e32 v4, v41, v22
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v22, v4
  v_cvt_f16_f32_e32 v22, v22
  buffer_store_short v22, v71, s[12:15], 0 offen
  v_mul_f32_e32 v23, v46, v23
  v_add_f32_e32 v4, v45, v23
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v23, v4
  v_cvt_f16_f32_e32 v23, v23
  buffer_store_short v23, v73, s[12:15], 0 offen
  v_mul_f32_e32 v24, v50, v24
  v_add_f32_e32 v4, v49, v24
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v24, v4
  v_cvt_f16_f32_e32 v24, v24
  buffer_store_short v24, v75, s[12:15], 0 offen
  v_mul_f32_e32 v25, v38, v25
  v_add_f32_e32 v4, v37, v25
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v25, v4
  v_cvt_f16_f32_e32 v25, v25
  buffer_store_short v25, v77, s[12:15], 0 offen
  v_mul_f32_e32 v26, v42, v26
  v_add_f32_e32 v4, v41, v26
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v26, v4
  v_cvt_f16_f32_e32 v26, v26
  buffer_store_short v26, v79, s[12:15], 0 offen
  v_mul_f32_e32 v27, v46, v27
  v_add_f32_e32 v4, v45, v27
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v27, v4
  v_cvt_f16_f32_e32 v27, v27
  buffer_store_short v27, v81, s[12:15], 0 offen
  v_mul_f32_e32 v28, v50, v28
  v_add_f32_e32 v4, v49, v28
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v28, v4
  v_cvt_f16_f32_e32 v28, v28
  buffer_store_short v28, v83, s[12:15], 0 offen
  v_mul_f32_e32 v29, v38, v29
  v_add_f32_e32 v4, v37, v29
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v29, v4
  v_cvt_f16_f32_e32 v29, v29
  buffer_store_short v29, v85, s[12:15], 0 offen
  v_mul_f32_e32 v30, v42, v30
  v_add_f32_e32 v4, v41, v30
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v30, v4
  v_cvt_f16_f32_e32 v30, v30
  buffer_store_short v30, v87, s[12:15], 0 offen
  v_mul_f32_e32 v31, v46, v31
  v_add_f32_e32 v4, v45, v31
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v31, v4
  v_cvt_f16_f32_e32 v31, v31
  buffer_store_short v31, v89, s[12:15], 0 offen
  v_mul_f32_e32 v32, v50, v32
  v_add_f32_e32 v4, v49, v32
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v32, v4
  v_cvt_f16_f32_e32 v32, v32
  buffer_store_short v32, v91, s[12:15], 0 offen
  v_mul_f32_e32 v33, v38, v33
  v_add_f32_e32 v4, v37, v33
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v33, v4
  v_cvt_f16_f32_e32 v33, v33
  buffer_store_short v33, v93, s[12:15], 0 offen
  v_mul_f32_e32 v34, v42, v34
  v_add_f32_e32 v4, v41, v34
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v34, v4
  v_cvt_f16_f32_e32 v34, v34
  buffer_store_short v34, v95, s[12:15], 0 offen
  v_mul_f32_e32 v35, v46, v35
  v_add_f32_e32 v4, v45, v35
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v35, v4
  v_cvt_f16_f32_e32 v35, v35
  buffer_store_short v35, v97, s[12:15], 0 offen
  v_mul_f32_e32 v36, v50, v36
  v_add_f32_e32 v4, v49, v36
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v36, v4
  v_cvt_f16_f32_e32 v36, v36
  buffer_store_short v36, v99, s[12:15], 0 offen
  s_nop 0
  s_branch label_GW_End_1
label_GW_Beta_1:
  s_and_b32 s74, 0x7f, s20
  s_add_u32 s75, -1, s10
  s_cmp_ge_u32 s2, s75
  s_cselect_b32 s74, s74, 0
  s_cmpk_gt_u32 s74, 0x0
  s_cbranch_scc1 label_GW_B1_E1_M
  s_and_b32 s74, 0x7f, s21
  s_add_u32 s75, -1, s11
  s_cmp_ge_u32 s3, s75
  s_cselect_b32 s74, s74, 0
  s_cmpk_gt_u32 s74, 0x0
  s_cbranch_scc1 label_GW_B1_E1_N
label_GW_B1_E0:
  s_cmpk_eq_u32 s72, 0x3
  s_cbranch_scc1 label_To_Activation_Gelu_VW4_beta_1_edge_0
  s_cmpk_eq_u32 s72, 0x5
  s_cbranch_scc1 label_To_Activation_Relu_VW4_beta_1_edge_0
  s_cmpk_eq_u32 s72, 0xa
  s_cbranch_scc1 label_To_Activation_Silu_VW4_beta_1_edge_0
  s_cmpk_eq_u32 s72, 0xc
  s_cbranch_scc1 label_To_Activation_Clamp_VW4_beta_1_edge_0
label_To_Activation_None_VW4_beta_1_edge_0:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x4338, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_2
label_To_Activation_Gelu_VW4_beta_1_edge_0:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x4324, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_2
label_To_Activation_Relu_VW4_beta_1_edge_0:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x4410, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_2
label_To_Activation_Silu_VW4_beta_1_edge_0:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x441c, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_2
label_To_Activation_Clamp_VW4_beta_1_edge_0:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x4488, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_2
label_ActivationSetPCAddrEnd_2:
  v_add_lshl_u32 v10, v2, v0, 1
  buffer_load_dwordx2 v[60:61], v10, s[16:19], 0 offen
  s_mul_i32 s64, 0x80, s2
  v_sub_u32_e64 v11, v0, s64
  v_lshlrev_b32_e32 v11, 2, v11
  s_waitcnt lgkmcnt(0)
  s_barrier
  ds_read_b128 v[64:67], v11
  ds_read_b128 v[68:71], v11 offset:1024
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[62:63], v10, s[16:19], 0 offen
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[72:73], v10, s[16:19], 0 offen
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[74:75], v10, s[16:19], 0 offen
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[76:77], v10, s[16:19], 0 offen
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[78:79], v10, s[16:19], 0 offen
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[80:81], v10, s[16:19], 0 offen
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[82:83], v10, s[16:19], 0 offen
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[84:85], v10, s[16:19], 0 offen
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[86:87], v10, s[16:19], 0 offen
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[88:89], v10, s[16:19], 0 offen
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[90:91], v10, s[16:19], 0 offen
  v_add_lshl_u32 v9, v3, v0, 1
  v_accvgpr_read_b32 v12, a0
  v_accvgpr_read_b32 v13, a4
  v_accvgpr_read_b32 v14, a8
  v_accvgpr_read_b32 v15, a12
  v_accvgpr_read_b32 v16, a16
  v_accvgpr_read_b32 v17, a20
  v_accvgpr_read_b32 v18, a24
  v_accvgpr_read_b32 v19, a28
  v_accvgpr_read_b32 v20, a32
  v_accvgpr_read_b32 v21, a36
  v_accvgpr_read_b32 v22, a40
  v_accvgpr_read_b32 v23, a44
  v_accvgpr_read_b32 v24, a48
  v_accvgpr_read_b32 v25, a52
  v_accvgpr_read_b32 v26, a56
  v_accvgpr_read_b32 v27, a60
  v_accvgpr_read_b32 v28, a1
  v_accvgpr_read_b32 v29, a5
  v_accvgpr_read_b32 v30, a9
  v_accvgpr_read_b32 v31, a13
  v_accvgpr_read_b32 v32, a17
  v_accvgpr_read_b32 v33, a21
  v_accvgpr_read_b32 v34, a25
  v_accvgpr_read_b32 v35, a29
  v_accvgpr_read_b32 v36, a33
  v_accvgpr_read_b32 v37, a37
  v_accvgpr_read_b32 v38, a41
  v_accvgpr_read_b32 v39, a45
  v_accvgpr_read_b32 v40, a49
  v_accvgpr_read_b32 v41, a53
  v_accvgpr_read_b32 v42, a57
  v_accvgpr_read_b32 v43, a61
  v_accvgpr_read_b32 v44, a2
  v_accvgpr_read_b32 v45, a6
  v_accvgpr_read_b32 v46, a10
  v_accvgpr_read_b32 v47, a14
  v_accvgpr_read_b32 v48, a18
  v_accvgpr_read_b32 v49, a22
  v_accvgpr_read_b32 v50, a26
  v_accvgpr_read_b32 v51, a30
  v_accvgpr_read_b32 v52, a34
  v_accvgpr_read_b32 v53, a38
  v_accvgpr_read_b32 v54, a42
  v_accvgpr_read_b32 v55, a46
  v_accvgpr_read_b32 v56, a50
  v_accvgpr_read_b32 v57, a54
  v_accvgpr_read_b32 v58, a58
  v_accvgpr_read_b32 v59, a62
  v_pk_mul_f32 v[12:13], s[44:45], v[12:13] op_sel_hi:[0,1]
  v_pk_mul_f32 v[14:15], s[44:45], v[14:15] op_sel_hi:[0,1]
  v_pk_mul_f32 v[16:17], s[44:45], v[16:17] op_sel_hi:[0,1]
  v_pk_mul_f32 v[18:19], s[44:45], v[18:19] op_sel_hi:[0,1]
  v_pk_mul_f32 v[20:21], s[44:45], v[20:21] op_sel_hi:[0,1]
  v_pk_mul_f32 v[22:23], s[44:45], v[22:23] op_sel_hi:[0,1]
  v_pk_mul_f32 v[24:25], s[44:45], v[24:25] op_sel_hi:[0,1]
  v_pk_mul_f32 v[26:27], s[44:45], v[26:27] op_sel_hi:[0,1]
  v_pk_mul_f32 v[28:29], s[44:45], v[28:29] op_sel_hi:[0,1]
  v_pk_mul_f32 v[30:31], s[44:45], v[30:31] op_sel_hi:[0,1]
  v_pk_mul_f32 v[32:33], s[44:45], v[32:33] op_sel_hi:[0,1]
  v_pk_mul_f32 v[34:35], s[44:45], v[34:35] op_sel_hi:[0,1]
  v_pk_mul_f32 v[36:37], s[44:45], v[36:37] op_sel_hi:[0,1]
  v_pk_mul_f32 v[38:39], s[44:45], v[38:39] op_sel_hi:[0,1]
  v_pk_mul_f32 v[40:41], s[44:45], v[40:41] op_sel_hi:[0,1]
  v_pk_mul_f32 v[42:43], s[44:45], v[42:43] op_sel_hi:[0,1]
  v_pk_mul_f32 v[44:45], s[44:45], v[44:45] op_sel_hi:[0,1]
  v_pk_mul_f32 v[46:47], s[44:45], v[46:47] op_sel_hi:[0,1]
  v_pk_mul_f32 v[48:49], s[44:45], v[48:49] op_sel_hi:[0,1]
  v_pk_mul_f32 v[50:51], s[44:45], v[50:51] op_sel_hi:[0,1]
  v_pk_mul_f32 v[52:53], s[44:45], v[52:53] op_sel_hi:[0,1]
  v_pk_mul_f32 v[54:55], s[44:45], v[54:55] op_sel_hi:[0,1]
  v_pk_mul_f32 v[56:57], s[44:45], v[56:57] op_sel_hi:[0,1]
  v_pk_mul_f32 v[58:59], s[44:45], v[58:59] op_sel_hi:[0,1]
  s_waitcnt vmcnt(11) lgkmcnt(0)
  v_pk_mul_f32 v[12:13], v[68:69], v[12:13]
  v_pk_mul_f32 v[14:15], v[70:71], v[14:15]
  v_fma_mix_f32 v12, s45, v60, v12 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v13, s45, v60, v13 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v14, s45, v61, v14 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v15, s45, v61, v15 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[64:65], v[12:13]
  v_pk_add_f32 v[6:7], v[66:67], v[14:15]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[12:13], v[4:5]
  v_mov_b64_e32 v[14:15], v[6:7]
  v_cvt_f16_f32_e32 v12, v12
  v_cvt_f16_f32_e32 v13, v13
  v_pack_b32_f16 v12, v12, v13
  v_cvt_f16_f32_e32 v14, v14
  v_cvt_f16_f32_e32 v15, v15
  v_pack_b32_f16 v13, v14, v15
  buffer_store_dwordx2 v[12:13], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(11)
  v_pk_mul_f32 v[16:17], v[68:69], v[16:17]
  v_pk_mul_f32 v[18:19], v[70:71], v[18:19]
  v_fma_mix_f32 v16, s45, v62, v16 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v17, s45, v62, v17 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v18, s45, v63, v18 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v19, s45, v63, v19 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[64:65], v[16:17]
  v_pk_add_f32 v[6:7], v[66:67], v[18:19]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[16:17], v[4:5]
  v_mov_b64_e32 v[18:19], v[6:7]
  v_cvt_f16_f32_e32 v16, v16
  v_cvt_f16_f32_e32 v17, v17
  v_pack_b32_f16 v16, v16, v17
  v_cvt_f16_f32_e32 v18, v18
  v_cvt_f16_f32_e32 v19, v19
  v_pack_b32_f16 v17, v18, v19
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[16:17], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(11)
  v_pk_mul_f32 v[20:21], v[68:69], v[20:21]
  v_pk_mul_f32 v[22:23], v[70:71], v[22:23]
  v_fma_mix_f32 v20, s45, v72, v20 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v21, s45, v72, v21 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v22, s45, v73, v22 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v23, s45, v73, v23 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[64:65], v[20:21]
  v_pk_add_f32 v[6:7], v[66:67], v[22:23]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[20:21], v[4:5]
  v_mov_b64_e32 v[22:23], v[6:7]
  v_cvt_f16_f32_e32 v20, v20
  v_cvt_f16_f32_e32 v21, v21
  v_pack_b32_f16 v20, v20, v21
  v_cvt_f16_f32_e32 v22, v22
  v_cvt_f16_f32_e32 v23, v23
  v_pack_b32_f16 v21, v22, v23
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[20:21], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(11)
  v_pk_mul_f32 v[24:25], v[68:69], v[24:25]
  v_pk_mul_f32 v[26:27], v[70:71], v[26:27]
  v_fma_mix_f32 v24, s45, v74, v24 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v25, s45, v74, v25 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v26, s45, v75, v26 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v27, s45, v75, v27 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[64:65], v[24:25]
  v_pk_add_f32 v[6:7], v[66:67], v[26:27]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[24:25], v[4:5]
  v_mov_b64_e32 v[26:27], v[6:7]
  v_cvt_f16_f32_e32 v24, v24
  v_cvt_f16_f32_e32 v25, v25
  v_pack_b32_f16 v24, v24, v25
  v_cvt_f16_f32_e32 v26, v26
  v_cvt_f16_f32_e32 v27, v27
  v_pack_b32_f16 v25, v26, v27
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[24:25], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(11)
  v_pk_mul_f32 v[28:29], v[68:69], v[28:29]
  v_pk_mul_f32 v[30:31], v[70:71], v[30:31]
  v_fma_mix_f32 v28, s45, v76, v28 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v29, s45, v76, v29 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v30, s45, v77, v30 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v31, s45, v77, v31 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[64:65], v[28:29]
  v_pk_add_f32 v[6:7], v[66:67], v[30:31]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[28:29], v[4:5]
  v_mov_b64_e32 v[30:31], v[6:7]
  v_cvt_f16_f32_e32 v28, v28
  v_cvt_f16_f32_e32 v29, v29
  v_pack_b32_f16 v28, v28, v29
  v_cvt_f16_f32_e32 v30, v30
  v_cvt_f16_f32_e32 v31, v31
  v_pack_b32_f16 v29, v30, v31
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[28:29], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(11)
  v_pk_mul_f32 v[32:33], v[68:69], v[32:33]
  v_pk_mul_f32 v[34:35], v[70:71], v[34:35]
  v_fma_mix_f32 v32, s45, v78, v32 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v33, s45, v78, v33 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v34, s45, v79, v34 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v35, s45, v79, v35 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[64:65], v[32:33]
  v_pk_add_f32 v[6:7], v[66:67], v[34:35]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[32:33], v[4:5]
  v_mov_b64_e32 v[34:35], v[6:7]
  v_cvt_f16_f32_e32 v32, v32
  v_cvt_f16_f32_e32 v33, v33
  v_pack_b32_f16 v32, v32, v33
  v_cvt_f16_f32_e32 v34, v34
  v_cvt_f16_f32_e32 v35, v35
  v_pack_b32_f16 v33, v34, v35
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[32:33], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(11)
  v_pk_mul_f32 v[36:37], v[68:69], v[36:37]
  v_pk_mul_f32 v[38:39], v[70:71], v[38:39]
  v_fma_mix_f32 v36, s45, v80, v36 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v37, s45, v80, v37 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v38, s45, v81, v38 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v39, s45, v81, v39 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[64:65], v[36:37]
  v_pk_add_f32 v[6:7], v[66:67], v[38:39]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[36:37], v[4:5]
  v_mov_b64_e32 v[38:39], v[6:7]
  v_cvt_f16_f32_e32 v36, v36
  v_cvt_f16_f32_e32 v37, v37
  v_pack_b32_f16 v36, v36, v37
  v_cvt_f16_f32_e32 v38, v38
  v_cvt_f16_f32_e32 v39, v39
  v_pack_b32_f16 v37, v38, v39
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[36:37], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(11)
  v_pk_mul_f32 v[40:41], v[68:69], v[40:41]
  v_pk_mul_f32 v[42:43], v[70:71], v[42:43]
  v_fma_mix_f32 v40, s45, v82, v40 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v41, s45, v82, v41 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v42, s45, v83, v42 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v43, s45, v83, v43 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[64:65], v[40:41]
  v_pk_add_f32 v[6:7], v[66:67], v[42:43]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[40:41], v[4:5]
  v_mov_b64_e32 v[42:43], v[6:7]
  v_cvt_f16_f32_e32 v40, v40
  v_cvt_f16_f32_e32 v41, v41
  v_pack_b32_f16 v40, v40, v41
  v_cvt_f16_f32_e32 v42, v42
  v_cvt_f16_f32_e32 v43, v43
  v_pack_b32_f16 v41, v42, v43
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[40:41], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(11)
  v_pk_mul_f32 v[44:45], v[68:69], v[44:45]
  v_pk_mul_f32 v[46:47], v[70:71], v[46:47]
  v_fma_mix_f32 v44, s45, v84, v44 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v45, s45, v84, v45 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v46, s45, v85, v46 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v47, s45, v85, v47 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[64:65], v[44:45]
  v_pk_add_f32 v[6:7], v[66:67], v[46:47]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[44:45], v[4:5]
  v_mov_b64_e32 v[46:47], v[6:7]
  v_cvt_f16_f32_e32 v44, v44
  v_cvt_f16_f32_e32 v45, v45
  v_pack_b32_f16 v44, v44, v45
  v_cvt_f16_f32_e32 v46, v46
  v_cvt_f16_f32_e32 v47, v47
  v_pack_b32_f16 v45, v46, v47
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[44:45], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(11)
  v_pk_mul_f32 v[48:49], v[68:69], v[48:49]
  v_pk_mul_f32 v[50:51], v[70:71], v[50:51]
  v_fma_mix_f32 v48, s45, v86, v48 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v49, s45, v86, v49 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v50, s45, v87, v50 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v51, s45, v87, v51 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[64:65], v[48:49]
  v_pk_add_f32 v[6:7], v[66:67], v[50:51]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[48:49], v[4:5]
  v_mov_b64_e32 v[50:51], v[6:7]
  v_cvt_f16_f32_e32 v48, v48
  v_cvt_f16_f32_e32 v49, v49
  v_pack_b32_f16 v48, v48, v49
  v_cvt_f16_f32_e32 v50, v50
  v_cvt_f16_f32_e32 v51, v51
  v_pack_b32_f16 v49, v50, v51
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[48:49], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(11)
  v_pk_mul_f32 v[52:53], v[68:69], v[52:53]
  v_pk_mul_f32 v[54:55], v[70:71], v[54:55]
  v_fma_mix_f32 v52, s45, v88, v52 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v53, s45, v88, v53 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v54, s45, v89, v54 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v55, s45, v89, v55 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[64:65], v[52:53]
  v_pk_add_f32 v[6:7], v[66:67], v[54:55]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[52:53], v[4:5]
  v_mov_b64_e32 v[54:55], v[6:7]
  v_cvt_f16_f32_e32 v52, v52
  v_cvt_f16_f32_e32 v53, v53
  v_pack_b32_f16 v52, v52, v53
  v_cvt_f16_f32_e32 v54, v54
  v_cvt_f16_f32_e32 v55, v55
  v_pack_b32_f16 v53, v54, v55
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[52:53], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(11)
  v_pk_mul_f32 v[56:57], v[68:69], v[56:57]
  v_pk_mul_f32 v[58:59], v[70:71], v[58:59]
  v_fma_mix_f32 v56, s45, v90, v56 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v57, s45, v90, v57 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v58, s45, v91, v58 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v59, s45, v91, v59 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[64:65], v[56:57]
  v_pk_add_f32 v[6:7], v[66:67], v[58:59]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[56:57], v[4:5]
  v_mov_b64_e32 v[58:59], v[6:7]
  v_cvt_f16_f32_e32 v56, v56
  v_cvt_f16_f32_e32 v57, v57
  v_pack_b32_f16 v56, v56, v57
  v_cvt_f16_f32_e32 v58, v58
  v_cvt_f16_f32_e32 v59, v59
  v_pack_b32_f16 v57, v58, v59
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[56:57], v9, s[12:15], 0 offen
  s_nop 0
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[28:29], v10, s[16:19], 0 offen
  ds_read_b128 v[32:35], v11
  ds_read_b128 v[36:39], v11 offset:1024
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[30:31], v10, s[16:19], 0 offen
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[40:41], v10, s[16:19], 0 offen
  s_lshl_b32 s64, s38, 1
  s_add_u32 s16, s16, s64
  s_addc_u32 s17, s17, 0
  buffer_load_dwordx2 v[42:43], v10, s[16:19], 0 offen
  v_accvgpr_read_b32 v12, a3
  v_accvgpr_read_b32 v13, a7
  v_accvgpr_read_b32 v14, a11
  v_accvgpr_read_b32 v15, a15
  v_accvgpr_read_b32 v16, a19
  v_accvgpr_read_b32 v17, a23
  v_accvgpr_read_b32 v18, a27
  v_accvgpr_read_b32 v19, a31
  v_accvgpr_read_b32 v20, a35
  v_accvgpr_read_b32 v21, a39
  v_accvgpr_read_b32 v22, a43
  v_accvgpr_read_b32 v23, a47
  v_accvgpr_read_b32 v24, a51
  v_accvgpr_read_b32 v25, a55
  v_accvgpr_read_b32 v26, a59
  v_accvgpr_read_b32 v27, a63
  v_pk_mul_f32 v[12:13], s[44:45], v[12:13] op_sel_hi:[0,1]
  v_pk_mul_f32 v[14:15], s[44:45], v[14:15] op_sel_hi:[0,1]
  v_pk_mul_f32 v[16:17], s[44:45], v[16:17] op_sel_hi:[0,1]
  v_pk_mul_f32 v[18:19], s[44:45], v[18:19] op_sel_hi:[0,1]
  v_pk_mul_f32 v[20:21], s[44:45], v[20:21] op_sel_hi:[0,1]
  v_pk_mul_f32 v[22:23], s[44:45], v[22:23] op_sel_hi:[0,1]
  v_pk_mul_f32 v[24:25], s[44:45], v[24:25] op_sel_hi:[0,1]
  v_pk_mul_f32 v[26:27], s[44:45], v[26:27] op_sel_hi:[0,1]
  s_waitcnt vmcnt(3) lgkmcnt(0)
  v_pk_mul_f32 v[12:13], v[36:37], v[12:13]
  v_pk_mul_f32 v[14:15], v[38:39], v[14:15]
  v_fma_mix_f32 v12, s45, v28, v12 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v13, s45, v28, v13 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v14, s45, v29, v14 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v15, s45, v29, v15 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[32:33], v[12:13]
  v_pk_add_f32 v[6:7], v[34:35], v[14:15]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[12:13], v[4:5]
  v_mov_b64_e32 v[14:15], v[6:7]
  v_cvt_f16_f32_e32 v12, v12
  v_cvt_f16_f32_e32 v13, v13
  v_pack_b32_f16 v12, v12, v13
  v_cvt_f16_f32_e32 v14, v14
  v_cvt_f16_f32_e32 v15, v15
  v_pack_b32_f16 v13, v14, v15
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[12:13], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(3)
  v_pk_mul_f32 v[16:17], v[36:37], v[16:17]
  v_pk_mul_f32 v[18:19], v[38:39], v[18:19]
  v_fma_mix_f32 v16, s45, v30, v16 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v17, s45, v30, v17 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v18, s45, v31, v18 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v19, s45, v31, v19 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[32:33], v[16:17]
  v_pk_add_f32 v[6:7], v[34:35], v[18:19]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[16:17], v[4:5]
  v_mov_b64_e32 v[18:19], v[6:7]
  v_cvt_f16_f32_e32 v16, v16
  v_cvt_f16_f32_e32 v17, v17
  v_pack_b32_f16 v16, v16, v17
  v_cvt_f16_f32_e32 v18, v18
  v_cvt_f16_f32_e32 v19, v19
  v_pack_b32_f16 v17, v18, v19
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[16:17], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(3)
  v_pk_mul_f32 v[20:21], v[36:37], v[20:21]
  v_pk_mul_f32 v[22:23], v[38:39], v[22:23]
  v_fma_mix_f32 v20, s45, v40, v20 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v21, s45, v40, v21 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v22, s45, v41, v22 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v23, s45, v41, v23 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[32:33], v[20:21]
  v_pk_add_f32 v[6:7], v[34:35], v[22:23]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[20:21], v[4:5]
  v_mov_b64_e32 v[22:23], v[6:7]
  v_cvt_f16_f32_e32 v20, v20
  v_cvt_f16_f32_e32 v21, v21
  v_pack_b32_f16 v20, v20, v21
  v_cvt_f16_f32_e32 v22, v22
  v_cvt_f16_f32_e32 v23, v23
  v_pack_b32_f16 v21, v22, v23
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[20:21], v9, s[12:15], 0 offen
  s_waitcnt vmcnt(3)
  v_pk_mul_f32 v[24:25], v[36:37], v[24:25]
  v_pk_mul_f32 v[26:27], v[38:39], v[26:27]
  v_fma_mix_f32 v24, s45, v42, v24 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v25, s45, v42, v25 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v26, s45, v43, v26 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v27, s45, v43, v27 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[32:33], v[24:25]
  v_pk_add_f32 v[6:7], v[34:35], v[26:27]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[24:25], v[4:5]
  v_mov_b64_e32 v[26:27], v[6:7]
  v_cvt_f16_f32_e32 v24, v24
  v_cvt_f16_f32_e32 v25, v25
  v_pack_b32_f16 v24, v24, v25
  v_cvt_f16_f32_e32 v26, v26
  v_cvt_f16_f32_e32 v27, v27
  v_pack_b32_f16 v25, v26, v27
  s_lshl_b32 s64, s36, 1
  s_add_u32 s12, s12, s64
  s_addc_u32 s13, s13, 0
  buffer_store_dwordx2 v[24:25], v9, s[12:15], 0 offen
  s_nop 0
  s_branch label_GW_End_1
label_GW_B1_E1_N:
  s_cmpk_eq_u32 s72, 0x3
  s_cbranch_scc1 label_To_Activation_Gelu_VW4_beta_1_edge_1
  s_cmpk_eq_u32 s72, 0x5
  s_cbranch_scc1 label_To_Activation_Relu_VW4_beta_1_edge_1
  s_cmpk_eq_u32 s72, 0xa
  s_cbranch_scc1 label_To_Activation_Silu_VW4_beta_1_edge_1
  s_cmpk_eq_u32 s72, 0xc
  s_cbranch_scc1 label_To_Activation_Clamp_VW4_beta_1_edge_1
label_To_Activation_None_VW4_beta_1_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x35e0, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Gelu_VW4_beta_1_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x35cc, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Relu_VW4_beta_1_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x36b8, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Silu_VW4_beta_1_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x36c4, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_1
label_To_Activation_Clamp_VW4_beta_1_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x3730, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd_1
label_ActivationSetPCAddrEnd_1:
  v_mov_b32_e32 v8, 0x80000000
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v9, v2, v0, 1
  v_cndmask_b32_e64 v9, v8, v9, s[78:79]
  buffer_load_dwordx2 v[10:11], v9, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v60, v0, s74
  v_lshlrev_b32_e32 v60, 2, v60
  s_waitcnt lgkmcnt(0)
  s_barrier
  ds_read_b128 v[52:55], v60
  ds_read_b128 v[56:59], v60 offset:1024
  v_add_lshl_u32 v9, v3, v0, 1
  v_cndmask_b32_e64 v9, v8, v9, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v61, v2, v0, 1
  v_cndmask_b32_e64 v61, v8, v61, s[78:79]
  buffer_load_dwordx2 v[62:63], v61, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v64, v0, s74
  v_lshlrev_b32_e32 v64, 2, v64
  v_add_lshl_u32 v61, v3, v0, 1
  v_cndmask_b32_e64 v61, v8, v61, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v65, v2, v0, 1
  v_cndmask_b32_e64 v65, v8, v65, s[78:79]
  buffer_load_dwordx2 v[66:67], v65, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v68, v0, s74
  v_lshlrev_b32_e32 v68, 2, v68
  v_add_lshl_u32 v65, v3, v0, 1
  v_cndmask_b32_e64 v65, v8, v65, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v69, v2, v0, 1
  v_cndmask_b32_e64 v69, v8, v69, s[78:79]
  buffer_load_dwordx2 v[70:71], v69, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v72, v0, s74
  v_lshlrev_b32_e32 v72, 2, v72
  v_add_lshl_u32 v69, v3, v0, 1
  v_cndmask_b32_e64 v69, v8, v69, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v73, v2, v0, 1
  v_cndmask_b32_e64 v73, v8, v73, s[78:79]
  buffer_load_dwordx2 v[74:75], v73, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v76, v0, s74
  v_lshlrev_b32_e32 v76, 2, v76
  v_add_lshl_u32 v73, v3, v0, 1
  v_cndmask_b32_e64 v73, v8, v73, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v77, v2, v0, 1
  v_cndmask_b32_e64 v77, v8, v77, s[78:79]
  buffer_load_dwordx2 v[78:79], v77, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v80, v0, s74
  v_lshlrev_b32_e32 v80, 2, v80
  v_add_lshl_u32 v77, v3, v0, 1
  v_cndmask_b32_e64 v77, v8, v77, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v81, v2, v0, 1
  v_cndmask_b32_e64 v81, v8, v81, s[78:79]
  buffer_load_dwordx2 v[82:83], v81, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v84, v0, s74
  v_lshlrev_b32_e32 v84, 2, v84
  v_add_lshl_u32 v81, v3, v0, 1
  v_cndmask_b32_e64 v81, v8, v81, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v85, v2, v0, 1
  v_cndmask_b32_e64 v85, v8, v85, s[78:79]
  buffer_load_dwordx2 v[86:87], v85, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v88, v0, s74
  v_lshlrev_b32_e32 v88, 2, v88
  v_add_lshl_u32 v85, v3, v0, 1
  v_cndmask_b32_e64 v85, v8, v85, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v89, v2, v0, 1
  v_cndmask_b32_e64 v89, v8, v89, s[78:79]
  buffer_load_dwordx2 v[90:91], v89, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v92, v0, s74
  v_lshlrev_b32_e32 v92, 2, v92
  v_add_lshl_u32 v89, v3, v0, 1
  v_cndmask_b32_e64 v89, v8, v89, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v93, v2, v0, 1
  v_cndmask_b32_e64 v93, v8, v93, s[78:79]
  buffer_load_dwordx2 v[94:95], v93, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v96, v0, s74
  v_lshlrev_b32_e32 v96, 2, v96
  v_add_lshl_u32 v93, v3, v0, 1
  v_cndmask_b32_e64 v93, v8, v93, s[78:79]
  v_accvgpr_read_b32 v12, a0
  v_accvgpr_read_b32 v13, a4
  v_accvgpr_read_b32 v14, a8
  v_accvgpr_read_b32 v15, a12
  v_accvgpr_read_b32 v16, a16
  v_accvgpr_read_b32 v17, a20
  v_accvgpr_read_b32 v18, a24
  v_accvgpr_read_b32 v19, a28
  v_accvgpr_read_b32 v20, a32
  v_accvgpr_read_b32 v21, a36
  v_accvgpr_read_b32 v22, a40
  v_accvgpr_read_b32 v23, a44
  v_accvgpr_read_b32 v24, a48
  v_accvgpr_read_b32 v25, a52
  v_accvgpr_read_b32 v26, a56
  v_accvgpr_read_b32 v27, a60
  v_accvgpr_read_b32 v28, a1
  v_accvgpr_read_b32 v29, a5
  v_accvgpr_read_b32 v30, a9
  v_accvgpr_read_b32 v31, a13
  v_accvgpr_read_b32 v32, a17
  v_accvgpr_read_b32 v33, a21
  v_accvgpr_read_b32 v34, a25
  v_accvgpr_read_b32 v35, a29
  v_accvgpr_read_b32 v36, a33
  v_accvgpr_read_b32 v37, a37
  v_accvgpr_read_b32 v38, a41
  v_accvgpr_read_b32 v39, a45
  v_accvgpr_read_b32 v40, a49
  v_accvgpr_read_b32 v41, a53
  v_accvgpr_read_b32 v42, a57
  v_accvgpr_read_b32 v43, a61
  v_accvgpr_read_b32 v44, a2
  v_accvgpr_read_b32 v45, a6
  v_accvgpr_read_b32 v46, a10
  v_accvgpr_read_b32 v47, a14
  v_accvgpr_read_b32 v48, a18
  v_accvgpr_read_b32 v49, a22
  v_accvgpr_read_b32 v50, a26
  v_accvgpr_read_b32 v51, a30
  v_pk_mul_f32 v[12:13], s[44:45], v[12:13] op_sel_hi:[0,1]
  v_pk_mul_f32 v[14:15], s[44:45], v[14:15] op_sel_hi:[0,1]
  v_pk_mul_f32 v[16:17], s[44:45], v[16:17] op_sel_hi:[0,1]
  v_pk_mul_f32 v[18:19], s[44:45], v[18:19] op_sel_hi:[0,1]
  v_pk_mul_f32 v[20:21], s[44:45], v[20:21] op_sel_hi:[0,1]
  v_pk_mul_f32 v[22:23], s[44:45], v[22:23] op_sel_hi:[0,1]
  v_pk_mul_f32 v[24:25], s[44:45], v[24:25] op_sel_hi:[0,1]
  v_pk_mul_f32 v[26:27], s[44:45], v[26:27] op_sel_hi:[0,1]
  v_pk_mul_f32 v[28:29], s[44:45], v[28:29] op_sel_hi:[0,1]
  v_pk_mul_f32 v[30:31], s[44:45], v[30:31] op_sel_hi:[0,1]
  v_pk_mul_f32 v[32:33], s[44:45], v[32:33] op_sel_hi:[0,1]
  v_pk_mul_f32 v[34:35], s[44:45], v[34:35] op_sel_hi:[0,1]
  v_pk_mul_f32 v[36:37], s[44:45], v[36:37] op_sel_hi:[0,1]
  v_pk_mul_f32 v[38:39], s[44:45], v[38:39] op_sel_hi:[0,1]
  v_pk_mul_f32 v[40:41], s[44:45], v[40:41] op_sel_hi:[0,1]
  v_pk_mul_f32 v[42:43], s[44:45], v[42:43] op_sel_hi:[0,1]
  v_pk_mul_f32 v[44:45], s[44:45], v[44:45] op_sel_hi:[0,1]
  v_pk_mul_f32 v[46:47], s[44:45], v[46:47] op_sel_hi:[0,1]
  v_pk_mul_f32 v[48:49], s[44:45], v[48:49] op_sel_hi:[0,1]
  v_pk_mul_f32 v[50:51], s[44:45], v[50:51] op_sel_hi:[0,1]
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_pk_mul_f32 v[12:13], v[56:57], v[12:13]
  v_pk_mul_f32 v[14:15], v[58:59], v[14:15]
  v_fma_mix_f32 v12, s45, v10, v12 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v13, s45, v10, v13 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v14, s45, v11, v14 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v15, s45, v11, v15 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[52:53], v[12:13]
  v_pk_add_f32 v[6:7], v[54:55], v[14:15]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[12:13], v[4:5]
  v_mov_b64_e32 v[14:15], v[6:7]
  v_cvt_f16_f32_e32 v12, v12
  v_cvt_f16_f32_e32 v13, v13
  v_pack_b32_f16 v12, v12, v13
  v_cvt_f16_f32_e32 v14, v14
  v_cvt_f16_f32_e32 v15, v15
  v_pack_b32_f16 v13, v14, v15
  buffer_store_dwordx2 v[12:13], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[16:17], v[56:57], v[16:17]
  v_pk_mul_f32 v[18:19], v[58:59], v[18:19]
  v_fma_mix_f32 v16, s45, v62, v16 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v17, s45, v62, v17 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v18, s45, v63, v18 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v19, s45, v63, v19 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[52:53], v[16:17]
  v_pk_add_f32 v[6:7], v[54:55], v[18:19]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[16:17], v[4:5]
  v_mov_b64_e32 v[18:19], v[6:7]
  v_cvt_f16_f32_e32 v16, v16
  v_cvt_f16_f32_e32 v17, v17
  v_pack_b32_f16 v16, v16, v17
  v_cvt_f16_f32_e32 v18, v18
  v_cvt_f16_f32_e32 v19, v19
  v_pack_b32_f16 v17, v18, v19
  buffer_store_dwordx2 v[16:17], v61, s[12:15], 0 offen
  v_pk_mul_f32 v[20:21], v[56:57], v[20:21]
  v_pk_mul_f32 v[22:23], v[58:59], v[22:23]
  v_fma_mix_f32 v20, s45, v66, v20 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v21, s45, v66, v21 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v22, s45, v67, v22 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v23, s45, v67, v23 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[52:53], v[20:21]
  v_pk_add_f32 v[6:7], v[54:55], v[22:23]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[20:21], v[4:5]
  v_mov_b64_e32 v[22:23], v[6:7]
  v_cvt_f16_f32_e32 v20, v20
  v_cvt_f16_f32_e32 v21, v21
  v_pack_b32_f16 v20, v20, v21
  v_cvt_f16_f32_e32 v22, v22
  v_cvt_f16_f32_e32 v23, v23
  v_pack_b32_f16 v21, v22, v23
  buffer_store_dwordx2 v[20:21], v65, s[12:15], 0 offen
  v_pk_mul_f32 v[24:25], v[56:57], v[24:25]
  v_pk_mul_f32 v[26:27], v[58:59], v[26:27]
  v_fma_mix_f32 v24, s45, v70, v24 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v25, s45, v70, v25 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v26, s45, v71, v26 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v27, s45, v71, v27 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[52:53], v[24:25]
  v_pk_add_f32 v[6:7], v[54:55], v[26:27]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[24:25], v[4:5]
  v_mov_b64_e32 v[26:27], v[6:7]
  v_cvt_f16_f32_e32 v24, v24
  v_cvt_f16_f32_e32 v25, v25
  v_pack_b32_f16 v24, v24, v25
  v_cvt_f16_f32_e32 v26, v26
  v_cvt_f16_f32_e32 v27, v27
  v_pack_b32_f16 v25, v26, v27
  buffer_store_dwordx2 v[24:25], v69, s[12:15], 0 offen
  v_pk_mul_f32 v[28:29], v[56:57], v[28:29]
  v_pk_mul_f32 v[30:31], v[58:59], v[30:31]
  v_fma_mix_f32 v28, s45, v74, v28 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v29, s45, v74, v29 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v30, s45, v75, v30 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v31, s45, v75, v31 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[52:53], v[28:29]
  v_pk_add_f32 v[6:7], v[54:55], v[30:31]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[28:29], v[4:5]
  v_mov_b64_e32 v[30:31], v[6:7]
  v_cvt_f16_f32_e32 v28, v28
  v_cvt_f16_f32_e32 v29, v29
  v_pack_b32_f16 v28, v28, v29
  v_cvt_f16_f32_e32 v30, v30
  v_cvt_f16_f32_e32 v31, v31
  v_pack_b32_f16 v29, v30, v31
  buffer_store_dwordx2 v[28:29], v73, s[12:15], 0 offen
  v_pk_mul_f32 v[32:33], v[56:57], v[32:33]
  v_pk_mul_f32 v[34:35], v[58:59], v[34:35]
  v_fma_mix_f32 v32, s45, v78, v32 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v33, s45, v78, v33 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v34, s45, v79, v34 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v35, s45, v79, v35 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[52:53], v[32:33]
  v_pk_add_f32 v[6:7], v[54:55], v[34:35]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[32:33], v[4:5]
  v_mov_b64_e32 v[34:35], v[6:7]
  v_cvt_f16_f32_e32 v32, v32
  v_cvt_f16_f32_e32 v33, v33
  v_pack_b32_f16 v32, v32, v33
  v_cvt_f16_f32_e32 v34, v34
  v_cvt_f16_f32_e32 v35, v35
  v_pack_b32_f16 v33, v34, v35
  buffer_store_dwordx2 v[32:33], v77, s[12:15], 0 offen
  v_pk_mul_f32 v[36:37], v[56:57], v[36:37]
  v_pk_mul_f32 v[38:39], v[58:59], v[38:39]
  v_fma_mix_f32 v36, s45, v82, v36 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v37, s45, v82, v37 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v38, s45, v83, v38 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v39, s45, v83, v39 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[52:53], v[36:37]
  v_pk_add_f32 v[6:7], v[54:55], v[38:39]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[36:37], v[4:5]
  v_mov_b64_e32 v[38:39], v[6:7]
  v_cvt_f16_f32_e32 v36, v36
  v_cvt_f16_f32_e32 v37, v37
  v_pack_b32_f16 v36, v36, v37
  v_cvt_f16_f32_e32 v38, v38
  v_cvt_f16_f32_e32 v39, v39
  v_pack_b32_f16 v37, v38, v39
  buffer_store_dwordx2 v[36:37], v81, s[12:15], 0 offen
  v_pk_mul_f32 v[40:41], v[56:57], v[40:41]
  v_pk_mul_f32 v[42:43], v[58:59], v[42:43]
  v_fma_mix_f32 v40, s45, v86, v40 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v41, s45, v86, v41 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v42, s45, v87, v42 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v43, s45, v87, v43 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[52:53], v[40:41]
  v_pk_add_f32 v[6:7], v[54:55], v[42:43]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[40:41], v[4:5]
  v_mov_b64_e32 v[42:43], v[6:7]
  v_cvt_f16_f32_e32 v40, v40
  v_cvt_f16_f32_e32 v41, v41
  v_pack_b32_f16 v40, v40, v41
  v_cvt_f16_f32_e32 v42, v42
  v_cvt_f16_f32_e32 v43, v43
  v_pack_b32_f16 v41, v42, v43
  buffer_store_dwordx2 v[40:41], v85, s[12:15], 0 offen
  v_pk_mul_f32 v[44:45], v[56:57], v[44:45]
  v_pk_mul_f32 v[46:47], v[58:59], v[46:47]
  v_fma_mix_f32 v44, s45, v90, v44 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v45, s45, v90, v45 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v46, s45, v91, v46 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v47, s45, v91, v47 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[52:53], v[44:45]
  v_pk_add_f32 v[6:7], v[54:55], v[46:47]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[44:45], v[4:5]
  v_mov_b64_e32 v[46:47], v[6:7]
  v_cvt_f16_f32_e32 v44, v44
  v_cvt_f16_f32_e32 v45, v45
  v_pack_b32_f16 v44, v44, v45
  v_cvt_f16_f32_e32 v46, v46
  v_cvt_f16_f32_e32 v47, v47
  v_pack_b32_f16 v45, v46, v47
  buffer_store_dwordx2 v[44:45], v89, s[12:15], 0 offen
  v_pk_mul_f32 v[48:49], v[56:57], v[48:49]
  v_pk_mul_f32 v[50:51], v[58:59], v[50:51]
  v_fma_mix_f32 v48, s45, v94, v48 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v49, s45, v94, v49 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v50, s45, v95, v50 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v51, s45, v95, v51 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[52:53], v[48:49]
  v_pk_add_f32 v[6:7], v[54:55], v[50:51]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[48:49], v[4:5]
  v_mov_b64_e32 v[50:51], v[6:7]
  v_cvt_f16_f32_e32 v48, v48
  v_cvt_f16_f32_e32 v49, v49
  v_pack_b32_f16 v48, v48, v49
  v_cvt_f16_f32_e32 v50, v50
  v_cvt_f16_f32_e32 v51, v51
  v_pack_b32_f16 v49, v50, v51
  buffer_store_dwordx2 v[48:49], v93, s[12:15], 0 offen
  s_nop 0
  v_mov_b32_e32 v8, 0x80000000
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v9, v2, v0, 1
  v_cndmask_b32_e64 v9, v8, v9, s[78:79]
  buffer_load_dwordx2 v[10:11], v9, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v44, v0, s74
  v_lshlrev_b32_e32 v44, 2, v44
  ds_read_b128 v[36:39], v44
  ds_read_b128 v[40:43], v44 offset:1024
  v_add_lshl_u32 v9, v3, v0, 1
  v_cndmask_b32_e64 v9, v8, v9, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v45, v2, v0, 1
  v_cndmask_b32_e64 v45, v8, v45, s[78:79]
  buffer_load_dwordx2 v[46:47], v45, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v48, v0, s74
  v_lshlrev_b32_e32 v48, 2, v48
  v_add_lshl_u32 v45, v3, v0, 1
  v_cndmask_b32_e64 v45, v8, v45, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v49, v2, v0, 1
  v_cndmask_b32_e64 v49, v8, v49, s[78:79]
  buffer_load_dwordx2 v[50:51], v49, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v52, v0, s74
  v_lshlrev_b32_e32 v52, 2, v52
  v_add_lshl_u32 v49, v3, v0, 1
  v_cndmask_b32_e64 v49, v8, v49, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v53, v2, v0, 1
  v_cndmask_b32_e64 v53, v8, v53, s[78:79]
  buffer_load_dwordx2 v[54:55], v53, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v56, v0, s74
  v_lshlrev_b32_e32 v56, 2, v56
  v_add_lshl_u32 v53, v3, v0, 1
  v_cndmask_b32_e64 v53, v8, v53, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v57, v2, v0, 1
  v_cndmask_b32_e64 v57, v8, v57, s[78:79]
  buffer_load_dwordx2 v[58:59], v57, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v60, v0, s74
  v_lshlrev_b32_e32 v60, 2, v60
  v_add_lshl_u32 v57, v3, v0, 1
  v_cndmask_b32_e64 v57, v8, v57, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v61, v2, v0, 1
  v_cndmask_b32_e64 v61, v8, v61, s[78:79]
  buffer_load_dwordx2 v[62:63], v61, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v64, v0, s74
  v_lshlrev_b32_e32 v64, 2, v64
  v_add_lshl_u32 v61, v3, v0, 1
  v_cndmask_b32_e64 v61, v8, v61, s[78:79]
  v_accvgpr_read_b32 v12, a34
  v_accvgpr_read_b32 v13, a38
  v_accvgpr_read_b32 v14, a42
  v_accvgpr_read_b32 v15, a46
  v_accvgpr_read_b32 v16, a50
  v_accvgpr_read_b32 v17, a54
  v_accvgpr_read_b32 v18, a58
  v_accvgpr_read_b32 v19, a62
  v_accvgpr_read_b32 v20, a3
  v_accvgpr_read_b32 v21, a7
  v_accvgpr_read_b32 v22, a11
  v_accvgpr_read_b32 v23, a15
  v_accvgpr_read_b32 v24, a19
  v_accvgpr_read_b32 v25, a23
  v_accvgpr_read_b32 v26, a27
  v_accvgpr_read_b32 v27, a31
  v_accvgpr_read_b32 v28, a35
  v_accvgpr_read_b32 v29, a39
  v_accvgpr_read_b32 v30, a43
  v_accvgpr_read_b32 v31, a47
  v_accvgpr_read_b32 v32, a51
  v_accvgpr_read_b32 v33, a55
  v_accvgpr_read_b32 v34, a59
  v_accvgpr_read_b32 v35, a63
  v_pk_mul_f32 v[12:13], s[44:45], v[12:13] op_sel_hi:[0,1]
  v_pk_mul_f32 v[14:15], s[44:45], v[14:15] op_sel_hi:[0,1]
  v_pk_mul_f32 v[16:17], s[44:45], v[16:17] op_sel_hi:[0,1]
  v_pk_mul_f32 v[18:19], s[44:45], v[18:19] op_sel_hi:[0,1]
  v_pk_mul_f32 v[20:21], s[44:45], v[20:21] op_sel_hi:[0,1]
  v_pk_mul_f32 v[22:23], s[44:45], v[22:23] op_sel_hi:[0,1]
  v_pk_mul_f32 v[24:25], s[44:45], v[24:25] op_sel_hi:[0,1]
  v_pk_mul_f32 v[26:27], s[44:45], v[26:27] op_sel_hi:[0,1]
  v_pk_mul_f32 v[28:29], s[44:45], v[28:29] op_sel_hi:[0,1]
  v_pk_mul_f32 v[30:31], s[44:45], v[30:31] op_sel_hi:[0,1]
  v_pk_mul_f32 v[32:33], s[44:45], v[32:33] op_sel_hi:[0,1]
  v_pk_mul_f32 v[34:35], s[44:45], v[34:35] op_sel_hi:[0,1]
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_pk_mul_f32 v[12:13], v[40:41], v[12:13]
  v_pk_mul_f32 v[14:15], v[42:43], v[14:15]
  v_fma_mix_f32 v12, s45, v10, v12 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v13, s45, v10, v13 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v14, s45, v11, v14 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v15, s45, v11, v15 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[36:37], v[12:13]
  v_pk_add_f32 v[6:7], v[38:39], v[14:15]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[12:13], v[4:5]
  v_mov_b64_e32 v[14:15], v[6:7]
  v_cvt_f16_f32_e32 v12, v12
  v_cvt_f16_f32_e32 v13, v13
  v_pack_b32_f16 v12, v12, v13
  v_cvt_f16_f32_e32 v14, v14
  v_cvt_f16_f32_e32 v15, v15
  v_pack_b32_f16 v13, v14, v15
  buffer_store_dwordx2 v[12:13], v9, s[12:15], 0 offen
  v_pk_mul_f32 v[16:17], v[40:41], v[16:17]
  v_pk_mul_f32 v[18:19], v[42:43], v[18:19]
  v_fma_mix_f32 v16, s45, v46, v16 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v17, s45, v46, v17 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v18, s45, v47, v18 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v19, s45, v47, v19 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[36:37], v[16:17]
  v_pk_add_f32 v[6:7], v[38:39], v[18:19]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[16:17], v[4:5]
  v_mov_b64_e32 v[18:19], v[6:7]
  v_cvt_f16_f32_e32 v16, v16
  v_cvt_f16_f32_e32 v17, v17
  v_pack_b32_f16 v16, v16, v17
  v_cvt_f16_f32_e32 v18, v18
  v_cvt_f16_f32_e32 v19, v19
  v_pack_b32_f16 v17, v18, v19
  buffer_store_dwordx2 v[16:17], v45, s[12:15], 0 offen
  v_pk_mul_f32 v[20:21], v[40:41], v[20:21]
  v_pk_mul_f32 v[22:23], v[42:43], v[22:23]
  v_fma_mix_f32 v20, s45, v50, v20 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v21, s45, v50, v21 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v22, s45, v51, v22 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v23, s45, v51, v23 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[36:37], v[20:21]
  v_pk_add_f32 v[6:7], v[38:39], v[22:23]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[20:21], v[4:5]
  v_mov_b64_e32 v[22:23], v[6:7]
  v_cvt_f16_f32_e32 v20, v20
  v_cvt_f16_f32_e32 v21, v21
  v_pack_b32_f16 v20, v20, v21
  v_cvt_f16_f32_e32 v22, v22
  v_cvt_f16_f32_e32 v23, v23
  v_pack_b32_f16 v21, v22, v23
  buffer_store_dwordx2 v[20:21], v49, s[12:15], 0 offen
  v_pk_mul_f32 v[24:25], v[40:41], v[24:25]
  v_pk_mul_f32 v[26:27], v[42:43], v[26:27]
  v_fma_mix_f32 v24, s45, v54, v24 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v25, s45, v54, v25 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v26, s45, v55, v26 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v27, s45, v55, v27 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[36:37], v[24:25]
  v_pk_add_f32 v[6:7], v[38:39], v[26:27]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[24:25], v[4:5]
  v_mov_b64_e32 v[26:27], v[6:7]
  v_cvt_f16_f32_e32 v24, v24
  v_cvt_f16_f32_e32 v25, v25
  v_pack_b32_f16 v24, v24, v25
  v_cvt_f16_f32_e32 v26, v26
  v_cvt_f16_f32_e32 v27, v27
  v_pack_b32_f16 v25, v26, v27
  buffer_store_dwordx2 v[24:25], v53, s[12:15], 0 offen
  v_pk_mul_f32 v[28:29], v[40:41], v[28:29]
  v_pk_mul_f32 v[30:31], v[42:43], v[30:31]
  v_fma_mix_f32 v28, s45, v58, v28 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v29, s45, v58, v29 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v30, s45, v59, v30 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v31, s45, v59, v31 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[36:37], v[28:29]
  v_pk_add_f32 v[6:7], v[38:39], v[30:31]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[28:29], v[4:5]
  v_mov_b64_e32 v[30:31], v[6:7]
  v_cvt_f16_f32_e32 v28, v28
  v_cvt_f16_f32_e32 v29, v29
  v_pack_b32_f16 v28, v28, v29
  v_cvt_f16_f32_e32 v30, v30
  v_cvt_f16_f32_e32 v31, v31
  v_pack_b32_f16 v29, v30, v31
  buffer_store_dwordx2 v[28:29], v57, s[12:15], 0 offen
  v_pk_mul_f32 v[32:33], v[40:41], v[32:33]
  v_pk_mul_f32 v[34:35], v[42:43], v[34:35]
  v_fma_mix_f32 v32, s45, v62, v32 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v33, s45, v62, v33 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_fma_mix_f32 v34, s45, v63, v34 op_sel_hi:[0,1,0]
  v_fma_mix_f32 v35, s45, v63, v35 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_pk_add_f32 v[4:5], v[36:37], v[32:33]
  v_pk_add_f32 v[6:7], v[38:39], v[34:35]
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b64_e32 v[32:33], v[4:5]
  v_mov_b64_e32 v[34:35], v[6:7]
  v_cvt_f16_f32_e32 v32, v32
  v_cvt_f16_f32_e32 v33, v33
  v_pack_b32_f16 v32, v32, v33
  v_cvt_f16_f32_e32 v34, v34
  v_cvt_f16_f32_e32 v35, v35
  v_pack_b32_f16 v33, v34, v35
  buffer_store_dwordx2 v[32:33], v61, s[12:15], 0 offen
  s_nop 0
  s_branch label_GW_End_1
label_GW_B1_E1_M:
  s_cmpk_eq_u32 s72, 0x3
  s_cbranch_scc1 label_To_Activation_Gelu_VW1_beta_1_edge_1
  s_cmpk_eq_u32 s72, 0x5
  s_cbranch_scc1 label_To_Activation_Relu_VW1_beta_1_edge_1
  s_cmpk_eq_u32 s72, 0xa
  s_cbranch_scc1 label_To_Activation_Silu_VW1_beta_1_edge_1
  s_cmpk_eq_u32 s72, 0xc
  s_cbranch_scc1 label_To_Activation_Clamp_VW1_beta_1_edge_1
label_To_Activation_None_VW1_beta_1_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x2628, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Gelu_VW1_beta_1_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x2614, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Relu_VW1_beta_1_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x2640, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Silu_VW1_beta_1_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x2634, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd
label_To_Activation_Clamp_VW1_beta_1_edge_1:
  s_getpc_b64 s[8:9]
  s_add_i32 s64, 0x2640, 4
  s_add_u32 s8, s8, s64
  s_addc_u32 s9, s9, 0
  s_branch label_ActivationSetPCAddrEnd
label_ActivationSetPCAddrEnd:
  v_mov_b32_e32 v8, 0x80000000
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v42, v2, v0, 1
  v_cndmask_b32_e64 v42, v8, v42, s[78:79]
  buffer_load_short_d16 v39, v42, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v43, v0, s74
  v_lshlrev_b32_e32 v43, 2, v43
  s_waitcnt lgkmcnt(0)
  s_barrier
  ds_read_b32 v40, v43
  ds_read_b32 v41, v43 offset:1024
  v_add_lshl_u32 v42, v3, v0, 1
  v_cndmask_b32_e64 v42, v8, v42, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v47, v2, v4, 1
  v_cndmask_b32_e64 v47, v8, v47, s[78:79]
  buffer_load_short_d16_hi v44, v47, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v48, v4, s74
  v_lshlrev_b32_e32 v48, 2, v48
  ds_read_b32 v45, v48
  ds_read_b32 v46, v48 offset:1024
  v_add_lshl_u32 v47, v3, v4, 1
  v_cndmask_b32_e64 v47, v8, v47, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v52, v2, v4, 1
  v_cndmask_b32_e64 v52, v8, v52, s[78:79]
  buffer_load_short_d16 v49, v52, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v53, v4, s74
  v_lshlrev_b32_e32 v53, 2, v53
  ds_read_b32 v50, v53
  ds_read_b32 v51, v53 offset:1024
  v_add_lshl_u32 v52, v3, v4, 1
  v_cndmask_b32_e64 v52, v8, v52, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v57, v2, v4, 1
  v_cndmask_b32_e64 v57, v8, v57, s[78:79]
  buffer_load_short_d16_hi v54, v57, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v58, v4, s74
  v_lshlrev_b32_e32 v58, 2, v58
  ds_read_b32 v55, v58
  ds_read_b32 v56, v58 offset:1024
  v_add_lshl_u32 v57, v3, v4, 1
  v_cndmask_b32_e64 v57, v8, v57, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v60, v2, v0, 1
  v_cndmask_b32_e64 v60, v8, v60, s[78:79]
  buffer_load_short_d16 v59, v60, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v61, v0, s74
  v_lshlrev_b32_e32 v61, 2, v61
  v_add_lshl_u32 v60, v3, v0, 1
  v_cndmask_b32_e64 v60, v8, v60, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v63, v2, v4, 1
  v_cndmask_b32_e64 v63, v8, v63, s[78:79]
  buffer_load_short_d16_hi v62, v63, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v64, v4, s74
  v_lshlrev_b32_e32 v64, 2, v64
  v_add_lshl_u32 v63, v3, v4, 1
  v_cndmask_b32_e64 v63, v8, v63, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v66, v2, v4, 1
  v_cndmask_b32_e64 v66, v8, v66, s[78:79]
  buffer_load_short_d16 v65, v66, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v67, v4, s74
  v_lshlrev_b32_e32 v67, 2, v67
  v_add_lshl_u32 v66, v3, v4, 1
  v_cndmask_b32_e64 v66, v8, v66, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v69, v2, v4, 1
  v_cndmask_b32_e64 v69, v8, v69, s[78:79]
  buffer_load_short_d16_hi v68, v69, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v70, v4, s74
  v_lshlrev_b32_e32 v70, 2, v70
  v_add_lshl_u32 v69, v3, v4, 1
  v_cndmask_b32_e64 v69, v8, v69, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v72, v2, v0, 1
  v_cndmask_b32_e64 v72, v8, v72, s[78:79]
  buffer_load_short_d16 v71, v72, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v73, v0, s74
  v_lshlrev_b32_e32 v73, 2, v73
  v_add_lshl_u32 v72, v3, v0, 1
  v_cndmask_b32_e64 v72, v8, v72, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v75, v2, v4, 1
  v_cndmask_b32_e64 v75, v8, v75, s[78:79]
  buffer_load_short_d16_hi v74, v75, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v76, v4, s74
  v_lshlrev_b32_e32 v76, 2, v76
  v_add_lshl_u32 v75, v3, v4, 1
  v_cndmask_b32_e64 v75, v8, v75, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v78, v2, v4, 1
  v_cndmask_b32_e64 v78, v8, v78, s[78:79]
  buffer_load_short_d16 v77, v78, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v79, v4, s74
  v_lshlrev_b32_e32 v79, 2, v79
  v_add_lshl_u32 v78, v3, v4, 1
  v_cndmask_b32_e64 v78, v8, v78, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v81, v2, v4, 1
  v_cndmask_b32_e64 v81, v8, v81, s[78:79]
  buffer_load_short_d16_hi v80, v81, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v82, v4, s74
  v_lshlrev_b32_e32 v82, 2, v82
  v_add_lshl_u32 v81, v3, v4, 1
  v_cndmask_b32_e64 v81, v8, v81, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v84, v2, v0, 1
  v_cndmask_b32_e64 v84, v8, v84, s[78:79]
  buffer_load_short_d16 v83, v84, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v85, v0, s74
  v_lshlrev_b32_e32 v85, 2, v85
  v_add_lshl_u32 v84, v3, v0, 1
  v_cndmask_b32_e64 v84, v8, v84, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v87, v2, v4, 1
  v_cndmask_b32_e64 v87, v8, v87, s[78:79]
  buffer_load_short_d16_hi v86, v87, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v88, v4, s74
  v_lshlrev_b32_e32 v88, 2, v88
  v_add_lshl_u32 v87, v3, v4, 1
  v_cndmask_b32_e64 v87, v8, v87, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v90, v2, v4, 1
  v_cndmask_b32_e64 v90, v8, v90, s[78:79]
  buffer_load_short_d16 v89, v90, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v91, v4, s74
  v_lshlrev_b32_e32 v91, 2, v91
  v_add_lshl_u32 v90, v3, v4, 1
  v_cndmask_b32_e64 v90, v8, v90, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v93, v2, v4, 1
  v_cndmask_b32_e64 v93, v8, v93, s[78:79]
  buffer_load_short_d16_hi v92, v93, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v94, v4, s74
  v_lshlrev_b32_e32 v94, 2, v94
  v_add_lshl_u32 v93, v3, v4, 1
  v_cndmask_b32_e64 v93, v8, v93, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v96, v2, v0, 1
  v_cndmask_b32_e64 v96, v8, v96, s[78:79]
  buffer_load_short_d16 v95, v96, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v97, v0, s74
  v_lshlrev_b32_e32 v97, 2, v97
  v_add_lshl_u32 v96, v3, v0, 1
  v_cndmask_b32_e64 v96, v8, v96, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v99, v2, v4, 1
  v_cndmask_b32_e64 v99, v8, v99, s[78:79]
  buffer_load_short_d16_hi v98, v99, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v100, v4, s74
  v_lshlrev_b32_e32 v100, 2, v100
  v_add_lshl_u32 v99, v3, v4, 1
  v_cndmask_b32_e64 v99, v8, v99, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v102, v2, v4, 1
  v_cndmask_b32_e64 v102, v8, v102, s[78:79]
  buffer_load_short_d16 v101, v102, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v103, v4, s74
  v_lshlrev_b32_e32 v103, 2, v103
  v_add_lshl_u32 v102, v3, v4, 1
  v_cndmask_b32_e64 v102, v8, v102, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v105, v2, v4, 1
  v_cndmask_b32_e64 v105, v8, v105, s[78:79]
  buffer_load_short_d16_hi v104, v105, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v106, v4, s74
  v_lshlrev_b32_e32 v106, 2, v106
  v_add_lshl_u32 v105, v3, v4, 1
  v_cndmask_b32_e64 v105, v8, v105, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v108, v2, v0, 1
  v_cndmask_b32_e64 v108, v8, v108, s[78:79]
  buffer_load_short_d16 v107, v108, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v109, v0, s74
  v_lshlrev_b32_e32 v109, 2, v109
  v_add_lshl_u32 v108, v3, v0, 1
  v_cndmask_b32_e64 v108, v8, v108, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v111, v2, v4, 1
  v_cndmask_b32_e64 v111, v8, v111, s[78:79]
  buffer_load_short_d16_hi v110, v111, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v112, v4, s74
  v_lshlrev_b32_e32 v112, 2, v112
  v_add_lshl_u32 v111, v3, v4, 1
  v_cndmask_b32_e64 v111, v8, v111, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v114, v2, v4, 1
  v_cndmask_b32_e64 v114, v8, v114, s[78:79]
  buffer_load_short_d16 v113, v114, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v115, v4, s74
  v_lshlrev_b32_e32 v115, 2, v115
  v_add_lshl_u32 v114, v3, v4, 1
  v_cndmask_b32_e64 v114, v8, v114, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v117, v2, v4, 1
  v_cndmask_b32_e64 v117, v8, v117, s[78:79]
  buffer_load_short_d16_hi v116, v117, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v118, v4, s74
  v_lshlrev_b32_e32 v118, 2, v118
  v_add_lshl_u32 v117, v3, v4, 1
  v_cndmask_b32_e64 v117, v8, v117, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v120, v2, v0, 1
  v_cndmask_b32_e64 v120, v8, v120, s[78:79]
  buffer_load_short_d16 v119, v120, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v121, v0, s74
  v_lshlrev_b32_e32 v121, 2, v121
  v_add_lshl_u32 v120, v3, v0, 1
  v_cndmask_b32_e64 v120, v8, v120, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v123, v2, v4, 1
  v_cndmask_b32_e64 v123, v8, v123, s[78:79]
  buffer_load_short_d16_hi v122, v123, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v125, v4, s74
  v_lshlrev_b32_e32 v125, 2, v125
  v_add_lshl_u32 v123, v3, v4, 1
  v_cndmask_b32_e64 v123, v8, v123, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v127, v2, v4, 1
  v_cndmask_b32_e64 v127, v8, v127, s[78:79]
  buffer_load_short_d16 v126, v127, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v128, v4, s74
  v_lshlrev_b32_e32 v128, 2, v128
  v_add_lshl_u32 v127, v3, v4, 1
  v_cndmask_b32_e64 v127, v8, v127, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v130, v2, v4, 1
  v_cndmask_b32_e64 v130, v8, v130, s[78:79]
  buffer_load_short_d16_hi v129, v130, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v131, v4, s74
  v_lshlrev_b32_e32 v131, 2, v131
  v_add_lshl_u32 v130, v3, v4, 1
  v_cndmask_b32_e64 v130, v8, v130, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v133, v2, v0, 1
  v_cndmask_b32_e64 v133, v8, v133, s[78:79]
  buffer_load_short_d16 v132, v133, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v134, v0, s74
  v_lshlrev_b32_e32 v134, 2, v134
  v_add_lshl_u32 v133, v3, v0, 1
  v_cndmask_b32_e64 v133, v8, v133, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v136, v2, v4, 1
  v_cndmask_b32_e64 v136, v8, v136, s[78:79]
  buffer_load_short_d16_hi v135, v136, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v137, v4, s74
  v_lshlrev_b32_e32 v137, 2, v137
  v_add_lshl_u32 v136, v3, v4, 1
  v_cndmask_b32_e64 v136, v8, v136, s[78:79]
  v_accvgpr_read_b32 v9, a0
  v_accvgpr_read_b32 v10, a4
  v_accvgpr_read_b32 v11, a8
  v_accvgpr_read_b32 v12, a12
  v_accvgpr_read_b32 v13, a16
  v_accvgpr_read_b32 v14, a20
  v_accvgpr_read_b32 v15, a24
  v_accvgpr_read_b32 v16, a28
  v_accvgpr_read_b32 v17, a32
  v_accvgpr_read_b32 v18, a36
  v_accvgpr_read_b32 v19, a40
  v_accvgpr_read_b32 v20, a44
  v_accvgpr_read_b32 v21, a48
  v_accvgpr_read_b32 v22, a52
  v_accvgpr_read_b32 v23, a56
  v_accvgpr_read_b32 v24, a60
  v_accvgpr_read_b32 v25, a1
  v_accvgpr_read_b32 v26, a5
  v_accvgpr_read_b32 v27, a9
  v_accvgpr_read_b32 v28, a13
  v_accvgpr_read_b32 v29, a17
  v_accvgpr_read_b32 v30, a21
  v_accvgpr_read_b32 v31, a25
  v_accvgpr_read_b32 v32, a29
  v_accvgpr_read_b32 v33, a33
  v_accvgpr_read_b32 v34, a37
  v_accvgpr_read_b32 v35, a41
  v_accvgpr_read_b32 v36, a45
  v_accvgpr_read_b32 v37, a49
  v_accvgpr_read_b32 v38, a53
  v_mul_f32_e32 v9, s44, v9
  v_pk_mul_f32 v[10:11], s[44:45], v[10:11] op_sel_hi:[0,1]
  v_pk_mul_f32 v[12:13], s[44:45], v[12:13] op_sel_hi:[0,1]
  v_pk_mul_f32 v[14:15], s[44:45], v[14:15] op_sel_hi:[0,1]
  v_pk_mul_f32 v[16:17], s[44:45], v[16:17] op_sel_hi:[0,1]
  v_pk_mul_f32 v[18:19], s[44:45], v[18:19] op_sel_hi:[0,1]
  v_pk_mul_f32 v[20:21], s[44:45], v[20:21] op_sel_hi:[0,1]
  v_pk_mul_f32 v[22:23], s[44:45], v[22:23] op_sel_hi:[0,1]
  v_pk_mul_f32 v[24:25], s[44:45], v[24:25] op_sel_hi:[0,1]
  v_pk_mul_f32 v[26:27], s[44:45], v[26:27] op_sel_hi:[0,1]
  v_pk_mul_f32 v[28:29], s[44:45], v[28:29] op_sel_hi:[0,1]
  v_pk_mul_f32 v[30:31], s[44:45], v[30:31] op_sel_hi:[0,1]
  v_pk_mul_f32 v[32:33], s[44:45], v[32:33] op_sel_hi:[0,1]
  v_pk_mul_f32 v[34:35], s[44:45], v[34:35] op_sel_hi:[0,1]
  v_pk_mul_f32 v[36:37], s[44:45], v[36:37] op_sel_hi:[0,1]
  v_mul_f32_e32 v38, s44, v38
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_mul_f32_e32 v9, v41, v9
  v_fma_mix_f32 v9, s45, v39, v9 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v9
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v9, v4
  v_cvt_f16_f32_e32 v9, v9
  buffer_store_short v9, v42, s[12:15], 0 offen
  v_mul_f32_e32 v10, v46, v10
  v_fma_mix_f32 v10, s45, v44, v10 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v10
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v10, v4
  v_cvt_f16_f32_e32 v10, v10
  buffer_store_short v10, v47, s[12:15], 0 offen
  v_mul_f32_e32 v11, v51, v11
  v_fma_mix_f32 v11, s45, v49, v11 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v11
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v11, v4
  v_cvt_f16_f32_e32 v11, v11
  buffer_store_short v11, v52, s[12:15], 0 offen
  v_mul_f32_e32 v12, v56, v12
  v_fma_mix_f32 v12, s45, v54, v12 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v12
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v12, v4
  v_cvt_f16_f32_e32 v12, v12
  buffer_store_short v12, v57, s[12:15], 0 offen
  v_mul_f32_e32 v13, v41, v13
  v_fma_mix_f32 v13, s45, v59, v13 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v13
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v13, v4
  v_cvt_f16_f32_e32 v13, v13
  buffer_store_short v13, v60, s[12:15], 0 offen
  v_mul_f32_e32 v14, v46, v14
  v_fma_mix_f32 v14, s45, v62, v14 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v14
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v14, v4
  v_cvt_f16_f32_e32 v14, v14
  buffer_store_short v14, v63, s[12:15], 0 offen
  v_mul_f32_e32 v15, v51, v15
  v_fma_mix_f32 v15, s45, v65, v15 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v15
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v15, v4
  v_cvt_f16_f32_e32 v15, v15
  buffer_store_short v15, v66, s[12:15], 0 offen
  v_mul_f32_e32 v16, v56, v16
  v_fma_mix_f32 v16, s45, v68, v16 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v16
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v16, v4
  v_cvt_f16_f32_e32 v16, v16
  buffer_store_short v16, v69, s[12:15], 0 offen
  v_mul_f32_e32 v17, v41, v17
  v_fma_mix_f32 v17, s45, v71, v17 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v17
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v17, v4
  v_cvt_f16_f32_e32 v17, v17
  buffer_store_short v17, v72, s[12:15], 0 offen
  v_mul_f32_e32 v18, v46, v18
  v_fma_mix_f32 v18, s45, v74, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v18
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v18, v4
  v_cvt_f16_f32_e32 v18, v18
  buffer_store_short v18, v75, s[12:15], 0 offen
  v_mul_f32_e32 v19, v51, v19
  v_fma_mix_f32 v19, s45, v77, v19 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v19
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v19, v4
  v_cvt_f16_f32_e32 v19, v19
  buffer_store_short v19, v78, s[12:15], 0 offen
  v_mul_f32_e32 v20, v56, v20
  v_fma_mix_f32 v20, s45, v80, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v20
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v20, v4
  v_cvt_f16_f32_e32 v20, v20
  buffer_store_short v20, v81, s[12:15], 0 offen
  v_mul_f32_e32 v21, v41, v21
  v_fma_mix_f32 v21, s45, v83, v21 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v21
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v21, v4
  v_cvt_f16_f32_e32 v21, v21
  buffer_store_short v21, v84, s[12:15], 0 offen
  v_mul_f32_e32 v22, v46, v22
  v_fma_mix_f32 v22, s45, v86, v22 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v22
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v22, v4
  v_cvt_f16_f32_e32 v22, v22
  buffer_store_short v22, v87, s[12:15], 0 offen
  v_mul_f32_e32 v23, v51, v23
  v_fma_mix_f32 v23, s45, v89, v23 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v23
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v23, v4
  v_cvt_f16_f32_e32 v23, v23
  buffer_store_short v23, v90, s[12:15], 0 offen
  v_mul_f32_e32 v24, v56, v24
  v_fma_mix_f32 v24, s45, v92, v24 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v24
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v24, v4
  v_cvt_f16_f32_e32 v24, v24
  buffer_store_short v24, v93, s[12:15], 0 offen
  v_mul_f32_e32 v25, v41, v25
  v_fma_mix_f32 v25, s45, v95, v25 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v25
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v25, v4
  v_cvt_f16_f32_e32 v25, v25
  buffer_store_short v25, v96, s[12:15], 0 offen
  v_mul_f32_e32 v26, v46, v26
  v_fma_mix_f32 v26, s45, v98, v26 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v26
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v26, v4
  v_cvt_f16_f32_e32 v26, v26
  buffer_store_short v26, v99, s[12:15], 0 offen
  v_mul_f32_e32 v27, v51, v27
  v_fma_mix_f32 v27, s45, v101, v27 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v27
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v27, v4
  v_cvt_f16_f32_e32 v27, v27
  buffer_store_short v27, v102, s[12:15], 0 offen
  v_mul_f32_e32 v28, v56, v28
  v_fma_mix_f32 v28, s45, v104, v28 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v28
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v28, v4
  v_cvt_f16_f32_e32 v28, v28
  buffer_store_short v28, v105, s[12:15], 0 offen
  v_mul_f32_e32 v29, v41, v29
  v_fma_mix_f32 v29, s45, v107, v29 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v29
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v29, v4
  v_cvt_f16_f32_e32 v29, v29
  buffer_store_short v29, v108, s[12:15], 0 offen
  v_mul_f32_e32 v30, v46, v30
  v_fma_mix_f32 v30, s45, v110, v30 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v30
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v30, v4
  v_cvt_f16_f32_e32 v30, v30
  buffer_store_short v30, v111, s[12:15], 0 offen
  v_mul_f32_e32 v31, v51, v31
  v_fma_mix_f32 v31, s45, v113, v31 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v31
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v31, v4
  v_cvt_f16_f32_e32 v31, v31
  buffer_store_short v31, v114, s[12:15], 0 offen
  v_mul_f32_e32 v32, v56, v32
  v_fma_mix_f32 v32, s45, v116, v32 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v32
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v32, v4
  v_cvt_f16_f32_e32 v32, v32
  buffer_store_short v32, v117, s[12:15], 0 offen
  v_mul_f32_e32 v33, v41, v33
  v_fma_mix_f32 v33, s45, v119, v33 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v33
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v33, v4
  v_cvt_f16_f32_e32 v33, v33
  buffer_store_short v33, v120, s[12:15], 0 offen
  v_mul_f32_e32 v34, v46, v34
  v_fma_mix_f32 v34, s45, v122, v34 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v34
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v34, v4
  v_cvt_f16_f32_e32 v34, v34
  buffer_store_short v34, v123, s[12:15], 0 offen
  v_mul_f32_e32 v35, v51, v35
  v_fma_mix_f32 v35, s45, v126, v35 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v35
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v35, v4
  v_cvt_f16_f32_e32 v35, v35
  buffer_store_short v35, v127, s[12:15], 0 offen
  v_mul_f32_e32 v36, v56, v36
  v_fma_mix_f32 v36, s45, v129, v36 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v36
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v36, v4
  v_cvt_f16_f32_e32 v36, v36
  buffer_store_short v36, v130, s[12:15], 0 offen
  v_mul_f32_e32 v37, v41, v37
  v_fma_mix_f32 v37, s45, v132, v37 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v37
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v37, v4
  v_cvt_f16_f32_e32 v37, v37
  buffer_store_short v37, v133, s[12:15], 0 offen
  v_mul_f32_e32 v38, v46, v38
  v_fma_mix_f32 v38, s45, v135, v38 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v38
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v38, v4
  v_cvt_f16_f32_e32 v38, v38
  buffer_store_short v38, v136, s[12:15], 0 offen
  s_nop 0
  v_mov_b32_e32 v8, 0x80000000
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v42, v2, v4, 1
  v_cndmask_b32_e64 v42, v8, v42, s[78:79]
  buffer_load_short_d16 v39, v42, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v43, v4, s74
  v_lshlrev_b32_e32 v43, 2, v43
  ds_read_b32 v40, v43
  ds_read_b32 v41, v43 offset:1024
  v_add_lshl_u32 v42, v3, v4, 1
  v_cndmask_b32_e64 v42, v8, v42, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v47, v2, v4, 1
  v_cndmask_b32_e64 v47, v8, v47, s[78:79]
  buffer_load_short_d16_hi v44, v47, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v48, v4, s74
  v_lshlrev_b32_e32 v48, 2, v48
  ds_read_b32 v45, v48
  ds_read_b32 v46, v48 offset:1024
  v_add_lshl_u32 v47, v3, v4, 1
  v_cndmask_b32_e64 v47, v8, v47, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v52, v2, v0, 1
  v_cndmask_b32_e64 v52, v8, v52, s[78:79]
  buffer_load_short_d16 v49, v52, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v53, v0, s74
  v_lshlrev_b32_e32 v53, 2, v53
  ds_read_b32 v50, v53
  ds_read_b32 v51, v53 offset:1024
  v_add_lshl_u32 v52, v3, v0, 1
  v_cndmask_b32_e64 v52, v8, v52, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v57, v2, v4, 1
  v_cndmask_b32_e64 v57, v8, v57, s[78:79]
  buffer_load_short_d16_hi v54, v57, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v58, v4, s74
  v_lshlrev_b32_e32 v58, 2, v58
  ds_read_b32 v55, v58
  ds_read_b32 v56, v58 offset:1024
  v_add_lshl_u32 v57, v3, v4, 1
  v_cndmask_b32_e64 v57, v8, v57, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v60, v2, v4, 1
  v_cndmask_b32_e64 v60, v8, v60, s[78:79]
  buffer_load_short_d16 v59, v60, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v61, v4, s74
  v_lshlrev_b32_e32 v61, 2, v61
  v_add_lshl_u32 v60, v3, v4, 1
  v_cndmask_b32_e64 v60, v8, v60, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v63, v2, v4, 1
  v_cndmask_b32_e64 v63, v8, v63, s[78:79]
  buffer_load_short_d16_hi v62, v63, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v64, v4, s74
  v_lshlrev_b32_e32 v64, 2, v64
  v_add_lshl_u32 v63, v3, v4, 1
  v_cndmask_b32_e64 v63, v8, v63, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v66, v2, v0, 1
  v_cndmask_b32_e64 v66, v8, v66, s[78:79]
  buffer_load_short_d16 v65, v66, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v67, v0, s74
  v_lshlrev_b32_e32 v67, 2, v67
  v_add_lshl_u32 v66, v3, v0, 1
  v_cndmask_b32_e64 v66, v8, v66, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v69, v2, v4, 1
  v_cndmask_b32_e64 v69, v8, v69, s[78:79]
  buffer_load_short_d16_hi v68, v69, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v70, v4, s74
  v_lshlrev_b32_e32 v70, 2, v70
  v_add_lshl_u32 v69, v3, v4, 1
  v_cndmask_b32_e64 v69, v8, v69, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v72, v2, v4, 1
  v_cndmask_b32_e64 v72, v8, v72, s[78:79]
  buffer_load_short_d16 v71, v72, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v73, v4, s74
  v_lshlrev_b32_e32 v73, 2, v73
  v_add_lshl_u32 v72, v3, v4, 1
  v_cndmask_b32_e64 v72, v8, v72, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v75, v2, v4, 1
  v_cndmask_b32_e64 v75, v8, v75, s[78:79]
  buffer_load_short_d16_hi v74, v75, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v76, v4, s74
  v_lshlrev_b32_e32 v76, 2, v76
  v_add_lshl_u32 v75, v3, v4, 1
  v_cndmask_b32_e64 v75, v8, v75, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v78, v2, v0, 1
  v_cndmask_b32_e64 v78, v8, v78, s[78:79]
  buffer_load_short_d16 v77, v78, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v79, v0, s74
  v_lshlrev_b32_e32 v79, 2, v79
  v_add_lshl_u32 v78, v3, v0, 1
  v_cndmask_b32_e64 v78, v8, v78, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v81, v2, v4, 1
  v_cndmask_b32_e64 v81, v8, v81, s[78:79]
  buffer_load_short_d16_hi v80, v81, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v82, v4, s74
  v_lshlrev_b32_e32 v82, 2, v82
  v_add_lshl_u32 v81, v3, v4, 1
  v_cndmask_b32_e64 v81, v8, v81, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v84, v2, v4, 1
  v_cndmask_b32_e64 v84, v8, v84, s[78:79]
  buffer_load_short_d16 v83, v84, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v85, v4, s74
  v_lshlrev_b32_e32 v85, 2, v85
  v_add_lshl_u32 v84, v3, v4, 1
  v_cndmask_b32_e64 v84, v8, v84, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v87, v2, v4, 1
  v_cndmask_b32_e64 v87, v8, v87, s[78:79]
  buffer_load_short_d16_hi v86, v87, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v88, v4, s74
  v_lshlrev_b32_e32 v88, 2, v88
  v_add_lshl_u32 v87, v3, v4, 1
  v_cndmask_b32_e64 v87, v8, v87, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v90, v2, v0, 1
  v_cndmask_b32_e64 v90, v8, v90, s[78:79]
  buffer_load_short_d16 v89, v90, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v91, v0, s74
  v_lshlrev_b32_e32 v91, 2, v91
  v_add_lshl_u32 v90, v3, v0, 1
  v_cndmask_b32_e64 v90, v8, v90, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v93, v2, v4, 1
  v_cndmask_b32_e64 v93, v8, v93, s[78:79]
  buffer_load_short_d16_hi v92, v93, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v94, v4, s74
  v_lshlrev_b32_e32 v94, 2, v94
  v_add_lshl_u32 v93, v3, v4, 1
  v_cndmask_b32_e64 v93, v8, v93, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v96, v2, v4, 1
  v_cndmask_b32_e64 v96, v8, v96, s[78:79]
  buffer_load_short_d16 v95, v96, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v97, v4, s74
  v_lshlrev_b32_e32 v97, 2, v97
  v_add_lshl_u32 v96, v3, v4, 1
  v_cndmask_b32_e64 v96, v8, v96, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v99, v2, v4, 1
  v_cndmask_b32_e64 v99, v8, v99, s[78:79]
  buffer_load_short_d16_hi v98, v99, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v100, v4, s74
  v_lshlrev_b32_e32 v100, 2, v100
  v_add_lshl_u32 v99, v3, v4, 1
  v_cndmask_b32_e64 v99, v8, v99, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v102, v2, v0, 1
  v_cndmask_b32_e64 v102, v8, v102, s[78:79]
  buffer_load_short_d16 v101, v102, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v103, v0, s74
  v_lshlrev_b32_e32 v103, 2, v103
  v_add_lshl_u32 v102, v3, v0, 1
  v_cndmask_b32_e64 v102, v8, v102, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v105, v2, v4, 1
  v_cndmask_b32_e64 v105, v8, v105, s[78:79]
  buffer_load_short_d16_hi v104, v105, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v106, v4, s74
  v_lshlrev_b32_e32 v106, 2, v106
  v_add_lshl_u32 v105, v3, v4, 1
  v_cndmask_b32_e64 v105, v8, v105, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v108, v2, v4, 1
  v_cndmask_b32_e64 v108, v8, v108, s[78:79]
  buffer_load_short_d16 v107, v108, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v109, v4, s74
  v_lshlrev_b32_e32 v109, 2, v109
  v_add_lshl_u32 v108, v3, v4, 1
  v_cndmask_b32_e64 v108, v8, v108, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v111, v2, v4, 1
  v_cndmask_b32_e64 v111, v8, v111, s[78:79]
  buffer_load_short_d16_hi v110, v111, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v112, v4, s74
  v_lshlrev_b32_e32 v112, 2, v112
  v_add_lshl_u32 v111, v3, v4, 1
  v_cndmask_b32_e64 v111, v8, v111, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v114, v2, v0, 1
  v_cndmask_b32_e64 v114, v8, v114, s[78:79]
  buffer_load_short_d16 v113, v114, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v115, v0, s74
  v_lshlrev_b32_e32 v115, 2, v115
  v_add_lshl_u32 v114, v3, v0, 1
  v_cndmask_b32_e64 v114, v8, v114, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v117, v2, v4, 1
  v_cndmask_b32_e64 v117, v8, v117, s[78:79]
  buffer_load_short_d16_hi v116, v117, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v118, v4, s74
  v_lshlrev_b32_e32 v118, 2, v118
  v_add_lshl_u32 v117, v3, v4, 1
  v_cndmask_b32_e64 v117, v8, v117, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v120, v2, v4, 1
  v_cndmask_b32_e64 v120, v8, v120, s[78:79]
  buffer_load_short_d16 v119, v120, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v121, v4, s74
  v_lshlrev_b32_e32 v121, 2, v121
  v_add_lshl_u32 v120, v3, v4, 1
  v_cndmask_b32_e64 v120, v8, v120, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v123, v2, v4, 1
  v_cndmask_b32_e64 v123, v8, v123, s[78:79]
  buffer_load_short_d16_hi v122, v123, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v125, v4, s74
  v_lshlrev_b32_e32 v125, 2, v125
  v_add_lshl_u32 v123, v3, v4, 1
  v_cndmask_b32_e64 v123, v8, v123, s[78:79]
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v127, v2, v0, 1
  v_cndmask_b32_e64 v127, v8, v127, s[78:79]
  buffer_load_short_d16 v126, v127, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v128, v0, s74
  v_lshlrev_b32_e32 v128, 2, v128
  v_add_lshl_u32 v127, v3, v0, 1
  v_cndmask_b32_e64 v127, v8, v127, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v130, v2, v4, 1
  v_cndmask_b32_e64 v130, v8, v130, s[78:79]
  buffer_load_short_d16_hi v129, v130, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v131, v4, s74
  v_lshlrev_b32_e32 v131, 2, v131
  v_add_lshl_u32 v130, v3, v4, 1
  v_cndmask_b32_e64 v130, v8, v130, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v133, v2, v4, 1
  v_cndmask_b32_e64 v133, v8, v133, s[78:79]
  buffer_load_short_d16 v132, v133, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v134, v4, s74
  v_lshlrev_b32_e32 v134, 2, v134
  v_add_lshl_u32 v133, v3, v4, 1
  v_cndmask_b32_e64 v133, v8, v133, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v136, v2, v4, 1
  v_cndmask_b32_e64 v136, v8, v136, s[78:79]
  buffer_load_short_d16_hi v135, v136, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v137, v4, s74
  v_lshlrev_b32_e32 v137, 2, v137
  v_add_lshl_u32 v136, v3, v4, 1
  v_cndmask_b32_e64 v136, v8, v136, s[78:79]
  v_accvgpr_read_b32 v9, a57
  v_accvgpr_read_b32 v10, a61
  v_accvgpr_read_b32 v11, a2
  v_accvgpr_read_b32 v12, a6
  v_accvgpr_read_b32 v13, a10
  v_accvgpr_read_b32 v14, a14
  v_accvgpr_read_b32 v15, a18
  v_accvgpr_read_b32 v16, a22
  v_accvgpr_read_b32 v17, a26
  v_accvgpr_read_b32 v18, a30
  v_accvgpr_read_b32 v19, a34
  v_accvgpr_read_b32 v20, a38
  v_accvgpr_read_b32 v21, a42
  v_accvgpr_read_b32 v22, a46
  v_accvgpr_read_b32 v23, a50
  v_accvgpr_read_b32 v24, a54
  v_accvgpr_read_b32 v25, a58
  v_accvgpr_read_b32 v26, a62
  v_accvgpr_read_b32 v27, a3
  v_accvgpr_read_b32 v28, a7
  v_accvgpr_read_b32 v29, a11
  v_accvgpr_read_b32 v30, a15
  v_accvgpr_read_b32 v31, a19
  v_accvgpr_read_b32 v32, a23
  v_accvgpr_read_b32 v33, a27
  v_accvgpr_read_b32 v34, a31
  v_accvgpr_read_b32 v35, a35
  v_accvgpr_read_b32 v36, a39
  v_accvgpr_read_b32 v37, a43
  v_accvgpr_read_b32 v38, a47
  v_mul_f32_e32 v9, s44, v9
  v_pk_mul_f32 v[10:11], s[44:45], v[10:11] op_sel_hi:[0,1]
  v_pk_mul_f32 v[12:13], s[44:45], v[12:13] op_sel_hi:[0,1]
  v_pk_mul_f32 v[14:15], s[44:45], v[14:15] op_sel_hi:[0,1]
  v_pk_mul_f32 v[16:17], s[44:45], v[16:17] op_sel_hi:[0,1]
  v_pk_mul_f32 v[18:19], s[44:45], v[18:19] op_sel_hi:[0,1]
  v_pk_mul_f32 v[20:21], s[44:45], v[20:21] op_sel_hi:[0,1]
  v_pk_mul_f32 v[22:23], s[44:45], v[22:23] op_sel_hi:[0,1]
  v_pk_mul_f32 v[24:25], s[44:45], v[24:25] op_sel_hi:[0,1]
  v_pk_mul_f32 v[26:27], s[44:45], v[26:27] op_sel_hi:[0,1]
  v_pk_mul_f32 v[28:29], s[44:45], v[28:29] op_sel_hi:[0,1]
  v_pk_mul_f32 v[30:31], s[44:45], v[30:31] op_sel_hi:[0,1]
  v_pk_mul_f32 v[32:33], s[44:45], v[32:33] op_sel_hi:[0,1]
  v_pk_mul_f32 v[34:35], s[44:45], v[34:35] op_sel_hi:[0,1]
  v_pk_mul_f32 v[36:37], s[44:45], v[36:37] op_sel_hi:[0,1]
  v_mul_f32_e32 v38, s44, v38
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_mul_f32_e32 v9, v41, v9
  v_fma_mix_f32 v9, s45, v39, v9 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v9
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v9, v4
  v_cvt_f16_f32_e32 v9, v9
  buffer_store_short v9, v42, s[12:15], 0 offen
  v_mul_f32_e32 v10, v46, v10
  v_fma_mix_f32 v10, s45, v44, v10 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v10
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v10, v4
  v_cvt_f16_f32_e32 v10, v10
  buffer_store_short v10, v47, s[12:15], 0 offen
  v_mul_f32_e32 v11, v51, v11
  v_fma_mix_f32 v11, s45, v49, v11 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v11
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v11, v4
  v_cvt_f16_f32_e32 v11, v11
  buffer_store_short v11, v52, s[12:15], 0 offen
  v_mul_f32_e32 v12, v56, v12
  v_fma_mix_f32 v12, s45, v54, v12 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v12
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v12, v4
  v_cvt_f16_f32_e32 v12, v12
  buffer_store_short v12, v57, s[12:15], 0 offen
  v_mul_f32_e32 v13, v41, v13
  v_fma_mix_f32 v13, s45, v59, v13 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v13
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v13, v4
  v_cvt_f16_f32_e32 v13, v13
  buffer_store_short v13, v60, s[12:15], 0 offen
  v_mul_f32_e32 v14, v46, v14
  v_fma_mix_f32 v14, s45, v62, v14 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v14
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v14, v4
  v_cvt_f16_f32_e32 v14, v14
  buffer_store_short v14, v63, s[12:15], 0 offen
  v_mul_f32_e32 v15, v51, v15
  v_fma_mix_f32 v15, s45, v65, v15 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v15
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v15, v4
  v_cvt_f16_f32_e32 v15, v15
  buffer_store_short v15, v66, s[12:15], 0 offen
  v_mul_f32_e32 v16, v56, v16
  v_fma_mix_f32 v16, s45, v68, v16 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v16
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v16, v4
  v_cvt_f16_f32_e32 v16, v16
  buffer_store_short v16, v69, s[12:15], 0 offen
  v_mul_f32_e32 v17, v41, v17
  v_fma_mix_f32 v17, s45, v71, v17 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v17
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v17, v4
  v_cvt_f16_f32_e32 v17, v17
  buffer_store_short v17, v72, s[12:15], 0 offen
  v_mul_f32_e32 v18, v46, v18
  v_fma_mix_f32 v18, s45, v74, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v18
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v18, v4
  v_cvt_f16_f32_e32 v18, v18
  buffer_store_short v18, v75, s[12:15], 0 offen
  v_mul_f32_e32 v19, v51, v19
  v_fma_mix_f32 v19, s45, v77, v19 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v19
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v19, v4
  v_cvt_f16_f32_e32 v19, v19
  buffer_store_short v19, v78, s[12:15], 0 offen
  v_mul_f32_e32 v20, v56, v20
  v_fma_mix_f32 v20, s45, v80, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v20
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v20, v4
  v_cvt_f16_f32_e32 v20, v20
  buffer_store_short v20, v81, s[12:15], 0 offen
  v_mul_f32_e32 v21, v41, v21
  v_fma_mix_f32 v21, s45, v83, v21 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v21
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v21, v4
  v_cvt_f16_f32_e32 v21, v21
  buffer_store_short v21, v84, s[12:15], 0 offen
  v_mul_f32_e32 v22, v46, v22
  v_fma_mix_f32 v22, s45, v86, v22 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v22
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v22, v4
  v_cvt_f16_f32_e32 v22, v22
  buffer_store_short v22, v87, s[12:15], 0 offen
  v_mul_f32_e32 v23, v51, v23
  v_fma_mix_f32 v23, s45, v89, v23 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v23
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v23, v4
  v_cvt_f16_f32_e32 v23, v23
  buffer_store_short v23, v90, s[12:15], 0 offen
  v_mul_f32_e32 v24, v56, v24
  v_fma_mix_f32 v24, s45, v92, v24 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v24
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v24, v4
  v_cvt_f16_f32_e32 v24, v24
  buffer_store_short v24, v93, s[12:15], 0 offen
  v_mul_f32_e32 v25, v41, v25
  v_fma_mix_f32 v25, s45, v95, v25 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v25
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v25, v4
  v_cvt_f16_f32_e32 v25, v25
  buffer_store_short v25, v96, s[12:15], 0 offen
  v_mul_f32_e32 v26, v46, v26
  v_fma_mix_f32 v26, s45, v98, v26 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v26
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v26, v4
  v_cvt_f16_f32_e32 v26, v26
  buffer_store_short v26, v99, s[12:15], 0 offen
  v_mul_f32_e32 v27, v51, v27
  v_fma_mix_f32 v27, s45, v101, v27 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v27
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v27, v4
  v_cvt_f16_f32_e32 v27, v27
  buffer_store_short v27, v102, s[12:15], 0 offen
  v_mul_f32_e32 v28, v56, v28
  v_fma_mix_f32 v28, s45, v104, v28 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v28
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v28, v4
  v_cvt_f16_f32_e32 v28, v28
  buffer_store_short v28, v105, s[12:15], 0 offen
  v_mul_f32_e32 v29, v41, v29
  v_fma_mix_f32 v29, s45, v107, v29 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v29
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v29, v4
  v_cvt_f16_f32_e32 v29, v29
  buffer_store_short v29, v108, s[12:15], 0 offen
  v_mul_f32_e32 v30, v46, v30
  v_fma_mix_f32 v30, s45, v110, v30 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v30
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v30, v4
  v_cvt_f16_f32_e32 v30, v30
  buffer_store_short v30, v111, s[12:15], 0 offen
  v_mul_f32_e32 v31, v51, v31
  v_fma_mix_f32 v31, s45, v113, v31 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v31
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v31, v4
  v_cvt_f16_f32_e32 v31, v31
  buffer_store_short v31, v114, s[12:15], 0 offen
  v_mul_f32_e32 v32, v56, v32
  v_fma_mix_f32 v32, s45, v116, v32 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v32
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v32, v4
  v_cvt_f16_f32_e32 v32, v32
  buffer_store_short v32, v117, s[12:15], 0 offen
  v_mul_f32_e32 v33, v41, v33
  v_fma_mix_f32 v33, s45, v119, v33 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v33
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v33, v4
  v_cvt_f16_f32_e32 v33, v33
  buffer_store_short v33, v120, s[12:15], 0 offen
  v_mul_f32_e32 v34, v46, v34
  v_fma_mix_f32 v34, s45, v122, v34 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v34
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v34, v4
  v_cvt_f16_f32_e32 v34, v34
  buffer_store_short v34, v123, s[12:15], 0 offen
  v_mul_f32_e32 v35, v51, v35
  v_fma_mix_f32 v35, s45, v126, v35 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v50, v35
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v35, v4
  v_cvt_f16_f32_e32 v35, v35
  buffer_store_short v35, v127, s[12:15], 0 offen
  v_mul_f32_e32 v36, v56, v36
  v_fma_mix_f32 v36, s45, v129, v36 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v55, v36
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v36, v4
  v_cvt_f16_f32_e32 v36, v36
  buffer_store_short v36, v130, s[12:15], 0 offen
  v_mul_f32_e32 v37, v41, v37
  v_fma_mix_f32 v37, s45, v132, v37 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v40, v37
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v37, v4
  v_cvt_f16_f32_e32 v37, v37
  buffer_store_short v37, v133, s[12:15], 0 offen
  v_mul_f32_e32 v38, v46, v38
  v_fma_mix_f32 v38, s45, v135, v38 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v45, v38
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v38, v4
  v_cvt_f16_f32_e32 v38, v38
  buffer_store_short v38, v136, s[12:15], 0 offen
  s_nop 0
  v_mov_b32_e32 v8, 0x80000000
  v_add_co_u32_e64 v1, vcc, v1, 1
  v_add_u32_e64 v2, v2, s38
  v_add_u32_e64 v3, v3, s36
  v_cmp_lt_u32_e64 s[74:75], v0, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v16, v2, v0, 1
  v_cndmask_b32_e64 v16, v8, v16, s[78:79]
  buffer_load_short_d16 v13, v16, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v17, v0, s74
  v_lshlrev_b32_e32 v17, 2, v17
  ds_read_b32 v14, v17
  ds_read_b32 v15, v17 offset:1024
  v_add_lshl_u32 v16, v3, v0, 1
  v_cndmask_b32_e64 v16, v8, v16, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 1
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v21, v2, v4, 1
  v_cndmask_b32_e64 v21, v8, v21, s[78:79]
  buffer_load_short_d16_hi v18, v21, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v22, v4, s74
  v_lshlrev_b32_e32 v22, 2, v22
  ds_read_b32 v19, v22
  ds_read_b32 v20, v22 offset:1024
  v_add_lshl_u32 v21, v3, v4, 1
  v_cndmask_b32_e64 v21, v8, v21, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 2
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v26, v2, v4, 1
  v_cndmask_b32_e64 v26, v8, v26, s[78:79]
  buffer_load_short_d16 v23, v26, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v27, v4, s74
  v_lshlrev_b32_e32 v27, 2, v27
  ds_read_b32 v24, v27
  ds_read_b32 v25, v27 offset:1024
  v_add_lshl_u32 v26, v3, v4, 1
  v_cndmask_b32_e64 v26, v8, v26, s[78:79]
  v_add_co_u32_e64 v4, vcc, v0, 3
  v_cmp_lt_u32_e64 s[74:75], v4, s20
  v_cmp_lt_u32_e64 s[78:79], v1, s21
  s_and_b64 s[78:79], s[74:75], s[78:79]
  v_add_lshl_u32 v31, v2, v4, 1
  v_cndmask_b32_e64 v31, v8, v31, s[78:79]
  buffer_load_short_d16_hi v28, v31, s[16:19], 0 offen
  s_mul_i32 s74, 0x80, s2
  v_sub_u32_e64 v32, v4, s74
  v_lshlrev_b32_e32 v32, 2, v32
  ds_read_b32 v29, v32
  ds_read_b32 v30, v32 offset:1024
  v_add_lshl_u32 v31, v3, v4, 1
  v_cndmask_b32_e64 v31, v8, v31, s[78:79]
  v_accvgpr_read_b32 v9, a51
  v_accvgpr_read_b32 v10, a55
  v_accvgpr_read_b32 v11, a59
  v_accvgpr_read_b32 v12, a63
  v_mul_f32_e32 v9, s44, v9
  v_pk_mul_f32 v[10:11], s[44:45], v[10:11] op_sel_hi:[0,1]
  v_mul_f32_e32 v12, s44, v12
  s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
  v_mul_f32_e32 v9, v15, v9
  v_fma_mix_f32 v9, s45, v13, v9 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v14, v9
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v9, v4
  v_cvt_f16_f32_e32 v9, v9
  buffer_store_short v9, v16, s[12:15], 0 offen
  v_mul_f32_e32 v10, v20, v10
  v_fma_mix_f32 v10, s45, v18, v10 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v19, v10
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v10, v4
  v_cvt_f16_f32_e32 v10, v10
  buffer_store_short v10, v21, s[12:15], 0 offen
  v_mul_f32_e32 v11, v25, v11
  v_fma_mix_f32 v11, s45, v23, v11 op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v24, v11
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v11, v4
  v_cvt_f16_f32_e32 v11, v11
  buffer_store_short v11, v26, s[12:15], 0 offen
  v_mul_f32_e32 v12, v30, v12
  v_fma_mix_f32 v12, s45, v28, v12 op_sel:[0,1,0] op_sel_hi:[0,1,0]
  v_add_f32_e32 v4, v29, v12
  s_swappc_b64 s[58:59], s[8:9]
  v_mov_b32_e32 v12, v4
  v_cvt_f16_f32_e32 v12, v12
  buffer_store_short v12, v31, s[12:15], 0 offen
  s_nop 0
  s_branch label_GW_End_1
label_Activation_None_VW4:
  s_setpc_b64 s[58:59]
label_Activation_Gelu_VW4:
  v_mul_f32_e32 v8, 0x3d372713, v4
  v_fma_f32 v8, v4, v8, 1.0
  v_mul_f32_e32 v8, v4, v8
  v_mul_f32_e32 v8, 0x40135761, v8
  v_exp_f32_e32 v8, v8
  s_nop 0
  v_add_f32_e32 v8, 1.0, v8
  v_rcp_f32_e32 v8, v8
  s_nop 0
  v_fma_f32 v8, -2.0, v8, 2.0
  v_mul_f32_e32 v8, v4, v8
  v_mul_f32_e32 v4, 0.5, v8
  v_mul_f32_e32 v8, 0x3d372713, v5
  v_fma_f32 v8, v5, v8, 1.0
  v_mul_f32_e32 v8, v5, v8
  v_mul_f32_e32 v8, 0x40135761, v8
  v_exp_f32_e32 v8, v8
  s_nop 0
  v_add_f32_e32 v8, 1.0, v8
  v_rcp_f32_e32 v8, v8
  s_nop 0
  v_fma_f32 v8, -2.0, v8, 2.0
  v_mul_f32_e32 v8, v5, v8
  v_mul_f32_e32 v5, 0.5, v8
  v_mul_f32_e32 v8, 0x3d372713, v6
  v_fma_f32 v8, v6, v8, 1.0
  v_mul_f32_e32 v8, v6, v8
  v_mul_f32_e32 v8, 0x40135761, v8
  v_exp_f32_e32 v8, v8
  s_nop 0
  v_add_f32_e32 v8, 1.0, v8
  v_rcp_f32_e32 v8, v8
  s_nop 0
  v_fma_f32 v8, -2.0, v8, 2.0
  v_mul_f32_e32 v8, v6, v8
  v_mul_f32_e32 v6, 0.5, v8
  v_mul_f32_e32 v8, 0x3d372713, v7
  v_fma_f32 v8, v7, v8, 1.0
  v_mul_f32_e32 v8, v7, v8
  v_mul_f32_e32 v8, 0x40135761, v8
  v_exp_f32_e32 v8, v8
  s_nop 0
  v_add_f32_e32 v8, 1.0, v8
  v_rcp_f32_e32 v8, v8
  s_nop 0
  v_fma_f32 v8, -2.0, v8, 2.0
  v_mul_f32_e32 v8, v7, v8
  v_mul_f32_e32 v7, 0.5, v8
  s_setpc_b64 s[58:59]
label_Activation_Relu_VW4:
  v_max_f32_e64 v4, v4, 0
  v_max_f32_e64 v5, v5, 0
  v_max_f32_e64 v6, v6, 0
  v_max_f32_e64 v7, v7, 0
  s_setpc_b64 s[58:59]
label_Activation_Silu_VW4:
  v_mul_f32_e32 v8, 0xbfb8aa3b, v4
  v_exp_f32_e32 v8, v8
  s_nop 0
  v_add_f32_e32 v8, 1.0, v8
  v_rcp_f32_e32 v8, v8
  s_nop 0
  v_mul_f32_e32 v4, v4, v8
  v_mul_f32_e32 v8, 0xbfb8aa3b, v5
  v_exp_f32_e32 v8, v8
  s_nop 0
  v_add_f32_e32 v8, 1.0, v8
  v_rcp_f32_e32 v8, v8
  s_nop 0
  v_mul_f32_e32 v5, v5, v8
  v_mul_f32_e32 v8, 0xbfb8aa3b, v6
  v_exp_f32_e32 v8, v8
  s_nop 0
  v_add_f32_e32 v8, 1.0, v8
  v_rcp_f32_e32 v8, v8
  s_nop 0
  v_mul_f32_e32 v6, v6, v8
  v_mul_f32_e32 v8, 0xbfb8aa3b, v7
  v_exp_f32_e32 v8, v8
  s_nop 0
  v_add_f32_e32 v8, 1.0, v8
  v_rcp_f32_e32 v8, v8
  s_nop 0
  v_mul_f32_e32 v7, v7, v8
  s_setpc_b64 s[58:59]
label_Activation_Clamp_VW4:
  v_min_f32_e32 v4, s71, v4
  v_max_f32_e32 v4, s70, v4
  v_min_f32_e32 v5, s71, v5
  v_max_f32_e32 v5, s70, v5
  v_min_f32_e32 v6, s71, v6
  v_max_f32_e32 v6, s70, v6
  v_min_f32_e32 v7, s71, v7
  v_max_f32_e32 v7, s70, v7
  s_setpc_b64 s[58:59]
label_Activation_None_VW1:
  s_setpc_b64 s[58:59]
label_Activation_Gelu_VW1:
  v_mul_f32_e32 v8, 0x3d372713, v4
  v_fma_f32 v8, v4, v8, 1.0
  v_mul_f32_e32 v8, v4, v8
  v_mul_f32_e32 v8, 0x40135761, v8
  v_exp_f32_e32 v8, v8
  s_nop 0
  v_add_f32_e32 v8, 1.0, v8
  v_rcp_f32_e32 v8, v8
  s_nop 0
  v_fma_f32 v8, -2.0, v8, 2.0
  v_mul_f32_e32 v8, v4, v8
  v_mul_f32_e32 v4, 0.5, v8
  s_setpc_b64 s[58:59]
label_Activation_Relu_VW1:
  v_max_f32_e64 v4, v4, 0
  s_setpc_b64 s[58:59]
label_Activation_Silu_VW1:
  v_mul_f32_e32 v8, 0xbfb8aa3b, v4
  v_exp_f32_e32 v8, v8
  s_nop 0
  v_add_f32_e32 v8, 1.0, v8
  v_rcp_f32_e32 v8, v8
  s_nop 0
  v_mul_f32_e32 v4, v4, v8
  s_setpc_b64 s[58:59]
label_Activation_Clamp_VW1:
  v_min_f32_e32 v4, s71, v4
  v_max_f32_e32 v4, s70, v4
  s_setpc_b64 s[58:59]
label_SK_Partials_1:
label_GW_Partials_E0:
  s_mov_b64 s[60:61], s[32:33]
  s_mov_b32 s62, 0x80000000
  s_mov_b32 s63, 0x20000
  s_mul_i32 s8, 0x10000, s53
  s_add_u32 s60, s60, s8
  s_addc_u32 s61, s61, 0
  v_accvgpr_read_b32 v12, a0
  v_accvgpr_read_b32 v13, a4
  v_accvgpr_read_b32 v14, a8
  v_accvgpr_read_b32 v15, a12
  v_accvgpr_read_b32 v16, a16
  v_accvgpr_read_b32 v17, a20
  v_accvgpr_read_b32 v18, a24
  v_accvgpr_read_b32 v19, a28
  v_accvgpr_read_b32 v20, a32
  v_accvgpr_read_b32 v21, a36
  v_accvgpr_read_b32 v22, a40
  v_accvgpr_read_b32 v23, a44
  v_accvgpr_read_b32 v24, a48
  v_accvgpr_read_b32 v25, a52
  v_accvgpr_read_b32 v26, a56
  v_accvgpr_read_b32 v27, a60
  v_accvgpr_read_b32 v28, a1
  v_accvgpr_read_b32 v29, a5
  v_accvgpr_read_b32 v30, a9
  v_accvgpr_read_b32 v31, a13
  v_accvgpr_read_b32 v32, a17
  v_accvgpr_read_b32 v33, a21
  v_accvgpr_read_b32 v34, a25
  v_accvgpr_read_b32 v35, a29
  v_accvgpr_read_b32 v36, a33
  v_accvgpr_read_b32 v37, a37
  v_accvgpr_read_b32 v38, a41
  v_accvgpr_read_b32 v39, a45
  v_accvgpr_read_b32 v40, a49
  v_accvgpr_read_b32 v41, a53
  v_accvgpr_read_b32 v42, a57
  v_accvgpr_read_b32 v43, a61
  v_accvgpr_read_b32 v44, a2
  v_accvgpr_read_b32 v45, a6
  v_accvgpr_read_b32 v46, a10
  v_accvgpr_read_b32 v47, a14
  v_accvgpr_read_b32 v48, a18
  v_accvgpr_read_b32 v49, a22
  v_accvgpr_read_b32 v50, a26
  v_accvgpr_read_b32 v51, a30
  v_accvgpr_read_b32 v52, a34
  v_accvgpr_read_b32 v53, a38
  v_accvgpr_read_b32 v54, a42
  v_accvgpr_read_b32 v55, a46
  v_accvgpr_read_b32 v56, a50
  v_accvgpr_read_b32 v57, a54
  v_accvgpr_read_b32 v58, a58
  v_accvgpr_read_b32 v59, a62
  v_accvgpr_read_b32 v60, a3
  v_accvgpr_read_b32 v61, a7
  v_accvgpr_read_b32 v62, a11
  v_accvgpr_read_b32 v63, a15
  v_accvgpr_read_b32 v64, a19
  v_accvgpr_read_b32 v65, a23
  v_accvgpr_read_b32 v66, a27
  v_accvgpr_read_b32 v67, a31
  v_accvgpr_read_b32 v68, a35
  v_accvgpr_read_b32 v69, a39
  v_accvgpr_read_b32 v70, a43
  v_accvgpr_read_b32 v71, a47
  v_accvgpr_read_b32 v72, a51
  v_accvgpr_read_b32 v73, a55
  v_accvgpr_read_b32 v74, a59
  v_accvgpr_read_b32 v75, a63
  s_nop 1
  v_lshlrev_b32_e32 v9, 4, v124
  s_mov_b32 s8, 0
  buffer_store_dwordx4 v[12:15], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[16:19], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[20:23], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[24:27], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[28:31], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[32:35], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[36:39], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[40:43], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[44:47], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[48:51], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[52:55], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[56:59], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[60:63], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[64:67], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[68:71], v9, s[60:63], s8 offen sc0 sc1
  s_add_u32 s8, s8, 0x1000
  buffer_store_dwordx4 v[72:75], v9, s[60:63], s8 offen sc0 sc1
  s_nop 0
  s_waitcnt vmcnt(0)
  s_barrier
  s_lshl_b32 s8, s53, 2
  v_readfirstlane_b32 s58, v124
  s_cmp_eq_u32 s58, 0
  s_cbranch_scc0 label_SK_SkipFlagSet
  s_mov_b32 s58, 1
  s_store_dword s58, s[34:35], s8 glc
label_SK_SkipFlagSet:
  s_waitcnt lgkmcnt(0)
  s_branch label_GW_End_1
label_SK_CloseLoop:
label_GW_End_1:
  s_cmp_ge_u32 s54, s55
  s_cbranch_scc1 label_KernelEnd
  s_getpc_b64 s[74:75]
  s_add_i32 s76, 0xffff19d8, 4
  s_abs_i32 s76, s76
  s_sub_u32 s74, s74, s76
  s_subb_u32 s75, s75, 0
  s_setpc_b64 s[74:75]
label_KernelEnd:
end:
label_NoBranch_LMYADZ5IUPFIU87Z:
  s_endpgm

.section .rodata,"a",@progbits
.p2align 6, 0x0
.amdhsa_kernel gemm
  .amdhsa_group_segment_fixed_size 33792
  .amdhsa_private_segment_fixed_size 0
  .amdhsa_kernarg_size 148
  .amdhsa_next_free_vgpr 256
  .amdhsa_next_free_sgpr 96
  .amdhsa_system_sgpr_workgroup_id_x 1
  .amdhsa_system_sgpr_workgroup_id_y 1
  .amdhsa_system_sgpr_workgroup_id_z 1
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_user_sgpr_count 2
  .amdhsa_user_sgpr_kernarg_preload_length 0
  .amdhsa_user_sgpr_kernarg_preload_offset 0
  .amdhsa_accum_offset 192
  .amdhsa_uses_dynamic_stack 0
  .amdhsa_tg_split 0
.end_amdhsa_kernel

.amdgpu_metadata
---
amdhsa.kernels:
  - .name: gemm
    .symbol: gemm.kd
    .args:
      - .name: A
        .address_space: global
        .offset: 0
        .size: 8
        .value_kind: global_buffer
        .value_type: f16
      - .name: B
        .address_space: global
        .offset: 8
        .size: 8
        .value_kind: global_buffer
        .value_type: f16
      - .name: C
        .address_space: global
        .offset: 16
        .size: 8
        .value_kind: global_buffer
        .value_type: f16
      - .name: D
        .address_space: global
        .offset: 24
        .size: 8
        .value_kind: global_buffer
        .value_type: f16
      - .name: AddressWS
        .address_space: global
        .offset: 32
        .size: 8
        .value_kind: global_buffer
        .value_type: f32
      - .name: AddressFlags
        .address_space: global
        .offset: 40
        .size: 8
        .value_kind: global_buffer
        .value_type: f16
      - .name: Gemm_info
        .offset: 48
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: kernel_info0
        .offset: 52
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: kernel_info1
        .offset: 56
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: numWG
        .offset: 60
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: SizesFree0
        .offset: 64
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: SizesFree1
        .offset: 68
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: SizesFree2
        .offset: 72
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: SizesSum0
        .offset: 76
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: strideD0
        .offset: 80
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: strideD1
        .offset: 84
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: strideC0
        .offset: 88
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: strideC1
        .offset: 92
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: strideA0
        .offset: 96
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: strideA1
        .offset: 100
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: strideB0
        .offset: 104
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: strideB1
        .offset: 108
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: alpha
        .offset: 112
        .size: 4
        .value_kind: by_value
        .value_type: f32
      - .name: beta
        .offset: 116
        .size: 4
        .value_kind: by_value
        .value_type: f32
      - .name: ItersPerTile
        .offset: 120
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: MagicNumberItersPerTile
        .offset: 124
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: MagicShiftItersPerTile
        .offset: 128
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: TotalIters
        .offset: 132
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: SKItersPerWG
        .offset: 136
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: skGrid
        .offset: 140
        .size: 4
        .value_kind: by_value
        .value_type: u32
      - .name: skTiles
        .offset: 144
        .size: 4
        .value_kind: by_value
        .value_type: u32
    .group_segment_fixed_size: 33792
    .private_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 148
    .max_flat_workgroup_size: 256
    .sgpr_count: 0
    .sgpr_spill_count: 0
    .vgpr_count: 192
    .vgpr_spill_count: 0
    .wavefront_size: 64
amdhsa.version:
  - 1
  - 1
...
.end_amdgpu_metadata
