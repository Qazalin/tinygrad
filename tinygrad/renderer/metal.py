import functools
from tinygrad.renderer.cstyle import uops_to_cstyle, CStyleLanguage

class MetalLanguage(CStyleLanguage):
  kernel_prefix = "#include <metal_stdlib>\nusing namespace metal;\nkernel "
  buffer_prefix = "device "
  smem_prefix = "threadgroup "
  arg_int_prefix = "constant int&"
  barrier = "threadgroup_barrier(mem_flags::mem_threadgroup);"
  max_vector_width = 4 # https://developer.apple.com/metal/Metal-Shading-Language-Specification.pdf#page=25
  vectorize_fn = lambda x: str(x)
  uses_ptr_arithmetic=True
  gid = [f"gid.{chr(120+i)}" for i in range(3)]
  lid = [f"lid.{chr(120+i)}" for i in range(3)]
  extra_args = ['uint3 gid [[threadgroup_position_in_grid]]', 'uint3 lid [[thread_position_in_threadgroup]]']

MetalRenderer = functools.partial(uops_to_cstyle, MetalLanguage())
