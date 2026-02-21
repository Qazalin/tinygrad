from tinygrad import Tensor, Device, dtypes
from tinygrad.runtime.autogen.amd.rdna4.ins import *
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from extra.gemm.amd_asm_matmul import Kernel
from tinygrad.renderer.amd.sqtt import map_insts, format_packet

device = Device[Device.DEFAULT]
arch = device.arch
N_WAVES = 2

k = Kernel(arch)
k.emit(s_load_b64(s[0:1], s[0:1], NULL))
k.emit(v_mov_b32_e32(v[0], 0))
k.emit(v_mov_b32_e32(v[1], 0))
k.emit(global_load_b32(v[1], v[0:1], s[0:1]))
k.emit(s_endpgm())

def fxn(A:UOp) -> UOp:
  lidx = UOp.special(N_WAVES*32, "lidx0")
  sink = UOp.sink(lidx, arg=KernelInfo(name="test"))
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in k.finalize()]))))
a = Tensor([1], dtype=dtypes.int32).realize()
a = Tensor.custom_kernel(a, fxn=fxn)[0]
a.realize()
print(a.numpy())

programs:dict[int, bytes] = {}
for e in device.profile_events:
  if type(e).__name__ == "ProfileProgramEvent": programs[e.tag] = e.lib
  if type(e).__name__ == "ProfileSQTTEvent":
    for pkt,inst in map_insts(e.blob, programs[e.kern], arch):
      if inst is None: continue
      print(format_packet(pkt), inst.inst)
