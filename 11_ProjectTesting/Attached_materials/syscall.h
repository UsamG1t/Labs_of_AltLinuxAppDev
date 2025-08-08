#include <err.h>
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define _DEFAULT_SOURCE
#define SYSTAB_LEN 364

#ifndef VERSION
#define VERSION "unknown"
#endif

#define LEN(x)      (sizeof(x) / sizeof(*x))
#define streq(a,b)  (strcmp(a,b) == 0)
#define ARG(n)    parse_arg(syscall_name, cmd[n])

#define CMD_MAX   20  /* maximum number of commands per invocation */
static int ret_values[CMD_MAX];

typedef struct syscall {
  const char *name;
  long code;
} Syscall;

extern Syscall systab[SYSTAB_LEN + 1];

void usage();
int scomp(const void *m1, const void *m2);
long lookup(const char *name);
void unescape_nl(char *str);
void dump_ret_values(void);

void echo(int argc, char **argv);
unsigned long parse_arg(const char *syscall_name, char *arg);
void parse_syscall(int cmd_no, char **cmd, int cmd_len);
void split_cmdline(int argc, char **argv);

