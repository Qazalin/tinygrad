importScripts("../assets/dagrejs.github.io/project/dagre/latest/dagre.min.js");

const canvas = new OffscreenCanvas(0, 0);
const ctx = canvas.getContext('2d');
ctx.font = "16px sans-serif";

const NODE_PADDING = 10;
const LINE_HEIGHT = 16;

function getTextDims(text) {
  let [maxWidth, height] = [0, 0];
  for (line of text.split("\n")) {
    const { width } = ctx.measureText(line);
    if (width > maxWidth) maxWidth = width;
    height += LINE_HEIGHT;
  }
  return [maxWidth, height];
}

onmessage = (e) => {
  const { graph, additions } = e.data;
  // ** initialize the graph
  const g = new dagre.graphlib.Graph({ compound: true });
  g.setGraph({ rankdir: "LR" }).setDefaultEdgeLabel(function() { return {}; });
  if (additions.length !== 0) g.setNode("addition", {label: "", style: "fill: rgba(26, 27, 38, 0.5); stroke: none;"});
  for (const [k,v] of Object.entries(graph)) {
    const [label, src, color] = v;
    // calculate node dims based on the label + padding
    const [labelWidth, labelHeight] = getTextDims(label);
    const node = {label, labelType:"text", style:`fill: ${color};`, width:labelWidth+NODE_PADDING*2, height:labelHeight+NODE_PADDING*2};
    // for PROGRAM UOp we render the node with a code block
    if (label.includes("PROGRAM")) {
      const [name, ...rest] = label.split("\n");
      const labelEl = Object.assign(document.createElement("div"));
      labelEl.appendChild(Object.assign(document.createElement("p"), {innerText: name, className: "label", style: "margin-bottom: 2px" }));
      labelEl.appendChild(highlightedCodeBlock(rest.join("\n"), "cpp", true));
      node.label = labelEl;
      node.labelType = "html";
    }
    g.setNode(k, node);
    for (const s of src) g.setEdge(s, k);
    if (additions.includes(parseInt(k))) g.setParent(k, "addition");
  }

  // ** calculate layout
  dagre.layout(g);
  postMessage(dagre.graphlib.json.write(g));
  self.close();
}
