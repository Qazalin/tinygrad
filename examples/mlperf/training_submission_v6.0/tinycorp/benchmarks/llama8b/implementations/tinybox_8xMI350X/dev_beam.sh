#!/usr/bin/env bash

export PYTHONPATH="."
export DEV=${DEV:-AMD}
export EMULATE="AMD_CDNA4"
export CHECK_OOB=0
export REWRITE_STACK_LIMIT=5000000 HCQDEV_WAIT_TIMEOUT_MS=240000
export DEVICE_IN_FUNCTION_BUG=1

export DEBUG=${DEBUG:-2}
export HK_FLASH_ATTENTION=${HK_FLASH_ATTENTION:-1}
export ALL2ALL=${ALL2ALL:-1}
export USE_ATOMICS=${USE_ATOMICS:-1}
export ASM_GEMM=${ASM_GEMM:-1}
export WQKV=${WQKV:-1}
export MASTER_WEIGHTS=${MASTER_WEIGHTS:-1}
export FP8=${FP8:-1}

export DEFAULT_FLOAT="bfloat16" OPTIM_DTYPE="bfloat16"
export DP=${DP:-8} MP=${MP:-1} BS=${BS:-8} EVAL_BS=${EVAL_BS:-8} GRADIENT_ACC_STEPS=${GRADIENT_ACC_STEPS:-4}
export GBS=$((BS * GRADIENT_ACC_STEPS))

export MODEL="llama3"
export BASEDIR="/raid/datasets/c4-8b/"
export SMALL=1
export LLAMA3_SIZE=${LLAMA3_SIZE:-"8B"}
export EVAL_TARGET=3.3 EVAL_FREQ=12288
export LR="1e-3" END_LR="1e-4" WARMUP_SAMPLES=4096 MAX_STEPS=1200000
export WARMUP_STEPS=$((WARMUP_SAMPLES / GBS))
export SAMPLES=$((MAX_STEPS * GBS))
export SEQLEN=${SEQLEN:-8192}

export SEED=${SEED:-5760}
export DATA_SEED=${DATA_SEED:-5760}

export JITBEAM=${JITBEAM:-3}
export BEAM_UOPS_MAX=6000 BEAM_UPCAST_MAX=256 BEAM_LOCAL_MAX=1024 BEAM_MIN_PROGRESS=5 BEAM_PADTO=1

export FAKEDATA=1 BENCHMARK=${BENCHMARK:-10}
if [ -z "$FULL_LAYERS" ]; then
  export LLAMA_LAYERS=2
fi

# Optional ftrace for kernel tracing
if [ "${FTRACE:-0}" = "1" ]; then
  echo "Enabling ftrace..."
  sudo sh -c 'echo 0 > /sys/kernel/debug/tracing/tracing_on'
  sudo sh -c 'echo > /sys/kernel/debug/tracing/trace'
  sudo sh -c 'echo function > /sys/kernel/debug/tracing/current_tracer'
  sudo sh -c 'echo "zap_pte_range remap_pfn_range unmap_page_range" > /sys/kernel/debug/tracing/set_ftrace_filter'
  sudo sh -c 'echo 1 > /sys/kernel/debug/tracing/tracing_on'
fi

export _SHELL_START=$(python3 -c "import time; print(time.time_ns())")
python3 examples/mlperf/model_train.py
_EXIT_TIME=$(python3 -c "import os,time; print(f'{(time.time_ns() - int(os.environ[\"_SHELL_START\"]))*1e-6:6.2f} ms')")
echo "python exit: $_EXIT_TIME"

if [ "${FTRACE:-0}" = "1" ]; then
  sudo sh -c 'echo 0 > /sys/kernel/debug/tracing/tracing_on'
  echo "=== Ftrace output (python3 only, last 200 lines) ==="
  sudo cat /sys/kernel/debug/tracing/trace | grep python3 | tail -200
fi
