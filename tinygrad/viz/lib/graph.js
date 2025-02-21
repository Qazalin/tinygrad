function applyClass(dom, classFn, otherClasses) {
  if (classFn) dom.attr("class", classFn).attr("class", otherClasses + " " + dom.attr("class"));
}

function addLabel(root, label) {
  const labelGroup = root.append("g");
  const labelText = labelGroup.append("text");
  const lines = label.split("\n");
  for (let i = 0; i < lines.length; i++) labelText.append("tspan").attr("xml:space", "preserve").attr("dy", "1em").attr("x", "1").text(lines[i]);
  // recenter text
  const { width, height } = labelGroup.node().getBBox();
  labelText.attr("transform", `translate(${-width/2}, ${-height/2})`);
  return labelGroup;
}

function createNodes(selection, g) {
  // Bind data to existing nodes and mark them as updated
  let svgNodes = selection.selectAll("g.node").data(g.nodes(), (v) => v).classed("update", true);
  svgNodes.exit().remove();
  svgNodes.enter().append("g").attr("class", "node").style("opacity", 0);
  svgNodes = selection.selectAll("g.node");
  svgNodes.each(function(v) {
    const node = g.node(v);
    const thisGroup = d3.select(this);
    applyClass(thisGroup, node["class"], `${thisGroup.classed("update") ? "update " : ""}node`);
    thisGroup.select("g.label").remove();
    const labelGroup = thisGroup.append("g").attr("class", "label");
    const labelDom = addLabel(labelGroup, node.label);
    // adjust the node width by the label dims + add padding
    const { width: labelWidth, height: labelHeight } = labelDom.node().getBBox();
    const padding = 20;
    const [w, h] = [labelWidth+padding, labelHeight+padding];
    const rect = d3.select(this).insert("rect", ":first-child").attr("x", -w/2).attr("y", -h/2).attr("width", w).attr("height", h).attr("fill", node.color);
    node.width = w;
    node.height = h;
    node.elem = this;
  });
  return svgNodes;
}

window.renderGraph = (graph, additions) => {
  // console.profile('graph.js Profile');
  const g = new dagre.graphlib.Graph({ compound: true });
  g.setGraph({ rankdir: "LR" }).setDefaultEdgeLabel(function() { return {}; });
  for (const [k,u] of Object.entries(graph)) {
    g.setNode(k, { id: k, label: u[0], color: u[2] });
    for (const src of u[1]) g.setEdge(src, k);
  }
  const svg = d3.select("#graph-svg");
  const render = svg.select("#render");
  svg.call(d3.zoom().scaleExtent([0.05, 2]).on("zoom", () => {
    const transform = d3.event.transform;
    render.attr("transform", transform);
  }));
  const nodes = createNodes(render.select("#nodes"), g);
  dagre.layout(g);
  paintGraph(nodes, g);
  // console.profileEnd('graph.js Profile');
}

// this has DOM access
function paintGraph(nodes, g) {
  const svg = d3.select("#graph-svg");
  const render = svg.select("#render");
  function positionNodes(selection, g) {
    const created = selection.filter(function() { return !d3.select(this).classed("update") });
    function translate(v) {
      const node = g.node(v);
      return `translate(${node.x}, ${node.y})`;
    }
    created.attr("transform", translate);
    selection.style("opacity", 1).attr("transform", translate);
  }
  function createEdgePaths(selection, g) {
    var previousPaths = selection.selectAll("g.edgePath").data(g.edges(), e => `${e.v}:${e.w}`).classed("update", true);
    var newPaths = enter(previousPaths, g);
    exit(previousPaths, g);
    var svgPaths = previousPaths.merge !== undefined ? previousPaths.merge(newPaths) : previousPaths;
    svgPaths.style("opacity", 1);
    // Save DOM element in the path group, and set ID and class
    svgPaths.each(function(e) {
      var domEdge = d3.select(this);
      var edge = g.edge(e);
      edge.elem = this;
      // TODO: does this need a unique?
      edge.arrowheadId = "arrowhead";
      applyClass(domEdge, edge["class"], (domEdge.classed("update") ? "update " : "") + "edgePath");
    });
    svgPaths.selectAll("path.path").each(function (e) {
      const domEdge = d3.select(this).attr("marker-end", () => `url(${location.href.split("#")[0]}#arrowhead)`).style("fill", "none");
      domEdge.attr("d", e => calcPoints(g, e));
    });
    svgPaths.selectAll("defs *").remove();
    svgPaths.selectAll("defs").each(function (e) {
      const edge = g.edge(e);
      arrowhead(d3.select(this), edge.arrowheadId, edge, "arrowhead");
    });
    return svgPaths;
  }
  function intersectRect(node, point) {
    var x = node.x;
    var y = node.y;
    // Rectangle intersection algorithm from:
    // http://math.stackexchange.com/questions/108113/find-edge-between-two-boxes
    var dx = point.x - x;
    var dy = point.y - y;
    var w = node.width / 2;
    var h = node.height / 2;
    var sx, sy;
    if (Math.abs(dy) * w > Math.abs(dx) * h) {
      // Intersection is top or bottom of rect.
      if (dy < 0) {
        h = -h;
      }
      sx = dy === 0 ? 0 : h * dx / dy;
      sy = h;
    } else {
      // Intersection is left or right of rect.
      if (dx < 0) w = -w;
      sx = w;
      sy = dx === 0 ? 0 : w * dy / dx;
    }
    return { x: x + sx, y: y + sy };
  }
  function calcPoints(g, e) {
    const edge = g.edge(e);
    const tail = g.node(e.v);
    const head = g.node(e.w);
    const points = edge.points.slice(1, edge.points.length-1);
    points.unshift(intersectRect(tail, points[0]));
    points.push(intersectRect(head, points[points.length-1]));
    return createLine(edge, points);
  }
  function createLine(edge, points) {
    const line = d3.line().x(d => d.x).y(d => d.y)
    line.curve(d3.curveBasis);
    return line(points);
  }
  function getCoords(elem) {
    const bbox = elem.getBBox();
    const matrix = elem.ownerSVGElement.getScreenCTM().inverse().multiply(elem.getScreenCTM()).translate(bbox.width / 2, bbox.height / 2);
    return { x: matrix.e, y: matrix.f };
  }
  function enter(svgPaths, g) {
    var svgPathsEnter = svgPaths.enter().append("g").attr("class", "edgePath").style("opacity", 0);
    svgPathsEnter.append("path").attr("class", "path").attr("d", (e) => {
      const edge = g.edge(e);
      const sourceElem = g.node(e.v).elem;
      const points = [];
      for (var i = 0; i < edge.points.length; i++) points.push(getCoords(sourceElem));
      return createLine(edge, points);
    });
    svgPathsEnter.append("defs");
    return svgPathsEnter;
  }
  function exit(svgPaths, g) {
    const svgPathExit = svgPaths.exit();
    svgPathExit.style("opacity", 0).remove();
  }
  function arrowhead(parent, id, edge, type) {
    const marker = parent.append("marker")
      .attr("id", id)
      .attr("viewBox", "0 0 10 10")
      .attr("refX", 9)
      .attr("refY", 5)
      .attr("markerUnits", "strokeWidth")
      .attr("markerWidth", 8)
      .attr("markerHeight", 6)
      .attr("orient", "auto");
    const path = marker.append("path").attr("d", "M 0 0 L 10 5 L 0 10 z").style("stroke-width", 1).style("stroke-dasharray", "1,0");
  }
  positionNodes(nodes, g);
  createEdgePaths(render.select("#edges"), g);
}
