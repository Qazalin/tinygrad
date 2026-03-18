"""
RDNA3 Instruction Timing Tables - Measured via SQTT

Run tests INDIVIDUALLY with AM_RESET=1 for accurate measurements:
  AM_RESET=1 PROFILE=1 SQTT=1 AMD=1 python -m pytest test/amd/test_instruction_tables.py::TestInstructionTables::test_simple_loop -v -s

MEASURED TIMINGS (RDNA3 / gfx1100):
===================================
Issue-to-Exec Latency (pipeline depth):
  - SALU: 4 cycles
  - VALU: 7 cycles (13 cycles on first/cold iteration)
  - TRANS: 7 cycles (13 cycles on first/cold iteration)

Issue Rate (throughput):
  - VALU: 1 instruction/cycle (both dependent and independent)
  - The hardware issues back-to-back; dependencies handled via scoreboard/s_delay_alu

s_delay_alu Effects:
  - VALU_DEP_1: 5 cycle gap between dependent VALUs (vs 1 cycle without)
  - VALU_DEP_N means "dependent on VALU N instructions back"

Loop Overhead:
  - Empty loop: 26 cycles (s_nop + s_sub_u32 + s_cmpk_lg_u32 + s_cbranch_scc1)
  - First iteration: +2 cycles for ICache miss

ICache Warmup:
  - First iteration may have 2-6 extra cycles
  - Subsequent iterations are deterministic
  - Use WARMUP=10 iterations to discard cold data
"""
import os
os.environ["VIZ"] = os.environ.get("VIZ", "-2")
import unittest, functools
from extra.gemm.amd_asm_matmul import Kernel
from tinygrad.runtime.autogen.amd.rdna3.ins import *
from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad import Tensor, Device
from tinygrad.helpers import DEBUG
from tinygrad.renderer.amd.sqtt import *

def asm_fxn(*args:tuple[UOp, ...], k:Kernel, lx=32, gx=1, name:str="asm_fxn") -> UOp:
  """Single wave dispatch (lx=32, gx=1) for isolated timing."""
  lidx = UOp.special(lx, "lidx0")
  gidx = UOp.special(gx, "gidx0")
  sink = UOp.sink(*[t.base for t in args], lidx, gidx, arg=KernelInfo(name=name))
  return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in k.finalize()]))))

def load_sqtt():
  sqtt, prg = None, None
  for e in Device[Device.DEFAULT].profile_events:
    if type(e).__name__ == "ProfileSQTTEvent" and e.se == 1: sqtt = e
    if type(e).__name__ == "ProfileProgramEvent": prg = e
  target = f"gfx{Device[Device.DEFAULT].device_props()['gfx_target_version']//1000}"
  ret = []
  for p in map_insts(sqtt.blob, prg.lib, target):
    if type(p[0]).__name__.replace("_RDNA4", "") in skip: continue
    if DEBUG >= 2: print_packets([p])
    ret.append(p)
  return ret

class TestInstructionTables(unittest.TestCase):
  def setUp(self):
    self.arch = getattr(Device[Device.DEFAULT].renderer, "arch", "")
    if not self.arch.startswith("gfx11"): self.skipTest("only rdna3")
    Device[Device.DEFAULT].profile_events.clear()

  def test_simple_loop(self):
    """Verify we can run a loop and see all iterations in SQTT."""
    k = Kernel(self.arch)
    ITERATIONS = 20

    # Loop counter in s10
    k.emit(s_mov_b32(s[10], ITERATIONS))

    # Loop body: v_add_f32, then decrement and branch
    k.emit(v_add_f32_e32(v[0], v[0], v[1]))
    k.emit(s_sub_u32(s[10], s[10], 1))
    k.emit(s_cmpk_lg_u32(s[10], 0))  # SCC = (s[10] != 0)
    k.emit(s_cbranch_scc1(-4))  # branch back 4 instructions if SCC=1 (counter != 0)

    k.emit(s_endpgm())

    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    mapped = load_sqtt()

    # Count VALUINST packets - should be ITERATIONS
    valuinsts = [p._time for p, _ in mapped if isinstance(p, VALUINST)]
    print(f"\nLoop iterations detected: {len(valuinsts)} (expected {ITERATIONS})")

    assert len(valuinsts) == ITERATIONS, f"Expected {ITERATIONS} VALUINST, got {len(valuinsts)}"

  def test_loop_timing_warmup(self):
    """Verify ICache warmup: later iterations should have consistent timing."""
    k = Kernel(self.arch)
    ITERATIONS = 50
    WARMUP = 10

    k.emit(s_mov_b32(s[10], ITERATIONS))
    k.emit(v_add_f32_e32(v[0], v[0], v[1]))
    k.emit(s_sub_u32(s[10], s[10], 1))
    k.emit(s_cmpk_lg_u32(s[10], 0))  # SCC = (s[10] != 0)
    k.emit(s_cbranch_scc1(-4))
    k.emit(s_endpgm())

    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    mapped = load_sqtt()

    valuinsts = [p._time for p, _ in mapped if isinstance(p, VALUINST)]
    assert len(valuinsts) == ITERATIONS

    # Calculate gaps between iterations
    gaps = [valuinsts[i] - valuinsts[i-1] for i in range(1, len(valuinsts))]

    # Split into cold (first WARMUP) and warm (rest)
    cold_gaps = gaps[:WARMUP]
    warm_gaps = gaps[WARMUP:]

    print(f"\nCold gaps (first {WARMUP}): {cold_gaps}")
    print(f"Warm gaps (remaining): {warm_gaps[:10]}...")  # first 10

    # Warm gaps should all be identical (deterministic)
    unique_warm = set(warm_gaps)
    print(f"Unique warm gap values: {unique_warm}")

    assert len(unique_warm) == 1, f"Warm gaps not deterministic: {unique_warm}"

  def test_empty_loop_overhead(self):
    """Measure pure loop overhead with no payload instructions."""
    k = Kernel(self.arch)
    ITERATIONS = 50
    WARMUP = 10

    # Use s_nop as the "marker" we can count - it does nothing but is traceable
    k.emit(s_mov_b32(s[10], ITERATIONS))
    k.emit(s_nop(0))  # marker instruction
    k.emit(s_sub_u32(s[10], s[10], 1))
    k.emit(s_cmpk_lg_u32(s[10], 0))
    k.emit(s_cbranch_scc1(-4))
    k.emit(s_endpgm())

    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    mapped = load_sqtt()

    # Find s_nop markers by looking at IMMEDIATE packets (s_nop is traced as IMMEDIATE)
    nops = [p._time for p, inst in mapped if isinstance(p, IMMEDIATE) and inst and "s_nop" in str(inst)]
    assert len(nops) == ITERATIONS, f"Expected {ITERATIONS} s_nop, got {len(nops)}"

    gaps = [nops[i] - nops[i-1] for i in range(1, len(nops))]
    warm_gaps = gaps[WARMUP:]
    overhead = warm_gaps[0] if warm_gaps else None

    print(f"\nEmpty loop overhead: {overhead} cycles per iteration")
    print(f"Warm gaps: {warm_gaps[:10]}...")
    assert len(set(warm_gaps)) == 1, f"Loop overhead not deterministic: {set(warm_gaps)}"

  def test_valu_latency_dependency_chain(self):
    """
    Measure VALU latency using a dependency chain.
    v0 = v_add_f32(v0, v1)  # each depends on previous v0
    v0 = v_add_f32(v0, v1)
    ...
    Latency = (total_time) / (num_instructions)
    """
    k = Kernel(self.arch)
    ITERATIONS = 50
    WARMUP = 10
    CHAIN_LENGTH = 4  # 4 dependent v_add_f32 per iteration

    k.emit(s_mov_b32(s[10], ITERATIONS))

    # 4 dependent v_add_f32 instructions (all use v0 as both src and dst)
    for _ in range(CHAIN_LENGTH):
      k.emit(v_add_f32_e32(v[0], v[0], v[1]))

    k.emit(s_sub_u32(s[10], s[10], 1))
    k.emit(s_cmpk_lg_u32(s[10], 0))
    k.emit(s_cbranch_scc1(-CHAIN_LENGTH - 3))
    k.emit(s_endpgm())

    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    mapped = load_sqtt()

    valuinsts = [p._time for p, _ in mapped if isinstance(p, VALUINST)]
    assert len(valuinsts) == ITERATIONS * CHAIN_LENGTH

    # Group into iterations
    iter_times = [valuinsts[i*CHAIN_LENGTH:(i+1)*CHAIN_LENGTH] for i in range(ITERATIONS)]

    # Calculate per-iteration timing from first VALU of each iteration
    first_valu_times = [it[0] for it in iter_times]
    iter_gaps = [first_valu_times[i] - first_valu_times[i-1] for i in range(1, len(first_valu_times))]
    warm_iter_gaps = iter_gaps[WARMUP:]

    # Also measure gaps within a single iteration (between dependent VALUs)
    # Pick a warm iteration
    warm_iter = iter_times[WARMUP + 5]
    intra_gaps = [warm_iter[i] - warm_iter[i-1] for i in range(1, len(warm_iter))]

    print(f"\nVALU dependency chain (length={CHAIN_LENGTH}):")
    print(f"Inter-iteration gaps (warm): {warm_iter_gaps[:5]}...")
    print(f"Intra-iteration gaps (between dependent VALUs): {intra_gaps}")

    # With dependency, we expect ~5 cycles between dependent VALUs (VALU latency)
    # Actually based on RDNA3: v_add_f32 has ~5 cycle latency
    avg_intra = sum(intra_gaps) / len(intra_gaps) if intra_gaps else 0
    print(f"Average latency per v_add_f32: {avg_intra:.1f} cycles")

  def test_valu_throughput_independent(self):
    """
    Measure VALU throughput using independent instructions.
    Use different register banks to avoid conflicts:
    - bank0: v0, v4, v8, v12
    - bank1: v1, v5, v9, v13
    - bank2: v2, v6, v10, v14
    - bank3: v3, v7, v11, v15
    """
    k = Kernel(self.arch)
    ITERATIONS = 50
    WARMUP = 10
    NUM_INDEP = 4  # 4 independent v_add_f32 per iteration

    k.emit(s_mov_b32(s[10], ITERATIONS))

    # 4 independent v_add_f32 using different destination registers (different banks)
    # v0 = v8 + v16 (bank0 = bank0 + bank0)
    # v1 = v9 + v17 (bank1 = bank1 + bank1)
    # v2 = v10 + v18 (bank2 = bank2 + bank2)
    # v3 = v11 + v19 (bank3 = bank3 + bank3)
    k.emit(v_add_f32_e32(v[0], v[8], v[16]))
    k.emit(v_add_f32_e32(v[1], v[9], v[17]))
    k.emit(v_add_f32_e32(v[2], v[10], v[18]))
    k.emit(v_add_f32_e32(v[3], v[11], v[19]))

    k.emit(s_sub_u32(s[10], s[10], 1))
    k.emit(s_cmpk_lg_u32(s[10], 0))
    k.emit(s_cbranch_scc1(-NUM_INDEP - 3))
    k.emit(s_endpgm())

    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    mapped = load_sqtt()

    valuinsts = [p._time for p, _ in mapped if isinstance(p, VALUINST)]
    assert len(valuinsts) == ITERATIONS * NUM_INDEP

    # Measure gaps between consecutive VALU issues (should be 1 cycle for throughput)
    all_gaps = [valuinsts[i] - valuinsts[i-1] for i in range(1, len(valuinsts))]
    # Skip first iteration and first instruction of each iteration (loop overhead)
    warm_gaps = all_gaps[WARMUP * NUM_INDEP:]

    # Group by position in iteration
    intra_iter_gaps = []  # gaps within iterations (not crossing loop boundary)
    for i, gap in enumerate(warm_gaps):
      pos_in_iter = (i + 1) % NUM_INDEP  # 0 = first gap in iter, etc.
      if pos_in_iter != 0:  # not crossing loop boundary
        intra_iter_gaps.append(gap)

    print(f"\nVALU throughput (independent, {NUM_INDEP} per iter):")
    print(f"Intra-iteration gaps: {set(intra_iter_gaps)}")
    avg_throughput = sum(intra_iter_gaps) / len(intra_iter_gaps) if intra_iter_gaps else 0
    print(f"Average issue rate: {avg_throughput:.2f} cycles between independent VALUs")

  def test_valu_issue_to_exec_latency(self):
    """
    Measure VALU issue-to-exec latency using ALUEXEC packets.
    This gives us the actual pipeline depth from issue to execution.
    """
    k = Kernel(self.arch)
    ITERATIONS = 50
    WARMUP = 10

    k.emit(s_mov_b32(s[10], ITERATIONS))
    k.emit(v_add_f32_e32(v[0], v[0], v[1]))
    k.emit(s_sub_u32(s[10], s[10], 1))
    k.emit(s_cmpk_lg_u32(s[10], 0))
    k.emit(s_cbranch_scc1(-4))
    k.emit(s_endpgm())

    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    mapped = load_sqtt()

    # Collect VALUINST (issue) and ALUEXEC (exec) times for v_add_f32
    issue_times = []
    exec_times = []
    for p, inst in mapped:
      if isinstance(p, VALUINST) and inst and "v_add_f32" in str(inst):
        issue_times.append(p._time)
      if isinstance(p, ALUEXEC) and inst and "v_add_f32" in str(inst):
        exec_times.append(p._time)

    print(f"\nVALU issue times (first 5): {issue_times[:5]}")
    print(f"VALU exec times (first 5): {exec_times[:5]}")

    # Match issue to exec
    if len(issue_times) == len(exec_times):
      latencies = [exec_times[i] - issue_times[i] for i in range(len(issue_times))]
      warm_latencies = latencies[WARMUP:]
      print(f"Issue-to-exec latencies (warm): {set(warm_latencies)}")
      avg_latency = sum(warm_latencies) / len(warm_latencies)
      print(f"Average VALU issue-to-exec latency: {avg_latency:.1f} cycles")
    else:
      print(f"Mismatch: {len(issue_times)} issues vs {len(exec_times)} execs")
      # They might be offset - just show the gap pattern
      if issue_times and exec_times:
        print(f"First issue: {issue_times[0]}, first exec: {exec_times[0]}")
        print(f"Gap: {exec_times[0] - issue_times[0]} cycles")

  def test_salu_issue_to_exec_latency(self):
    """
    Measure SALU issue-to-exec latency using ALUEXEC packets.
    SALU should have shorter pipeline depth than VALU.
    """
    k = Kernel(self.arch)
    ITERATIONS = 50
    WARMUP = 10

    k.emit(s_mov_b32(s[10], ITERATIONS))
    k.emit(s_add_u32(s[0], s[0], s[1]))  # SALU instruction we want to measure
    k.emit(s_sub_u32(s[10], s[10], 1))
    k.emit(s_cmpk_lg_u32(s[10], 0))
    k.emit(s_cbranch_scc1(-4))
    k.emit(s_endpgm())

    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    mapped = load_sqtt()

    # Collect INST (issue) and ALUEXEC (exec) times for s_add_u32
    issue_times = []
    exec_times = []
    for p, inst in mapped:
      inst_str = str(inst) if inst else ""
      if isinstance(p, INST) and "SALU" in str(p.op) and "s_add_u32" in inst_str:
        issue_times.append(p._time)
      if isinstance(p, ALUEXEC) and "s_add_u32" in inst_str:
        exec_times.append(p._time)

    print(f"\nSALU issue times (first 5): {issue_times[:5]}")
    print(f"SALU exec times (first 5): {exec_times[:5]}")

    if len(issue_times) == len(exec_times):
      latencies = [exec_times[i] - issue_times[i] for i in range(len(issue_times))]
      warm_latencies = latencies[WARMUP:]
      print(f"Issue-to-exec latencies (warm): {set(warm_latencies)}")
      avg_latency = sum(warm_latencies) / len(warm_latencies)
      print(f"Average SALU issue-to-exec latency: {avg_latency:.1f} cycles")
    else:
      print(f"Mismatch: {len(issue_times)} issues vs {len(exec_times)} execs")

  def test_trans_issue_to_exec_latency(self):
    """
    Measure transcendental unit (TRANS) issue-to-exec latency.
    TRANS instructions: v_rcp_f32, v_rsq_f32, v_sqrt_f32, v_exp_f32, v_log_f32, etc.
    """
    k = Kernel(self.arch)
    ITERATIONS = 50
    WARMUP = 10

    k.emit(s_mov_b32(s[10], ITERATIONS))
    k.emit(v_rcp_f32_e32(v[0], v[1]))  # TRANS instruction
    k.emit(s_sub_u32(s[10], s[10], 1))
    k.emit(s_cmpk_lg_u32(s[10], 0))
    k.emit(s_cbranch_scc1(-4))
    k.emit(s_endpgm())

    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    mapped = load_sqtt()

    # Collect INST op=VALU_TRANS (issue) and ALUEXEC (exec) times for v_rcp_f32
    issue_times = []
    exec_times = []
    for p, inst in mapped:
      inst_str = str(inst) if inst else ""
      if isinstance(p, INST) and "VALU_TRANS" in str(p.op) and "v_rcp_f32" in inst_str:
        issue_times.append(p._time)
      if isinstance(p, ALUEXEC) and "v_rcp_f32" in inst_str:
        exec_times.append(p._time)

    print(f"\nTRANS (v_rcp_f32) issue times (first 5): {issue_times[:5]}")
    print(f"TRANS exec times (first 5): {exec_times[:5]}")

    if len(issue_times) == len(exec_times):
      latencies = [exec_times[i] - issue_times[i] for i in range(len(issue_times))]
      cold_latencies = latencies[:WARMUP]
      warm_latencies = latencies[WARMUP:]
      print(f"Cold latencies (first {WARMUP}): {cold_latencies}")
      print(f"Issue-to-exec latencies (warm): {set(warm_latencies)}")
      avg_latency = sum(warm_latencies) / len(warm_latencies)
      print(f"Average TRANS issue-to-exec latency: {avg_latency:.1f} cycles")
    else:
      print(f"Mismatch: {len(issue_times)} issues vs {len(exec_times)} execs")

  def test_delay_alu_validation(self):
    """
    Test s_delay_alu effect on dependent instructions.
    VALU_DEP_N means "dependent on VALU N instructions back".
    With VALU_DEP_1, the hardware waits for the previous VALU to complete.
    """
    k = Kernel(self.arch)
    ITERATIONS = 50
    WARMUP = 10

    # Simple test: measure gap with VALU_DEP_1 (immediate dependency)
    # v0 = v0 + v1
    # s_delay_alu(VALU_DEP_1)  // wait for v0 to be ready
    # v2 = v0 + v3             // uses v0
    k.emit(s_mov_b32(s[10], ITERATIONS))

    # With VALU_DEP_1: wait for immediate previous VALU
    k.emit(v_add_f32_e32(v[0], v[0], v[1]))    # producer of v0
    k.emit(s_delay_alu(0x01))                   # VALU_DEP_1
    k.emit(v_add_f32_e32(v[2], v[0], v[3]))    # consumer of v0

    k.emit(s_sub_u32(s[10], s[10], 1))
    k.emit(s_cmpk_lg_u32(s[10], 0))
    k.emit(s_cbranch_scc1(-5))
    k.emit(s_endpgm())

    Tensor.empty(1).custom_kernel(fxn=functools.partial(asm_fxn, k=k))[0].realize()
    mapped = load_sqtt()

    valuinsts = [p._time for p, _ in mapped if isinstance(p, VALUINST)]
    print(f"\nVALU count: {len(valuinsts)} (expected {ITERATIONS * 2})")

    # Measure gaps between producer and consumer in each iteration
    gaps = []
    for i in range(0, len(valuinsts) - 1, 2):
      gaps.append(valuinsts[i + 1] - valuinsts[i])

    warm_gaps = gaps[WARMUP:]
    print(f"Gap with VALU_DEP_1 (warm): {set(warm_gaps)}")
    if warm_gaps:
      print(f"Average gap: {sum(warm_gaps) / len(warm_gaps):.1f} cycles")
      # VALU_DEP_1 should insert ~5 cycles (based on our earlier observation)
      assert all(g >= 4 for g in warm_gaps), f"Expected gap >= 4 with VALU_DEP_1, got {warm_gaps}"

if __name__ == "__main__":
  unittest.main()
