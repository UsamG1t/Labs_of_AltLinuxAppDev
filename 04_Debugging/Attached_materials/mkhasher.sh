#!/bin/sh -E
PROG=`basename "$0"`
TEMP=$(getopt -o 'p:rvw:h' --long 'rooter,packages:,verbose,workdir:,help' -n "$PROG" -- "$@") || exit $?
eval set -- "$TEMP"
unset TEMP

WORKDIR="$HOME/hasher"
SHFLAGS=""
ALLFLAGS=""
MOUNTPOINTS=/proc,/dev/pts
ADDPACKAGES="vim-plugin-spec_alt-ftplugin vim-console tree rpm-utils"

USAGE="$PROG — run hsh-shell with network on and some packages installed

Usage: $PROG [OPTIONS] [SRC-RPM]
    -p|--packages Additional packages to install
    -r|--rooter   Run shell commands as «rooter» user
    -w|--workdir  Specify hasher hierarchy directory ($WORKDIR)
    -v|--verbose  Print more information
    -h|--help	  Print this help

SRC-RPM is source RPM file to build inside hasher.
When installed, it's build dependencies will be installed as well.
"
while true; do
  case "$1" in
    -p|--packages) ADDPACKAGES="$ADDPACKAGES $2"; shift;;
    -r|--rooter) SHFLAGS="$SHFLAGS --rooter";;
    -w|--workdir) WORKDIR="$2"; shift;;
    -v|--verbose) ALLFLAGS="$ALLFLAGS --verbose";;
    -h|--help) echo "$USAGE" >&2; exit 0;;
    --) shift; break;;
  esac
  shift
done

test -d "$WORKDIR/chroot" || hsh --workdir="$WORKDIR" --mountpoints=$MOUNTPOINTS $ALLFLAGS --init
if [ "$#" = 1 ]; then
  hsh-rebuild --workdir="$WORKDIR" $ALLFLAGS --install-only "$1"
  hsh-run --workdir="$WORKDIR" $ALLFLAGS -- rpm -i /usr/src/in/srpm/`basename "$1"`
fi

hsh-copy $ALLFLAGS --workdir="$WORKDIR" --rooter /etc/resolv.conf /etc/resolv.conf
hsh-install $ALLFLAGS --workdir="$WORKDIR" --mountpoints=$MOUNTPOINTS $ADDPACKAGES
share_network=1 hsh-shell $ALLFLAGS $SHFLAGS --workdir="$WORKDIR" --mountpoints=$MOUNTPOINTS
