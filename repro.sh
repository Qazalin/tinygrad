#!/usr/bin/env bash
set -u

DEV=AMD python extra/gemm/rdna4_asm_matmul.py || true

DEV=AMD python extra/gemm/rdna4_asm_matmul.py &
p1=$!

# at this point the GPU is unusable unless you reboot
DEV=AMD python test/test_tiny.py TestTiny.test_plus

# note: this seems to take the machine down.
sudo lsof /tmp/am_0000:83:00.0.lock &

wait "$p1"
