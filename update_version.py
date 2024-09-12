import subprocess, json

out = int(json.loads(subprocess.check_output(["curl", "https://pypi.org/pypi/tinygrad-tools/json"]).decode("utf-8"))["info"]["release_url"].split("/")[-2].split(".")[-1])
new_version = f"0.9.{out+1}"
with open("setup.py", "r") as f: content = f.read()
prev_version = [x for x in content.splitlines() if "version" in x][0].split("=")[-1].split(",")[0].replace("'", "")
new_content = content.replace(prev_version, new_version).replace("name='tinygrad'", "name='tinygrad-tools'")
with open("setup.py", "w") as f: f.write(new_content)
