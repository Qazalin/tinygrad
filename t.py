import pickle
from tinygrad.uop.ops import Ops
from tinygrad import Tensor
with open("/tmp/test2.pkl", "rb") as f: sink = pickle.load(f)
assert len(sink.src) == 1
buf = next((t for t in sink.toposort() if t.op is Ops.BUFFER and t.src[0].arg == 334))
print(buf.buffer.numpy())
t = Tensor(sink.src[0], device="CPU")
t.realize()
print(buf.buffer.numpy())
