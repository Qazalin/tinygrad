typedef long unsigned int size_t;
typedef __bf16 hip_bfloat16;
typedef unsigned int u32x4 __attribute__((ext_vector_type(4)));
extern "C" __attribute__((device, const)) size_t __ockl_get_local_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_group_id(unsigned int);

extern "C" __attribute__((global)) void __attribute__((amdgpu_flat_work_group_size(1, 256))) E_114688_32_4_2_4(
    hip_bfloat16* data0_117440512,
    hip_bfloat16* data1_14680064,
    hip_bfloat16* data2_14680064,
    hip_bfloat16* data3_14680064,
    hip_bfloat16* data4_14680064,
    hip_bfloat16* data5_14680064,
    hip_bfloat16* data6_14680064,
    hip_bfloat16* data7_14680064,
    hip_bfloat16* data8_14680064) {
  int tid = __ockl_get_local_id(0);
  int gid = __ockl_get_group_id(0);
  int v = (gid * 256 + tid) * 2;

  u32x4 *dst = (u32x4*)data0_117440512;
  u32x4 *src;
  int off;
  if (v < 1835008) { src = (u32x4*)data1_14680064; off = v; }
  else if (v < 3670016) { src = (u32x4*)data2_14680064; off = v - 1835008; }
  else if (v < 5505024) { src = (u32x4*)data3_14680064; off = v - 3670016; }
  else if (v < 7340032) { src = (u32x4*)data4_14680064; off = v - 5505024; }
  else if (v < 9175040) { src = (u32x4*)data5_14680064; off = v - 7340032; }
  else if (v < 11010048) { src = (u32x4*)data6_14680064; off = v - 9175040; }
  else if (v < 12845056) { src = (u32x4*)data7_14680064; off = v - 11010048; }
  else { src = (u32x4*)data8_14680064; off = v - 12845056; }

  dst[v] = src[off];
  dst[v+1] = src[off+1];
}
