#!/usr/bin/env python3
"""
WMMA/Tensor Core Starvation Analyzer

Analyzes SQTT output from extra/viz/cli.py to identify when tensor cores are idle and why.

Usage:
  VIZ=-2 python extra/gemm/amd_wmma_matmul.py
  python extra/viz/cli.py -p -s "SQTT wmma_kernel SE:0 PKTS" | python extra/gemm/analyze_wmma.py
  # Or from file:
  python extra/gemm/analyze_wmma.py < /tmp/sqtt_trace.txt
"""

import sys
import re
from collections import defaultdict

ANSI_RE = re.compile(r'\x1b\[[0-9;]*m')

def analyze_wmma_starvation_streaming():
  """Analyze SQTT trace to find WMMA starvation periods - optimized single-pass"""

  # Counters for single-pass analysis
  min_clk = float('inf')
  max_clk = 0
  
  wmma_execs = []  # (clk, dur) tuples for WMMA ops
  mem_ops_by_type = defaultdict(lambda: {'count': 0, 'total_delay': 0, 'max_delay': 0})
  high_delay_ops = []  # Top delay operations
  
  # Event timeline for gap analysis - store (clk, event_type) tuples
  # event_type: 'barrier', 'waitcnt', 'global_load', 'lds'
  timeline_events = []
  
  line_count = 0
  
  for line in sys.stdin:
    line_count += 1
    if line_count % 100000 == 0:
      print(f"Processing line {line_count}...", file=sys.stderr)
    
    # Strip ANSI codes
    line = ANSI_RE.sub('', line)
    if not line.strip() or line.startswith('Clk') or line.startswith('-'):
      continue
    
    parts = line.split()
    if len(parts) < 4:
      continue
    
    try:
      clk = int(parts[0])
      unit = parts[1]
      op = parts[2]
      dur = int(parts[3]) if parts[3].isdigit() else 1
    except (ValueError, IndexError):
      continue
    
    min_clk = min(min_clk, clk)
    max_clk = max(max_clk, clk)
    
    # Parse phase and info
    phase = None
    delay = 0
    info = ""
    
    if len(parts) > 4:
      if parts[4] == "DISPATCH":
        phase = "DISPATCH"
        info = " ".join(parts[5:]) if len(parts) > 5 else ""
      elif parts[4].isdigit():
        delay = int(parts[4])
        if len(parts) > 5 and parts[5] == "EXEC":
          phase = "EXEC"
          info = " ".join(parts[6:]) if len(parts) > 6 else ""
        else:
          info = " ".join(parts[5:]) if len(parts) > 5 else ""
      elif parts[4] == "EXEC":
        phase = "EXEC"
        info = " ".join(parts[5:]) if len(parts) > 5 else ""
      else:
        info = " ".join(parts[4:])
    
    # Only analyze EXEC phase
    if phase != "EXEC":
      continue
    
    # Track WMMA operations
    if 'wmma' in info.lower():
      wmma_execs.append((clk, dur, delay))
      mem_ops_by_type['v_wmma']['count'] += 1
      mem_ops_by_type['v_wmma']['total_delay'] += delay
      mem_ops_by_type['v_wmma']['max_delay'] = max(mem_ops_by_type['v_wmma']['max_delay'], delay)
    
    # Track memory operations
    if 'global_load_b128' in info:
      mem_ops_by_type['global_load_b128']['count'] += 1
      mem_ops_by_type['global_load_b128']['total_delay'] += delay
      mem_ops_by_type['global_load_b128']['max_delay'] = max(mem_ops_by_type['global_load_b128']['max_delay'], delay)
    elif 'global_load_u16' in info:
      mem_ops_by_type['global_load_u16']['count'] += 1
      mem_ops_by_type['global_load_u16']['total_delay'] += delay
      mem_ops_by_type['global_load_u16']['max_delay'] = max(mem_ops_by_type['global_load_u16']['max_delay'], delay)
    elif 'global_store' in info:
      mem_ops_by_type['global_store']['count'] += 1
      mem_ops_by_type['global_store']['total_delay'] += delay
      mem_ops_by_type['global_store']['max_delay'] = max(mem_ops_by_type['global_store']['max_delay'], delay)
    elif 'ds_load' in info or 'ds_read' in info:
      mem_ops_by_type['ds_load']['count'] += 1
      mem_ops_by_type['ds_load']['total_delay'] += delay
      mem_ops_by_type['ds_load']['max_delay'] = max(mem_ops_by_type['ds_load']['max_delay'], delay)
    elif 'ds_store' in info or 'ds_write' in info:
      mem_ops_by_type['ds_store']['count'] += 1
      mem_ops_by_type['ds_store']['total_delay'] += delay
      mem_ops_by_type['ds_store']['max_delay'] = max(mem_ops_by_type['ds_store']['max_delay'], delay)
    
    # Track high-delay operations
    if delay > 100:
      high_delay_ops.append((clk, delay, op, info[:60]))
      # Keep only top 100 for memory efficiency
      if len(high_delay_ops) > 200:
        high_delay_ops.sort(key=lambda x: -x[1])
        high_delay_ops = high_delay_ops[:100]
    
    # Track timeline events for gap analysis
    if 's_barrier' in info:
      timeline_events.append((clk, 'barrier'))
    if 's_waitcnt' in info:
      timeline_events.append((clk, 'waitcnt'))
    if 'global_load' in info:
      timeline_events.append((clk, 'global_load'))
    if 'ds_' in info:
      timeline_events.append((clk, 'lds'))

  print(f"Processed {line_count} lines", file=sys.stderr)
  
  if not wmma_execs:
    print("ERROR: No WMMA operations found in trace")
    return
  
  total_cycles = max_clk - min_clk + 1
  
  # Sort WMMA executions by clock
  wmma_execs.sort(key=lambda x: x[0])
  
  # Calculate WMMA active cycles
  wmma_cycles = sum(dur for _, dur, _ in wmma_execs)
  
  print("=" * 80)
  print("WMMA/TENSOR CORE STARVATION ANALYSIS")
  print("=" * 80)
  print(f"\nTotal trace cycles: {total_cycles:,}")
  print(f"Total WMMA operations: {len(wmma_execs)}")
  print(f"Total WMMA cycles: {wmma_cycles:,}")
  print(f"WMMA utilization: {100 * wmma_cycles / total_cycles:.1f}%")
  print(f"Theoretical max (if 100% busy): {135 * wmma_cycles / total_cycles:.1f} TFLOPS (of 135 peak)")
  
  # Sort timeline events for binary search
  timeline_events.sort(key=lambda x: x[0])
  event_clks = [e[0] for e in timeline_events]
  
  # Find gaps between WMMA operations
  gaps = []
  prev_end = wmma_execs[0][0]
  
  for clk, dur, _ in wmma_execs:
    gap = clk - prev_end
    if gap > 0:
      gaps.append((prev_end, clk, gap))
    prev_end = clk + dur
  
  print(f"\n{'=' * 80}")
  print("STARVATION GAPS (periods where tensor cores are idle)")
  print("=" * 80)
  
  # Sort gaps by duration
  gaps_sorted = sorted(gaps, key=lambda x: -x[2])
  
  # For top gaps, find causes using binary search
  import bisect
  
  def get_gap_causes(start, end):
    """Find event types in a gap using binary search"""
    left = bisect.bisect_left(event_clks, start)
    right = bisect.bisect_right(event_clks, end)
    causes = set()
    for i in range(left, min(right, len(timeline_events))):
      if start <= timeline_events[i][0] < end:
        causes.add(timeline_events[i][1])
    return causes
  
  print(f"\nTop 20 longest gaps (out of {len(gaps)} total):")
  print(f"{'Gap#':<6} {'Start':<12} {'End':<12} {'Duration':<10} {'Cause'}")
  print("-" * 80)
  
  for i, (start, end, duration) in enumerate(gaps_sorted[:20]):
    causes = get_gap_causes(start, end)
    cause_str = ", ".join(sorted(causes)).upper() if causes else "OTHER"
    print(f"{i+1:<6} {start:<12} {end:<12} {duration:<10} {cause_str}")
  
  # Aggregate gap analysis
  print(f"\n{'=' * 80}")
  print("GAP ANALYSIS SUMMARY")
  print("=" * 80)
  
  total_gap_cycles = sum(g[2] for g in gaps)
  print(f"\nTotal gap cycles: {total_gap_cycles:,} ({100 * total_gap_cycles / total_cycles:.1f}% of trace)")
  
  # Categorize gaps by cause (sample top 500 gaps for speed)
  gap_causes = defaultdict(int)
  for start, end, duration in gaps_sorted[:500]:
    causes = get_gap_causes(start, end)
    if 'barrier' in causes:
      gap_causes['BARRIER'] += duration
    if 'waitcnt' in causes:
      gap_causes['WAITCNT'] += duration
    if 'global_load' in causes:
      gap_causes['GLOBAL_LOAD'] += duration
    if 'lds' in causes:
      gap_causes['LDS'] += duration
    if not causes:
      gap_causes['OTHER'] += duration
  
  print(f"\nGap cycles by cause (from top 500 gaps):")
  for cause, cycles in sorted(gap_causes.items(), key=lambda x: -x[1]):
    print(f"  {cause:<20}: {cycles:>12,} cycles")
  
  # Memory latency analysis
  print(f"\n{'=' * 80}")
  print("MEMORY OPERATION LATENCY ANALYSIS")
  print("=" * 80)
  
  high_delay_ops.sort(key=lambda x: -x[1])
  
  print(f"\nTop 20 highest latency operations:")
  print(f"{'Clk':<12} {'Delay':<8} {'Op':<20} {'Info'}")
  print("-" * 80)
  
  for clk, delay, op, info in high_delay_ops[:20]:
    print(f"{clk:<12} {delay:<8} {op:<20} {info}")
  
  # Memory operation type analysis
  print(f"\n{'=' * 80}")
  print("MEMORY OPERATION TYPE BREAKDOWN")
  print("=" * 80)
  
  print(f"\n{'Op Type':<25} {'Count':<10} {'Avg Delay':<12} {'Max Delay':<12} {'Total Delay'}")
  print("-" * 80)
  
  for op_type, stats in sorted(mem_ops_by_type.items(), key=lambda x: -x[1]['total_delay']):
    if stats['count'] > 0:
      avg_delay = stats['total_delay'] / stats['count']
      print(f"{op_type:<25} {stats['count']:<10} {avg_delay:<12.1f} {stats['max_delay']:<12} {stats['total_delay']}")
  
  # Recommendations
  print(f"\n{'=' * 80}")
  print("OPTIMIZATION RECOMMENDATIONS")
  print("=" * 80)
  
  if gap_causes.get('GLOBAL_LOAD', 0) > 1000:
    print("\n[HIGH PRIORITY] Global memory loads causing significant stalls")
    print("  - Consider using coalesced memory access patterns")
    print("  - Pre-transpose matrices if possible")
    print("  - Use wider loads (b128 instead of u16)")
  
  if gap_causes.get('BARRIER', 0) > 500:
    print("\n[MEDIUM PRIORITY] Barriers causing stalls")
    print("  - Consider double-buffering to overlap compute with memory")
    print("  - Reduce synchronization frequency")
  
  if gap_causes.get('LDS', 0) > 500:
    print("\n[MEDIUM PRIORITY] LDS operations causing stalls")
    print("  - Check for LDS bank conflicts")
    print("  - Consider LDS layout optimization")
  
  u16_loads = mem_ops_by_type.get('global_load_u16', {'count': 0, 'total_delay': 0})
  if u16_loads['count'] > 0 and u16_loads['total_delay'] / max(1, u16_loads['count']) > 500:
    print("\n[HIGH PRIORITY] Scattered u16 loads have very high latency")
    print(f"  - {u16_loads['count']} loads with avg delay {u16_loads['total_delay']/u16_loads['count']:.0f} cycles")
    print("  - This is the main bottleneck - need to use coalesced loads")
    print("  - Consider transposing B matrix or changing memory layout")
  
  # WMMA delay analysis
  wmma_stats = mem_ops_by_type.get('v_wmma', {'count': 0, 'total_delay': 0, 'max_delay': 0})
  if wmma_stats['count'] > 0:
    avg_wmma_delay = wmma_stats['total_delay'] / wmma_stats['count']
    print(f"\n[INFO] WMMA instruction statistics:")
    print(f"  - Count: {wmma_stats['count']}")
    print(f"  - Avg delay before execution: {avg_wmma_delay:.1f} cycles")
    print(f"  - Max delay: {wmma_stats['max_delay']} cycles")
    if avg_wmma_delay > 50:
      print("  - HIGH DELAY: WMMAs are waiting too long, likely for memory operations")
  
  print("\n" + "=" * 80)

if __name__ == "__main__":
  analyze_wmma_starvation_streaming()
