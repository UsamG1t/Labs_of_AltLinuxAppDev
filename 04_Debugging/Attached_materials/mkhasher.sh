#!/bin/sh -E
PROG=mkhasher
TEMP=$(getopt -o 'ip:rvw:h' --long 'init,rooter,packages:,verbose,workdir:,help' -n "$PROG" -- "$@") || exit $?
eval set -- "$TEMP"
unset TEMP

ACTION="shell"
WORKDIR="$HOME/hasher"
ADDFLAGS=""
MOUNTPOINTS=/proc
ADDPACKAGES="vim-plugin-spec_alt-ftplugin vim-console tree rpm-utils"

USAGE="$PROG — run hsh-shell with network on and some packages installed

Usage: $PROG [OPTIONS] [SRC-RPM]
    -i|--init     Initialize hasher directory before entering shell
    -p|--packages Additional packages to install
    -r|--rooter   Run shell commands as «rooter» user
    -w|--workdir  Specify hasher hierarchy directory ($WORKDIR)
    -v|--verbose  Print more information
    -h|--help	  Print this help

SRC-RPM is source RPM file to build inside hasher.
"
while true; do
  case "$1" in
    -i|--init) ACTION="init $ACTION";;
    -p|--packages) ADDPACKAGES="$ADDPACKAGES $2"; shift;;
    -r|--rooter) ADDFLAGS="$ADDFLAGS --rooter";;
    -w|--workdir) WORKDIR="$2"; shift;;
    -v|--verbose) ADDFLAGS="$ADDFLAGS --verbose";;
    -h|--help) echo "$USAGE" >&2; exit 0;;
    --) shift; break;;
  esac
  shift
done

test -z "$1" -a -z "$ADDFLAGS" && ACTION="shell"
test -n "$1" && ACTION="build"
for ACT in $ACTION; do
  case $ACT in
    build) hsh --workdir="$WORKDIR" --mountpoints=$MOUNTPOINTS $ADDFLAGS --lazy "$1"; exit $? ;;
    init) hsh --workdir="$WORKDIR" --mountpoints=$MOUNTPOINTS $ADDFLGS --init;;
    shell) hsh-copy --rooter /etc/resolv.conf /etc/resolv.conf
           hsh-install --workdir="$WORKDIR" --mountpoints=$MOUNTPOINTS $ADDPACKAGES
           share_network=1 hsh-shell $ADDFLAGS --workdir="$WORKDIR" --mountpoints=$MOUNTPOINTS;;
  esac
done
