"""Experimental CDNA4 MXFP4 GEMM kernels built from the known-good handwritten reference."""

from extra.gemm.cdna_lib.mxfp4 import LLAMA_SHAPES, build_kernel, choose_auto_variant
from extra.gemm.cdna_lib.resources import KernelResources, scan_resources

__all__ = ["LLAMA_SHAPES", "KernelResources", "build_kernel", "choose_auto_variant", "scan_resources"]
