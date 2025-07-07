Данный репозиторий предлагает слушателям курса набор практических задач по сборке пакетов с применением изучаемых в курсе технологий. Описанные лабораторные работы являются документацией по разработке с помощью [Альт Платформы](www.basealt.ru/alt-platform). Лабораторные работы подразумевают предварительное прохождение соответствующих глав основного материала курса (в формате [свободного чтения](https://github.com/UsamG1t/Methodics_of_LinuxAppDev) или просмотра [лекций](https://uneex.org/LecturesCMC/LinuxApplicationDevelopment2024)).

Для выполнения работ необходимы инструменты по сборке `RPM`-пакетов - [`hasher`](https://www.altlinux.org/Hasher) и [`gear`](https://www.altlinux.org/Gear). 

Для начала прохождения лабораторных работ необходимо:
 + [Установить](https://www.altlinux.org/Releases/Download) любую версию дистрибутива Альт или запросить у [Георгия](http://uneex.org/FrBrGeorge) доступ к временной виртуальной машине на базе `AltLinux`.
 + Установить в систему пакеты `hasher` и `gear`
```console
[user@VM ~]$ apt-get install hasher gear
<...>
[user@VM ~]$
```

Все примеры выполнены при помощи [Альт Платформы](https://docs.altlinux.org/ru-RU/alt-platform/10.0/html-single/alt-platform/index.html#whatis) на базе ветки разработки [p11](https://www.altlinux.org/%D0%9E%D0%B4%D0%B8%D0%BD%D0%BD%D0%B0%D0%B4%D1%86%D0%B0%D1%82%D0%B0%D1%8F_%D0%BF%D0%BB%D0%B0%D1%82%D1%84%D0%BE%D1%80%D0%BC%D0%B0).