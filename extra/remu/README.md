## Intro

Remu is an RDNA3 emulator built to test correctness of RDNA3 code. We use this at tinygrad for the AMD CI.
It supports most of the common RDNA3 instructions, but [does not have full coverage](https://github.com/Qazalin/remu/issues/27).

Remu is only for testing correctness of program output, it is not a cycle accurate simulator.

## Build Locally

Remu is written in Rust, make sure you have [cargo](https://doc.rust-lang.org/cargo/getting-started/installation.html).

`cargo build --manifest-path ./extra/remu/Cargo.toml --release` will install dependancies and build a binary usable by tinygrad in the `./extra/remu/target/` directory.

Remu has 3 dependancies:

1. lazy_static: To call os.getenv once for env variables, functionally equivalent to `functools.cache`
2. num_traits: Lack of a generic "Float" trait in the Rust std library. This is useful for sharing implementation between f16, f32 and f64 (eg. in comparison ops)
3. half: f16 is not a Rust primitive like f32.

## Usage with tinygrad

The latest binaries are released in https://github.com/Qazalin/remu/releases. Alternatively, you can [build remu locally](#build-locally).

Tinygrad does not yet output RDNA3 kernels directly, you will need [LLVM@19](https://github.com/tinygrad/tinygrad/blob/e2ed673c946c8f1774d816c75e52a994c2dd8a88/.github/actions/setup-tinygrad/action.yml#L208).

`PYTHONPATH="." MOCKGPU=1 AMD=1 python test/test_tiny.py TestTiny.test_plus` will use Remu to run an emulated RDNA3 kernel.
Add `DEBUG=7` to see disassembly, along with remu's logs.
