import pandas as pd
import plotly.express as px

df = pd.read_csv("/tmp/bert.csv")
df = df.sort_values(by="time_ms", ascending=False)
print(df.iloc[0]["code"])
