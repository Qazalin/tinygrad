VIZ is a tool for inspecting tinygrad's compilation process and performance profiling.

## Usage

1. Run tinygrad with VIZ=1 (this saves the pkls and launches the server, to only save the pkls, use VIZ=-1)
2. That's it!

This can be used to:
1. See all schedules
2. See all graphs and how they were rewritten
3. See generated code and disassembly
4. See profile

To view the trace, you can use:
1. Web UI in http://localhost:8000 (launch server with python -m tinygrad.viz.serve, VIZ=1 automatically does this)
2. Command line interface in `extra/viz/cli.py`

## SQTT Profiling

To get cycle level tracing on AMD, set VIZ=2 (or VIZ=-2 to not launch the server). works on RDNA3 and RDNA4 (best) and CDNA (developing).

View other flags in tinygrad/runtime/ops_amd.py to configure SQTT as needed.
