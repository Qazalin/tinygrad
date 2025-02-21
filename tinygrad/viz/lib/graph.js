import "/assets/d3js.org/d3.v5.min.js";
import "https://cdn.jsdelivr.net/npm/dagre@0.8.5/dist/dagre.min.js";

window.renderGraph = function(graph, additions) {
  const g = new dagre.graphlib.Graph({ compound: true }).setGraph({ rankdir: "LR" }).setDefaultEdgeLabel(function() { return {}; });
  g.setNode("addition", {label: "", clusterLabelPos: "top", style: additions.length !== 0 ? "fill: rgba(26, 27, 38, 0.5);" : "display: none;"});
  for (const [k,u] of Object.entries(graph)) {
    let node = {label: u[0], labelType: "text", style: `fill: ${u[2]};`};
    // for PROGRAM UOp we render the node with a code block
    if (u[0].includes("PROGRAM")) {
      const [name, ...rest] = u[0].split("\n");
      const label = Object.assign(document.createElement("div"));
      label.appendChild(Object.assign(document.createElement("p"), {innerText: name, className: "label", style: "margin-bottom: 2px" }))
      label.appendChild(highlightedCodeBlock(rest.join("\n"), "cpp", true));
      node = {label, labelType: "html", style: `fill: ${u[2]}`};
    }
    g.setNode(k, node);
    for (const src of u[1]) {
      g.setEdge(src, k, {curve: d3.curveBasis})
    }
    if (additions.includes(parseInt(k))) {
      g.setParent(k, "addition");
    }
  }
  const svg = d3.select("#graph-svg");
  const inner = svg.select("g");
  var zoom = d3.zoom()
    .scaleExtent([0.05, 2])
    .on("zoom", () => {
      const transform = d3.event.transform;
      inner.attr("transform", transform);
    });
  svg.call(zoom);
  // render(inner, g);
}
