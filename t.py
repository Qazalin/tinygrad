import functools
import time
from tqdm import tqdm

from tinygrad import Device, GlobalCounters, Tensor, TinyJit, dtypes
from tinygrad.helpers import getenv, BEAM, WINO, Context
from tinygrad.nn.state import get_parameters, get_state_dict, safe_load
from tinygrad.nn.optim import LARS, SGD, OptimizerGroup

from extra.lr_scheduler import LRSchedulerGroup
from examples.mlperf.helpers import load_training_state

from extra.models import resnet
from examples.mlperf.dataloader import batch_load_resnet
from extra.datasets.imagenet import get_train_files, get_val_files
from examples.mlperf.lr_schedulers import PolynomialDecayWithWarmup
from examples.mlperf.initializers import Conv2dHeNormal, Linear
from examples.hlb_cifar10 import UnsyncedBatchNorm

config = {}
seed = config["seed"] = getenv("SEED", 42)
Tensor.manual_seed(seed)  # seed for weight initialization

GPUS = config["GPUS"] = [f"{Device.DEFAULT}:{i}" for i in range(getenv("GPUS", 1))]
print(f"Training on {GPUS}")
for x in GPUS: Device[x]

# ** model definition and initializers **
num_classes = 1000
resnet.Conv2d = Conv2dHeNormal
resnet.Linear = Linear
if not getenv("SYNCBN"): resnet.BatchNorm = functools.partial(UnsyncedBatchNorm, num_devices=len(GPUS))
model = resnet.ResNet50(num_classes)

# shard weights and initialize in order
for k, x in get_state_dict(model).items():
  if not getenv("SYNCBN") and ("running_mean" in k or "running_var" in k):
    x.realize().shard_(GPUS, axis=0)
  else:
    x.realize().to_(GPUS)
parameters = get_parameters(model)

# ** hyperparameters **
epochs            = config["epochs"]            = getenv("EPOCHS", 41)
BS                = config["BS"]                = getenv("BS", 104 * len(GPUS))  # fp32 GPUS<=6 7900xtx can fit BS=112
EVAL_BS           = config["EVAL_BS"]           = getenv("EVAL_BS", BS)
base_lr           = config["base_lr"]           = getenv("LR", 8.5 * (BS/2048))
lr_warmup_epochs  = config["lr_warmup_epochs"]  = getenv("WARMUP_EPOCHS", 5)
decay             = config["decay"]             = getenv("DECAY", 2e-4)

loss_scaler       = config["LOSS_SCALER"]       = getenv("LOSS_SCALER", 128.0 if dtypes.default_float == dtypes.float16 else 1.0)

target, achieved  = getenv("TARGET", 0.759), False
eval_start_epoch  = getenv("EVAL_START_EPOCH", 0)
eval_epochs       = getenv("EVAL_EPOCHS", 1)

steps_in_train_epoch  = config["steps_in_train_epoch"]  = (len(get_train_files()) // BS)
steps_in_val_epoch    = config["steps_in_val_epoch"]    = (len(get_val_files()) // EVAL_BS)

config["DEFAULT_FLOAT"] = dtypes.default_float.name
config["BEAM"]    = BEAM.value
config["WINO"]    = WINO.value
config["SYNCBN"]  = getenv("SYNCBN")

# ** Optimizer **
skip_list = [v for k, v in get_state_dict(model).items() if "bn" in k or "bias" in k or "downsample.1" in k]
parameters = [x for x in parameters if x not in set(skip_list)]
optimizer = LARS(parameters, base_lr, momentum=.9, weight_decay=decay)
optimizer_skip = SGD(skip_list, base_lr, momentum=.9, weight_decay=0.0, classic=True)
optimizer_group = OptimizerGroup(optimizer, optimizer_skip)

# ** LR scheduler **
scheduler = PolynomialDecayWithWarmup(optimizer, initial_lr=base_lr, end_lr=1e-4,
                                      train_steps=epochs * steps_in_train_epoch,
                                      warmup=lr_warmup_epochs * steps_in_train_epoch)
scheduler_skip = PolynomialDecayWithWarmup(optimizer_skip, initial_lr=base_lr, end_lr=1e-4,
                                           train_steps=epochs * steps_in_train_epoch,
                                           warmup=lr_warmup_epochs * steps_in_train_epoch)
scheduler_group = LRSchedulerGroup(scheduler, scheduler_skip)
print(f"training with batch size {BS} for {epochs} epochs")

# ** resume from checkpointing **
start_epoch = 0
if ckpt:=getenv("RESUME", ""):
  load_training_state(model, optimizer_group, scheduler_group, safe_load(ckpt))
  start_epoch = int(scheduler.epoch_counter.numpy().item() / steps_in_train_epoch)
  print(f"resuming from {ckpt} at epoch {start_epoch}")

# ** init wandb **
WANDB = getenv("WANDB")
if WANDB:
  import wandb
  wandb_args = {"id": wandb_id, "resume": "must"} if (wandb_id := getenv("WANDB_RESUME", "")) else {}
  wandb.init(config=config, **wandb_args)

BENCHMARK = getenv("BENCHMARK")

# ** jitted steps **
input_mean = Tensor([123.68, 116.78, 103.94], device=GPUS, dtype=dtypes.float32).reshape(1, -1, 1, 1)
# mlperf reference resnet does not divide by input_std for some reason
# input_std = Tensor([0.229, 0.224, 0.225], device=GPUS, dtype=dtypes.float32).reshape(1, -1, 1, 1)
def normalize(x): return (x.permute([0, 3, 1, 2]) - input_mean).cast(dtypes.default_float)
@TinyJit
def train_step(X, Y):
  with Context(BEAM=getenv("TRAIN_BEAM", BEAM.value)):
    optimizer_group.zero_grad()
    X = normalize(X)
    out = model.forward(X)
    loss = out.cast(dtypes.float32).sparse_categorical_crossentropy(Y, label_smoothing=0.1)
    top_1 = (out.argmax(-1) == Y).sum()
    (loss * loss_scaler).backward()
    for t in optimizer_group.params: t.grad = t.grad.contiguous() / loss_scaler
    # x for o in self.optimizers for x in o._step()
    o = optimizer_group.optimizers[0]
    sched = o.sched_step()
    print(len(sched))
    #[extra + self.params + self.buffers if extra is not None else self.params + self.buffers]

def data_get(it):
  x, y, cookie = next(it)
  return x.shard(GPUS, axis=0).realize(), Tensor(y, requires_grad=False).shard(GPUS, axis=0), cookie

# ** epoch loop **
step_times = []
e = 1
# ** train loop **
Tensor.training = True
batch_loader = batch_load_resnet(batch_size=BS, val=False, shuffle=True, seed=seed*epochs + e)
it = iter(tqdm(batch_loader, total=steps_in_train_epoch, desc=f"epoch {e}", disable=BENCHMARK))
i, proc = 0, data_get(it)
st = time.perf_counter()
while proc is not None:
  GlobalCounters.reset()
  train_step(proc[0], proc[1]), proc[2]
  break
