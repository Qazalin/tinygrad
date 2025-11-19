#!/bin/bash
llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj /tmp/patched.s -o /tmp/patched.o

llvm-objcopy --update-section .text=/tmp/patched.o /tmp/test.hsaco /tmp/test_patched.hsaco
