#!/usr/bin/env python3
import argparse, statistics

from tinygrad import Device
from tinygrad.device import Buffer
from tinygrad.dtype import dtypes
from tinygrad.helpers import Context, GlobalCounters

def gather_source(out_size:int, in_size:int, shards:int, threads:int) -> tuple[str, str, tuple[int, int, int], tuple[int, int, int]]:
  elems_per_thread = 16
  assert in_size % (elems_per_thread * threads) == 0
  name = f"bench_gather_{out_size}_{in_size}_{shards}"
  args = ",\n    ".join([f"hip_bfloat16* data0_{out_size}"] + [f"hip_bfloat16* data{i}_{in_size}" for i in range(1, shards+1)])
  srcs = ", ".join(f"(u32x4*)data{i}_{in_size}" for i in range(1, shards+1))
  vecs_per_input = in_size // 8
  groups_per_input = in_size // (elems_per_thread * threads)
  source = f'''typedef long unsigned int size_t;
typedef __bf16 hip_bfloat16;
typedef unsigned int u32x4 __attribute__((ext_vector_type(4)));
extern "C" __attribute__((device, const)) size_t __ockl_get_local_id(unsigned int);
extern "C" __attribute__((device, const)) size_t __ockl_get_group_id(unsigned int);
extern "C" __attribute__((global)) void __attribute__((amdgpu_flat_work_group_size(1, {threads}))) {name}(
    {args}) {{
  int tid = __ockl_get_local_id(0);
  int gid = __ockl_get_group_id(0);
  int shard = __ockl_get_group_id(1);
  int local_v = (gid * {threads} + tid) * 2;
  int v = shard * {vecs_per_input} + local_v;
  u32x4 *dst = (u32x4*)data0_{out_size};
  u32x4 *srcs[{shards}] = {{{srcs}}};
  u32x4 *src = srcs[shard];
  dst[v] = src[local_v];
  dst[v+1] = src[local_v+1];
}}'''
  return source, name, (groups_per_input, shards, 1), (threads, 1, 1)

def make_buffers(device:str, in_size:int, shards:int) -> tuple[Buffer, list[Buffer]]:
  out = Buffer(device, in_size * shards, dtypes.bfloat16).allocate()
  ins = [Buffer(device, in_size, dtypes.bfloat16).allocate() for _ in range(shards)]
  Device[device].synchronize()
  return out, ins

def time_sdma_batched(device:str, out:Buffer, ins:list[Buffer], submit_each:bool=False) -> float:
  dev = Device[device]
  assert dev.hw_copy_queue_t is not None, f"{device} has no SDMA copy queue"
  st, en = dev.new_signal(), dev.new_signal()
  q = dev.hw_copy_queue_t().wait(dev.timeline_signal, dev.timeline_value - 1).timestamp(st)
  for i, src in enumerate(ins):
    q.copy(out._buf.offset(i * src.nbytes, src.nbytes), src._buf, src.nbytes)
    if submit_each and i != len(ins)-1:
      q.signal(dev.timeline_signal, dev.next_timeline()).submit(dev)
      q = dev.hw_copy_queue_t().wait(dev.timeline_signal, dev.timeline_value - 1)
  q.timestamp(en).signal(dev.timeline_signal, dev.next_timeline()).submit(dev)
  dev.synchronize()
  return float(en.timestamp - st.timestamp) / 1e6

def summarize(label:str, times:list[float], bytes_moved:int) -> None:
  us = [x * 1e6 for x in times]
  med = statistics.median(us)
  mean = statistics.mean(us)
  gbps = bytes_moved / statistics.median(times) / 1e9
  print(f"{label:20s} median {med:9.2f} us  mean {mean:9.2f} us  min {min(us):9.2f} us  {gbps:8.1f} GB/s")

def bench_one(device:str, in_size:int, shards:int, iters:int, warmup:int, threads:int, separate_submit:bool) -> None:
  dev = Device[device]
  assert device.startswith("AMD"), f"expected AMD device, got {device}"
  out, ins = make_buffers(device, in_size, shards)
  source, name, global_size, local_size = gather_source(in_size * shards, in_size, shards, threads)
  prg = dev.runtime(name, dev.compiler.compile_cached(source))
  bytes_moved = in_size * shards * dtypes.bfloat16.itemsize

  gather_times, sdma_times, sdma_split_times = [], [], []
  for i in range(warmup + iters):
    gt = prg(out._buf, *[x._buf for x in ins], global_size=global_size, local_size=local_size, wait=True)
    st = time_sdma_batched(device, out, ins)
    sst = time_sdma_batched(device, out, ins, submit_each=True) if separate_submit else None
    if i >= warmup:
      gather_times.append(gt)
      sdma_times.append(st)
      if sst is not None: sdma_split_times.append(sst)

  print(f"\n{device}: {shards} x {in_size} bf16 -> {in_size*shards} bf16 ({bytes_moved/1e6:.1f} MB)")
  print(f"kernel launch: global={global_size} local={local_size}")
  summarize("fast_gather", gather_times, bytes_moved)
  summarize("sdma batched", sdma_times, bytes_moved)
  if sdma_split_times: summarize("sdma 1 submit/copy", sdma_split_times, bytes_moved)

def main():
  parser = argparse.ArgumentParser(description="Compare fast gather kernel against SDMA offset copies for shard concatenation")
  parser.add_argument("--device", default=Device.DEFAULT, help="AMD device to benchmark, for example AMD or AMD:1")
  parser.add_argument("--in-size", type=int, default=14680064, help="elements per input shard")
  parser.add_argument("--shards", type=int, default=8)
  parser.add_argument("--threads", type=int, default=256)
  parser.add_argument("--iters", type=int, default=20)
  parser.add_argument("--warmup", type=int, default=5)
  parser.add_argument("--all-fast-gather-shapes", action="store_true", help="benchmark the four shapes seen in train @ 2..3")
  parser.add_argument("--separate-submit", action="store_true", help="also benchmark one SDMA submit per shard copy")
  args = parser.parse_args()

  with Context(DEBUG=0):
    GlobalCounters.reset()
    shapes = [14680064, 7340032, 3145728, 2097152] if args.all_fast_gather_shapes else [args.in_size]
    for in_size in shapes: bench_one(args.device, in_size, args.shards, args.iters, args.warmup, args.threads, args.separate_submit)

if __name__ == "__main__": main()
