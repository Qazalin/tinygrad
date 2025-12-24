import functools
from types import SimpleNamespace
from dataclasses import dataclass
from typing import Callable, Generic, Protocol, TypeVar, runtime_checkable

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

T = TypeVar("T")

@runtime_checkable
class EncodingTrait(Protocol[T]):
  enc: Callable[[T], int]
  dec: Callable[[int], T]

@dataclass(frozen=True)
class field(Generic[T]):
  b:bits
  e:EncodingTrait[T]
  def get(self, word:int) -> T: return self.e.dec(self.b.get(word))
  def prep(self, v:T) -> int: return self.b.prep(self.e.enc(v))

@dataclass(frozen=True)
class PackTrait:
  @classmethod
  @functools.cache
  def fields(cls) -> tuple[tuple[str, field], ...]: return tuple([(k,v) for k,v in cls.__dict__.items() if isinstance(v, field)])

  @classmethod
  def pack(cls, *args:tuple[int, ...]) -> int:
    word = 0
    for ((_, f), v) in zip(cls.fields(), args):
      word |= f.prep(v)
    return word

  @classmethod
  def unpack(cls, word:int): return SimpleNamespace(**{k:f.get(word) for k,f in cls.fields()})

# ** register types

@dataclass(frozen=True)
class SGPR: idx:int

SGPR_COUNT = 128

class _SGPR:
  def __init__(self): self.sgprs = [SGPR(i) for i in range(SGPR_COUNT)]
  def __getitem__(self, s): return self.sgprs.__getitem__(s)

s = _SGPR()

# ** instruction operands

class Id(EncodingTrait):
  @staticmethod
  def dec(v): return v
  @staticmethod
  def enc(v): return v

class SSRC(EncodingTrait):
  @staticmethod
  def dec(v):
    if 0 <= v <= 105: return s[v]
    raise Exception(f"todo {v}")
  @staticmethod
  def enc(v):
    if isinstance(v, SGPR): return v.idx
    raise Exception(f"todo {v}")

class Opcode(EncodingTrait):
  def __init__(self, ty): self.ty = ty
  def dec(self, v): return self.ty(v)
  def enc(self, v): return int(v)
