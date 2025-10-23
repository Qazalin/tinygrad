#!/bin/bash
#!/bin/bash
sudo CUDA=1 DEBUG=2 /usr/local/cuda/bin/ncu --force-overwrite \
  --target-processes all \
  --metrics sm__cycles_elapsed.avg,l1tex__t_sectors_pipe_lsu_mem_global_op_ld.sum,l1tex__t_requests_pipe_lsu_mem_global_op_ld.sum \
  /home/qazal/code/tinygrad/venv/bin/python t.py
