def get_freq():
  from tinygrad.runtime.ops_amd import AMDDevice
  import tinygrad.runtime.autogen.amd_gpu as gc
  import time
  d = AMDDevice('AMD')
  adev = d.iface.dev_impl
  #print(adev.drm_dev_info.gpu_counter_freq)
  rlc32_addr = gc.GC_BASE__INST0_SEG1 + gc.regRLC_GPU_CLOCK_32

  for _ in range(5):
    v1 = adev.rreg(rlc32_addr)
    t1 = time.perf_counter_ns()
    print(t1)
    time.sleep(0.05)
    v2 = adev.rreg(rlc32_addr)
    t2 = time.perf_counter_ns()
    print(t2)
    delta = (v2 - v1) & 0xffffffff
    freq_khz = round(delta * 1_000_000 / (t2 - t1))
    print(f'  {freq_khz} KHz')

from tinygrad import Tensor, Device
from tinygrad.viz.serve import amd_decode
from extra.sqtt.roc import decode

start = read_gpu_clock_64()
Tensor.empty(32).add(1).realize()
end = read_gpu_clock_64()

sqtt = [s for s in Device[Device.DEFAULT].profile_events if type(s).__name__ == "ProfileSQTTEvent"]
disasms = {(s.name, s.tag):amd_decode(s.lib, "gfx11000") for s in Device[Device.DEFAULT].profile_events if type(s).__name__ == "ProfileProgramEvent"}
for s in sqtt:
  r = decode([s], disasms)
  vals = [x[1] for x in r.realtime[s.se]]
  if vals:
    print(s.se, min(vals), max(vals), start, end)

