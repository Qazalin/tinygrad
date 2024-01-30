#type:ignore
from tinygrad import Tensor
from examples.llama import Transformer, MODEL_PARAMS
from tinygrad.dtype import dtypes
from tinygrad.nn.state import get_state_dict

#config = {"dim": 2, "n_heads": 2, "n_layers": 2, "norm_eps": 1e-06, "vocab_size": 24, "hidden_dim": 2}
config = MODEL_PARAMS["1"]["7B"]["args"]
Tensor.manual_seed(1337)
dtypes.default_float = dtypes.float16
mdl = Transformer(**config)
state = get_state_dict(mdl)
print(state["layers.0.attention.wq.weight"].numpy())

#   def __call__(self, tokens:Tensor, start_pos:Variable, temperature:float=0.0):
#mdl(Tensor([1, 6601]), 0)
