---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 — Value, представляющее замкнутый интервал двумя endpoint IEEE 754 binary64 в порядке (lower, upper)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 — Value, представляющее замкнутый интервал двумя endpoint IEEE 754 binary64 в порядке `(lower, upper)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x00000703`, семейство NUMERIC.

## Раскладка {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  всего 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Номер Codec       2 WORD  0x00000703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Интерпретация и действительность {#해석과-유효성}

- Оба endpoint — binary64 в порядке big-endian WORD; оба конца включаются в интервал.
- Битовый образ знакового нуля у действительного endpoint сохраняется без изменений. Выравнивающего заполнения ABI нет.
- Payload составляет ровно 8 WORD, и должно выполняться `lower ≤ upper`.
- NaN несравним, поэтому отклоняется. Endpoint-бесконечность тоже отклоняется, так как интервал стал бы unbounded.
- Пустой (empty), unbounded и открытый интервалы, а также NaI в этом формате выразить нельзя; они отклоняются.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Числовой формат endpoint следует [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), а смысл пары замкнутых endpoint опирается на модель интервалов [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) и её simplified flavor [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- Этот формат — простой профиль GEUL, допускающий только конечные непустые замкнутые интервалы. Decorations, NaI, пустые и unbounded интервалы, а также полная модель операций и interchange IEEE 1788/1788.1 не реализуются и не сериализуются как есть.

## Длина {#길이}

- Общая длина — ровно 13 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 8 WORD; используется прямая длина `LLLL=1100`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 8 WORD, значение отклоняется.

## Пример {#예시}

- Endpoint `(1.0, 2.0)` — это `[1.0, 2.0]`, значение действительно. `(2.0, 1.0)` и `(NaN, 1.0)` — invalid.
