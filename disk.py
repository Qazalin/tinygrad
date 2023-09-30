from examples.gpt2 import get_url
from extra.utils import fetch_as_file
from tinygrad.nn.state import torch_load

weights = torch_load(fetch_as_file(get_url("gpt2-medium")))
name='wte.weight'
params = weights[name]
print("CPU ------------------")
print(params.numpy())
print("GPU ------------------")
print(params.to("GPU").numpy())
print("METAL ------------------")
print(params.to("METAL").numpy())
