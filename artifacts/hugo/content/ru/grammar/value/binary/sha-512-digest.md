---
title: "SHA-512-DIGEST"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST — формат Issuer NIST фиксированной длины 36 WORD, хранящий все 512 bit результата SHA-512."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST — это Value фиксированной ширины, хранящий результат SHA-512 из семейства SHA-2 целиком. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, номер формата `0xC000`, семейство BINARY. Payload — ровно 32 WORD (512 bit); усечение (truncation) не допускается.

## Раскладка

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Расширяющий Length TAG   1 WORD  0x0024 (всего 36 WORD)
Issuer            1 WORD  0x0062 (NIST)
Номер формата     1 WORD  0xC000
Payload           32 WORD  SHA-512 Digest
```

## Интерпретация и допустимость

- 64 octet Payload читаются в порядке вывода SHA-512. В каждом WORD сначала идёт старший octet.
- Преобразование endian GEUL к digest bit string отдельно не применяется. Octet sequence вывода по порядку лишь группируется по два octet и оформляется как 16-битные big-endian WORD.
- Представление, где Payload не равен 32 WORD или результат произвольно обрезан, отклоняется. descriptor и padding нет.

## Основание в стандартах

- Алгоритм SHA-512 и 512-битный результат следуют NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL TAG, Length и framing 16-битными WORD — правила, которые добавляет этот формат; они не часть алгоритма SHA-2.

## Длина

- Всего ровно 36 WORD: 1 WORD TAG, 1 WORD расширяющего Length TAG, 1 WORD Issuer, 1 WORD номера формата и 32 WORD Payload; используется `LLLL=1110`. descriptor и padding нет.
- Если Payload не равен ровно 32 WORD, значение отклоняется.

## Примеры

- Octet digest от `d[0]` до `d[63]` по порядку кладутся в Payload WORD от `(d[0]<<8)|d[1]` до `(d[62]<<8)|d[63]`. Полная Length всегда равна 36 WORD.
