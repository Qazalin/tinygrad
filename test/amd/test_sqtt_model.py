"""
SQTT (SQ Thread Trace) Model Verification Tests

This file tests claims from the RDNA3 ISA documentation against actual SQTT traces.
Each test documents:
1. The claim being verified
2. The ISA reference quote
3. The actual test that verifies the behavior

Run with: AM_RESET=1 PROFILE=1 SQTT=1 AMD=1 python -m pytest test/amd/test_sqtt_model.py -v
"""
import unittest
import os

# must set before importing tinygrad
os.environ.setdefault("PROFILE", "1")
os.environ.setdefault("SQTT", "1")

from tinygrad import Tensor, Device
from tinygrad.device import Compiled
from tinygrad.helpers import getenv
from tinygrad.renderer.amd.sqtt import (
  decode, map_insts, PacketType, print_packets,
  WAVESTART, WAVESTART_RDNA4, WAVEEND, WAVEALLOC, WAVEALLOC_RDNA4, WAVERDY,
  INST, INST_RDNA4, VALUINST, IMMEDIATE, IMMEDIATE_MASK,
  ALUEXEC, VMEMEXEC, AluSrc, MemSrc,
  LAYOUT_HEADER, NOP, SNAPSHOT,
  TS_DELTA_SHORT, TS_DELTA_OR_MARK, TS_DELTA_OR_MARK_RDNA4,
  InstOp, InstOpRDNA4,
)

def get_sqtt_events():
  """Get SQTT events from Compiled.profile_events after kernel execution."""
  from tinygrad.runtime.ops_amd import ProfileSQTTEvent
  from tinygrad.device import ProfileProgramEvent
  sqtt_events = [e for e in Compiled.profile_events if isinstance(e, ProfileSQTTEvent)]
  prg_events = {e.tag: e for e in Compiled.profile_events if isinstance(e, ProfileProgramEvent)}
  return sqtt_events, prg_events

def get_target():
  """Get the GPU target string."""
  dev = Device["AMD"]
  return f"gfx{dev.device_props()['gfx_target_version']//1000}"

def decode_packets(blob):
  """Decode SQTT blob into list of packets."""
  ret = []
  for e in decode(blob):
    print_packets([e])
    ret.append(e)
  return ret

def count_packet_types(packets):
  """Count occurrences of each packet type."""
  counts = {}
  for p in packets:
    name = type(p).__name__
    counts[name] = counts.get(name, 0) + 1
  return counts

def is_issue_packet(pkt):
  """Returns True if pkt is an ISSUE packet (not EXEC). EXEC packets have correlated inst info but are not new instruction issues."""
  return not isinstance(pkt, (ALUEXEC, VMEMEXEC))

@unittest.skipUnless(getenv("AMD") and Device.DEFAULT == "AMD", "AMD only")
class TestSQTTModel(unittest.TestCase):
  """
  Tests verifying RDNA3 ISA claims against SQTT traces.

  Each test follows the pattern:
  1. Run a specific kernel
  2. Capture SQTT trace
  3. Verify ISA-documented behavior
  """

  @classmethod
  def setUpClass(cls):
    # clear any existing events
    Compiled.profile_events.clear()
    cls.target = get_target()

  def setUp(self):
    # clear events before each test
    Compiled.profile_events.clear()

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: Layout Header Structure
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_layout_header_first_packet(self):
    """
    CLAIM: Every SQTT trace begins with a LAYOUT_HEADER packet that identifies the trace format.

    ISA REFERENCE: The SQTT format uses a layout header to indicate the trace version.
    - Layout 3: RDNA3 (gfx11xx)
    - Layout 4: RDNA4 (gfx12xx)

    OBSERVED: The first decoded packet is always LAYOUT_HEADER with layout=3 or layout=4.
    """
    # run a simple kernel
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()
    self.assertGreater(len(sqtt_events), 0, "No SQTT events captured")

    for event in sqtt_events:
      packets = decode_packets(event.blob)
      self.assertGreater(len(packets), 0)

      # first packet must be LAYOUT_HEADER
      first = packets[0]
      self.assertIsInstance(first, LAYOUT_HEADER)

      # layout must be 3 (RDNA3) or 4 (RDNA4)
      self.assertIn(first.layout, [3, 4], f"Unexpected layout: {first.layout}")

      if self.target.startswith("gfx11"):
        self.assertEqual(first.layout, 3, "RDNA3 should use layout 3")
      elif self.target.startswith("gfx12"):
        self.assertEqual(first.layout, 4, "RDNA4 should use layout 4")

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: Wave Lifecycle
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_wave_lifecycle_wavestart_waveend(self):
    """
    CLAIM: Each wave has a defined lifecycle from WAVESTART to WAVEEND.

    ISA REFERENCE (Section 2.3 Work-groups):
    "A wave is a collection of 32 or 64 work-items that execute in parallel on a single
    RDNA3 processor."

    ISA REFERENCE (Section 3.5 Initial Wave State):
    "When a wave is created the PC is initialized to the first instruction in the program."

    OBSERVED: SQTT traces show WAVESTART when a wave is allocated to a SIMD,
    followed by instructions, and WAVEEND when the wave completes (s_endpgm).
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue

      packets = decode_packets(event.blob)
      counts = count_packet_types(packets)

      # check for wave lifecycle packets
      wavestart_types = ["WAVESTART", "WAVESTART_RDNA4"]
      waveend_count = counts.get("WAVEEND", 0)

      wavestart_count = sum(counts.get(t, 0) for t in wavestart_types)

      # if we have instruction tracing, we should see wave lifecycle
      if wavestart_count > 0:
        # every started wave should end
        self.assertEqual(wavestart_count, waveend_count,
          f"WAVESTART count ({wavestart_count}) != WAVEEND count ({waveend_count})")

        # verify wave IDs match
        wave_starts = {}
        wave_ends = {}
        for p in packets:
          if isinstance(p, (WAVESTART, WAVESTART_RDNA4)):
            key = (p.cu, p.simd, p.wave)
            wave_starts[key] = wave_starts.get(key, 0) + 1
          elif isinstance(p, WAVEEND):
            key = (p.cu, p.simd, p.wave)
            wave_ends[key] = wave_ends.get(key, 0) + 1

        for key in wave_starts:
          self.assertEqual(wave_starts[key], wave_ends.get(key, 0),
            f"Wave {key} started {wave_starts[key]} times but ended {wave_ends.get(key, 0)} times")

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: Instruction Issue vs Execution
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_inst_packets_precede_exec_packets(self):
    """
    CLAIM: Instructions are ISSUED to the pipeline before they EXECUTE on ALU/memory units.

    ISA REFERENCE (Section 5.6 Data Dependency Resolution):
    "The shader has four counters that track the progress of issued instructions.
    S_WAITCNT waits for the values of these counters to be at, or below, specified
    values before continuing."

    ISA REFERENCE (Section 3.2.1 Program Counter):
    "The PC points to the next instruction to issue. All prior instructions have
    been issued but may or may not have completed execution."

    OBSERVED: INST/VALUINST packets (instruction issue) appear BEFORE corresponding
    ALUEXEC/VMEMEXEC packets (execution unit busy). The time delta shows pipeline latency.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue

      packets = decode_packets(event.blob)

      # find instruction packets and exec packets
      inst_times = []
      exec_times = []

      for p in packets:
        if isinstance(p, (INST, INST_RDNA4, VALUINST, IMMEDIATE)):
          inst_times.append(p._time)
        elif isinstance(p, (ALUEXEC, VMEMEXEC)):
          exec_times.append(p._time)

      if not inst_times or not exec_times:
        continue

      # first instruction should come before or at the same time as first exec
      self.assertLessEqual(min(inst_times), min(exec_times),
        "First EXEC packet appeared before first instruction issue")

      # there should be exec packets after instruction packets (showing execution)
      self.assertGreater(max(exec_times), min(inst_times),
        "No EXEC packets after instruction issue")

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: ALUEXEC Source Types
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_aluexec_src_types(self):
    """
    CLAIM: ALUEXEC packets indicate which ALU type is executing: SALU, VALU, or both.

    ISA REFERENCE (Section 6 Scalar ALU Operations):
    "Scalar ALU (SALU) instructions operate on values that are common to all
    work-items in the wave."

    ISA REFERENCE (Section 7 Vector ALU Operations):
    "Vector ALU (VALU) instructions control the SIMD32's math unit and operate
    on 32 work-items of data at a time."

    ISA REFERENCE (Section 2 Shader Concepts):
    "The RDNA3 processor consists primarily of:
    - A scalar ALU, which operates on one value per wave (common to all work-items)
    - A vector ALU, which operates on unique values per work-item"

    OBSERVED: ALUEXEC packets have src field indicating SALU, VALU, or VALU_SALU
    (concurrent execution of both).
    """
    # use a kernel that has both scalar and vector ops
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue

      packets = decode_packets(event.blob)

      alu_srcs = set()
      for p in packets:
        if isinstance(p, ALUEXEC):
          if isinstance(p.src, AluSrc):
            alu_srcs.add(p.src)
          else:
            alu_srcs.add(p.src)

      # verify we see valid ALU source types
      valid_srcs = {AluSrc.NONE, AluSrc.SALU, AluSrc.VALU, AluSrc.VALU_SALU, 0, 1, 2, 3}
      for src in alu_srcs:
        self.assertIn(src, valid_srcs, f"Invalid ALUEXEC src: {src}")

      if AluSrc.SALU in alu_srcs or 1 in alu_srcs:
        # we have SALU execution - good
        pass
      if AluSrc.VALU in alu_srcs or 2 in alu_srcs:
        # we have VALU execution - good for add kernel
        pass

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: VMEMEXEC Memory Operations
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_vmemexec_for_memory_ops(self):
    """
    CLAIM: VMEMEXEC packets indicate when the memory unit is executing loads/stores.

    ISA REFERENCE (Section 11 Global, Scratch and Flat Address Space):
    "Global instructions transfer data between VGPRs and global memory."

    ISA REFERENCE (Table 4 Readable and Writable Hardware States):
    "VMcnt - Counts the number of VMEM load and sample instructions issued but not yet completed.
    VScnt - Counts the number of VMEM store instructions issued but not yet completed."

    OBSERVED: VMEMEXEC packets with src=VMEM appear after global_load/global_store instructions.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue

      packets = decode_packets(event.blob)

      vmem_insts = []
      vmem_execs = []

      for p in packets:
        if isinstance(p, (INST, INST_RDNA4)):
          op_name = p.op.name if isinstance(p.op, (InstOp, InstOpRDNA4)) else str(p.op)
          if "GLOBAL" in op_name or "VMEM" in op_name:
            vmem_insts.append(p)
        elif isinstance(p, VMEMEXEC):
          vmem_execs.append(p)

      # if we have memory instructions, we should have VMEMEXEC
      if vmem_insts:
        self.assertGreater(len(vmem_execs), 0,
          f"Had {len(vmem_insts)} VMEM instructions but no VMEMEXEC packets")

        # verify VMEM sources
        vmem_srcs = set()
        for p in vmem_execs:
          if isinstance(p.src, MemSrc):
            vmem_srcs.add(p.src)

        # should see VMEM source type
        vmem_types = {MemSrc.VMEM, MemSrc.VMEM_ALT}
        self.assertTrue(vmem_srcs & vmem_types,
          f"Expected VMEM source type, got {vmem_srcs}")

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: Timestamps are Monotonically Increasing
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_timestamps_monotonic(self):
    """
    CLAIM: SQTT packet timestamps are monotonically increasing within a trace.

    ISA REFERENCE (Section 3.4.10 Time):
    "The GPU contains a free-running timestamp counter."

    OBSERVED: Each packet's _time field is >= the previous packet's _time.
    The delta fields accumulate to form the timestamp.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      packets = decode_packets(event.blob)

      prev_time = -1
      for i, p in enumerate(packets):
        self.assertGreaterEqual(p._time, prev_time,
          f"Timestamp went backwards at packet {i}: {p._time} < {prev_time}")
        prev_time = p._time

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: Wave ID Consistency
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_wave_id_in_instructions(self):
    """
    CLAIM: Instruction packets contain a wave ID identifying which wave issued them.

    ISA REFERENCE (Section 1.1 Terminology):
    "Wave - A collection of 32 or 64 work-items that execute in parallel on a
    single RDNA3 processor."

    ISA REFERENCE (Table 4 STATUS register):
    "WAVE_ID - Wave id within the SIMD."

    OBSERVED: INST, VALUINST, and IMMEDIATE packets have a wave field (0-31).
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue

      packets = decode_packets(event.blob)

      wave_ids = set()
      for p in packets:
        if isinstance(p, (INST, INST_RDNA4, VALUINST, IMMEDIATE)):
          wave_ids.add(p.wave)

      # wave IDs should be valid (0-31 typically)
      for wave_id in wave_ids:
        self.assertGreaterEqual(wave_id, 0)
        self.assertLess(wave_id, 32, f"Wave ID {wave_id} >= 32")

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: Instruction Mapping
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_map_insts_decodes_kernel(self):
    """
    CLAIM: SQTT packets can be mapped back to actual GPU instructions.

    ISA REFERENCE (Section 3.2.1 Program Counter):
    "The Program Counter is a DWORD-aligned byte address that points to the
    next instruction to execute."

    OBSERVED: map_insts() correlates SQTT packets with disassembled instructions,
    tracking PC for each wave and yielding (packet, InstructionInfo) tuples.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue
      if event.kern not in prg_events:
        continue

      prg = prg_events[event.kern]
      mapped = list(map_insts(event.blob, prg.lib, self.target))

      # should have mapped packets
      self.assertGreater(len(mapped), 0)

      # count instructions that were mapped
      mapped_insts = [info for _, info in mapped if info is not None]

      if mapped_insts:
        # verify we see some instructions
        self.assertGreater(len(mapped_insts), 0)

        # verify PC is valid
        for info in mapped_insts:
          self.assertGreaterEqual(info.pc, 0)

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: s_endpgm Terminates Wave
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_waveend_maps_to_endpgm(self):
    """
    CLAIM: WAVEEND packet corresponds to s_endpgm instruction execution.

    ISA REFERENCE (Section 16.5 SOPP Instructions - S_ENDPGM):
    "End of program; terminate wavefront."

    OBSERVED: When mapping instructions, WAVEEND packet maps to s_endpgm instruction.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue
      if event.kern not in prg_events:
        continue

      prg = prg_events[event.kern]
      mapped = list(map_insts(event.blob, prg.lib, self.target))

      for pkt, info in mapped:
        if isinstance(pkt, WAVEEND) and info is not None:
          # WAVEEND should map to s_endpgm
          inst_name = type(info.inst).__name__
          self.assertIn("endpgm", inst_name.lower(),
            f"WAVEEND mapped to {inst_name}, expected s_endpgm")

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: Memory Latency Visible in Trace
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_memory_latency_visible(self):
    """
    CLAIM: Memory operations have significant latency compared to ALU operations.

    ISA REFERENCE (Section 5.6 Data Dependency Resolution):
    "Inserting S_NOP is not required to achieve correct operation."
    "These allow the shader writer to schedule long-latency instructions,
    execute unrelated work, and specify when results of long-latency operations
    are needed."

    ISA REFERENCE (Section 1.2.3 Device Memory):
    "The GPU hides memory latency by keeping track of potentially hundreds of
    work-items in various stages of execution, and by overlapping compute
    operations with memory-access operations."

    OBSERVED: Time between global_load INST packet and subsequent s_waitcnt
    shows memory latency (typically hundreds of cycles for global memory).
    """
    # use a kernel with memory operations
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue
      if event.kern not in prg_events:
        continue

      prg = prg_events[event.kern]
      mapped = list(map_insts(event.blob, prg.lib, self.target))

      load_times = []
      wait_times = []

      for pkt, info in mapped:
        if info is None:
          continue
        inst_name = str(info.inst).lower()
        if "global_load" in inst_name or "s_load" in inst_name:
          load_times.append(pkt._time)
        elif "s_waitcnt" in inst_name:
          wait_times.append(pkt._time)

      # if we have loads and waits, check the latency
      if load_times and wait_times:
        first_load = min(load_times)
        first_wait_after_load = min(t for t in wait_times if t > first_load) if any(t > first_load for t in wait_times) else None

        if first_wait_after_load:
          latency = first_wait_after_load - first_load
          # memory latency should be noticeable (at least a few cycles)
          # this is a sanity check, not a precise measurement
          self.assertGreater(latency, 0,
            "Memory load to waitcnt latency should be > 0")

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: Multiple Waves Interleaved
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_multiple_waves_interleaved(self):
    """
    CLAIM: Multiple waves can execute on the same SIMD, with instructions interleaved.

    ISA REFERENCE (Section 1.2.1 Work-group Processor):
    "The GPU hides memory latency by keeping track of potentially hundreds of
    work-items in various stages of execution."

    ISA REFERENCE (Section 2.3 Work-groups):
    "Waves in a work-group are all issued to the same WGP but can run on any
    of the 4 SIMD32's."

    OBSERVED: In traces with multiple waves, instruction packets alternate
    between different wave IDs showing interleaved execution.
    """
    # use a larger workload to get multiple waves
    import numpy as np
    a = Tensor(np.random.randn(64, 64).astype(np.float32)).realize()
    b = Tensor(np.random.randn(64, 64).astype(np.float32)).realize()
    c = (a @ b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue

      packets = decode_packets(event.blob)

      # collect wave IDs from instruction packets in order
      wave_sequence = []
      for p in packets:
        if isinstance(p, (INST, INST_RDNA4, VALUINST, IMMEDIATE)):
          wave_sequence.append(p.wave)

      if len(wave_sequence) < 2:
        continue

      unique_waves = set(wave_sequence)

      if len(unique_waves) > 1:
        # verify interleaving: check for wave ID changes
        changes = sum(1 for i in range(1, len(wave_sequence))
                     if wave_sequence[i] != wave_sequence[i-1])

        # should have multiple context switches if waves are interleaved
        self.assertGreater(changes, 0,
          f"Found {len(unique_waves)} waves but no interleaving")

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: INST Op Types Match Instruction Categories
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_inst_op_categories(self):
    """
    CLAIM: INST packet op field categorizes the instruction type.

    ISA REFERENCE (Section 4 Shader Instruction Set):
    "Instructions include: vector ALU, scalar ALU, memory transfer, and
    control flow operations."

    OBSERVED: INST packets have op field indicating instruction category:
    - SALU (0x0): Scalar ALU
    - SMEM (0x1): Scalar Memory
    - GLOBAL_LOAD/STORE: Vector global memory
    - JUMP: Branch taken
    - etc.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue

      packets = decode_packets(event.blob)

      op_types = set()
      for p in packets:
        if isinstance(p, (INST, INST_RDNA4)):
          if isinstance(p.op, (InstOp, InstOpRDNA4)):
            op_types.add(p.op.name)
          else:
            op_types.add(f"0x{p.op:02x}")

      # should see some known op types
      known_ops = {"SALU", "SMEM", "GLOBAL_LOAD", "GLOBAL_STORE", "GLOBAL_LOAD_VADDR",
                   "GLOBAL_STORE_128", "JUMP", "JUMP_NO"}

      if op_types:
        # at least some ops should be recognized
        recognized = op_types & known_ops
        # this is informational - we just verify we can decode ops
        pass

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: Clause Instructions Grouped
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_clause_groups_memory_ops(self):
    """
    CLAIM: s_clause instruction groups memory operations for efficiency.

    ISA REFERENCE (Section 5.2 Instruction Clauses):
    "The shader has an instruction type called a clause. A clause is a group
    of memory instructions that return data out-of-order."

    ISA REFERENCE (Section 8.3 Scalar Memory Clauses and Groups):
    "Scalar memory loads can return data out-of-order from how they were issued;
    they can return partial results at any time."

    OBSERVED: s_clause instructions appear before groups of SMEM or VMEM loads,
    indicating the clause length.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue
      if event.kern not in prg_events:
        continue

      prg = prg_events[event.kern]
      mapped = list(map_insts(event.blob, prg.lib, self.target))

      clause_found = False
      for pkt, info in mapped:
        if info is None:
          continue
        inst_str = str(info.inst).lower()
        if "s_clause" in inst_str:
          clause_found = True
          break

      # clauses are common but not required - just verify we can detect them
      # (no assertion, just documentation)

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: EXEC Packets Track Execution Unit Occupancy, Not Individual Instructions
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_exec_packets_are_occupancy_not_instructions(self):
    """
    CLAIM: EXEC packets (ALUEXEC/VMEMEXEC) represent execution unit occupancy,
    NOT per-instruction execution markers.

    ISA REFERENCE (Section 2 Shader Concepts):
    "The RDNA3 processor consists primarily of:
    - A scalar ALU, which operates on one value per wave
    - A vector ALU, which operates on unique values per work-item"

    ISA REFERENCE (Section 7.6 Dual Issue VALU):
    "[VALU] instructions may issue twice as two wave32 instructions."

    KEY INSIGHT: EXEC packets don't have wave IDs - they indicate the execution
    unit (SALU/VALU/VMEM) is busy, regardless of which wave is using it.
    Multiple EXEC packets can appear for a single instruction (multi-cycle ops)
    or a single EXEC can cover multiple back-to-back instructions.

    OBSERVED: ALUEXEC/VMEMEXEC packets don't have wave fields (unlike INST packets).
    The count of EXEC packets does NOT equal the count of instructions.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue

      packets = decode_packets(event.blob)

      # count instruction packets (have wave field)
      inst_count = 0
      inst_with_wave = 0
      exec_count = 0
      exec_with_wave = 0

      for p in packets:
        if isinstance(p, (INST, INST_RDNA4, VALUINST, IMMEDIATE)):
          inst_count += 1
          if hasattr(p, 'wave'):
            inst_with_wave += 1
        elif isinstance(p, (ALUEXEC, VMEMEXEC)):
          exec_count += 1
          # EXEC packets should NOT have wave field
          if hasattr(p, 'wave'):
            exec_with_wave += 1

      if inst_count > 0:
        # all instruction packets should have wave field
        self.assertEqual(inst_count, inst_with_wave,
          "All INST packets should have wave field")

        # EXEC packets should NOT have wave field (they track unit occupancy)
        self.assertEqual(exec_with_wave, 0,
          "EXEC packets should NOT have wave field - they track unit occupancy")

        # EXEC count is typically different from instruction count
        # (can be more due to multi-cycle ops, or less due to pipelining)

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: EXEC Packets Show Pipeline Latency
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_exec_shows_pipeline_stages(self):
    """
    CLAIM: The timing gap between INST issue and EXEC shows pipeline stages.

    ISA REFERENCE (Section 5.6 Data Dependency Resolution):
    "The shader has four counters that track the progress of issued instructions."

    ISA REFERENCE (Section 5.7 ALU Instruction Software Scheduling):
    "The shader program may include instructions to delay ALU instructions from
    being issued in order to attempt to avoid pipeline stalls caused by issuing
    dependent instructions too closely together."

    KEY INSIGHT: Instructions are ISSUED to the sequencer, then scheduled to
    execution units. The EXEC packet appears when the unit is actually executing.

    OBSERVED: Time delta between instruction issue and EXEC packets shows the
    issue-to-execute pipeline latency. VALU typically executes 1-4 cycles after issue.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue

      packets = decode_packets(event.blob)

      # find first ALU instruction and subsequent ALUEXEC
      first_valu_time = None
      first_aluexec_time = None

      for p in packets:
        if isinstance(p, VALUINST) and first_valu_time is None:
          first_valu_time = p._time
        elif isinstance(p, ALUEXEC) and first_valu_time is not None and first_aluexec_time is None:
          first_aluexec_time = p._time
          break

      if first_valu_time is not None and first_aluexec_time is not None:
        latency = first_aluexec_time - first_valu_time
        # pipeline latency should be small but non-negative
        self.assertGreaterEqual(latency, 0,
          "EXEC should not precede instruction issue")
        # typically a few cycles, not hundreds
        self.assertLess(latency, 100,
          f"Pipeline latency {latency} cycles seems too high for ALU")

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: s_waitcnt Visible in Trace
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_waitcnt_appears_in_trace(self):
    """
    CLAIM: s_waitcnt instructions are visible in SQTT trace as IMMEDIATE packets.

    ISA REFERENCE (Section 5.6 Data Dependency Resolution):
    "S_WAITCNT waits for the values of these counters to be at, or below,
    specified values before continuing."

    ISA REFERENCE (Table 18 Data Dependency Instructions):
    "S_WAITCNT - Wait for count of outstanding instruction counters to be
    less-than or equal-to all of these values before continuing.
    SIMM16 = { VMcnt[5:0], LGKMcnt[5:0], 1'b0, EXPcnt[2:0] }"

    OBSERVED: s_waitcnt instructions appear as IMMEDIATE packets in the trace,
    allowing us to see when the shader waits for memory operations.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue
      if event.kern not in prg_events:
        continue

      prg = prg_events[event.kern]
      mapped = list(map_insts(event.blob, prg.lib, self.target))

      waitcnt_found = False
      for pkt, info in mapped:
        if info is None:
          continue
        inst_str = str(info.inst).lower()
        if "waitcnt" in inst_str:
          waitcnt_found = True
          # verify it came from IMMEDIATE packet
          self.assertIsInstance(pkt, (IMMEDIATE, IMMEDIATE_MASK),
            f"s_waitcnt should be IMMEDIATE packet, got {type(pkt).__name__}")
          break

      # most kernels with memory ops have waitcnt
      # (not asserting True because some simple kernels may not have them)

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: SIMD/CU Identification in Wave Packets
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_simd_cu_identification(self):
    """
    CLAIM: Wave lifecycle packets identify which SIMD/CU the wave runs on.

    ISA REFERENCE (Section 1.2.1 Work-group Processor):
    "The processor array is organized as a set of work-group processor (WGP)
    pipelines, each independent from the others."

    ISA REFERENCE (Section 2.3 Work-groups):
    "Waves in a work-group are all issued to the same WGP but can run on any
    of the 4 SIMD32's."

    ISA REFERENCE (Table 4 STATUS register):
    "WAVE_ID 4:0 - Wave id within the SIMD.
     SIMD_ID 9:8 - SIMD_ID within the WGP"

    OBSERVED: WAVESTART and WAVEEND packets contain cu, simd, and wave fields
    that identify exactly where the wave executed.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue

      packets = decode_packets(event.blob)

      for p in packets:
        if isinstance(p, (WAVESTART, WAVESTART_RDNA4)):
          # verify SIMD/CU fields are present and valid
          self.assertGreaterEqual(p.simd, 0)
          self.assertLess(p.simd, 4, "SIMD ID should be 0-3")
          self.assertGreaterEqual(p.cu, 0)
          self.assertGreaterEqual(p.wave, 0)

        elif isinstance(p, WAVEEND):
          self.assertGreaterEqual(p.simd, 0)
          self.assertLess(p.simd, 4, "SIMD ID should be 0-3")
          self.assertGreaterEqual(p.cu, 0)
          self.assertGreaterEqual(p.wave, 0)

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: VALU vs SALU Instruction Distribution
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_valu_salu_instruction_distribution(self):
    """
    CLAIM: Different instruction types appear as different packet types.

    ISA REFERENCE (Section 6 Scalar ALU Operations):
    "Scalar ALU (SALU) instructions operate on values that are common to all
    work-items in the wave. These operations consist of 32-bit integer or float
    arithmetic, and 32- or 64-bit bit-wise operations."

    ISA REFERENCE (Section 7 Vector ALU Operations):
    "Vector ALU (VALU) instructions control the SIMD32's math unit and operate
    on 32 work-items of data at a time."

    ISA REFERENCE (Packet types):
    - VALUINST: VALU instruction issued
    - INST with op=SALU: Scalar ALU instruction
    - IMMEDIATE: SOPP instructions (s_waitcnt, s_clause, etc.)

    OBSERVED: Add kernel shows VALUINST for v_add_f32, INST/IMMEDIATE for s_* ops.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    for event in sqtt_events:
      if not event.itrace:
        continue
      if event.kern not in prg_events:
        continue

      prg = prg_events[event.kern]
      mapped = list(map_insts(event.blob, prg.lib, self.target))

      valu_insts = []
      salu_insts = []
      smem_insts = []

      for pkt, info in mapped:
        if info is None:
          continue
        inst_str = str(info.inst).lower()

        if isinstance(pkt, VALUINST):
          valu_insts.append(inst_str)
        elif isinstance(pkt, (INST, INST_RDNA4)):
          op_name = pkt.op.name if isinstance(pkt.op, (InstOp, InstOpRDNA4)) else ""
          if op_name == "SALU":
            salu_insts.append(inst_str)
          elif op_name == "SMEM":
            smem_insts.append(inst_str)
        elif isinstance(pkt, IMMEDIATE):
          # IMMEDIATE is typically for SOPP (s_waitcnt, s_clause, etc.)
          salu_insts.append(inst_str)

      # a kernel should have both VALU (for the actual add) and SALU (for control flow)
      if valu_insts:
        # verify VALU instructions are vector ops
        for inst in valu_insts:
          # VALU ops typically start with v_ or are VOPD dual-issue
          self.assertTrue(
            inst.startswith("v_") or "vopd" in inst.lower() or "dual" in inst.lower(),
            f"Expected VALU instruction to start with v_, got: {inst}"
          )

  # ═══════════════════════════════════════════════════════════════════════════════
  # TEST: Global Memory Operations Have Distinct OpCodes
  # ═══════════════════════════════════════════════════════════════════════════════

  def test_global_memory_opcodes(self):
    """
    CLAIM: Global memory load/store operations have distinct INST opcodes.

    ISA REFERENCE (Section 11.1.2 Global):
    "Global instructions transfer data between VGPRs and global memory."

    ISA REFERENCE (InstOp enum from sqtt.py):
    "GLOBAL_LOAD = 0x21      # saddr=SGPR, all sizes
     GLOBAL_LOAD_VADDR = 0x22 # saddr=NULL, all sizes
     GLOBAL_STORE = 0x24     # saddr=SGPR, 32-bit
     GLOBAL_STORE_128 = 0x27 # saddr=SGPR 128 or saddr=NULL 96"

    OBSERVED: INST packets for global_load/global_store have appropriate op values.
    """
    a = Tensor([1.0, 2.0, 3.0, 4.0]).realize()
    b = Tensor([5.0, 6.0, 7.0, 8.0]).realize()
    c = (a + b).realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()

    global_ops = set()
    for event in sqtt_events:
      if not event.itrace:
        continue

      packets = decode_packets(event.blob)

      for p in packets:
        if isinstance(p, (INST, INST_RDNA4)):
          if isinstance(p.op, (InstOp, InstOpRDNA4)):
            op_name = p.op.name
            if "GLOBAL" in op_name:
              global_ops.add(op_name)

    # should see some global ops in memory-accessing kernels
    # (load from a, load from b, store to c)
    if global_ops:
      # verify they're valid global op names
      for op in global_ops:
        self.assertTrue(op.startswith("GLOBAL_"),
          f"Global op should start with GLOBAL_, got {op}")


# ═══════════════════════════════════════════════════════════════════════════════
# RAW ASSEMBLY TESTS
# These tests use custom kernels with hand-written assembly to verify specific
# SQTT packet behavior for known instruction sequences.
# ═══════════════════════════════════════════════════════════════════════════════

from tinygrad.uop.ops import UOp, Ops, KernelInfo
from tinygrad.renderer import Estimates
from tinygrad.runtime.autogen.amd.rdna3.ins import (s_nop, s_endpgm, v_mov_b32_e32, s_mov_b32, s_mov_b64, s_waitcnt,
  global_load_b32, global_store_b32, s_load_b64, v_lshlrev_b32_e32, v_add_f32_e32,
  v_readlane_b32, v_readfirstlane_b32_e32, v_writelane_b32)
from tinygrad.renderer.amd.dsl import s, v, NULL, EXEC
from test.amd.helpers import TARGET_TO_ARCH

def make_custom_kernel(name: str, insts: list, size: int = 1) -> callable:
  def kernel_fn(A: UOp) -> UOp:
    A = A.flatten()
    threads = UOp.special(size, "lidx0")
    sink = UOp.sink(A.base, threads, arg=KernelInfo(name, estimates=Estimates(ops=size, mem=size*4)))
    return UOp(Ops.PROGRAM, src=(sink, UOp(Ops.DEVICE, arg="AMD"), UOp(Ops.LINEAR, src=tuple([UOp(Ops.INS, arg=x) for x in insts]))))
  return kernel_fn

def get_kernel_sqtt(sqtt_events, prg_events, kernel_name: str):
  """Get the SQTT event for a specific kernel by name."""
  for event in sqtt_events:
    # se 1 has the itrace.
    if not event.itrace or event.se != 1: continue
    prg = prg_events[event.kern]
    if kernel_name in prg.name:
      return event, prg

def correlate_issue_to_exec(mapped):
  """Link each instruction ISSUE packet to its corresponding EXEC packet.

  Returns list of (issue_pkt, info, exec_type, exec_pkt, latency_cycles).
  exec_type is 'VALU', 'SALU', 'VMEM', or 'SMEM' based on instruction class.
  """
  # collect issue packets with their expected exec type
  issues = []
  for pkt, info in mapped:
    if not info: continue
    if isinstance(pkt, VALUINST):
      issues.append((pkt, info, 'VALU'))
    elif isinstance(pkt, (INST, INST_RDNA4)):
      if isinstance(pkt.op, (InstOp, InstOpRDNA4)):
        if 'GLOBAL' in pkt.op.name or 'FLAT' in pkt.op.name:
          issues.append((pkt, info, 'VMEM'))
        elif pkt.op.name == 'SMEM':
          issues.append((pkt, info, 'SMEM'))
        elif pkt.op.name == 'SALU':
          issues.append((pkt, info, 'SALU'))
        else:
          issues.append((pkt, info, pkt.op.name))

  # collect exec packets
  execs = []
  for pkt, _ in mapped:
    if isinstance(pkt, ALUEXEC):
      src = pkt.src.name if isinstance(pkt.src, AluSrc) else str(pkt.src)
      execs.append((pkt, src))
    elif isinstance(pkt, VMEMEXEC):
      src = pkt.src.name if isinstance(pkt.src, MemSrc) else str(pkt.src)
      execs.append((pkt, src))

  # match each issue to next exec of same type
  exec_idx = 0
  results = []
  for issue_pkt, info, expected_type in issues:
    matched_exec = None
    for i in range(exec_idx, len(execs)):
      exec_pkt, exec_src = execs[i]
      if expected_type in exec_src or exec_src in expected_type:
        matched_exec = exec_pkt
        exec_idx = i + 1
        break
    latency = (matched_exec._time - issue_pkt._time) if matched_exec else None
    results.append((issue_pkt, info, expected_type, matched_exec, latency))

  return results
  raise AssertionError(f"No SQTT event found for kernel '{kernel_name}'")

@unittest.skipUnless(getenv("AMD") and Device.DEFAULT == "AMD", "AMD only")
class TestSQTTRawAssembly(unittest.TestCase):
  """
  Tests using raw assembly to verify SQTT packet behavior for known instruction sequences.
  """

  @classmethod
  def setUpClass(cls):
    cls.target = get_target()
    cls.arch = TARGET_TO_ARCH.get(Device["AMD"].arch, "rdna3")

  def setUp(self):
    Compiled.profile_events.clear()

  def test_raw_asm_nop_endpgm(self):
    """
    CLAIM: s_nop instructions produce exactly one IMMEDIATE packet each.

    ISA REFERENCE (Section 16.5 SOPP Instructions - S_NOP):
    "Do nothing. Repeat NOP 1..8 times based on SIMM16[2:0]."

    OBSERVED: 2 s_nop instructions produce exactly 2 IMMEDIATE packets mapped to s_nop.
    """
    if self.arch != "rdna3": self.skipTest("only rdna3")

    insts = [s_nop(0), s_nop(0), s_endpgm()]

    a = Tensor.empty(1).contiguous().realize()
    Tensor.custom_kernel(a, fxn=make_custom_kernel("test_nop_endpgm", insts, size=1))[0].realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()
    event, prg = get_kernel_sqtt(sqtt_events, prg_events, "test_nop_endpgm")
    mapped = list(map_insts(event.blob, prg.lib, self.target))

    # find s_nop instructions (filter out EXEC packets which now have correlated inst info)
    nops = [(pkt, info) for pkt, info in mapped if info and is_issue_packet(pkt) and "s_nop" in str(info.inst).lower()]
    self.assertEqual(len(nops), 2, f"Expected 2 s_nop, got {len(nops)}")

    # s_nop maps to IMMEDIATE packet
    for pkt, info in nops:
      self.assertIsInstance(pkt, (IMMEDIATE, IMMEDIATE_MASK), f"s_nop should be IMMEDIATE, got {type(pkt).__name__}")

  def test_raw_asm_valu_instruction(self):
    """
    CLAIM: v_mov_b32 produces VALUINST packet.

    ISA REFERENCE (Section 7.1 VOP1 Instructions - V_MOV_B32):
    "D.u = S0.u"

    OBSERVED: 2 v_mov_b32_e32 instructions produce exactly 2 VALUINST packets mapped to v_mov_b32.
    """
    if self.arch != "rdna3": self.skipTest("only rdna3")

    insts = [v_mov_b32_e32(v[0], 0), v_mov_b32_e32(v[1], 1.0), s_endpgm()]

    a = Tensor.empty(1).contiguous().realize()
    Tensor.custom_kernel(a, fxn=make_custom_kernel("test_valu_mov", insts, size=1))[0].realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()
    event, prg = get_kernel_sqtt(sqtt_events, prg_events, "test_valu_mov")
    mapped = list(map_insts(event.blob, prg.lib, self.target))

    # find v_mov_b32 instructions (filter out EXEC packets which now have correlated inst info)
    vmovs = [(pkt, info) for pkt, info in mapped if info and is_issue_packet(pkt) and "v_mov_b32" in str(info.inst).lower()]
    self.assertEqual(len(vmovs), 2, f"Expected 2 v_mov_b32, got {len(vmovs)}")

    # v_mov_b32 maps to VALUINST packet
    for pkt, info in vmovs:
      self.assertIsInstance(pkt, VALUINST, f"v_mov_b32 should be VALUINST, got {type(pkt).__name__}")

  def test_raw_asm_salu_instruction(self):
    """
    CLAIM: s_mov_b32 produces INST packet with op=SALU.

    ISA REFERENCE (Section 6.1 SOP1 Instructions - S_MOV_B32):
    "D.u = S0.u"

    OBSERVED: 2 s_mov_b32 instructions produce exactly 2 INST packets mapped to s_mov_b32.
    """
    if self.arch != "rdna3": self.skipTest("only rdna3")

    insts = [s_mov_b32(s[0], 0), s_mov_b32(s[1], 1), s_endpgm()]

    a = Tensor.empty(1).contiguous().realize()
    Tensor.custom_kernel(a, fxn=make_custom_kernel("test_salu_mov", insts, size=1))[0].realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()
    event, prg = get_kernel_sqtt(sqtt_events, prg_events, "test_salu_mov")
    mapped = list(map_insts(event.blob, prg.lib, self.target))

    # find s_mov_b32 instructions (filter out EXEC packets which now have correlated inst info)
    smovs = [(pkt, info) for pkt, info in mapped if info and is_issue_packet(pkt) and "s_mov_b32" in str(info.inst).lower()]
    self.assertEqual(len(smovs), 2, f"Expected 2 s_mov_b32, got {len(smovs)}")

    # s_mov_b32 maps to INST packet with SALU op
    for pkt, info in smovs:
      self.assertIsInstance(pkt, (INST, INST_RDNA4), f"s_mov_b32 should be INST, got {type(pkt).__name__}")
      self.assertEqual(pkt.op, InstOp.SALU, f"s_mov_b32 should have SALU op, got {pkt.op}")

  def test_raw_asm_global_load_store(self):
    """
    CLAIM: global_load/global_store produce INST packets with GLOBAL_* opcodes.

    ISA REFERENCE (Section 11.1.2 Global):
    "Global instructions transfer data between VGPRs and global memory."

    OBSERVED: global_load_b32 maps to INST with GLOBAL_LOAD op, global_store_b32 maps to INST with GLOBAL_STORE op.
    """
    if self.arch != "rdna3": self.skipTest("only rdna3")

    insts = [
      s_load_b64(s[0:1], s[0:1], soffset=NULL),
      s_waitcnt(lgkmcnt=0),
      v_lshlrev_b32_e32(v[0], 2, v[0]),
      global_load_b32(v[1], v[0], saddr=s[0:1]),
      s_waitcnt(vmcnt=0),
      v_add_f32_e32(v[1], v[1], v[1]),
      global_store_b32(addr=v[0], data=v[1], saddr=s[0:1]),
      s_endpgm(),
    ]

    a = Tensor.empty(4)
    Tensor.custom_kernel(a, fxn=make_custom_kernel("test_global_load_store", insts, size=4))[0].realize()

    sqtt_events, prg_events = get_sqtt_events()
    event, prg = get_kernel_sqtt(sqtt_events, prg_events, "test_global_load_store")
    mapped = list(map_insts(event.blob, prg.lib, self.target))

    # find global_load_b32 and global_store_b32 instructions (filter out EXEC packets which now have correlated inst info)
    loads = [(pkt, info) for pkt, info in mapped if info and is_issue_packet(pkt) and "global_load" in str(info.inst).lower()]
    stores = [(pkt, info) for pkt, info in mapped if info and is_issue_packet(pkt) and "global_store" in str(info.inst).lower()]

    self.assertEqual(len(loads), 1, f"Expected 1 global_load, got {len(loads)}")
    self.assertEqual(len(stores), 1, f"Expected 1 global_store, got {len(stores)}")

    # verify packet types have GLOBAL_* ops
    pkt, info = loads[0]
    self.assertIsInstance(pkt, (INST, INST_RDNA4))
    self.assertIn("GLOBAL_LOAD", pkt.op.name)

    pkt, info = stores[0]
    self.assertIsInstance(pkt, (INST, INST_RDNA4))
    self.assertIn("GLOBAL_STORE", pkt.op.name)

  def test_raw_asm_waitcnt_visible(self):
    """
    CLAIM: s_waitcnt produces IMMEDIATE packet.

    ISA REFERENCE (Section 5.6 Data Dependency Resolution):
    "S_WAITCNT waits for the values of these counters."

    OBSERVED: s_waitcnt maps to IMMEDIATE packet.
    """
    if self.arch != "rdna3": self.skipTest("only rdna3")

    insts = [s_waitcnt(vmcnt=0, lgkmcnt=0), s_nop(0), s_endpgm()]

    a = Tensor.empty(1).contiguous().realize()
    Tensor.custom_kernel(a, fxn=make_custom_kernel("test_waitcnt", insts, size=1))[0].realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()
    event, prg = get_kernel_sqtt(sqtt_events, prg_events, "test_waitcnt")
    mapped = list(map_insts(event.blob, prg.lib, self.target))

    # find s_waitcnt instruction (filter out EXEC packets which now have correlated inst info)
    waitcnts = [(pkt, info) for pkt, info in mapped if info and is_issue_packet(pkt) and "s_waitcnt" in str(info.inst).lower()]
    self.assertEqual(len(waitcnts), 1, f"Expected 1 s_waitcnt, got {len(waitcnts)}")

    # s_waitcnt maps to IMMEDIATE packet
    pkt, info = waitcnts[0]
    self.assertIsInstance(pkt, (IMMEDIATE, IMMEDIATE_MASK), f"s_waitcnt should be IMMEDIATE, got {type(pkt).__name__}")

  def test_raw_asm_exec_timing_relationship(self):
    """
    CLAIM: VALU instructions produce VALUINST packets, followed by ALUEXEC with VALU source.

    ISA REFERENCE (Section 5.7 ALU Instruction Software Scheduling):
    "The shader program may include instructions to delay ALU instructions."

    OBSERVED: v_mov and v_add map to VALUINST packets. ALUEXEC appears after VALUINST (issue before execute).
    """
    if self.arch != "rdna3": self.skipTest("only rdna3")

    insts = [
      v_mov_b32_e32(v[0], 1.0),
      v_mov_b32_e32(v[1], 2.0),
      v_add_f32_e32(v[2], v[0], v[1]),
      v_add_f32_e32(v[3], v[2], v[0]),
      v_add_f32_e32(v[4], v[3], v[1]),
      s_endpgm(),
    ]

    a = Tensor.empty(1).contiguous().realize()
    Tensor.custom_kernel(a, fxn=make_custom_kernel("test_exec_timing", insts, size=1))[0].realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()
    event, prg = get_kernel_sqtt(sqtt_events, prg_events, "test_exec_timing")
    mapped = list(map_insts(event.blob, prg.lib, self.target))

    # find v_mov and v_add instructions (filter out EXEC packets which now have correlated inst info)
    vmovs = [(pkt, info) for pkt, info in mapped if info and is_issue_packet(pkt) and "v_mov_b32" in str(info.inst).lower()]
    vadds = [(pkt, info) for pkt, info in mapped if info and is_issue_packet(pkt) and "v_add_f32" in str(info.inst).lower()]

    self.assertEqual(len(vmovs), 2, f"Expected 2 v_mov_b32, got {len(vmovs)}")
    self.assertEqual(len(vadds), 3, f"Expected 3 v_add_f32, got {len(vadds)}")

    # all VALU ops map to VALUINST
    for pkt, info in vmovs + vadds:
      self.assertIsInstance(pkt, VALUINST, f"{info.inst} should be VALUINST, got {type(pkt).__name__}")

    # ALUEXEC packets exist and follow VALUINST in time
    packets = [pkt for pkt, _ in mapped]
    first_valuinst = next(p for p in packets if isinstance(p, VALUINST))
    first_aluexec = next((p for p in packets if isinstance(p, ALUEXEC)), None)
    self.assertIsNotNone(first_aluexec, "Should have ALUEXEC packets")
    self.assertLessEqual(first_valuinst._time, first_aluexec._time)

  def test_raw_asm_issue_to_exec_correlation(self):
    """
    CLAIM: Each instruction ISSUE can be correlated to its EXEC packet.

    ISA REFERENCE (Section 3.2.1 Program Counter):
    "The PC points to the next instruction to issue. All prior instructions have
    been issued but may or may not have completed execution."

    OBSERVED: VALU issues correlate to ALUEXEC(VALU), VMEM issues correlate to VMEMEXEC.
    The latency (cycles between issue and exec) is visible in the trace.
    """
    if self.arch != "rdna3": self.skipTest("only rdna3")

    insts = [
      s_load_b64(s[0:1], s[0:1], soffset=NULL),
      s_waitcnt(lgkmcnt=0),
      v_lshlrev_b32_e32(v[0], 2, v[0]),
      global_load_b32(v[1], v[0], saddr=s[0:1]),
      s_waitcnt(vmcnt=0),
      v_add_f32_e32(v[1], v[1], v[1]),
      global_store_b32(addr=v[0], data=v[1], saddr=s[0:1]),
      s_endpgm(),
    ]

    a = Tensor([1.0, 2.0, 3.0, 4.0]).contiguous().realize()
    Tensor.custom_kernel(a, fxn=make_custom_kernel("test_correlation", insts, size=4))[0].realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()
    event, prg = get_kernel_sqtt(sqtt_events, prg_events, "test_correlation")
    mapped = list(map_insts(event.blob, prg.lib, self.target))

    correlated = correlate_issue_to_exec(mapped)

    # verify VALU instructions have EXEC with positive latency
    valu_corr = [(info, latency) for _, info, exec_type, exec_pkt, latency in correlated
                 if exec_type == 'VALU' and exec_pkt is not None]
    self.assertEqual(len(valu_corr), 2, f"Expected 2 VALU with EXEC, got {len(valu_corr)}")
    for info, latency in valu_corr:
      self.assertGreater(latency, 0, f"{info.inst} should have positive latency")

    # verify VMEM instructions have EXEC
    vmem_corr = [(info, latency) for _, info, exec_type, exec_pkt, latency in correlated
                 if exec_type == 'VMEM' and exec_pkt is not None]
    self.assertEqual(len(vmem_corr), 2, f"Expected 2 VMEM with EXEC, got {len(vmem_corr)}")

  def test_raw_asm_exec_zero_skipping(self):
    """
    CLAIM: VALU instructions with EXEC=0 are skipped and produce IMMEDIATE packets (not VALUINST).

    ISA REFERENCE (Section 3.2.3 Instruction Skipping):
    "The shader hardware may skip vector instructions when EXEC==0."
    "VALU - skip if EXEC == 0"

    OBSERVED: When EXEC=0, VALU instructions produce IMMEDIATE packets instead of VALUINST,
    and no corresponding ALUEXEC packet is generated.
    """
    if self.arch != "rdna3": self.skipTest("only rdna3")

    insts = [
      v_mov_b32_e32(v[0], 42),           # VALU with EXEC=all ones -> VALUINST + ALUEXEC
      s_mov_b64(s[2:3], EXEC),           # save EXEC -> INST(SALU) + ALUEXEC(SALU)
      s_mov_b64(EXEC, 0),                # set EXEC=0 -> INST(SALU_SAVEEXEC) + ALUEXEC(SALU)
      v_mov_b32_e32(v[1], 99),           # VALU with EXEC=0 -> IMMEDIATE (skipped, no ALUEXEC)
      v_mov_b32_e32(v[2], 100),          # another skipped VALU -> IMMEDIATE
      s_mov_b64(EXEC, s[2:3]),           # restore EXEC -> INST(SALU_SAVEEXEC) + ALUEXEC(SALU)
      v_mov_b32_e32(v[3], 200),          # VALU with EXEC restored -> VALUINST + ALUEXEC
      s_endpgm(),
    ]

    a = Tensor.empty(1).contiguous().realize()
    Tensor.custom_kernel(a, fxn=make_custom_kernel("test_exec_zero", insts, size=1))[0].realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()
    event, prg = get_kernel_sqtt(sqtt_events, prg_events, "test_exec_zero")
    mapped = list(map_insts(event.blob, prg.lib, self.target))

    # Count VALUINST packets - should only be 2 (first and last v_mov, not the skipped ones)
    valuinsts = [(pkt, info) for pkt, info in mapped if isinstance(pkt, VALUINST)]
    self.assertEqual(len(valuinsts), 2, f"Expected 2 VALUINST (skipped VALUs don't produce VALUINST), got {len(valuinsts)}")

    # Count IMMEDIATE packets with v_mov instructions - should be 2 (the skipped ones)
    skipped_vmovs = [(pkt, info) for pkt, info in mapped
                    if isinstance(pkt, IMMEDIATE) and info and "v_mov" in str(info.inst).lower()]
    self.assertEqual(len(skipped_vmovs), 2, f"Expected 2 skipped v_mov as IMMEDIATE, got {len(skipped_vmovs)}")

    # Count ALUEXEC packets - 2 VALU + 3 SALU = 5 total
    aluexecs = [(pkt, info) for pkt, info in mapped if isinstance(pkt, ALUEXEC)]
    self.assertEqual(len(aluexecs), 5, f"Expected 5 ALUEXEC (2 VALU + 3 SALU), got {len(aluexecs)}")

    # Verify all ALUEXEC are correlated (no None info)
    uncorrelated = [pkt for pkt, info in aluexecs if info is None]
    self.assertEqual(len(uncorrelated), 0, f"All ALUEXEC should be correlated, got {len(uncorrelated)} uncorrelated")

  def test_raw_asm_readlane_writelane(self):
    """
    CLAIM: v_readlane, v_readfirstlane, v_writelane produce VALUINST + ALUEXEC despite writing to SGPRs.

    ISA REFERENCE (Section 3.2.3 Instruction Skipping):
    "These are not skipped regardless of EXEC mask value, and are issued only once in wave64:
     V_NOP, V_PIPEFLUSH, V_READLANE, V_READFIRSTLANE, V_WRITELANE"

    OBSERVED: These lane instructions produce VALUINST packets and corresponding ALUEXEC(VALU) packets.
    """
    if self.arch != "rdna3": self.skipTest("only rdna3")

    insts = [
      v_mov_b32_e32(v[0], 42),                 # regular VALU
      v_readlane_b32(s[0], v[0], 0),           # readlane: VGPR -> SGPR
      v_readfirstlane_b32_e32(s[1], v[0]),     # readfirstlane: VGPR -> SGPR
      v_writelane_b32(v[1], s[0], 0),          # writelane: SGPR -> one lane of VGPR
      v_mov_b32_e32(v[2], 99),                 # regular VALU
      s_endpgm(),
    ]

    a = Tensor.empty(1).contiguous().realize()
    Tensor.custom_kernel(a, fxn=make_custom_kernel("test_lane_ops", insts, size=1))[0].realize()
    Device["AMD"].synchronize()

    sqtt_events, prg_events = get_sqtt_events()
    event, prg = get_kernel_sqtt(sqtt_events, prg_events, "test_lane_ops")
    mapped = list(map_insts(event.blob, prg.lib, self.target))

    # All 5 V_ instructions should produce VALUINST
    valuinsts = [(pkt, info) for pkt, info in mapped if isinstance(pkt, VALUINST)]
    self.assertEqual(len(valuinsts), 5, f"Expected 5 VALUINST, got {len(valuinsts)}")

    # All 5 should have corresponding ALUEXEC(VALU)
    aluexecs = [(pkt, info) for pkt, info in mapped if isinstance(pkt, ALUEXEC)]
    valu_execs = [(pkt, info) for pkt, info in aluexecs if pkt.src == AluSrc.VALU]
    self.assertEqual(len(valu_execs), 5, f"Expected 5 ALUEXEC(VALU), got {len(valu_execs)}")

    # Verify lane ops are correctly mapped - check both VALUINST and ALUEXEC have the lane instructions
    lane_valuinsts = [(pkt, info) for pkt, info in mapped
                      if isinstance(pkt, VALUINST) and info and "lane" in str(info.inst).lower()]
    lane_aluexecs = [(pkt, info) for pkt, info in mapped
                     if isinstance(pkt, ALUEXEC) and info and "lane" in str(info.inst).lower()]
    self.assertEqual(len(lane_valuinsts), 3, f"Expected 3 lane VALUINST, got {len(lane_valuinsts)}")
    self.assertEqual(len(lane_aluexecs), 3, f"Expected 3 lane ALUEXEC (correlated), got {len(lane_aluexecs)}")


if __name__ == "__main__":
  unittest.main()
