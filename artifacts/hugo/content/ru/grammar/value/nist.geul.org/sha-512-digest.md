---
title: "SHA-512-DIGEST"
weight: 1039
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST — Value фиксированной ширины, содержащее весь результат SHA-512 из семейства SHA-2."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST — Value фиксированной ширины, содержащее весь результат SHA-512 из семейства SHA-2. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000015` NIST, номер Codec `0x0000C000`, семейство BINARY. Payload составляет ровно 32 WORD (512 бит); усечение (truncation) не допускается.

## Раскладка {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length, расш. TAG 1 WORD  0x0026 (всего 38 WORD)
Issuer            2 WORD  0x00000015 (NIST)
Номер Codec       2 WORD  0x0000C000
Payload           32 WORD  SHA-512 Digest
```

## Интерпретация и действительность {#해석과-유효성}

- 64 octet Payload читаются в том порядке, в каком их выдаёт SHA-512. В каждом WORD первым идёт старший octet.
- Преобразование порядка байтов GEUL к битовой строке digest отдельно не применяется. Octet вывода по порядку лишь группируются по два и оформляются в 16-битные big-endian WORD (framing).
- Представление отклоняется, если Payload не равен 32 WORD или результат произвольно усечён. Descriptor и заполнения нет.

## Стандартные основания {#표준-근거}

- Алгоритм SHA-512 и 512-битный результат следуют NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- TAG GEUL, Length и 16-битный framing WORD — правила, которые добавляет этот формат; они не являются частью алгоритма SHA-2.

## Длина {#길이}

- Общая длина — ровно 38 WORD: TAG 1 WORD, расширяющий TAG Length 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 32 WORD; используется `LLLL=1110`. Descriptor и заполнения нет.
- Если Payload не равен ровно 32 WORD, значение отклоняется.

## Пример {#예시}

- Octet digest от `d[0]` до `d[63]` помещаются в Payload WORD по порядку, от `(d[0]<<8)|d[1]` до `(d[62]<<8)|d[63]`. Общая длина (Length) всегда 38 WORD.
