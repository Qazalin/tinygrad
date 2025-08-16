#!/bin/bash

AMD_LLVM=1 FORWARD_ONLY=1 CI=1 PYTHONPATH=. MOCKGPU=1 AMD=1 python -m pytest -n=auto test/test_ops.py test/test_dtype.py test/test_dtype_alu.py test/test_linearizer.py test/test_randomness.py test/test_jit.py test/test_graph.py test/test_multitensor.py test/test_hcq.py --durations=20
