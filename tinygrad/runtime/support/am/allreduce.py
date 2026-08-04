from __future__ import annotations
import functools
from typing import Any
from tinygrad.device import Buffer, BufferSpec, Device, MultiBuffer, TinyELF
from tinygrad.dtype import dtypes
from tinygrad.helpers import Target, round_up

CHANNELS, THREADS = 112, 256

# RCCL 2.27.7 channel rings from AMD's MI350X MLPerf v6 submission. RCCL rank -> tinygrad device is derived from the PCI BDFs in its trace.
_AMD_TO_TINY = (3, 0, 2, 1, 7, 4, 6, 5)
_AMD_RINGS = (
  (0,5,7,6,4,1,3,2), (0,5,7,4,6,1,3,2), (0,6,7,4,1,2,5,3), (0,7,1,2,5,6,3,4),
  (0,3,7,2,4,5,6,1), (0,7,3,6,2,4,5,1), (0,6,2,7,1,5,3,4), (0,2,3,1,4,6,7,5),
  (0,2,3,1,6,4,7,5), (0,3,5,2,1,4,7,6), (0,4,3,6,5,2,1,7), (0,1,6,5,4,2,7,3),
  (0,1,5,4,2,6,3,7), (0,4,3,5,1,7,2,6),
)
RINGS = tuple(tuple(_AMD_TO_TINY[r] for r in ring) for ring in _AMD_RINGS) * 8
_RING_SRC = ",\n".join("{" + ",".join(map(str, ring)) + "}" for ring in RINGS)

class _PeerBuffer(Buffer):
  """A dependency-visible peer view which does not own the shared allocation."""
  def deallocate(self): self._bufs.clear()

SRC = r'''
typedef __bf16 bf16;
typedef bf16 bf16x8 __attribute__((ext_vector_type(8)));
#define LOAD_FLAG(ptr) __atomic_load_n(ptr, __ATOMIC_RELAXED)
#define STORE_FLAG(ptr, value) do { __builtin_amdgcn_fence(__ATOMIC_SEQ_CST, "agent"); __atomic_store_n(ptr, value, __ATOMIC_RELAXED); } while (0)
#define LOAD_FIFO8(ptr) __builtin_nontemporal_load((const bf16x8 *)(ptr))
#define STORE_FIFO8(ptr, value) __builtin_nontemporal_store(value, (bf16x8 *)(ptr))
#define LOAD_FIFO(ptr) __builtin_nontemporal_load((const bf16 *)(ptr))
#define STORE_FIFO(ptr, value) __builtin_nontemporal_store(value, (bf16 *)(ptr))
__attribute__((address_space(4))) const unsigned char rings[112][8] = {
$RINGS
};

extern "C" __attribute__((global)) void __attribute__((amdgpu_flat_work_group_size(256, 256))) amd_allreduce_ring(
    bf16 *out, const bf16 *in, bf16 *comm0, bf16 *comm1, bf16 *comm2, bf16 *comm3,
    bf16 *comm4, bf16 *comm5, bf16 *comm6, bf16 *comm7,
    unsigned rank, unsigned nranks, unsigned numel, unsigned channels, unsigned epoch, unsigned capacity) {
  const unsigned tid = __builtin_amdgcn_workitem_id_x();
  const unsigned channel = __builtin_amdgcn_workgroup_id_x();
  bf16 *comms[8] = {comm0, comm1, comm2, comm3, comm4, comm5, comm6, comm7};
  unsigned pos = 0;
  while (rings[channel][pos] != rank) pos++;
  bf16 *local = comms[rank];
  bf16 *next = comms[rings[channel][(pos + 1) % nranks]];
  bf16 *prev = comms[rings[channel][(pos + nranks - 1) % nranks]];
  const unsigned chunk = (numel + nranks - 1) / nranks;
  const unsigned vecs = chunk / 8;
  const unsigned stride = channels * 256;
  const unsigned data_elems = 2 * capacity;
  unsigned __attribute__((address_space(1))) *local_ready = (unsigned __attribute__((address_space(1))) *)(local + data_elems);
  unsigned __attribute__((address_space(1))) *local_ack = local_ready + 2 * 112;
  unsigned __attribute__((address_space(1))) *next_ready = (unsigned __attribute__((address_space(1))) *)(next + data_elems);
  unsigned __attribute__((address_space(1))) *prev_ack = (unsigned __attribute__((address_space(1))) *)(prev + data_elems) + 2 * 112;

  // Reduce-scatter. Keep partials in the transport slot and only write the final shard to out.
  for (unsigned step = 0; step < nranks - 1; step++) {
    const unsigned seq = epoch + step + 1, slot = step & 1;
    const unsigned send_chunk = (pos + nranks - step) % nranks;
    const unsigned recv_chunk = (send_chunk + nranks - 1) % nranks;
    if (tid == 0 && step >= 2)
      while (LOAD_FLAG(local_ack + slot * 112 + channel) < seq - 2) { }
    __builtin_amdgcn_s_barrier();
    for (unsigned v = channel * 256 + tid; v < vecs; v += stride) {
      unsigned src = send_chunk * chunk + v * 8;
      bf16x8 value = {};
      if (src + 8 <= numel) value = step == 0 ? *(const bf16x8 *)(in + src) : LOAD_FIFO8(local + ((step-1)&1) * capacity + v * 8);
      STORE_FIFO8(next + slot * capacity + v * 8, value);
    }
    for (unsigned i = vecs * 8 + channel * 256 + tid; i < chunk; i += stride) {
      unsigned src = send_chunk * chunk + i;
      STORE_FIFO(next + slot * capacity + i, src < numel ? (step == 0 ? in[src] : LOAD_FIFO(local + ((step-1)&1) * capacity + i)) : (bf16)0.0f);
    }
    __builtin_amdgcn_s_barrier();
    if (tid == 0 && step != 0) STORE_FLAG(prev_ack + ((step-1)&1) * 112 + channel, seq - 1);
    if (tid == 0) STORE_FLAG(next_ready + slot * 112 + channel, seq);
    if (tid == 0) while (LOAD_FLAG(local_ready + slot * 112 + channel) < seq) { }
    __builtin_amdgcn_s_barrier();
    for (unsigned v = channel * 256 + tid; v < vecs; v += stride) {
      unsigned dst = recv_chunk * chunk + v * 8;
      if (dst + 8 <= numel) {
        bf16x8 value = LOAD_FIFO8(local + slot * capacity + v * 8) + *(const bf16x8 *)(in + dst);
        if (step == nranks-2) *(bf16x8 *)(out + dst) = value;
        else STORE_FIFO8(local + slot * capacity + v * 8, value);
      }
    }
    for (unsigned i = vecs * 8 + channel * 256 + tid; i < chunk; i += stride) {
      unsigned dst = recv_chunk * chunk + i;
      if (dst < numel) {
        bf16 value = (bf16)((float)LOAD_FIFO(local + slot * capacity + i) + (float)in[dst]);
        if (step == nranks-2) out[dst] = value;
        else STORE_FIFO(local + slot * capacity + i, value);
      }
    }
    __builtin_amdgcn_s_barrier();
    if (tid == 0 && step == nranks-2) STORE_FLAG(prev_ack + slot * 112 + channel, seq);
    __builtin_amdgcn_s_barrier();
  }

  // All-gather the reduced shards.
  const unsigned owner = (pos + 1) % nranks;
  for (unsigned step = 0; step < nranks - 1; step++) {
    const unsigned opstep = nranks - 1 + step, seq = epoch + opstep + 1, slot = opstep & 1;
    const unsigned send_chunk = (owner + nranks - step) % nranks;
    const unsigned recv_chunk = (send_chunk + nranks - 1) % nranks;
    if (tid == 0) while (LOAD_FLAG(local_ack + slot * 112 + channel) < seq - 2) { }
    __builtin_amdgcn_s_barrier();
    for (unsigned v = channel * 256 + tid; v < vecs; v += stride) {
      unsigned src = send_chunk * chunk + v * 8;
      bf16x8 value = {};
      if (src + 8 <= numel) value = *(bf16x8 *)(out + src);
      STORE_FIFO8(next + slot * capacity + v * 8, value);
    }
    for (unsigned i = vecs * 8 + channel * 256 + tid; i < chunk; i += stride) {
      unsigned src = send_chunk * chunk + i;
      STORE_FIFO(next + slot * capacity + i, src < numel ? out[src] : (bf16)0.0f);
    }
    __builtin_amdgcn_s_barrier();
    if (tid == 0) STORE_FLAG(next_ready + slot * 112 + channel, seq);
    if (tid == 0) while (LOAD_FLAG(local_ready + slot * 112 + channel) < seq) { }
    __builtin_amdgcn_s_barrier();
    for (unsigned v = channel * 256 + tid; v < vecs; v += stride) {
      unsigned dst = recv_chunk * chunk + v * 8;
      if (dst + 8 <= numel) *(bf16x8 *)(out + dst) = LOAD_FIFO8(local + slot * capacity + v * 8);
    }
    for (unsigned i = vecs * 8 + channel * 256 + tid; i < chunk; i += stride) {
      unsigned dst = recv_chunk * chunk + i;
      if (dst < numel) out[dst] = LOAD_FIFO(local + slot * capacity + i);
    }
    __builtin_amdgcn_s_barrier();
    if (tid == 0) STORE_FLAG(prev_ack + slot * 112 + channel, seq);
    __builtin_amdgcn_s_barrier();
  }
}
'''.replace("$RINGS", _RING_SRC)

class AMDAllReduce:
  def __init__(self, devices:tuple[str, ...]):
    self.devices = tuple(Device[d] for d in devices)
    self.lib = self.devices[0].compiler.compile_cached(SRC)
    sig = tuple((None, 0, dtypes.uint32, ()) for _ in range(6))
    self.prgs = [d.runtime(TinyELF(self.lib, "amd_allreduce_ring", Target("AMD", arch=d.arch), sig)) for d in self.devices]
    self.comm:list[Any] = []
    self.comm_size, self.comm_capacity, self.epoch = 0, 0, 0
    self.comm_uops, self.comm_owner_bufs, self.comm_mbufs = None, [], []

  def _ensure_comm(self, numel:int):
    chunk = (numel + len(self.devices) - 1) // len(self.devices)
    size = round_up(2 * chunk * 2 + 4 * CHANNELS * 4, 2 << 20)
    if size <= self.comm_size: return
    assert self.comm_uops is None, "allreduce FIFO addresses are frozen after graph capture"
    for d in self.devices: d.synchronize()
    for d,b in zip(self.devices, self.comm): d.allocator._free(b, BufferSpec(coherent=True, nolru=True))
    self.comm = [d.allocator.alloc(size, BufferSpec(coherent=True, nolru=True)) for d in self.devices]
    zero = memoryview(bytearray(size))
    for d,b in zip(self.devices, self.comm): d.allocator._copyin(b, zero)
    for d in self.devices: d.synchronize()
    for rank,d in enumerate(self.devices):
      for peer,b in enumerate(self.comm):
        if peer != rank: d.allocator._map(b)
    self.comm_size, self.comm_capacity = size, (size - 4 * CHANNELS * 4) // 4

  def __call__(self, out:MultiBuffer, inp:MultiBuffer, wait=False, timeout=None):
    assert len(out.bufs) == len(inp.bufs) == len(self.devices)
    numel = out.bufs[0].size
    self._ensure_comm(numel)
    channels = min(CHANNELS, max(1, ((numel + len(self.devices) - 1) // len(self.devices) * 2 + (32 << 10) - 1) // (32 << 10)))
    self.epoch += 32
    for rank,(d,prg) in enumerate(zip(self.devices, self.prgs)):
      prg(out.bufs[rank].get_buf(d.device), inp.bufs[rank].get_buf(d.device), *self.comm,
          vals=(rank, len(self.devices), numel, channels, self.epoch, self.comm_capacity),
          global_size=(channels, 1, 1), local_size=(THREADS, 1, 1), wait=False)
    if wait:
      for d in self.devices: d.synchronize()

  def graph_comm_uops(self):
    if self.comm_uops is not None: return self.comm_uops
    # The largest Llama 8B collective is 1 GiB/rank. Freeze the graph FIFO at that size so all graph programs keep stable addresses.
    self._ensure_comm(536870912)
    from tinygrad.uop.ops import UOp, buffers
    comm_uops = []
    self.comm_owner_bufs = [Buffer(d.device, self.comm_size//2, dtypes.bfloat16, opaque=raw,
                                   options=BufferSpec(coherent=True, nolru=True)) for d,raw in zip(self.devices, self.comm)]
    for owner in self.comm_owner_bufs:
      mb = MultiBuffer.__new__(MultiBuffer)
      # Rank-local views keep graph dependencies ordered per queue without serializing the eight concurrent ring ranks.
      mb.bufs = []
      for d in self.devices:
        peer = _PeerBuffer(d.device, self.comm_size//2, dtypes.bfloat16, options=BufferSpec(coherent=True, nolru=True))
        peer.allocator, peer._bufs[d.device] = d.allocator, owner._buf
        mb.bufs.append(peer)
      u = UOp.new_buffer(tuple(d.device for d in self.devices), self.comm_size//2, dtypes.bfloat16)
      buffers[u] = mb.ref(1)
      comm_uops.append(u)
      self.comm_mbufs.append(mb)
    self.comm_uops = tuple(comm_uops)
    return self.comm_uops

@functools.cache
def get_allreduce(devices:tuple[str, ...]) -> AMDAllReduce: return AMDAllReduce(devices)

def run_amd_allreduce(out:Buffer|MultiBuffer, inp:Buffer|MultiBuffer, wait=False, timeout=None):
  assert isinstance(out, MultiBuffer) and isinstance(inp, MultiBuffer)
  get_allreduce(tuple(b.device for b in out.bufs))(out, inp, wait=wait, timeout=timeout)

def reserve_graph_epoch(devices:tuple[str, ...], count:int) -> int:
  ar = get_allreduce(devices)
  base = ar.epoch + 32
  ar.epoch += count * 32
  return base

def graph_amd_allreduce(call, collective_id:int):
  from tinygrad.uop.ops import UOp, Ops, KernelInfo, ProgramInfo
  out, inp = call.src[1:3]
  assert isinstance(out.buffer, MultiBuffer) and out.max_numel() == out.buffer.bufs[0].size, \
    f"allreduce logical/physical size mismatch: {out.max_numel()} != {out.buffer.bufs[0].size}"
  devices = tuple(out.device)
  ar = get_allreduce(devices)
  comms = ar.graph_comm_uops()
  rank = UOp.variable("_device_num", 0, 7, dtype=dtypes.uint32)
  nranks = UOp.variable("_ar_nranks_8", 8, 8, dtype=dtypes.uint32)
  numel = UOp.variable(f"_ar_numel_{out.max_numel()}", out.max_numel(), out.max_numel(), dtype=dtypes.uint32)
  channels_n = min(CHANNELS, max(1, ((out.max_numel()+7)//8*2 + (32<<10)-1)//(32<<10)))
  channels = UOp.variable(f"_ar_channels_{channels_n}", channels_n, channels_n, dtype=dtypes.uint32)
  epoch = UOp.variable(f"_ar_epoch_{collective_id}", 0, 0xffffffff, dtype=dtypes.uint32)
  capacity = UOp.variable(f"_ar_capacity_{ar.comm_capacity}", ar.comm_capacity, ar.comm_capacity, dtype=dtypes.uint32)
  params = tuple(UOp.param(i, dtypes.bfloat16, (x.max_numel(),)) for i,x in enumerate((out, inp, *comms)))
  sink = UOp.sink(*params, arg=KernelInfo("amd_allreduce_ring"))
  info = ProgramInfo("amd_allreduce_ring", (channels_n,1,1), (THREADS,1,1), (rank,nranks,numel,channels,epoch,capacity),
                     tuple(range(10)), (0,2,3,4,5,6,7,8,9), (1,2,3,4,5,6,7,8,9), Target("AMD", arch=ar.devices[0].arch))
  prg = UOp(Ops.PROGRAM, src=(sink, UOp(Ops.LINEAR, src=(*params, sink)), UOp(Ops.SOURCE, arg=SRC), UOp(Ops.BINARY, arg=ar.lib)), arg=info)
  return call.replace(src=(prg, out, inp, *comms))
