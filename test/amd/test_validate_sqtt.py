# validate SQTT traces against rocprof decoder
import sys, pickle
from tinygrad.helpers import temp
from test.amd.test_sqttmap import rocprof_inst_traces_match

if __name__ == "__main__":
  with open(temp("profile.pkl", append_user=True) if len(sys.argv) < 2 else sys.argv[1], "rb") as f:
    data = pickle.load(f)
  prg_events = {e.tag: e for e in data if type(e).__name__ == "ProfileProgramEvent" and e.tag is not None}
  sqtt_events = [e for e in data if type(e).__name__ == "ProfileSQTTEvent"]
  dev_targets = {e.device: f"gfx{e.props['gfx_target_version']//1000}" for e in data if type(e).__name__ == "ProfileDeviceEvent" and e.props}

  for i, event in enumerate(sqtt_events):
    if not event.itrace: continue
    prg = prg_events.get(event.kern)
    if prg is None: continue
    target = dev_targets[prg.device]
    print(f"=== event {i} {prg.name} ===")
    passed_insts, n_waves, n_units = rocprof_inst_traces_match(event, prg, target)
    if n_waves: print(f"  passed for {passed_insts} instructions across {n_waves} waves scheduled on {n_units} wave units")
