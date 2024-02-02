import pandas as pd


vals = open("./k0").read().splitlines()
data = []
for val_pack in vals:
  val_pack = val_pack.split(" ")[:-1]
  vals = [v.split("=") for v in val_pack]
  data.append({k:float(v) for k,v in vals})

df = pd.DataFrame(data)
df = df.loc[((df["tx"] == 1) | (df["tx"] == 17)) & (df["ele"] == 4)]
print(df)
