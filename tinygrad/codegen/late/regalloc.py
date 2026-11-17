import itertools
from tinygrad.helpers import dedup, unwrap
from tinygrad.uop.ops import UOp, Ops, PatternMatcher, UPat
from tinygrad.renderer.x86 import ISARenderer, Register, rdef, regs, with_regs, LinearContext

# ops that participate in register allocation
REGALLOC_OPS = {Ops.CALL, Ops.BUFFER, Ops.ALLOC, Ops.RANGE, Ops.END}

class LinearScanRegallocContext:
  # returns the uop that defines the virtual register
  def vdef(self, v:Register) -> UOp: return self.definitions[v]
  def __init__(self, ctx:LinearContext, uops:list[UOp], ren:ISARenderer):
    self.outputs: dict[UOp, list[UOp]] = {}
    for u in uops:
      if u.op is Ops.AFTER and u.src[0].op in {Ops.BUFFER, Ops.ALLOC}:
        for call in u.src[1:]:
          if call.op is Ops.CALL and call.body.op is Ops.ASM: self.outputs.setdefault(call, []).append(u.src[0])
    self.outputs = {call: [s for s in call.src[1:] if s in outputs] for call,outputs in self.outputs.items()}
    written = {dst for outputs in self.outputs.values() for dst in outputs}
    self.defs = {u: tuple(unwrap(rdef(dst)) for dst in self.outputs.get(u, [])) if u.op is Ops.CALL else
                 regs(u) if u not in written else () for u in uops}
    self.reads = {u: tuple(s for s in u.src if s not in self.outputs.get(u, [])) for u in uops}
    self.definitions: dict[Register, UOp] = {}
    for call, outputs in self.outputs.items():
      for dst in outputs: self.definitions.setdefault(unwrap(rdef(dst)), dst.after(call))
    self.definitions.update({r:u for u in uops if u.op is Ops.BUFFER for r in self.defs[u]})
    self.bindings: dict[UOp, dict[UOp, UOp]] = {}
    self.reloads: dict[Register, UOp] = {}
    self.effect = UOp(Ops.NOOP)
    self.uops = uops = [u for u in uops if u.op in REGALLOC_OPS]
    self.ren = ren
    self.idx = itertools.count()

    # compute live ranges
    self.live_range: dict[Register, list[int]] = {}
    lr = self.live_range
    loops: dict[int, int] = {} # the interval of each loop, from its RANGE to the last uop that reads that RANGE
    for idx,u in reversed(list(enumerate(uops))):
      defs = self.defs[u]
      for v in defs + tuple(rdef(s) for s in dedup(self.reads[u])):
        if isinstance(v, Register): lr.setdefault(v, []).insert(0, idx)
      for v in defs:
        if (n:=max((e for s,e in loops.items() if s <= lr[v][-1] < e), default=None)): lr[v].append(n)
      if u.op is Ops.RANGE: loops[idx] = max(j for j,x in enumerate(uops) if u in x.src)

    # allocate registers
    self.spills: dict[Register, int] = {} # mapping from virtual to stack offset
    self.reals: dict[int, dict[Register, Register]] = {} # mapping from virtual to real at each program point
    self.insert_before: dict[int, list[tuple[Register, Register]]] = {} # fills to be inserted at each program point
    live: dict[Register, Register] = {} # mapping from virtual to real that's currently assigned to it
    live_ins: list[dict[Register, Register]] = [] # mapping from virtual to real at loop entry

    def alloc(cons:tuple[Register, ...], i:int) -> Register:
      live_inv = {v:k for k,v in live.items()}
      # allocate the best register. Registers not in live or not used again are free and have priority,
      # otherwise pick the one with the furthest next use. Regs that appear first in cons have priority in case of a tie
      reg,vreg = max(((r,live_inv.get(r)) for r in cons),
                    key=lambda rv: next((j-i for j in ([] if rv[1] is None else lr[rv[1]]) if j >= i), len(uops)))
      return live.pop(vreg) if vreg is not None else reg

    # assign register to spilled virtual and record load to be emitted before current uop, also assign it a stack slot
    def fill(v:Register, i:int, cons:tuple[Register, ...]|None=None) -> Register:
      if v not in self.spills:
        self.spills[v] = ctx.assign_spill_slot(v, self.vdef(v))
      r = alloc(cons if cons is not None else v.cons, i)
      self.insert_before.setdefault(i, []).append((v, r))
      return r

    for i,u in enumerate(uops):
      # allocate uses
      for s in self.reads[u]:
        if not isinstance(v:=rdef(s), Register): continue
        if v not in live: live[v] = fill(v, i)
        self.reals.setdefault(i, {})[v] = live[v]

      # allocate defs
      if self.defs[u]:
        for j,v in enumerate(self.defs[u]):
          if v not in live:
            cons = v.cons
            # two address instructions (src is reused by def) can only coalesce reused src.
            # reused src goes first to get priority in case of a tiebreak
            if ren.is_two_address(u) and j == 0:
              uses = tuple(live.get(rdef(s)) for s in self.reads[u] if rdef(s) is not None)
              cons = ((uses[0],) if uses[0] in cons else ()) + tuple(r for r in cons if r not in uses)
            live[v] = alloc(cons, i+1)
          self.reals.setdefault(i, {})[v] = live[v]

      # loop prologue, avoid loading inside the loop
      if u.op is Ops.RANGE:
        # we move to registers vars used in the loop sorted by next use, vars not used in the loop will not be reloaded in the epilogue
        used_in_loop = [v for v in live.keys() | self.spills.keys() if any(i <= l < loops[i] for l in lr[v])]
        sorted_uses = sorted(used_in_loop, key=lambda k: (next(l-i for l in lr[k] if l >= i), lr[k][0], k.name, k.index))
        live_in: dict[Register, Register] = {}
        for v in sorted_uses:
          # if all the possible registers are already in live_in there's no space for this var
          if set(v.cons).issubset(live_in.values()): continue
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
  original = ctx.uops[i]
  before = []
  for v,r in ctx.insert_before.get(i, []):
    value = ctx.ren.fill(ctx.spills[v], ctx.vdef(v), r, ctx.effect)
    before.append(value)
    ctx.reloads[v], ctx.effect = value, value
  nsrc = []
  def retag(x:UOp, r:Register, value:UOp|None=None) -> UOp:
    return x.replace(src=(retag(x.src[0],r,value),*x.src[1:])) if x.op in {Ops.AFTER, Ops.BITCAST} else \
      value if value is not None else with_regs(x, (r,))
  for j,s in enumerate(x.src):
    # v here is the virtual defined by the original s as s is the rewritten version
    if (v:=rdef(ctx.uops[i].src[j])) in ctx.reals.get(i, {}):
      reg = ctx.reals[i][v]
      nsrc.append(retag(s, reg, ctx.reloads.get(v) if original.src[j] in ctx.reads[original] else None))
    else: nsrc.append(s)
  nx = x.replace(src=tuple(nsrc))
  if x.op in {Ops.BUFFER, Ops.ALLOC} and ctx.defs[original]: nx = with_regs(nx, tuple(ctx.reals[i][v] for v in ctx.defs[original]))
  ctx.bindings[nx] = {dst: nx.src[original.src.index(dst)] for dst in ctx.outputs.get(original, [])}

  values = [dst.after(nx) for dst in ctx.bindings[nx].values()] if x.op is Ops.CALL else [nx]
  after = [ctx.ren.spill(ctx.spills[v], value) for v,value in zip(ctx.defs[original], values) if v in ctx.spills]
  for v in ctx.defs[original]: ctx.reloads.pop(v, None)
  if x.op in {Ops.CALL, Ops.RANGE, Ops.END} or after: ctx.effect = ctx.effect.after(nx, *after)

  return nx, before + [nx] + after

pm_regalloc_rewrite = PatternMatcher([
  (UPat(REGALLOC_OPS, name="x"), regalloc_rewrite),
  (UPat((Ops.BUFFER, Ops.ALLOC), name="dst").after(UPat(Ops.ASM).call(allow_any_len=True, name="call")),
   lambda ctx,dst,call: ((out:=ctx.bindings[call][dst].after(call)), [out])),
])
