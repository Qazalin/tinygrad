import unittest
from test.test_ops import TestOps, helper_test_op

helper_test_op([(45,65), (45,65), (45,65)], lambda x,y,z: x+y+z)
