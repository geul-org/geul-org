---
title: "BLAKE3-256-DIGEST"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST — формат Issuer фиксированной длины 20 WORD, хранящий первые 32 octet вывода BLAKE3 в режиме hash по умолчанию."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST — это Value фиксированной ширины, хранящий первые 32 octet (256 bit) вывода BLAKE3 в default hash mode. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0xC000`, семейство BINARY. Payload — ровно 16 WORD; keyed hash mode, key derivation mode и вывод XOF другой длины не хранятся.

## Раскладка

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Расширяющий Length TAG   1 WORD  0x0014 (всего 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0xC000
Payload           16 WORD  BLAKE3-256 Digest
```

## Интерпретация и допустимость

- Payload — первые 32 octet output stream BLAKE3 в default hash mode. Порядок вывода сохраняется, в каждом WORD сначала идёт старший octet.
- Преобразование endian GEUL к выводу отдельно не применяется. Octet sequence вывода по порядку группируется по два octet и оформляется как 16-битные big-endian WORD.
- Представление, где Payload не равен 16 WORD или хранит результат keyed_hash, derive_key либо XOF другой длины, отклоняется. descriptor и padding нет.

## Основание в стандартах

- Определения алгоритма, режимов и вывода следуют [официальному репозиторию реализации](https://github.com/BLAKE3-team/BLAKE3) команды BLAKE3 и [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- GEUL TAG, Length и framing 16-битными WORD — правила, которые добавляет этот формат; они не часть алгоритма BLAKE3.

## Длина

- Всего ровно 20 WORD: 1 WORD TAG, 1 WORD расширяющего Length TAG, 1 WORD Issuer, 1 WORD номера формата и 16 WORD Payload; используется `LLLL=1110`. descriptor и padding нет.
- Если Payload не равен ровно 16 WORD, значение отклоняется.

## Примеры

- Octet вывода от `d[0]` до `d[31]` по порядку вывода, по два octet, кладутся в 16 Payload WORD. Полная Length всегда равна 20 WORD.
