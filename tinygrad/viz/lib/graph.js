function recenterRects(svg, zoom) {
  const svgBounds = svg.node().getBoundingClientRect();
  for (const rect of svg.node().querySelectorAll("rect")) {
    const rectBounds = rect.getBoundingClientRect();
    const outOfBounds = rectBounds.top < svgBounds.top || rectBounds.left < svgBounds.left ||
      rectBounds.bottom > svgBounds.bottom || rectBounds.right > svgBounds.right;
    // if there's at least one rect in view we don't do anything
    if (!outOfBounds) return;
  }
  svg.call(zoom.transform, d3.zoomIdentity)
}

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

function intersectRect(r1, r2) {
  const dx = r2.x-r1.x;
  const dy = r2.y-r1.y;
  if (dx === 0 && dy === 0) throw new Error("Invalid node coordinates, rects must not overlap");
  const scaleX = dx !== 0 ? (r1.width/2)/Math.abs(dx) : Infinity;
  const scaleY = dy !== 0 ? (r1.height/2)/Math.abs(dy) : Infinity;
  const scale = Math.min(scaleX, scaleY);
  return {x:r1.x+dx*scale, y:r1.y+dy*scale};
}

window.renderGraph = function(graph, additions) {
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

  // ** select svg render
  const svg = d3.select("#graph-svg");
  const inner = svg.select("g");
  const zoom = d3.zoom().scaleExtent([0.05, 2]).on("zoom", ({ transform }) => {
    inner.attr("transform", transform);
  });
  recenterRects(svg, zoom);
  svg.call(zoom);

  // ** draw nodes
  const nodeRender = inner.select("#nodes");
  const nodes = nodeRender.selectAll("g").data(g.nodes().map(id => g.node(id)), d => d).join("g").attr("transform", d => `translate(${d.x}, ${d.y})`);
  nodes.selectAll("rect").data(d => [d]).join("rect").attr("width", d => d.width).attr("height", d => d.height).attr("style", d => d.style)
    .attr("x", d => -d.width/2).attr("y", d => -d.height/2)
  // +labels
  nodes.selectAll("g.label").data(d => [d]).join("g").attr("class", "label").attr("transform", d => {
    const x = (d.width-NODE_PADDING*2)/2;
    const y = (d.height-NODE_PADDING*2)/2;
    return `translate(-${x}, -${y})`;
   }).selectAll("text").data(d => [d.label.split("\n")]).join("text").selectAll("tspan").data(d => d).join("tspan").text(d => d).attr("x", "1")
     .attr("dy", LINE_HEIGHT).attr("xml:space", "preserve");

  // ** draw edges
  const line = d3.line().x(d => d.x).y(d => d.y).curve(d3.curveBasis);
  const edgeRender = inner.select("#edges");
  edgeRender.selectAll("path.edgePath").data(g.edges()).join("path").attr("class", "edgePath").attr("d", (e) => {
    const edge = g.edge(e);
    const points = edge.points.slice(1, edge.points.length-1);
    points.unshift(intersectRect(g.node(e.v), points[0]));
    points.push(intersectRect(g.node(e.w), points[points.length-1]));
    return line(points);
  }).attr("marker-end", "url(#arrowhead)");
  // +arrow heads
  inner.append("defs").append("marker").attr("id", "arrowhead").attr("viewBox", "0 -5 10 10").attr("refX", 10).attr("refY", 0)
    .attr("markerWidth", 6).attr("markerHeight", 6).attr("orient", "auto").append("path").attr("d", "M0,-5L10,0L0,5").attr("fill", "#4a4b57");
}
