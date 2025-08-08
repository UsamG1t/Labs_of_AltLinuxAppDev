#include "syscall.h"

int main(int argc, char **argv)
{
  int repeat = 1, skip = 1;

  if (argc <= 1) {
    usage();
    return 0;
  }

  /* arguments */
  if (argv[1][0] == '-') {
    /* help */
    if (streq(argv[1], "-h") || streq(argv[1], "--help")) {
      usage();
      return 0;
    }

    /* version */
    if (streq(argv[1], "-v") || streq(argv[1], "--version")) {
      puts("syscall version "VERSION);
      return 0;
    }

    /* Handle -n option */
    repeat = atoi(argv[1] + 1);
    if (repeat < 1) {
      errx(1, "option -<n> must be between 1 and %d", INT_MAX);
    }
    if (argc <= 3) {
      usage();
      return 1;
    }
    skip++;
  }

  memset(ret_values, -1, sizeof ret_values);

  while (repeat--) {
    split_cmdline(argc - skip, argv + skip);
  }

  return 0;
}
