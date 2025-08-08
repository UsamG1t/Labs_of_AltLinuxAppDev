#include "syscall.h"

unsigned long parse_arg(const char *syscall_name, char *arg)
{
  unsigned long num;
  char *endp = NULL;

  /* #hello - length of a string */
  if (arg[0] == '#') {
    return (unsigned long)strlen(arg + 1);
  }

  /* $0 - return value of a previous syscall */
  if (arg[0] == '$') {
    num = strtoul(arg + 1, &endp, 10);
    if (num < CMD_MAX - 1) {
      return (unsigned long)ret_values[num];
    }
  }

  /* Try to parse it as a number */
  endp = NULL;
  num = strtoul(arg, &endp, 0);
  if (errno == ERANGE) {
    errx(1, "%s: argument '%s' is out of range",
      syscall_name, arg);
  }
  if (endp && *endp == '\0') {
    /* strtoul succeeded */
    return num;
  }

  /* assume it is a string */
  /* unescape any \n at the end of the string */
  unescape_nl(arg);
  return (unsigned long)arg;
}

void echo(int argc, char **argv) {
  int i;

  for (i = 1; i < argc; i++) {
    if (argv[i][0] == '$' || argv[i][0] == '#') {
      printf("%ld\n", parse_arg(__func__, argv[i]));
    } else {
      printf("%s\n", argv[i]);
    }
  }
}

void parse_syscall(int cmd_no, char **cmd, int cmd_len)
{
  long syscall_num, ret = -1;
  char *syscall_name = cmd[0];

  /* Special case */
  if (streq(syscall_name, "echo")) {
    echo(cmd_len, cmd);
    ret_values[cmd_no] = 0; /* echo never fails */
    return;
  }

  syscall_num = lookup(syscall_name);
  if (syscall_num == -1) {
    errx(1, "unknown system call '%s'", syscall_name);
  }

  switch (cmd_len) {
  case 0:
    ret = syscall(syscall_num);
    break;
  case 1:
    ret = syscall(syscall_num, ARG(1));
    break;
  case 2:
    ret = syscall(syscall_num, ARG(1), ARG(2));
    break;
  case 3:
    ret = syscall(syscall_num, ARG(1), ARG(2), ARG(3));
    break;
  case 4:
    ret = syscall(syscall_num, ARG(1), ARG(2), ARG(3), ARG(4));
    break;
  case 5:
    ret = syscall(syscall_num, ARG(1), ARG(2), ARG(3), ARG(4), ARG(5));
    break;
  default:
    errx(1, "too many arguments for %s", syscall_name);
  }

  if (ret == -1) {
    errx(1, "%s failed: %s", syscall_name, strerror(errno));
  }

  ret_values[cmd_no] = (int)ret;
}

void split_cmdline(int argc, char **argv)
{
  int cmd_no = 0, cmd_len = 0, i;

  for (i = 0; i < argc; i++) {
    //printf("dbg: %s\n", argv[i]);
    if (cmd_no == CMD_MAX) {
      errx(1, "too many command (%d > %d)", cmd_no, CMD_MAX);
    }
    if (streq(argv[i], ",") || i == argc-1) {
      //printf("parse: len=%d  no=%d  start=%s\n", cmd_len, cmd_no, (argv + (i - cmd_len))[0]);
      parse_syscall(cmd_no, argv + (i - cmd_len), cmd_len);
      cmd_no++;
      cmd_len = 0;
    } else {
      cmd_len++;
    }
  }
}