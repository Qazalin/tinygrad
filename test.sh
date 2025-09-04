sudo nsys profile \
  --trace=cuda,cublas,cudnn,osrt,nvtx \
  --sample=cpu \
  --cpuctxsw=process-tree \
  --gpu-metrics-devices=all \
  --force-overwrite=true \
  -o gpt-oss \
  ./venv/bin/python t.py
