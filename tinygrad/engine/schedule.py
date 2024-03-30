from typing import List, Optional, Set

from tinygrad.lazy import LazyBuffer
from tinygrad.ops import ScheduleItem

def create_schedule(outs:List[LazyBuffer], seen:Optional[Set[LazyBuffer]]=None) -> List[ScheduleItem]: return []
