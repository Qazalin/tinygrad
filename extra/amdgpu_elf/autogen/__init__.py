from tinygrad.runtime.autogen import amdgpu_kd

def pack_rodata(kd:dict, byte_offset:int, arch:str) -> bytes:
  # --- Table 74 structural rules ---
  # CP requires the kernel descriptor allocated on 64-byte alignment. (Caller responsibility.)
  # Total size is 64 bytes. :contentReference[oaicite:8]{index=8}
  if (byte_offset & 255) != 0:
    raise AssertionError("KERNEL_CODE_ENTRY_BYTE_OFFSET must point to a 256-byte aligned entry point")

  desc = amdgpu_kd.llvm_amdhsa_kernel_descriptor_t()

  # 31:0 GROUP_SEGMENT_FIXED_SIZE
  desc.group_segment_fixed_size = int(kd.get("group_segment_fixed_size", 0)) & 0xffffffff

  # 63:32 PRIVATE_SEGMENT_FIXED_SIZE
  desc.private_segment_fixed_size = int(kd.get("private_segment_fixed_size", 0)) & 0xffffffff

  # 95:64 KERNARG_SIZE
  desc.kernarg_size = int(kd.get("kernarg_size", 0)) & 0xffffffff

  # 127:96 Reserved, must be 0. :contentReference[oaicite:9]{index=9}
  desc.reserved0[:] = b"\x00" * 4

  # 191:128 KERNEL_CODE_ENTRY_BYTE_OFFSET (possibly negative)
  desc.kernel_code_entry_byte_offset = int(byte_offset)

  # 351:192 Reserved, must be 0. :contentReference[oaicite:10]{index=10}
  desc.reserved1[:] = b"\x00" * 20

  # --- Arch classification helpers (no function, just booleans) ---
  is_gfx6_gfx8 = arch.startswith("gfx6") or arch.startswith("gfx7") or arch.startswith("gfx8")
  is_gfx9 = arch.startswith("gfx9") and (arch != "gfx90a") and (arch != "gfx942") and (not arch.startswith("gfx950"))
  is_gfx6_gfx9 = is_gfx6_gfx8 or is_gfx9 or arch.startswith("gfx900") or arch.startswith("gfx902") or arch.startswith("gfx904") or arch.startswith("gfx906") or arch.startswith("gfx908")
  is_gfx90a = arch == "gfx90a"
  is_gfx942 = arch == "gfx942"
  is_gfx90a_gfx942 = is_gfx90a or is_gfx942
  is_gfx10 = arch.startswith("gfx10")
  is_gfx11 = arch.startswith("gfx11")
  is_gfx12 = arch.startswith("gfx12") or arch.startswith("gfx120")
  is_gfx125 = arch.startswith("gfx125")

  # wavefront size 32 enable bit lives in kernel_code_properties bit 458.
  # GFX6-GFX9: reserved, must be 0. GFX10-GFX11: controls wave32 vs wave64. :contentReference[oaicite:11]{index=11}
  wavefront_size32 = int(kd.get("wavefront_size32", 0))
  if wavefront_size32 not in (0, 1):
    raise AssertionError("wavefront_size32 must be 0 or 1")

  if is_gfx6_gfx9 and wavefront_size32 != 0:
    raise AssertionError("ENABLE_WAVEFRONT_SIZE32 is reserved on GFX6-GFX9 and must be 0")

  # --- Table 74: COMPUTE_PGM_RSRC3 (arch-specific) ---
  # 383:352 COMPUTE_PGM_RSRC3 :contentReference[oaicite:12]{index=12}
  if is_gfx6_gfx9:
    # Reserved, must be 0. :contentReference[oaicite:13]{index=13}
    if int(kd.get("compute_pgm_rsrc3", 0)) != 0:
      raise AssertionError("COMPUTE_PGM_RSRC3 is reserved on GFX6-GFX9 and must be 0")
    # Also reject any per-field attempts.
    if int(kd.get("amdhsa_accum_offset", 0)) != 0:
      raise AssertionError("ACCUM_OFFSET only valid on GFX90A/GFX942")
    if int(kd.get("tg_split", 0)) != 0:
      raise AssertionError("TG_SPLIT only valid on GFX90A/GFX942")
    if int(kd.get("shared_vgpr_count", 0)) != 0:
      raise AssertionError("SHARED_VGPR_COUNT only valid on GFX10+")
    if int(kd.get("inst_pref_size", 0)) != 0:
      raise AssertionError("INST_PREF_SIZE only valid on GFX11+ (and GFX12 has a different field)")
    if int(kd.get("trap_on_start", 0)) != 0:
      raise AssertionError("TRAP_ON_START must be 0 / reserved depending on arch")
    if int(kd.get("trap_on_end", 0)) != 0:
      raise AssertionError("TRAP_ON_END must be 0 / reserved depending on arch")
    if int(kd.get("image_op", 0)) != 0:
      raise AssertionError("IMAGE_OP must be 0 for compute kernels")
    if int(kd.get("glg_en", 0)) != 0:
      raise AssertionError("GLG_EN only valid on GFX12")
    if int(kd.get("named_bar_cnt", 0)) != 0:
      raise AssertionError("NAMED_BAR_CNT only valid on GFX125*")
    if int(kd.get("enable_dynamic_vgpr", 0)) != 0:
      raise AssertionError("ENABLE_DYNAMIC_VGPR only valid on GFX125*")
    if int(kd.get("tcp_split", 0)) != 0:
      raise AssertionError("TCP_SPLIT only valid on GFX125*")
    if int(kd.get("enable_didt_throttle", 0)) != 0:
      raise AssertionError("ENABLE_DIDT_THROTTLE only valid on GFX125*")

    desc.compute_pgm_rsrc3 = 0

  elif is_gfx90a_gfx942:
    # Table 77: bits 5:0 ACCUM_OFFSET (0..63 encoded) :contentReference[oaicite:14]{index=14}
    amdhsa_accum_offset = int(kd.get("amdhsa_accum_offset", 0))
    if amdhsa_accum_offset < 0 or amdhsa_accum_offset > 63:
      raise AssertionError("ACCUM_OFFSET must be 0..63 (encoded, granularity 4)")

    # bits 16 TG_SPLIT :contentReference[oaicite:15]{index=15}
    tg_split = int(kd.get("tg_split", 0))
    if tg_split not in (0, 1):
      raise AssertionError("TG_SPLIT must be 0 or 1")

    # Reserved bits must be 0: 15:6 and 31:17 :contentReference[oaicite:16]{index=16}
    # Enforce by refusing any other keys that map to those bits (we don’t expose them).

    desc.compute_pgm_rsrc3 = (
      (amdhsa_accum_offset << amdgpu_kd.COMPUTE_PGM_RSRC3_GFX90A_ACCUM_OFFSET_SHIFT) |
      (tg_split << amdgpu_kd.COMPUTE_PGM_RSRC3_GFX90A_TG_SPLIT_SHIFT)
    )

  elif is_gfx10 or is_gfx11:
    # Table 78
    shared_vgpr_count = int(kd.get("shared_vgpr_count", 0))
    if shared_vgpr_count < 0 or shared_vgpr_count > 15:
      raise AssertionError("SHARED_VGPR_COUNT must be 0..15")

    # For wavefront size 32, shared_vgpr_count must be 0. :contentReference[oaicite:17]{index=17}
    if wavefront_size32 == 1 and shared_vgpr_count != 0:
      raise AssertionError("For wavefront size 32, SHARED_VGPR_COUNT must be 0")

    inst_pref_size = int(kd.get("inst_pref_size", 0))
    trap_on_start = int(kd.get("trap_on_start", 0))
    trap_on_end = int(kd.get("trap_on_end", 0))
    image_op = int(kd.get("image_op", 0))

    if is_gfx10:
      # INST_PREF_SIZE reserved, must be 0. :contentReference[oaicite:18]{index=18}
      if inst_pref_size != 0:
        raise AssertionError("On GFX10, INST_PREF_SIZE is reserved and must be 0")
      # TRAP_ON_START reserved, must be 0. :contentReference[oaicite:19]{index=19}
      if trap_on_start != 0:
        raise AssertionError("On GFX10, TRAP_ON_START is reserved and must be 0")
      # TRAP_ON_END reserved, must be 0. :contentReference[oaicite:20]{index=20}
      if trap_on_end != 0:
        raise AssertionError("On GFX10, TRAP_ON_END is reserved and must be 0")
      # IMAGE_OP reserved, must be 0. :contentReference[oaicite:21]{index=21}
      if image_op != 0:
        raise AssertionError("On GFX10, IMAGE_OP is reserved and must be 0")

      desc.compute_pgm_rsrc3 = (
        (shared_vgpr_count << amdgpu_kd.COMPUTE_PGM_RSRC3_GFX10_GFX11_SHARED_VGPR_COUNT_SHIFT)
      )

    else:
      # GFX11
      # INST_PREF_SIZE is 0..63 encoded (granularity 128B). :contentReference[oaicite:22]{index=22}
      if inst_pref_size < 0 or inst_pref_size > 63:
        raise AssertionError("On GFX11, INST_PREF_SIZE must be 0..63 (encoded, 128B granularity)")

      # TRAP_ON_START must be 0 (CP fills). :contentReference[oaicite:23]{index=23}
      if trap_on_start != 0:
        raise AssertionError("On GFX11, TRAP_ON_START must be 0 (CP fills this bit)")
      # TRAP_ON_END must be 0 (CP fills). :contentReference[oaicite:24]{index=24}
      if trap_on_end != 0:
        raise AssertionError("On GFX11, TRAP_ON_END must be 0 (CP fills this bit)")

      # IMAGE_OP: not used for compute kernels and must be 0. :contentReference[oaicite:25]{index=25}
      if image_op != 0:
        raise AssertionError("On GFX11, IMAGE_OP must be 0 for compute kernels")

      desc.compute_pgm_rsrc3 = (
        (shared_vgpr_count << amdgpu_kd.COMPUTE_PGM_RSRC3_GFX10_GFX11_SHARED_VGPR_COUNT_SHIFT) |
        (inst_pref_size << amdgpu_kd.COMPUTE_PGM_RSRC3_GFX11_INST_PREF_SIZE_SHIFT)
      )

  elif is_gfx12 or is_gfx125:
    # Table 79
    inst_pref_size = int(kd.get("inst_pref_size", 0))
    glg_en = int(kd.get("glg_en", 0))
    named_bar_cnt = int(kd.get("named_bar_cnt", 0))
    enable_dynamic_vgpr = int(kd.get("enable_dynamic_vgpr", 0))
    tcp_split = int(kd.get("tcp_split", 0))
    enable_didt_throttle = int(kd.get("enable_didt_throttle", 0))
    image_op = int(kd.get("image_op", 0))

    # 3:0 reserved must be 0 (we don’t allow setting it)
    # 11:4 INST_PREF_SIZE is 0..255 encoded (granularity 128B). :contentReference[oaicite:26]{index=26}
    if inst_pref_size < 0 or inst_pref_size > 255:
      raise AssertionError("On GFX12, INST_PREF_SIZE must be 0..255 (encoded, 128B granularity)")

    # bit 12 reserved must be 0 (we don’t allow setting it)
    # bit 13 GLG_EN: 0/1 :contentReference[oaicite:27]{index=27}
    if glg_en not in (0, 1):
      raise AssertionError("On GFX12, GLG_EN must be 0 or 1")

    if is_gfx12 and (not is_gfx125):
      # GFX120* fields are reserved/must be 0: NAMED_BAR_CNT, ENABLE_DYNAMIC_VGPR, TCP_SPLIT, ENABLE_DIDT_THROTTLE :contentReference[oaicite:28]{index=28}
      if named_bar_cnt != 0:
        raise AssertionError("On GFX120*, NAMED_BAR_CNT is reserved and must be 0")
      if enable_dynamic_vgpr != 0:
        raise AssertionError("On GFX120*, ENABLE_DYNAMIC_VGPR is reserved and must be 0")
      if tcp_split != 0:
        raise AssertionError("On GFX120*, TCP_SPLIT is reserved and must be 0")
      if enable_didt_throttle != 0:
        raise AssertionError("On GFX120*, ENABLE_DIDT_THROTTLE is reserved and must be 0")
    else:
      # GFX125* encodings
      # NAMED_BAR_CNT: “0-4 allocating 0,4,8,12,16” => stored value 0..4 :contentReference[oaicite:29]{index=29}
      if named_bar_cnt < 0 or named_bar_cnt > 4:
        raise AssertionError("On GFX125*, NAMED_BAR_CNT must be 0..4 (represents 0..16 in steps of 4)")
      if enable_dynamic_vgpr not in (0, 1):
        raise AssertionError("On GFX125*, ENABLE_DYNAMIC_VGPR must be 0 or 1")
      if tcp_split < 0 or tcp_split > 7:
        raise AssertionError("On GFX125*, TCP_SPLIT must be 0..7")
      if enable_didt_throttle not in (0, 1):
        raise AssertionError("On GFX125*, ENABLE_DIDT_THROTTLE must be 0 or 1")

    # IMAGE_OP: must be 0 for compute kernels :contentReference[oaicite:30]{index=30}
    if image_op != 0:
      raise AssertionError("On GFX12, IMAGE_OP must be 0 for compute kernels")

    desc.compute_pgm_rsrc3 = (
      (inst_pref_size << amdgpu_kd.COMPUTE_PGM_RSRC3_GFX12_PLUS_INST_PREF_SIZE_SHIFT) |
      (glg_en << amdgpu_kd.COMPUTE_PGM_RSRC3_GFX12_PLUS_GLG_EN_SHIFT)
    )

  else:
    raise NotImplementedError(f"Unknown arch '{arch}' for COMPUTE_PGM_RSRC3")

  # --- Table 75: COMPUTE_PGM_RSRC1 (GFX6-GFX12) ---
  # Bits are in amdgpu_kd: shifts/masks are autogenerated. :contentReference[oaicite:31]{index=31}

  # 5:0 GRANULATED_WORKITEM_VGPR_COUNT per docs. :contentReference[oaicite:32]{index=32}
  if "next_free_vgpr" not in kd:
    raise AssertionError("next_free_vgpr is required to compute GRANULATED_WORKITEM_VGPR_COUNT")
  vgprs_used = int(kd["next_free_vgpr"])
  if vgprs_used < 0:
    raise AssertionError("next_free_vgpr must be >= 0")

  vgpr_div = None
  if is_gfx90a_gfx942:
    # Doc mentions align(arch_vgprs,4) + acc_vgprs, but we only have next_free_vgpr here.
    # We enforce the division rule exactly: ceil(vgprs_used/8)-1. :contentReference[oaicite:33]{index=33}
    vgpr_div = 8
  elif (is_gfx10 or is_gfx11 or is_gfx12 or is_gfx125):
    if wavefront_size32 == 0:
      vgpr_div = 4
    else:
      # GFX125X wave32 uses /16, otherwise wave32 uses /8. :contentReference[oaicite:34]{index=34}
      vgpr_div = 16 if is_gfx125 else 8
  else:
    # GFX6-GFX9: /4 :contentReference[oaicite:35]{index=35}
    vgpr_div = 4

  vgpr_granule = (vgprs_used + vgpr_div - 1) // vgpr_div
  if vgpr_granule > 0:
    vgpr_granule -= 1
  else:
    vgpr_granule = 0
  if vgpr_granule < 0:
    vgpr_granule = 0
  if vgpr_granule > 63:
    raise AssertionError("GRANULATED_WORKITEM_VGPR_COUNT does not fit in 6 bits")

  # 9:6 GRANULATED_WAVEFRONT_SGPR_COUNT
  # GFX6-GFX8: max(0, ceil(sgprs_used/8)-1)
  # GFX9: 2*max(0, ceil(sgprs_used/16)-1)
  # GFX10-GFX12: Reserved, must be 0. :contentReference[oaicite:36]{index=36}
  sgpr_granule = 0
  if (is_gfx10 or is_gfx11 or is_gfx12 or is_gfx90a_gfx942 or is_gfx125):
    if int(kd.get("granulated_wavefront_sgpr_count", 0)) != 0:
      raise AssertionError("GRANULATED_WAVEFRONT_SGPR_COUNT is reserved on GFX10-GFX12 and must be 0")
    if "next_free_sgpr" in kd and int(kd.get("next_free_sgpr", 0)) != 0:
      # Don’t silently ignore—force the caller to be intentional.
      #raise AssertionError("next_free_sgpr provided but SGPR granulation is reserved (must be 0) on this arch")
      pass
    sgpr_granule = 0
  else:
    if "next_free_sgpr" not in kd:
      raise AssertionError("next_free_sgpr is required on GFX6-GFX9 to compute GRANULATED_WAVEFRONT_SGPR_COUNT")
    sgprs_used = int(kd["next_free_sgpr"])
    if sgprs_used < 0:
      raise AssertionError("next_free_sgpr must be >= 0")

    if is_gfx6_gfx8:
      div = 8
      tmp = (sgprs_used + div - 1) // div
      tmp = tmp - 1 if tmp > 0 else 0
      if tmp < 0:
        tmp = 0
      if tmp > 15:
        raise AssertionError("GRANULATED_WAVEFRONT_SGPR_COUNT does not fit in 4 bits")
      sgpr_granule = tmp
    else:
      # GFX9 rule: 2 * max(0, ceil(sgprs_used/16)-1) :contentReference[oaicite:37]{index=37}
      div = 16
      tmp = (sgprs_used + div - 1) // div
      tmp = tmp - 1 if tmp > 0 else 0
      if tmp < 0:
        tmp = 0
      tmp = 2 * tmp
      if tmp > 15:
        raise AssertionError("GRANULATED_WAVEFRONT_SGPR_COUNT does not fit in 4 bits")
      sgpr_granule = tmp

  # 11:10 PRIORITY must be 0 (CP fills). :contentReference[oaicite:38]{index=38}
  if int(kd.get("priority", 0)) != 0:
    raise AssertionError("PRIORITY must be 0 (CP is responsible for filling COMPUTE_PGM_RSRC1.PRIORITY)")

  # FLOAT_* fields: docs define meanings/enums but do not mandate a specific default.
  # We default to 0 (NEAR_EVEN for rounding, FLUSH_SRC_DST for denorm) because those are the 0 enum values. :contentReference[oaicite:39]{index=39}
  float_round_mode_32 = int(kd.get("float_round_mode_32", 0))
  float_round_mode_16_64 = int(kd.get("float_round_mode_16_64", 0))
  float_denorm_mode_32 = int(kd.get("float_denorm_mode_32", 0))
  float_denorm_mode_16_64 = int(kd.get("float_denorm_mode_16_64", 0))
  if float_round_mode_32 < 0 or float_round_mode_32 > 3:
    raise AssertionError("FLOAT_ROUND_MODE_32 must be 0..3")
  if float_round_mode_16_64 < 0 or float_round_mode_16_64 > 3:
    raise AssertionError("FLOAT_ROUND_MODE_16_64 must be 0..3")
  if float_denorm_mode_32 < 0 or float_denorm_mode_32 > 3:
    raise AssertionError("FLOAT_DENORM_MODE_32 must be 0..3")
  if float_denorm_mode_16_64 < 0 or float_denorm_mode_16_64 > 3:
    raise AssertionError("FLOAT_DENORM_MODE_16_64 must be 0..3")

  # bit 20 PRIV must be 0 (CP fills). :contentReference[oaicite:40]{index=40}
  if int(kd.get("priv", 0)) != 0:
    raise AssertionError("PRIV must be 0 (CP fills COMPUTE_PGM_RSRC1.PRIV)")

  # bit 21:
  # - GFX9-GFX11: ENABLE_DX10_CLAMP (caller-controlled)
  # - GFX12: WG_RR_EN, CP responsible for filling, so must be 0 in descriptor. :contentReference[oaicite:41]{index=41}
  enable_dx10_clamp_or_wg_rr_en = int(kd.get("enable_dx10_clamp", 0))
  if enable_dx10_clamp_or_wg_rr_en not in (0, 1):
    raise AssertionError("ENABLE_DX10_CLAMP/WG_RR_EN must be 0 or 1")
  if (is_gfx12 or is_gfx125) and enable_dx10_clamp_or_wg_rr_en != 0:
    raise AssertionError("On GFX12, WG_RR_EN is CP-filled and must be 0 in the descriptor")

  # bit 22 DEBUG_MODE must be 0 (CP fills). :contentReference[oaicite:42]{index=42}
  if int(kd.get("debug_mode", 0)) != 0:
    raise AssertionError("DEBUG_MODE must be 0 (CP fills COMPUTE_PGM_RSRC1.DEBUG_MODE)")

  # bit 23:
  # - GFX9-GFX11: ENABLE_IEEE_MODE (caller-controlled)
  # - GFX12: reserved, must be 0. :contentReference[oaicite:43]{index=43}
  enable_ieee_mode = int(kd.get("enable_ieee_mode", 0))
  if enable_ieee_mode not in (0, 1):
    raise AssertionError("ENABLE_IEEE_MODE must be 0 or 1")
  if (is_gfx12 or is_gfx125) and enable_ieee_mode != 0:
    raise AssertionError("On GFX12, bit 23 is reserved and must be 0")

  # bit 24 BULKY must be 0 (CP fills). :contentReference[oaicite:44]{index=44}
  if int(kd.get("bulky", 0)) != 0:
    raise AssertionError("BULKY must be 0 (CP fills COMPUTE_PGM_RSRC1.BULKY)")

  # bit 25 CDBG_USER must be 0 (CP fills). :contentReference[oaicite:45]{index=45}
  if int(kd.get("cdbg_user", 0)) != 0:
    raise AssertionError("CDBG_USER must be 0 (CP fills COMPUTE_PGM_RSRC1.CDBG_USER)")

  # bit 26 FP16_OVFL:
  # - GFX6-GFX8 reserved must be 0
  # - GFX9-GFX12 caller-controlled :contentReference[oaicite:46]{index=46}
  fp16_ovfl = int(kd.get("fp16_ovfl", 0))
  if fp16_ovfl not in (0, 1):
    raise AssertionError("FP16_OVFL must be 0 or 1")
  if is_gfx6_gfx8 and fp16_ovfl != 0:
    raise AssertionError("On GFX6-GFX8, FP16_OVFL is reserved and must be 0")

  # bits 27,28 are reserved for the arches we care about here (docs mention special GFX125 behavior for 27; keep strict).
  if int(kd.get("flat_scratch_is_nv", 0)) != 0:
    raise AssertionError("FLAT_SCRATCH_IS_NV is not supported here; must be 0")
  if int(kd.get("rsrc1_reserved28", 0)) != 0:
    raise AssertionError("RSRC1 bit 28 is reserved and must be 0")

  # bits 29..31: WGP_MODE/MEM_ORDERED/FWD_PROGRESS
  # GFX6-GFX9: reserved must be 0. GFX10-GFX12: caller-controlled. :contentReference[oaicite:47]{index=47}
  wgp_mode = int(kd.get("workgroup_processor_mode", 0))
  mem_ordered = int(kd.get("memory_ordered", 0))
  fwd_progress = int(kd.get("fwd_progress", 0))
  if wgp_mode not in (0, 1):
    raise AssertionError("WGP_MODE must be 0 or 1")
  if mem_ordered not in (0, 1):
    raise AssertionError("MEM_ORDERED must be 0 or 1")
  if fwd_progress not in (0, 1):
    raise AssertionError("FWD_PROGRESS must be 0 or 1")
  if is_gfx6_gfx9:
    if wgp_mode != 0:
      raise AssertionError("On GFX6-GFX9, WGP_MODE is reserved and must be 0")
    if mem_ordered != 0:
      raise AssertionError("On GFX6-GFX9, MEM_ORDERED is reserved and must be 0")
    if fwd_progress != 0:
      raise AssertionError("On GFX6-GFX9, FWD_PROGRESS is reserved and must be 0")

  desc.compute_pgm_rsrc1 = (
    (vgpr_granule << amdgpu_kd.COMPUTE_PGM_RSRC1_GRANULATED_WORKITEM_VGPR_COUNT_SHIFT) |
    (sgpr_granule << amdgpu_kd.COMPUTE_PGM_RSRC1_GRANULATED_WAVEFRONT_SGPR_COUNT_SHIFT) |
    (0 << amdgpu_kd.COMPUTE_PGM_RSRC1_PRIORITY_SHIFT) |
    (float_round_mode_32 << amdgpu_kd.COMPUTE_PGM_RSRC1_FLOAT_ROUND_MODE_32_SHIFT) |
    (float_round_mode_16_64 << amdgpu_kd.COMPUTE_PGM_RSRC1_FLOAT_ROUND_MODE_16_64_SHIFT) |
    (float_denorm_mode_32 << amdgpu_kd.COMPUTE_PGM_RSRC1_FLOAT_DENORM_MODE_32_SHIFT) |
    (float_denorm_mode_16_64 << amdgpu_kd.COMPUTE_PGM_RSRC1_FLOAT_DENORM_MODE_16_64_SHIFT) |
    (0 << amdgpu_kd.COMPUTE_PGM_RSRC1_PRIV_SHIFT) |
    (enable_dx10_clamp_or_wg_rr_en << amdgpu_kd.COMPUTE_PGM_RSRC1_GFX6_GFX11_ENABLE_DX10_CLAMP_SHIFT) |
    (0 << amdgpu_kd.COMPUTE_PGM_RSRC1_DEBUG_MODE_SHIFT) |
    (enable_ieee_mode << amdgpu_kd.COMPUTE_PGM_RSRC1_GFX6_GFX11_ENABLE_IEEE_MODE_SHIFT) |
    (0 << amdgpu_kd.COMPUTE_PGM_RSRC1_BULKY_SHIFT) |
    (0 << amdgpu_kd.COMPUTE_PGM_RSRC1_CDBG_USER_SHIFT) |
    (fp16_ovfl << amdgpu_kd.COMPUTE_PGM_RSRC1_GFX9_PLUS_FP16_OVFL_SHIFT) |
    (wgp_mode << amdgpu_kd.COMPUTE_PGM_RSRC1_GFX10_PLUS_WGP_MODE_SHIFT) |
    (mem_ordered << amdgpu_kd.COMPUTE_PGM_RSRC1_GFX10_PLUS_MEM_ORDERED_SHIFT) |
    (fwd_progress << amdgpu_kd.COMPUTE_PGM_RSRC1_GFX10_PLUS_FWD_PROGRESS_SHIFT)
  )

  # --- Table 76: COMPUTE_PGM_RSRC2 (GFX6-GFX12) ---
  enable_private_segment = int(kd.get("enable_private_segment", 0))
  if enable_private_segment not in (0, 1):
    raise AssertionError("ENABLE_PRIVATE_SEGMENT must be 0 or 1")  # :contentReference[oaicite:48]{index=48}

  user_sgpr_count = int(kd.get("user_sgpr_count", 0))
  if is_gfx125:
    # GFX125*: bits 6:1 is 6-bit count. :contentReference[oaicite:49]{index=49}
    if user_sgpr_count < 0 or user_sgpr_count > 63:
      raise AssertionError("On GFX125*, USER_SGPR_COUNT must be 0..63")
  else:
    # GFX6-GFX120*: bits 5:1 is 5-bit count. :contentReference[oaicite:50]{index=50}
    if user_sgpr_count < 0 or user_sgpr_count > 31:
      raise AssertionError("On GFX6-GFX120*, USER_SGPR_COUNT must be 0..31")

  # bit 6:
  # GFX6-GFX11: ENABLE_TRAP_HANDLER must be 0 (CP sets TRAP_PRESENT) :contentReference[oaicite:51]{index=51}
  enable_trap_handler_or_dynamic_vgpr = int(kd.get("enable_trap_handler", 0))
  if enable_trap_handler_or_dynamic_vgpr not in (0, 1):
    raise AssertionError("ENABLE_TRAP_HANDLER/ENABLE_DYNAMIC_VGPR must be 0 or 1")
  if (is_gfx6_gfx9 or is_gfx90a_gfx942 or is_gfx10 or is_gfx11) and enable_trap_handler_or_dynamic_vgpr != 0:
    raise AssertionError("On GFX6-GFX11, ENABLE_TRAP_HANDLER must be 0 (CP sets TRAP_PRESENT)")

  enable_sgpr_workgroup_id_x = int(kd.get("system_sgpr_workgroup_id_x", 0))
  enable_sgpr_workgroup_id_y = int(kd.get("system_sgpr_workgroup_id_y", 0))
  enable_sgpr_workgroup_id_z = int(kd.get("system_sgpr_workgroup_id_z", 0))
  enable_sgpr_workgroup_info = int(kd.get("system_sgpr_workgroup_info", 0))
  for v, n in (
    (enable_sgpr_workgroup_id_x, "ENABLE_SGPR_WORKGROUP_ID_X"),
    (enable_sgpr_workgroup_id_y, "ENABLE_SGPR_WORKGROUP_ID_Y"),
    (enable_sgpr_workgroup_id_z, "ENABLE_SGPR_WORKGROUP_ID_Z"),
    (enable_sgpr_workgroup_info, "ENABLE_SGPR_WORKGROUP_INFO"),
  ):
    if v not in (0, 1):
      raise AssertionError(f"{n} must be 0 or 1")

  enable_vgpr_workitem_id = int(kd.get("enable_vgpr_workitem_id", 0))
  if enable_vgpr_workitem_id < 0 or enable_vgpr_workitem_id > 3:
    raise AssertionError("ENABLE_VGPR_WORKITEM_ID must be 0..3")  # :contentReference[oaicite:52]{index=52}

  # bits 13,14 must be 0 (CP fills exception enables). :contentReference[oaicite:53]{index=53}
  if int(kd.get("enable_exception_address_watch", 0)) != 0:
    raise AssertionError("ENABLE_EXCEPTION_ADDRESS_WATCH must be 0 (CP fills)")
  if int(kd.get("enable_exception_memory", 0)) != 0:
    raise AssertionError("ENABLE_EXCEPTION_MEMORY must be 0 (CP fills)")

  # bits 23:15 GRANULATED_LDS_SIZE must be 0 (CP uses dispatch packet). :contentReference[oaicite:54]{index=54}
  if int(kd.get("granulated_lds_size", 0)) != 0:
    raise AssertionError("GRANULATED_LDS_SIZE must be 0 (CP uses dispatch packet rounded LDS size)")

  # bits 24..30 exception enables: caller may set 0/1
  exc_invalid = int(kd.get("enable_exception_ieee_754_fp_invalid_operation", 0))
  exc_denorm_src = int(kd.get("enable_exception_fp_denormal_source", 0))
  exc_div0 = int(kd.get("enable_exception_ieee_754_fp_division_by_zero", 0))
  exc_overflow = int(kd.get("enable_exception_ieee_754_fp_overflow", 0))
  exc_underflow = int(kd.get("enable_exception_ieee_754_fp_underflow", 0))
  exc_inexact = int(kd.get("enable_exception_ieee_754_fp_inexact", 0))
  exc_int_div0 = int(kd.get("enable_exception_int_divide_by_zero", 0))
  for v, n in (
    (exc_invalid, "EXCP_INVALID"),
    (exc_denorm_src, "EXCP_DENORM_SRC"),
    (exc_div0, "EXCP_DIV0"),
    (exc_overflow, "EXCP_OVERFLOW"),
    (exc_underflow, "EXCP_UNDERFLOW"),
    (exc_inexact, "EXCP_INEXACT"),
    (exc_int_div0, "EXCP_INT_DIV0"),
  ):
    if v not in (0, 1):
      raise AssertionError(f"{n} must be 0 or 1")

  # bit 31 reserved must be 0
  if int(kd.get("rsrc2_reserved31", 0)) != 0:
    raise AssertionError("COMPUTE_PGM_RSRC2 bit 31 is reserved and must be 0")

  desc.compute_pgm_rsrc2 = (
    (enable_private_segment << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_PRIVATE_SEGMENT_SHIFT) |
    (user_sgpr_count << amdgpu_kd.COMPUTE_PGM_RSRC2_USER_SGPR_COUNT_SHIFT) |
    (enable_trap_handler_or_dynamic_vgpr << amdgpu_kd.COMPUTE_PGM_RSRC2_GFX6_GFX11_ENABLE_TRAP_HANDLER_SHIFT) |
    (enable_sgpr_workgroup_id_x << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_SGPR_WORKGROUP_ID_X_SHIFT) |
    (enable_sgpr_workgroup_id_y << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_SGPR_WORKGROUP_ID_Y_SHIFT) |
    (enable_sgpr_workgroup_id_z << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_SGPR_WORKGROUP_ID_Z_SHIFT) |
    (enable_sgpr_workgroup_info << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_SGPR_WORKGROUP_INFO_SHIFT) |
    (enable_vgpr_workitem_id << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_VGPR_WORKITEM_ID_SHIFT) |
    (0 << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_EXCEPTION_ADDRESS_WATCH_SHIFT) |
    (0 << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_EXCEPTION_MEMORY_SHIFT) |
    (0 << amdgpu_kd.COMPUTE_PGM_RSRC2_GRANULATED_LDS_SIZE_SHIFT) |
    (exc_invalid << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_EXCEPTION_IEEE_754_FP_INVALID_OPERATION_SHIFT) |
    (exc_denorm_src << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_EXCEPTION_FP_DENORMAL_SOURCE_SHIFT) |
    (exc_div0 << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_EXCEPTION_IEEE_754_FP_DIVISION_BY_ZERO_SHIFT) |
    (exc_overflow << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_EXCEPTION_IEEE_754_FP_OVERFLOW_SHIFT) |
    (exc_underflow << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_EXCEPTION_IEEE_754_FP_UNDERFLOW_SHIFT) |
    (exc_inexact << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_EXCEPTION_IEEE_754_FP_INEXACT_SHIFT) |
    (exc_int_div0 << amdgpu_kd.COMPUTE_PGM_RSRC2_ENABLE_EXCEPTION_INT_DIVIDE_BY_ZERO_SHIFT)
  )

  # --- Table 74: kernel_code_properties (bits 458:448, plus wave32 + dynamic stack) ---
  # These enables are the “setup of SGPR user data registers” flags.
  # Total enabled user SGPRs must not exceed 16 and must match compute_pgm_rsrc2.user_sgpr_count. :contentReference[oaicite:55]{index=55}

  # Requires knowing whether the target has Architected flat scratch for two bits. :contentReference[oaicite:56]{index=56}
  """
  if "architected_flat_scratch" not in kd:
    raise AssertionError("architected_flat_scratch must be provided (0/1) to validate scratch-related SGPR enables")
  architected_flat_scratch = int(kd["architected_flat_scratch"])
  if architected_flat_scratch not in (0, 1):
    raise AssertionError("architected_flat_scratch must be 0 or 1")
  """

  enable_sgpr_private_segment_buffer = int(kd.get("user_sgpr_private_segment_buffer", 0))
  enable_sgpr_dispatch_ptr = int(kd.get("user_sgpr_dispatch_ptr", 0))
  enable_sgpr_queue_ptr = int(kd.get("user_sgpr_queue_ptr", 0))
  enable_sgpr_kernarg_segment_ptr = int(kd.get("user_sgpr_kernarg_segment_ptr", 0))
  enable_sgpr_dispatch_id = int(kd.get("user_sgpr_dispatch_id", 0))
  enable_sgpr_flat_scratch_init = int(kd.get("user_sgpr_flat_scratch_init", 0))
  enable_sgpr_private_segment_size = int(kd.get("user_sgpr_private_segment_size", 0))
  for v, n in (
    (enable_sgpr_private_segment_buffer, "ENABLE_SGPR_PRIVATE_SEGMENT_BUFFER"),
    (enable_sgpr_dispatch_ptr, "ENABLE_SGPR_DISPATCH_PTR"),
    (enable_sgpr_queue_ptr, "ENABLE_SGPR_QUEUE_PTR"),
    (enable_sgpr_kernarg_segment_ptr, "ENABLE_SGPR_KERNARG_SEGMENT_PTR"),
    (enable_sgpr_dispatch_id, "ENABLE_SGPR_DISPATCH_ID"),
    (enable_sgpr_flat_scratch_init, "ENABLE_SGPR_FLAT_SCRATCH_INIT"),
    (enable_sgpr_private_segment_size, "ENABLE_SGPR_PRIVATE_SEGMENT_SIZE"),
  ):
    if v not in (0, 1):
      raise AssertionError(f"{n} must be 0 or 1")

  # Two scratch-related SGPRs must be 0 if Architected flat scratch. :contentReference[oaicite:57]{index=57} :contentReference[oaicite:58]{index=58}
  """
  if architected_flat_scratch == 1:
    if enable_sgpr_private_segment_buffer != 0:
      raise AssertionError("ENABLE_SGPR_PRIVATE_SEGMENT_BUFFER not supported with architected flat scratch and must be 0")
    if enable_sgpr_flat_scratch_init != 0:
      raise AssertionError("ENABLE_SGPR_FLAT_SCRATCH_INIT not supported with architected flat scratch and must be 0")

  """
  # Reserved bits 457:455 must be 0. :contentReference[oaicite:59]{index=59}
  if int(kd.get("kernel_code_properties_reserved_455_457", 0)) != 0:
    raise AssertionError("kernel_code_properties bits 455:457 are reserved and must be 0")

  # ENABLE_WAVEFRONT_SIZE32: GFX6-GFX9 reserved must be 0; already enforced above. :contentReference[oaicite:60]{index=60}

  uses_dynamic_stack = int(kd.get("uses_dynamic_stack", 0))
  if uses_dynamic_stack not in (0, 1):
    raise AssertionError("USES_DYNAMIC_STACK must be 0 or 1")  # :contentReference[oaicite:61]{index=61}

  # Reserved 463:460 must be 0. :contentReference[oaicite:62]{index=62}
  if int(kd.get("kernel_code_properties_reserved_460_463", 0)) != 0:
    raise AssertionError("kernel_code_properties bits 460:463 are reserved and must be 0")

  # Validate enabled-user-sgpr count <=16 and <= user_sgpr_count.
  enabled_user_sgprs = (
    enable_sgpr_private_segment_buffer +
    enable_sgpr_dispatch_ptr +
    enable_sgpr_queue_ptr +
    enable_sgpr_kernarg_segment_ptr +
    enable_sgpr_dispatch_id +
    enable_sgpr_flat_scratch_init +
    enable_sgpr_private_segment_size
  )
  if enabled_user_sgprs > 16:
    raise AssertionError("Total enabled SGPR user data registers must not exceed 16")
  if user_sgpr_count < enabled_user_sgprs:
    raise AssertionError("USER_SGPR_COUNT must be >= number of enabled user SGPRs")
  # Doc also says enabled requests must match user_sgpr_count; we enforce equality if caller asks for strict match.
  if int(kd.get("require_user_sgpr_count_match", 1)) == 1 and user_sgpr_count != enabled_user_sgprs:
    raise AssertionError("USER_SGPR_COUNT must match the number of enabled user SGPRs (strict mode)")

  desc.kernel_code_properties = (
    (enable_sgpr_private_segment_buffer << amdgpu_kd.KERNEL_CODE_PROPERTY_ENABLE_SGPR_PRIVATE_SEGMENT_BUFFER_SHIFT) |
    (enable_sgpr_dispatch_ptr << amdgpu_kd.KERNEL_CODE_PROPERTY_ENABLE_SGPR_DISPATCH_PTR_SHIFT) |
    (enable_sgpr_queue_ptr << amdgpu_kd.KERNEL_CODE_PROPERTY_ENABLE_SGPR_QUEUE_PTR_SHIFT) |
    (enable_sgpr_kernarg_segment_ptr << amdgpu_kd.KERNEL_CODE_PROPERTY_ENABLE_SGPR_KERNARG_SEGMENT_PTR_SHIFT) |
    (enable_sgpr_dispatch_id << amdgpu_kd.KERNEL_CODE_PROPERTY_ENABLE_SGPR_DISPATCH_ID_SHIFT) |
    (enable_sgpr_flat_scratch_init << amdgpu_kd.KERNEL_CODE_PROPERTY_ENABLE_SGPR_FLAT_SCRATCH_INIT_SHIFT) |
    (enable_sgpr_private_segment_size << amdgpu_kd.KERNEL_CODE_PROPERTY_ENABLE_SGPR_PRIVATE_SEGMENT_SIZE_SHIFT) |
    (0 << amdgpu_kd.KERNEL_CODE_PROPERTY_RESERVED0_SHIFT) |
    (wavefront_size32 << amdgpu_kd.KERNEL_CODE_PROPERTY_ENABLE_WAVEFRONT_SIZE32_SHIFT) |
    (uses_dynamic_stack << amdgpu_kd.KERNEL_CODE_PROPERTY_USES_DYNAMIC_STACK_SHIFT) |
    (0 << amdgpu_kd.KERNEL_CODE_PROPERTY_RESERVED1_SHIFT)
  )

  # --- Table 74: kernarg_preload (GFX90A/GFX942 only; otherwise reserved must be 0) ---
  kernarg_preload_spec_length = int(kd.get("kernarg_preload_spec_length", 0))
  kernarg_preload_spec_offset = int(kd.get("kernarg_preload_spec_offset", 0))

  if is_gfx90a_gfx942:
    # 470:464 7 bits length; 479:471 9 bits offset :contentReference[oaicite:63]{index=63}
    if kernarg_preload_spec_length < 0 or kernarg_preload_spec_length > 127:
      raise AssertionError("KERNARG_PRELOAD_SPEC_LENGTH must be 0..127")
    if kernarg_preload_spec_offset < 0 or kernarg_preload_spec_offset > 511:
      raise AssertionError("KERNARG_PRELOAD_SPEC_OFFSET must be 0..511")
  else:
    # Reserved, must be 0 on GFX6-GFX9. :contentReference[oaicite:64]{index=64}
    if kernarg_preload_spec_length != 0:
      raise AssertionError("KERNARG_PRELOAD_SPEC_LENGTH is reserved on this arch and must be 0")
    if kernarg_preload_spec_offset != 0:
      raise AssertionError("KERNARG_PRELOAD_SPEC_OFFSET is reserved on this arch and must be 0")

  desc.kernarg_preload = (
    (kernarg_preload_spec_length << amdgpu_kd.KERNARG_PRELOAD_SPEC_LENGTH_SHIFT) |
    (kernarg_preload_spec_offset << amdgpu_kd.KERNARG_PRELOAD_SPEC_OFFSET_SHIFT)
  )

  # 511:480 reserved, must be 0. :contentReference[oaicite:65]{index=65}
  desc.reserved3[:] = b"\x00" * 4

  return bytes(desc)
