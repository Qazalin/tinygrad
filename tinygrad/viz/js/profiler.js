var raw = null

const rect = (s) => s.getBoundingClientRect()

const formatTime = (ms) => {
  if (ms<1e2) return `${Math.round(ms,2)}us`;
  if (ms<1e6) return `${Math.round(ms*1e-3,2)}ms`;
  return `${Math.round(ms*1e-6,2)}s`;
}

const colors = ["7aa2f7", "ff9e64", "f7768e", "2ac3de", "7dcfff", "1abc9c", "9ece6a", "e0af68", "bb9af7", "9d7cd8", "ff007c"];
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
  const HEIGHT = 16;
  const root = document.querySelector(".main-container");
  root.style = "display: flex; width: 100%; height: 100%"
  const lst = root.appendChild(document.createElement("div"));
  lst.style = `background: #0f1018; padding: ${PADDING}px;`;
  const svg = d3.select(root).append("svg").attr("width", "100%").attr("height", "100%");
  let maxDuration = null;
  const timelines = {};
  for (const [pid, threadEvents] of Object.entries(events)) {
    if (threadEvents.every((e) => e.length === 0)) continue;
    const procRoot = lst.appendChild(document.createElement("div"));
    const name = procRoot.appendChild(document.createElement("p"));
    name.style = "background: #0f1018; width: 100%; padding: 4px;";
    name.textContent = procMap[pid].args.name;
    timelines[pid] = {};
    for (const [tid, events] of Object.entries(threadEvents)) {
      const thread = procRoot.appendChild(document.createElement("div"));
      thread.style = "display: flex; padding: 4px;";
      const name = thread.appendChild(document.createElement("p"));
      name.textContent = threadMap[pid][tid].args.name
      const st = events[0].ts;
      const y = rect(thread).y;
      const data = [];
      for (const [i,e] of events.entries()) {
        data.push({ name:e.name, color:`#${colors[i%colors.length]}`, x:e.ts-st, width:e.dur, y });
        if (i === events.length-1) {
          const threadDuration = (e.ts+data.reduce((s, d) => s+d.width, 0))-st;
          maxDuration = maxDuration == null ? threadDuration : Math.max(threadDuration, maxDuration);
        }
      }
      timelines[pid][tid] = data;
    }
  }

  const render = svg.append("g").attr("transform", "translate(0, 0)");
  const width = rect(root).width-rect(lst).width;
  const x = d3.scaleLinear().domain([0, maxDuration]).range([PADDING, width-PADDING]);;
  const TICK_SIZE = 6;
  const time = render.append("g").call(d3.axisTop(x).tickFormat(formatTime).tickSize(TICK_SIZE)).attr("transform", `translate(0, ${PADDING+TICK_SIZE})`);
  for (const [pid, threads] of Object.entries(timelines)) {
    const proc = render.append("g").attr("id", `pid-${pid}`).attr("transform", "translate(0, 0)");
    for (const [tid, events] of Object.entries(threads)) {
      const g = proc.append("g").attr("id", `tid-${tid}`);
      g.selectAll("rect").data(events).join("rect").attr("fill", d => d.color).attr("x", d => x(d.x)).attr("y", d => d.y+4).attr("width", d => x(d.width)).attr("height", HEIGHT);
    }
  }

  const extra = root.appendChild(document.createElement("div"));
  extra.style = "position: absolute; width: 100%; height: 230px; background: #0a0b11; bottom: 0";
}
main();
