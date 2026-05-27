// Generic HIP launch interposer for reverse engineering Torch/ROCm kernels.
// Build: clang++ -shared -fPIC -D__HIP_PLATFORM_AMD__ -I/opt/rocm/include extra/torch_rev/hiptrace.cpp -o libhiptrace.so -ldl
// Use:   HIPTRACE_DIR=trace LD_PRELOAD=$PWD/libhiptrace.so python repro.py
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <hip/hip_runtime_api.h>

#include <atomic>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <dlfcn.h>
#include <mutex>
#include <string>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <unordered_map>
#include <vector>

static std::atomic<uint64_t> dump_seq{0};
static std::mutex names_mu;
static std::unordered_map<void*, std::string> function_names;

static int env_int(const char *key, int dflt) {
  const char *value = getenv(key);
  return value ? atoi(value) : dflt;
}

static const char *env_str(const char *key, const char *dflt) {
  const char *value = getenv(key);
  return value && value[0] ? value : dflt;
}

static uint64_t tid() { return (uint64_t)syscall(SYS_gettid); }

static bool wanted(const char *name) {
  const char *filter = getenv("HIPTRACE_FILTER");
  return !filter || !filter[0] || (name && strstr(name, filter));
}

static std::string sanitize(const char *name) {
  if (!name || !name[0]) return "unknown";
  std::string out;
  out.reserve(128);
  for (const char *p = name; *p && out.size() < 120; p++) {
    char c = *p;
    bool ok = (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_' || c == '-';
    out.push_back(ok ? c : '_');
  }
  return out.empty() ? "unknown" : out;
}

static const char *remembered_name(hipFunction_t f) {
  std::lock_guard<std::mutex> lock(names_mu);
  auto it = function_names.find((void*)f);
  return it == function_names.end() ? nullptr : it->second.c_str();
}

static std::string symbol_name(const void *p) {
  Dl_info info;
  if (p && dladdr(p, &info) && info.dli_sname) return info.dli_sname;
  return "unknown";
}

struct ExtraArgs {
  const void *buf = nullptr;
  size_t size = 0;
};

static ExtraArgs parse_extra(void **extra) {
  ExtraArgs ret;
  if (!extra) return ret;
  for (int i = 0; i < 64 && extra[i] != HIP_LAUNCH_PARAM_END; i += 2) {
    if (extra[i] == HIP_LAUNCH_PARAM_BUFFER_POINTER) ret.buf = extra[i + 1];
    else if (extra[i] == HIP_LAUNCH_PARAM_BUFFER_SIZE && extra[i + 1]) ret.size = *(size_t*)extra[i + 1];
  }
  return ret;
}

static const char *arg_mode(void **kernel_params, void **extra) {
  ExtraArgs ea = parse_extra(extra);
  if (ea.buf && ea.size) return "extra(packed)";
  if (kernel_params) return "kernelParams(ptrs)";
  if (extra) return "extra(unknown)";
  return "none";
}

static void dump_kernargs(const char *tag, const char *kernel_name, const void *buf, size_t size) {
  if (!buf || !size || !env_int("HIPTRACE_DUMP", 1) || !wanted(kernel_name)) return;

  const char *dir = env_str("HIPTRACE_DIR", "trace");
  mkdir(dir, 0755);  // best effort

  char path[4096];
  uint64_t seq = dump_seq.fetch_add(1, std::memory_order_relaxed);
  std::string safe_name = sanitize(kernel_name);
  snprintf(path, sizeof(path), "%s/%d.%llu.%llu.%s.%s.kernargs.bin", dir, (int)getpid(),
           (unsigned long long)tid(), (unsigned long long)seq, tag ? tag : "launch", safe_name.c_str());

  FILE *f = fopen(path, "wb");
  if (!f) return;
  fwrite(buf, 1, size, f);
  fclose(f);
  if (env_int("HIPTRACE_PRINT", 1)) fprintf(stderr, "[hiptrace] wrote %zu bytes -> %s\n", size, path);
}

struct ReentryGuard {
  static thread_local int depth;
  bool active = false;
  ReentryGuard() { active = (depth++ == 0); }
  ~ReentryGuard() { depth--; }
  operator bool() const { return active; }
};
thread_local int ReentryGuard::depth = 0;

struct PendingArgs {
  dim3 grid{0, 0, 0};
  dim3 block{0, 0, 0};
  size_t shmem = 0;
  hipStream_t stream = nullptr;
  std::vector<unsigned char> buf;
  bool active = false;
};
static thread_local PendingArgs pending;

static hipError_t (*real_hipModuleGetFunction)(hipFunction_t*, hipModule_t, const char*) = nullptr;
static hipError_t (*real_hipModuleLaunchKernel)(hipFunction_t, unsigned int, unsigned int, unsigned int, unsigned int, unsigned int, unsigned int, unsigned int, hipStream_t, void**, void**) = nullptr;
static hipError_t (*real_hipExtModuleLaunchKernel)(hipFunction_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, size_t, hipStream_t, void**, void**, hipEvent_t, hipEvent_t, uint32_t) = nullptr;
static hipError_t (*real_hipLaunchKernel)(const void*, dim3, dim3, void**, size_t, hipStream_t) = nullptr;
static hipError_t (*real_hipLaunchKernel_spt)(const void*, dim3, dim3, void**, size_t, hipStream_t) = nullptr;
static hipError_t (*real_hipExtLaunchKernel)(const void*, dim3, dim3, void**, size_t, hipStream_t, hipEvent_t, hipEvent_t, int) = nullptr;
static hipError_t (*real_hipConfigureCall)(dim3, dim3, size_t, hipStream_t) = nullptr;
static hipError_t (*real_hipSetupArgument)(const void*, size_t, size_t) = nullptr;
static hipError_t (*real_hipLaunchByPtr)(const void*) = nullptr;

static void resolve_syms() {
  if (!real_hipModuleGetFunction) real_hipModuleGetFunction = (decltype(real_hipModuleGetFunction))dlsym(RTLD_NEXT, "hipModuleGetFunction");
  if (!real_hipModuleLaunchKernel) real_hipModuleLaunchKernel = (decltype(real_hipModuleLaunchKernel))dlsym(RTLD_NEXT, "hipModuleLaunchKernel");
  if (!real_hipExtModuleLaunchKernel) real_hipExtModuleLaunchKernel = (decltype(real_hipExtModuleLaunchKernel))dlsym(RTLD_NEXT, "hipExtModuleLaunchKernel");
  if (!real_hipLaunchKernel) real_hipLaunchKernel = (decltype(real_hipLaunchKernel))dlsym(RTLD_NEXT, "hipLaunchKernel");
  if (!real_hipLaunchKernel_spt) real_hipLaunchKernel_spt = (decltype(real_hipLaunchKernel_spt))dlsym(RTLD_NEXT, "hipLaunchKernel_spt");
  if (!real_hipExtLaunchKernel) real_hipExtLaunchKernel = (decltype(real_hipExtLaunchKernel))dlsym(RTLD_NEXT, "hipExtLaunchKernel");
  if (!real_hipConfigureCall) real_hipConfigureCall = (decltype(real_hipConfigureCall))dlsym(RTLD_NEXT, "hipConfigureCall");
  if (!real_hipSetupArgument) real_hipSetupArgument = (decltype(real_hipSetupArgument))dlsym(RTLD_NEXT, "hipSetupArgument");
  if (!real_hipLaunchByPtr) real_hipLaunchByPtr = (decltype(real_hipLaunchByPtr))dlsym(RTLD_NEXT, "hipLaunchByPtr");
}

__attribute__((constructor)) static void hiptrace_loaded() {
  if (env_int("HIPTRACE_PRINT", 1)) fprintf(stderr, "[hiptrace] loaded pid=%d\n", (int)getpid());
}

extern "C" hipError_t hipModuleGetFunction(hipFunction_t *function, hipModule_t module, const char *name) {
  resolve_syms();
  if (!real_hipModuleGetFunction) return hipErrorUnknown;
  hipError_t ret = real_hipModuleGetFunction(function, module, name);
  if (ret == hipSuccess && function && *function && name) {
    std::lock_guard<std::mutex> lock(names_mu);
    function_names[(void*)*function] = name;
  }
  if (env_int("HIPTRACE_PRINT", 1) && wanted(name)) fprintf(stderr, "[hiptrace] hipModuleGetFunction name=%s f=%p status=%d\n", name ? name : "<null>", function ? (void*)*function : nullptr, (int)ret);
  return ret;
}

extern "C" hipError_t hipModuleLaunchKernel(hipFunction_t f, unsigned int gx, unsigned int gy, unsigned int gz, unsigned int bx, unsigned int by, unsigned int bz, unsigned int shmem, hipStream_t stream, void **kernel_params, void **extra) {
  resolve_syms();
  if (!real_hipModuleLaunchKernel) return hipErrorUnknown;
  ReentryGuard guard;
  if (!guard) return real_hipModuleLaunchKernel(f, gx, gy, gz, bx, by, bz, shmem, stream, kernel_params, extra);
  const char *name = remembered_name(f);
  ExtraArgs ea = parse_extra(extra);
  if (env_int("HIPTRACE_PRINT", 1) && wanted(name)) fprintf(stderr, "[hiptrace] hipModuleLaunchKernel f=%p name=%s grid=(%u,%u,%u) block=(%u,%u,%u) shmem=%u argmode=%s\n", (void*)f, name ? name : "unknown", gx, gy, gz, bx, by, bz, shmem, arg_mode(kernel_params, extra));
  dump_kernargs("args_extra", name, ea.buf, ea.size);
  return real_hipModuleLaunchKernel(f, gx, gy, gz, bx, by, bz, shmem, stream, kernel_params, extra);
}

extern "C" hipError_t hipExtModuleLaunchKernel(hipFunction_t f, uint32_t gx, uint32_t gy, uint32_t gz, uint32_t lx, uint32_t ly, uint32_t lz, size_t shmem, hipStream_t stream, void **kernel_params, void **extra, hipEvent_t start, hipEvent_t stop, uint32_t flags) {
  resolve_syms();
  if (!real_hipExtModuleLaunchKernel) return hipErrorUnknown;
  ReentryGuard guard;
  if (!guard) return real_hipExtModuleLaunchKernel(f, gx, gy, gz, lx, ly, lz, shmem, stream, kernel_params, extra, start, stop, flags);
  const char *name = remembered_name(f);
  ExtraArgs ea = parse_extra(extra);
  if (env_int("HIPTRACE_PRINT", 1) && wanted(name)) fprintf(stderr, "[hiptrace] hipExtModuleLaunchKernel f=%p name=%s global=(%u,%u,%u) local=(%u,%u,%u) shmem=%zu flags=0x%x argmode=%s\n", (void*)f, name ? name : "unknown", gx, gy, gz, lx, ly, lz, shmem, flags, arg_mode(kernel_params, extra));
  dump_kernargs("args_extra", name, ea.buf, ea.size);
  return real_hipExtModuleLaunchKernel(f, gx, gy, gz, lx, ly, lz, shmem, stream, kernel_params, extra, start, stop, flags);
}

extern "C" hipError_t hipLaunchKernel(const void *func, dim3 grid, dim3 block, void **args, size_t shmem, hipStream_t stream) {
  resolve_syms();
  if (!real_hipLaunchKernel) return hipErrorUnknown;
  if (env_int("HIPTRACE_PRINT", 1)) fprintf(stderr, "[hiptrace] hipLaunchKernel func=%p name=%s grid=(%u,%u,%u) block=(%u,%u,%u) shmem=%zu\n", func, symbol_name(func).c_str(), grid.x, grid.y, grid.z, block.x, block.y, block.z, shmem);
  return real_hipLaunchKernel(func, grid, block, args, shmem, stream);
}

extern "C" hipError_t hipLaunchKernel_spt(const void *func, dim3 grid, dim3 block, void **args, size_t shmem, hipStream_t stream) {
  resolve_syms();
  if (!real_hipLaunchKernel_spt) return real_hipLaunchKernel ? hipLaunchKernel(func, grid, block, args, shmem, stream) : hipErrorUnknown;
  if (env_int("HIPTRACE_PRINT", 1)) fprintf(stderr, "[hiptrace] hipLaunchKernel_spt func=%p name=%s grid=(%u,%u,%u) block=(%u,%u,%u) shmem=%zu\n", func, symbol_name(func).c_str(), grid.x, grid.y, grid.z, block.x, block.y, block.z, shmem);
  return real_hipLaunchKernel_spt(func, grid, block, args, shmem, stream);
}

extern "C" hipError_t hipExtLaunchKernel(const void *func, dim3 grid, dim3 block, void **args, size_t shmem, hipStream_t stream, hipEvent_t start, hipEvent_t stop, int flags) {
  resolve_syms();
  if (!real_hipExtLaunchKernel) return hipErrorUnknown;
  if (env_int("HIPTRACE_PRINT", 1)) fprintf(stderr, "[hiptrace] hipExtLaunchKernel func=%p name=%s grid=(%u,%u,%u) block=(%u,%u,%u) shmem=%zu flags=0x%x\n", func, symbol_name(func).c_str(), grid.x, grid.y, grid.z, block.x, block.y, block.z, shmem, flags);
  return real_hipExtLaunchKernel(func, grid, block, args, shmem, stream, start, stop, flags);
}

extern "C" hipError_t hipConfigureCall(dim3 grid, dim3 block, size_t shmem, hipStream_t stream) {
  resolve_syms();
  if (!real_hipConfigureCall) return hipErrorUnknown;
  pending.grid = grid; pending.block = block; pending.shmem = shmem; pending.stream = stream; pending.buf.clear(); pending.active = true;
  return real_hipConfigureCall(grid, block, shmem, stream);
}

extern "C" hipError_t hipSetupArgument(const void *arg, size_t size, size_t offset) {
  resolve_syms();
  if (!real_hipSetupArgument) return hipErrorUnknown;
  if (pending.active) {
    size_t need = offset + size;
    if (pending.buf.size() < need) pending.buf.resize(need);
    if (arg && size) memcpy(pending.buf.data() + offset, arg, size);
  }
  return real_hipSetupArgument(arg, size, offset);
}

extern "C" hipError_t hipLaunchByPtr(const void *func) {
  resolve_syms();
  if (!real_hipLaunchByPtr) return hipErrorUnknown;
  std::string name = symbol_name(func);
  if (env_int("HIPTRACE_PRINT", 1)) fprintf(stderr, "[hiptrace] hipLaunchByPtr func=%p name=%s grid=(%u,%u,%u) block=(%u,%u,%u) shmem=%zu\n", func, name.c_str(), pending.grid.x, pending.grid.y, pending.grid.z, pending.block.x, pending.block.y, pending.block.z, pending.shmem);
  if (pending.active && !pending.buf.empty()) dump_kernargs("by_ptr", name.c_str(), pending.buf.data(), pending.buf.size());
  hipError_t ret = real_hipLaunchByPtr(func);
  pending.active = false;
  return ret;
}
