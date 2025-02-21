importScripts("/assets/cdn.jsdelivr.net/npm/dagre@0.8.5/dist/dagre.min.js")

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
  for (const [k,v] of Object.entries(graph)) {
    const [label, parents, color] = v;
    // calculate label dims + add padding
    const [labelWidth, labelHeight] = getTextDims(label);
    g.setNode(k, { label, color, width:labelWidth+20, height:labelHeight+30 });
    for (const s of src) g.setEdge(s, k);
  }
  postMessage({ event:"update-progress", payload:"Created graph with ${g.nodes().length} nodes and ${g.edges().length} edges" });
  dagre.layout(g);
  postMessage({ event:"set-graph", payload:dagre.graphlib.json.write(g) });
  self.close();
}
