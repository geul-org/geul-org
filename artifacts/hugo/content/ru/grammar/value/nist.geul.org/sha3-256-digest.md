---
title: "SHA3-256-DIGEST"
weight: 1040
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST — Value фиксированной ширины, содержащее весь результат SHA3-256."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST — Value фиксированной ширины, содержащее весь результат SHA3-256. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000015` NIST, номер Codec `0x0000C001`, семейство BINARY. Payload составляет ровно 16 WORD (256 бит); усечение (truncation) не допускается.

## Раскладка {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length, расш. TAG 1 WORD  0x0016 (всего 22 WORD)
Issuer            2 WORD  0x00000015 (NIST)
Номер Codec       2 WORD  0x0000C001
Payload           16 WORD  SHA3-256 Digest
```

## Интерпретация и действительность {#해석과-유효성}

- 32 octet Payload читаются в том порядке, в каком их выдаёт SHA3-256. В каждом WORD первым идёт старший octet.
- Преобразование порядка байтов GEUL к битовой строке digest отдельно не применяется. Octet вывода по порядку лишь группируются по два и оформляются в 16-битные big-endian WORD (framing).
- Представление отклоняется, если Payload не равен 16 WORD или результат произвольно усечён. Descriptor и заполнения нет.

## Стандартные основания {#표준-근거}

- Алгоритм SHA3-256 и 256-битный результат следуют NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). Стандарт SHA-3 описан также в [проекте Hash Functions](https://csrc.nist.gov/Projects/hash-functions) NIST.
- TAG GEUL, Length и 16-битный framing WORD — правила, которые добавляет этот формат; они не являются частью алгоритма SHA-3.

## Длина {#길이}

- Общая длина — ровно 22 WORD: TAG 1 WORD, расширяющий TAG Length 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 16 WORD; используется `LLLL=1110`. Descriptor и заполнения нет.
- Если Payload не равен ровно 16 WORD, значение отклоняется.

## Пример {#예시}

- Octet digest от `d[0]` до `d[31]` помещаются в 16 WORD Payload в порядке вывода, по два octet. Общая длина (Length) всегда 22 WORD.
