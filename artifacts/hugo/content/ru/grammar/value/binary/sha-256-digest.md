---
title: "SHA-256-DIGEST"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST — Value фиксированной длины 18 WORD, хранящий все 256 bit результата SHA-256."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-256-DIGEST — это Value фиксированной ширины, хранящий результат SHA-256 из семейства SHA-2 целиком. Прямой код Value `0x61`, семейство BINARY. Payload — ровно 16 WORD (256 bit); усечение (truncation) не допускается.

## Раскладка

```
TAG WORD          0x0F61 (0000 1111 0110 0001)  LLLL=1110
Расширяющий Length TAG   1 WORD  0x0012 (всего 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## Интерпретация и допустимость

- 32 octet Payload читаются в порядке вывода SHA-256. В каждом WORD сначала идёт старший octet.
- Преобразование endian GEUL к digest bit string отдельно не применяется. Octet sequence вывода по порядку лишь группируется по два octet и оформляется как 16-битные big-endian WORD.
- Представление, где Payload не равен 16 WORD или результат произвольно обрезан, отклоняется. descriptor и padding нет.

## Основание в стандартах

- Алгоритм SHA-256 и 256-битный результат следуют NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL TAG, Length и framing 16-битными WORD — правила, которые добавляет этот формат; они не часть алгоритма SHA-2.

## Длина

- Всего ровно 18 WORD: 1 WORD TAG, 1 WORD расширяющего Length TAG и 16 WORD Payload; используется `LLLL=1110`. descriptor и padding нет.
- Если Payload не равен ровно 16 WORD, значение отклоняется.

## Примеры

- Octet digest от `d[0]` до `d[31]` по порядку кладутся в Payload WORD от `(d[0]<<8)|d[1]` до `(d[30]<<8)|d[31]`. Полная Length всегда равна 18 WORD.
