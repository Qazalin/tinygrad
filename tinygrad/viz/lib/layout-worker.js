importScripts("https://cdn.jsdelivr.net/npm/dagre@0.8.5/dist/dagre.min.js")

const canvas = new OffscreenCanvas(0, 0);
const ctx = canvas.getContext('2d');
ctx.font = "14px sans-serif";

function getTextDims(text) {
  let [maxWidth, height] = [0, 0];
  for (l of text.split("\n")) {
    const { width, actualBoundingBoxAscent, actualBoundingBoxDescent } = ctx.measureText(l);
    if (width > maxWidth) maxWidth = width;
    height += actualBoundingBoxAscent+actualBoundingBoxDescent;
  }
  return [maxWidth, height];
}

onmessage = (e) => {
  const { graph, additions } = e.data;
  const g = new dagre.graphlib.Graph({ compound: true });
  g.setGraph({ rankdir: "LR" }).setDefaultEdgeLabel(function() { return {}; });
  for (const [k,u] of Object.entries(graph)) {
    // adjust the node width by the label dims + add padding
    const [labelWidth, labelHeight] = getTextDims(u[0]);
    g.setNode(k, { id: k, label: u[0], color: u[2], width: labelWidth+20, height: labelHeight+30 });
    for (const src of u[1]) g.setEdge(src, k);
  }
  dagre.layout(g);
  postMessage(dagre.graphlib.json.write(g))
}
