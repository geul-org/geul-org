---
title: "SHA3-256-DIGEST"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST — формат Issuer NIST фиксированной длины 20 WORD, хранящий все 256 bit результата SHA3-256."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST — это Value фиксированной ширины, хранящий результат SHA3-256 целиком. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, номер формата `0xC001`, семейство BINARY. Payload — ровно 16 WORD (256 bit); усечение (truncation) не допускается.

## Раскладка

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Расширяющий Length TAG   1 WORD  0x0014 (всего 20 WORD)
Issuer            1 WORD  0x0062 (NIST)
Номер формата     1 WORD  0xC001
Payload           16 WORD  SHA3-256 Digest
```

## Интерпретация и допустимость

- 32 octet Payload читаются в порядке вывода SHA3-256. В каждом WORD сначала идёт старший octet.
- Преобразование endian GEUL к digest bit string отдельно не применяется. Octet sequence вывода по порядку лишь группируется по два octet и оформляется как 16-битные big-endian WORD.
- Представление, где Payload не равен 16 WORD или результат произвольно обрезан, отклоняется. descriptor и padding нет.

## Основание в стандартах

- Алгоритм SHA3-256 и 256-битный результат следуют NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). Стандарт SHA-3 также представлен в [проекте Hash Functions](https://csrc.nist.gov/Projects/hash-functions) NIST.
- GEUL TAG, Length и framing 16-битными WORD — правила, которые добавляет этот формат; они не часть алгоритма SHA-3.

## Длина

- Всего ровно 20 WORD: 1 WORD TAG, 1 WORD расширяющего Length TAG, 1 WORD Issuer, 1 WORD номера формата и 16 WORD Payload; используется `LLLL=1110`. descriptor и padding нет.
- Если Payload не равен ровно 16 WORD, значение отклоняется.

## Примеры

- Octet digest от `d[0]` до `d[31]` по порядку вывода, по два octet, кладутся в 16 Payload WORD. Полная Length всегда равна 20 WORD.
