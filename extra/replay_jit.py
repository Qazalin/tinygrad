import pickle
from tinygrad.engine.realize import run_linear

with open("/tmp/linear.pkl", "rb") as f: linear, var_vals = pickle.load(f)
run_linear(linear, var_vals)
