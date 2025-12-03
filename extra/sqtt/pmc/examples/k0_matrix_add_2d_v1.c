__global__ void matrix_add_2d(const arr_t * __restrict__ A, const arr_t * __restrict__ B, arr_t * __restrict__ C, const size_t sw, const size_t sh){
  size_t idx = __ockl_get_local_id(0) + __ockl_get_local_size(0) * (size_t)__ockl_get_group_id(0);
  size_t idy = __ockl_get_local_id(1) + __ockl_get_local_size(1) * (size_t)__ockl_get_group_id(1);
  int sw = 1024;
  int sh = 1024;
  if ((idx < sh) && (idy < sw)) {
    size_t off = idx * sw + idy;
    *(data0_1048576 + off) = *(data1_1048576 + off) + *(data2_1048576 + off);
  }
}
