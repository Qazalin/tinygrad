from __future__ import annotations
import functools, json, math
from dataclasses import dataclass
from pathlib import Path
from tinygrad import Tensor, nn, dtypes, TinyJit, UOp
from tinygrad.nn.state import safe_load, load_state_dict
from tinygrad.tts.speaker import SpeakerEncoder, mel_spectrogram


@dataclass
class VoiceClonePrompt:
  codes:Tensor                 # (frames, 16)
  speaker_embedding:Tensor     # (2048,)
  text_ids:list[int]


def sample_logits(logits:Tensor, first:bool, temperature:float, top_k:int, random:Tensor|None=None) -> Tensor:
  logits = logits.float()
  if first:
    ids = Tensor.arange(logits.shape[-1]).to(logits.device)
    valid = (ids < 2048) | (ids == 2150)
    logits = valid.where(logits, float("-inf"))
  if temperature <= 0: return logits.argmax(-1, keepdim=True)
  # Parallel rejection sampling avoids constructing the full top-k. Conditioning categorical samples on membership
  # in the top-k is the desired distribution; eight candidates makes the fallback probability negligible here.
  count = 8 if top_k and top_k < logits.shape[-1] else 1
  expanded = logits.expand(count, logits.shape[-1])
  cdf = (logits / temperature).softmax(-1).cumsum(-1)
  random = Tensor.rand(count, 1, device=logits.device) if random is None else random
  candidates = (cdf.expand(count, cdf.shape[-1]) < random).sum(-1, keepdim=True).cast('int32')
  if count == 1: return candidates
  candidate_logits = expanded.gather(-1, candidates)
  accepted = (expanded > candidate_logits).sum(-1) < top_k
  first_accepted = accepted.argmax().reshape(1)
  selected = candidates.flatten().gather(0, first_accepted).reshape(1,1)
  return accepted.any().where(selected, logits.argmax(-1, keepdim=True))


class Attention:
  def __init__(self, dim:int, heads:int, kv_heads:int, head_dim:int, eps:float, theta:float, max_context:int, qk_norm:bool=True):
    self.heads, self.kv_heads, self.head_dim = heads, kv_heads, head_dim
    self.theta, self.max_context = theta, max_context
    self.q_proj, self.k_proj = nn.Linear(dim, heads*head_dim, bias=False), nn.Linear(dim, kv_heads*head_dim, bias=False)
    self.v_proj, self.o_proj = nn.Linear(dim, kv_heads*head_dim, bias=False), nn.Linear(heads*head_dim, dim, bias=False)
    self.q_norm = nn.RMSNorm(head_dim, eps) if qk_norm else None
    self.k_norm = nn.RMSNorm(head_dim, eps) if qk_norm else None

  def _rope(self, x:Tensor, pos:Tensor) -> Tensor:
    inv = 1.0 / (self.theta ** (Tensor.arange(0, self.head_dim, 2).to(x.device).float() / self.head_dim))
    freqs = pos.float().reshape(-1, 1) * inv.reshape(1, -1)
    cos, sin = freqs.cos().cat(freqs.cos(), dim=-1), freqs.sin().cat(freqs.sin(), dim=-1)
    x1, x2 = x.chunk(2, dim=-1)
    return x * cos.reshape(1, 1, -1, self.head_dim) + (-x2).cat(x1, dim=-1) * sin.reshape(1, 1, -1, self.head_dim)

  def __call__(self, x:Tensor, start_pos:int|UOp, cache:bool=True, window:int|None=None, cache_tensor:Tensor|None=None) -> Tensor:
    B,T,_ = x.shape
    q = self.q_proj(x).reshape(B,T,self.heads,self.head_dim).transpose(1,2)
    k = self.k_proj(x).reshape(B,T,self.kv_heads,self.head_dim).transpose(1,2)
    v = self.v_proj(x).reshape(B,T,self.kv_heads,self.head_dim).transpose(1,2)
    if self.q_norm is not None: q, k = self.q_norm(q), self.k_norm(k)
    pos = Tensor.arange(start_pos, start_pos+T).to(x.device)
    q, k = self._rope(q, pos), self._rope(k, pos)
    if cache:
      if cache_tensor is not None: cache_kv = cache_tensor
      else:
        if not hasattr(self, "cache_kv"):
          self.cache_kv = Tensor.empty(2, B, self.kv_heads, self.max_context, self.head_dim, dtype=x.dtype, device=x.device)
        cache_kv = self.cache_kv
      stored = Tensor(cache_kv.uop.after(cache_kv[:, :, :, start_pos:start_pos+T].uop.store(Tensor.stack(k, v).uop)))
      begin = max(0, start_pos+T-window) if window and isinstance(start_pos, int) else 0
      k, v = stored[0,:,:,begin:start_pos+T], stored[1,:,:,begin:start_pos+T]
    mask = None
    if T != 1:
      key_len = k.shape[-2]
      mask = Tensor.full((1,1,T,key_len), float("-inf"), dtype=x.dtype, device=x.device).triu(key_len-T+1)
      if window:
        qi = Tensor.arange(T).to(x.device).reshape(T,1) + key_len-T
        ki = Tensor.arange(key_len).to(x.device).reshape(1,key_len)
        mask = ((ki < qi-window+1).reshape(1,1,T,key_len)).where(float("-inf"), mask)
    out = q.scaled_dot_product_attention(k, v, attn_mask=mask, enable_gqa=True)
    return self.o_proj(out.transpose(1,2).reshape(B,T,-1))


class MLP:
  def __init__(self, dim:int, hidden:int):
    self.gate_proj, self.up_proj, self.down_proj = nn.Linear(dim, hidden, bias=False), nn.Linear(dim, hidden, bias=False), nn.Linear(hidden, dim, bias=False)
  def __call__(self, x:Tensor) -> Tensor: return self.down_proj(self.gate_proj(x).silu() * self.up_proj(x))


class DecoderLayer:
  def __init__(self, dim:int, hidden:int, heads:int, kv_heads:int, head_dim:int, eps:float, theta:float, max_context:int,
               qk_norm:bool=True, layer_scale:bool=False):
    self.self_attn = Attention(dim, heads, kv_heads, head_dim, eps, theta, max_context, qk_norm)
    self.mlp = MLP(dim, hidden)
    self.input_layernorm, self.post_attention_layernorm = nn.RMSNorm(dim, eps), nn.RMSNorm(dim, eps)
    if layer_scale:
      self.self_attn_layer_scale = {"scale": Tensor.ones(dim)}
      self.mlp_layer_scale = {"scale": Tensor.ones(dim)}

  def __call__(self, x:Tensor, start_pos:int|UOp, cache:bool=True, window:int|None=None, cache_tensor:Tensor|None=None) -> Tensor:
    a = self.self_attn(self.input_layernorm(x), start_pos, cache, window, cache_tensor)
    if hasattr(self, "self_attn_layer_scale"): a = a * self.self_attn_layer_scale["scale"]
    x = x + a
    m = self.mlp(self.post_attention_layernorm(x))
    if hasattr(self, "mlp_layer_scale"): m = m * self.mlp_layer_scale["scale"]
    return (x + m).contiguous()


class TalkerModel:
  def __init__(self, cfg:dict, max_context:int):
    d, hd = cfg["hidden_size"], cfg["head_dim"]
    self.layers = [DecoderLayer(d, cfg["intermediate_size"], cfg["num_attention_heads"], cfg["num_key_value_heads"], hd,
                  cfg["rms_norm_eps"], cfg["rope_theta"], max_context) for _ in range(cfg["num_hidden_layers"])]
    self.norm = nn.RMSNorm(d, cfg["rms_norm_eps"])
    self.codec_embedding = nn.Embedding(cfg["vocab_size"], d)
    self.text_embedding = nn.Embedding(cfg["text_vocab_size"], cfg["text_hidden_size"])
    self.rollout_jit = TinyJit(self.forward)

  def forward(self, x:Tensor, start_pos:int|UOp) -> Tensor:
    for layer in self.layers: x = layer(x, start_pos)
    return self.norm(x)

  def __call__(self, x:Tensor, start_pos:int|UOp) -> Tensor:
    return self.forward(x, start_pos) if x.shape[1] != 1 else self.rollout_jit(x.contiguous(), start_pos)


class TextProjection:
  def __init__(self, dim:int):
    self.linear_fc1, self.linear_fc2 = nn.Linear(dim, dim, bias=True), nn.Linear(dim, dim, bias=True)
  def __call__(self, x:Tensor) -> Tensor: return self.linear_fc2(self.linear_fc1(x).silu())


class CodePredictorModel:
  def __init__(self, cfg:dict, talker_dim:int):
    d, hd = cfg["hidden_size"], cfg["head_dim"]
    self.layers = [DecoderLayer(d, cfg["intermediate_size"], cfg["num_attention_heads"], cfg["num_key_value_heads"], hd,
                  cfg["rms_norm_eps"], cfg["rope_theta"], 32) for _ in range(cfg["num_hidden_layers"])]
    self.norm = nn.RMSNorm(d, cfg["rms_norm_eps"])
    self.codec_embedding = [nn.Embedding(cfg["vocab_size"], talker_dim) for _ in range(cfg["num_code_groups"]-1)]

  def forward(self, x:Tensor, start_pos:int|UOp, cache_tensor:Tensor|None=None) -> Tensor:
    for i,layer in enumerate(self.layers): x = layer(x, start_pos, cache=True, cache_tensor=None if cache_tensor is None else cache_tensor[i])
    return self.norm(x)


  def __call__(self, x:Tensor, start_pos:int|UOp) -> Tensor:
    return self.forward(x, start_pos)


class CodePredictor:
  def __init__(self, cfg:dict, talker_dim:int):
    self.model = CodePredictorModel(cfg, talker_dim)
    self.lm_head = [nn.Linear(cfg["hidden_size"], cfg["vocab_size"], bias=False) for _ in range(cfg["num_code_groups"]-1)]
    self.small_to_mtp_projection = nn.Linear(talker_dim, cfg["hidden_size"], bias=True)
    self.cfg = cfg
    self._jit_key:tuple[float,int]|None = None
    self._step_jit:list[TinyJit] = []

  def _step(self, i:int, temperature:float, top_k:int, hidden_or_token:Tensor, random:Tensor, cache:Tensor,
            first:Tensor|None=None) -> tuple[Tensor,Tensor]:
    embedding = Tensor.cat(hidden_or_token, first, dim=1) if i == 0 and first is not None else self.model.codec_embedding[i-1](hidden_or_token)
    x = self.small_to_mtp_projection(embedding)
    logits = self.lm_head[i](self.model.forward(x, 0 if i == 0 else i+1, cache)[:, -1])
    token = sample_logits(logits, False, temperature, top_k, random)
    return token, Tensor(cache.uop.after(token.uop))

  def _get_steps(self, temperature:float, top_k:int):
    if self._jit_key != (temperature, top_k):
      self._jit_key = (temperature, top_k)
      self._step_jit = [TinyJit(functools.partial(self._step, i, temperature, top_k)) for i in range(len(self.lm_head))]
    return self._step_jit

  def _generate_once(self, hidden:Tensor, first:Tensor, temperature:float, top_k:int) -> Tensor:
    if not hasattr(self, "cache_kv"):
      self.cache_kv = Tensor.empty(len(self.model.layers), 2, hidden.shape[0], self.cfg["num_key_value_heads"], 32,
                                   self.cfg["head_dim"], dtype=hidden.dtype, device=hidden.device).realize()
    codes:list[Tensor] = []
    for i,step in enumerate(self._get_steps(temperature, top_k)):
      count = 8 if top_k and temperature > 0 else 1
      random = Tensor.rand(count, 1, device=hidden.device).realize()
      token,self.cache_kv = (step(hidden.contiguous(), random, self.cache_kv, first.contiguous()) if i == 0 else
                             step(codes[-1].contiguous(), random, self.cache_kv))
      token.realize()
      codes.append(token)
    return Tensor.cat(*codes, dim=1)

  def generate(self, hidden:Tensor, first:Tensor, temperature:float, top_k:int) -> Tensor:
    return self._generate_once(hidden, first, temperature, top_k)


class Talker:
  def __init__(self, cfg:dict, max_context:int):
    self.model = TalkerModel(cfg, max_context)
    self.text_projection = TextProjection(cfg["text_hidden_size"])
    self.codec_head = nn.Linear(cfg["hidden_size"], cfg["vocab_size"], bias=False)
    self.code_predictor = CodePredictor(cfg["code_predictor_config"], cfg["hidden_size"])

  def _advance(self, temperature:float, top_k:int, codes:Tensor, trailing:Tensor, random:Tensor,
               start_pos:UOp) -> tuple[Tensor,Tensor]:
    combined = self.model.codec_embedding(codes[:, :1])
    for i in range(codes.shape[1]-1): combined = combined + self.code_predictor.model.codec_embedding[i](codes[:, i+1:i+2])
    hidden = self.model.forward(combined + trailing, start_pos)
    token = sample_logits(self.codec_head(hidden[:, -1]), True, temperature, top_k, random)
    return hidden, token

  def advance(self, codes:Tensor, trailing:Tensor, start_pos:UOp, temperature:float, top_k:int) -> tuple[Tensor,Tensor]:
    count = 8 if top_k and temperature > 0 else 1
    random = Tensor.rand(count, 1, device=codes.device).realize()
    return self._advance(temperature, top_k, codes.contiguous(), trailing.contiguous(), random, start_pos)


class Qwen3TTS:
  SAMPLE_RATE = 24000
  def __init__(self, config:dict, max_context:int=4096):
    if config.get("tts_model_type") not in {"custom_voice", "base"}:
      raise ValueError(f"unsupported Qwen3-TTS model type {config.get('tts_model_type')!r}")
    self.config, self.talker_config = config, config["talker_config"]
    self.talker = Talker(self.talker_config, max_context)
    if config.get("tts_model_type") == "base": self.speaker_encoder = SpeakerEncoder(config["speaker_encoder_config"]["enc_dim"])
    self.max_context = max_context

  @staticmethod
  def from_pretrained(path:str|Path, max_context:int=4096, realize:bool=True) -> "Qwen3TTS":
    path = Path(path)
    config = json.loads((path/"config.json").read_text())
    model = Qwen3TTS(config, max_context)
    state = {k:v for k,v in safe_load(path/"model.safetensors").items() if k.startswith("talker.") or k.startswith("speaker_encoder.")}
    load_state_dict(model, state, strict=True, consume=True, realize=False)
    if realize:
      params = nn.state.get_parameters(model)
      for p in params: p.replace(p.contiguous())
      Tensor.realize(*params)
    return model

  def _sample(self, logits:Tensor, first:bool, temperature:float=0.9, top_k:int=50) -> Tensor:
    return sample_logits(logits, first, temperature, top_k)

  def create_voice_clone_prompt(self, wav, sample_rate:int, text_ids:list[int], codec) -> VoiceClonePrompt:
    if self.config["tts_model_type"] != "base": raise ValueError("voice cloning requires a Base checkpoint")
    import numpy as np
    audio = np.asarray(wav, dtype=np.float32).reshape(-1)
    if sample_rate != self.SAMPLE_RATE:
      try: import librosa
      except ImportError as e: raise ImportError("resampling voice references requires librosa") from e
      audio = librosa.resample(audio, orig_sr=sample_rate, target_sr=self.SAMPLE_RATE)
    codes = codec.encoder(Tensor(audio).cast(codec.encoder.encoder.layers[0].conv.weight.dtype).reshape(1,-1)).realize()[0].transpose(0,1)
    mel = Tensor(mel_spectrogram(audio, self.SAMPLE_RATE), device=self.talker.model.codec_embedding.weight.device).cast(
      self.speaker_encoder.blocks[0].conv.weight.dtype)
    speaker = self.speaker_encoder(mel.unsqueeze(0)).realize()[0]
    return VoiceClonePrompt(codes, speaker, text_ids)

  def generate_codes(self, ids:list[int], speaker:str="ryan", language:str="english", max_new_tokens:int=2048,
                     temperature:float=0.9, top_k:int=50) -> Tensor:
    if self.config["tts_model_type"] != "custom_voice": raise ValueError("Base checkpoints require generate_voice_clone_codes")
    cfg = self.talker_config
    if len(ids) < 8: raise ValueError("expected a Qwen assistant-formatted text prompt")
    if speaker.lower() not in cfg["spk_id"]: raise ValueError(f"unknown speaker {speaker!r}; choose from {', '.join(cfg['spk_id'])}")
    if language.lower() not in cfg["codec_language_id"]: raise ValueError(f"unsupported language {language!r}")
    dev = self.talker.model.codec_embedding.weight.device
    tid = Tensor([ids], dtype=dtypes.int32, device=dev)
    text = self.talker.text_projection(self.talker.model.text_embedding(tid))
    specials = Tensor([[self.config["tts_bos_token_id"], self.config["tts_eos_token_id"], self.config["tts_pad_token_id"]]],
                      dtype=dtypes.int32, device=dev)
    tts_bos, tts_eos, tts_pad = self.talker.text_projection(self.talker.model.text_embedding(specials)).chunk(3, dim=1)
    codec_ids = [cfg["codec_think_id"], cfg["codec_think_bos_id"], cfg["codec_language_id"][language.lower()], cfg["codec_think_eos_id"],
                 cfg["spk_id"][speaker.lower()], cfg["codec_pad_id"], cfg["codec_bos_id"]]
    codec = self.talker.model.codec_embedding(Tensor([codec_ids], dtype=dtypes.int32, device=dev))
    # Non-streaming prompt, matching the reference implementation.
    role = text[:, :3]
    prefix = Tensor.cat(tts_pad.expand(1, len(codec_ids)-2, -1), tts_bos, dim=1) + codec[:, :-1]
    body = Tensor.cat(text[:, 3:-5], tts_eos, dim=1) + self.talker.model.codec_embedding(
      Tensor([[cfg["codec_pad_id"]] * (len(ids[3:-5])+1)], dtype=dtypes.int32, device=dev))
    prompt = Tensor.cat(role, prefix, body, tts_pad + codec[:, -1:], dim=1).contiguous()
    trailing = tts_pad
    return self._rollout(prompt, trailing, max_new_tokens, temperature, top_k)

  def generate_voice_clone_codes(self, ids:list[int], prompt:VoiceClonePrompt, language:str="english", max_new_tokens:int=2048,
                                 temperature:float=0.9, top_k:int=50) -> Tensor:
    if self.config["tts_model_type"] != "base": raise ValueError("voice cloning requires a Base checkpoint")
    cfg = self.talker_config
    if len(ids) < 8 or len(prompt.text_ids) < 5: raise ValueError("expected Qwen assistant-formatted target and reference text")
    if language.lower() not in cfg["codec_language_id"]: raise ValueError(f"unsupported language {language!r}")
    if prompt.codes.ndim != 2 or prompt.codes.shape[1] != cfg["num_code_groups"]:
      raise ValueError(f"reference codes must have shape (frames, {cfg['num_code_groups']})")
    dev = self.talker.model.codec_embedding.weight.device
    target = Tensor([ids], dtype=dtypes.int32, device=dev)
    reference = Tensor([prompt.text_ids], dtype=dtypes.int32, device=dev)
    specials = Tensor([[self.config["tts_bos_token_id"], self.config["tts_eos_token_id"], self.config["tts_pad_token_id"]]],
                      dtype=dtypes.int32, device=dev)
    tts_bos, tts_eos, tts_pad = self.talker.text_projection(self.talker.model.text_embedding(specials)).chunk(3, dim=1)
    speaker = prompt.speaker_embedding.to(dev).cast(self.talker.model.codec_embedding.weight.dtype).reshape(1, 1, -1)
    codec_ids = [cfg["codec_think_id"], cfg["codec_think_bos_id"], cfg["codec_language_id"][language.lower()], cfg["codec_think_eos_id"]]
    tags = self.talker.model.codec_embedding(Tensor([codec_ids], dtype=dtypes.int32, device=dev))
    endings = self.talker.model.codec_embedding(Tensor([[cfg["codec_pad_id"], cfg["codec_bos_id"]]], dtype=dtypes.int32, device=dev))
    codec_prefix = Tensor.cat(tags, speaker, endings, dim=1)
    role = self.talker.text_projection(self.talker.model.text_embedding(target[:, :3]))
    prefix = Tensor.cat(tts_pad.expand(1, codec_prefix.shape[1]-2, -1), tts_bos, dim=1) + codec_prefix[:, :-1]

    ref_target_ids = Tensor.cat(reference[:, 3:-2], target[:, 3:-5], dim=1)
    text_embed = Tensor.cat(self.talker.text_projection(self.talker.model.text_embedding(ref_target_ids)), tts_eos, dim=1)
    codes = prompt.codes.to(dev).cast(dtypes.int32)
    codec_embed = self.talker.model.codec_embedding(codes[:, :1])
    for i in range(codes.shape[1]-1): codec_embed = codec_embed + self.talker.code_predictor.model.codec_embedding[i](codes[:, i+1:i+2])
    codec_embed = Tensor.cat(self.talker.model.codec_embedding(Tensor([[cfg["codec_bos_id"]]], dtype=dtypes.int32, device=dev)),
                             codec_embed.squeeze(1).unsqueeze(0), dim=1)
    if text_embed.shape[1] > codec_embed.shape[1]:
      raise ValueError("reference audio is too short for its transcript; use a longer voice sample")
    text_embed = Tensor.cat(text_embed, tts_pad.expand(1, codec_embed.shape[1]-text_embed.shape[1], -1), dim=1)
    icl = text_embed + codec_embed
    model_prompt = Tensor.cat(role, prefix, icl, dim=1).contiguous()
    return self._rollout(model_prompt, tts_pad, max_new_tokens, temperature, top_k)

  def _rollout(self, prompt:Tensor, trailing:Tensor, max_new_tokens:int, temperature:float, top_k:int) -> Tensor:
    cfg = self.talker_config
    hidden = self.talker.model(prompt, 0)
    start_pos = prompt.shape[1]
    v_pos = UOp.variable("talker_pos", 1, self.max_context-1)
    logits, past_hidden = self.talker.codec_head(hidden[:, -1]), hidden[:, -1:]
    rows:list[Tensor] = []
    first = self._sample(logits, True, temperature, top_k).realize()
    for _ in range(max_new_tokens):
      if int(first.item()) == cfg["codec_eos_token_id"]: break
      first_embed = self.talker.model.codec_embedding(first)
      rest = self.talker.code_predictor.generate(past_hidden, first_embed, temperature, top_k)
      # JIT outputs reuse graph buffers; preserve each autoregressive frame before the next replay overwrites them.
      rows.append(Tensor.cat(first, rest, dim=1).contiguous().realize())
      hidden, first = self.talker.advance(rows[-1], trailing, v_pos.bind(start_pos), temperature, top_k)
      start_pos += 1
      past_hidden = hidden[:, -1:]
      first.realize()
    if not rows: raise RuntimeError("the talker stopped before producing an audio frame")
    return Tensor.cat(*rows, dim=0).unsqueeze(0).transpose(1, 2)
