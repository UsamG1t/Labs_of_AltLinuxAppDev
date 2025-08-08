#include "syscall.h"

void usage()
{
  puts("usage: syscall [-<n>] name [args...] [, name [args...]]...");
}

int scomp(const void *m1, const void *m2)
{
  Syscall *sys1 = (Syscall *)m1;
  Syscall *sys2 = (Syscall *)m2;
  return strcmp(sys1->name, sys2->name);
}

long lookup(const char *name)
{
  Syscall key, *res;
  key.name = name;

  res = bsearch(&key, systab, LEN(systab), sizeof key, scomp);
  if (res == NULL) {
    errx(1, "unknown system call: %s", name);
  }

  return res->code;
}

/* Quick and dirty way to unescape \n at the end of strings */
void unescape_nl(char *str) {
  size_t end = strlen(str) - 1;

  while (str[end] == 'n' && str[end-1] == '\\') {
    str[end-1] = '\n';
    str[end] = '\0';
    end -= 2;
  }
}

/* for debugging */
void dump_ret_values(void) {
  for (int i = 0; i < CMD_MAX; i++) {
    printf("%0d  %d\n", i, ret_values[i]);
  }
}
