from __future__ import annotations
import json, math
from pathlib import Path
from tinygrad import Tensor, nn, TinyJit
from tinygrad.nn.state import safe_load, load_state_dict
from tinygrad.tts.model import Attention, DecoderLayer


class CausalConv:
  def __init__(self, in_channels:int, out_channels:int, kernel_size:int, dilation:int=1, stride:int=1, groups:int=1, bias:bool=True):
    self.conv = nn.Conv1d(in_channels, out_channels, kernel_size, stride=stride, dilation=dilation, groups=groups, bias=bias)
    self.stride, self.kernel_size = stride, (kernel_size-1)*dilation+1
    self.padding = self.kernel_size-stride

  def __call__(self, x:Tensor) -> Tensor:
    frames = (x.shape[-1]-self.kernel_size+self.padding) / self.stride + 1
    ideal = (math.ceil(frames)-1)*self.stride + self.kernel_size-self.padding
    return self.conv(x.pad((self.padding, ideal-x.shape[-1]))).contiguous()


class CausalTransConv:
  def __init__(self, in_channels:int, out_channels:int, kernel_size:int, stride:int=1):
    self.conv = nn.ConvTranspose1d(in_channels, out_channels, kernel_size, stride=stride)
    self.right_pad = kernel_size-stride
  def __call__(self, x:Tensor) -> Tensor:
    x = self.conv(x)
    return x[..., :-self.right_pad].contiguous() if self.right_pad else x.contiguous()


class SnakeBeta:
  def __init__(self, channels:int): self.alpha, self.beta = Tensor.zeros(channels), Tensor.zeros(channels)
  def __call__(self, x:Tensor) -> Tensor:
    alpha, beta = self.alpha.exp().reshape(1,-1,1), self.beta.exp().reshape(1,-1,1)
    return x + (x*alpha).sin().square() / (beta+1e-9)


class ResidualUnit:
  def __init__(self, dim:int, dilation:int):
    self.act1, self.conv1 = SnakeBeta(dim), CausalConv(dim, dim, 7, dilation=dilation)
    self.act2, self.conv2 = SnakeBeta(dim), CausalConv(dim, dim, 1)
  def __call__(self, x:Tensor) -> Tensor: return x + self.conv2(self.act2(self.conv1(self.act1(x))))


class DecoderBlock:
  def __init__(self, in_dim:int, out_dim:int, rate:int):
    self.block = [SnakeBeta(in_dim), CausalTransConv(in_dim, out_dim, 2*rate, rate),
                  ResidualUnit(out_dim, 1), ResidualUnit(out_dim, 3), ResidualUnit(out_dim, 9)]
  def __call__(self, x:Tensor) -> Tensor:
    for block in self.block: x = block(x)
    return x


class ConvNeXtBlock:
  def __init__(self, dim:int):
    self.dwconv = CausalConv(dim, dim, 7, groups=dim)
    self.norm, self.pwconv1, self.pwconv2 = nn.LayerNorm(dim, eps=1e-6), nn.Linear(dim, 4*dim), nn.Linear(4*dim, dim)
    self.gamma = Tensor.ones(dim)
  def __call__(self, x:Tensor) -> Tensor:
    h = self.dwconv(x).transpose(1,2)
    h = self.pwconv2(self.pwconv1(self.norm(h)).gelu()) * self.gamma
    return x + h.transpose(1,2)


class DecoderTransformer:
  def __init__(self, cfg:dict):
    d, hd = cfg["hidden_size"], cfg["head_dim"]
    self.layers = [DecoderLayer(d, cfg["intermediate_size"], cfg["num_attention_heads"], cfg["num_key_value_heads"], hd,
                  cfg["rms_norm_eps"], cfg["rope_theta"], cfg["max_position_embeddings"], qk_norm=False, layer_scale=True)
                   for _ in range(cfg["num_hidden_layers"])]
    self.norm = nn.RMSNorm(d, cfg["rms_norm_eps"])
    self.input_proj, self.output_proj = nn.Linear(cfg["latent_dim"], d), nn.Linear(d, cfg["latent_dim"])
    self.window = cfg["sliding_window"]
  def __call__(self, x:Tensor) -> Tensor:
    x = self.input_proj(x)
    # Full-sequence decode uses the same causal sliding window in every layer.
    for layer in self.layers: x = layer(x, 0, cache=False, window=self.window)
    return self.output_proj(self.norm(x))


class EuclideanCodebook:
  def __init__(self, size:int, dim:int):
    self.cluster_usage, self.embedding_sum = Tensor.ones(size), Tensor.zeros(size, dim)
  def decode(self, codes:Tensor) -> Tensor:
    return (self.embedding_sum / self.cluster_usage.maximum(1e-5).unsqueeze(1))[codes]


class VectorQuantization:
  def __init__(self, size:int, dim:int): self._codebook = EuclideanCodebook(size, dim)
  def decode(self, codes:Tensor) -> Tensor: return self._codebook.decode(codes).transpose(1,2)


class VQLayers:
  def __init__(self, count:int, size:int, dim:int): self.layers = [VectorQuantization(size, dim) for _ in range(count)]


class ResidualVQ:
  def __init__(self, count:int, size:int, code_dim:int, out_dim:int):
    self.input_proj = nn.Conv1d(out_dim, code_dim, 1, bias=False)
    self.output_proj = nn.Conv1d(code_dim, out_dim, 1, bias=False)
    self.vq = VQLayers(count, size, code_dim)
  def decode(self, codes:Tensor) -> Tensor:
    out = self.vq.layers[0].decode(codes[:, 0])
    for i in range(1, codes.shape[1]): out = out + self.vq.layers[i].decode(codes[:, i])
    return self.output_proj(out)


class SplitQuantizer:
  def __init__(self, cfg:dict):
    self.rvq_first = ResidualVQ(1, cfg["codebook_size"], cfg["codebook_dim"]//2, cfg["codebook_dim"])
    self.rvq_rest = ResidualVQ(cfg["num_quantizers"]-1, cfg["codebook_size"], cfg["codebook_dim"]//2, cfg["codebook_dim"])
  def decode(self, codes:Tensor) -> Tensor:
    return self.rvq_first.decode(codes[:, :1]) + self.rvq_rest.decode(codes[:, 1:])


class CodecDecoder:
  def __init__(self, cfg:dict):
    self.quantizer = SplitQuantizer(cfg)
    self.pre_conv = CausalConv(cfg["codebook_dim"], cfg["latent_dim"], 3)
    self.pre_transformer = DecoderTransformer(cfg)
    self.upsample = [[CausalTransConv(cfg["latent_dim"], cfg["latent_dim"], f, f), ConvNeXtBlock(cfg["latent_dim"])]
                     for f in cfg["upsampling_ratios"]]
    dims = [cfg["decoder_dim"]//(2**i) for i in range(len(cfg["upsample_rates"])+1)]
    self.decoder = [CausalConv(cfg["latent_dim"], cfg["decoder_dim"], 7)] + \
      [DecoderBlock(dims[i], dims[i+1], rate) for i,rate in enumerate(cfg["upsample_rates"])] + \
      [SnakeBeta(dims[-1]), CausalConv(dims[-1], 1, 7)]
    self.total_upsample = math.prod(cfg["upsample_rates"] + cfg["upsampling_ratios"])
    self.decode_jit:dict[int,TinyJit] = {}

  def forward(self, codes:Tensor) -> Tensor:
    x = self.quantizer.decode(codes)
    x = self.pre_transformer(self.pre_conv(x).transpose(1,2)).transpose(1,2)
    for pair in self.upsample:
      for block in pair: x = block(x)
    for block in self.decoder: x = block(x)
    return x.clip(-1, 1)

  def __call__(self, codes:Tensor) -> Tensor:
    if codes.shape[-1] not in self.decode_jit: self.decode_jit[codes.shape[-1]] = TinyJit(self.forward)
    return self.decode_jit[codes.shape[-1]](codes.contiguous())

  def chunked_decode(self, codes:Tensor, chunk_size:int=300, left_context:int=25, fixed_shape:bool=False) -> Tensor:
    wavs:list[Tensor] = []
    for start in range(0, codes.shape[-1], chunk_size):
      context = min(left_context, start)
      end = min(start+chunk_size, codes.shape[-1])
      part = codes[..., start-context:end]
      if fixed_shape:
        target = chunk_size + (left_context if start else 0)
        if part.shape[-1] < target: part = part.pad((0, target-part.shape[-1]))
      wavs.append(self(part)[..., context*self.total_upsample:(context+end-start)*self.total_upsample])
    return Tensor.cat(*wavs, dim=-1)


class EncoderResidual:
  def __init__(self, dim:int, compress:int, kernel:int, dilation:int):
    self.block = [None, CausalConv(dim, dim//compress, kernel, dilation=dilation), None, CausalConv(dim//compress, dim, 1)]
  def __call__(self, x:Tensor) -> Tensor:
    return x + self.block[3](self.block[1](x.elu()).elu())


class SEANetEncoder:
  def __init__(self, cfg:dict):
    layers:list = [CausalConv(cfg["audio_channels"], cfg["num_filters"], cfg["kernel_size"])]
    scale = 1
    for ratio in reversed(cfg["upsampling_ratios"]):
      dim = scale*cfg["num_filters"]
      for j in range(cfg["num_residual_layers"]): layers += [EncoderResidual(dim, cfg["compress"], cfg["residual_kernel_size"], cfg["dilation_growth_rate"]**j)]
      layers += [None, CausalConv(dim, dim*2, ratio*2, stride=ratio)]
      scale *= 2
    layers += [None, CausalConv(scale*cfg["num_filters"], cfg["hidden_size"], cfg["last_kernel_size"])]
    self.layers = layers
  def __call__(self, x:Tensor) -> Tensor:
    for layer in self.layers: x = x.elu() if layer is None else layer(x)
    return x


class EncoderMLP:
  def __init__(self, dim:int, hidden:int): self.fc1, self.fc2 = nn.Linear(dim, hidden, bias=False), nn.Linear(hidden, dim, bias=False)
  def __call__(self, x:Tensor) -> Tensor: return self.fc2(self.fc1(x).gelu(approximate="none"))


class EncoderTransformerLayer:
  def __init__(self, cfg:dict):
    d, hd = cfg["hidden_size"], cfg["head_dim"]
    self.self_attn = Attention(d, cfg["num_attention_heads"], cfg["num_key_value_heads"], hd, cfg["norm_eps"], cfg["rope_theta"],
                              cfg["max_position_embeddings"], qk_norm=False)
    self.mlp = EncoderMLP(d, cfg["intermediate_size"])
    self.input_layernorm = nn.LayerNorm(d, eps=cfg["norm_eps"])
    self.post_attention_layernorm = nn.LayerNorm(d, eps=cfg["norm_eps"])
    self.self_attn_layer_scale, self.mlp_layer_scale = {"scale":Tensor.ones(d)}, {"scale":Tensor.ones(d)}
  def __call__(self, x:Tensor, window:int) -> Tensor:
    x = x + self.self_attn(self.input_layernorm(x), 0, cache=False, window=window) * self.self_attn_layer_scale["scale"]
    return x + self.mlp(self.post_attention_layernorm(x)) * self.mlp_layer_scale["scale"]


class EncoderTransformer:
  def __init__(self, cfg:dict): self.layers = [EncoderTransformerLayer(cfg) for _ in range(cfg["num_hidden_layers"])]
  def __call__(self, x:Tensor) -> Tensor:
    for layer in self.layers: x = layer(x, self.window)
    return x


class EncoderCodebook:
  def __init__(self, size:int, dim:int):
    self.cluster_usage, self.embed_sum, self.initialized = Tensor.ones(size), Tensor.zeros(size, dim), Tensor.ones(1)
  def embeddings(self) -> Tensor: return self.embed_sum / self.cluster_usage.maximum(1e-5).unsqueeze(1)


class EncoderVQ:
  def __init__(self, count:int, cfg:dict):
    self.input_proj = nn.Conv1d(cfg["hidden_size"], cfg["codebook_dim"], 1, bias=False)
    self.output_proj = nn.Conv1d(cfg["codebook_dim"], cfg["hidden_size"], 1, bias=False)
    self.layers = [{"codebook":EncoderCodebook(cfg["codebook_size"], cfg["codebook_dim"])} for _ in range(count)]
  def encode(self, x:Tensor, count:int) -> Tensor:
    residual, codes = self.input_proj(x).transpose(1,2), []
    for layer in self.layers[:count]:
      emb = layer["codebook"].embeddings().float()
      flat = residual.float().reshape(-1, residual.shape[-1])
      dist = flat.square().sum(1, keepdim=True) + emb.square().sum(1).reshape(1,-1) - 2*(flat @ emb.T)
      code = dist.argmin(-1).reshape(residual.shape[0], residual.shape[1])
      residual = residual - emb[code].cast(residual.dtype)
      codes.append(code)
    return Tensor.stack(*codes, dim=1)


class EncoderQuantizer:
  def __init__(self, cfg:dict):
    self.semantic_residual_vector_quantizer = EncoderVQ(cfg["num_semantic_quantizers"], cfg)
    self.acoustic_residual_vector_quantizer = EncoderVQ(cfg["num_quantizers"]-cfg["num_semantic_quantizers"], cfg)
  def encode(self, x:Tensor, count:int) -> Tensor:
    semantic = self.semantic_residual_vector_quantizer.encode(x, 1)
    acoustic = self.acoustic_residual_vector_quantizer.encode(x, count-1)
    return Tensor.cat(semantic, acoustic, dim=1)


class CodecEncoder:
  def __init__(self, cfg:dict, valid_quantizers:int=16):
    self.encoder = SEANetEncoder(cfg)
    self.encoder_transformer = EncoderTransformer(cfg)
    self.encoder_transformer.window = cfg["sliding_window"]
    self.downsample = CausalConv(cfg["hidden_size"], cfg["hidden_size"], 4, stride=2, bias=False)
    self.quantizer = EncoderQuantizer(cfg)
    self.valid_quantizers = valid_quantizers
  def __call__(self, wav:Tensor) -> Tensor:
    x = self.encoder(wav.reshape(wav.shape[0], 1, -1))
    x = self.encoder_transformer(x.transpose(1,2)).transpose(1,2)
    return self.quantizer.encode(self.downsample(x), self.valid_quantizers)


class Qwen3TTSCodec:
  def __init__(self, config:dict, encoder:bool=False):
    self.decoder = CodecDecoder(config["decoder_config"])
    if encoder: self.encoder = CodecEncoder(config["encoder_config"], config["encoder_valid_num_quantizers"])

  @staticmethod
  def from_pretrained(path:str|Path, realize:bool=True, encoder:bool=False) -> "Qwen3TTSCodec":
    path = Path(path)
    model = Qwen3TTSCodec(json.loads((path/"config.json").read_text()), encoder)
    state = {k:v for k,v in safe_load(path/"model.safetensors").items() if k.startswith("decoder.") or (encoder and k.startswith("encoder."))}
    load_state_dict(model, state, strict=True, consume=True, realize=False)
    if realize:
      params = nn.state.get_parameters(model)
      for p in params: p.replace(p.contiguous())
      Tensor.realize(*params)
    return model
