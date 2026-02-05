from tinygrad import Tensor, dtypes

# Exact shapes from the slow kernel r_4096_4_4_8_16_2_2048_4:
# - Output: float[16777216] = float[4096 * 4096]
# - data1: bfloat16[33554432] = gradient, indexed by c9*4096 + c2
# - data2: bfloat16[524288] = freqs_cos, indexed by c9*64 + c22
# - data3: bfloat16[33554432] = xq values
# - data4: bfloat16[524288] = freqs_sin
# - Reduction c9 over 8192 (SEQLEN)

# The kernel computes: out[c2, c4] = sum over c9 of: grad[c9, c2] * RoPE_backward(c9, c4)
# where c2 indexes DIM (4096), c4 indexes DIM (4096), c9 indexes SEQLEN (8192)

SEQLEN, DIM, HEAD_DIM = 8192, 4096, 128

# grad: [SEQLEN, DIM] - gradient flowing back
grad = Tensor.randn(SEQLEN, DIM, dtype=dtypes.bfloat16).realize()

# freqs: [SEQLEN, HEAD_DIM//2] = [8192, 64]
freqs_cos = Tensor.randn(SEQLEN, HEAD_DIM//2, dtype=dtypes.bfloat16).realize()
freqs_sin = Tensor.randn(SEQLEN, HEAD_DIM//2, dtype=dtypes.bfloat16).realize()

# xq: [SEQLEN, DIM] - the q projection output (used in RoPE backward)
xq = Tensor.randn(SEQLEN, DIM, dtype=dtypes.bfloat16).realize()

# RoPE backward on the gradient
# grad is [SEQLEN, DIM], reshape to [SEQLEN, N_HEADS, HEAD_DIM//2, 2]
N_HEADS = DIM // HEAD_DIM  # 32
grad_r = grad.reshape(SEQLEN, N_HEADS, HEAD_DIM//2, 2)

# freqs need to broadcast: [SEQLEN, 1, HEAD_DIM//2, 1]
freqs_cos_b = freqs_cos.reshape(SEQLEN, 1, HEAD_DIM//2, 1)
freqs_sin_b = freqs_sin.reshape(SEQLEN, 1, HEAD_DIM//2, 1)

# RoPE backward (conjugate):
# d_real = grad_real * cos + grad_imag * sin
# d_imag = grad_imag * cos - grad_real * sin
grad_real = grad_r[..., 0:1]
grad_imag = grad_r[..., 1:2]
d_real = grad_real * freqs_cos_b + grad_imag * freqs_sin_b  # bf16 ops here!
d_imag = grad_imag * freqs_cos_b - grad_real * freqs_sin_b  # bf16 ops here!

# Combine back to [SEQLEN, DIM]
d_xq = d_real.cat(d_imag, dim=-1).reshape(SEQLEN, DIM)

# Weight gradient: x^T @ d_xq where x is [SEQLEN, DIM]
# Result is [DIM, DIM], reducing over SEQLEN
x = Tensor.randn(SEQLEN, DIM, dtype=dtypes.bfloat16).realize()
grad_wq = x.T @ d_xq  # [DIM, DIM] - reduction over SEQLEN creates the slow kernel

print("Realizing grad_wq...")
grad_wq.realize()
print("Done")
