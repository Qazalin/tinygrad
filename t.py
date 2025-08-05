import ctypes, pickle, contextlib, io, enum
from tinygrad.helpers import temp
from tinygrad.runtime.ops_amd import ProfileSQTTEvent
from tinygrad.device import Device, ProfileProgramEvent
from tinygrad.viz.sqtt_parser import Wave, RecordType, PC, TraceData, att_parse_data_fn, se_data_callback_t, trace_callback_t, isa_callback_t
from tinygrad.viz.sqtt_parser_types import InstCategory
from tinygrad.viz.sqtt_parser import sqtt_parse, isa_map

if __name__ == "__main__":
  with open(temp("profile.pkl", append_user=True), "rb") as f: profile = pickle.load(f)
  for pc,inst in sqtt_parse(profile).items():
    isa = isa_map[pc]
    cat = InstCategory(inst.category).name if inst.category in InstCategory._value2member_map_ else f"UNKNOWN({inst.category})"
    print(f"PC=0x{pc:012x} {isa:<50} time={inst.time}, duration={inst.duration}, stall={inst.stall}, category={cat:<8}")
