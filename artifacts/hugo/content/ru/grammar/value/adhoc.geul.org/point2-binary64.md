---
title: "POINT2-BINARY64"
weight: 1017
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 — двумерная точка из двух компонент IEEE 754 binary64 в порядке (x, y)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 — двумерная точка из двух компонент IEEE 754 binary64 в порядке `(x, y)`.

## Раскладка {#레이아웃}

- Код: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x0000050A`. Семейство NUMERIC.

```
TAG WORD          0x09DC (0000 1001 1101 1100)  всего 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Номер Codec       2 WORD  0x0000050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## Правила интерпретации {#해석-규칙}

- Каждая компонента читается начиная со старшего WORD; сохраняются NaN payload и битовый образ знакового нуля.
- CRS, смысл, порядок и единицы осей определяются внешним контекстом. ABI-заполнения нет.

## Действительность {#유효성}

- Payload составляет ровно 8 WORD, и каждый участок из 4 WORD — это interchange bits binary64.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Порядок координат точки `x, y` опирается на Point/WKB axis order из OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), а каждая компонента следует [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Этот Payload — компактный профиль GEUL без WKB type/byte-order header и заголовка GeoPackage; он не является wire format OGC WKB. CRS, смысл и единицы осей определяются внешним контекстом.

## Длина {#길이}

- Общая длина — ровно 13 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 8 WORD; используется прямая длина `LLLL=1100`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 8 WORD, значение отклоняется.

## Пример {#예시}

- Payload `3FF0 0000 0000 0000 4000 0000 0000 0000` — это `(1.0, 2.0)`.
