import subprocess, pickle, datetime, time, bisect
from decimal import Decimal
import xml.etree.ElementTree as ET
from tinygrad.helpers import Timing, unwrap, temp, ProfileRangeEvent

def xctrace_export(*schemas:tuple[str, ...]):
  return subprocess.Popen(["xctrace", "export", "--input", "/tmp/metal.trace", "--xpath",
                           '/trace-toc/run[@number="1"]/data/table[' +' or '.join(f'@schema="{s}"' for s in schemas)+']'], stdout=subprocess.PIPE)

from tinygrad.helpers import diskcache
@diskcache
def parse_xml(st):
  proc = xctrace_export(st)
  cols:list[str] = []
  id_cache:dict[int, str] = {}
  for _,e in ET.iterparse(proc.stdout, events=("end",)):
    if (cid:=e.attrib.get("id")) is not None: id_cache[cid] = unwrap(e.text)
    if e.tag == "col": cols.append(unwrap(next(iter(e)).text))
    if e.tag == "row": yield {k:id_cache.get(v.attrib.get("ref"), v.text) for k,v in zip(cols, e)}

@diskcache
def get_trace_start():
  toc_proc = subprocess.run(["xctrace", "export", "--input", "/tmp/metal.trace", "--toc"], capture_output=True, text=True)
  return unwrap(unwrap(ET.fromstring(toc_proc.stdout).find(".//start-date")).text)

with open(temp("profile.pkl", append_user=True), "rb") as f: profile = pickle.load(f)
cmds:list[ProfileRangeEvent] = []
for p in profile:
  if isinstance(p, ProfileRangeEvent) and p.device == "METAL": cmds.append(p)

trace_wt = int(Decimal(datetime.datetime.fromisoformat("2025-07-25T09:11:49.426+03:00").timestamp())*Decimal(1e9))
trace_perf_ns = trace_wt-(time.time_ns()-time.perf_counter_ns())

counter_info = parse_xml("gpu-counter-info")

from collections import Counter

def aggregate_overlapping(cmds, samples, init_agg, finalize_agg):
  """
  Stream‑join cmds and samples by timestamp.
  cmds: list of objects with .st (start_ns), .en (end_ns)
  samples: iterator yielding objects with .timestamp and .values
  init_agg(cmd) → aggregator with .add(sample)
  finalize_agg(aggregator) → summary
  Yields: (cmd, summary_dict)
  """
  # 1) build & sort start/end events
  events = []
  for c in cmds:
    events.append((c.st, "start", c))
    events.append((c.en, "end",   c))
  events.sort(key=lambda e: e[0])

  active = {}       # cmd → agg
  ei = 0
  n_event = len(events)

  # 2) stream through samples
  for v in samples:
    t = int(v["timestamp"])+trace_perf_ns
    # process all cmd‑events up to this sample
    while ei < n_event and events[ei][0] <= t:
      _, kind, c = events[ei]
      if kind == "start":
        active[c.name] = init_agg(c)
      else:  # "end"
        agg = active.pop(c.name, None)
        if agg is not None:
          yield c, finalize_agg(agg)
      ei += 1

    # dispatch sample to all active aggs
    for agg in active.values():
      agg.add(v)

  # 3) flush any cmds whose end > last sample
  while ei < n_event:
    _, kind, c = events[ei]
    if kind == "end":
      agg = active.pop(c, None)
      if agg is not None:
        yield c, finalize_agg(agg)
    ei += 1


# ——— Example aggregation logic ———

def init_agg(cmd):
  """Create a per‑cmd Counter aggregator."""
  return Counter()

def finalize_agg(counter):
  """Return a plain dict of summed counters."""
  return dict(counter)

def add(self, sample):
  """Mix-in for Counter: add sample.values into the counter."""
  for k, v in sample.values.items():
    self[k] += v

# Monkey‑patch Counter.add for convenience
Counter.add = add


# ——— Usage ———

if __name__ == "__main__":
  samples = parse_xml("gpu-counter-value")
  for cmd, summary in aggregate_overlapping(cmds, samples, init_agg, finalize_agg):
    print(f"{cmd.name} [{cmd.st}–{cmd.en}]:")
    for counter_name, total in summary.items():
      print(f"  {counter_name:20s} {total}")
    print()
