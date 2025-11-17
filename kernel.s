s_load_b128 s[0:3], s[0:1], 0x0                            // 000000001600: F4004000 F8000000
v_lshl_or_b32 v0, ttmp9, 1, v0                             // 000000001608: D6560000 04010275
s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000001610: BF870091
v_ashrrev_i32_e32 v1, 31, v0                               // 000000001614: 3402009F
v_lshlrev_b64_e32 v[0:1], 2, v[0:1]                        // 000000001618: 3E000082
s_wait_kmcnt 0x0                                           // 00000000161C: BFC70000
s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000001620: BF870111
v_add_co_u32 v2, vcc_lo, s2, v0                            // 000000001624: D7006A02 00020002
v_add_co_ci_u32_e32 v3, vcc_lo, s3, v1, vcc_lo             // 00000000162C: 40060203
v_add_co_u32 v0, vcc_lo, s0, v0                            // 000000001630: D7006A00 00020000
s_wait_alu 0xfffd                                          // 000000001638: BF88FFFD
v_add_co_ci_u32_e32 v1, vcc_lo, s1, v1, vcc_lo             // 00000000163C: 40020201
global_load_b32 v2, v[2:3], off                            // 000000001640: EE05007C 00000002 00000002
s_wait_loadcnt 0x0                                         // 00000000164C: BFC00000
v_add_f32_e32 v2, 1.0, v2                                  // 000000001650: 060404F2
global_store_b32 v[0:1], v2, off                           // 000000001654: EE06807C 01000000 00000000
s_nop 0                                                    // 000000001660: BF800000
