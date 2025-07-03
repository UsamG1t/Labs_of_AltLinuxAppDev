Данная лабораторная работа продолжает повествование главы о [сборочном окружении и зависимостях при разработке](https://github.com/UsamG1t/Methodics_of_LinuxAppDev/blob/master/Methodical_manual/00_BuildEnv/0.%20%D0%A1%D0%B1%D0%BE%D1%80%D0%BE%D1%87%D0%BD%D0%BE%D0%B5%20%D0%BE%D0%BA%D1%80%D1%83%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5%20%D0%B8%20%D0%B7%D0%B0%D0%B2%D0%B8%D1%81%D0%B8%D0%BC%D0%BE%D1%81%D1%82%D0%B8%20%D0%BF%D1%80%D0%B8%20%D1%80%D0%B0%D0%B7%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%BA%D0%B5.md).

---

Итогом в рамках разработки под Linux является ***пакет***. Пакетом называются ресурсы, необходимые для установки и интеграции в систему некоторого компонента (архив файлов, до- и послеустановочные сценарии, информация о пакете и его сопровождающем), объединённые в одном файле. Основной материал курса направлен на изучение парадигм и технологий локальной разработки. Лабораторные работы будут объединять полученные знания в рамках сборки пакетов программ. В линейке дистрибутивов Альт используется формат пакетов [RPM](https://docs.altlinux.org/ru-RU/alt-platform/10.1/html-single/alt-platform/index.html#id864). Различают `.rpm`-пакеты, непосредственно предназначенные для установки компонентов в всистему, и `.src.rpm`-пакеты, содержащие все необходимые для сборки `.rpm`-пакетв данные — исходные тексты и сценарии сборки.

# `Hasher by ALT Linux Team`

В рамках разработки на [Альт Платформе](https://docs.altlinux.org/ru-RU/alt-platform/10.1/html-single/alt-platform/index.html#whatis) используется специальный инструмент [`hasher`](https://docs.altlinux.org/ru-RU/alt-platform/10.1/html-single/alt-platform/index.html#hasher--chapter). Это средство безопасной и воспроизводимой сборки пакетов в «чистой» и контролируемой среде. `Hasher` организует изолированное пространство (файловая система, процессы, отсутствие доступа к сети по умолчанию и т. п.), устанавливает туда базовую систему и все сборочные зависимости, после чего запускает сборку пакета. Главная особенность `hasher` — в нём можно запускать непроверенный и потенциально небезопасный код, не опасаясь его воздействия на внешнюю систему. В сборочном окружении `hasher` нет суперпользователя (его заменяет системный пользователь с обычными правами и библиотека `fakeroot`), все процессы запускаются либо с его правами, либо с правами второго системного пользователя, и ни один из этих процессов не имеет доступа к ресурсам внешней системы. Однако для сборки пакетов предоставляется кое-какая информация извне (например, объём памяти и количество ядер процессора) и некоторые свойства ОС (например, работа с псевдотерминалами, иногда требуется поддержка сети и т. п.). Скорость работы приложений в `hasher` не снижается, но каждый раз среда разворачивается заново, чтобы исключить влияние предыдущей сборки на последующую.

Некоторые следствия данной парадигмы работы `hasher`:
 + Все необходимые для сборки зависимости должны быть установлены заранее, либо взяты из `.src.rpm`-пакета;
 + Сборка не зависит от конфигурации компьютера пользователя, собирающего пакет (установленное, система и их версии), и может быть повторена на другом компьютере;
 + Изолированность среды сборки позволяет с легкостью собирать на одном компьютере пакеты для разных дистрибутивов и веток репозитория — для этого достаточно лишь направить `hasher` на различные репозитории для каждого сборочного окружения.

## Настройка `hasher`

Ещё одной особенностью `hasher` является независимость от `root`-прав. Все действия внутри системы выполняются в изолированном блоке файловой системы, а действия, требующие прав суперпользователя, журналируются и выполняются фиктивно в изолированном блоке.

Для работы `hasher` необходимо зарегистрировать пользователя, который будет выполнять сборки, поскольку `hasher` необходимо создать специальных внутренних пользователей для работы.

Регистрация выполняется суперпользователем с помощью команды `hasher-useradd`:

```console
[root@VM ~]# id admin
uid=1000(admin) gid=1000(admin) группы=1000(admin),10(wheel),100(users),36(vmusers)

[root@VM ~]# hasher-useradd admin
useradd: Warning: missing or non-executable shell '/dev/null'
useradd: Warning: missing or non-executable shell '/dev/null'
Добавление пользователя admin в группу admin_a
Добавление пользователя admin в группу admin_b
Добавление пользователя admin в группу hashman
hasher-useradd: enabling hasher-privd
Внимание: Отправляется запрос 'systemctl enable hasher-privd.service'.
Synchronizing state of hasher-privd.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable hasher-privd
hasher-useradd: starting hasher-privd

[root@VM ~]# id admin
uid=1000(admin) gid=1000(admin) группы=1000(admin),10(wheel),100(users),997( hashman),1001(admin_a),1002(admin_b),36(vmusers)
[root@VM ~]#
```

При регистрации создаются два дополнительных пользователя. `B`-пользователь отвечает за непосредственно сборку пакета, `A`-пользователь выполняет роль суперпользователя в рамках системы сборки (при помощи `fakeroot`).

## Первый запуск

Все действия, связанные с работой `hasher`, контролируются множеством утилит семейства `hsh`.

Перед каждой сборкой нового пакета необходимо пересоздавать окружение, сделать это можно с помощью ключа `--init`. Также окружение автоматически пересоздаётся при открытии архива исходников пакета (`.src.rpm`-файлы). При первом создании окружения необходимо отдельно создать директорию для расположения изолированного блока файловой системы. По умолчанию инструмент ожидает директорию `./hasher/`, однако она может быть любой из разрешённых в файле `/etc/hasher-priv/system` (ключ `prefix=`), в таком случае необходимо одним из параметров передавать путь к расположению директории:

```console
[admin@VM ~]$ hsh --init
/usr/bin/hsh-sh-functions: строка 281: cd: /home/admin/hasher: Нет такого файла или каталога
[admin@VM ~]$ mkdir hasher
[admin@VM ~]$ hsh -v --init |& tee log
```

Рассмотрим [вывод](Attached_materials/%D0%A1%D0%BE%D0%BA%D1%80%D0%B0%D1%89%D1%91%D0%BD%D0%BD%D1%8B%D0%B9%20%D0%B2%D1%8B%D0%B2%D0%BE%D0%B4%20%D0%BF%D1%80%D0%B8%20%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B8%20%D0%BE%D0%BA%D1%80%D1%83%D0%B6%D0%B5%D0%BD%D0%B8%D1%8F%20hasher.md) при создании окружения и обсудим некоторые составные части `hasher`.

В состав `hasher` по умолчанию идёт набор утилит, связанных с работой самого инструмента (в частности, `fakeroot`, за счёт которого реализован псевдосуперпользователь). Также по умолчанию `hasher` поддерживает классический набор утилит для разработки, в том числе, использующихся в рамках данного курса (`autoconf`, `automake`, `gcc`, `diffutils` и т.д.).

Внутри `hasher` основной пользователь и два дополнительных обретают описанные выше характеристики: основной пользователь — внутри он называется `caller` — имеет право лишь просматривать данные и получать доступ к готовым пакетам, `A`-пользователь — `rooter` - выполняет действия суперпользователя в рамках инструмента, `B`-пользователь — `builder` — осуществляет сборку пакетов.

`hasher` предоставляет **минимальное** необходимое для сборки окружение. Вследствие этого все инструменты по разработке или отладке, необходимые в рамках работы с `hasher` необходимо устанавливать после **каждого пересоздания** окружения. Вследствие этого всюду далее при рассмотрении отдельных сборок будут опускаться команды пересоздания окружения и установки постоянно необходимых для разработки утилит:
 + `hsh --init` для пересоздания окружения
 + `hsh-install` для установки пакетов из репозиториев Альт

```console
[admin@VM ~]$ hsh --init
<...>
[admin@VM ~]$ hsh-install vim-console tree
<...>
[admin@VM ~]$
```

Также будут опускаться команды входа в изолированное окружение от имени `builder` и `rooter`, все кодовые вставки будут сопровождаться отметками о том, от имени какого пользователя проведён вход:
 + `hsh-shell` для входа от имени `builder`
 + `hsh-shell --rooter` для входа от имени `rooter`

## Создание нулевого пакета

Разберём структуру `hasher` согласно правилам разработки [`RPM`](https://docs.altlinux.org/ru-RU/alt-platform/10.1/html-single/alt-platform/index.html#id864)-пакетов. `RPM`-пакет состоит из архива файлов, а также заголовка, содержащего метаданные о пакете.
Различают **пакеты с исходным кодом** (`.src.rpm`), состоящих из исходников и [`spec`-файла](https://docs.altlinux.org/ru-RU/alt-platform/10.1/html-single/alt-platform/index.html#id868), представляющего из себя инструкцию по сборке пакета, и **двоичные пакеты** (`.rpm`), непосредственно устанавливающиеся в систему.

`Hasher` для работы содержит специальноедерево директорий, по которому автоматически или вручную распределяются файлы для сборки:

`builder`
```console
[builder@localhost ~]$ tree RPM
RPM
|-- BUILD
|-- RPMS
|   `-- noarch
|-- SOURCES
|-- SPECS
`-- SRPMS

7 directories, 0 files
```

Директории `RPMS` и `SRPMS` содержат готовые пакеты, `SOURCES` содержит архив исходников. Исходники чаще всего хранятся в виде архива (обычно `.tar.gz`); `SPECS` — соответствующий `.spec`-файл. В директории `BUILD` проводится сборка пакета, перед началом сборки содержимое директории очищается, что позволяет повторно проводить независимую сборку для одного и того же пакета.

Напишем самый простой пакет, не содержащий ничего кроме `spec`-файла.

`builder`
```console
[builder@localhost ~]$ vim RPM/SPECS/null-pkg.spec
[builder@localhost ~]$ cat RPM/SPECS/null-pkg.spec  
Name: null-pkg
Version: 1.0
Release: alt1

Summary: Null package

License: GPLv3+
Group: Development/Other
Packager: Automated package hasher <hasher@localhost>

%description
This is the smallest ever alt package without any functionality

%files

%changelog
* Tue Jul 01 2025 Automated package hasher <hasher@localhost> 1.0-alt1
- Initial build

[builder@localhost ~]$ tree RPM
RPM
|-- BUILD
|-- RPMS
|   `-- noarch
|-- SOURCES
|-- SPECS
|   `-- null-pkg.spec
`-- SRPMS

7 directories, 1 file
[builder@localhost ~]$
```

Текст внутри `spec`-файла имеет специальный синтаксис. Синтаксические определения имеют значения, задающие порядок сборки, номер версии, информацию о зависимостях и вообще всю информацию о пакете, которая может быть необходимо для сборки и идентификации пакета.

`spec` состоит из **преамбулы**, содержащей метаданные пакета, и **основной части**, содержащей иструкции по сборке и установке пакета.

***Минимально необходимые*** параметры `spec`-файла для сборки пакета:
 + **Преамбула:**
	 + Имя пакета;
	 + Версия согласно правилам [версионирования](https://github.com/UsamG1t/Methodics_of_LinuxAppDev/blob/master/Methodical_manual/10_LibTesting/10.%20%D0%91%D0%B8%D0%B1%D0%BB%D0%B8%D0%BE%D1%82%D0%B5%D0%BA%D0%B8%20%D0%B8%20%D1%82%D0%B5%D1%81%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5.md#%D0%B2%D0%B5%D1%80%D1%81%D0%B8%D0%BE%D0%BD%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5);
	 + Релиз пакета;
	 + Краткое описание пакета;
	 + Лицензия на собираемое ПО;
	 + Категория пакета;
	 + Разработчик пакета;
 + **Основная часть:**
	 + Директива `%files` для описания устанавливаемых файлову конечного пользователя (даже если этих файлов нет);
	 + Директива `%changelog` для записи изменений, произошедших в пакете между сборками разных версий или релизов.

Подробнее познакомиться с другими директивами можно по [ссылке](https://docs.altlinux.org/ru-RU/alt-platform/10.1/html-single/alt-platform/index.html#id865). В рамках лабораторных работ в дальнейшем будут рассмотрены и другие директивы (как, например, необязательная директива `%description`, содержащая более подробное описание функциональности пакета).

Сборка пакетов осуществляется с помощью команды `rpmbuild`. Ключ `-ba` (`build all`) собирает как двоичный пакет, так и новый пакет с исходным кодом.

`builder`
```console
[builder@localhost ~]$ rpmbuild -ba RPM/SPECS/null-pkg.spec  
Processing files: null-pkg-1.0-alt1
Wrote: /usr/src/RPM/SRPMS/null-pkg-1.0-alt1.src.rpm (w2.lzdio)
Wrote: /usr/src/RPM/RPMS/x86_64/null-pkg-1.0-alt1.x86_64.rpm (w2.lzdio)

[builder@localhost ~]$ tree RPM
RPM
|-- BUILD
|-- RPMS
|   |-- noarch
|   `-- x86_64
|       `-- null-pkg-1.0-alt1.x86_64.rpm
|-- SOURCES
|-- SPECS
|   `-- null-pkg.spec
`-- SRPMS
   `-- null-pkg-1.0-alt1.src.rpm

8 directories, 3 files
[builder@localhost ~]$  
```

Попробуем установить полученный пакет в `hasher`, для этого необходимо от имени суперпользователя воспользоваться установщиком `rpm` с ключом `-i`. Чтобы у `rooter` была возможность обратиться к полученному пакету, необходимо перенести его в директорию общего доступа для всех трёх пользователей - специальную директорию `.in`:

`admin`
```console
[admin@VM ~]$ cp hasher/chroot/usr/src/RPM/RPMS/x86_64/null-pkg-1.0-alt1.x86_64.rpm hasher/chroot/.in/
[admin@VM ~]$ hsh-shell --rooter
```

`rooter`
```console
[root@localhost .in]# ls
null-pkg-1.0-alt1.x86_64.rpm
[root@localhost .in]# rpm -i null-pkg-1.0-alt1.x86_64.rpm  
<13>Jul  1 16:46:01 rpm: null-pkg-1.0-alt1 1751388308 installed
                                                              [root@localhost .in]#  
[root@localhost .in]# n
namei          ngettext       nisdomainname  nm             nologin        nsenter
newusers       nice           nl             nohup          nproc          numfmt
```

Пакет успешно установился, и, поскольку он пустой, он никак не отображается во внутренней системе поиска.

## Создание примитивного пакета

Теперь соберём пакет, состоящий из одного `shell`-скрипта, чтобы проверить реальную функциональность пакета. Напомним, что необходимо пересоздать окружение, а также добавить те инструменты разработки, которыми вы пользуетесь.

`builder`
```console
[builder@localhost ~]$ tree RPM
RPM
|-- BUILD
|-- RPMS
|   `-- noarch
|-- SOURCES
|-- SPECS
`-- SRPMS

7 directories, 0 files
[builder@localhost ~]$ vim RPM/SOURCES/not-null-pkg-1.0.sh
[builder@localhost ~]$ cat RPM/SOURCES/not-null-pkg-1.0.sh  
echo "This is not null pkg"

[builder@localhost ~]$ vim RPM/SPECS/not-null-pkg.spec
[builder@localhost ~]$ cat RPM/SPECS/not-null-pkg.spec  
Name: not-null-pkg
Version: 1.0
Release: alt1

Summary: Not Null package

License: GPLv3+
Group: Development/Other
Packager: Automated package hasher <hasher@localhost>

Source: %name-%version.sh

%description
This is not the smallest ever alt package cause of functionality

%install
install -D -pm 755 %_sourcedir/%name-%version.sh %{buildroot}%{_bindir}

%files
%_bindir/*

%changelog
* Tue Jul 01 2025 Automated package hasher <hasher@localhost> 1.0-alt1
- Initial build
[builder@localhost ~]$
```

Разберём новые директивы и команды.

Директива `Source` в преамбуле описывает набор исходных текстов программы. Напомним, что по правилам сборки `RPM` исходники необходимо размещать в виде `.tar.gz`-архива, мы же для упрощения укажем исключительно один скрипт. Именование архива в обязательном порядке должно содержать имя и версию пакета через дефис, аналогично именованию нашего файла.

В основной части добавилась директива `%install`, которая отвечает за команды установки/копирования файлов из сборочного каталога в псевдо-корневой каталог. Утилита `install` занимается размещением итоговых файлов (исполняемых файлов, документации, библиотек; в нашем случае, исполняемого скрипта) по их конечным директориям. При этом используются [предопределённые макросы](https://www.altlinux.org/Spec/%D0%9F%D1%80%D0%B5%D0%B4%D0%BE%D0%BF%D1%80%D0%B5%D0%B4%D0%B5%D0%BB%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5_%D0%BC%D0%B0%D0%BA%D1%80%D0%BE%D1%81%D1%8B#C%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_%D0%BC%D0%B0%D0%BA%D1%80%D0%BE%D1%81%D0%BE%D0%B2), описывающие место установки данных. Для исплняемого скрипта, изначально размещавшегося в `RPM/SOURCE`, производится установка в псевдокорневой каталог (внутри `RPM/BUILD`) в директорию `/usr/bin`

Поскольку в итоговый пакет должен попасть исполняемый файл, в директиве `%files` указывается расположение итоговых данных.

При сборке пакета в логах явно выделяется информационный блок, описывающий установку исполняемого файла.

`builder`
```console
[builder@localhost ~]$ rpmbuild -ba RPM/SPECS/not-null-pkg.spec  
Executing(%install): /bin/sh -e /usr/src/tmp/rpm-tmp.81856
+ umask 022
+ /bin/mkdir -p /usr/src/RPM/BUILD
+ cd /usr/src/RPM/BUILD
+ /bin/chmod -Rf u+rwX -- /usr/src/tmp/not-null-pkg-buildroot
+ /bin/rm -rf -- /usr/src/tmp/not-null-pkg-buildroot
+ PATH=/usr/libexec/rpm-build:/usr/src/bin:/usr/bin:/bin:/usr/local/bin:/usr/games
+ install -D -pm 755 /usr/src/RPM/SOURCES/not-null-pkg-1.0.sh /usr/src/tmp/not-null-pkg-buildroot/usr/bin/not-null-pkg
+ /usr/lib/rpm/brp-alt

Cleaning files in /usr/src/tmp/not-null-pkg-buildroot (auto)
Verifying and fixing files in /usr/src/tmp/not-null-pkg-buildroot (binconfig,pkgconfig,libtool,desktop,
gnuconfig)
Checking contents of files in /usr/src/tmp/not-null-pkg-buildroot/ (default)
Compressing files in /usr/src/tmp/not-null-pkg-buildroot (auto)
Verifying ELF objects in /usr/src/tmp/not-null-pkg-buildroot (arch=normal,fhs=normal,lfs=relaxed,lint=r
elaxed,rpath=normal,stack=normal,textrel=normal,unresolved=normal)
Splitting links to aliased files under /{,s}bin in /usr/src/tmp/not-null-pkg-buildroot
Processing files: not-null-pkg-1.0-alt1
Finding Provides (using /usr/lib/rpm/find-provides)
Executing: /bin/sh -e /usr/src/tmp/rpm-tmp.QrK1pE
find-provides: running scripts (alternatives,debuginfo,lib,pam,perl,pkgconfig,python,python3,shell)
Finding Requires (using /usr/lib/rpm/find-requires)
Executing: /bin/sh -e /usr/src/tmp/rpm-tmp.aiR5Fd
find-requires: running scripts (cpp,debuginfo,files,lib,pam,perl,pkgconfig,pkgconfiglib,python,python3,
rpmlib,shebang,shell,static,symlinks,systemd-services)
Finding debuginfo files (using /usr/lib/rpm/find-debuginfo-files)
Executing: /bin/sh -e /usr/src/tmp/rpm-tmp.CsoTgW

Wrote: /usr/src/RPM/SRPMS/not-null-pkg-1.0-alt1.src.rpm (w2.lzdio)
Wrote: /usr/src/RPM/RPMS/x86_64/not-null-pkg-1.0-alt1.x86_64.rpm (w2.lzdio)
[builder@localhost ~]$ tree RPM/
RPM/
|-- BUILD
|-- RPMS
|   |-- noarch
|   `-- x86_64
|       `-- not-null-pkg-1.0-alt1.x86_64.rpm
|-- SOURCES
|   `-- not-null-pkg-1.0.sh
|-- SPECS
|   |-- not-null-pkg.spec
|   `-- not-null-pkg.spec~
`-- SRPMS
   `-- not-null-pkg-1.0-alt1.src.rpm

8 directories, 5 files
[builder@localhost ~]$  
```

При установке пакета в систему он устанавливается согласно указанным директориям, благодаря чему встроенная в терминал система поиска утилит определяет его:

`admin`
```console
[admin@VM ~]$ cp hasher/chroot/usr/src/RPM/RPMS/x86_64/not-null-pkg-1.0-alt1.x86_64.rpm hasher/chroot/.in/
[admin@VM ~]$ hsh-shell --rooter
```

`rooter`
```console
[root@localhost .in]# rpm -i not-null-pkg-1.0-alt1.x86_64.rpm  
<13>Jul  1 16:33:50 rpm: not-null-pkg-1.0-alt1 1751387597 installed
                                                                  [root@localhost .in]#
 
[root@localhost .in]# no
nohup         nologin       not-null-pkg   
[root@localhost .in]# not-null-pkg  
This is not null pkg
[root@localhost .in]#
```
