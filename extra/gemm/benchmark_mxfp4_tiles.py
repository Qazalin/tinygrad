import statistics

from tinygrad import GlobalCounters, Tensor, dtypes
from tinygrad.helpers import DEBUG, getenv

from extra.gemm.cdna_asm_gemm import MXFP4_TILES, asm_gemm
from extra.llama_kernels.quantize_mxfp4 import quantize_mxfp4


M, N, K = getenv("M", 16384), getenv("N", 14336), getenv("K", 4096)
WARMUP, CNT = getenv("WARMUP", 2), getenv("CNT", 7)
assert DEBUG >= 2, "GlobalCounters kernel timing requires DEBUG=2"

a = (Tensor.rand if getenv("RAND", 0) else Tensor.ones)(M, K, dtype=dtypes.bfloat16).contiguous()
w = (Tensor.rand if getenv("RAND", 0) else Tensor.ones)(N, K, dtype=dtypes.bfloat16).contiguous()
a_mxfp4 = quantize_mxfp4(a, shuffle_col=True)
w_mxfp4 = quantize_mxfp4(w, shuffle_row=True, shuffle_col=True)
Tensor.realize(a, w, *a_mxfp4, *w_mxfp4)

tiles = (tuple(map(int, getenv("TILE", "0,0").split(","))),) if getenv("TILE", "") else MXFP4_TILES
for tile in tiles:
  if M % tile[0] != 0 or N % tile[1] != 0:
    print(f"{M}x{N}x{K} {tile[0]}x{tile[1]}: skipped (shape is not tile-aligned)")
    continue
  times = []
  out = None
  for i in range(WARMUP + CNT):
    target = Tensor.zeros(M, N, dtype=dtypes.bfloat16).contiguous().realize() if getenv("OUT", 0) else None
    st = GlobalCounters.time_sum_s
    out = asm_gemm(a, w.T, mxfp4=True, mxfp4_tile=tile, mxfp4_x=a_mxfp4, mxfp4_w=w_mxfp4, out=target).realize()
    if i >= WARMUP: times.append(GlobalCounters.time_sum_s - st)
  assert out is not None
  max_error = (out.float() - getenv("EXPECT", K)).abs().max().item() if not getenv("RAND", 0) else 0.0
  tm = statistics.median(times)
  print(f"{M}x{N}x{K} {tile[0]}x{tile[1]}: {tm*1e3:.4f} ms, {2*M*N*K/tm/1e15:.3f} PFLOP/s, max_error={max_error:g}")
  if getenv("DIAG", 0) and not getenv("RAND", 0):
    expected = getenv("EXPECT", K)
    out_f = out.float()
    print("output range/mean/mismatch:", out_f.min().item(), out_f.max().item(), out_f.mean().item(), (out != expected).float().mean().item())
    print("row means:", out_f.mean(axis=1)[::64].numpy().tolist())
    print("first row means:", out_f.mean(axis=1)[:32].numpy().tolist())
    print("col means:", out_f.mean(axis=0)[::128].numpy().tolist())
    print("row0:", out_f[0, :256].numpy().tolist())
    print("wrong/min/max:", (out_f != getenv("EXPECT", K)).sum().item(), out_f.min().item(), out_f.max().item())
  if not getenv("RAND", 0): assert max_error == 0.0
