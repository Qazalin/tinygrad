# CUSTOM_VOCAB_ARGMAX=1 CUSTOM_MLP=1 CUSTOM_GDN=1 JITBEAM=2 python -m tinygrad.llm.cli -m qwen3.5:0.8b --benchmark 16
import functools

from tinygrad import Device, Tensor, dtypes, Context
from tinygrad.renderer import Estimates
from tinygrad.uop.ops import KernelInfo, Ops, UOp

_DIM, _HIDDEN = 1024, 3584
_GDN_HV, _GDN_V, _GDN_K = 16, 128, 128
_GDN_CHANNELS, _GDN_CONV_KERNEL = 3 * _GDN_HV * _GDN_K, 4
_VOCAB = 248320
_Q8_BLOCK = 32
_Q8_BLOCK_BYTES = 34

# note: this is needed because standalone Ops.SOURCE (without Ops.BINARY) isn't supported
@Context(ALLOW_DEVICE_USAGE=1)
def get_arch() -> str: return Device[Device.DEFAULT].renderer.target.arch

def _q8_bytes(numel:int) -> int:
  assert numel % _Q8_BLOCK == 0
  return (numel // _Q8_BLOCK) * _Q8_BLOCK_BYTES

def _find_raw_q8_blocks(weight:Tensor) -> Tensor|None:
  seen:set[int] = set()
  stack = [weight.uop]
  while stack:
    u = stack.pop()
    if id(u) in seen: continue
    seen.add(id(u))
    if u.op is Ops.CONTIGUOUS and u.dtype.scalar() == dtypes.uchar:
      return Tensor(u)
    stack.extend(u.src)
  return None

def _base_buffer_with_offset(t:Tensor) -> tuple[Tensor, int]|None:
  src = t.uop.src[0] if t.uop.op is Ops.CONTIGUOUS and len(t.uop.src) else t.uop
  if (offset := src.contiguous_view_offset()) is None: return None
  base = src.base
  if base.op is Ops.BUFFER_VIEW: offset, base = offset + base.arg[1], base.src[0]
  if base.op not in {Ops.BUFFER, Ops.PARAM}: return None
  return Tensor(base), offset

_GATE_UP_HIP_SRC = r"""
#include <hip/hip_runtime.h>
#include <stdint.h>

constexpr int DIM = 1024;
constexpr int HIDDEN = 3584;
constexpr int THREADS = 32;
constexpr int ROWS_PER_GROUP = 1;
constexpr float RMS_EPS = 1.0e-6f;

extern "C" __global__ __launch_bounds__(THREADS) void fused_gate_up_q8(
    float* __restrict__ z,
    const float* __restrict__ x_norm,
    const unsigned char* __restrict__ gate_w,
    const unsigned char* __restrict__ up_w) {
  int tid = threadIdx.x;
  int row = blockIdx.x;

  int block = tid;
  int base = (row * (DIM / 32) + block) * 34;
  const unsigned char* gb = gate_w + base;
  const unsigned char* ub = up_w + base;
  float gs = float(*reinterpret_cast<const _Float16*>(gb));
  float us = float(*reinterpret_cast<const _Float16*>(ub));
  float gacc = 0.0f, uacc = 0.0f;
  #pragma unroll
  for (int offset = 0; offset < 32; offset++) {
    int i = block * 32 + offset;
    float x = x_norm[i];
    gacc += float(*reinterpret_cast<const int8_t*>(gb + 2 + offset)) * gs * x;
    uacc += float(*reinterpret_cast<const int8_t*>(ub + 2 + offset)) * us * x;
  }
  #pragma unroll
  for (int delta = 16; delta > 0; delta >>= 1) {
    gacc += __shfl_down(gacc, delta, 32);
    uacc += __shfl_down(uacc, delta, 32);
  }
  if (tid == 0) {
    z[row] = (gacc / (1.0f + exp2f(-1.4426950408889634f * gacc))) * uacc;
  }
}
"""

@functools.cache
def _compiled_gate_up(arch:str) -> bytes:
  from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
  return HIPCCCompiler(arch).compile_cached(_GATE_UP_HIP_SRC)

def _gate_up_kernel(z:UOp, x_norm:UOp, gate_w:UOp, up_w:UOp, arch:str) -> UOp:
  assert z.numel() == _HIDDEN, f"fused_gate_up_q8 expects hidden={_HIDDEN}, got {z.numel()}"
  ops = 4 * _HIDDEN * _DIM + 2 * _HIDDEN
  mem = (_DIM + _HIDDEN) * 4 + 2 * _q8_bytes(_HIDDEN * _DIM)
  sink = UOp.sink(
    UOp.special(_HIDDEN, "gidx0"), UOp.special(32, "lidx0"),
    z, x_norm, gate_w, up_w,
    arg=KernelInfo(name="fused_gate_up_q8", estimates=Estimates(ops=ops, mem=mem)))
  return UOp(Ops.PROGRAM, src=(
    sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)),
    UOp(Ops.SOURCE, arg=_GATE_UP_HIP_SRC), UOp(Ops.BINARY, arg=_compiled_gate_up(arch))))

def fused_gate_up(x_norm:Tensor, gate_w:Tensor, up_w:Tensor) -> Tensor:
  assert x_norm.numel() == _DIM, f"fused_gate_up only supports dim={_DIM}, got {x_norm.numel()}"
  gate_raw = _find_raw_q8_blocks(gate_w)
  up_raw = _find_raw_q8_blocks(up_w)
  if gate_raw is None or up_raw is None:
    raise NotImplementedError("fused_gate_up: all weights must trace to a raw uchar buffer")
  z = Tensor.empty(_HIDDEN, dtype=dtypes.float, device=x_norm.device)
  z, *_ = Tensor.custom_kernel(z, x_norm.reshape(-1), gate_raw, up_raw,
                               fxn=functools.partial(_gate_up_kernel, arch=get_arch()))
  return z.reshape(*x_norm.shape[:-1], _HIDDEN)

_GDN_QKV_CONV_HIP_SRC = r"""
#include <hip/hip_runtime.h>
#include <stdint.h>

constexpr int DIM = 1024;
constexpr int CHANNELS = 6144;
constexpr int CONV_KERNEL = 4;
constexpr int THREADS = 32;

extern "C" __global__ __launch_bounds__(THREADS) void gdn_qkv_conv_q8__WEIGHT_OFFSET__(
    float* __restrict__ conv_out,
    float* __restrict__ next_state,
    const float* __restrict__ conv_state,
    const float* __restrict__ x,
    const unsigned char* __restrict__ qkv_w,
    const unsigned char* __restrict__ conv_w) {
  int tid = threadIdx.x;
  int ch0 = blockIdx.x * THREADS * 3 + tid * 3;
  float acc0 = 0.0f, acc1 = 0.0f, acc2 = 0.0f;

  #pragma unroll
  for (int block = 0; block < DIM / 32; block++) {
    int base = __WEIGHT_OFFSET__ + (ch0 * (DIM / 32) + block) * 34;
    const unsigned char* wb0 = qkv_w + base;
    const unsigned char* wb1 = wb0 + (DIM / 32) * 34;
    const unsigned char* wb2 = wb1 + (DIM / 32) * 34;
    float scale0 = float(*reinterpret_cast<const _Float16*>(wb0));
    float scale1 = float(*reinterpret_cast<const _Float16*>(wb1));
    float scale2 = float(*reinterpret_cast<const _Float16*>(wb2));
    #pragma unroll
    for (int i = 0; i < 32; i++) {
      int k = block * 32 + i;
      _Float16 xh = (_Float16)x[k];
      _Float16 wh0 = (_Float16)(scale0 * float(*reinterpret_cast<const int8_t*>(wb0 + 2 + i)));
      _Float16 wh1 = (_Float16)(scale1 * float(*reinterpret_cast<const int8_t*>(wb1 + 2 + i)));
      _Float16 wh2 = (_Float16)(scale2 * float(*reinterpret_cast<const int8_t*>(wb2 + 2 + i)));
      acc0 += float((_Float16)(xh * wh0));
      acc1 += float((_Float16)(xh * wh1));
      acc2 += float((_Float16)(xh * wh2));
    }
  }

  float projected0 = float((_Float16)acc0);
  float projected1 = float((_Float16)acc1);
  float projected2 = float((_Float16)acc2);
  float s00 = conv_state[ch0], s01 = conv_state[CHANNELS + ch0], s02 = conv_state[2 * CHANNELS + ch0];
  float s10 = conv_state[ch0 + 1], s11 = conv_state[CHANNELS + ch0 + 1], s12 = conv_state[2 * CHANNELS + ch0 + 1];
  float s20 = conv_state[ch0 + 2], s21 = conv_state[CHANNELS + ch0 + 2], s22 = conv_state[2 * CHANNELS + ch0 + 2];
  const unsigned char* cw0 = conv_w + ch0 * CONV_KERNEL * 4;
  const unsigned char* cw1 = cw0 + CONV_KERNEL * 4;
  const unsigned char* cw2 = cw1 + CONV_KERNEL * 4;
  _Float16 c00 = (_Float16)(*reinterpret_cast<const float*>(cw0 + 0));
  _Float16 c01 = (_Float16)(*reinterpret_cast<const float*>(cw0 + 4));
  _Float16 c02 = (_Float16)(*reinterpret_cast<const float*>(cw0 + 8));
  _Float16 c03 = (_Float16)(*reinterpret_cast<const float*>(cw0 + 12));
  _Float16 c10 = (_Float16)(*reinterpret_cast<const float*>(cw1 + 0));
  _Float16 c11 = (_Float16)(*reinterpret_cast<const float*>(cw1 + 4));
  _Float16 c12 = (_Float16)(*reinterpret_cast<const float*>(cw1 + 8));
  _Float16 c13 = (_Float16)(*reinterpret_cast<const float*>(cw1 + 12));
  _Float16 c20 = (_Float16)(*reinterpret_cast<const float*>(cw2 + 0));
  _Float16 c21 = (_Float16)(*reinterpret_cast<const float*>(cw2 + 4));
  _Float16 c22 = (_Float16)(*reinterpret_cast<const float*>(cw2 + 8));
  _Float16 c23 = (_Float16)(*reinterpret_cast<const float*>(cw2 + 12));
  conv_out[ch0] = ((s00 * float(c00) + s01 * float(c01)) + s02 * float(c02)) + projected0 * float(c03);
  conv_out[ch0 + 1] = ((s10 * float(c10) + s11 * float(c11)) + s12 * float(c12)) + projected1 * float(c13);
  conv_out[ch0 + 2] = ((s20 * float(c20) + s21 * float(c21)) + s22 * float(c22)) + projected2 * float(c23);
  next_state[ch0] = s01;
  next_state[ch0 + 1] = s11;
  next_state[ch0 + 2] = s21;
  next_state[CHANNELS + ch0] = s02;
  next_state[CHANNELS + ch0 + 1] = s12;
  next_state[CHANNELS + ch0 + 2] = s22;
  next_state[2 * CHANNELS + ch0] = projected0;
  next_state[2 * CHANNELS + ch0 + 1] = projected1;
  next_state[2 * CHANNELS + ch0 + 2] = projected2;
}
"""

@functools.cache
def _compiled_gdn_qkv_conv(weight_offset:int, arch:str) -> bytes:
  from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
  return HIPCCCompiler(arch).compile_cached(_GDN_QKV_CONV_HIP_SRC.replace("__WEIGHT_OFFSET__", str(weight_offset)))

def _gdn_qkv_conv_kernel(conv_out:UOp, next_state:UOp, conv_state:UOp, x:UOp, qkv_w:UOp, conv_w:UOp, arch:str, weight_offset:int=0) -> UOp:
  assert conv_out.numel() == _GDN_CHANNELS and next_state.numel() == (_GDN_CONV_KERNEL - 1) * _GDN_CHANNELS and conv_state.numel() == next_state.numel() and x.numel() == _DIM
  assert qkv_w.numel() >= weight_offset + _q8_bytes(_GDN_CHANNELS * _DIM) and conv_w.numel() == _GDN_CHANNELS * _GDN_CONV_KERNEL * 4
  ops = _GDN_CHANNELS * _DIM * 2 + _GDN_CHANNELS * 8
  mem = _q8_bytes(_GDN_CHANNELS * _DIM) + (_DIM + _GDN_CHANNELS * _GDN_CONV_KERNEL + 2 * _GDN_CHANNELS) * 4
  sink = UOp.sink(
    UOp.special(_GDN_CHANNELS // (32 * 3), "gidx0"), UOp.special(32, "lidx0"),
    conv_out, next_state, conv_state, x, qkv_w, conv_w,
    arg=KernelInfo(name="gdn_qkv_conv_q8", estimates=Estimates(ops=ops, mem=mem)))
  return UOp(Ops.PROGRAM, src=(
    sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)),
    UOp(Ops.SOURCE, arg=_GDN_QKV_CONV_HIP_SRC.replace("__WEIGHT_OFFSET__", str(weight_offset))),
    UOp(Ops.BINARY, arg=_compiled_gdn_qkv_conv(weight_offset, arch))))

def gdn_qkv_conv(conv_state:Tensor, x:Tensor, qkv_w:Tensor, conv_w:Tensor) -> tuple[Tensor, Tensor]:
  assert conv_state.numel() == (_GDN_CONV_KERNEL - 1) * _GDN_CHANNELS and x.numel() == _DIM and conv_w.numel() == _GDN_CHANNELS * _GDN_CONV_KERNEL
  qkv_raw = _find_raw_q8_blocks(qkv_w)
  if qkv_raw is None:
    raise NotImplementedError("gdn_qkv_conv: qkv weight must trace to a raw uchar buffer")
  conv_out = Tensor.empty(_GDN_CHANNELS, dtype=dtypes.float, device=x.device)
  next_state = Tensor.empty(conv_state.shape, dtype=conv_state.dtype, device=x.device)
  conv_raw = _find_raw_q8_blocks(conv_w)
  if conv_raw is None:
    raise NotImplementedError("gdn_qkv_conv: conv weight must trace to a raw uchar buffer")
  conv_out, next_state, *_ = Tensor.custom_kernel(conv_out, next_state.reshape(-1), conv_state.reshape(-1), x.reshape(-1).float(), qkv_raw, conv_raw,
                                                  fxn=functools.partial(_gdn_qkv_conv_kernel, weight_offset=0, arch=get_arch()))
  return conv_out.reshape(1, _GDN_CHANNELS), next_state.reshape(conv_state.shape)

_GDN_RECURRENT_CONV_HIP_SRC = r"""
#include <hip/hip_runtime.h>
#include <stdint.h>

constexpr int HV = 16;
constexpr int V = 128;
constexpr int K = 128;
constexpr int LANES_PER_ROW = 16;
constexpr int ELEMS_PER_LANE = 8;
constexpr int THREADS = 128;
constexpr int GROUPS = THREADS / LANES_PER_ROW;
constexpr int ILP_ROWS = 4;
constexpr int ROWS_PER_BLOCK = GROUPS * ILP_ROWS;

extern "C" __global__ __launch_bounds__(THREADS) void gdn_recurrent_update_conv(
    float* __restrict__ core_out,
    float* __restrict__ state,
    const float* __restrict__ conv_out,
    const float* __restrict__ alpha,
    const _Float16* __restrict__ beta) {
  int tid = threadIdx.x;
  int lane = tid & (LANES_PER_ROW - 1);
  int group = tid >> 4;
  int hv = blockIdx.x;
  int row_base = blockIdx.y * ROWS_PER_BLOCK + group * ILP_ROWS;
  int k_base = lane * ELEMS_PER_LANE;

  float qv[ELEMS_PER_LANE], kv[ELEMS_PER_LANE], h[ILP_ROWS][ELEMS_PER_LANE];
  float qsum = 0.0f, ksum = 0.0f;
  #pragma unroll
  for (int i = 0; i < ELEMS_PER_LANE; i++) {
    int kk = k_base + i;
    float qraw = conv_out[hv * K + kk];
    float kraw = conv_out[HV * K + hv * K + kk];
    qv[i] = qraw;
    kv[i] = kraw;
    qsum += qraw * qraw;
    ksum += kraw * kraw;
  }
  #pragma unroll
  for (int delta = 8; delta > 0; delta >>= 1) {
    qsum += __shfl_xor(qsum, delta, LANES_PER_ROW);
    ksum += __shfl_xor(ksum, delta, LANES_PER_ROW);
  }
  float qscale = rsqrtf(qsum) * 0.08838834764831845f;
  float kscale = rsqrtf(ksum);
  #pragma unroll
  for (int i = 0; i < ELEMS_PER_LANE; i++) {
    qv[i] *= qscale;
    kv[i] *= kscale;
  }

  float a = alpha[hv];
  float b = float(beta[hv]);
  float dot_hk[ILP_ROWS];
  #pragma unroll
  for (int r = 0; r < ILP_ROWS; r++) dot_hk[r] = 0.0f;

  #pragma unroll
  for (int r = 0; r < ILP_ROWS; r++) {
    int row = row_base + r;
    int base = (hv * V + row) * K + k_base;
    #pragma unroll
    for (int i = 0; i < ELEMS_PER_LANE; i++) {
      float hvv = state[base + i] * a;
      h[r][i] = hvv;
      dot_hk[r] += hvv * kv[i];
    }
  }

  #pragma unroll
  for (int delta = 8; delta > 0; delta >>= 1) {
    #pragma unroll
    for (int r = 0; r < ILP_ROWS; r++) dot_hk[r] += __shfl_xor(dot_hk[r], delta, LANES_PER_ROW);
  }

  float dot_hq[ILP_ROWS];
  #pragma unroll
  for (int r = 0; r < ILP_ROWS; r++) {
    int row = row_base + r;
    float vn = (conv_out[2 * HV * K + hv * V + row] - dot_hk[r]) * b;
    dot_hq[r] = 0.0f;
    int base = (hv * V + row) * K + k_base;
    #pragma unroll
    for (int i = 0; i < ELEMS_PER_LANE; i++) {
      float updated = h[r][i] + kv[i] * vn;
      state[base + i] = updated;
      dot_hq[r] += updated * qv[i];
    }
  }

  #pragma unroll
  for (int delta = 8; delta > 0; delta >>= 1) {
    #pragma unroll
    for (int r = 0; r < ILP_ROWS; r++) dot_hq[r] += __shfl_xor(dot_hq[r], delta, LANES_PER_ROW);
  }

  if (lane == 0) {
    #pragma unroll
    for (int r = 0; r < ILP_ROWS; r++) core_out[hv * V + row_base + r] = dot_hq[r];
  }
}
"""

@functools.cache
def _compiled_gdn_recurrent_conv(arch:str) -> bytes:
  from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
  return HIPCCCompiler(arch).compile_cached(_GDN_RECURRENT_CONV_HIP_SRC)

def _gdn_recurrent_conv_kernel(core:UOp, state:UOp, conv_out:UOp, alpha:UOp, beta:UOp, arch:str) -> UOp:
  assert core.numel() == _GDN_HV * _GDN_V and state.numel() == _GDN_HV * _GDN_V * _GDN_K and conv_out.numel() == 3 * _GDN_HV * _GDN_K
  ops = _GDN_HV * _GDN_V * _GDN_K * 4
  mem = (2 * _GDN_HV * _GDN_V * _GDN_K + 3 * _GDN_HV * _GDN_K + _GDN_HV * _GDN_V) * 4
  sink = UOp.sink(
    UOp.special(_GDN_HV, "gidx0"), UOp.special(_GDN_V // 32, "gidx1"), UOp.special(128, "lidx0"),
    core, state, conv_out, alpha, beta,
    arg=KernelInfo(name="gdn_recurrent_update_conv", estimates=Estimates(ops=ops, mem=mem)))
  return UOp(Ops.PROGRAM, src=(
    sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)),
    UOp(Ops.SOURCE, arg=_GDN_RECURRENT_CONV_HIP_SRC), UOp(Ops.BINARY, arg=_compiled_gdn_recurrent_conv(arch))))

def gdn_recurrent_update_conv(state:Tensor, conv_out:Tensor, alpha:Tensor, beta:Tensor) -> Tensor:
  assert state.numel() == _GDN_HV * _GDN_V * _GDN_K and conv_out.numel() == 3 * _GDN_HV * _GDN_K
  core = Tensor.empty(_GDN_HV, _GDN_V, dtype=dtypes.float, device=state.device)
  core, *_ = Tensor.custom_kernel(core, state, conv_out.reshape(-1), alpha.reshape(-1), beta.reshape(-1),
                                  fxn=functools.partial(_gdn_recurrent_conv_kernel, arch=get_arch()))
  return core.reshape(1, 1, _GDN_HV, _GDN_V)

_VOCAB_ROWS_PER_BLOCK = 32
_VOCAB_PARTIALS = (_VOCAB + _VOCAB_ROWS_PER_BLOCK - 1) // _VOCAB_ROWS_PER_BLOCK

_Q8_LMHEAD_PARTIAL_ARGMAX_HIP_SRC = r"""
#include <hip/hip_runtime.h>
#include <stdint.h>
#include <math.h>

constexpr int DIM = 1024;
constexpr int VOCAB = 248320;
constexpr int LANES_PER_ROW = 32;
constexpr int ROWS_PER_BLOCK = 32;
constexpr int THREADS = LANES_PER_ROW * ROWS_PER_BLOCK;
constexpr long WEIGHT_OFFSET = __WEIGHT_OFFSET__;
constexpr float NEG_INF = -3.4028234663852886e38f;
constexpr float LOG2E_INV = 0.6931471805599453f;

extern "C" __global__ __launch_bounds__(THREADS) void q8_lmhead_gumbel_partial_argmax(
    float* __restrict__ partial_scores,
    int* __restrict__ partial_tokens,
    const float* __restrict__ hidden,
    const unsigned char* __restrict__ weight,
    const float* __restrict__ temperature,
    const float* __restrict__ rnd) {
  int tid = threadIdx.x;
  int lane = tid & 31;
  int row = tid >> 5;
  int token = blockIdx.x * ROWS_PER_BLOCK + row;

  float acc = 0.0f;
  if (token < VOCAB) {
    const unsigned char* wbase = weight + WEIGHT_OFFSET;
    int base = (token * (DIM / 32) + lane) * 34;
    float scale = float(*reinterpret_cast<const _Float16*>(wbase + base));
    #pragma unroll
    for (int i = 0; i < 32; i++) {
      acc += hidden[lane * 32 + i] * scale * float(*reinterpret_cast<const int8_t*>(wbase + base + 2 + i));
    }
  }

  #pragma unroll
  for (int delta = 16; delta > 0; delta >>= 1) acc += __shfl_down(acc, delta, 32);

  __shared__ float scores[ROWS_PER_BLOCK];
  __shared__ int tokens[ROWS_PER_BLOCK];
  if (lane == 0) {
    float score = NEG_INF;
    if (token < VOCAB) {
      float u = fminf(fmaxf(rnd[token], 1.0e-12f), 0.9999999403953552f);
      float gumbel = -LOG2E_INV * log2f(-LOG2E_INV * log2f(u));
      score = acc / fmaxf(temperature[0], 1.0e-12f) + gumbel;
    }
    scores[row] = score;
    tokens[row] = token;
  }
  __syncthreads();

  if (tid == 0) {
    float best_score = scores[0];
    int best_token = tokens[0];
    #pragma unroll
    for (int i = 1; i < ROWS_PER_BLOCK; i++) {
      float s = scores[i];
      int t = tokens[i];
      if (s > best_score || (s == best_score && t < best_token)) {
        best_score = s;
        best_token = t;
      }
    }
    partial_scores[blockIdx.x] = best_score;
    partial_tokens[blockIdx.x] = best_token;
  }
}
"""

_Q8_LMHEAD_FINAL_ARGMAX_HIP_SRC = r"""
#include <hip/hip_runtime.h>
#include <stdint.h>

constexpr int PARTIALS = 7760;
constexpr int THREADS = 256;
constexpr float NEG_INF = -3.4028234663852886e38f;

extern "C" __global__ __launch_bounds__(THREADS) void q8_lmhead_gumbel_final_argmax(
    int* __restrict__ out,
    const float* __restrict__ partial_scores,
    const int* __restrict__ partial_tokens) {
  int tid = threadIdx.x;
  float best_score = NEG_INF;
  int best_token = 0;
  for (int i = tid; i < PARTIALS; i += THREADS) {
    float s = partial_scores[i];
    int t = partial_tokens[i];
    if (s > best_score || (s == best_score && t < best_token)) {
      best_score = s;
      best_token = t;
    }
  }

  __shared__ float scores[THREADS];
  __shared__ int tokens[THREADS];
  scores[tid] = best_score;
  tokens[tid] = best_token;
  __syncthreads();

  for (int stride = THREADS / 2; stride > 0; stride >>= 1) {
    if (tid < stride) {
      float s = scores[tid + stride];
      int t = tokens[tid + stride];
      if (s > scores[tid] || (s == scores[tid] && t < tokens[tid])) {
        scores[tid] = s;
        tokens[tid] = t;
      }
    }
    __syncthreads();
  }
  if (tid == 0) out[0] = tokens[0];
}
"""

@functools.cache
def _compiled_q8_lmhead_partial_argmax(weight_offset:int, arch:str) -> bytes:
  from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
  return HIPCCCompiler(arch).compile_cached(
    _Q8_LMHEAD_PARTIAL_ARGMAX_HIP_SRC.replace("__WEIGHT_OFFSET__", str(weight_offset)))

@functools.cache
def _compiled_q8_lmhead_final_argmax(arch:str) -> bytes:
  from tinygrad.runtime.support.compiler_amd import HIPCCCompiler
  return HIPCCCompiler(arch).compile_cached(_Q8_LMHEAD_FINAL_ARGMAX_HIP_SRC)

def _q8_lmhead_partial_argmax_kernel(scores:UOp, tokens:UOp, hidden:UOp, weight:UOp, temperature:UOp, rnd:UOp, arch:str, weight_offset:int=0) -> UOp:
  assert scores.numel() == _VOCAB_PARTIALS and tokens.numel() == _VOCAB_PARTIALS and hidden.numel() == _DIM and weight.numel() >= weight_offset + _q8_bytes(_VOCAB * _DIM) and rnd.numel() == _VOCAB
  ops = _VOCAB * _DIM * 2 + _VOCAB * 8
  mem = _q8_bytes(_VOCAB * _DIM) + (_DIM + _VOCAB) * 4 + _VOCAB_PARTIALS * 8 + 4
  sink = UOp.sink(
    UOp.special(_VOCAB_PARTIALS, "gidx0"), UOp.special(_VOCAB_ROWS_PER_BLOCK * 32, "lidx0"),
    scores, tokens, hidden, weight, temperature, rnd,
    arg=KernelInfo(name="q8_lmhead_gumbel_partial_argmax", estimates=Estimates(ops=ops, mem=mem)))
  return UOp(Ops.PROGRAM, src=(
    sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)),
    UOp(Ops.SOURCE, arg=_Q8_LMHEAD_PARTIAL_ARGMAX_HIP_SRC.replace("__WEIGHT_OFFSET__", str(weight_offset))),
    UOp(Ops.BINARY, arg=_compiled_q8_lmhead_partial_argmax(weight_offset, arch))))

def _q8_lmhead_final_argmax_kernel(out:UOp, scores:UOp, tokens:UOp, arch:str) -> UOp:
  assert out.numel() == 1 and scores.numel() == _VOCAB_PARTIALS and tokens.numel() == _VOCAB_PARTIALS
  sink = UOp.sink(
    UOp.special(1, "gidx0"), UOp.special(256, "lidx0"),
    out, scores, tokens,
    arg=KernelInfo(name="q8_lmhead_gumbel_final_argmax", estimates=Estimates(ops=_VOCAB_PARTIALS, mem=_VOCAB_PARTIALS * 8 + 4)))
  return UOp(Ops.PROGRAM, src=(
    sink, UOp(Ops.DEVICE, arg=Device.DEFAULT), UOp(Ops.LINEAR, src=(*sink.src, sink)),
    UOp(Ops.SOURCE, arg=_Q8_LMHEAD_FINAL_ARGMAX_HIP_SRC), UOp(Ops.BINARY, arg=_compiled_q8_lmhead_final_argmax(arch))))

def q8_lmhead_gumbel_argmax(hidden:Tensor, weight:Tensor, temperature:Tensor) -> Tensor:
  assert hidden.numel() == _DIM
  weight_raw = _find_raw_q8_blocks(weight)
  if weight_raw is None:
    raise NotImplementedError("q8_lmhead_gumbel_argmax: weight must trace to a raw uchar buffer")
  weight_offset = 0
  if (base_and_offset := _base_buffer_with_offset(weight_raw)) is not None:
    weight_raw, weight_offset = base_and_offset
  scores = Tensor.empty(_VOCAB_PARTIALS, dtype=dtypes.float, device=hidden.device)
  tokens = Tensor.empty(_VOCAB_PARTIALS, dtype=dtypes.int, device=hidden.device)
  rnd = Tensor.rand(_VOCAB, dtype=dtypes.float, device=hidden.device, contiguous=False)
  scores, tokens, *_ = Tensor.custom_kernel(scores, tokens, hidden.reshape(-1), weight_raw, temperature.reshape(-1), Tensor(rnd.uop.base),
                                            fxn=functools.partial(_q8_lmhead_partial_argmax_kernel, weight_offset=weight_offset,
                                                                  arch=get_arch()))
  out = Tensor.empty(1, dtype=dtypes.int, device=hidden.device)
  out, *_ = Tensor.custom_kernel(out, scores, tokens,
                                 fxn=functools.partial(_q8_lmhead_final_argmax_kernel, arch=get_arch()))
  return out.reshape(1, 1)
