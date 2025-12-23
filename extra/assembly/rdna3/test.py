import functools
from types import SimpleNamespace
from dataclasses import dataclass
from tinygrad.uop.ops import UOp, Ops

def sgpr(i:int): return i

@dataclass(frozen=True)
class field:
  lo:int
  hi:int

  @property
  def mask(self) -> int: return ((1 << (self.hi - self.lo + 1)) - 1) << self.lo

  def get(self, word:int) -> int: return (word & self.mask) >> self.lo
  def prep(self, value:int) -> int: return (value << self.lo) & self.mask

@dataclass(frozen=True)
class PackTrait:
  @classmethod
  @functools.cache
  def fields(cls) -> tuple[tuple[str, field], ...]: return tuple([(k,v) for k,v in cls.__dict__.items() if isinstance(v, field)][1:])

  @classmethod
  def pack(cls, *args:tuple[int, ...]) -> int:
    ret = cls.encoding.prep(cls.ENC)
    for ((_,f), v) in zip(cls.fields(), args): ret |= f.prep(v)
    return ret

  @classmethod
  def unpack(cls, word:int): return SimpleNamespace(**{k:f.get(word) for k,f in cls.fields()})

class SOPC(PackTrait):
  ENC = 0b10_1111110
  encoding = field(23, 31)
  op       = field(16, 22)
  ssrc1    = field(8, 15)
  ssrc0    = field(0, 7)

  def s_cmp_eq_i32(*args): return SOPC.pack(0, *args)
  def s_cmp_lg_i32(*args): return SOPC.pack(1, *args)

inst = SOPC.s_cmp_lg_i32(sgpr(4), sgpr(2))
sopc = SOPC.unpack(inst)
print(sopc)
