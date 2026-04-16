VIZ is a tool for:

1. Inspecting tinygrad's graph rewrites
2. Viewing source code and disassembly of all generated kernels
3. Runtime performance profiling (Python time, GPU time)
4. SQTT tracing at instruction timing level (AMD runtime only)

## Usage

1. Run with `VIZ=1` (other modes available too, see table below)
2. That's it!

| VIZ | Behavior |
| --- | --- |
| `1` | Collect a trace and launch the web UI |
| `2` | Collect a trace with SQTT and launch the web UI |

### Viewing Traces

VIZ provides a web UI that launches automatically after the program completes.

You can also use the CLI tool to view the same trace without a browser:

```bash
extra/viz/cli.py --help
```
