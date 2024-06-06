import subprocess, inspect, difflib
from tqdm import tqdm
from tinygrad.helpers import colored

def get_src(limit:int, offset:int):
  import pickle
  from tinygrad.helpers import db_connection, VERSION
  from tinygrad.codegen.linearizer import Linearizer
  conn = db_connection()
  cur = conn.cursor()
  cur.execute(f"SELECT val FROM 'process_replay_{VERSION}' LIMIT ? OFFSET ?", (limit, offset))
  for row in cur.fetchall():
    ast, applied_opts = pickle.loads(row[0])
    k = Linearizer(*ast)
    for opt in applied_opts: k.apply_opt(opt)
    print(k.linearize().to_program().src)
  conn.close()

def get_program(branch, limit, offset) -> str:
  code = \
f"""
import pickle
from tinygrad.helpers import db_connection, VERSION
from tinygrad.codegen.linearizer import Linearizer
conn = db_connection()
cur = conn.cursor()
cur.execute(f"SELECT val FROM 'process_replay_{VERSION}' LIMIT ? OFFSET ?", ({limit}, {offset}))
for row in cur.fetchall():
  ast, applied_opts = pickle.loads(row[0])
  k = Linearizer(*ast)
  for opt in applied_opts: k.apply_opt(opt)
  print(k.linearize().to_program().src)
conn.close()
"""
  subprocess.run(["git", "checkout", branch], check=True, capture_output=True)
  result = subprocess.run(["python3", "-c", code], capture_output=True, text=True)
  return result.stdout

def cleanup():
  from tinygrad.helpers import db_connection, VERSION
  conn = db_connection()
  cur = conn.cursor()
  cur.execute(f"drop table 'process_replay_{VERSION}'")
#cleanup()

from tinygrad.helpers import db_connection, VERSION
conn = db_connection()
cur = conn.cursor()
row_count: int = cur.execute(f"select count(*) from 'process_replay_{VERSION}'").fetchone()[0]
conn.close()
PAGE_SIZE = 100
for offset in tqdm(range(0, row_count, PAGE_SIZE)):
  master_src = get_program("master", PAGE_SIZE, offset)
  feat_src = get_program("faster_process_replay", PAGE_SIZE, offset)
  try: assert master_src == feat_src
  except AssertionError as e:
    print(f"FAILED AT OFFSET {offset}")
    diff = list(difflib.unified_diff(master_src.splitlines(), feat_src.splitlines()))
    for line in diff:
      color = "red" if line.startswith("- ") else "green" if line.startswith("+ ") else None
      print(colored(line, color))
    raise e
