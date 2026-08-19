from __future__ import annotations
import numpy as np
from tinygrad import Tensor, nn


class TDNN:
  def __init__(self, in_channels:int, out_channels:int, kernel:int, dilation:int=1):
    self.conv = nn.Conv1d(in_channels, out_channels, kernel, dilation=dilation)
    self.pad = dilation*(kernel-1)//2
  def __call__(self, x:Tensor) -> Tensor: return self.conv(x.pad((self.pad, self.pad), mode="reflect")).relu()


class Res2Net:
  def __init__(self, channels:int, scale:int, kernel:int, dilation:int):
    self.blocks = [TDNN(channels//scale, channels//scale, kernel, dilation) for _ in range(scale-1)]
    self.scale = scale
  def __call__(self, x:Tensor) -> Tensor:
    out:list[Tensor] = []
    for i,part in enumerate(x.chunk(self.scale, dim=1)):
      cur = part if i == 0 else self.blocks[i-1](part if i == 1 else part+out[-1])
      out.append(cur)
    return Tensor.cat(*out, dim=1)


class SqueezeExcitation:
  def __init__(self, channels:int, hidden:int):
    self.conv1, self.conv2 = nn.Conv1d(channels, hidden, 1), nn.Conv1d(hidden, channels, 1)
  def __call__(self, x:Tensor) -> Tensor: return x * self.conv2(self.conv1(x.mean(2, keepdim=True)).relu()).sigmoid()


class SERes2Net:
  def __init__(self, channels:int, kernel:int, dilation:int):
    self.tdnn1, self.tdnn2 = TDNN(channels, channels, 1), TDNN(channels, channels, 1)
    self.res2net_block, self.se_block = Res2Net(channels, 8, kernel, dilation), SqueezeExcitation(channels, 128)
  def __call__(self, x:Tensor) -> Tensor: return x + self.se_block(self.tdnn2(self.res2net_block(self.tdnn1(x))))


class AttentiveStatisticsPooling:
  def __init__(self, channels:int):
    self.tdnn, self.conv = TDNN(channels*3, 128, 1), nn.Conv1d(128, channels, 1)
  def __call__(self, x:Tensor) -> Tensor:
    mean, std = x.mean(2, keepdim=True), ((x-x.mean(2, keepdim=True)).square().mean(2, keepdim=True)+1e-12).sqrt()
    attn = self.conv(self.tdnn(Tensor.cat(x, mean.expand(*x.shape), std.expand(*x.shape), dim=1)).tanh()).softmax(2)
    mean = (x*attn).sum(2)
    std = (attn*(x-mean.unsqueeze(2)).square()).sum(2).maximum(1e-12).sqrt()
    return Tensor.cat(mean, std, dim=1).unsqueeze(2)


class SpeakerEncoder:
  def __init__(self, output_dim:int=2048):
    self.blocks = [TDNN(128, 512, 5), SERes2Net(512, 3, 2), SERes2Net(512, 3, 3), SERes2Net(512, 3, 4)]
    self.mfa, self.asp, self.fc = TDNN(1536, 1536, 1), AttentiveStatisticsPooling(1536), nn.Conv1d(3072, output_dim, 1)
  def __call__(self, mel:Tensor) -> Tensor:
    x, features = mel.transpose(1,2), []
    for block in self.blocks: x=block(x); features.append(x)
    return self.fc(self.asp(self.mfa(Tensor.cat(*features[1:], dim=1)))).squeeze(2)


def mel_spectrogram(wav:np.ndarray, sample_rate:int=24000) -> np.ndarray:
  try: import librosa
  except ImportError as e: raise ImportError("voice cloning requires librosa for reference-audio preprocessing") from e
  if sample_rate != 24000: wav = librosa.resample(wav.astype(np.float32), orig_sr=sample_rate, target_sr=24000)
  wav = np.pad(wav.astype(np.float32), (384,384), mode="reflect")
  spec = np.abs(librosa.stft(wav, n_fft=1024, hop_length=256, win_length=1024, window="hann", center=False))
  mel = librosa.filters.mel(sr=24000, n_fft=1024, n_mels=128, fmin=0, fmax=12000) @ np.sqrt(spec*spec+1e-9)
  return np.log(np.maximum(mel, 1e-5)).T.astype(np.float32)
