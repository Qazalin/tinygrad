from tinygrad import Tensor, Device, dtypes
from tinygrad.runtime.autogen.amd.rdna4.ins import *
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from extra.gemm.amd_asm_matmul import Kernel
from tinygrad.renderer.amd.sqtt import map_insts, format_packet

device = Device[Device.DEFAULT]
arch = device.arch
N_WAVES = 2

k = Kernel(arch)
k.emit(s_load_b128(s[0:3], s[0:1], NULL))
k.waitcnt(lgkm=0)
k.emit(v_mov_b32_e32(v[0], 0))
k.emit(v_mov_b32_e32(v[1], 0))
k.emit(global_load_b32(v[2], v[0:1], s[2:3]))
k.waitcnt(lgkm=0, vm=0)
k.emit(global_store_b32(vaddr=v[0:1], saddr=s[0:1], vsrc=v[2]))
k.emit(s_endpgm())

def fxn(out:UOp, A:UOp) -> UOp:
  lidx = UOp.special(1, "lidx0")
  sink = UOp.sink(out, A, lidx, arg=KernelInfo(name="test"))
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in k.finalize()]))))

a = Tensor([1, 1], dtype=dtypes.int32).realize()
out = Tensor.empty_like(a)
out = Tensor.custom_kernel(out, a, fxn=fxn)[0]
out.realize()
print(out.numpy())

programs:dict[int, bytes] = {}
for e in device.profile_events:
  if type(e).__name__ == "ProfileProgramEvent": programs[e.tag] = e.lib
  if type(e).__name__ == "ProfileSQTTEvent":
    for pkt,inst in map_insts(e.blob, programs[e.kern], arch):
      if inst is None: continue
      print(format_packet(pkt), inst.inst)
