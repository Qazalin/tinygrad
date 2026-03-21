// Microbenchmark: arrow feature with out-of-bounds support
// Simulates millions of shapes where most are skipped by visibility check
// Run with: node arrow_bench.js [numPairs]

const NUM_SHAPES = 1_000_000;
const NUM_ARROW_PAIRS = process.argv[2] != null ? parseInt(process.argv[2]) : 1;
const ITERATIONS = 100;

// Visible range: only 1% of shapes are visible (simulates zoomed in view)
const VISIBLE_START = 4_000_000;
const VISIBLE_END = 4_100_000;

// Generate mock shapes (time-based coordinates)
const shapes = Array.from({length: NUM_SHAPES}, (_, i) => ({
  x: i * 10,          // start time
  width: 8,           // duration
  y: (i % 100) * 5,   // y offset within track
  height: 4,
  arg: { key: `WAVE:0-${i}` }
}));

// Arrow pairs: one shape in visible range, one out of bounds
const arrowPairsList = NUM_ARROW_PAIRS === 0 ? [] : Array.from({length: NUM_ARROW_PAIRS}, (_, i) => [
  `WAVE:0-${400000 + i}`,      // in visible range
  `WAVE:0-${100 + i}`          // out of bounds (before visible)
]);

// Mock xscale and constants
const xscale = (t) => (t - VISIBLE_START) * 0.01;  // maps time to pixels
const st = VISIBLE_START, et = VISIBLE_END;
const offsetY = 100;
const canvasWidth = 1000;

console.log(`Shapes: ${NUM_SHAPES.toLocaleString()}, Arrow pairs: ${NUM_ARROW_PAIRS}, Iterations: ${ITERATIONS}`);
console.log(`Visible range: ${st}-${et} (${((et-st)/(NUM_SHAPES*10)*100).toFixed(1)}% of shapes)\n`);

// ============================================================================
// BASELINE: No arrow feature at all
// ============================================================================
function benchBaseline() {
  let drawn = 0;
  for (const e of shapes) {
    if (e.x > et || e.x + e.width < st) continue;
    // simulate drawing
    const x = xscale(e.x);
    const y = offsetY + e.y;
    const width = xscale(e.x + e.width) - x;
    drawn++;
  }
  return drawn;
}

// ============================================================================
// APPROACH 1: Current - array scan on every shape (before visibility check)
// ============================================================================
function benchArrayScanBefore() {
  const shapeBounds = new Map();
  let drawn = 0;
  for (const e of shapes) {
    const x = xscale(e.x);
    const y = offsetY + e.y;
    const width = xscale(e.x + e.width) - x;
    // check if shape is in arrow pairs
    for (const [a, b] of arrowPairsList) {
      if (a === e.arg.key || b === e.arg.key) {
        shapeBounds.set(e.arg.key, { x0: x, x1: x + width, y0: y, y1: y + e.height });
        break;
      }
    }
    if (e.x > et || e.x + e.width < st) continue;
    drawn++;
  }
  return [drawn, shapeBounds.size];
}

// ============================================================================
// APPROACH 2: Array scan after visibility check (misses out-of-bounds)
// ============================================================================
function benchArrayScanAfter() {
  const shapeBounds = new Map();
  let drawn = 0;
  for (const e of shapes) {
    if (e.x > et || e.x + e.width < st) continue;
    const x = xscale(e.x);
    const y = offsetY + e.y;
    const width = xscale(e.x + e.width) - x;
    // check if shape is in arrow pairs
    for (const [a, b] of arrowPairsList) {
      if (a === e.arg.key || b === e.arg.key) {
        shapeBounds.set(e.arg.key, { x0: x, x1: x + width, y0: y, y1: y + e.height });
        break;
      }
    }
    drawn++;
  }
  return [drawn, shapeBounds.size];
}

// ============================================================================
// APPROACH 3: Pre-build Set of arrow keys, check in hot loop
// ============================================================================
function benchSetCheck() {
  const arrowKeys = new Set(arrowPairsList.flat());
  const shapeBounds = new Map();
  let drawn = 0;
  for (const e of shapes) {
    if (arrowKeys.has(e.arg.key)) {
      const x = xscale(e.x);
      const y = offsetY + e.y;
      const width = xscale(e.x + e.width) - x;
      shapeBounds.set(e.arg.key, { x0: x, x1: x + width, y0: y, y1: y + e.height });
    }
    if (e.x > et || e.x + e.width < st) continue;
    const x = xscale(e.x);
    const y = offsetY + e.y;
    const width = xscale(e.x + e.width) - x;
    drawn++;
  }
  return [drawn, shapeBounds.size];
}

// ============================================================================
// APPROACH 4: Pre-build Set, but only check if set is non-empty
// ============================================================================
function benchSetCheckGuarded() {
  const arrowKeys = new Set(arrowPairsList.flat());
  const hasArrows = arrowKeys.size > 0;
  const shapeBounds = new Map();
  let drawn = 0;
  for (const e of shapes) {
    if (hasArrows && arrowKeys.has(e.arg.key)) {
      const x = xscale(e.x);
      const y = offsetY + e.y;
      const width = xscale(e.x + e.width) - x;
      shapeBounds.set(e.arg.key, { x0: x, x1: x + width, y0: y, y1: y + e.height });
    }
    if (e.x > et || e.x + e.width < st) continue;
    const x = xscale(e.x);
    const y = offsetY + e.y;
    const width = xscale(e.x + e.width) - x;
    drawn++;
  }
  return [drawn, shapeBounds.size];
}

// ============================================================================
// APPROACH 5: Pre-build Map from key -> index, single lookup
// ============================================================================
function benchMapLookup() {
  const arrowKeyMap = new Map();
  for (const [a, b] of arrowPairsList) {
    arrowKeyMap.set(a, true);
    arrowKeyMap.set(b, true);
  }
  const shapeBounds = new Map();
  let drawn = 0;
  for (const e of shapes) {
    if (arrowKeyMap.has(e.arg.key)) {
      const x = xscale(e.x);
      const y = offsetY + e.y;
      const width = xscale(e.x + e.width) - x;
      shapeBounds.set(e.arg.key, { x0: x, x1: x + width, y0: y, y1: y + e.height });
    }
    if (e.x > et || e.x + e.width < st) continue;
    const x = xscale(e.x);
    const y = offsetY + e.y;
    const width = xscale(e.x + e.width) - x;
    drawn++;
  }
  return [drawn, shapeBounds.size];
}

// ============================================================================
// APPROACH 6: Store shape index in arrowPairs, direct lookup after loop
// ============================================================================
function benchPostLoop() {
  // Pre-parse arrow keys to get shape indices
  const arrowIndices = arrowPairsList.flatMap(([a, b]) => {
    const idxA = parseInt(a.split("-")[1]);
    const idxB = parseInt(b.split("-")[1]);
    return [idxA, idxB];
  });
  const shapeBounds = new Map();
  let drawn = 0;
  for (const e of shapes) {
    if (e.x > et || e.x + e.width < st) continue;
    const x = xscale(e.x);
    const y = offsetY + e.y;
    const width = xscale(e.x + e.width) - x;
    shapeBounds.set(e.arg.key, { x0: x, x1: x + width, y0: y, y1: y + e.height });
    drawn++;
  }
  // Post-loop: compute bounds for out-of-bounds arrow shapes
  for (const idx of arrowIndices) {
    const e = shapes[idx];
    if (!shapeBounds.has(e.arg.key)) {
      const x = xscale(e.x);
      const y = offsetY + e.y;
      const width = xscale(e.x + e.width) - x;
      shapeBounds.set(e.arg.key, { x0: x, x1: x + width, y0: y, y1: y + e.height });
    }
  }
  return [drawn, shapeBounds.size];
}

// Warmup
for (let i = 0; i < 10; i++) {
  benchBaseline();
  benchArrayScanBefore();
  benchArrayScanAfter();
  benchSetCheck();
  benchSetCheckGuarded();
  benchMapLookup();
  benchPostLoop();
}

// Benchmark runner
function runBench(name, fn) {
  const start = performance.now();
  let result;
  for (let i = 0; i < ITERATIONS; i++) {
    result = fn();
  }
  const elapsed = performance.now() - start;
  const resultStr = Array.isArray(result) ? `drawn=${result[0]}, bounds=${result[1]}` : `drawn=${result}`;
  console.log(`${name.padEnd(30)}: ${elapsed.toFixed(1).padStart(7)}ms (${(elapsed/ITERATIONS).toFixed(2)}ms/iter) [${resultStr}]`);
  return elapsed;
}

const t0 = runBench("Baseline (no arrows)", benchBaseline);
const t1 = runBench("Array scan before skip", benchArrayScanBefore);
const t2 = runBench("Array scan after skip", benchArrayScanAfter);
const t3 = runBench("Set check", benchSetCheck);
const t4 = runBench("Set check (guarded)", benchSetCheckGuarded);
const t5 = runBench("Map lookup", benchMapLookup);
const t6 = runBench("Post-loop direct index", benchPostLoop);

console.log(`\nOverhead vs baseline:`);
console.log(`  Array scan before: +${((t1-t0)/t0*100).toFixed(1)}%`);
console.log(`  Array scan after:  +${((t2-t0)/t0*100).toFixed(1)}% (no OOB support)`);
console.log(`  Set check:         +${((t3-t0)/t0*100).toFixed(1)}%`);
console.log(`  Set guarded:       +${((t4-t0)/t0*100).toFixed(1)}%`);
console.log(`  Map lookup:        +${((t5-t0)/t0*100).toFixed(1)}%`);
console.log(`  Post-loop index:   +${((t6-t0)/t0*100).toFixed(1)}%`);
