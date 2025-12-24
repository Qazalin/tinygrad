from types import SimpleNamespace
from dataclasses import dataclass, field

# ** byte packing helper

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

# ** register types

@dataclass(frozen=True)
class SGPR: idx:int

SGPR_COUNT = 128

class _SGPR:
  def __init__(self): self.sgprs = [SGPR(i) for i in range(SGPR_COUNT)]
  def __getitem__(self, s): return self.sgprs.__getitem__(s)

s = _SGPR()

# ** instruction operands

def encode_field(name:str, v) -> int:
  if name.startswith("ssrc"):
    if isinstance(v, SGPR): return v.idx
  if name in {"op", "encoding"}: return v
  raise ValueError(f"no encoding for field {name} with value {v}")

def decode_field(name:str, v:int): raise Exception("todo!")

@dataclass(frozen=True)
class PackTrait:
  fields:dict[str, bits] = field(default_factory=dict)
  def __init_subclass__(cls):
    super().__init_subclass__()
    cls.fields = {k:v for k,v in cls.__dict__.items() if isinstance(v, bits)}

  @classmethod
  def pack(cls, *args, **kwargs) -> int:
    if (nargs:=len(args)+len(kwargs)) != len(cls.fields):
      raise TypeError(f"wrong number of arguments for {cls.__name__}, expected {len(cls.fields)}, got {nargs}")
    word = 0
    for n,v in [*zip(cls.fields, args), *kwargs.items()]:
      word |= cls.fields[n].prep(encode_field(n, v))
    return word

  @classmethod
  def unpack(cls, word:int): return SimpleNamespace(**{k:decode_field(k, f.get(word)) for k,f in cls.fields.items()})
