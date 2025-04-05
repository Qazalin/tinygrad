var raw = null

const rect = (s) => s.getBoundingClientRect()

const formatTime = (ms) => {
  if (ms<1e2) return `${Math.round(ms,2)}us`;
  if (ms<1e6) return `${Math.round(ms*1e-3,2)}ms`;
  return `${Math.round(ms*1e-6,2)}s`;
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
  const PADDING = 16;
  const root = document.querySelector(".main-container");
  root.style = "display: flex; width: 100%; height: 100%"
  const lst = root.appendChild(document.createElement("div"));
  lst.style = `background: #0f1018; padding: ${PADDING}px;`;
  const svg = d3.select(root).append("svg").attr("width", "100%").attr("height", "100%");
  let maxDuration = null;
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
      const duration = events[events.length-1].ts-events[0].ts;
      maxDuration = maxDuration == null ? duration : Math.max(duration, maxDuration);
    }
  }
  const render = svg.append("g");
  const width = rect(root).width-rect(lst).width;
  const x = d3.scaleLinear().domain([0, maxDuration]).range([PADDING, width-PADDING]);;
  const TICK_SIZE = 6;
  const time = render.append("g").call(d3.axisTop(x).tickFormat(formatTime).tickSize(TICK_SIZE)).attr("transform", `translate(0, ${PADDING+TICK_SIZE})`);
}
main();
