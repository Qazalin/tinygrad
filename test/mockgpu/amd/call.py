import ctypes, itertools
from tinygrad.viz.serve import amd_decode, amdgpu_cfg, COND_TAKEN, COND_NOT_TAKEN
from tinygrad.uop.ops import UOp, Ops, KernelInfo, PatternMatcher, UPat, graph_rewrite, rewrite_group
from tinygrad.codegen import to_program
from tinygrad.device import Device
from tinygrad.dtype import Invalid
from tinygrad.helpers import Context, getenv, TracingKey
from test.mockgpu.amd.emu import _Ctx, _get_handler, _wave_size, _canonical_info, PC_LO_IDX, PC_HI_IDX

asm_call_counter = itertools.count(1)

def pc_index(idx:int) -> UPat:
  reg, null = UPat.const(idx).cast(), UPat.const(124).cast()
  return UPat.any(reg, reg.ne(null).where(reg, UPat.const(Invalid)))

pm_asm_call = PatternMatcher([
  (UPat((Ops.LOAD, Ops.STORE), src=(UPat(Ops.PARAM, name="buf").index(UPat.any(pc_index(PC_LO_IDX), pc_index(PC_HI_IDX))),), allow_any_len=True),
   lambda buf: UOp(Ops.NOOP) if buf.arg.name == "sgpr" else None),
])

pm_pc_store_value = PatternMatcher([
  (UPat(Ops.STORE, src=(UPat(Ops.INDEX, src=(UPat(Ops.PARAM, name="buf"), pc_index(PC_LO_IDX))), UPat(name="val")), allow_any_len=True),
   lambda buf,val: val if buf.arg.name == "sgpr" else None),
])

def branch_cond(sink:UOp) -> UOp|None:
  for u in sink.toposort():
    if (val:=pm_pc_store_value.rewrite(u)) is None: continue
    while val.op is Ops.CAST: val = val.src[0]
    if val.op is Ops.WHERE: return val.src[0]
  return None

@rewrite_group(name=lambda *args,ret,**_: TracingKey(f"Lift {(k:=ret.src[0].arg).name}", (("lift", k.function_name),)))
def lift(lib: int, lib_sz: int, arch: str = "rdna3", backend: str|None = None) -> UOp:
  backend = getenv("ASM_CALL_BACKEND", "CPU") if backend is None else backend
  # decode
  lib_bytes = ctypes.string_at(lib, lib_sz)
  insts, cfg = amd_decode(lib_bytes, arch), amdgpu_cfg(lib_bytes, arch)
  # construct CALL graph
  afters: dict[UOp, UOp] = {}
  loops = {pc:UOp.loop(i) for i,(pc,paths) in enumerate(cfg["data"]["paths"].items()) if pc in paths}
  for bpc, block in cfg["data"]["blocks"].items():
    loop, loop_cond = loops.get(bpc), None
    for off in block:
      inst = insts[off]
      inst_st = str(inst)
      if inst_st.startswith("s_code_end"): continue
      if inst_st.startswith(("s_getpc", "s_setpc")): raise AssertionError("getpc and setpc are not allowed in ASM_CALL")
      ctx = _Ctx(inst.size(), _wave_size(arch), inst_addr=lib+off)
      sink = _get_handler(inst)(inst, ctx)
      *_, canonical_name = _canonical_info(inst, ctx, lib_bytes[off:])
      bufs = sorted((u for u in sink.toposort() if u.op is Ops.PARAM), key=lambda u: u.arg.slot)
      body = sink.substitute(dict(zip(bufs, params:=[b.param_like(i, name=b.arg.name) for i,b in enumerate(bufs)])))
      args = [afters.get(b, b) for b in bufs]
      if loop is not None:
        args = [x.after(loop) for x in args]
        if (cond:=branch_cond(body)) is not None:
          cond = cond.substitute(dict(zip(params, args)), walk=True)
          loop_cond = cond != True if cfg["data"]["paths"][bpc][bpc] == COND_NOT_TAKEN else cond
      call = body.call(*args, name=canonical_name)
      afters.update((b, arg.after(call)) for b, arg in zip(bufs, args))
    if loop is not None:
      backedge = UOp.sink(*afters.values()).backedge(loop, loop_cond if loop_cond is not None else False)
      afters = {b:x.after(backedge) for b,x in afters.items()}
  sink = UOp.sink(*afters.values(), arg=KernelInfo(name=f"asm_call n{next(asm_call_counter)}", opts_to_apply=()))
  sink = graph_rewrite(sink, pm_asm_call, name="pm_asm_call", bottom_up=True, enter_calls=True)
  with Context(NOOPT=1, CHECK_OOB=0, TUPLE_ORDER=0, EMULATED_DTYPES="", CAPTURE_PROCESS_REPLAY=0):
    return to_program(sink, Device[backend].renderer)
