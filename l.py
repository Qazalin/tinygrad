import numpy as np

x = np.load(open("remu.bin", "rb"))
y = np.load(open("torch.bin", "rb"))
d = ~np.isclose(x, y, rtol=1e-4)
print(x[d])
print(y[d])
