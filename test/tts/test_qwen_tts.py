import unittest
from tinygrad import Tensor, nn
from tinygrad.nn.state import get_state_dict, load_state_dict
from tinygrad.tts.model import Attention
from tinygrad.tts.codec import CausalConv, CausalTransConv


class TestQwenTTS(unittest.TestCase):
  def test_cached_attention_matches_full_attention(self):
    Tensor.manual_seed(4)
    full, cached = Attention(16, 2, 1, 8, 1e-6, 10000, 16), Attention(16, 2, 1, 8, 1e-6, 10000, 16)
    load_state_dict(cached, get_state_dict(full))
    x = Tensor.randn(1, 5, 16)
    expected = full(x, 0, cache=False).realize()
    chunks = [cached(x[:, :3], 0).realize(), cached(x[:, 3:4], 3).realize(), cached(x[:, 4:], 4).realize()]
    actual = Tensor.cat(*chunks, dim=1).realize()
    self.assertTrue((expected-actual).abs().max().item() < 1e-5)

  def test_codec_convolution_lengths(self):
    x = Tensor.randn(1, 4, 7)
    self.assertEqual(CausalConv(4, 6, 3)(x).shape, (1, 6, 7))
    self.assertEqual(CausalConv(4, 6, 4, stride=2)(x).shape, (1, 6, 4))
    self.assertEqual(CausalTransConv(4, 6, 6, stride=3)(x).shape, (1, 6, 21))


if __name__ == "__main__": unittest.main()
