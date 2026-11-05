---
title: "POINT3-BINARY64"
weight: 1018
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 — трёхмерная точка из трёх компонент IEEE 754 binary64 в порядке (x, y, z)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 — трёхмерная точка из трёх компонент IEEE 754 binary64 в порядке `(x, y, z)`.

## Раскладка {#레이아웃}

- Код: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x0000050B`. Семейство NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length, расш. TAG 1 WORD  0x0012 (всего 18 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Номер Codec       2 WORD  0x0000050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## Правила интерпретации {#해석-규칙}

- Каждая компонента читается начиная со старшего WORD; сохраняются NaN payload и битовый образ знакового нуля.
- CRS, смысл, порядок и единицы осей определяются внешним контекстом. ABI-заполнения нет.

## Действительность {#유효성}

- Payload составляет ровно 12 WORD, и каждый участок из 4 WORD — это interchange bits binary64.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Порядок координат точки `x, y, z` опирается на Point/WKB axis order из OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), а каждая компонента следует [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Этот Payload — компактный профиль GEUL без WKB type/byte-order header и заголовка GeoPackage; он не является wire format OGC WKB. CRS, смысл и единицы осей определяются внешним контекстом.

## Длина {#길이}

- Общая длина — ровно 18 WORD: TAG 1 WORD, расширяющий TAG Length 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 12 WORD; используется `LLLL=1110`. Descriptor и заполнения нет.
- Если Payload не равен ровно 12 WORD, значение отклоняется.

## Пример {#예시}

- Если три binary64 в Payload равны `1.0, 2.0, 3.0`, это точка `(1.0, 2.0, 3.0)`.
