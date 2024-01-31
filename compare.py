import numpy as np

remu = np.fromfile("/tmp/HIP.pkl")
metal = np.fromfile("/tmp/METAL.pkl")
np.testing.assert_allclose(remu, metal, atol=1e-4, rtol=1e-2)
