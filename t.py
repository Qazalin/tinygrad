from tinygrad.renderer.cstyle import OpenCLRenderer
from tinygrad.codegen.linearizer import Linearizer
from tinygrad.graph import print_tree
from tinygrad import Tensor, dtypes
from tinygrad.lazy import get_lazyop_info
from tinygrad.ops import ReduceOps

d1 = dtypes.half
d2 = dtypes.float

x = Tensor.rand(1024,1024, dtype=d1)
w = Tensor.rand(1024,1024, dtype=d1)
out = (x*w).cast(d2).sum(-1).cast(d1)

ast = out.lazydata.schedule()[-1].ast
#print_tree(ast)

mulacc = [op for op in ast.get_lazyops() if op.op in ReduceOps][0]
assert get_lazyop_info(mulacc).dtype == d2

lin = Linearizer(ast)
lin.linearize()

print("---")
for u in lin.uops: print(u)
print(OpenCLRenderer(lin.name, lin.uops)[0])
"""
"""
