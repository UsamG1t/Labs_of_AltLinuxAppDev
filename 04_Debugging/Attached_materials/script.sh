#!/bin/bash

# Инициализация переменных
workdir="hasher"
rooter_flag=""
hasher_arg=""

# Функция вывода справки
show_help() {
  cat <<EOF
Использование: $0 [OPTIONS] [ARGUMENT]

Опции:
  -w DIR       Указание рабочей директории (по умолчанию: hasher)
  --rooter     Использовать root-режим
  -h, --help   Показать эту справку

Аргумент:
  *.src.rpm    Файл RPM для обработки
  --init       Инициализация среды
  (пусто)     Пропустить этап обработки

Примеры:
  $0 -w mydir package.src.rpm
  $0 --rooter --init
  $0 -h
EOF
  exit 0
}

# Обработка аргументов командной строки
while getopts ":w:h-:" opt; do
  case $opt in
    w)
      workdir="$OPTARG"
      ;;
    h)
      show_help
      ;;
    -)
      case "$OPTARG" in
        rooter)
          rooter_flag="--rooter"
          ;;
        help)
          show_help
          ;;
        *)
          echo "Неизвестный длинный флаг: --$OPTARG" >&2
          exit 1
          ;;
      esac
      ;;
    \?)
      echo "Неизвестный флаг: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Флаг -$OPTARG требует аргумент." >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND -1))

if [ $# -gt 0 ]; then
  hasher_arg="$1"
fi

case "$hasher_arg" in
  *.src.rpm)
    hsh --workdir="$workdir" --mountpoints=/proc $hasher_arg --lazy
    ;;
  "--init")
    hsh --workdir="$workdir" --mountpoints=/proc --init
    ;;
  "")
    ;;
  *)
    echo "Ошибка: недопустимое значение аргумента: '$hasher_arg'" >&2
    echo "Допустимые значения: '', '*.src.rpm', '--init'" >&2
    exit 1
    ;;
esac

echo "nameserver 8.8.8.8" > "$workdir"/chroot/.in/resolv.conf
hsh-run --rooter cp resolv.conf /etc/
hsh-install --workdir="$workdir" vim-plugin-spec_alt-ftplugin vim-console tree
share_network=1 hsh-shell $rooter_flag --workdir="$workdir" --mountpoints=/proc