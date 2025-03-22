import pickle
data = pickle.load(open("/Users/qazal/Desktop/test.pickle", "rb"))
print(data["device_traces"][0][0]["stream"])
