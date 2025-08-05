import pickle, subprocess, sys, os
from tinygrad.runtime.ops_amd import ProfileSQTTEvent
from tinygrad.device import ProfileProgramEvent
from tinygrad.helpers import getenv, temp

with open(temp("profile.pkl", append_user=True), "rb") as f: profile = pickle.load(f)
for e in profile:
  if isinstance(e, ProfileProgramEvent):
    byte_len = (e.base.bit_length()+7)//8
    le_bytes = e.base.to_bytes(byte_len, byteorder="little")
    print(e.name, e.base)
  if isinstance(e, ProfileSQTTEvent):
    #subprocess.run("xxd", input=e.blob, stdout=open(f"sqtt/{e.se}.hex", "w"), check=True)
    print(len(e.blob))
