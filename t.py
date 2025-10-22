import pickle
from extra.sqtt.roc import decode_sqtt

with open("/tmp/profile.pkl.root", "rb") as f: profile = pickle.load(f)
ret = decode_sqtt(profile).output
print(ret.occ[0].time)
print(ret.occ[1].time)
