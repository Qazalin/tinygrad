#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>

__attribute__((constructor))
static void preload_ctor(void) {
  const char msg[] = "[preload] loaded\n";
  syscall(SYS_write, 2, msg, sizeof(msg) - 1);
}
