import tinygrad.runtime.autogen.amd_gpu as gc
from tinygrad import Tensor, Device
import time

d = Device[Device.DEFAULT]
adev = d.iface.dev_impl

capture_addr = gc.GC_BASE__INST0_SEG1 + gc.regRLC_CAPTURE_GPU_CLOCK_COUNT
lsb_addr = gc.GC_BASE__INST0_SEG1 + gc.regRLC_GPU_CLOCK_COUNT_LSB
msb_addr = gc.GC_BASE__INST0_SEG1 + gc.regRLC_GPU_CLOCK_COUNT_MSB

def read_gpu_clock_64():
  adev.wreg(capture_addr, 1)
  lo = adev.rreg(lsb_addr)
  hi = adev.rreg(msb_addr)
  return (hi << 32) | lo

a = read_gpu_clock_64()
time.sleep(0.1)
b = read_gpu_clock_64()

def format_gpu_time(ticks):
  seconds = ticks * 10e-9
  hours = int(seconds // 3600)
  minutes = int((seconds % 3600) // 60)
  secs = seconds % 60
  return f"{hours}h {minutes}m {secs:.3f}s"

print("ticks:", b - a)
print("ns:", (b - a) * 10)
print(format_gpu_time(a))
print(a)

start = read_gpu_clock_64()
N = 4096
x = Tensor.arange(N)
x.realize()
end = read_gpu_clock_64()

d._at_profile_finalize()
sqtt = [s for s in d.profile_events if type(s).__name__ == "ProfileSQTTEvent"]
from tinygrad.viz.serve import amd_decode
from extra.sqtt.roc import decode
disasms = {s.tag:{k+s.base:v for k,v in amd_decode(s.lib, "gfx11000").items()} for s in d.profile_events if type(s).__name__ == "ProfileProgramEvent" }

RT_BITS = 36
RT_WRAP = 1 << RT_BITS
RT_MASK = RT_WRAP - 1
RT_FREQ = 100_000_000

def unwrap_rt(vals):
  out = []
  base = 0
  prev = None
  for v in vals:
    if prev is not None and v < prev:
      base += RT_WRAP
    out.append(base + v)
    prev = v
  return out

def build_rt_anchors(pairs):
  shader = [int(x[0]) for x in pairs]
  rt = unwrap_rt([int(x[1]) for x in pairs])
  return list(zip(shader, rt))

from bisect import bisect_right

def shader_to_rt(shader_time, anchors):
  if not anchors:
    raise ValueError("no realtime anchors")

  xs = [a[0] for a in anchors]
  i = bisect_right(xs, shader_time) - 1

  if i < 0:
    i = 0
  if i >= len(anchors) - 1:
    i = len(anchors) - 2

  s0, r0 = anchors[i]
  s1, r1 = anchors[i + 1]

  if s1 == s0:
    return r0

  return r0 + (shader_time - s0) * (r1 - r0) / (s1 - s0)

def shader_to_seconds(shader_time, anchors):
  return shader_to_rt(shader_time, anchors) / RT_FREQ


def fmt_ns(ns):
  if ns < 1_000:
    return f"{ns:.0f} ns"
  if ns < 1_000_000:
    return f"{ns/1_000:.3f} us"
  if ns < 1_000_000_000:
    return f"{ns/1_000_000:.3f} ms"
  return f"{ns/1_000_000_000:.6f} s"

def shader_to_rt(shader_time, anchors):
  from bisect import bisect_right

  xs = [a[0] for a in anchors]
  i = bisect_right(xs, shader_time) - 1
  if i < 0: i = 0
  if i >= len(anchors) - 1: i = len(anchors) - 2

  s0, r0 = anchors[i]
  s1, r1 = anchors[i + 1]
  if s1 == s0: return r0
  return r0 + (shader_time - s0) * (r1 - r0) / (s1 - s0)

def print_inst_timeline(wave, anchors, rt_freq=100_000_000):
  insts = list(wave.unpack_insts())
  if not insts:
    return

  first_rt = shader_to_rt(insts[0].time, anchors)
  prev_end_ns = None

  for i,inst in enumerate(insts):
    start_rt = shader_to_rt(inst.time, anchors)
    end_rt = shader_to_rt(inst.time + inst.dur, anchors)

    start_ns = (start_rt - first_rt) * 1_000_000_000 / rt_freq
    end_ns = (end_rt - first_rt) * 1_000_000_000 / rt_freq
    dur_ns = end_ns - start_ns

    gap = ""
    if prev_end_ns is not None:
      gap_ns = start_ns - prev_end_ns
      if abs(gap_ns) >= 0.5:
        gap = f"  gap {fmt_ns(gap_ns)}"

    if i == len(insts) - 1:
      print(f"{fmt_ns(start_ns):>10}  +{fmt_ns(dur_ns):>10}  {inst.typ}{gap}")
    prev_end_ns = end_ns

for s in sqtt:
  r = decode([s], disasms)
  if not r.inst_execs: continue
  vals = [x[1] for x in r.realtime[s.se]]
  print(s.se, min(vals), max(vals), start, end)
  anchors = build_rt_anchors(r.realtime[s.se])
  wave = list(r.inst_execs.values())[0][0]
  print_inst_timeline(wave, anchors)
