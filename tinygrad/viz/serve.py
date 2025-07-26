#!/usr/bin/env python3
import multiprocessing, pickle, difflib, os, threading, json, time, sys, webbrowser, socket, argparse, socketserver, functools, codecs, subprocess
import xml.etree.ElementTree as ET
from decimal import Decimal
from http.server import BaseHTTPRequestHandler
from urllib.parse import parse_qs, urlparse
from typing import Any, TypedDict, Generator, IO
from tinygrad.helpers import colored, getenv, tqdm, unwrap, word_wrap, TRACEMETA, ProfileEvent, ProfileRangeEvent, TracingKey
from tinygrad.uop.ops import TrackedGraphRewrite, UOp, Ops, printable, GroupOp, srender, sint
from tinygrad.device import ProfileDeviceEvent, ProfileGraphEvent, ProfileGraphEntry, ProfilePointEvent
from tinygrad.dtype import dtypes

uops_colors = {Ops.LOAD: "#ffc0c0", Ops.STORE: "#87CEEB", Ops.CONST: "#e0e0e0", Ops.VCONST: "#e0e0e0", Ops.REDUCE: "#FF5B5B",
               Ops.DEFINE_GLOBAL: "#ffe0b0", Ops.DEFINE_LOCAL: "#ffe0d0", Ops.DEFINE_REG: "#f0ffe0", Ops.REDUCE_AXIS: "#FF6B6B",
               Ops.RANGE: "#c8a0e0", Ops.ASSIGN: "#909090", Ops.BARRIER: "#ff8080", Ops.IF: "#c8b0c0", Ops.SPECIAL: "#c0c0ff",
               Ops.INDEX: "#e8ffa0", Ops.WMMA: "#efefc0", Ops.VIEW: "#C8F9D4", Ops.MULTI: "#f6ccff", Ops.KERNEL: "#3e7f55",
               **{x:"#D8F9E4" for x in GroupOp.Movement}, **{x:"#ffffc0" for x in GroupOp.ALU}, Ops.THREEFRY:"#ffff80", Ops.BUFFER_VIEW: "#E5EAFF",
               Ops.BLOCK: "#C4A484", Ops.BLOCKEND: "#C4A4A4", Ops.BUFFER: "#B0BDFF", Ops.COPY: "#a040a0", Ops.FUSE: "#FFa500",
               Ops.ALLREDUCE: "#ff40a0", Ops.MSELECT: "#d040a0", Ops.MSTACK: "#d040a0", Ops.CONTIGUOUS: "#FFC14D"}

# VIZ API

rt_test = [
    {
        "device": "METAL",
        "duration": 18901.875000665314,
        "stats": {
            "counter_info": {
                "0": {
                    "timestamp": "0",
                    "counter-id": "0",
                    "name": "RT Unit Active",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of GPU Cores where raytracing unit is active.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "1": {
                    "timestamp": "0",
                    "counter-id": "1",
                    "name": "VS Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the vertex shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "2": {
                    "timestamp": "0",
                    "counter-id": "2",
                    "name": "FS Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the fragment shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "3": {
                    "timestamp": "0",
                    "counter-id": "3",
                    "name": "Kernel Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the compute kernel",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "4": {
                    "timestamp": "0",
                    "counter-id": "4",
                    "name": "Total Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Sum of vertex, fragment and compute occupancy",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "5": {
                    "timestamp": "0",
                    "counter-id": "5",
                    "name": "Occupancy Manager Target",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The occupancy level to which the occupancy throttler is attempting to achieve.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "6": {
                    "timestamp": "0",
                    "counter-id": "6",
                    "name": "L1 Eviction Rate",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "A measure of the number of L1 cache lines evicted by shader core private memory accesses . The more this number approaches 100% the more that the Occupancy Manager will attempt to reduce simdgroup occupancy.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "7": {
                    "timestamp": "0",
                    "counter-id": "7",
                    "name": "Vertex Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which vertex shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "8": {
                    "timestamp": "0",
                    "counter-id": "8",
                    "name": "Fragment Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which fragment shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "9": {
                    "timestamp": "0",
                    "counter-id": "9",
                    "name": "Compute Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which compute shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "10": {
                    "timestamp": "0",
                    "counter-id": "10",
                    "name": "ALU Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which ALU work is attempted to execute as a percentage of peak ALU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "11": {
                    "timestamp": "0",
                    "counter-id": "11",
                    "name": "ALU Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which ALU work is executed as a percentage of peak ALU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "12": {
                    "timestamp": "0",
                    "counter-id": "12",
                    "name": "F32 Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F32 work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "13": {
                    "timestamp": "0",
                    "counter-id": "13",
                    "name": "F32 Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F32 work is executed as a percentage of peak F32 performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "14": {
                    "timestamp": "0",
                    "counter-id": "14",
                    "name": "F16 Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F16 work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "15": {
                    "timestamp": "0",
                    "counter-id": "15",
                    "name": "F16 Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F16 work is executed as a percentage of peak F16 performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "16": {
                    "timestamp": "0",
                    "counter-id": "16",
                    "name": "Integer and Conditional Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Conditional work is executed as a percentage of peak Integer and Conditional performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "17": {
                    "timestamp": "0",
                    "counter-id": "17",
                    "name": "Integer and Conditional Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Conditional work is executed as a percentage of peak Integer and Conditional performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "18": {
                    "timestamp": "0",
                    "counter-id": "18",
                    "name": "Control Flow Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Control Flow work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "19": {
                    "timestamp": "0",
                    "counter-id": "19",
                    "name": "Control Flow Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Control Flow work is executed as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "20": {
                    "timestamp": "0",
                    "counter-id": "20",
                    "name": "Instruction Throughput Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader instructions are attempted to be processed as a percentage of peak shader execution pipeline performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "21": {
                    "timestamp": "0",
                    "counter-id": "21",
                    "name": "Instruction Throughput Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader instructions are processed as a percentage of peak shader execution pipeline performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "22": {
                    "timestamp": "0",
                    "counter-id": "22",
                    "name": "Integer and Complex Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Complex work is attemped to execute as a percentage of peak Integer and Complex performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "23": {
                    "timestamp": "0",
                    "counter-id": "23",
                    "name": "Integer and Complex Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Complex work is executed as a percentage of peak Integer and Complex performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "24": {
                    "timestamp": "0",
                    "counter-id": "24",
                    "name": "L1 Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader core L1 cache is attempting to service read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "25": {
                    "timestamp": "0",
                    "counter-id": "25",
                    "name": "L1 Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s L1 cache serviced read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "26": {
                    "timestamp": "0",
                    "counter-id": "26",
                    "name": "L1 Total Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Total Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "27": {
                    "timestamp": "0",
                    "counter-id": "27",
                    "name": "L1 Buffer Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Buffer Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "28": {
                    "timestamp": "0",
                    "counter-id": "28",
                    "name": "L1 Imageblock Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Imageblock Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "29": {
                    "timestamp": "0",
                    "counter-id": "29",
                    "name": "L1 RT Scratch Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 RT Scratch Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "30": {
                    "timestamp": "0",
                    "counter-id": "30",
                    "name": "L1 Register Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Register Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "31": {
                    "timestamp": "0",
                    "counter-id": "31",
                    "name": "L1 Stack Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Stack Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "32": {
                    "timestamp": "0",
                    "counter-id": "32",
                    "name": "L1 Threadgroup Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Threadgroup Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "33": {
                    "timestamp": "0",
                    "counter-id": "33",
                    "name": "Buffer L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the buffer reads serviced by L1 as a percentage of total L1 read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "34": {
                    "timestamp": "0",
                    "counter-id": "34",
                    "name": "ThreadGroup L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures threadgroup L1 reads accesses as a percentage of peak L1 total read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "35": {
                    "timestamp": "0",
                    "counter-id": "35",
                    "name": "ImageBlock L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures imageblock read accesses as a percentage of total L1 read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "36": {
                    "timestamp": "0",
                    "counter-id": "36",
                    "name": "Stack L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures stack L1 read accesses  as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "37": {
                    "timestamp": "0",
                    "counter-id": "37",
                    "name": "Register L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 rgeneral purpose register read accesses as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "38": {
                    "timestamp": "0",
                    "counter-id": "38",
                    "name": "RT Scratch L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 ray tracing scratch read accesses as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "39": {
                    "timestamp": "0",
                    "counter-id": "39",
                    "name": "Other L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 read accesses for other shader core sub-blocks  as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "40": {
                    "timestamp": "0",
                    "counter-id": "40",
                    "name": "Buffer L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the buffer writes serviced by L1 as a percentage of total L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "41": {
                    "timestamp": "0",
                    "counter-id": "41",
                    "name": "ThreadGroup L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures threadgroup write accesses as a percentage of peak L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "42": {
                    "timestamp": "0",
                    "counter-id": "42",
                    "name": "ImageBlock L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures imageblock write accesses as a percentage of total L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "43": {
                    "timestamp": "0",
                    "counter-id": "43",
                    "name": "Stack L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures stack L1 write accesses  as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "44": {
                    "timestamp": "0",
                    "counter-id": "44",
                    "name": "RT Scratch L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 ray tracing scratch write accesses as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "45": {
                    "timestamp": "0",
                    "counter-id": "45",
                    "name": "Register L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 general purpose register write accesses as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "46": {
                    "timestamp": "0",
                    "counter-id": "46",
                    "name": "Other L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 write accesses for other shader core sub-blocks  as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "47": {
                    "timestamp": "0",
                    "counter-id": "47",
                    "name": "Buffer L1 Miss Rate",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage buffer L1 cache accesses are misses from shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "48": {
                    "timestamp": "0",
                    "counter-id": "48",
                    "name": "Total SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of all simdgroups including vertex, fragment and compute running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "49": {
                    "timestamp": "0",
                    "counter-id": "49",
                    "name": "Vertex SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of vertex simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "50": {
                    "timestamp": "0",
                    "counter-id": "50",
                    "name": "Fragment SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of fragment simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "51": {
                    "timestamp": "0",
                    "counter-id": "51",
                    "name": "Compute SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of vertex simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "52": {
                    "timestamp": "0",
                    "counter-id": "52",
                    "name": "Texture Read Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture reads / samples are attempted to execute as a percentage of peak texture read / sampling performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "53": {
                    "timestamp": "0",
                    "counter-id": "53",
                    "name": "Texture Read Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture reads / samples are executed as a percentage of peak texture read / sample performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "54": {
                    "timestamp": "0",
                    "counter-id": "54",
                    "name": "Texture Read Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture cache reads are attempted to execute as a percentage of peak texture read cache performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "55": {
                    "timestamp": "0",
                    "counter-id": "55",
                    "name": "Texture Read Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture cache reads is executed as a percentage of peak texture read cache performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "56": {
                    "timestamp": "0",
                    "counter-id": "56",
                    "name": "Texture Write Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture write are attempted to execute as a percentage of peak texture write performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "57": {
                    "timestamp": "0",
                    "counter-id": "57",
                    "name": "Texture Write Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture writes are executed as a percentage of peak texture writes performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "58": {
                    "timestamp": "0",
                    "counter-id": "58",
                    "name": "GPU Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are read or written by the GPU to a memory external to the GPU (potentially device memory).",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "59": {
                    "timestamp": "0",
                    "counter-id": "59",
                    "name": "GPU Read Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are read by the GPU from a memory external to the GPU (potentially device memory)",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "60": {
                    "timestamp": "0",
                    "counter-id": "60",
                    "name": "GPU Write Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are written by the GPU to a memory external to the GPU (potentially device memory).",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "61": {
                    "timestamp": "0",
                    "counter-id": "61",
                    "name": "MMU Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU is attempting to execute read and write requests through MMU due to last level cache misses as a percentage of peak MMU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "62": {
                    "timestamp": "0",
                    "counter-id": "62",
                    "name": "MMU Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU serviced read and write requests through MMU due to last level cache misses as a percentage of peak MMU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "63": {
                    "timestamp": "0",
                    "counter-id": "63",
                    "name": "Last Level Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s last level cache is attempting to service read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "64": {
                    "timestamp": "0",
                    "counter-id": "64",
                    "name": "Last Level Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s last level cache serviced read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                }
            },
            "counter_agg": {
                "0": 0,
                "1": 0,
                "2": 0,
                "3": 26.34843235512203,
                "4": 26.34843235512203,
                "5": 30.184407910753475,
                "6": 0.28577267563270486,
                "7": 0,
                "8": 0,
                "9": 82.85780709395094,
                "10": 49.204122245430185,
                "11": 42.96141581172206,
                "12": 91.92463411603771,
                "13": 80.24709776387161,
                "14": 0,
                "15": 0,
                "16": 6.162094941749683,
                "17": 5.359964372533326,
                "18": 1.0936101130289309,
                "19": 0.6275493874666667,
                "20": 99.82969528114214,
                "21": 22.266940602445242,
                "22": 0.6430308655987427,
                "23": 0.6315389736603774,
                "24": 10.520571255968562,
                "25": 10.520432033627687,
                "26": 97.61523194816485,
                "27": 94.16328307970826,
                "28": 0,
                "29": 0,
                "30": 3.446380941967292,
                "31": 0,
                "32": 0,
                "33": 87.06561032791821,
                "34": 0,
                "35": 0,
                "36": 0,
                "37": 5.6080966721886805,
                "38": 0,
                "39": 0.00002057340754716981,
                "40": 0.35247732396855336,
                "41": 0,
                "42": 0,
                "43": 0,
                "44": 0,
                "45": 6.97377452715975,
                "46": 0.00002057340754716981,
                "47": 53.268557342432665,
                "48": 25.294495060877992,
                "49": 0,
                "50": 0,
                "51": 25.294495060877992,
                "52": 0,
                "53": 0,
                "54": 0,
                "55": 0,
                "56": 0.000002781754318618042,
                "57": 0.000002781754318618042,
                "58": 309.7697773696217,
                "59": 305.77450143232545,
                "60": 3.9952759368042328,
                "61": 19.263823059484118,
                "62": 19.10681692764022,
                "63": 57.2015872539127,
                "64": 57.04151233854502
            }
        }
    },
    {
        "device": "METAL",
        "duration": 16470.499998831656,
        "stats": {
            "counter_info": {
                "0": {
                    "timestamp": "0",
                    "counter-id": "0",
                    "name": "RT Unit Active",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of GPU Cores where raytracing unit is active.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "1": {
                    "timestamp": "0",
                    "counter-id": "1",
                    "name": "VS Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the vertex shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "2": {
                    "timestamp": "0",
                    "counter-id": "2",
                    "name": "FS Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the fragment shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "3": {
                    "timestamp": "0",
                    "counter-id": "3",
                    "name": "Kernel Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the compute kernel",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "4": {
                    "timestamp": "0",
                    "counter-id": "4",
                    "name": "Total Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Sum of vertex, fragment and compute occupancy",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "5": {
                    "timestamp": "0",
                    "counter-id": "5",
                    "name": "Occupancy Manager Target",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The occupancy level to which the occupancy throttler is attempting to achieve.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "6": {
                    "timestamp": "0",
                    "counter-id": "6",
                    "name": "L1 Eviction Rate",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "A measure of the number of L1 cache lines evicted by shader core private memory accesses . The more this number approaches 100% the more that the Occupancy Manager will attempt to reduce simdgroup occupancy.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "7": {
                    "timestamp": "0",
                    "counter-id": "7",
                    "name": "Vertex Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which vertex shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "8": {
                    "timestamp": "0",
                    "counter-id": "8",
                    "name": "Fragment Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which fragment shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "9": {
                    "timestamp": "0",
                    "counter-id": "9",
                    "name": "Compute Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which compute shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "10": {
                    "timestamp": "0",
                    "counter-id": "10",
                    "name": "ALU Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which ALU work is attempted to execute as a percentage of peak ALU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "11": {
                    "timestamp": "0",
                    "counter-id": "11",
                    "name": "ALU Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which ALU work is executed as a percentage of peak ALU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "12": {
                    "timestamp": "0",
                    "counter-id": "12",
                    "name": "F32 Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F32 work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "13": {
                    "timestamp": "0",
                    "counter-id": "13",
                    "name": "F32 Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F32 work is executed as a percentage of peak F32 performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "14": {
                    "timestamp": "0",
                    "counter-id": "14",
                    "name": "F16 Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F16 work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "15": {
                    "timestamp": "0",
                    "counter-id": "15",
                    "name": "F16 Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F16 work is executed as a percentage of peak F16 performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "16": {
                    "timestamp": "0",
                    "counter-id": "16",
                    "name": "Integer and Conditional Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Conditional work is executed as a percentage of peak Integer and Conditional performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "17": {
                    "timestamp": "0",
                    "counter-id": "17",
                    "name": "Integer and Conditional Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Conditional work is executed as a percentage of peak Integer and Conditional performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "18": {
                    "timestamp": "0",
                    "counter-id": "18",
                    "name": "Control Flow Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Control Flow work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "19": {
                    "timestamp": "0",
                    "counter-id": "19",
                    "name": "Control Flow Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Control Flow work is executed as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "20": {
                    "timestamp": "0",
                    "counter-id": "20",
                    "name": "Instruction Throughput Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader instructions are attempted to be processed as a percentage of peak shader execution pipeline performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "21": {
                    "timestamp": "0",
                    "counter-id": "21",
                    "name": "Instruction Throughput Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader instructions are processed as a percentage of peak shader execution pipeline performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "22": {
                    "timestamp": "0",
                    "counter-id": "22",
                    "name": "Integer and Complex Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Complex work is attemped to execute as a percentage of peak Integer and Complex performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "23": {
                    "timestamp": "0",
                    "counter-id": "23",
                    "name": "Integer and Complex Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Complex work is executed as a percentage of peak Integer and Complex performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "24": {
                    "timestamp": "0",
                    "counter-id": "24",
                    "name": "L1 Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader core L1 cache is attempting to service read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "25": {
                    "timestamp": "0",
                    "counter-id": "25",
                    "name": "L1 Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s L1 cache serviced read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "26": {
                    "timestamp": "0",
                    "counter-id": "26",
                    "name": "L1 Total Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Total Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "27": {
                    "timestamp": "0",
                    "counter-id": "27",
                    "name": "L1 Buffer Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Buffer Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "28": {
                    "timestamp": "0",
                    "counter-id": "28",
                    "name": "L1 Imageblock Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Imageblock Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "29": {
                    "timestamp": "0",
                    "counter-id": "29",
                    "name": "L1 RT Scratch Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 RT Scratch Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "30": {
                    "timestamp": "0",
                    "counter-id": "30",
                    "name": "L1 Register Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Register Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "31": {
                    "timestamp": "0",
                    "counter-id": "31",
                    "name": "L1 Stack Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Stack Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "32": {
                    "timestamp": "0",
                    "counter-id": "32",
                    "name": "L1 Threadgroup Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Threadgroup Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "33": {
                    "timestamp": "0",
                    "counter-id": "33",
                    "name": "Buffer L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the buffer reads serviced by L1 as a percentage of total L1 read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "34": {
                    "timestamp": "0",
                    "counter-id": "34",
                    "name": "ThreadGroup L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures threadgroup L1 reads accesses as a percentage of peak L1 total read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "35": {
                    "timestamp": "0",
                    "counter-id": "35",
                    "name": "ImageBlock L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures imageblock read accesses as a percentage of total L1 read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "36": {
                    "timestamp": "0",
                    "counter-id": "36",
                    "name": "Stack L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures stack L1 read accesses  as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "37": {
                    "timestamp": "0",
                    "counter-id": "37",
                    "name": "Register L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 rgeneral purpose register read accesses as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "38": {
                    "timestamp": "0",
                    "counter-id": "38",
                    "name": "RT Scratch L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 ray tracing scratch read accesses as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "39": {
                    "timestamp": "0",
                    "counter-id": "39",
                    "name": "Other L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 read accesses for other shader core sub-blocks  as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "40": {
                    "timestamp": "0",
                    "counter-id": "40",
                    "name": "Buffer L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the buffer writes serviced by L1 as a percentage of total L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "41": {
                    "timestamp": "0",
                    "counter-id": "41",
                    "name": "ThreadGroup L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures threadgroup write accesses as a percentage of peak L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "42": {
                    "timestamp": "0",
                    "counter-id": "42",
                    "name": "ImageBlock L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures imageblock write accesses as a percentage of total L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "43": {
                    "timestamp": "0",
                    "counter-id": "43",
                    "name": "Stack L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures stack L1 write accesses  as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "44": {
                    "timestamp": "0",
                    "counter-id": "44",
                    "name": "RT Scratch L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 ray tracing scratch write accesses as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "45": {
                    "timestamp": "0",
                    "counter-id": "45",
                    "name": "Register L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 general purpose register write accesses as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "46": {
                    "timestamp": "0",
                    "counter-id": "46",
                    "name": "Other L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 write accesses for other shader core sub-blocks  as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "47": {
                    "timestamp": "0",
                    "counter-id": "47",
                    "name": "Buffer L1 Miss Rate",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage buffer L1 cache accesses are misses from shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "48": {
                    "timestamp": "0",
                    "counter-id": "48",
                    "name": "Total SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of all simdgroups including vertex, fragment and compute running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "49": {
                    "timestamp": "0",
                    "counter-id": "49",
                    "name": "Vertex SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of vertex simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "50": {
                    "timestamp": "0",
                    "counter-id": "50",
                    "name": "Fragment SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of fragment simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "51": {
                    "timestamp": "0",
                    "counter-id": "51",
                    "name": "Compute SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of vertex simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "52": {
                    "timestamp": "0",
                    "counter-id": "52",
                    "name": "Texture Read Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture reads / samples are attempted to execute as a percentage of peak texture read / sampling performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "53": {
                    "timestamp": "0",
                    "counter-id": "53",
                    "name": "Texture Read Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture reads / samples are executed as a percentage of peak texture read / sample performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "54": {
                    "timestamp": "0",
                    "counter-id": "54",
                    "name": "Texture Read Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture cache reads are attempted to execute as a percentage of peak texture read cache performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "55": {
                    "timestamp": "0",
                    "counter-id": "55",
                    "name": "Texture Read Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture cache reads is executed as a percentage of peak texture read cache performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "56": {
                    "timestamp": "0",
                    "counter-id": "56",
                    "name": "Texture Write Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture write are attempted to execute as a percentage of peak texture write performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "57": {
                    "timestamp": "0",
                    "counter-id": "57",
                    "name": "Texture Write Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture writes are executed as a percentage of peak texture writes performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "58": {
                    "timestamp": "0",
                    "counter-id": "58",
                    "name": "GPU Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are read or written by the GPU to a memory external to the GPU (potentially device memory).",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "59": {
                    "timestamp": "0",
                    "counter-id": "59",
                    "name": "GPU Read Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are read by the GPU from a memory external to the GPU (potentially device memory)",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "60": {
                    "timestamp": "0",
                    "counter-id": "60",
                    "name": "GPU Write Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are written by the GPU to a memory external to the GPU (potentially device memory).",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "61": {
                    "timestamp": "0",
                    "counter-id": "61",
                    "name": "MMU Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU is attempting to execute read and write requests through MMU due to last level cache misses as a percentage of peak MMU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "62": {
                    "timestamp": "0",
                    "counter-id": "62",
                    "name": "MMU Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU serviced read and write requests through MMU due to last level cache misses as a percentage of peak MMU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "63": {
                    "timestamp": "0",
                    "counter-id": "63",
                    "name": "Last Level Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s last level cache is attempting to service read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "64": {
                    "timestamp": "0",
                    "counter-id": "64",
                    "name": "Last Level Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s last level cache serviced read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                }
            },
            "counter_agg": {
                "0": 0,
                "1": 0,
                "2": 0,
                "3": 26.22293408702166,
                "4": 26.22293408702166,
                "5": 31.07536010020058,
                "6": 0.35159264433910536,
                "7": 0,
                "8": 0,
                "9": 80.2993510203795,
                "10": 48.29813708640124,
                "11": 42.17948382844594,
                "12": 90.343664750355,
                "13": 78.78532456954825,
                "14": 0,
                "15": 0,
                "16": 5.9372609764978295,
                "17": 5.263505030235213,
                "18": 1.0024919385468962,
                "19": 0.6161160643636359,
                "20": 99.54615883530444,
                "21": 21.861682169077927,
                "22": 0.6306968914992782,
                "23": 0.6202761137330443,
                "24": 10.470524335760464,
                "25": 10.470321698011553,
                "26": 97.13527093550637,
                "27": 93.62946816696534,
                "28": 0,
                "29": 0,
                "30": 3.501840069186143,
                "31": 0,
                "32": 0,
                "33": 83.87483902379944,
                "34": 0,
                "35": 0,
                "36": 0,
                "37": 6.962769339867243,
                "38": 0,
                "39": 0.000016163940836940837,
                "40": 0.35544503415728707,
                "41": 0,
                "42": 0,
                "43": 0,
                "44": 0,
                "45": 8.806914272305919,
                "46": 0.000016163940836940837,
                "47": 55.18642056916302,
                "48": 25.17401672349785,
                "49": 0,
                "50": 0,
                "51": 25.17401672349785,
                "52": 0,
                "53": 0,
                "54": 0,
                "55": 0,
                "56": 0.000003331353846153846,
                "57": 0.000003331353846153846,
                "58": 351.26403489352117,
                "59": 346.65909951939705,
                "60": 4.604935373675755,
                "61": 21.835485449484842,
                "62": 21.666235341696975,
                "63": 66.83564251031513,
                "64": 66.68005154713632
            }
        }
    },
    {
        "device": "METAL",
        "duration": 17346.75000079733,
        "stats": {
            "counter_info": {
                "0": {
                    "timestamp": "0",
                    "counter-id": "0",
                    "name": "RT Unit Active",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of GPU Cores where raytracing unit is active.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "1": {
                    "timestamp": "0",
                    "counter-id": "1",
                    "name": "VS Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the vertex shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "2": {
                    "timestamp": "0",
                    "counter-id": "2",
                    "name": "FS Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the fragment shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "3": {
                    "timestamp": "0",
                    "counter-id": "3",
                    "name": "Kernel Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the compute kernel",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "4": {
                    "timestamp": "0",
                    "counter-id": "4",
                    "name": "Total Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Sum of vertex, fragment and compute occupancy",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "5": {
                    "timestamp": "0",
                    "counter-id": "5",
                    "name": "Occupancy Manager Target",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The occupancy level to which the occupancy throttler is attempting to achieve.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "6": {
                    "timestamp": "0",
                    "counter-id": "6",
                    "name": "L1 Eviction Rate",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "A measure of the number of L1 cache lines evicted by shader core private memory accesses . The more this number approaches 100% the more that the Occupancy Manager will attempt to reduce simdgroup occupancy.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "7": {
                    "timestamp": "0",
                    "counter-id": "7",
                    "name": "Vertex Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which vertex shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "8": {
                    "timestamp": "0",
                    "counter-id": "8",
                    "name": "Fragment Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which fragment shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "9": {
                    "timestamp": "0",
                    "counter-id": "9",
                    "name": "Compute Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which compute shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "10": {
                    "timestamp": "0",
                    "counter-id": "10",
                    "name": "ALU Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which ALU work is attempted to execute as a percentage of peak ALU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "11": {
                    "timestamp": "0",
                    "counter-id": "11",
                    "name": "ALU Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which ALU work is executed as a percentage of peak ALU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "12": {
                    "timestamp": "0",
                    "counter-id": "12",
                    "name": "F32 Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F32 work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "13": {
                    "timestamp": "0",
                    "counter-id": "13",
                    "name": "F32 Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F32 work is executed as a percentage of peak F32 performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "14": {
                    "timestamp": "0",
                    "counter-id": "14",
                    "name": "F16 Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F16 work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "15": {
                    "timestamp": "0",
                    "counter-id": "15",
                    "name": "F16 Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F16 work is executed as a percentage of peak F16 performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "16": {
                    "timestamp": "0",
                    "counter-id": "16",
                    "name": "Integer and Conditional Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Conditional work is executed as a percentage of peak Integer and Conditional performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "17": {
                    "timestamp": "0",
                    "counter-id": "17",
                    "name": "Integer and Conditional Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Conditional work is executed as a percentage of peak Integer and Conditional performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "18": {
                    "timestamp": "0",
                    "counter-id": "18",
                    "name": "Control Flow Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Control Flow work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "19": {
                    "timestamp": "0",
                    "counter-id": "19",
                    "name": "Control Flow Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Control Flow work is executed as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "20": {
                    "timestamp": "0",
                    "counter-id": "20",
                    "name": "Instruction Throughput Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader instructions are attempted to be processed as a percentage of peak shader execution pipeline performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "21": {
                    "timestamp": "0",
                    "counter-id": "21",
                    "name": "Instruction Throughput Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader instructions are processed as a percentage of peak shader execution pipeline performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "22": {
                    "timestamp": "0",
                    "counter-id": "22",
                    "name": "Integer and Complex Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Complex work is attemped to execute as a percentage of peak Integer and Complex performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "23": {
                    "timestamp": "0",
                    "counter-id": "23",
                    "name": "Integer and Complex Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Complex work is executed as a percentage of peak Integer and Complex performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "24": {
                    "timestamp": "0",
                    "counter-id": "24",
                    "name": "L1 Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader core L1 cache is attempting to service read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "25": {
                    "timestamp": "0",
                    "counter-id": "25",
                    "name": "L1 Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s L1 cache serviced read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "26": {
                    "timestamp": "0",
                    "counter-id": "26",
                    "name": "L1 Total Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Total Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "27": {
                    "timestamp": "0",
                    "counter-id": "27",
                    "name": "L1 Buffer Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Buffer Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "28": {
                    "timestamp": "0",
                    "counter-id": "28",
                    "name": "L1 Imageblock Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Imageblock Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "29": {
                    "timestamp": "0",
                    "counter-id": "29",
                    "name": "L1 RT Scratch Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 RT Scratch Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "30": {
                    "timestamp": "0",
                    "counter-id": "30",
                    "name": "L1 Register Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Register Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "31": {
                    "timestamp": "0",
                    "counter-id": "31",
                    "name": "L1 Stack Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Stack Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "32": {
                    "timestamp": "0",
                    "counter-id": "32",
                    "name": "L1 Threadgroup Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Threadgroup Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "33": {
                    "timestamp": "0",
                    "counter-id": "33",
                    "name": "Buffer L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the buffer reads serviced by L1 as a percentage of total L1 read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "34": {
                    "timestamp": "0",
                    "counter-id": "34",
                    "name": "ThreadGroup L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures threadgroup L1 reads accesses as a percentage of peak L1 total read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "35": {
                    "timestamp": "0",
                    "counter-id": "35",
                    "name": "ImageBlock L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures imageblock read accesses as a percentage of total L1 read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "36": {
                    "timestamp": "0",
                    "counter-id": "36",
                    "name": "Stack L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures stack L1 read accesses  as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "37": {
                    "timestamp": "0",
                    "counter-id": "37",
                    "name": "Register L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 rgeneral purpose register read accesses as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "38": {
                    "timestamp": "0",
                    "counter-id": "38",
                    "name": "RT Scratch L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 ray tracing scratch read accesses as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "39": {
                    "timestamp": "0",
                    "counter-id": "39",
                    "name": "Other L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 read accesses for other shader core sub-blocks  as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "40": {
                    "timestamp": "0",
                    "counter-id": "40",
                    "name": "Buffer L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the buffer writes serviced by L1 as a percentage of total L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "41": {
                    "timestamp": "0",
                    "counter-id": "41",
                    "name": "ThreadGroup L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures threadgroup write accesses as a percentage of peak L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "42": {
                    "timestamp": "0",
                    "counter-id": "42",
                    "name": "ImageBlock L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures imageblock write accesses as a percentage of total L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "43": {
                    "timestamp": "0",
                    "counter-id": "43",
                    "name": "Stack L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures stack L1 write accesses  as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "44": {
                    "timestamp": "0",
                    "counter-id": "44",
                    "name": "RT Scratch L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 ray tracing scratch write accesses as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "45": {
                    "timestamp": "0",
                    "counter-id": "45",
                    "name": "Register L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 general purpose register write accesses as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "46": {
                    "timestamp": "0",
                    "counter-id": "46",
                    "name": "Other L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 write accesses for other shader core sub-blocks  as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "47": {
                    "timestamp": "0",
                    "counter-id": "47",
                    "name": "Buffer L1 Miss Rate",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage buffer L1 cache accesses are misses from shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "48": {
                    "timestamp": "0",
                    "counter-id": "48",
                    "name": "Total SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of all simdgroups including vertex, fragment and compute running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "49": {
                    "timestamp": "0",
                    "counter-id": "49",
                    "name": "Vertex SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of vertex simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "50": {
                    "timestamp": "0",
                    "counter-id": "50",
                    "name": "Fragment SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of fragment simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "51": {
                    "timestamp": "0",
                    "counter-id": "51",
                    "name": "Compute SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of vertex simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "52": {
                    "timestamp": "0",
                    "counter-id": "52",
                    "name": "Texture Read Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture reads / samples are attempted to execute as a percentage of peak texture read / sampling performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "53": {
                    "timestamp": "0",
                    "counter-id": "53",
                    "name": "Texture Read Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture reads / samples are executed as a percentage of peak texture read / sample performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "54": {
                    "timestamp": "0",
                    "counter-id": "54",
                    "name": "Texture Read Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture cache reads are attempted to execute as a percentage of peak texture read cache performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "55": {
                    "timestamp": "0",
                    "counter-id": "55",
                    "name": "Texture Read Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture cache reads is executed as a percentage of peak texture read cache performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "56": {
                    "timestamp": "0",
                    "counter-id": "56",
                    "name": "Texture Write Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture write are attempted to execute as a percentage of peak texture write performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "57": {
                    "timestamp": "0",
                    "counter-id": "57",
                    "name": "Texture Write Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture writes are executed as a percentage of peak texture writes performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "58": {
                    "timestamp": "0",
                    "counter-id": "58",
                    "name": "GPU Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are read or written by the GPU to a memory external to the GPU (potentially device memory).",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "59": {
                    "timestamp": "0",
                    "counter-id": "59",
                    "name": "GPU Read Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are read by the GPU from a memory external to the GPU (potentially device memory)",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "60": {
                    "timestamp": "0",
                    "counter-id": "60",
                    "name": "GPU Write Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are written by the GPU to a memory external to the GPU (potentially device memory).",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "61": {
                    "timestamp": "0",
                    "counter-id": "61",
                    "name": "MMU Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU is attempting to execute read and write requests through MMU due to last level cache misses as a percentage of peak MMU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "62": {
                    "timestamp": "0",
                    "counter-id": "62",
                    "name": "MMU Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU serviced read and write requests through MMU due to last level cache misses as a percentage of peak MMU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "63": {
                    "timestamp": "0",
                    "counter-id": "63",
                    "name": "Last Level Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s last level cache is attempting to service read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "64": {
                    "timestamp": "0",
                    "counter-id": "64",
                    "name": "Last Level Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s last level cache serviced read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                }
            },
            "counter_agg": {
                "0": 0,
                "1": 0,
                "2": 0,
                "3": 26.117278606503405,
                "4": 26.117278606503405,
                "5": 31.22153511723533,
                "6": 0.3466674061326952,
                "7": 0,
                "8": 0,
                "9": 79.6095309289767,
                "10": 46.06128587481799,
                "11": 39.98963171866889,
                "12": 86.25864944636544,
                "13": 74.69488877174422,
                "14": 0,
                "15": 0,
                "16": 5.565415760448701,
                "17": 4.990329035648425,
                "18": 0.9572177322366625,
                "19": 0.5841262089247611,
                "20": 99.31360283407527,
                "21": 20.726679769436394,
                "22": 0.5970130851080712,
                "23": 0.5880912593474686,
                "24": 9.962627317875514,
                "25": 9.962378220575928,
                "26": 96.70088034056354,
                "27": 93.12947130635155,
                "28": 0,
                "29": 0,
                "30": 3.5680251735020496,
                "31": 0,
                "32": 0,
                "33": 83.21150241915868,
                "34": 0,
                "35": 0,
                "36": 0,
                "37": 7.210099984477424,
                "38": 0,
                "39": 0.000031291343365253076,
                "40": 0.3514972579972642,
                "41": 0,
                "42": 0,
                "43": 0,
                "44": 0,
                "45": 9.22683775367442,
                "46": 0.000031291343365253076,
                "47": 55.718786382681294,
                "48": 25.07258746222435,
                "49": 0,
                "50": 0,
                "51": 25.07258746222435,
                "52": 0,
                "53": 0,
                "54": 0,
                "55": 0,
                "56": 0.000003060242171189979,
                "57": 0.000003060242171189979,
                "58": 353.50517481924794,
                "59": 349.05510136610076,
                "60": 4.450073452636889,
                "61": 21.97784040386167,
                "62": 21.804476770342927,
                "63": 64.23714308190203,
                "64": 64.00884788851585
            }
        }
    },
    {
        "device": "METAL",
        "duration": 16872.08333351009,
        "stats": {
            "counter_info": {
                "0": {
                    "timestamp": "0",
                    "counter-id": "0",
                    "name": "RT Unit Active",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of GPU Cores where raytracing unit is active.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "1": {
                    "timestamp": "0",
                    "counter-id": "1",
                    "name": "VS Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the vertex shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "2": {
                    "timestamp": "0",
                    "counter-id": "2",
                    "name": "FS Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the fragment shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "3": {
                    "timestamp": "0",
                    "counter-id": "3",
                    "name": "Kernel Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the compute kernel",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "4": {
                    "timestamp": "0",
                    "counter-id": "4",
                    "name": "Total Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Sum of vertex, fragment and compute occupancy",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "5": {
                    "timestamp": "0",
                    "counter-id": "5",
                    "name": "Occupancy Manager Target",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The occupancy level to which the occupancy throttler is attempting to achieve.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "6": {
                    "timestamp": "0",
                    "counter-id": "6",
                    "name": "L1 Eviction Rate",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "A measure of the number of L1 cache lines evicted by shader core private memory accesses . The more this number approaches 100% the more that the Occupancy Manager will attempt to reduce simdgroup occupancy.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "7": {
                    "timestamp": "0",
                    "counter-id": "7",
                    "name": "Vertex Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which vertex shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "8": {
                    "timestamp": "0",
                    "counter-id": "8",
                    "name": "Fragment Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which fragment shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "9": {
                    "timestamp": "0",
                    "counter-id": "9",
                    "name": "Compute Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which compute shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "10": {
                    "timestamp": "0",
                    "counter-id": "10",
                    "name": "ALU Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which ALU work is attempted to execute as a percentage of peak ALU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "11": {
                    "timestamp": "0",
                    "counter-id": "11",
                    "name": "ALU Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which ALU work is executed as a percentage of peak ALU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "12": {
                    "timestamp": "0",
                    "counter-id": "12",
                    "name": "F32 Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F32 work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "13": {
                    "timestamp": "0",
                    "counter-id": "13",
                    "name": "F32 Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F32 work is executed as a percentage of peak F32 performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "14": {
                    "timestamp": "0",
                    "counter-id": "14",
                    "name": "F16 Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F16 work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "15": {
                    "timestamp": "0",
                    "counter-id": "15",
                    "name": "F16 Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F16 work is executed as a percentage of peak F16 performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "16": {
                    "timestamp": "0",
                    "counter-id": "16",
                    "name": "Integer and Conditional Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Conditional work is executed as a percentage of peak Integer and Conditional performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "17": {
                    "timestamp": "0",
                    "counter-id": "17",
                    "name": "Integer and Conditional Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Conditional work is executed as a percentage of peak Integer and Conditional performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "18": {
                    "timestamp": "0",
                    "counter-id": "18",
                    "name": "Control Flow Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Control Flow work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "19": {
                    "timestamp": "0",
                    "counter-id": "19",
                    "name": "Control Flow Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Control Flow work is executed as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "20": {
                    "timestamp": "0",
                    "counter-id": "20",
                    "name": "Instruction Throughput Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader instructions are attempted to be processed as a percentage of peak shader execution pipeline performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "21": {
                    "timestamp": "0",
                    "counter-id": "21",
                    "name": "Instruction Throughput Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader instructions are processed as a percentage of peak shader execution pipeline performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "22": {
                    "timestamp": "0",
                    "counter-id": "22",
                    "name": "Integer and Complex Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Complex work is attemped to execute as a percentage of peak Integer and Complex performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "23": {
                    "timestamp": "0",
                    "counter-id": "23",
                    "name": "Integer and Complex Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Complex work is executed as a percentage of peak Integer and Complex performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "24": {
                    "timestamp": "0",
                    "counter-id": "24",
                    "name": "L1 Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader core L1 cache is attempting to service read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "25": {
                    "timestamp": "0",
                    "counter-id": "25",
                    "name": "L1 Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s L1 cache serviced read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "26": {
                    "timestamp": "0",
                    "counter-id": "26",
                    "name": "L1 Total Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Total Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "27": {
                    "timestamp": "0",
                    "counter-id": "27",
                    "name": "L1 Buffer Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Buffer Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "28": {
                    "timestamp": "0",
                    "counter-id": "28",
                    "name": "L1 Imageblock Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Imageblock Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "29": {
                    "timestamp": "0",
                    "counter-id": "29",
                    "name": "L1 RT Scratch Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 RT Scratch Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "30": {
                    "timestamp": "0",
                    "counter-id": "30",
                    "name": "L1 Register Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Register Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "31": {
                    "timestamp": "0",
                    "counter-id": "31",
                    "name": "L1 Stack Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Stack Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "32": {
                    "timestamp": "0",
                    "counter-id": "32",
                    "name": "L1 Threadgroup Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Threadgroup Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "33": {
                    "timestamp": "0",
                    "counter-id": "33",
                    "name": "Buffer L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the buffer reads serviced by L1 as a percentage of total L1 read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "34": {
                    "timestamp": "0",
                    "counter-id": "34",
                    "name": "ThreadGroup L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures threadgroup L1 reads accesses as a percentage of peak L1 total read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "35": {
                    "timestamp": "0",
                    "counter-id": "35",
                    "name": "ImageBlock L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures imageblock read accesses as a percentage of total L1 read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "36": {
                    "timestamp": "0",
                    "counter-id": "36",
                    "name": "Stack L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures stack L1 read accesses  as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "37": {
                    "timestamp": "0",
                    "counter-id": "37",
                    "name": "Register L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 rgeneral purpose register read accesses as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "38": {
                    "timestamp": "0",
                    "counter-id": "38",
                    "name": "RT Scratch L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 ray tracing scratch read accesses as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "39": {
                    "timestamp": "0",
                    "counter-id": "39",
                    "name": "Other L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 read accesses for other shader core sub-blocks  as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "40": {
                    "timestamp": "0",
                    "counter-id": "40",
                    "name": "Buffer L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the buffer writes serviced by L1 as a percentage of total L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "41": {
                    "timestamp": "0",
                    "counter-id": "41",
                    "name": "ThreadGroup L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures threadgroup write accesses as a percentage of peak L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "42": {
                    "timestamp": "0",
                    "counter-id": "42",
                    "name": "ImageBlock L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures imageblock write accesses as a percentage of total L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "43": {
                    "timestamp": "0",
                    "counter-id": "43",
                    "name": "Stack L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures stack L1 write accesses  as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "44": {
                    "timestamp": "0",
                    "counter-id": "44",
                    "name": "RT Scratch L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 ray tracing scratch write accesses as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "45": {
                    "timestamp": "0",
                    "counter-id": "45",
                    "name": "Register L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 general purpose register write accesses as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "46": {
                    "timestamp": "0",
                    "counter-id": "46",
                    "name": "Other L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 write accesses for other shader core sub-blocks  as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "47": {
                    "timestamp": "0",
                    "counter-id": "47",
                    "name": "Buffer L1 Miss Rate",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage buffer L1 cache accesses are misses from shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "48": {
                    "timestamp": "0",
                    "counter-id": "48",
                    "name": "Total SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of all simdgroups including vertex, fragment and compute running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "49": {
                    "timestamp": "0",
                    "counter-id": "49",
                    "name": "Vertex SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of vertex simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "50": {
                    "timestamp": "0",
                    "counter-id": "50",
                    "name": "Fragment SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of fragment simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "51": {
                    "timestamp": "0",
                    "counter-id": "51",
                    "name": "Compute SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of vertex simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "52": {
                    "timestamp": "0",
                    "counter-id": "52",
                    "name": "Texture Read Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture reads / samples are attempted to execute as a percentage of peak texture read / sampling performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "53": {
                    "timestamp": "0",
                    "counter-id": "53",
                    "name": "Texture Read Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture reads / samples are executed as a percentage of peak texture read / sample performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "54": {
                    "timestamp": "0",
                    "counter-id": "54",
                    "name": "Texture Read Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture cache reads are attempted to execute as a percentage of peak texture read cache performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "55": {
                    "timestamp": "0",
                    "counter-id": "55",
                    "name": "Texture Read Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture cache reads is executed as a percentage of peak texture read cache performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "56": {
                    "timestamp": "0",
                    "counter-id": "56",
                    "name": "Texture Write Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture write are attempted to execute as a percentage of peak texture write performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "57": {
                    "timestamp": "0",
                    "counter-id": "57",
                    "name": "Texture Write Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture writes are executed as a percentage of peak texture writes performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "58": {
                    "timestamp": "0",
                    "counter-id": "58",
                    "name": "GPU Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are read or written by the GPU to a memory external to the GPU (potentially device memory).",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "59": {
                    "timestamp": "0",
                    "counter-id": "59",
                    "name": "GPU Read Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are read by the GPU from a memory external to the GPU (potentially device memory)",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "60": {
                    "timestamp": "0",
                    "counter-id": "60",
                    "name": "GPU Write Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are written by the GPU to a memory external to the GPU (potentially device memory).",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "61": {
                    "timestamp": "0",
                    "counter-id": "61",
                    "name": "MMU Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU is attempting to execute read and write requests through MMU due to last level cache misses as a percentage of peak MMU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "62": {
                    "timestamp": "0",
                    "counter-id": "62",
                    "name": "MMU Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU serviced read and write requests through MMU due to last level cache misses as a percentage of peak MMU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "63": {
                    "timestamp": "0",
                    "counter-id": "63",
                    "name": "Last Level Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s last level cache is attempting to service read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "64": {
                    "timestamp": "0",
                    "counter-id": "64",
                    "name": "Last Level Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s last level cache serviced read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                }
            },
            "counter_agg": {
                "0": 0,
                "1": 0,
                "2": 0,
                "3": 25.95913103952319,
                "4": 25.95913103952319,
                "5": 31.839977245286928,
                "6": 0.35091813384669496,
                "7": 0,
                "8": 0,
                "9": 78.72436540070598,
                "10": 47.17477832647961,
                "11": 41.1143852733671,
                "12": 88.27210390718844,
                "13": 76.79576302933478,
                "14": 0,
                "15": 0,
                "16": 5.770118411760899,
                "17": 5.130691196412096,
                "18": 0.9827871144402224,
                "19": 0.6005564219521798,
                "20": 98.94949141834742,
                "21": 21.309641454340337,
                "22": 0.6146686675555557,
                "23": 0.6046326414360056,
                "24": 10.224935218976087,
                "25": 10.22470666451196,
                "26": 96.14032180164554,
                "27": 92.7307298855204,
                "28": 0,
                "29": 0,
                "30": 3.4060063164135017,
                "31": 0,
                "32": 0,
                "33": 83.60190090075382,
                "34": 0,
                "35": 0,
                "36": 0,
                "37": 7.06782535505485,
                "38": 0,
                "39": 0.00002446024894514768,
                "40": 0.35948349147819975,
                "41": 0,
                "42": 0,
                "43": 0,
                "44": 0,
                "45": 8.970741296285517,
                "46": 0.00002449423488045007,
                "47": 55.862782413119554,
                "48": 24.920765797955006,
                "49": 0,
                "50": 0,
                "51": 24.920765797955006,
                "52": 0,
                "53": 0,
                "54": 0,
                "55": 0,
                "56": 0.0000031456030042918455,
                "57": 0.0000031456030042918455,
                "58": 357.0425185603462,
                "59": 352.491089843417,
                "60": 4.551428716449705,
                "61": 22.208442179289907,
                "62": 22.02265329488165,
                "63": 66.1832047568728,
                "64": 66.00203191652658
            }
        }
    },
    {
        "device": "METAL",
        "duration": 16736.499999751686,
        "stats": {
            "counter_info": {
                "0": {
                    "timestamp": "0",
                    "counter-id": "0",
                    "name": "RT Unit Active",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of GPU Cores where raytracing unit is active.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "1": {
                    "timestamp": "0",
                    "counter-id": "1",
                    "name": "VS Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the vertex shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "2": {
                    "timestamp": "0",
                    "counter-id": "2",
                    "name": "FS Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the fragment shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "3": {
                    "timestamp": "0",
                    "counter-id": "3",
                    "name": "Kernel Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage of shader core resources that are occupied by the compute kernel",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "4": {
                    "timestamp": "0",
                    "counter-id": "4",
                    "name": "Total Occupancy",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Sum of vertex, fragment and compute occupancy",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "5": {
                    "timestamp": "0",
                    "counter-id": "5",
                    "name": "Occupancy Manager Target",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The occupancy level to which the occupancy throttler is attempting to achieve.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "6": {
                    "timestamp": "0",
                    "counter-id": "6",
                    "name": "L1 Eviction Rate",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "A measure of the number of L1 cache lines evicted by shader core private memory accesses . The more this number approaches 100% the more that the Occupancy Manager will attempt to reduce simdgroup occupancy.",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "7": {
                    "timestamp": "0",
                    "counter-id": "7",
                    "name": "Vertex Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which vertex shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "8": {
                    "timestamp": "0",
                    "counter-id": "8",
                    "name": "Fragment Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which fragment shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "9": {
                    "timestamp": "0",
                    "counter-id": "9",
                    "name": "Compute Shader Launch Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "The rate at which compute shader threads are launched into the shader cores or stalled launching by the shader core, normalized to the peak launch rate",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "10": {
                    "timestamp": "0",
                    "counter-id": "10",
                    "name": "ALU Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which ALU work is attempted to execute as a percentage of peak ALU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "11": {
                    "timestamp": "0",
                    "counter-id": "11",
                    "name": "ALU Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which ALU work is executed as a percentage of peak ALU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "12": {
                    "timestamp": "0",
                    "counter-id": "12",
                    "name": "F32 Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F32 work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "13": {
                    "timestamp": "0",
                    "counter-id": "13",
                    "name": "F32 Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F32 work is executed as a percentage of peak F32 performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "14": {
                    "timestamp": "0",
                    "counter-id": "14",
                    "name": "F16 Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F16 work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "15": {
                    "timestamp": "0",
                    "counter-id": "15",
                    "name": "F16 Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which F16 work is executed as a percentage of peak F16 performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "16": {
                    "timestamp": "0",
                    "counter-id": "16",
                    "name": "Integer and Conditional Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Conditional work is executed as a percentage of peak Integer and Conditional performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "17": {
                    "timestamp": "0",
                    "counter-id": "17",
                    "name": "Integer and Conditional Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Conditional work is executed as a percentage of peak Integer and Conditional performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "18": {
                    "timestamp": "0",
                    "counter-id": "18",
                    "name": "Control Flow Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Control Flow work is attempted to execute as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "19": {
                    "timestamp": "0",
                    "counter-id": "19",
                    "name": "Control Flow Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Control Flow work is executed as a percentage of peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "20": {
                    "timestamp": "0",
                    "counter-id": "20",
                    "name": "Instruction Throughput Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader instructions are attempted to be processed as a percentage of peak shader execution pipeline performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "21": {
                    "timestamp": "0",
                    "counter-id": "21",
                    "name": "Instruction Throughput Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader instructions are processed as a percentage of peak shader execution pipeline performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "22": {
                    "timestamp": "0",
                    "counter-id": "22",
                    "name": "Integer and Complex Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Complex work is attemped to execute as a percentage of peak Integer and Complex performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "23": {
                    "timestamp": "0",
                    "counter-id": "23",
                    "name": "Integer and Complex Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which Integer and Complex work is executed as a percentage of peak Integer and Complex performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "24": {
                    "timestamp": "0",
                    "counter-id": "24",
                    "name": "L1 Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which shader core L1 cache is attempting to service read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "25": {
                    "timestamp": "0",
                    "counter-id": "25",
                    "name": "L1 Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s L1 cache serviced read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "26": {
                    "timestamp": "0",
                    "counter-id": "26",
                    "name": "L1 Total Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Total Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "27": {
                    "timestamp": "0",
                    "counter-id": "27",
                    "name": "L1 Buffer Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Buffer Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "28": {
                    "timestamp": "0",
                    "counter-id": "28",
                    "name": "L1 Imageblock Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Imageblock Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "29": {
                    "timestamp": "0",
                    "counter-id": "29",
                    "name": "L1 RT Scratch Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 RT Scratch Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "30": {
                    "timestamp": "0",
                    "counter-id": "30",
                    "name": "L1 Register Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Register Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "31": {
                    "timestamp": "0",
                    "counter-id": "31",
                    "name": "L1 Stack Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Stack Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "32": {
                    "timestamp": "0",
                    "counter-id": "32",
                    "name": "L1 Threadgroup Residency",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "L1 Threadgroup Residency",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "33": {
                    "timestamp": "0",
                    "counter-id": "33",
                    "name": "Buffer L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the buffer reads serviced by L1 as a percentage of total L1 read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "34": {
                    "timestamp": "0",
                    "counter-id": "34",
                    "name": "ThreadGroup L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures threadgroup L1 reads accesses as a percentage of peak L1 total read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "35": {
                    "timestamp": "0",
                    "counter-id": "35",
                    "name": "ImageBlock L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures imageblock read accesses as a percentage of total L1 read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "36": {
                    "timestamp": "0",
                    "counter-id": "36",
                    "name": "Stack L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures stack L1 read accesses  as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "37": {
                    "timestamp": "0",
                    "counter-id": "37",
                    "name": "Register L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 rgeneral purpose register read accesses as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "38": {
                    "timestamp": "0",
                    "counter-id": "38",
                    "name": "RT Scratch L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 ray tracing scratch read accesses as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "39": {
                    "timestamp": "0",
                    "counter-id": "39",
                    "name": "Other L1 Read Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 read accesses for other shader core sub-blocks  as a percentage of total L1 cache’s read accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "40": {
                    "timestamp": "0",
                    "counter-id": "40",
                    "name": "Buffer L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the buffer writes serviced by L1 as a percentage of total L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "41": {
                    "timestamp": "0",
                    "counter-id": "41",
                    "name": "ThreadGroup L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures threadgroup write accesses as a percentage of peak L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "42": {
                    "timestamp": "0",
                    "counter-id": "42",
                    "name": "ImageBlock L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures imageblock write accesses as a percentage of total L1 write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "43": {
                    "timestamp": "0",
                    "counter-id": "43",
                    "name": "Stack L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures stack L1 write accesses  as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "44": {
                    "timestamp": "0",
                    "counter-id": "44",
                    "name": "RT Scratch L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 ray tracing scratch write accesses as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "45": {
                    "timestamp": "0",
                    "counter-id": "45",
                    "name": "Register L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 general purpose register write accesses as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "46": {
                    "timestamp": "0",
                    "counter-id": "46",
                    "name": "Other L1 Write Accesses",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures L1 write accesses for other shader core sub-blocks  as a percentage of total L1 cache’s write accesses",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "47": {
                    "timestamp": "0",
                    "counter-id": "47",
                    "name": "Buffer L1 Miss Rate",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Percentage buffer L1 cache accesses are misses from shader",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "48": {
                    "timestamp": "0",
                    "counter-id": "48",
                    "name": "Total SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of all simdgroups including vertex, fragment and compute running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "49": {
                    "timestamp": "0",
                    "counter-id": "49",
                    "name": "Vertex SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of vertex simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "50": {
                    "timestamp": "0",
                    "counter-id": "50",
                    "name": "Fragment SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of fragment simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "51": {
                    "timestamp": "0",
                    "counter-id": "51",
                    "name": "Compute SIMD Groups Inflight",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "The average number of vertex simdgroups running concurrently per shader core.",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "52": {
                    "timestamp": "0",
                    "counter-id": "52",
                    "name": "Texture Read Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture reads / samples are attempted to execute as a percentage of peak texture read / sampling performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "53": {
                    "timestamp": "0",
                    "counter-id": "53",
                    "name": "Texture Read Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture reads / samples are executed as a percentage of peak texture read / sample performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "54": {
                    "timestamp": "0",
                    "counter-id": "54",
                    "name": "Texture Read Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture cache reads are attempted to execute as a percentage of peak texture read cache performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "55": {
                    "timestamp": "0",
                    "counter-id": "55",
                    "name": "Texture Read Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture cache reads is executed as a percentage of peak texture read cache performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "56": {
                    "timestamp": "0",
                    "counter-id": "56",
                    "name": "Texture Write Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture write are attempted to execute as a percentage of peak texture write performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "57": {
                    "timestamp": "0",
                    "counter-id": "57",
                    "name": "Texture Write Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which texture writes are executed as a percentage of peak texture writes performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "58": {
                    "timestamp": "0",
                    "counter-id": "58",
                    "name": "GPU Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are read or written by the GPU to a memory external to the GPU (potentially device memory).",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "59": {
                    "timestamp": "0",
                    "counter-id": "59",
                    "name": "GPU Read Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are read by the GPU from a memory external to the GPU (potentially device memory)",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "60": {
                    "timestamp": "0",
                    "counter-id": "60",
                    "name": "GPU Write Bandwidth",
                    "max-value": "9223372036854775807",
                    "accelerator-id": "4294969211",
                    "description": "Measures how much memory, in gigabytes per second, are written by the GPU to a memory external to the GPU (potentially device memory).",
                    "group-index": "1",
                    "type": "Value",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "61": {
                    "timestamp": "0",
                    "counter-id": "61",
                    "name": "MMU Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU is attempting to execute read and write requests through MMU due to last level cache misses as a percentage of peak MMU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "62": {
                    "timestamp": "0",
                    "counter-id": "62",
                    "name": "MMU Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU serviced read and write requests through MMU due to last level cache misses as a percentage of peak MMU performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "63": {
                    "timestamp": "0",
                    "counter-id": "63",
                    "name": "Last Level Cache Limiter",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s last level cache is attempting to service read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                },
                "64": {
                    "timestamp": "0",
                    "counter-id": "64",
                    "name": "Last Level Cache Utilization",
                    "max-value": "100",
                    "accelerator-id": "4294969211",
                    "description": "Measures the time during which GPU’s last level cache serviced read and write requests as a percentage of cache’s peak performance",
                    "group-index": "1",
                    "type": "Percentage",
                    "ring-buffer-count": "1",
                    "require-weighted-accumulation": "0",
                    "sample-interval": "0"
                }
            },
            "counter_agg": {
                "0": 0,
                "1": 0,
                "2": 0,
                "3": 26.217230488684667,
                "4": 26.217230488684667,
                "5": 30.791343745208852,
                "6": 0.33424969863068194,
                "7": 0,
                "8": 0,
                "9": 80.08710089938354,
                "10": 47.674857544964496,
                "11": 41.58354664036937,
                "12": 89.20316097163361,
                "13": 77.67284852036074,
                "14": 0,
                "15": 0,
                "16": 5.835814765853692,
                "17": 5.1885486842457444,
                "18": 0.9893365250440351,
                "19": 0.6074210279517042,
                "20": 99.59415268207103,
                "21": 21.552802082660495,
                "22": 0.6214787043281246,
                "23": 0.6113921517272723,
                "24": 10.312263538694596,
                "25": 10.312078755022743,
                "26": 97.11660479486646,
                "27": 93.55235599094607,
                "28": 0,
                "29": 0,
                "30": 3.560356508323866,
                "31": 0,
                "32": 0,
                "33": 84.11076627655413,
                "34": 0,
                "35": 0,
                "36": 0,
                "37": 6.847384478764201,
                "38": 0,
                "39": 0.0000123259375,
                "40": 0.3499973467556818,
                "41": 0,
                "42": 0,
                "43": 0,
                "44": 0,
                "45": 8.691827244105111,
                "46": 0.0000123259375,
                "47": 55.63873195835372,
                "48": 25.16854126911788,
                "49": 0,
                "50": 0,
                "51": 25.16854126911788,
                "52": 0,
                "53": 0,
                "54": 0,
                "55": 0,
                "56": 0.0000032478982683982685,
                "57": 0.0000032478982683982685,
                "58": 348.96057986736633,
                "59": 344.42249114897885,
                "60": 4.53808871790991,
                "61": 21.66278765665466,
                "62": 21.500642206225226,
                "63": 66.15511471995796,
                "64": 65.96389969406304
            }
        }
    }
]

# ** Metadata for a track_rewrites scope

ref_map:dict[Any, int] = {}
def get_metadata(keys:list[TracingKey], contexts:list[list[TrackedGraphRewrite]]) -> list[dict]:
  ret = []
  for i,(k,v) in enumerate(zip(keys, contexts)):
    steps = [{"name":s.name, "loc":s.loc, "depth":s.depth, "match_count":len(s.matches), "code_line":printable(s.loc)} for s in v]
    ret.append(r:={"name":k.display_name, "fmt":k.fmt, "steps":steps})
    #if getenv("PROFILE_VALUE") >= 2 and k.keys: r["runtime_stats"] = get_runtime_stats(k.keys[0])
    r["runtime_stats"] = rt_test
    for key in k.keys: ref_map[key] = i
  return ret

# ** Complete rewrite details for a graph_rewrite call

class GraphRewriteDetails(TypedDict):
  graph: dict                            # JSON serialized UOp for this rewrite step
  uop: str                               # strigified UOp for this rewrite step
  diff: list[str]|None                   # diff of the single UOp that changed
  changed_nodes: list[int]|None          # the changed UOp id + all its parents ids
  upat: tuple[tuple[str, int], str]|None # [loc, source_code] of the matched UPat

def shape_to_str(s:tuple[sint, ...]): return "(" + ','.join(srender(x) for x in s) + ")"
def mask_to_str(s:tuple[tuple[sint, sint], ...]): return "(" + ','.join(shape_to_str(x) for x in s) + ")"

def uop_to_json(x:UOp) -> dict[int, dict]:
  assert isinstance(x, UOp)
  graph: dict[int, dict] = {}
  excluded: set[UOp] = set()
  for u in (toposort:=x.toposort()):
    # always exclude DEVICE/CONST/UNIQUE
    if u.op in {Ops.DEVICE, Ops.CONST, Ops.UNIQUE}: excluded.add(u)
    # only exclude CONST VIEW source if it has no other children in the graph
    if u.op is Ops.CONST and len(u.src) != 0 and all(cr.op is Ops.CONST for c in u.src[0].children if (cr:=c()) is not None and cr in toposort):
      excluded.update(u.src)
  for u in toposort:
    if u in excluded: continue
    argst = codecs.decode(str(u.arg), "unicode_escape")
    if u.op is Ops.VIEW:
      argst = ("\n".join([f"{shape_to_str(v.shape)} / {shape_to_str(v.strides)}"+("" if v.offset == 0 else f" / {srender(v.offset)}")+
                          (f"\nMASK {mask_to_str(v.mask)}" if v.mask is not None else "") for v in unwrap(u.st).views]))
    label = f"{str(u.op).split('.')[1]}{(chr(10)+word_wrap(argst.replace(':', ''))) if u.arg is not None else ''}"
    if u.dtype != dtypes.void: label += f"\n{u.dtype}"
    for idx,x in enumerate(u.src):
      if x in excluded:
        if x.op is Ops.CONST and dtypes.is_float(u.dtype): label += f"\nCONST{idx} {x.arg:g}"
        else: label += f"\n{x.op.name}{idx} {x.arg}"
    try:
      if u.op not in {Ops.VIEW, Ops.BUFFER, Ops.KERNEL, Ops.ASSIGN, Ops.COPY, Ops.SINK, *GroupOp.Buffer} and u.st is not None:
        label += f"\n{shape_to_str(u.shape)}"
    except Exception:
      label += "\n<ISSUE GETTING SHAPE>"
    if (ref:=ref_map.get(u.arg.ast) if u.op is Ops.KERNEL else None) is not None: label += f"\ncodegen@{ctxs[ref]['name']}"
    # NOTE: kernel already has metadata in arg
    if TRACEMETA >= 2 and u.metadata is not None and u.op is not Ops.KERNEL: label += "\n"+repr(u.metadata)
    graph[id(u)] = {"label":label, "src":[id(x) for x in u.src if x not in excluded], "color":uops_colors.get(u.op, "#ffffff"),
                    "ref":ref, "tag":u.tag}
  return graph

@functools.cache
def _reconstruct(a:int):
  op, dtype, src, arg, tag = contexts[2][a]
  arg = type(arg)(_reconstruct(arg.ast), arg.metadata) if op is Ops.KERNEL else arg
  return UOp(op, dtype, tuple(_reconstruct(s) for s in src), arg, tag)

def get_details(ctx:TrackedGraphRewrite) -> Generator[GraphRewriteDetails, None, None]:
  yield {"graph":uop_to_json(next_sink:=_reconstruct(ctx.sink)), "uop":str(next_sink), "changed_nodes":None, "diff":None, "upat":None}
  replaces: dict[UOp, UOp] = {}
  for u0_num,u1_num,upat_loc in tqdm(ctx.matches):
    replaces[u0:=_reconstruct(u0_num)] = u1 = _reconstruct(u1_num)
    try: new_sink = next_sink.substitute(replaces)
    except RuntimeError as e: new_sink = UOp(Ops.NOOP, arg=str(e))
    yield {"graph":(sink_json:=uop_to_json(new_sink)), "uop":str(new_sink), "changed_nodes":[id(x) for x in u1.toposort() if id(x) in sink_json],
           "diff":list(difflib.unified_diff(str(u0).splitlines(), str(u1).splitlines())), "upat":(upat_loc, printable(upat_loc))}
    if not ctx.bottom_up: next_sink = new_sink

# Profiler API

device_ts_diffs:dict[str, tuple[Decimal, Decimal]] = {}
def cpu_ts_diff(device:str, thread=0) -> Decimal: return device_ts_diffs.get(device, (Decimal(0),))[thread]

DevEvent = ProfileRangeEvent|ProfileGraphEntry|ProfilePointEvent
def flatten_events(profile:list[ProfileEvent]) -> Generator[tuple[Decimal, Decimal, DevEvent], None, None]:
  for e in profile:
    if isinstance(e, ProfileRangeEvent): yield (e.st+(diff:=cpu_ts_diff(e.device, e.is_copy)), (e.en if e.en is not None else e.st)+diff, e)
    elif isinstance(e, ProfilePointEvent): yield (e.st, e.st, e)
    elif isinstance(e, ProfileGraphEvent):
      cpu_ts = []
      for ent in e.ents: cpu_ts += [e.sigs[ent.st_id]+(diff:=cpu_ts_diff(ent.device, ent.is_copy)), e.sigs[ent.en_id]+diff]
      yield (st:=min(cpu_ts)), (et:=max(cpu_ts)), ProfileRangeEvent(f"{e.ents[0].device.split(':')[0]} Graph", f"batched {len(e.ents)}", st, et)
      for i,ent in enumerate(e.ents): yield (cpu_ts[i*2], cpu_ts[i*2+1], ent)

# timeline layout stacks events in a contiguous block. When a late starter finishes late, there is whitespace in the higher levels.
def timeline_layout(events:list[tuple[int, int, float, DevEvent]]) -> dict:
  shapes:list[dict] = []
  levels:list[int] = []
  for st,et,dur,e in events:
    if dur == 0: continue
    # find a free level to put the event
    depth = next((i for i,level_et in enumerate(levels) if st>=level_et), len(levels))
    if depth < len(levels): levels[depth] = et
    else: levels.append(et)
    name, cat = e.name, None
    if (ref:=ref_map.get(name)) is not None: name = ctxs[ref]["name"]
    elif isinstance(e.name, TracingKey):
      name, cat = e.name.display_name, e.name.cat
      ref = next((v for k in e.name.keys if (v:=ref_map.get(k)) is not None), None)
    shapes.append({"name":name, "ref":ref, "st":st, "dur":dur, "depth":depth, "cat":cat})
  return {"shapes":shapes, "maxDepth":len(levels)}

def mem_layout(events:list[tuple[int, int, float, DevEvent]]) -> dict:
  step, peak, mem = 0, 0, 0
  shps:dict[int, dict] = {}
  temp:dict[int, dict] = {}
  timestamps:list[int] = []
  for st,_,_,e in events:
    if not isinstance(e, ProfilePointEvent): continue
    if e.name == "alloc":
      shps[e.ref] = temp[e.ref] = {"x":[step], "y":[mem], "arg":e.arg}
      timestamps.append(int(e.st))
      step += 1
      mem += e.arg["nbytes"]
      if mem > peak: peak = mem
    if e.name == "free":
      timestamps.append(int(e.st))
      step += 1
      mem -= (removed:=temp.pop(e.ref))["arg"]["nbytes"]
      removed["x"].append(step)
      removed["y"].append(removed["y"][-1])
      for k,v in temp.items():
        if k > e.ref:
          v["x"] += [step, step]
          v["y"] += [v["y"][-1], v["y"][-1]-removed["arg"]["nbytes"]]
  for v in temp.values():
    v["x"].append(step)
    v["y"].append(v["y"][-1])
  return {"shapes":list(shps.values()), "peak":peak, "timestamps":timestamps}

def get_profile(profile:list[ProfileEvent]):
  # start by getting the time diffs
  for ev in profile:
    if isinstance(ev,ProfileDeviceEvent): device_ts_diffs[ev.device] = (ev.comp_tdiff, ev.copy_tdiff if ev.copy_tdiff is not None else ev.comp_tdiff)
  # map events per device
  dev_events:dict[str, list[tuple[int, int, float, DevEvent]]] = {}
  min_ts:int|None = None
  max_ts:int|None = None
  for ts,en,e in flatten_events(profile):
    dev_events.setdefault(e.device,[]).append((st:=int(ts), et:=int(en), float(en-ts), e))
    if min_ts is None or st < min_ts: min_ts = st
    if max_ts is None or et > max_ts: max_ts = et
  # return layout of per device events
  for events in dev_events.values(): events.sort(key=lambda v:v[0])
  dev_layout = {k:{"timeline":timeline_layout(v), "mem":mem_layout(v)} for k,v in dev_events.items()}
  return json.dumps({"layout":dev_layout, "st":min_ts, "et":max_ts}).encode("utf-8")

# ** GPU counter parsers

# Metal XCtrace

def parse_xml(stream:IO[bytes]) -> Generator[dict]:
  cols:list[str] = []
  id_cache:dict = {}
  for _,e in ET.iterparse(stream, events=("end",)):
    if (eid:=e.attrib.get("id")) is not None: id_cache[eid] = e.text
    if e.tag == "col": cols.append(unwrap(next(iter(e)).text))
    if e.tag == "row": yield {k:id_cache.get(v.attrib.get("ref"), v.text or v) for k,v in zip(cols, e)}

xctrace_cache:dict[str, list[dict]] = {}

def xctrace_export(schema:str) -> list[dict]:
  if (cret:=xctrace_cache.get(schema)) is not None: return cret
  try:
    proc = subprocess.Popen(["xctrace", "export", "--input", "/tmp/metal.trace", "--xpath",
                             f'/trace-toc/run[@number="1"]/data/table[@schema="{schema}"]'], stdout=subprocess.PIPE)
    xctrace_cache[schema] = ret = list(tqdm(parse_xml(unwrap(proc.stdout)), desc=f"parsing {schema}"))
    return ret
  finally:
    proc.terminate()
    proc.wait()

MTL_COUNTER_GROUPS = {"ALU":[11, 13, 15, 17, 19, 21, 23], "DRAM":[62, 64], "SRAM":[25]}

def get_metal_counters(st:int, et:int):
  # start by getting monotonic time at the start of trace
  time_info = list(xctrace_export("time-info"))[0]
  num, denom = [int(f.text) for f in time_info["timebase-info"].findall("mach-timebase-info-field")]
  start_time = Decimal(time_info["mabs-epoch"])*Decimal(num/denom)
  counter_info = {int(r["counter-id"]):r for r in xctrace_export("gpu-counter-info")}
  # calculate the mean counter values in the passed in time range
  acc:dict[int, int] = {}
  samples:dict[int, int] = {}
  for r in xctrace_export("gpu-counter-value"):
    sample_ts = (start_time+Decimal(r["timestamp"]))/Decimal(1e3)
    if sample_ts < st: continue
    if sample_ts > et: break
    if (counter_id:=r["counter-id"]) not in acc: acc[counter_id], samples[counter_id] = 0, 0
    acc[counter_id] += float(r["value"])
    samples[counter_id] += 1
  counter_agg = {k:v/samples[k] for k,v in acc.items()}
  return {"counter_info":counter_info, "counter_agg":counter_agg}

hw_counters = {"METAL":get_metal_counters}

def get_runtime_stats(key) -> list[dict]:
  ret:list[dict] = []
  for e in profile:
    if isinstance(e, ProfileRangeEvent) and e.en is not None and e.name == key:
      ret.append({"device":e.device, "duration":float(e.en-e.st), "stats":(hw_counters.get(e.device, lambda *_:None)(e.st, e.en))})
  return ret

# ** HTTP server

class Handler(BaseHTTPRequestHandler):
  def do_GET(self):
    ret, status_code, content_type = b"", 200, "text/html"

    if (url:=urlparse(self.path)).path == "/":
      with open(os.path.join(os.path.dirname(__file__), "index.html"), "rb") as f: ret = f.read()
    elif self.path.startswith(("/assets/", "/js/")) and '/..' not in self.path:
      try:
        with open(os.path.join(os.path.dirname(__file__), self.path.strip('/')), "rb") as f: ret = f.read()
        if url.path.endswith(".js"): content_type = "application/javascript"
        if url.path.endswith(".css"): content_type = "text/css"
      except FileNotFoundError: status_code = 404
    elif url.path == "/ctxs":
      if "ctx" in (q:=parse_qs(url.query)): return self.stream_json(get_details(contexts[1][int(q["ctx"][0])][int(q["idx"][0])]))
      ret, content_type = json.dumps(ctxs).encode(), "application/json"
    elif url.path == "/get_profile" and profile_ret is not None: ret, content_type = profile_ret, "application/json"
    else: status_code = 404

    # send response
    self.send_response(status_code)
    self.send_header('Content-Type', content_type)
    self.send_header('Content-Length', str(len(ret)))
    self.end_headers()
    return self.wfile.write(ret)

  def stream_json(self, source:Generator):
    try:
      self.send_response(200)
      self.send_header("Content-Type", "text/event-stream")
      self.send_header("Cache-Control", "no-cache")
      self.end_headers()
      for r in source:
        self.wfile.write(f"data: {json.dumps(r)}\n\n".encode("utf-8"))
        self.wfile.flush()
      self.wfile.write("data: END\n\n".encode("utf-8"))
    # pass if client closed connection
    except (BrokenPipeError, ConnectionResetError): return

# ** main loop

def reloader():
  mtime = os.stat(__file__).st_mtime
  while not stop_reloader.is_set():
    if mtime != os.stat(__file__).st_mtime:
      print("reloading server...")
      os.execv(sys.executable, [sys.executable] + sys.argv)
    time.sleep(0.1)

def load_pickle(path:str):
  if path is None or not os.path.exists(path): return None
  with open(path, "rb") as f: return pickle.load(f)

# NOTE: using HTTPServer forces a potentially slow socket.getfqdn
class TCPServerWithReuse(socketserver.TCPServer): allow_reuse_address = True

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument('--kernels', type=str, help='Path to kernels', default=None)
  parser.add_argument('--profile', type=str, help='Path profile', default=None)
  args = parser.parse_args()

  with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    if s.connect_ex(((HOST:="http://127.0.0.1").replace("http://", ""), PORT:=getenv("PORT", 8000))) == 0:
      raise RuntimeError(f"{HOST}:{PORT} is occupied! use PORT= to change.")
  stop_reloader = threading.Event()
  multiprocessing.current_process().name = "VizProcess"    # disallow opening of devices
  st = time.perf_counter()
  print("*** viz is starting")

  contexts, profile = load_pickle(args.kernels), load_pickle(args.profile)

  # NOTE: this context is a tuple of list[keys] and list[values]
  ctxs = get_metadata(*contexts[:2]) if contexts is not None else []

  profile_ret = get_profile(profile) if profile is not None else None

  server = TCPServerWithReuse(('', PORT), Handler)
  reloader_thread = threading.Thread(target=reloader)
  reloader_thread.start()
  print(f"*** started viz on {HOST}:{PORT}")
  print(colored(f"*** ready in {(time.perf_counter()-st)*1e3:4.2f}ms", "green"), flush=True)
  if len(getenv("BROWSER", "")) > 0: webbrowser.open(f"{HOST}:{PORT}{'/profiler' if contexts is None else ''}")
  try: server.serve_forever()
  except KeyboardInterrupt:
    print("*** viz is shutting down...")
    stop_reloader.set()
