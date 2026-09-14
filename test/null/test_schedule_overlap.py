import random, unittest, weakref
from unittest.mock import patch
from tinygrad import dtypes
from tinygrad.uop.ops import UOp, Ops, ProgramInfo, KernelInfo
from tinygrad.schedule.allreduce import _allreduce_view
from tinygrad.schedule.overlap import overlap_copies
from tinygrad.renderer import Estimates
from tinygrad.device import DepsTracker

def buf(device="NULL", size=16): return UOp.new_buffer(device,size,dtypes.float32)
def compute(name, out, *ins, ops=1000000000):
  sink = UOp.sink(arg=KernelInfo(name,estimates=Estimates(ops=ops,mem=1)))
  prg = UOp(Ops.PROGRAM,src=(sink,),arg=ProgramInfo(globals=tuple(range(1+len(ins))),outs=(0,),ins=tuple(range(1,1+len(ins)))))
  return prg.call(out,*ins)
def copy(out, inp): return UOp(Ops.COPY,src=(inp,),arg=out.device).call(out,inp)

class TestScheduleOverlap(unittest.TestCase):
  def schedule(self, *calls):
    ret = overlap_copies(UOp(Ops.LINEAR,src=calls)).src
    self.assertCountEqual(ret,calls)
    return ret

  def test_independent_compute_covers_copy_wait(self):
    x,y,z,p,q = [buf() for _ in range(5)]
    c = copy(y,x)
    prep, reduce, fa = compute("prep",p,x),compute("reduce",z,y),compute("fa",q,p)
    self.assertEqual(self.schedule(c,prep,reduce,fa),(c,prep,fa,reduce))

  def test_dependent_compute_cannot_pass_reducer(self):
    x,y,z,w = [buf() for _ in range(4)]
    calls = (copy(y,x),compute("reduce",z,y),compute("consumer",w,z))
    self.assertEqual(self.schedule(*calls),calls)

  def test_old_copy_wait_already_covered_by_prep(self):
    x,q,y,z,p,w = [buf() for _ in range(6)]
    saved,collective = copy(q,x),copy(y,x)
    prep = compute("prep",p,q)
    reducer,fa = compute("reduce",z,y),compute("fa",w,p,q)
    self.assertEqual(self.schedule(saved,prep,collective,reducer,fa),(saved,prep,collective,fa,reducer))

  def test_deferral_is_bounded(self):
    x,y,z,a,b = [buf() for _ in range(5)]
    c,r,f,g = copy(y,x),compute("reduce",z,y),compute("first",a,x),compute("second",b,x)
    self.assertEqual(self.schedule(c,r,f,g),(c,f,r,g))

  def test_prep_chain_is_not_pulled_forward(self):
    x,y,z,p,q = [buf() for _ in range(5)]
    c,r = copy(y,x),compute("reduce",z,y)
    prep,fa = compute("prep",p,x,ops=0),compute("fa",q,p)
    self.assertEqual(self.schedule(c,r,prep,fa),(c,r,prep,fa))

  def test_unknown_cost_chain_is_bounded(self):
    x,y,z = [buf() for _ in range(3)]
    c,r = copy(y,x),compute("reduce",z,y)
    work = [compute(f"work_{i}",buf(),x,ops=0) for i in range(10)]
    self.assertEqual(self.schedule(c,r,*work),(c,r,*work))

  def test_unrelated_copies_are_not_pulled_ahead(self):
    x,y,z,w = [buf() for _ in range(4)]
    p,f,c = compute("producer",y,x),compute("independent",w,x),copy(z,y)
    self.assertEqual(self.schedule(p,f,c),(p,f,c))

  def test_war_and_waw(self):
    x,y,z,w = [buf() for _ in range(4)]
    c,r,overwrite,overwrite_again = copy(y,x),compute("reduce",z,y),compute("overwrite",y,w),compute("overwrite_again",y,x)
    ret = self.schedule(c,r,overwrite,overwrite_again)
    self.assertLess(ret.index(r),ret.index(overwrite))
    self.assertLess(ret.index(overwrite),ret.index(overwrite_again))

  def test_overlapping_physical_slices_alias(self):
    x,y,z = buf(),buf(),buf()
    c = copy(_allreduce_view(y,0,8),_allreduce_view(x,0,8))
    r = compute("reduce",z,_allreduce_view(y,0,8))
    overwrite = compute("overwrite",_allreduce_view(y,4,12),x)
    self.assertEqual(self.schedule(c,r,overwrite),(c,r,overwrite))

  def test_disjoint_physical_slices_can_overlap(self):
    x,y,z = buf(),buf(),buf()
    c = copy(_allreduce_view(y,0,8),_allreduce_view(x,0,8))
    r = compute("reduce",z,_allreduce_view(y,0,8))
    other = compute("other",_allreduce_view(y,8,16),x)
    self.assertEqual(self.schedule(c,r,other),(c,other,r))

  def test_distinct_uops_wrapping_same_storage_alias(self):
    x,y,z = buf(),buf(),buf()
    alias = UOp.from_buffer(y.arg.buffer.view(8,dtypes.float32,0))
    c,r,w = copy(y,x),compute("reduce",z,y),compute("overwrite",alias,x)
    self.assertEqual(self.schedule(c,r,w),(c,r,w))

  def test_multibuffer_and_selected_lane_alias(self):
    x,y = buf(("NULL","NULL:1")),buf(("NULL","NULL:1"))
    z = buf()
    c = copy(y,x)
    r = compute("reduce",z,y.mselect(0))
    overwrite = compute("overwrite",y,x)
    self.assertEqual(self.schedule(c,r,overwrite),(c,r,overwrite))

  def test_synthetic_storage_identities_stay_alive(self):
    x,y,z,w = [buf(("NULL","NULL:1")).param_like(i) for i in range(4)]
    refs = []
    access = DepsTracker.access_resources
    def checked_access(tracker, regions, writes, index):
      self.assertTrue(all(r() is not None for r in refs))
      refs.extend(weakref.ref(r.base) for r in regions)
      return access(tracker,regions,writes,index)
    with patch.object(DepsTracker,"access_resources",checked_access):
      self.schedule(copy(y,x),compute("reduce",z,y),compute("independent",w,x))

  def test_selected_reshaped_slice_keeps_lane_alias(self):
    x,y = buf(("NULL","NULL:1")),buf(("NULL","NULL:1"))
    z = buf()
    view = _allreduce_view(y.reshape((4,4)),0,8).mselect(0)
    c = copy(view,_allreduce_view(x.mselect(0),0,8))
    r = compute("reduce",z,view)
    independent = compute("other",buf(),x)
    self.assertEqual(self.schedule(c,r,independent),(c,independent,r))

  def test_unknown_inner_offset_is_not_narrowed_by_outer_slice(self):
    x,y,z = buf(),buf(),buf()
    start = UOp.variable("offset",0,8)
    dynamic = _allreduce_view(y,start,start+8)
    c = copy(_allreduce_view(dynamic,0,4),_allreduce_view(x,0,4))
    r = compute("reduce",z,_allreduce_view(y,8,12))
    overwrite = compute("overwrite",_allreduce_view(y,8,12),x)
    self.assertEqual(self.schedule(c,r,overwrite),(c,r,overwrite))

  def test_unknown_call_is_barrier(self):
    x,y,z,w = [buf() for _ in range(4)]
    c,r = copy(y,x),compute("reduce",z,y)
    opaque = UOp(Ops.CUSTOM_FUNCTION,arg="opaque").call()
    f = compute("independent",w,x)
    self.assertEqual(self.schedule(c,r,opaque,f),(c,r,opaque,f))

  def test_no_copy_is_unchanged(self):
    x,y,z = buf(),buf(),buf()
    calls = (compute("a",y,x),compute("b",z,x))
    self.assertEqual(self.schedule(*calls),calls)

  def test_randomized_mutating_calls_preserve_results(self):
    for seed in range(20):
      rng = random.Random(seed)
      buffers = [buf() for _ in range(8)]
      calls = []
      for i in range(100):
        out,a,b = rng.sample(buffers,3)
        calls.append(copy(out,a) if rng.randrange(3)==0 else compute(f"compute_{i}",out,a,b))
      def evaluate(ordered):
        values = {b:i for i,b in enumerate(buffers)}
        for c in ordered:
          dst,*ins = c.src[1:]
          values[dst] = sum(values[b] for b in ins) % 1000003
        return values
      self.assertEqual(evaluate(calls),evaluate(self.schedule(*calls)))

  def test_explicit_after_is_barrier(self):
    x,y,z,w = [buf() for _ in range(4)]
    c,r = copy(y,x),compute("reduce",z,y)
    ordered = compute("explicit",w,x.after(r))
    later = compute("later",buf(),x)
    self.assertEqual(self.schedule(c,r,ordered,later),(c,r,ordered,later))

  def test_randomized_bound_views_preserve_results(self):
    for seed in range(10):
      rng = random.Random(seed)
      base = buf(size=32).arg.buffer
      views = [UOp.from_buffer(base.view(8,dtypes.float32,4*i)) for i in range(25)]
      calls = [copy(*rng.sample(views,2)) for _ in range(30)]
      calls += [compute(f"op_{i}",*rng.sample(views,3),ops=0) for i in range(30)]
      rng.shuffle(calls)
      def evaluate(ordered):
        data = list(range(32))
        for c in ordered:
          dst,*src = [a.arg.buffer.offset//4 for a in c.src[1:]]
          values = [sum(data[s+j] for s in src)%1000003 for j in range(8)]
          data[dst:dst+8] = values
        return data
      self.assertEqual(evaluate(calls),evaluate(self.schedule(*calls)))

if __name__ == "__main__": unittest.main()
