#define F32
typedef float float8 __attribute__((ext_vector_type(8)));
typedef _Float16 half16 __attribute__((ext_vector_type(16)));
extern "C" __global__ void __launch_bounds__ (128, 1) test(float* c, __half* a, __half* b) {
  const int gx = blockIdx.x*2 + threadIdx.y;
  const int gy = blockIdx.y*2 + threadIdx.z;

  const int lIdx = threadIdx.x;
  const int lane = lIdx%16;

  const int KX  = 4;
  const int KY = 4;
  const int N = 2048;
  bool logme = blockIdx.x == 0 && blockIdx.y == 0 && threadIdx.x == 0 && threadIdx.y == 0 && threadIdx.z == 0;

  c += gx*(KX*16)*(N) + gy*(KY*16) + (lIdx/16)*(N) + lane;
  a += gx*(KX*16)*(N);
  b += gy*(KY*16);

  half16 a_frag[(KX)];
  half16 b_frag[(KY)];
  #ifdef F32
    float8 c_frag[(KY)][(KX)] = {};
  #else
    half16 c_frag[(KY)][(KX)] = {};
  #endif

  for (int k = 0; k < N; k += 16) {
    __syncthreads();
    for (int ele = 0; ele < 16; ++ele) {
      for (int x = 0; x < (KX); x++) {
        a_frag[x][ele] = a[(k+ele) + x*(16*N) + (N)*lane];
      }
    }
    for (int ele = 0; ele < 16; ++ele) {
      for (int y = 0; y < (KY); y++) {
        b_frag[y][ele] = b[(k+ele)*(N) + y*16 + lane];
      }
    }
    for (int y = 0; y < KY; y++) {
      for (int x = 0; x < KX; x++) {
        #ifdef F32
          c_frag[y][x] = __builtin_amdgcn_wmma_f32_16x16x16_f16_w32(a_frag[x], b_frag[y], c_frag[y][x]);
        #else
          c_frag[y][x] = __builtin_amdgcn_wmma_f16_16x16x16_f16_w32(a_frag[x], b_frag[y], c_frag[y][x], false);
        #endif
      }
    }
  }

  for (int ele = 0; ele < 8; ++ele) {
    for (int y = 0; y < (KY); y++) {
      for (int x = 0; x < (KX); x++) {
        #ifdef F32
          c[ele*(2*N) + y*16 + x*(16*N)] = c_frag[y][x][ele];
        #else
          c[ele*(2*N) + y*16 + x*(16*N)] = c_frag[y][x][ele*2];
        #endif
      }
    }
  }
}
