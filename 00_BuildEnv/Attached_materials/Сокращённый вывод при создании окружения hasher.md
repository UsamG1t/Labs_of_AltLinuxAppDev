
```console
hsh: Executing wrapper: systemd-run  --user --scope --same-dir --property=Delegate=yes --send-sighup --collect  
Running as unit: run-p8052-i8352.scope; invocation ID: 4eed2a0919cc4c27bb1bc0b063dc7735  
hsh: changed working directory to `/home/papillon_jaune/hasher'  
hsh: Locked working directory `/home/papillon_jaune/hasher'  

<...>

Чтение списков пакетов...  
Построение дерева зависимостей...  
Selected version fakeroot#1.29-alt3:p11+348779.600.1.1@1716502783 for fakeroot>=0:0.7.3  
Следующие дополнительные пакеты будут установлены:  
 bash       getopt            libelf        libpopt             sh  
 bash5      glibc-core        libgcc1       libreadline8        sh5  
 bashrc     glibc-preinstall  libgcrypt20   librpm7             terminfo  
 bzlib      grep              libgmp10      libselinux          zlib  
 coreutils  libacl            libgpg-error  libsha1detectcoll1  
 fakeroot   libattr           liblua5.3     libtinfo6  
 findutils  libcap            liblzma       libzstd  
 gawk       libdb4.7          libpcre2      sed  
Следующие НОВЫЕ пакеты будут установлены:  
 bash        gawk              libdb4.7      libpcre2            rpm  
 bash5       getopt            libelf        libpopt             sed  
 bashrc      glibc-core        libgcc1       libreadline8        setup  
 bzlib       glibc-preinstall  libgcrypt20   librpm7             sh  
 coreutils   grep              libgmp10      libselinux          sh5  
 fakeroot    libacl            libgpg-error  libsha1detectcoll1  terminfo  
 filesystem  libattr           liblua5.3     libtinfo6           zlib  
 findutils   libcap            liblzma       libzstd  
<...>
Завершено.  

hsh-initroot: Calculated package file list.  
hsh-initroot: Generated initial package file list.  
Чтение списков пакетов...  
Построение дерева зависимостей...  
<...>
Следующие дополнительные пакеты будут установлены:  
 alt-os-release                      libmount  
 autoconf                            libmpc3  
 autoconf-common                     libmpfr6  
 autoconf_2.71                       libncursesw6  
 automake                            libpam0  
 automake-common                     libpasswdqc  
 automake_1.16                       libpcre2  
 bash                                libpopt  
 bash5                               libproc2_1  
 bashrc                              libreadline8  
 binutils                            librpm  
 bison                               librpm7  
 bison-runtime                       librpmbuild  
 branding-xalt-kworkstation-release  librpmbuild7  
 bzip2                               libseccomp  
 bzlib                               libselinux  
 chkconfig                           libsframe1  
 common-licenses                     libsha1detectcoll1  
 control                             libshell  
 coreutils                           libsmartcols  
 cpio                                libstdc++6  
 cpp                                 libtcb  
 cpp13                               libtic6  
 debugedit                           libtinfo6  
 diffutils                           libtool  
 elfutils                            libtool-common  
 emacs-base                          libtool_2.4  
 etcskel                             libtsan2  
 file                                libubsan1  
 filesystem                          libudev1  
 findutils                           libunistring2  
 gawk                                libuuid  
 gcc                                 libvtv0  
 gcc-common                          libxml2  
 gcc13                               libzio  
 getopt                              libzstd  
 gettext                             m4  
 gettext-tools                       make  
 glib2                               nss_tcb  
 glib2-locales                       pam
 glibc                               pam-config  
 glibc-core                          pam-config-control  
 glibc-devel                         pam0_mktemp  
 glibc-gconv-modules                 pam0_passwdqc  
 glibc-kernheaders                   pam0_tcb  
 glibc-kernheaders-generic           pam0_userpass  
 glibc-kernheaders-x86               passwdqc-control  
 glibc-locales                       patch  
 glibc-nss                           perl-CPAN-Meta-Requirements  
 glibc-preinstall                    perl-base  
 glibc-pthread                       perl-parent  
 glibc-timezones                     perl-threads  
 glibc-utils                         pkg-config  
 gnu-config                          procps  
 grep                                psmisc  
 gzip                                rootfiles  
 iconv                               rpm  
 info-install                        rpm-build  
 kernel-headers-common               rpm-build-file  
 libacl                              rpm-build-perl  
 libasan8                            rpm-macros-python  
 libasm                              rpm-macros-python3  
 libatomic1                          rpm-macros-systemd  
 libattr                             rpmspec  
 libaudit1                           sed  
 libbeecrypt7                        service  
 libblkid                            setarch  
 libcap                              setup  
 libcap-ng                           sh  
 libcap-utils                        sh5  
 libcrypt                            shadow-convert  
 libcrypt-devel                      shadow-utils  
 libctf-nobfd0                       sisyphus_check  
 libdb4.7                            sysvinit-utils  
 libdw                               tar  
 libelf                              tcb-utils  
 libffi8                             terminfo  
 libgcc1                             termutils  
 libgcrypt20                         tzdata  
 libgmp10                            util-linux  
 libgpg-error                        util-linux-control  
 libgpm                              vim-minimal  
 libhwasan0                          vitmp  
 libitm1                             which  
 liblsan0                            xml-common  
 liblua5.3                           xz  
 liblzma                             zlib  
 libmagic                            zstd
 
 Следующие НОВЫЕ пакеты будут установлены:
  alt-os-release                      libmount
  autoconf                            libmpc3
  autoconf-common                     libmpfr6
  autoconf_2.71                       libncursesw6
  automake                            libpam0
  automake-common                     libpasswdqc
  automake_1.16                       libpcre2
  basesystem                          libpopt
  bash                                libproc2_1
  bash5                               libreadline8
  bashrc                              librpm
  binutils                            librpm7
  bison                               librpmbuild
  bison-runtime                       librpmbuild7
  branding-xalt-kworkstation-release  libseccomp
  bzip2                               libselinux
  bzlib                               libsframe1
  chkconfig                           libsha1detectcoll1
  common-licenses                     libshell
  control                             libsmartcols
  coreutils                           libstdc++6
  cpio                                libtcb
  cpp                                 libtic6
  cpp13                               libtinfo6
  debugedit                           libtool
  diffutils                           libtool-common
  elfutils                            libtool_2.4
  emacs-base                          libtsan2
  etcskel                             libubsan1
  file                                libudev1
  filesystem                          libunistring2
  findutils                           libuuid
  gawk                                libvtv0
  gcc                                 libxml2
  gcc-common                          libzio
  gcc13                               libzstd
  getopt                              m4
  gettext                             make
  gettext-tools                       nss_tcb
  glib2                               pam
  glib2-locales                       pam-config
  glibc                               pam-config-control
  glibc-core                          pam0_mktemp
  glibc-devel                         pam0_passwdqc
  glibc-gconv-modules                 pam0_tcb
  glibc-kernheaders                   pam0_userpass
  glibc-kernheaders-generic           passwdqc-control
  glibc-kernheaders-x86               patch
  glibc-locales                       perl-CPAN-Meta-Requirements
  glibc-nss                           perl-base
  glibc-preinstall                    perl-parent
glibc-pthread                       perl-threads  
 glibc-timezones                     pkg-config  
 glibc-utils                         procps  
 gnu-config                          psmisc  
 grep                                rootfiles  
 gzip                                rpm  
 iconv                               rpm-build  
 info-install                        rpm-build-file  
 kernel-headers-common               rpm-build-perl  
 libacl                              rpm-macros-python  
 libasan8                            rpm-macros-python3  
 libasm                              rpm-macros-systemd  
 libatomic1                          rpmspec  
 libattr                             sed  
 libaudit1                           service  
 libbeecrypt7                        setarch  
 libblkid                            setup  
 libcap                              sh  
 libcap-ng                           sh5  
 libcap-utils                        shadow-convert  
 libcrypt                            shadow-utils  
 libcrypt-devel                      sisyphus_check  
 libctf-nobfd0                       sysvinit-utils  
 libdb4.7                            tar  
 libdw                               tcb-utils  
 libelf                              terminfo  
 libffi8                             termutils  
 libgcc1                             time  
 libgcrypt20                         tzdata  
 libgmp10                            util-linux  
 libgpg-error                        util-linux-control  
 libgpm                              vim-minimal  
 libhwasan0                          vitmp  
 libitm1                             which  
 liblsan0                            xml-common  
 liblua5.3                           xz  
 liblzma                             zlib  
 libmagic                            zstd  
0 будет обновлено, 178 новых установлено, 0 пакетов будет удалено и 0 не будет обновлено.  
Необходимо получить 73,3MB/86,2MB архивов.  
После распаковки потребуется дополнительно 514MB дискового пространства.  
<...>
Завершено.

Running /usr/lib/rpm/posttrans-filetriggers hsh-initroot: RPM database updated.  
<86>Jul  1 09:29:43 groupadd[10102]: group added to /etc/group: name=caller, GID=1000^M  
<86>Jul  1 09:29:43 groupadd[10102]: group added to /etc/gshadow: name=caller^M  
<86>Jul  1 09:29:43 groupadd[10102]: new group: name=caller, GID=1000^M  
<86>Jul  1 09:29:43 useradd[10108]: new user: name=caller, UID=1000, GID=1000, home=/, shell=/bin/bash, from=none^M  
<86>Jul  1 09:29:43 groupadd[10117]: group added to /etc/group: name=rooter, GID=1001^M  
<86>Jul  1 09:29:43 groupadd[10117]: group added to /etc/gshadow: name=rooter^M  
<86>Jul  1 09:29:43 groupadd[10117]: new group: name=rooter, GID=1001^M  
<86>Jul  1 09:29:43 useradd[10123]: new user: name=rooter, UID=1001, GID=1001, home=/root, shell=/bin/bash, from=none^M  
<86>Jul  1 09:29:43 groupadd[10132]: group added to /etc/group: name=builder, GID=1002^M  
<86>Jul  1 09:29:43 groupadd[10132]: group added to /etc/gshadow: name=builder^M
<86>Jul  1 09:29:43 groupadd[10132]: new group: name=builder, GID=1002^M  
<86>Jul  1 09:29:43 useradd[10138]: new user: name=builder, UID=1002, GID=1002, home=/usr/src, shell=/bin/bash, from=none^M  
mode of '/usr/src' changed from 0755 (rwxr-xr-x) to 1777 (rwxrwxrwt)  
hsh-initroot: First time initialization complete.  
hsh-initroot: RPM database archivation complete.  
hsh-initroot: Chroot archivation complete.

mkdir: created directory '/usr/src/tmp'  
mkdir: created directory '/usr/src/RPM'  
mkdir: created directory '/usr/src/RPM/BUILD'  
mkdir: created directory '/usr/src/RPM/SOURCES'  
mkdir: created directory '/usr/src/RPM/SPECS'  
mkdir: created directory '/usr/src/RPM/SRPMS'  
mkdir: created directory '/usr/src/RPM/RPMS'  
mkdir: created directory '/usr/src/RPM/RPMS/noarch'  
hsh-initroot: Created RPM build directory tree.
```
