from tinygrad import Tensor, UOp, dtypes
from tinygrad.uop.ops import KernelInfo, Ops

THREADS = 256
ITEMS = 4
TILE = THREADS * ITEMS

def hip_lds_loops(out:UOp, x:UOp) -> UOp:
  code = f"""
extern "C" __attribute__((global)) void lds_loops(float* out, const float* x) {{
  __attribute__((shared, aligned(16))) float lds[{TILE}];
  unsigned int tid = __builtin_amdgcn_workitem_id_x();
  unsigned int base = __builtin_amdgcn_workgroup_id_x() * {TILE};

  // Each thread computes four values and stores them in LDS.
  #pragma unroll 1
  for (unsigned int k = 0; k < {ITEMS}; k++) {{
    unsigned int j = k * {THREADS} + tid;
    lds[j] = base + j < {x.numel()} ? x[base + j] * 2.0f + 1.0f : 0.0f;
  }}

  // All threads participate, including those outside the final partial tile.
  __builtin_amdgcn_fence(__ATOMIC_RELEASE, "workgroup");
  __builtin_amdgcn_s_barrier();
  __builtin_amdgcn_fence(__ATOMIC_ACQUIRE, "workgroup");

  // Read another thread's values across wave boundaries, then write the result.
  #pragma unroll 1
  for (unsigned int k = 0; k < {ITEMS}; k++) {{
    unsigned int j = k * {THREADS} + tid;
    unsigned int peer = k * {THREADS} + (tid + {THREADS // 2}) % {THREADS};
    if (base + j < {x.numel()}) out[base + j] = lds[j] + lds[peer];
  }}
}}
"""
  sink = UOp.sink(UOp.special((x.numel() + TILE - 1) // TILE, "gidx0"), UOp.special(THREADS, "lidx0"),
                  out, x, arg=KernelInfo(name="lds_loops"))
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.LINEAR, src=(*sink.src, sink)), UOp(Ops.SOURCE, arg=code)))

if __name__ == "__main__":
  # PYTHONPATH=. DEV=MOCK+AMD python build/amd_custom_kernel.py
  n = TILE
  x = Tensor.arange(n, dtype=dtypes.float32).to("AMD").contiguous().realize()
  out = Tensor.empty_like(x).custom_kernel(x, fxn=hip_lds_loops)[0].realize()
  expected = []
  for i in range(n):
    peer = i // THREADS * THREADS + (i % THREADS + THREADS // 2) % THREADS
    expected.append(float(2 * i + 1 + (2 * peer + 1 if peer < n else 0)))
  assert out.tolist() == expected
  print(f"HIP LDS loops passed for {n} elements")
