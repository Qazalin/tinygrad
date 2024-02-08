import sys
import pandas as pd
from datascroller import scroll

f16 = pd.read_csv(f"/tmp/{sys.argv[1]}.csv")
scroll(f16)
