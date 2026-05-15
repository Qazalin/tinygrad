#!/usr/bin/env python3
import argparse

from tinygrad import Tensor
from tinygrad.helpers import Context, DEBUG, fetch
from tinygrad.llm.amd_kernels import gdn_qkv_conv
from tinygrad.llm.cli import models
from tinygrad.llm.model import GatedDeltaNetBlock, Transformer


def main() -> None:
  parser = argparse.ArgumentParser(description="Compare fused GDN QKV+conv kernel against autoscheduled reference kernels")
  parser.add_argument("--model", default="qwen3.5:0.8b", help="Model key or GGUF path")
  parser.add_argument("--gdn-block", type=int, default=0, help="Index within GDN blocks, not all transformer blocks")
  parser.add_argument("--device", default="AMD", help="Device to run on")
  parser.add_argument("--conv-atol", type=float, default=2e-6, help="Absolute tolerance for conv output diff")
  parser.add_argument("--state-atol", type=float, default=0.0, help="Absolute tolerance for next-state diff")
  args = parser.parse_args()

  debug_level = DEBUG.value
  with Context(DEBUG=0):
    model, _ = Transformer.from_gguf(fetch(models.get(args.model, args.model)), 16)
    Tensor.manual_seed(0)
    x = Tensor.randn(1, 1, 1024, device=args.device).realize()

  gdn_blocks = [b for b in model.blk if isinstance(b, GatedDeltaNetBlock)]
  if args.gdn_block >= len(gdn_blocks):
    raise SystemExit(f"requested --gdn-block={args.gdn_block}, but model only has {len(gdn_blocks)} GDN blocks")
  blk = gdn_blocks[args.gdn_block]

  with Context(DEBUG=0):
    conv_state = Tensor.randn(1, blk.ssm_conv_kernel-1, blk.conv_channels, device=args.device).realize()
  xh = x.half()

  print(f"testing GDN block {args.gdn_block} on {args.device}")
  print("reference path should autoschedule 3 kernels; fused path should run gdn_qkv_conv_q8")

  with Context(DEBUG=debug_level):
    projected = blk.attn_qkv(xh)
    conv_window = conv_state.cat(projected, dim=1)
    ref_conv = (conv_window * blk.ssm_conv1d["weight"].T.unsqueeze(0)).sum(1)
    ref_state_src = conv_window[:, 1:, :]
    ref_state_buf = Tensor.empty(*conv_state.shape, dtype=conv_state.dtype, device=conv_state.device)
    ref_state = Tensor(ref_state_buf.uop.after(ref_state_buf.uop.store(ref_state_src.uop)))
    Tensor.realize(ref_conv, ref_state)

    fused_conv, fused_state = gdn_qkv_conv(conv_state, x, blk.attn_qkv.weight, blk.ssm_conv1d["weight"])
    Tensor.realize(fused_conv, fused_state)

  with Context(DEBUG=0):
    conv_diff = (ref_conv - fused_conv).abs().realize()
    state_diff = (ref_state - fused_state).abs().realize()
    conv_max, conv_mean = conv_diff.max().item(), conv_diff.mean().item()
    state_max, state_mean = state_diff.max().item(), state_diff.mean().item()

  print(f"conv max diff:  {conv_max}")
  print(f"conv mean diff: {conv_mean}")
  print(f"state max diff: {state_max}")
  print(f"state mean diff:{state_mean}")

  if conv_max > args.conv_atol:
    raise SystemExit(f"conv diff {conv_max} exceeds tolerance {args.conv_atol}")
  if state_max > args.state_atol:
    raise SystemExit(f"state diff {state_max} exceeds tolerance {args.state_atol}")

  print("PASS")


if __name__ == "__main__":
  main()
