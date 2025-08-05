import pickle, subprocess, sys, os, ctypes
from tinygrad.runtime.ops_amd import ProfileSQTTEvent
from tinygrad.device import ProfileProgramEvent
from tinygrad.helpers import getenv, temp

if not os.path.exists(fn:=temp("buf.att")):
  with open(temp("profile.pkl", append_user=True), "rb") as f: profile = pickle.load(f)
  for e in profile:
    if isinstance(e, ProfileSQTTEvent):
      with open(fn, "wb") as f: f.write(e.blob)
      break

with open(fn, "rb") as f: raw = f.read()
lib = ctypes.CDLL("/opt/rocm/lib/librocprof-trace-decoder.so")
print(lib)
