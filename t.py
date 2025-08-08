import pickle
from typing import Generator
from tinygrad.helpers import temp

def get_sqtt(name:str, profile):
  from tinygrad.viz.sqtt_pkt_decoder import decode_sqtt_packets
  def find_program(name:str, profile) -> Generator[dict, None, None]:
    i = 0
    found = None
    for pkt in decode_sqtt_packets(profile):
      if pkt["type"] == "prg" and pkt["prg"]["name"] == name: found = pkt["prg"]
      if not found or pkt["type"] != "inst": continue
      if i > pkt["idx"]:
        rem = found["asm"][i:pkt["idx"]]
        for r in rem: yield {"code":r, "duration":0, "stall":0}
      yield pkt
      i += 1

  max_clks = 0
  instruction_timing = []
  for e in find_program(name, profile):
    total_clk = e["duration"]
    if total_clk > max_clks: max_clks = total_clk
    instruction_timing.append(e)

  rows = []
  for e in instruction_timing:
    total_clk = e["duration"]
    scale = total_clk/max_clks
    stall = e["stall"]
    stall_pct = ((stall/total_clk)*100)*scale
    hidden_pct = (100*scale)-stall_pct
    rows.append([e["code"], [stall_pct, hidden_pct]])
  return {"rows":rows, "cols":["Opcode", {"title":"Latency", "labels":["Stall", "Hidden"]}], "summary":[]}

with open(fn:=temp("profile.pkl", append_user=True), "rb") as f: profile = pickle.load(f)
print(get_sqtt("E_3", profile))
