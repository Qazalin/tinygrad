var raw = null

const rect = (s) => s.getBoundingClientRect()
function createTimeline(events) {
  const g = d3.create("svg:g");
  g.append("circle").attr("cx", 0).attr("cy", 0).attr("r", 3).attr("fill", "red")
  return g;
}

async function main() {
  // fetch
  if (raw == null) raw = await (await fetch("/get_profile")).json();
  const procMap = {};
  const threadMap = {};
  const events = {};
  for (const t of raw.traceEvents) {
    if (t.ph === "M") {
      if (t.name === "process_name") {
        procMap[t.pid] = t;
        threadMap[t.pid] = {};
        events[t.pid] = [];
      }
      if (t.name === "thread_name") {
        threadMap[t.pid][t.tid] = t;
        events[t.pid][t.tid] = [];
      }
    }
    if (t.ph === "X") {
      events[t.pid][t.tid].push(t);
    }
  }
  // render
  const root = document.querySelector(".main-container");
  root.style = "display: flex; width: 100%; height: 100%"
  const lst = root.appendChild(document.createElement("div"));
  lst.style = "background: #0f1018; padding: 20px;";
  const svg = d3.select(root).append("svg").attr("width", "100%").attr("height", "100%");
  let st = null;
  let et = null;
  for (const [pid, threadEvents] of Object.entries(events)) {
    if (threadEvents.every((e) => e.length === 0)) continue;
    const procRoot = lst.appendChild(document.createElement("div"));
    const name = procRoot.appendChild(document.createElement("p"));
    name.style = "background: #0f1018; width: 100%; padding: 4px;";
    name.textContent = procMap[pid].args.name;
    for (const [tid, events] of Object.entries(threadEvents)) {
      const thread = procRoot.appendChild(document.createElement("div"));
      thread.style = "display: flex; padding: 4px;";
      const name = thread.appendChild(document.createElement("p"));
      name.textContent = threadMap[pid][tid].args.name
      const threadStart = events[0].ts;
      const threadEnd = events[events.length-1].ts;
      st = st == null ? threadStart : Math.min(st, threadStart);
      et = et == null ? threadEnd : Math.max(et, threadEnd);
    }
  }
  const width = rect(root).width-rect(lst).width;
  const x = d3.scaleLinear().domain([st, et]).range([0, width]);;
}
main();
