from tinygrad.uop.ops import UOp, Ops, dtypes
from tinygrad.shape.shapetracker import ShapeTracker
from tinygrad.shape.view import View
from tinygrad import Device

ast = UOp(Ops.SINK, dtypes.void, arg=None, src=(
  UOp(Ops.STORE, dtypes.void, arg=None, src=(
    UOp(Ops.VIEW, dtypes.float.ptr(1638400), arg=ShapeTracker(views=(View(shape=(1, 512, 1, 32, 10, 10, 1, 1), strides=(0, 3200, 0, 100, 10, 1, 0, 0), offset=0, mask=None, contiguous=True),)), src=(
      UOp(Ops.DEFINE_GLOBAL, dtypes.float.ptr(1638400), arg=0, src=()),)),
    UOp(Ops.REDUCE_AXIS, dtypes.float, arg=(Ops.ADD, (6, 7)), src=(
      UOp(Ops.LOAD, dtypes.float, arg=None, src=(
        UOp(Ops.VIEW, dtypes.float.ptr(9437184), arg=ShapeTracker(views=(View(shape=(512, 32, 3, 11, 3, 11), strides=(18432, 576, 3, 72, 1, 9), offset=0, mask=((0, 512), (0, 32), (0, 3), (0, 8), (0, 3), (0, 8)), contiguous=False), View(shape=(512, 32, 40, 40), strides=(34848, 1089, 33, 1), offset=0, mask=((0, 512), (0, 32), (0, 33), (0, 33)), contiguous=False), View(shape=(1, 512, 1, 32, 10, 10, 4, 4), strides=(0, 51200, 0, 1600, 40, 1, 400, 10), offset=0, mask=None, contiguous=False))), src=(
          UOp(Ops.DEFINE_GLOBAL, dtypes.float.ptr(9437184), arg=1, src=()),)),)),)),)),))

from tinygrad.engine.realize import get_program
prg = get_program(ast, Device[Device.DEFAULT].renderer)
