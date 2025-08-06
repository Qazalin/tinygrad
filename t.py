import pickle
from tinygrad.helpers import temp
from tinygrad.viz.sqtt_pkt_decoder import decode_sqtt_packets

with open(fn:=temp("profile.pkl", append_user=True), "rb") as f: profile = pickle.load(f)
decode_sqtt_packets(profile)
