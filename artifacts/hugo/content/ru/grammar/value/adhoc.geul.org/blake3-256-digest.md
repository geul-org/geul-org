---
title: "BLAKE3-256-DIGEST"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST — Value фиксированной ширины, содержащее первые 32 octet (256 бит) вывода BLAKE3 в режиме default hash."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST — Value фиксированной ширины, содержащее первые 32 octet (256 бит) вывода BLAKE3 в режиме default hash. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x0000C000`, семейство BINARY. Payload составляет ровно 16 WORD; вывод keyed hash mode, key derivation mode и вывод XOF другой длины не помещаются.

## Раскладка {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length, расш. TAG 1 WORD  0x0016 (всего 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Номер Codec       2 WORD  0x0000C000
Payload           16 WORD  BLAKE3-256 Digest
```

## Интерпретация и действительность {#해석과-유효성}

- Payload — первые 32 octet output stream BLAKE3 в режиме default hash. Порядок вывода сохраняется, а внутри каждого WORD старший октет идёт первым.
- Преобразование порядка байтов GEUL к выводу отдельно не применяется. Octet вывода по порядку группируются по два и оформляются в 16-битные big-endian WORD (framing).
- Представление отклоняется, если Payload не равен 16 WORD или содержит результат keyed_hash, derive_key либо XOF другой длины. Descriptor и заполнения нет.

## Стандартные основания {#표준-근거}

- Алгоритм и определения mode и output следуют [официальному репозиторию реализации](https://github.com/BLAKE3-team/BLAKE3) команды BLAKE3 и [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- TAG GEUL, Length и 16-битный framing WORD — правила, которые добавляет этот формат; они не являются частью алгоритма BLAKE3.

## Длина {#길이}

- Общая длина — ровно 22 WORD: TAG 1 WORD, расширяющий TAG Length 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 16 WORD; используется `LLLL=1110`. Descriptor и заполнения нет.
- Если Payload не равен ровно 16 WORD, значение отклоняется.

## Пример {#예시}

- Octet вывода от `d[0]` до `d[31]` помещаются в 16 WORD Payload в порядке вывода, по два octet. Общая длина всегда 22 WORD.
