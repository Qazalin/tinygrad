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

# https://github.com/ROCm/rocprofiler-sdk/blob/fd6f96ffb54054b405a6f05f800c64394126672d/source/lib/rocprofiler-sdk/thread_trace/dl.cpp#L43
att_parse_data_fn = lib.rocprof_trace_decoder_parse_data
att_info_fn = lib.rocprof_trace_decoder_get_info_string
att_status_fn = lib.rocprof_trace_decoder_get_status_string
