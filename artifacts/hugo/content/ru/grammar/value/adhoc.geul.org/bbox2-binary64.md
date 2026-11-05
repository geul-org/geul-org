---
title: "BBOX2-BINARY64"
weight: 1000
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 — двумерный ограничивающий прямоугольник из четырёх компонент IEEE 754 binary64 в порядке (minX, minY, maxX, maxY)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 — двумерный ограничивающий прямоугольник из четырёх компонент IEEE 754 binary64 в порядке `(minX, minY, maxX, maxY)`.

## Раскладка {#레이아웃}

- Код: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x0000050C`. Семейство NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length, расш. TAG 1 WORD  0x0016 (всего 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Номер Codec       2 WORD  0x0000050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Правила интерпретации {#해석-규칙}

- Каждая компонента — binary64; читается начиная со старшего WORD. Битовый образ знакового нуля сохраняется.
- CRS, смысл, порядок и единицы осей определяются внешним контекстом. Выравнивающего заполнения ABI нет.

## Действительность {#유효성}

- Payload должен составлять ровно 16 WORD, при этом `minX ≤ maxX` и `minY ≤ maxY`.
- NaN несравним, поэтому значение отклоняется, если NaN есть в любой из компонент.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Смысл минимальной и максимальной координат взят из bounding envelope в OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html); каждая компонента следует [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Порядок двумерного массива envelope в GeoPackage — `[minx, maxx, miny, maxy]`. Порядок `(minX, minY, maxX, maxY)` в этом формате не является их wire order, а представляет собой компактный кортеж, определённый GEUL; заголовок WKB/GeoPackage тоже не включается. CRS, смысл и единицы осей определяются внешним контекстом.

## Длина {#길이}

- Общая длина — ровно 22 WORD: TAG 1 WORD, расширяющий TAG Length 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 16 WORD; используется `LLLL=1110`. Descriptor и заполнения нет.
- Если Payload не равен ровно 16 WORD, значение отклоняется.

## Пример {#예시}

- Если компоненты `(0.0, 1.0, 2.0, 3.0)`, значение действительно; если `(2.0, 1.0, 0.0, 3.0)` — invalid.
