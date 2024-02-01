extern "C" __attribute__((global)) void __launch_bounds__ (128, 1) test(float* c, half* a, half* b) {
  int gx = __ockl_get_group_id(0);
  int gy = __ockl_get_group_id(1);
  int gz = __ockl_get_group_id(2);
  int tx = __ockl_get_local_id(0);
  int ty = __ockl_get_local_id(1);
  int tz = __ockl_get_local_id(2);
}
