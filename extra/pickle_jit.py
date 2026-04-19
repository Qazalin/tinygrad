#!/usr/bin/env python3
"""Capture the forward-pass linear UOp *without* executing it, so the hang can be
reproduced in a fresh process. Model loading runs normally; the hook is installed
right before generate() so loading isn't intercepted."""
import os, sys, pickle
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from tinygrad import Tensor
from tinygrad.llm.model import Transformer
from tinygrad.llm.cli import models

print("loading model...", flush=True)
raw = Tensor.from_url(models["qwen3.5:27b"])
model, kv = Transformer.from_gguf(raw, 4096)
print("model loaded", flush=True)
del raw
import gc; gc.collect()

# now install the interceptor — only the forward pass runs from here
from tinygrad.engine import realize as realize_mod
import tinygrad.tensor as tensor_mod

captured = []
class DoneMarker(Exception): pass
def recording_run_linear(linear, var_vals=None, do_update_stats=True):
  captured.append((linear, dict(var_vals) if var_vals else None))
  print(f"captured linear #{len(captured)} with {len(linear.src)} calls", flush=True)
  # the big forward-pass linear is the one with many calls. stop once we see it.
  if len(linear.src) > 100: raise DoneMarker()
realize_mod.run_linear = recording_run_linear
tensor_mod.run_linear = recording_run_linear

try:
  list(zip(range(1), model.generate([0])))
except DoneMarker:
  print("captured forward-pass linear, skipping execution", flush=True)

if not captured:
  print("no linear captured", flush=True); sys.exit(1)

linear, var_vals = max(captured, key=lambda x: len(x[0].src))  # the big forward-pass linear
print(f"pickling linear with {len(linear.src)} calls ...", flush=True)
with open("/tmp/linear.pkl", "wb") as f: pickle.dump((linear, var_vals), f)
print(f"saved /tmp/linear.pkl ({os.path.getsize('/tmp/linear.pkl')} bytes)", flush=True)
