import subprocess, pickle
import xml.etree.ElementTree as ET
from tinygrad.helpers import Timing, unwrap

def xctrace_export(*schemas:tuple[str, ...]):
  return subprocess.Popen(["xctrace", "export", "--input", "/tmp/metal.trace", "--xpath",
                           '/trace-toc/run[@number="1"]/data/table[' +' or '.join(f'@schema="{s}"' for s in schemas)+']'], stdout=subprocess.PIPE)

convert_xml = {}

from tinygrad.helpers import diskcache
@diskcache
def parse_xml(st):
  proc = xctrace_export(st)
  cols:list[str] = []
  ret:list[dict] = []
  id_cache:dict[int, str] = {}
  for _,e in ET.iterparse(proc.stdout, events=("end",)):
    if (cid:=e.attrib.get("id")) is not None: id_cache[cid] = unwrap(e.text)
    if e.tag == "col": cols.append(unwrap(next(iter(e)).text))
    if e.tag == "row": ret.append({k:convert_xml.get(v.tag, str)(id_cache.get(v.attrib.get("ref"), v.text)) for k,v in zip(cols, e)})
  return ret

counter_info = parse_xml("gpu-counter-info")
ret = parse_xml("gpu-counter-value")
print(counter_info)
