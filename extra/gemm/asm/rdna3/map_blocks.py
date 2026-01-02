#!/usr/bin/env python3
"""Map basic blocks from gemm.s to the unrolled trace in cmp.s"""
import re
from pathlib import Path
from dataclasses import dataclass

@dataclass
class BasicBlock:
  label: str
  instrs: list[str]  # instructions without branches
  branch: str | None  # branch instruction if any
  branch_target: str | None  # target label

def parse_instruction(line: str) -> str | None:
  """Extract just the instruction mnemonic and operands, ignoring comments and hex"""
  line = line.strip()
  if not line or line.startswith('//') or line.startswith('#'):
    return None
  if '//' in line:
    line = line[:line.index('//')].strip()
  if line.endswith(':'):
    return None
  line = line.lstrip('\t')
  return line if line else None

def parse_gemm(path: Path) -> list[BasicBlock]:
  """Parse gemm.s into basic blocks"""
  blocks = []
  current_label = "start"
  current_instrs = []

  for line in path.read_text().splitlines():
    stripped = line.strip()
    if stripped.endswith(':') and not stripped.startswith('//'):
      if current_instrs:
        blocks.append(BasicBlock(current_label, current_instrs, None, None))
      current_label = stripped[:-1]
      current_instrs = []
    else:
      instr = parse_instruction(line)
      if instr:
        if instr.startswith('s_branch ') or instr.startswith('s_cbranch'):
          # Extract target
          parts = instr.split()
          target = parts[1] if len(parts) > 1 else None
          blocks.append(BasicBlock(current_label, current_instrs, instr, target))
          current_label = f"_fallthrough_{len(blocks)}"
          current_instrs = []
        elif instr == 's_endpgm':
          current_instrs.append(instr)
          blocks.append(BasicBlock(current_label, current_instrs, None, None))
          current_label = f"_after_end_{len(blocks)}"
          current_instrs = []
        else:
          current_instrs.append(instr)

  if current_instrs:
    blocks.append(BasicBlock(current_label, current_instrs, None, None))

  return blocks

def parse_cmp(path: Path) -> list[str]:
  """Parse cmp.s into a list of instructions"""
  instrs = []
  for line in path.read_text().splitlines():
    instr = parse_instruction(line)
    if instr:
      instrs.append(instr)
  return instrs

def match_sequence(block_instrs: list[str], trace: list[str], start: int) -> bool:
  """Check if block instructions match trace at position start"""
  if start + len(block_instrs) > len(trace):
    return False
  for i, bi in enumerate(block_instrs):
    if bi != trace[start + i]:
      return False
  return True

def find_all_occurrences(block: BasicBlock, trace: list[str]) -> list[int]:
  """Find all positions where block appears in trace"""
  if not block.instrs:
    return []
  positions = []
  for i in range(len(trace) - len(block.instrs) + 1):
    if match_sequence(block.instrs, trace, i):
      positions.append(i)
  return positions

def main():
  base = Path(__file__).parent
  gemm_path = base / "gemm.s"
  cmp_path = base / "cmp.s"
  out_path = base / "mapped.s"

  print("Parsing gemm.s...")
  blocks = parse_gemm(gemm_path)
  print(f"Found {len(blocks)} basic blocks")

  # Create label -> block mapping
  label_to_block = {b.label: b for b in blocks}

  print("Parsing cmp.s...")
  trace = parse_cmp(cmp_path)
  print(f"Found {len(trace)} instructions in trace")

  # Find all occurrences of each block
  print("\nFinding block occurrences...")
  block_positions: dict[str, list[int]] = {}
  for block in blocks:
    if block.instrs:
      positions = find_all_occurrences(block, trace)
      if positions:
        block_positions[block.label] = positions
        if len(positions) > 1:
          print(f"  {block.label}: {len(positions)} occurrences")

  # Now walk through trace and emit mapped output
  print("\nGenerating mapped output...")
  output_lines = []
  output_lines.append("// Fully unrolled assembly with mapped basic blocks")
  output_lines.append(f"// Original blocks: {len(blocks)}")
  output_lines.append(f"// Trace instructions: {len(trace)}")
  output_lines.append("")

  trace_pos = 0
  label_counter: dict[str, int] = {}

  while trace_pos < len(trace):
    # Find which block matches at this position
    matched_block = None
    for block in blocks:
      if block.instrs and match_sequence(block.instrs, trace, trace_pos):
        matched_block = block
        break

    if matched_block:
      # Generate label
      label_counter[matched_block.label] = label_counter.get(matched_block.label, 0) + 1
      count = label_counter[matched_block.label]
      if count == 1:
        new_label = matched_block.label
      else:
        new_label = f"{matched_block.label}_iter{count}"

      output_lines.append(f"\n{new_label}:  // trace [{trace_pos+1}:{trace_pos+len(matched_block.instrs)}]")

      # Emit instructions
      for instr in matched_block.instrs:
        output_lines.append(f"\t{instr}")

      # Handle branch
      if matched_block.branch:
        output_lines.append(f"\t// {matched_block.branch}")
        # Determine what happened: was branch taken or fell through?
        next_trace_pos = trace_pos + len(matched_block.instrs)
        if matched_block.branch_target and matched_block.branch_target in label_to_block:
          target_block = label_to_block[matched_block.branch_target]
          if target_block.instrs and next_trace_pos < len(trace):
            if match_sequence(target_block.instrs, trace, next_trace_pos):
              output_lines.append(f"\t// -> branch TAKEN to {matched_block.branch_target}")
            else:
              output_lines.append(f"\t// -> branch NOT TAKEN (fell through)")

      trace_pos += len(matched_block.instrs)
    else:
      # No block matched - emit single instruction
      output_lines.append(f"\t{trace[trace_pos]}  // unmatched @ {trace_pos+1}")
      trace_pos += 1

  # Write output
  with open(out_path, 'w') as f:
    f.write('\n'.join(output_lines))

  print(f"\nWrote mapped output to {out_path}")
  print(f"Total labels generated: {sum(label_counter.values())}")

  # Summary of loop iterations
  print("\nLoop iterations detected:")
  for label, count in sorted(label_counter.items(), key=lambda x: -x[1]):
    if count > 1:
      print(f"  {label}: {count}x")

if __name__ == "__main__":
  main()
