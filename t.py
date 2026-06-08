from tinygrad import Tensor, Context, dtypes
from tinygrad.helpers import getenv
import numpy as np

NDEV = getenv("NDEV", 8)
LOCAL = getenv("LOCAL", 256)
DEVICES = tuple("CPU" if i == 0 else f"CPU:{i}" for i in range(NDEV))

base_np = np.arange(NDEV * LOCAL, dtype=np.float32).reshape(NDEV, LOCAL)
with Context(DEBUG=0, TRACK_MATCH_STATS=0):
  base = Tensor(base_np, dtype=dtypes.float32).realize()

with Context(ALL2ALL=2):
  with Context(DEBUG=0, TRACK_MATCH_STATS=0):
    x = base.shard(DEVICES, axis=0).contiguous().realize()
  print("\n=== allreduce + downstream elementwise consumer ===")
  y = x.sum(axis=0)
  # This intentionally consumes the allreduce result so DEBUG=4 shows the E kernel after reassembly.
  z = (y * 2.0 + 1.0).contiguous().realize()

out = z.to("CPU").numpy()
expected = base_np.sum(axis=0) * 2.0 + 1.0
np.testing.assert_allclose(out, expected)
print("got     ", out[:8])
print("expected", expected[:8])
print("PASS")
