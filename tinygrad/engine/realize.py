from typing import List
from tinygrad.features.graph import save_schedule_graph
from tinygrad.helpers import getenv
from tinygrad.ops import ScheduleItem
from tinygrad.engine.commandqueue import CommandQueue

def run_schedule(schedule:List[ScheduleItem]):
  if getenv("GRAPHSCHEDULE"): save_schedule_graph(schedule)
  CommandQueue(schedule)()
