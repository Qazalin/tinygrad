from tinygrad import Tensor, dtypes, Device
from tinygrad.engine.realize import ProgramSpec, CompiledRunner, ExecItem

sw = 1024
sh = 1024
src_cuda = f"""
extern "C" __global__ void test(int* C, const int* A, const int* B) {{
  size_t gidx0 = (threadIdx.x + (blockDim.x * (size_t)blockIdx.x));
  size_t gidx1 = (threadIdx.y + (blockDim.y * (size_t)blockIdx.y));
  if ((gidx0 < {sh}) && (gidx1 < {sw})) {{
    size_t lin = (gidx0 * {sw}) + gidx1;
    *(C + lin) = (*(A + lin)) + (*(B + lin));
  }}
}}
"""

src_amd = f"""
#define INFINITY (__builtin_inff())
#define NAN (__builtin_nanf(""))
typedef long unsigned int size_t;
#define half _Float16
extern "C" __attribute__((device, const)) size_t __ockl_get_local_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_group_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_local_size(unsigned int);
extern "C" __attribute__((device, const)) float __ocml_fmax_f32(float, float);
extern "C" __attribute__((device, pure)) float __ocml_exp2_f32(float);
extern "C" __attribute__((device, pure)) float __ocml_log2_f32(float);
extern "C" __attribute__((device, const)) float __ocml_sqrt_f32(float);
extern "C" __attribute__((device)) float __ocml_sin_f32(float);
extern "C" __attribute__((device)) float __ocml_trunc_f32(float);
extern "C" __attribute__((device, const)) double __ocml_fmax_f64(double, double);
extern "C" __attribute__((device, pure)) double __ocml_exp2_f64(double);
extern "C" __attribute__((device, pure)) double __ocml_log2_f64(double);
extern "C" __attribute__((device, const)) double __ocml_sqrt_f64(double);
extern "C" __attribute__((device)) double __ocml_sin_f64(double);
extern "C" __attribute__((device)) double __ocml_trunc_f64(double);
extern "C" __attribute__((device, const)) half __ocml_fmax_f16(half, half);
extern "C" __attribute__((device, pure)) half __ocml_exp2_f16(half);
extern "C" __attribute__((device, pure)) half __ocml_log2_f16(half);
extern "C" __attribute__((device, const)) half __ocml_sqrt_f16(half);
extern "C" __attribute__((device)) half __ocml_sin_f16(half);
extern "C" __attribute__((device)) half __ocml_trunc_f16(half);
extern "C" __attribute__((global)) void test(int* data0, const int* data1, const int* data2) {{
  size_t l0 = __ockl_get_local_id(0); size_t l1 = __ockl_get_local_id(1);
  size_t g0 = __ockl_get_group_id(0); size_t g1 = __ockl_get_group_id(1);
  size_t s0 = __ockl_get_local_size(0); size_t s1 = __ockl_get_local_size(1);
  size_t y = l0 + s0 * g0; size_t x = l1 + s1 * g1;
  if ((x < {sh}) && (y < {sw})) {{ size_t lin = x * {sw} + y; *(data0 + lin) = (*(data1 + lin)) + (*(data2 + lin)); }}
}}
"""

src = src_amd

a = Tensor.full((sw, sh), 1, dtype=dtypes.int32).contiguous().realize()
b = Tensor.full((sw, sh), 2, dtype=dtypes.int32).contiguous().realize()
c = Tensor.full((sw, sh), 0, dtype=dtypes.int32).contiguous().realize()
prg = ProgramSpec("test", src, Device.DEFAULT, None, global_size=[32, 32, 1], local_size=[32, 32, 1])
car = CompiledRunner(prg)
ei = ExecItem(car, [t.uop.base.buffer for t in (c, a, b)])
ei.run(wait=True)
