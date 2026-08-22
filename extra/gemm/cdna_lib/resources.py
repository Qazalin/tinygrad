from dataclasses import dataclass

from tinygrad.helpers import round_up
from tinygrad.renderer.amd.dsl import Reg, FixedBitField
from tinygrad.runtime.autogen.amd.common import OpType

_ACCVGPR_TYPES = {OpType.OPR_ACCVGPR, OpType.OPR_SRC_ACCVGPR}
_MAYBE_ACCVGPR_TYPES = {OpType.OPR_VGPR_OR_ACCVGPR, OpType.OPR_SRC_VGPR_OR_ACCVGPR, OpType.OPR_SRC_VGPR_OR_ACCVGPR_OR_CONST}

@dataclass(frozen=True)
class KernelResources:
  regular_vgprs: int
  accvgprs: int
  referenced_sgprs: int
  accum_offset: int
  allocated_combined_vgprs: int
  descriptor_sgprs: int
  code_bytes: int
  instruction_count: int

  def one_line(self) -> str:
    return (f"vgpr={self.regular_vgprs} acc={self.accvgprs} combined={self.allocated_combined_vgprs} "
            f"sgpr_ref={self.referenced_sgprs} sgpr_desc={self.descriptor_sgprs} code={self.code_bytes}B insts={self.instruction_count}")

def scan_resources(insts) -> KernelResources:
  """Mirror tinygrad.renderer.amd.elf's typed-operand register scan without building an ELF."""
  max_vgpr = max_sgpr = max_accvgpr = 0
  for inst in insts:
    accvgpr_fields: set[str] = set()
    for opr_name, (_, _, opr_type) in inst.operands.items():
      if opr_type in _ACCVGPR_TYPES: accvgpr_fields.add(opr_name)
      elif opr_type in _MAYBE_ACCVGPR_TYPES and getattr(inst, "acc_cd", 0) == 1: accvgpr_fields.add(opr_name)

    for name, field in inst._fields:
      if isinstance(field, FixedBitField): continue
      val = getattr(inst, name)
      if not isinstance(val, Reg): continue
      if 256 <= val.offset < 512:
        used = (val.offset - 256) + val.sz
        if name in accvgpr_fields: max_accvgpr = max(max_accvgpr, used)
        else: max_vgpr = max(max_vgpr, used)
      elif val.offset < 106:
        max_sgpr = max(max_sgpr, val.offset + val.sz)

  accum_offset = round_up(max_vgpr, 4) if max_accvgpr else 0
  combined = round_up(accum_offset + max_accvgpr, 8) if max_accvgpr else round_up(max_vgpr, 8)
  # CDNA descriptor allocation includes VCC + FLAT_SCRATCH + XNACK_MASK (6 SGPRs), then rounds to 8.
  descriptor_sgprs = round_up(round_up(max_sgpr, 8) + 6, 8)
  return KernelResources(max_vgpr, max_accvgpr, max_sgpr, accum_offset, combined, descriptor_sgprs,
                         sum(x.size() for x in insts), len(insts))
