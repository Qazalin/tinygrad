VIZ is a tool for:

1. Inspecting tinygrad's graph rewrites
2. Runtime performance profiling (Python time, GPU time)
3. Reconstructing DEBUG output without re rerunning a command
4. SQTT instruction level profiling (AMD only)

## Usage

1. Run with `VIZ=1`
2. That's it!

Use VIZ=2 to enable SQTT tracing.

### Viewing Traces

- Browser web UI at: `tinygrad/viz/serve.py`, launches in http://localhost:8000.
- Command line interface at: `extra/viz/cli.py --help`.
