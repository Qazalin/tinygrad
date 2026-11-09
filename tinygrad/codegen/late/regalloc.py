import itertools
from tinygrad.helpers import dedup
from tinygrad.uop.ops import UOp, Ops, PatternMatcher, UPat
from tinygrad.renderer.x86 import ISARenderer, Register, rdef, regs, with_regs, LinearContext, call_defs, call_uses, reg_cons, reg_storage, \
  storage_base, reg, lower_instruction_call
from typing import Any
from dataclasses import replace

PSEUDO_OPS = {Ops.CONST, Ops.CAST, Ops.BITCAST, Ops.NOOP, Ops.AFTER, Ops.BARRIER, Ops.STACK, Ops.ALLOC, Ops.BUFFER}
VReg = Register|UOp

def is_instr_call(u:UOp) -> bool: return u.op is Ops.CALL and u.body.op is Ops.INS

def regdef(u:UOp) -> VReg|None:
  if (s:=reg_storage(u)) is not None: return storage_base(s)
  return rdef(u)
def instr_defs(u:UOp) -> tuple[VReg,...]: return call_defs(u) if is_instr_call(u) else regs(u)
def instr_uses(u:UOp) -> tuple[VReg,...]:
  if is_instr_call(u): return call_uses(u)
  return tuple(r for s in dedup(u.src) if (r:=regdef(s)) is not None)
def reg_size(v:VReg) -> int: return v.size if isinstance(v, Register) else v.arg.allocation.size if v.arg.allocation is not None else v.dtype.itemsize

def sort_name(v:VReg) -> tuple[str,int]:
  return (v.name, v.index) if isinstance(v, Register) else (str(v.arg.slot), 0)

class LinearScanRegallocContext:
  # the defining allocation for storage, or the instruction that defines a legacy virtual Register
  def vdef(self, v:VReg) -> UOp: return v if isinstance(v, UOp) else self.uops[self.live_range[v][0]]
  def __init__(self, ctx:LinearContext, uops:list[UOp], ren:ISARenderer):
    self.uops = uops
    self.ren = ren
    self.idx = itertools.count()

    # compute live ranges
    self.live_range: dict[VReg, list[int]] = {}
    lr = self.live_range
    loops: dict[int, int] = {} # the interval of each loop, from its RANGE to the last non pseudo uop that reads that RANGE
    for idx,u in reversed(list(enumerate(uops))):
      if u.op in PSEUDO_OPS: continue
      defs = instr_defs(u)
      for v in defs + instr_uses(u): lr.setdefault(v, []).insert(0, idx)
      for v in defs:
        if (n:=max((e for s,e in loops.items() if s <= lr[v][-1] < e), default=None)): lr[v].append(n)
      if u.op is Ops.RANGE: loops[idx] = max(j for j,x in enumerate(uops) if u in x.src and x.op not in PSEUDO_OPS)

    # allocate registers
    self.spills: dict[VReg, Any] = {} # mapping from storage/virtual to arbitrary spill slot
    self.reals: dict[int, dict[VReg, Register]] = {} # mapping from storage/virtual to real at each program point
    self.insert_before: dict[int, list[tuple[VReg, Register]]] = {} # fills to be inserted at each program point
    live: dict[VReg, Register] = {} # mapping from storage/virtual to real that's currently assigned to it
    live_ins: list[dict[VReg, Register]] = [] # mapping from storage/virtual to real at loop entry

    def alloc(cons:tuple[Register, ...], i:int) -> Register:
      live_inv = {v:k for k,v in live.items()}
      # allocate the best register. Registers not in live or not used again are free and have priority,
      # otherwise pick the one with the furthest next use. Regs that appear first in cons have priority in case of a tie
      r,vreg = max(((r,live_inv.get(r)) for r in cons),
                   key=lambda rv: next((j-i for j in ([] if rv[1] is None else lr[rv[1]]) if j >= i), len(uops)))
      return live.pop(vreg) if vreg is not None else r

    # assign register to spilled virtual and record load to be emitted before current uop, also assign it a stack slot
    def fill(v:VReg, i:int, cons:tuple[Register, ...]|None=None) -> Register:
      if v not in self.spills:
        self.spills[v] = ctx.assign_spill_slot(reg_cons(v), self.vdef(v))
      r = alloc(cons if cons is not None else reg_cons(v), i)
      self.insert_before.setdefault(i, []).append((v, r))
      return r

    for i,u in enumerate(uops):
      if u.op in PSEUDO_OPS: continue
      # allocate uses
      for v in instr_uses(u):
        if v not in live: live[v] = fill(v, i)
        self.reals.setdefault(i, {})[v] = live[v]

      # allocate defs
      for j,v in enumerate(instr_defs(u)):
        if v not in live:
          cons = reg_cons(v)
          # two address instructions (src is reused by def) can only coalesce reused src.
          # reused src goes first to get priority in case of a tiebreak
          if ren.is_two_address(u) and j == 0:
            uses = tuple(live.get(s) for s in instr_uses(u))
            cons = ((uses[0],) if uses[0] in cons else ()) + tuple(r for r in cons if r not in uses)
          live[v] = alloc(cons, i+1)
        self.reals.setdefault(i, {})[v] = live[v]

      # loop prologue, avoid loading inside the loop
      if u.op is Ops.RANGE:
        # we move to registers vars used in the loop sorted by next use, vars not used in the loop will not be reloaded in the epilogue
        used_in_loop = [v for v in live.keys() | self.spills.keys() if any(i <= l < loops[i] for l in lr[v])]
        sorted_uses = sorted(used_in_loop, key=lambda k: (next(l-i for l in lr[k] if l >= i), lr[k][0], *sort_name(k)))
        live_in: dict[VReg, Register] = {}
        for v in sorted_uses:
          # if all the possible registers are already in live_in there's no space for this var
          if set(reg_cons(v)).issubset(live_in.values()): continue
          if v not in live: live[v] = fill(v, i)
          live_in[v] = live[v]
        live_ins.append(live_in)

      # loop epilogue at the loop's last reader, reload registers that were live at loop entry
      if i in loops.values():
        # TODO: if a uop is in a different reg in live out vs live in move between registers instead of loading
        # TODO: don't reload if first use in loop is a load
        live_in = live_ins.pop()
        for v,r in live_in.items():
          if v not in live or live[v] != r: live[v] = fill(v, i, (r,))
        # a spilled var that only got a register inside the loop must be forced to reload from spill slot
        for v in list(live.keys()):
          if v in self.spills and v not in live_in: live.pop(v)

def regalloc_rewrite(ctx:LinearScanRegallocContext, x:UOp):
  i = next(ctx.idx)
  if x.op in {Ops.ALLOC, Ops.BUFFER}: return x, []
  if x.op in PSEUDO_OPS: return None
  old = ctx.uops[i]
  original_src = old.src_without_body if is_instr_call(old) else old.src
  assert (is_instr_call(x) == is_instr_call(old)) and len(x.src_without_body if is_instr_call(x) else x.src) == len(original_src), \
    f"regalloc line mismatch at {i}\nOLD: {old}\nNEW: {x}"
  nsrc = []
  def retag(s:UOp, v:VReg, r:Register) -> UOp:
    if s.op in {Ops.AFTER, Ops.BITCAST}: return s.replace(src=(retag(s.src[0],v,r),*s.src[1:]))
    return reg(v.dtype, r) if isinstance(v, UOp) else with_regs(s, (r,))
  for j,s in enumerate(x.src_without_body if is_instr_call(x) else x.src):
    if (v:=regdef(original_src[j])) in ctx.reals.get(i, {}):
      r = replace(ctx.reals[i][v], size=reg_size(v))
      if v in ctx.spills:
        fill = ctx.ren.fill(ctx.spills[v], ctx.vdef(v), r)
        # an AFTER-wrapped value (e.g. a RANGE bound) keeps its ordering deps around the fill
        nsrc.append(s.replace(src=(fill,)+s.src[1:]) if s.op is Ops.AFTER else fill)
      else: nsrc.append(retag(s, v, r))
    else: nsrc.append(s)
  if is_instr_call(x):
    nx = lower_instruction_call(x.replace(src=(x.body, *nsrc)))
  else:
    nx = with_regs(x.replace(src=tuple(nsrc)), tuple(replace(ctx.reals[i][v], size=reg_size(v)) for v in instr_defs(old))) \
      if instr_defs(old) else x.replace(src=tuple(nsrc))

  before = [ctx.ren.fill(ctx.spills[v], ctx.vdef(v), replace(r, size=reg_size(v))) for v,r in ctx.insert_before.get(i, [])]
  after = [ctx.ren.spill(ctx.spills[v], nx) for v in instr_defs(old) if v in ctx.spills]
  return nx, before + [nx] + after

# Every linearized line must advance the index, including residual address expressions.
pm_regalloc_rewrite = PatternMatcher([(UPat(set(Ops), name="x"), regalloc_rewrite)])
