---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 — формат Issuer ADHOC фиксированной длины 11 WORD для конечного непустого замкнутого интервала с нижней и верхней границами binary64."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 — Value, представляющий замкнутый интервал двумя endpoint IEEE 754 binary64 в порядке `(lower, upper)`. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0703`, семейство NUMERIC.

## Раскладка

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  всего 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Интерпретация и допустимость

- Оба endpoint — binary64 в порядке big-endian WORD; обе границы входят в интервал.
- У допустимого endpoint битовый шаблон signed zero сохраняется как есть. ABI padding нет.
- Payload содержит ровно 8 WORD, и должно выполняться `lower ≤ upper`.
- NaN нельзя сравнивать, поэтому он отвергается. Endpoint-infinity тоже отвергается, так как задаёт неограниченный интервал.
- Пустой, неограниченный и открытый интервалы, а также NaI этим форматом представить нельзя; они отвергаются.

## Стандартная основа и статус формата

- Числовой формат endpoint соответствует [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/); смысл пары замкнутых endpoint опирается на модель интервалов [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) и её simplified flavor [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- Это простой профиль GEUL, допускающий только конечные непустые замкнутые интервалы. Decorations, NaI, пустые и неограниченные интервалы, а также полная модель операций и interchange из IEEE 1788/1788.1 не реализуются и не сериализуются как есть.

## Длина

- Всего ровно 11 WORD: TAG 1 WORD, Issuer 1 WORD, номер формата 1 WORD и Payload 8 WORD; используется прямая длина `LLLL=1010`. Length extension TAG, descriptor и padding нет.
- Если Payload не равен ровно 8 WORD, запись отвергается.

## Пример

- Endpoint `(1.0, 2.0)` — это `[1.0, 2.0]`, допустимо. `(2.0, 1.0)` и `(NaN, 1.0)` — invalid.
