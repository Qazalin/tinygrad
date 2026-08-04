import numpy as np
import torch
import unittest
from unittest.mock import patch
from tinygrad import Tensor, Device, dtypes
from tinygrad.nn.optim import Adam, SGD, AdamW, Muon, LAMB
from tinygrad.helpers import Context
from test.helpers import needs_second_gpu, slow

np.random.seed(1337)
x_init = np.random.randn(1,4).astype(np.float32)
W_init = np.random.randn(4,4).astype(np.float32)
m_init = np.random.randn(1,4).astype(np.float32)

def _param(tensor, val):
  return tensor(val, requires_grad=True) if tensor is torch.tensor else tensor(val)

class TeenyNet:
  def __init__(self, tensor):
    self.x = _param(tensor, x_init.copy())
    self.W = _param(tensor, W_init.copy())
  def forward(self):
    return (self.x * self.W).sum()

class TinyNet:
  def __init__(self, tensor):
    self.x = _param(tensor, x_init.copy())
    self.W = _param(tensor, W_init.copy())
    self.m = tensor(m_init.copy())

  def forward(self):
    out = self.x.matmul(self.W).relu()
    # print(out.detach().numpy())
    out = out.log_softmax(1)
    out = out.mul(self.m).add(self.m).sum()
    return out

def step(tensor, optim, steps=1, teeny=False, **kwargs):
  net = TeenyNet(tensor) if teeny else TinyNet(tensor)
  optim = optim([net.x, net.W], **kwargs)
  for _ in range(steps):
    out = net.forward()
    optim.zero_grad()
    out.backward()
    optim.step()
  return net.x.detach().numpy(), net.W.detach().numpy()

class TestMLPerfOptim(unittest.TestCase):
  def test_clip_grads_sharded(self):
    from examples.mlperf.optim import clip_grads
    devs = ("CPU:0", "CPU:1")
    grads = [Tensor.arange(32).cast(dtypes.bfloat16).clone().shard(devs, None).realize(),
             Tensor.arange(12, 20).cast(dtypes.bfloat16).clone().shard(devs, None).realize()]
    norm, coeff = clip_grads(grads, 2, 1.0)
    Tensor.realize(norm, coeff)
    ref = np.sqrt(sum(np.square((g / 2).cast(g.dtype).float().numpy()).sum() for g in grads))
    np.testing.assert_allclose(norm.numpy(), ref, rtol=1e-6)
    np.testing.assert_allclose(coeff.numpy(), min(1.0, 1.0 / (ref + 1e-6)), rtol=1e-6)

  def test_fused_adamw(self):
    from examples.mlperf.optim import _fused_adamw_step
    rng = np.random.default_rng(4)
    param = Tensor(rng.standard_normal(256, dtype=np.float32), dtype=dtypes.bfloat16).realize()
    grad = Tensor(rng.standard_normal(256, dtype=np.float32), dtype=dtypes.bfloat16).realize()
    m = Tensor.randn(256, dtype=dtypes.bfloat16).realize()
    v = Tensor.rand(256, dtype=dtypes.bfloat16).realize()
    master = param.float().contiguous().realize()
    m_ref, v_ref, master_ref = m.clone().realize(), v.clone().realize(), master.clone().realize()
    lr, b1_t, b2_t = Tensor([1e-3]).realize(), Tensor([0.9]).realize(), Tensor([0.95]).realize()
    m_calc = 0.9 * m_ref.float() + 0.1 * grad.float()
    v_calc = 0.95 * v_ref.float() + 0.05 * grad.float().square()
    m_new, v_new = m_calc.cast(dtypes.bfloat16), v_calc.cast(dtypes.bfloat16)
    master_new = master_ref - lr * ((m_calc / (1.0 - b1_t)) / ((v_calc / (1.0 - b2_t)).sqrt() + 1e-5) + 0.1 * master_ref)
    param_ref = master_new.cast(dtypes.bfloat16)
    Tensor.realize(m_new, v_new, master_new, param_ref)
    _fused_adamw_step(param, grad, m, v, master, lr, b1_t, b2_t, Tensor.ones(1).realize(), 0.9, 0.95, 1e-5, 0.1, 1)
    Tensor.realize(param, m, v, master)
    np.testing.assert_array_equal(param.numpy(), param_ref.numpy())
    np.testing.assert_array_equal(m.numpy(), m_new.numpy())
    np.testing.assert_array_equal(v.numpy(), v_new.numpy())
    np.testing.assert_allclose(master.numpy(), master_new.numpy(), rtol=2e-7, atol=2e-7)

  def test_fused_adamw_zero(self):
    from examples.mlperf.optim import GradAccClipAdamW
    devs = ("CPU:0", "CPU:1")
    param = Tensor.arange(32).cast(dtypes.bfloat16).clone().shard(devs, None).is_param_(True).realize()
    grad = Tensor.arange(32, 64).cast(dtypes.bfloat16).clone().shard(devs, None).realize()
    with patch("examples.mlperf.optim.ZERO_OPTIM", 1), patch("examples.mlperf.optim.MASTER_WEIGHTS", 1):
      optim = GradAccClipAdamW([param], lr=1e-3, b1=0.9, b2=0.95, eps=1e-5, weight_decay=0.1, grad_acc=2)
    Tensor.realize(*optim.m, *optim.v, *optim.master_params, *optim.param_shards, optim.lr, optim.b1_t, optim.b2_t)
    self.assertEqual(optim.m[0].uop.axis, 0)
    w_ref = param.numpy().astype(np.float32)
    g_ref = ((grad / 2).cast(grad.dtype).float() * 0.75).cast(grad.dtype).float().numpy()
    m_ref, v_ref = np.zeros_like(g_ref), np.zeros_like(g_ref)
    for step in range(1, 3):
      m_ref, v_ref = 0.9 * m_ref + 0.1 * g_ref, 0.95 * v_ref + 0.05 * g_ref * g_ref
      w_ref -= 1e-3 * ((m_ref / (1 - 0.9**step)) / (np.sqrt(v_ref / (1 - 0.95**step)) + 1e-5) + 0.1 * w_ref)
      optim.fstep([grad], Tensor(0).realize(), Tensor.full((1,), 0.75, device=devs).realize())
      np.testing.assert_allclose(optim.m[0].numpy(), m_ref, rtol=1e-2)
      np.testing.assert_allclose(optim.v[0].numpy(), v_ref, rtol=1e-2)
      np.testing.assert_allclose(optim.master_params[0].numpy(), w_ref, rtol=2e-7, atol=2e-7)
      np.testing.assert_allclose(param.numpy(), w_ref, rtol=5e-3, atol=5e-3)

@slow
class TestOptim(unittest.TestCase):
  def setUp(self): self.enterContext(Context(TRAINING=1))

  def _test_optim(self, tinygrad_optim, torch_optim, steps, opts, atol, rtol):
    for x,y in zip(step(Tensor, tinygrad_optim, steps, **opts),
                   step(torch.tensor, torch_optim, steps, **opts)):
      np.testing.assert_allclose(x, y, atol=atol, rtol=rtol)

  def _test_sgd(self, steps, opts, atol, rtol): self._test_optim(SGD, torch.optim.SGD, steps, opts, atol, rtol)
  def _test_adam(self, steps, opts, atol, rtol): self._test_optim(Adam, torch.optim.Adam, steps, opts, atol, rtol)
  def _test_adamw(self, steps, opts, atol, rtol): self._test_optim(AdamW, torch.optim.AdamW, steps, opts, atol, rtol)
  def _test_muon(self, steps, opts, atol, rtol): self._test_optim(Muon, torch.optim.Muon, steps, opts, atol, rtol)

  def test_multistep_sgd_high_lr_teeny(self): self._test_sgd(2, {'lr': 1.1, 'teeny': True}, 1e-6, 1e-5)
  def test_multistep_adam_high_lr_teeny(self): self._test_adam(2, {'lr': 1.1, 'teeny': True}, 2e-4, 5e-4)
  def test_multistep_muon_high_lr_teeny(self): self._test_muon(2, {'lr': 1.1, 'teeny': True}, 1e-2, 5e-4)

  def test_sgd(self): self._test_sgd(1, {'lr': 0.001}, 1e-6, 0)
  def test_sgd_high_lr(self): self._test_sgd(1, {'lr': 10}, 1e-6, 1e-5)
  def test_sgd_wd(self): self._test_sgd(1, {'lr': 0.001, 'weight_decay': 0.1}, 1e-6, 0)
  def test_sgd_high_lr_wd(self): self._test_sgd(1, {'lr': 10, 'weight_decay': 0.1}, 1e-6, 1e-5)

  def test_multistep_sgd(self): self._test_sgd(10, {'lr': 0.001}, 1e-6, 0)
  def test_multistep_sgd_high_lr(self): self._test_sgd(10, {'lr': 10}, 1e-6, 3e-4)
  def test_multistep_sgd_wd(self): self._test_sgd(10, {'lr': 0.001, 'weight_decay': 0.1}, 1e-6, 0)
  def test_multistep_sgd_high_lr_wd(self): self._test_sgd(10, {'lr': 9, 'weight_decay': 0.1}, 1e-6, 3e-4)

  def test_multistep_sgd_momentum(self): self._test_sgd(10, {'lr': 0.001, 'momentum': 0.9}, 1e-6, 0)
  def test_multistep_sgd_high_lr_momentum(self): self._test_sgd(10, {'lr': 10, 'momentum': 0.9}, 1e-5, 3e-4)
  def test_multistep_sgd_momentum_wd(self): self._test_sgd(10, {'lr': 0.001, 'momentum': 0.9, 'weight_decay': 0.1}, 1e-6, 0)
  def test_multistep_sgd_high_lr_momentum_wd(self): self._test_sgd(10, {'lr': 10, 'momentum': 0.9, 'weight_decay': 0.1}, 1e-5, 3e-4)

  def test_multistep_sgd_nesterov_momentum(self): self._test_sgd(10, {'lr': 0.001, 'momentum': 0.9, 'nesterov': True}, 1e-5, 0)
  def test_multistep_sgd_high_lr_nesterov_momentum(self): self._test_sgd(10, {'lr': 10, 'momentum': 0.9, 'nesterov': True}, 1e-5, 3e-4)
  def test_multistep_sgd_nesterov_momentum_wd(self):
    self._test_sgd(10, {'lr': 0.001, 'momentum': 0.9, 'nesterov': True, 'weight_decay': 0.1}, 1e-5, 0)
  def test_multistep_sgd_high_lr_nesterov_momentum_wd(self):
    self._test_sgd(10, {'lr': 9, 'momentum': 0.9, 'nesterov': True, 'weight_decay': 0.1}, 1e-5, 3e-4)

  def test_muon(self): self._test_muon(1, {'lr': 0.001}, 1e-3, 0)
  # TODO: disabled due to big atol
  # def test_muon_high_lr(self): self._test_muon(1, {'lr': 10}, 1e-6, 3e-4)
  def test_muon_wd(self): self._test_muon(1, {'lr': 0.001, 'weight_decay': 0.01}, 1e-3, 3e-4)
  # TODO: disabled due to big atol
  # def test_muon_high_lr_wd(self): self._test_muon(1, {'lr': 10, 'weight_decay': 0.01}, 1e-6, 5e-4)

  # NOTE: momentum set to 0.95 by default, nesterov set to True by default
  def test_multistep_muon_momentum_wd(self): self._test_muon(10, {'lr': 0.001, 'weight_decay': 0.01}, 3e-3, 0)
  # ns defaults are numerically unstable, but it is tolerable in real training (see nsteps/nparam tests)
  # TODO: disabled due to big atol
  # def test_multistep_muon_high_lr_momentum_wd(self): self._test_muon(10, {'lr': 10, 'weight_decay': 0.01}, 1e-1, 3e-4)
  def test_multistep_muon_no_nesterov_momentum(self): self._test_muon(10, {'lr': 0.001, 'nesterov': False}, 1e-3, 0)
  # TODO: disabled due to big atol
  # def test_multistep_muon_high_lr_no_nesterov_momentum(self): self._test_muon(10, {'lr': 10, 'nesterov': False}, 5e-2, 1e-1)

  def test_muon_ns_steps(self): self._test_muon(1, {'lr': 0.001, 'ns_steps': 3}, 1e-4, 0)
  # TODO: disabled due to big atol
  # def test_muon_high_lr_ns_steps(self): self._test_muon(1, {'lr': 10, 'ns_steps': 3}, 1e-5, 3e-4)
  def test_muon_ns_coefficients(self): self._test_muon(1, {'lr': 0.001,'ns_coefficients': (2.0,-1.5,0.5)}, 1e-5, 3e-4)
  # TODO: disabled due to big atol
  # def test_muon_high_lr_ns_coefficients(self): self._test_muon(1, {'lr': 10,'ns_coefficients': (2.0,-1.5,0.5)}, 1e-5, 3e-4)

  def test_muon_momentum_wd_ns_steps_ns_coefficients(self):
    self._test_muon(10, {'lr': 0.001, 'momentum': 0.90, 'weight_decay': 0.01, 'ns_steps': 3, 'ns_coefficients': (2.0,-1.5,0.5)}, 1e-4, 0)
  # TODO: disabled due to big atol
  # def test_multistep_muon_high_lr_momentum_wd_ns_steps_ns_coefficients(self):
  #   self._test_muon(10, {'lr': 10, 'momentum': 0.90, 'weight_decay': 0.01, 'ns_steps': 3, 'ns_coefficients': (2.0,-1.5,0.5)}, 1e-5, 3e-4)

  def test_adam(self): self._test_adam(1, {'lr': 0.001}, 1e-5, 0)
  def test_adam_high_lr(self): self._test_adam(1, {'lr': 10}, 1e-4, 1e-4)
  def test_adamw(self): self._test_adamw(1, {'lr': 0.001}, 1e-5, 0)
  def test_adamw_high_lr(self): self._test_adamw(1, {'lr': 10}, 1e-4, 1e-4)

  def test_multistep_adam(self): self._test_adam(10, {'lr': 0.001}, 1e-5, 0)
  def test_multistep_adam_high_lr(self): self._test_adam(10, {'lr': 10}, 2e-3, 5e-4)

  def test_multistep_adamw(self): self._test_adamw(10, {'lr': 0.001}, 1e-5, 0)
  def test_multistep_adamw_high_lr(self): self._test_adamw(10, {'lr': 10}, 5e-4, 2e-3)

  def test_duped_weights(self):
    for Opt in [Adam, AdamW, SGD]:
      losses = []
      for i in range(2):
        w = Tensor(x_init.copy())
        opt = Opt([w], lr=0.1) if i == 0 else Opt([w, w], lr=0.1)

        loss = None
        for _ in range(3):
          loss = w.sum()
          opt.zero_grad()
          loss.backward()
          opt.step()
        losses.append(loss.numpy())

      np.testing.assert_allclose(losses[0], losses[1], atol=1e-4, rtol=0)

  @unittest.skipUnless(dtypes.half in Device[Device.DEFAULT].renderer.supported_dtypes(), "need half")
  def test_mixed_precision(self):
    self.enterContext(Context(DEFAULT_FLOAT=dtypes.half))
    # weight update would overflow without upcasting
    self._test_sgd(10, {'lr': 1e10}, 1e-6, 3e-4)
    self._test_adam(1, {'lr': 1e10}, 1e-4, 1e-4)
    self._test_adamw(1, {'lr': 1e10}, 1e-4, 1e-4)

  def test_assert_tensor_train(self):
    t = Tensor.ones((1,1))
    optimizer = Adam([t])
    optimizer.zero_grad()
    t.sum().backward()
    with Context(TRAINING=0):
      self.assertRaises(RuntimeError, optimizer.step)
    with Context(TRAINING=1):
      optimizer.step()

  def test_lamb_cpu_offload(self):
    # test that LAMB works when optimizer params (m, v, b1_t, b2_t) are moved to CPU
    t = Tensor(x_init.copy())
    opt = LAMB([t])
    # move optimizer state to CPU
    for p in opt.m + opt.v + [opt.b1_t, opt.b2_t]: p.to_("CPU")
    # run a step
    t.sum().backward()
    opt.step()
    self.assertEqual(t.device, Device.DEFAULT)
    self.assertEqual(opt.m[0].device, "CPU")

  @needs_second_gpu
  def test_lamb_cpu_offload_multi(self):
    ds = tuple(f"{Device.DEFAULT}:{i}" for i in range(2))
    t = Tensor(x_init.copy()).shard(ds, axis=1)
    ds = t.device
    opt = LAMB([t])
    # move optimizer state to CPU
    for p in opt.m + opt.v + [opt.b1_t, opt.b2_t]: p.to_("CPU")
    # run a step
    t.sum().backward()
    opt.step()
    self.assertEqual(t.device, ds)
    self.assertEqual(opt.m[0].device, "CPU")

if __name__ == '__main__':
  unittest.main()
