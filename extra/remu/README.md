## Intro

Remu is an RDNA3 emulator built to test correctness of RDNA3 code. We use this at tinygrad for the AMD CI.
It supports most of the common RDNA3 instructions, but [does not have full coverage](https://github.com/Qazalin/remu/issues/27).

Remu is only for testing correctness of program output, it is not a cycle accurate simulator.

## Build Locally

Remu is written in Rust, make sure you have [cargo](https://doc.rust-lang.org/cargo/getting-started/installation.html).

`cargo build --release` will install dependancies and build a binary usable by tinygrad in the `target` directory.

There are 2 dependencies:

1. half: f16 isn't a Rust primitive like f32. This allows for executing instructions with float16 operands.
2. num_traits: Lack of a generic "Float" trait in the Rust std library. This is useful for sharing implementation between f16, f32 and f64 (eg. in comparison ops, see `fn cmpf`)

## Usage with tinygrad

The latest binaries are released in https://github.com/Qazalin/remu/releases. Alternatively, you can [build locally](#build-locally).

Tinygrad does not yet output RDNA3 kernels directly, you will need [LLVM@19](https://github.com/tinygrad/tinygrad/blob/e2ed673c946c8f1774d816c75e52a994c2dd8a88/.github/actions/setup-tinygrad/action.yml#L208).

`PYTHONPATH="." MOCKGPU=1 AMD=1 AMD_LLVM=1 python test/test_tiny.py TestTiny.test_plus` will use Remu to run an emulated RDNA3 kernel.
Add `DEBUG=6` to see remu's logs.

If you make a change to extra/remu, make sure to rebuild with cargo.

### DEBUG output

Remu runs each thread one at a time in a nested for loop, see lib.rs. The DEBUG output prints information about the current thread.

There are 3 sections to the DEBUG output

```
<------------ 1 ----------> <--- 2 ---> <--------------------------------------- 3 ------------------------------------------>
[0   0   0  ] [0   0   0  ] 0  F4080100 SMEM     sbase=0          sdata=4          op=2             offset=0         soffset=0
```

##### Section 1: Grid info

`[gid.x, gid.y, gid.z], [lid.x, lid.y, lid.z]` of the current thread.

##### Section 2: Wave info

`<lane-id> from 0 to 31 <instruction hex>`

RDNA3 divides the number of threads into chunks of 32. Each thread is assigned to a "lane" from 0-31.

In Remu, even though these threads run one at a time, they share state like SGPRs, VGPRs, LDS, EXEC mask and VCC. Remu correctly simulates a barrier instruction in between. For more details, see work_group.rs.

Section 2 can be printed with a green or gray color.

Green = The thread is actively writing to registers
Gray = The thread has been "turned off" by the EXEC mask, it's still parsing instructions, but it skips execution. (refer to "EXECute Mask" on [page 23](https://www.amd.com/content/dam/amd/en/documents/radeon-tech-docs/instruction-set-architectures/rdna3-shader-instruction-set-architecture-feb-2023_0.pdf#page=23) of ISA docs for more details.)

To see the colors in action, try running `DEBUG=6 PYTHONPATH="." MOCKGPU=1 AMD=1 python test/test_ops.py TestOps.test_arange_big`. See how only lidx=0 is writing to global memory in the end:
```
[255 0   0  ] [0   0   0  ] 0  DC6A0000 GLOBAL   offset=0         op=26            addr=8           data=0           saddr=0          vdst=0
[255 0   0  ] [1   0   0  ] 1  DC6A0000
[255 0   0  ] [2   0   0  ] 2  DC6A0000
[255 0   0  ] [3   0   0  ] 3  DC6A0000
[255 0   0  ] [4   0   0  ] 4  DC6A0000
```

##### Instruction disassembly

This prints the instruction name and all the parsed bitfields in k/v format.
