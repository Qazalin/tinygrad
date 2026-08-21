# diff two jsonl outputs from DEBUG=3 python -m tinygrad.viz.cli --json
import argparse, json, itertools
from collections import Counter, defaultdict
from tinygrad.helpers import DEBUG, colored

def load(path):
  with open(path) as f:
    records = [json.loads(x) for x in f]
    asts = {a["ref"]:b["value"] for a,b in itertools.pairwise(records) if "name" in a and "value" in b and a.get("ref") is not None}
  ret:dict[str, dict[str, Counter]] = defaultdict(lambda: defaultdict(Counter))
  for x in records:
    if x.get("ref") in asts: ret[x["device"]][asts[x["ref"]]][x["name"]] += 1
  return ret

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("a")
  parser.add_argument("b")
  args = parser.parse_args()
  a, b = load(args.a), load(args.b)
  for device in sorted(a.keys() | b.keys()):
    print(device)
    for ast in sorted(a.get(device, {}).keys() | b.get(device, {}).keys()):
      if (a_runs:=a.get(device, {}).get(ast, {})) == (b_runs:=b.get(device, {}).get(ast, {})): continue
      for name,count in sorted(a_runs.items()): print(colored(f"- {name} {count}", "red"))
      for name,count in sorted(b_runs.items()): print(colored(f"+ {name} {count}", "green"))
      if DEBUG >= 3: print(ast, "\n")
