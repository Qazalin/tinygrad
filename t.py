import pandas as pd
import csv

path = "/Users/qazal/test.csv"

# pandas version
df = pd.read_csv(path)
df = df[["ID", "49"]]
d_pandas = dict(zip(df["ID"], df[df.columns[1]]))

# csv version

def try_number(x:str) -> int|float|str:
  try: return int(x)
  except ValueError:
    try: return int(f) if (f:=float(x)).is_integer() else f
    except ValueError: return x

import csv
out:dict[str, int|float|str] = {}
with open(path) as f:
  reader = csv.DictReader(f)
  for row in reader: out[row["\ufeffID"]] = try_number(row["49"])
