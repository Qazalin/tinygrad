import pandas as pd
logs = open("k0").read().split("\n")
all_data = []
for log in logs[:-1]:
  parts = log.split(" ")
  data = {}
  for part in parts:
    name, value = part.split("=")
    data[name] = value
  all_data.append(data)

df = pd.DataFrame(all_data).drop_duplicates()
print(df)
