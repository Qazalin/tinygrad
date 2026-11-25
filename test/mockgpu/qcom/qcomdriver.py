"""Mock Qualcomm KGSL driver (/dev/kgsl-3d0) + Adreno 630 PM4 command processor for DEV=MOCK+QCOM."""
import ctypes, mmap, time
from tinygrad.helpers import to_mv
from tinygrad.runtime.autogen import kgsl, libc, mesa
from test.mockgpu.driver import VirtDriver, VirtFile, VirtFileDesc
from test.mockgpu.qcom.emu import run_qcom_asm

def _f(val:int, name:str) -> int: return (val & getattr(mesa, f"{name}__MASK")) >> getattr(mesa, f"{name}__SHIFT")
_IC = {k: ((d << 30) | (ctypes.sizeof(st) << 16) | (b << 8) | nr) & 0xffffffff for k in (
  "DRAWCTXT_CREATE", "SETPROPERTY", "DEVICE_GETPROPERTY", "GPUOBJ_ALLOC", "GPUOBJ_FREE", "MAP_USER_MEM", "SHAREDMEM_FREE",
  "GPU_COMMAND", "CMDSTREAM_READTIMESTAMP_CTXTID", "DEVICE_WAITTIMESTAMP_CTXTID") for d, b, nr, st in (getattr(kgsl, f"IOCTL_KGSL_{k}").args,)}

class AdrenoPM4Executor:
  def __init__(self):
    self.regs:dict[int, int] = {}
    self.const_addr = self.const_sz = 0
  def _r(self, r:int) -> int: return self.regs.get(r, 0)
  def _r64(self, r:int) -> int: return self._r(r) | (self._r(r + 1) << 32)

  def execute_ib(self, gpuaddr:int, size_bytes:int) -> None:
    dwords, i = to_mv(gpuaddr, size_bytes).cast("I"), 0
    while i < len(dwords):
      hdr, i = dwords[i], i + 1
      if hdr == 0: continue
      if (pt := hdr & 0xf0000000) == mesa.CP_TYPE4_PKT:
        cnt, reg = hdr & 0x7f, (hdr >> 8) & 0x3ffff
        for k in range(cnt): self.regs[reg + k] = dwords[i + k]
      elif pt == mesa.CP_TYPE7_PKT:
        cnt, op = hdr & 0x3fff, (hdr >> 16) & 0x7f
        self._exec_pkt7(op, [dwords[i + k] for k in range(cnt)])
      else: raise RuntimeError(f"AdrenoPM4: unsupported packet header {hdr:#010x}")
      i += cnt

  def _exec_pkt7(self, op:int, p:list[int]) -> None:
    if op in (mesa.CP_WAIT_FOR_IDLE, mesa.CP_WAIT_MEM_WRITES, mesa.CP_SET_MARKER, mesa.CP_NOP, mesa.CP_WAIT_REG_MEM): return
    if op == mesa.CP_EVENT_WRITE:
      if len(p) >= 4 and (p[0] & 0xff) == mesa.CACHE_FLUSH_TS and (addr := p[1] | (p[2] << 32)): to_mv(addr, 4).cast("I")[0] = p[3]
    elif op == mesa.CP_REG_TO_MEM and len(p) >= 3:
      if (reg := _f(p[0], "CP_REG_TO_MEM_0_REG")) != mesa.REG_A6XX_CP_ALWAYS_ON_COUNTER:
        raise RuntimeError(f"AdrenoPM4: unsupported CP_REG_TO_MEM reg {reg:#x}")
      if (addr := p[1] | (p[2] << 32)): to_mv(addr, 8).cast("Q")[0] = int(time.perf_counter() * 19.2e6)
    elif op == mesa.CP_LOAD_STATE6_FRAG:
      if len(p) < 3: raise RuntimeError(f"AdrenoPM4: short CP_LOAD_STATE6_FRAG len={len(p)}")
      st_type, st_src = _f(p[0], "CP_LOAD_STATE6_0_STATE_TYPE"), _f(p[0], "CP_LOAD_STATE6_0_STATE_SRC")
      st_blk = _f(p[0], "CP_LOAD_STATE6_0_STATE_BLOCK")
      if st_src != mesa.SS6_INDIRECT or _f(p[0], "CP_LOAD_STATE6_0_DST_OFF") != 0:
        raise NotImplementedError(f"AdrenoPM4: unsupported CP_LOAD_STATE6_FRAG st_src={st_src}")
      if (st_type, st_blk) == (mesa.ST_CONSTANTS, mesa.SB6_CS_SHADER):
        self.const_addr, self.const_sz = p[1] | (p[2] << 32), _f(p[0], "CP_LOAD_STATE6_0_NUM_UNIT") * 16
      elif (st_type, st_blk) not in ((mesa.ST_SHADER, mesa.SB6_CS_SHADER), (mesa.ST_SHADER, mesa.SB6_CS_TEX),
                                     (mesa.ST_CONSTANTS, mesa.SB6_CS_TEX), (mesa.ST6_UAV, mesa.SB6_CS_SHADER)):
        raise NotImplementedError(f"AdrenoPM4: unsupported CP_LOAD_STATE6_FRAG ({st_type}, {st_blk})")
    elif op == mesa.CP_EXEC_CS:
      gx, gy, gz = (p[i + 1] if len(p) > i + 1 else self._r(getattr(mesa, f"REG_A6XX_SP_CS_KERNEL_GROUP_{d}")) for i, d in enumerate("XYZ"))
      lx, ly, lz = (_f(self._r(mesa.REG_A6XX_SP_CS_NDRANGE_0), f"A6XX_SP_CS_NDRANGE_0_LOCALSIZE{d}") + 1 for d in "XYZ")
      prg_off, instr_sz = self._r(mesa.REG_A6XX_SP_CS_PROGRAM_COUNTER_OFFSET), self._r(mesa.REG_A6XX_SP_CS_INSTR_SIZE)
      if instr_sz == 0 or (code_sz := instr_sz * 128 - prg_off * 8) <= 0:
        raise RuntimeError(f"AdrenoPM4: invalid SP_CS_INSTR_SIZE={instr_sz} prg_off={prg_off}")
      cfg, ccfg0 = self._r(mesa.REG_A6XX_SP_CS_CONFIG), self._r(mesa.REG_A6XX_SP_CS_CONST_CONFIG_0)
      n_tex, n_ibo = _f(cfg, "A6XX_SP_CS_CONFIG_NTEX"), _f(cfg, "A6XX_SP_CS_CONFIG_NUAV")
      run_qcom_asm(
        self._r64(mesa.REG_A6XX_SP_CS_BASE) + prg_off * 8, code_sz, gx, gy, gz, lx, ly, lz, const_addr=self.const_addr, const_sz=self.const_sz,
        tex_addr=self._r64(mesa.REG_A6XX_SP_CS_TEXMEMOBJ_BASE) if n_tex else 0, n_tex=n_tex,
        ibo_addr=self._r64(mesa.REG_A6XX_SP_CS_UAV_BASE) if n_ibo else 0, n_ibo=n_ibo,
        shmem=(_f(self._r(mesa.REG_A6XX_SP_CS_CNTL_1), "A6XX_SP_CS_CNTL_1_SHARED_SIZE") + 1) * 1024,
        pvtmem=_f(self._r(mesa.REG_A6XX_SP_CS_PVT_MEM_PARAM), "A6XX_SP_CS_PVT_MEM_PARAM_MEMSIZEPERITEM") * 512,
        mergedregs=bool(self._r(mesa.REG_A6XX_SP_CS_CNTL_0) & mesa.A6XX_SP_CS_CNTL_0_MERGEDREGS),
        wgid_reg=_f(ccfg0, "A6XX_SP_CS_CONST_CONFIG_0_WGIDCONSTID"), lid_reg=_f(ccfg0, "A6XX_SP_CS_CONST_CONFIG_0_LOCALIDREGID"))
    else: raise RuntimeError(f"AdrenoPM4: unsupported TYPE7 opcode {op:#x}")

class KGSLFileDesc(VirtFileDesc):
  def __init__(self, fd:int, driver:"QCOMDriver"):
    super().__init__(fd)
    self.driver = driver

  def mmap(self, st, sz, prot, flags, fd, off):
    if st != 0 or (flags & 0x10): raise NotImplementedError(f"QCOMDriver: fixed/hint mmap st={st:#x} flags={flags:#x} not supported")
    if (obj := self.driver.objs.get(off // 0x1000)) is None: raise RuntimeError(f"QCOMDriver: mmap of unknown gpuobj id {off // 0x1000}")
    if sz > obj[1]: raise ValueError(f"QCOMDriver: mmap size {sz} exceeds gpuobj size {obj[1]}")
    return obj[0]

  def ioctl(self, fd, req, argp):
    code, drv = req & 0xffffffff, self.driver
    if code == _IC["DRAWCTXT_CREATE"]:
      drv.next_ctx += 1
      kgsl.struct_kgsl_drawctxt_create.from_address(argp).drawctxt_id = drv.next_ctx
    elif code in (_IC["SETPROPERTY"], _IC["SHAREDMEM_FREE"]): pass
    elif code == _IC["DEVICE_GETPROPERTY"]:
      gp = kgsl.struct_kgsl_device_getproperty.from_address(argp)
      if gp.type != kgsl.KGSL_PROP_DEVICE_INFO: raise RuntimeError(f"QCOMDriver: unsupported KGSL property {gp.type:#x}")
      ctypes.cast(gp.value, ctypes.POINTER(kgsl.struct_kgsl_devinfo)).contents.chip_id = 0x06030001  # Adreno 630
    elif code == _IC["GPUOBJ_ALLOC"]:
      ga = kgsl.struct_kgsl_gpuobj_alloc.from_address(argp)
      sz = int(ga.mmapsize or ga.size)
      va = libc.mmap(0, sz, mmap.PROT_READ | mmap.PROT_WRITE, mmap.MAP_PRIVATE | mmap.MAP_ANONYMOUS, -1, 0)
      if va == (1 << 64) - 1: raise MemoryError(f"QCOMDriver: mmap failed for size {sz}")
      drv.next_obj += 1
      ga.id, ga.va_len, drv.objs[drv.next_obj] = drv.next_obj, sz, (va, sz)
    elif code == _IC["GPUOBJ_FREE"]:
      if (obj := drv.objs.pop(kgsl.struct_kgsl_gpuobj_free.from_address(argp).id, None)) is not None: libc.munmap(*obj)
    elif code == _IC["MAP_USER_MEM"]:
      um = kgsl.struct_kgsl_map_user_mem.from_address(argp)
      um.gpuaddr = um.hostptr
    elif code == _IC["GPU_COMMAND"]:
      if drv.last_error is not None: return -1
      gc = kgsl.struct_kgsl_gpu_command.from_address(argp)
      try:
        for ci in range(gc.numcmds):
          cmd = kgsl.struct_kgsl_command_object.from_address(gc.cmdlist + ci * gc.cmdsize)
          if cmd.flags & kgsl.KGSL_CMDLIST_IB: drv.pm4.execute_ib(int(cmd.gpuaddr), int(cmd.size))
      except Exception as e:
        drv.last_error = e
        return -1
      drv.timestamp += 1
      gc.timestamp = drv.timestamp
    elif code in (_IC["CMDSTREAM_READTIMESTAMP_CTXTID"], _IC["DEVICE_WAITTIMESTAMP_CTXTID"]):
      if drv.last_error is not None:
        err, drv.last_error = drv.last_error, None
        raise err
      if code == _IC["CMDSTREAM_READTIMESTAMP_CTXTID"]:
        kgsl.struct_kgsl_cmdstream_readtimestamp_ctxtid.from_address(argp).timestamp = drv.timestamp
    else: raise RuntimeError(f"QCOMDriver: unhandled KGSL ioctl {code:#x}")
    return 0

class QCOMDriver(VirtDriver):
  def __init__(self):
    super().__init__()
    self.next_fd, self.next_ctx, self.next_obj, self.timestamp = 900, 0, 0, 0
    self.last_error:Exception|None = None
    self.objs:dict[int, tuple[int, int]] = {}
    self.pm4 = AdrenoPM4Executor()
    self.tracked_files.append(VirtFile("/dev/kgsl-3d0", KGSLFileDesc))
  def open(self, name, flags, mode, fdcls):
    self.next_fd += 1
    return KGSLFileDesc(self.next_fd, self)
