import functools
from types import SimpleNamespace
from dataclasses import dataclass

@dataclass(frozen=True)
class bits:
  lo:int
  hi:int

  def __class_getitem__(cls, s):
    assert isinstance(s, slice) and s.step is None and s.start is not None and s.stop is not None, f"invalid slice for bits: {s}"
    return cls(lo=s.stop, hi=s.start)

  @property
  def mask(self) -> int: return ((1 << (self.hi - self.lo + 1)) - 1) << self.lo

  def get(self, word:int) -> int: return (word & self.mask) >> self.lo
  def prep(self, value:int) -> int: return (value << self.lo) & self.mask

@dataclass(frozen=True)
class PackTrait:
  @classmethod
  @functools.cache
  def fields(cls) -> tuple[tuple[str, bits], ...]: return tuple([(k,v) for k,v in cls.__dict__.items() if isinstance(v, bits)][1:])

  @classmethod
  def pack(cls, *args:tuple[int, ...]) -> int:
    ret = cls.encoding.prep(cls.ENC)
    for ((_,f), v) in zip(cls.fields(), args): ret |= f.prep(v)
    return ret

  @classmethod
  def unpack(cls, word:int): return SimpleNamespace(**{k:f.get(word) for k,f in cls.fields()})
