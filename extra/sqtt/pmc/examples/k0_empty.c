extern "C" __global__ void baseline() {
  int gid = __ockl_get_group_id(0) * __ockl_get_local_size(0) + __ockl_get_local_id(0);
  volatile float acc = (float)gid;

  #pragma clang loop unroll(disable)
  for (int k = 0; k < 100; k++) {
    // pure ALU work, no memory
    acc = acc * 1.000001f + 1.0f;
  }

  // Prevent compiler from dropping the loop
  if (acc == 123456.0f) {
    ((volatile int*)0)[0] = 0;
  }
}
