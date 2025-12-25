export HIP=1

PYTHONPATH=. rocprofv3 \
  --kernel-trace \
  --stats \
  --output-format csv \
  --output-directory /tmp/rocprof \
  -- python extra/gemm/asm/test.py
