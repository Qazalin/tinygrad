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
  int shard = __ockl_get_group_id(1);
  int local_v = (gid * 256 + tid) * 2;
  int v = shard * 1835008 + local_v;

  u32x4 *dst = (u32x4*)data0_117440512;
  u32x4 *srcs[8] = {(u32x4*)data1_14680064, (u32x4*)data2_14680064, (u32x4*)data3_14680064, (u32x4*)data4_14680064,
                    (u32x4*)data5_14680064, (u32x4*)data6_14680064, (u32x4*)data7_14680064, (u32x4*)data8_14680064};
  u32x4 *src = srcs[shard];

  dst[v] = src[local_v];
  dst[v+1] = src[local_v+1];
}
