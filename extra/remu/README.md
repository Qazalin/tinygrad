## Intro

Remu is a minimal RDNA3 emulator built for and tested on [tinygrad](https://github.com/tinygrad/tinygrad) CI.
It supports most of the common RDNA3 instructions. But there are [remaining unimplemented instructions](https://github.com/Qazalin/remu/issues/27).
Remu is built to test the correctness of RDNA3 program outputs. It is not a cycle accurate emulator.

## Build Locally

Remu is written in Rust, make sure you have installed [cargo](https://doc.rust-lang.org/cargo/getting-started/installation.html).

1. `cd ./extra/remu`
2. `cargo build --release` will install dependancies and create a binary usable by tinygrad in the `extra/remu/target/` directory.
(`libremu.dynlib` on macos, `libremu.so` on linux).
3. Symlink the binary to /usr/local/bin/

Mac:
`ln -s '$(pwd)/extra/remu/libremu.dynlib' '/usr/local/bin/'`
Linux:
`ln -s '$(pwd)/extra/remu/libremu.so' '/usr/local/bin/'`

# TODO: if there's a brew installed one this should override it.
# TODO: the command is wrong.

Remu has 3 dependancies:

1. lazy_static: To call `os.getenv` once for env variables, functionally equivalent to `functools.cache`
2. num_traits: Lack of a generic "Float" trait in the Rust std library. This is useful for sharing implementation between f16, f32 and f64 (eg. in comparison ops)
3. half: f16 is not a Rust primitive like f32.

## Usage with tinygrad

The latest binaries are released in https://github.com/Qazalin/remu/releases,

```
curl -s https://api.github.com/repos/Qazalin/remu/releases/latest | \
    jq -r '.assets[] | select(.name == "libremu.so").browser_download_url' | \
    xargs curl -L -o /usr/local/lib/libremu.so
```

alternatively, you can [build remu locally](#build-locally).

use `PYTHONPATH="." MOCKGPU=1 AMD=1` from you root tinygrad directory to execute kernels.

If you change something, you need to re-run `cd ./extra/remu && cargo build --release && cd ../`.

TODO: is there a way to detect changes and on MOCKGPU=1 just release again?
build cache key is last_updated, if last_updated then run it.

## Env variables

Using DEBUG >= 6 will print all the disassembled instructions, as remu executes them. There are 3 parts to each print line:

< ------ Section 1 -------->  <----- section 2 ----- > <----- section 3 -------->


1. Thread state within warp

This includes:

1. If the thread in wrap is actively executing the instruction ( = writing to registers).

The EXEC mask can "turn off" certain threads, eg. in 0b010, only the second thread has permission to write to registers. (imagine `if lidx == 1`).
If a thread is inactive, it will be colored gray, otherwise threads are green.

2. Decoded Instruction:

The instruction type (SMEM, GDS, etc) + all the resolved bitfields with names.
