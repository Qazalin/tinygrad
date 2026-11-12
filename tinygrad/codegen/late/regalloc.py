import itertools
from tinygrad.helpers import dedup
from tinygrad.uop.ops import UOp, Ops, PatternMatcher, UPat
from tinygrad.renderer.x86 import ISARenderer, Register, rdef, regs, with_regs, LinearContext
from typing import Any
from dataclasses import replace

PSEUDO_OPS = {Ops.CONST, Ops.CAST, Ops.BITCAST, Ops.NOOP, Ops.AFTER, Ops.BARRIER, Ops.STACK, Ops.BUFFER, Ops.ALLOC, Ops.RESHAPE,
              Ops.OPERAND}

def retag(x:UOp, r:Register) -> UOp:
  if x.op is Ops.CALL and (outputs:=regs(x)):
    dst = outputs[0].replace(arg=replace(outputs[0].arg, reg=r))
    return with_regs(x, (dst,)+outputs[1:])
  if x.op in {Ops.AFTER, Ops.BITCAST, Ops.RESHAPE}: return x.replace(src=(retag(x.src[0],r),*x.src[1:]))
  if x.op not in {Ops.BUFFER, Ops.ALLOC}: raise RuntimeError(f"can't retag {x.op} {x.arg}")
  return x.replace(arg=replace(x.arg, reg=r))

def read_src(u:UOp) -> tuple[UOp, ...]:
  src = u.src[1:len(u.src)-len(regs(u))] if u.op is Ops.CALL else u.src
  return tuple(s for x in src for s in (x.src if x.op is Ops.OPERAND else (x,)))

class LinearScanRegallocContext:
  # returns the uop that defines the virtual register
  def vdef(self, v:UOp) -> UOp: return self.uops[self.live_range[v][0]]
  def __init__(self, ctx:LinearContext, uops:list[UOp], ren:ISARenderer):
    self.uops = uops
    self.ren = ren
    self.idx = itertools.count()

    # compute live ranges
    self.live_range: dict[UOp, list[int]] = {}
    lr = self.live_range
    loops: dict[int, int] = {} # the interval of each loop, from its RANGE to the last non pseudo uop that reads that RANGE
    for idx,u in reversed(list(enumerate(uops))):
      if u.op in PSEUDO_OPS: continue
      defs = regs(u)
      for v in defs + tuple(rdef(s) for s in dedup(read_src(u))):
        if isinstance(v, UOp): lr.setdefault(v, []).insert(0, idx)
      for v in defs:
        if (n:=max((e for s,e in loops.items() if s <= lr[v][-1] < e), default=None)): lr[v].append(n)
      if u.op is Ops.RANGE: loops[idx] = max(j for j,x in enumerate(uops) if u in x.src and x.op not in PSEUDO_OPS)

    # allocate registers
    self.spills: dict[UOp, Any] = {} # mapping from storage to arbitrary spill slot
    self.reals: dict[int, dict[UOp, Register]] = {} # mapping from storage to real at each program point
    self.insert_before: dict[int, list[tuple[UOp, Register]]] = {} # fills to be inserted at each program point
    live: dict[UOp, Register] = {} # mapping from storage to real that's currently assigned to it
    live_ins: list[dict[UOp, Register]] = [] # mapping from storage to real at loop entry

    def alloc(cons:tuple[Register, ...], i:int) -> Register:
      live_inv = {v:k for k,v in live.items()}
      # allocate the best register. Registers not in live or not used again are free and have priority,
      # otherwise pick the one with the furthest next use. Regs that appear first in cons have priority in case of a tie
      reg,vreg = max(((r,live_inv.get(r)) for r in cons),
                    key=lambda rv: next((j-i for j in ([] if rv[1] is None else lr[rv[1]]) if j >= i), len(uops)))
      return live.pop(vreg) if vreg is not None else reg

    # assign register to spilled virtual and record load to be emitted before current uop, also assign it a stack slot
    def fill(v:UOp, i:int, cons:tuple[Register, ...]|None=None) -> Register:
      if v not in self.spills:
        self.spills[v] = ctx.assign_spill_slot(v.arg.reg, self.vdef(v))
      r = alloc(cons if cons is not None else v.arg.reg.cons, i)
      self.insert_before.setdefault(i, []).append((v, r))
      return r

    for i,u in enumerate(uops):
      if u.op in PSEUDO_OPS: continue
      # allocate uses, output bindings are not reads
      for s in read_src(u):
        if not isinstance(v:=rdef(s), UOp): continue
        if v not in live: live[v] = fill(v, i)
        self.reals.setdefault(i, {})[v] = live[v]

      # allocate defs
      if regs(u):
        for j,v in enumerate(regs(u)):
          if v not in live:
            cons = v.arg.reg.cons
            # two address instructions (src is reused by def) can only coalesce reused src.
            # reused src goes first to get priority in case of a tiebreak
            if ren.is_two_address(u) and j == 0:
              uses = tuple(live.get(rdef(s)) for s in read_src(u))
              cons = ((uses[0],) if uses[0] in cons else ()) + tuple(r for r in cons if r not in uses)
            live[v] = alloc(cons, i+1)
          self.reals.setdefault(i, {})[v] = live[v]

      # loop prologue, avoid loading inside the loop
      if u.op is Ops.RANGE:
        # we move to registers vars used in the loop sorted by next use, vars not used in the loop will not be reloaded in the epilogue
        used_in_loop = [v for v in live.keys() | self.spills.keys() if any(i <= l < loops[i] for l in lr[v])]
        sorted_uses = sorted(used_in_loop, key=lambda k: (next(l-i for l in lr[k] if l >= i), lr[k][0], k.arg.reg.name, k.arg.reg.index))
        live_in: dict[UOp, Register] = {}
        for v in sorted_uses:
          # if all the possible registers are already in live_in there's no space for this var
          if set(v.arg.reg.cons).issubset(live_in.values()): continue
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
  if x.op in PSEUDO_OPS: return None
  nsrc = []
  for j,s in enumerate(x.src):
    original = ctx.uops[i].src[j]
    old_fields = original.src if original.op is Ops.OPERAND else (original,)
    fields = s.src if s.op is Ops.OPERAND else (s,)
    assert len(old_fields) == len(fields), "regalloc cannot change the structure of an instruction operand"
    new_fields, changed = [], False
    for old,field in zip(old_fields, fields):
      # v here is the virtual defined by the original field as field is the rewritten version
      if (v:=rdef(old)) in ctx.reals.get(i, {}):
        reg = replace(ctx.reals[i][v], size=v.arg.reg.size)
        if v in ctx.spills:
          fill = ctx.ren.fill(ctx.spills[v], ctx.vdef(v), reg)
          # an AFTER-wrapped value (e.g. a RANGE bound) keeps its ordering deps around the fill
          field = field.replace(src=(fill,)+field.src[1:]) if field.op is Ops.AFTER else fill
        else: field = retag(field, reg)
        changed = True
      new_fields.append(field)
    nsrc.append(s.replace(src=tuple(new_fields)) if changed and s.op is Ops.OPERAND else new_fields[0] if changed else s)
  defs = tuple(v.replace(arg=replace(v.arg, reg=replace(ctx.reals[i][v], size=v.arg.reg.size))) for v in regs(x))
  nx = with_regs(x.replace(src=tuple(nsrc)), defs) if defs else x.replace(src=tuple(nsrc))

  before = [ctx.ren.fill(ctx.spills[v], ctx.vdef(v), replace(r, size=v.arg.reg.size)) for v,r in ctx.insert_before.get(i, [])]
  after = [ctx.ren.spill(ctx.spills[v], nx) for v in regs(x) if v in ctx.spills]

  return nx, before + [nx] + after

pm_regalloc_rewrite = PatternMatcher([
  (UPat({Ops.CALL, Ops.RANGE, Ops.END} | PSEUDO_OPS, name="x"), regalloc_rewrite),
])
