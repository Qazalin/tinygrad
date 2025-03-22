importScripts("../assets/dagrejs.github.io/project/dagre/latest/dagre.min.js");

const NODE_PADDING = 10;
const NODE_MARGIN = 50;
const LINE_HEIGHT = 14;
const canvas = new OffscreenCanvas(0, 0);
const ctx = canvas.getContext('2d');
ctx.font = `${LINE_HEIGHT}px sans-serif`;

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
  const { graph, additions, isLinear } = e.data;
  const g = new dagre.graphlib.Graph({ compound: true });
  g.setGraph({ rankdir: "LR", nodsep: NODE_MARGIN }).setDefaultEdgeLabel(function() { return {}; });
  if (additions.length !== 0) g.setNode("addition", {label: "", style: "fill: rgba(26, 27, 38, 0.5); stroke: none;", padding:0});
  for (const [k, [label, src, color]] of Object.entries(graph)) {
    // adjust node dims by label size + add padding
    const [labelWidth, labelHeight] = getTextDims(label);
    g.setNode(k, {label, color, width:labelWidth+NODE_PADDING*2, height:labelHeight+NODE_PADDING*2, padding:NODE_PADDING });
    for (const s of src) g.setEdge(s, k);
    if (additions.includes(parseInt(k))) g.setParent(k, "addition");
  }
  dagre.layout(g);
  if (isLinear) {
    const fixedY = (g.node(g.nodes()[g.nodes().length-1])).y;
    const offsets = {};
    g.nodes().forEach((nodeId) => {
      const node = g.node(nodeId);
      node.y = fixedY;
      if (node.x in offsets) {
        node.x = offsets[node.x] - (node.width+(node.width/2)+NODE_MARGIN);
        offsets[node.x] += node.width;
      } else {
        offsets[node.x] = node.width;
      }
    });
  }
  const dag = dagre.graphlib.json.write(g);
  postMessage(dag);
  self.close();
}
