---
title: "BBOX2-BINARY64"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 — Value двумерного ограничивающего прямоугольника из четырёх компонентов IEEE 754 binary64 в порядке (minX, minY, maxX, maxY) (формат Issuer ADHOC 0x050C)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 — двумерный ограничивающий прямоугольник из четырёх компонентов IEEE 754 binary64 в порядке `(minX, minY, maxX, maxY)`.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x050C`. Семейство NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length extension TAG   1 WORD  0x0014 (всего 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Правила интерпретации

- Каждый компонент — binary64, читается начиная со старшего WORD. Битовый шаблон signed zero сохраняется.
- CRS, смысл, порядок и единицы осей относятся к внешнему контексту. ABI padding нет.

## Допустимость

- Payload содержит ровно 16 WORD, при этом `minX ≤ maxX` и `minY ≤ maxY`.
- NaN нельзя сравнивать, поэтому запись с NaN в любом компоненте отвергается.

## Стандартная основа и статус формата

- Смысл минимальных и максимальных координат опирается на bounding envelope из OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html); каждый компонент соответствует [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- В GeoPackage порядок 2D-массива envelope — `[minx, maxx, miny, maxy]`. Порядок `(minX, minY, maxX, maxY)` в этом формате — не тот wire order, а компактный кортеж, заданный GEUL; заголовки WKB и GeoPackage тоже не включаются. CRS, смысл осей и единицы относятся к внешнему контексту.

## Длина

- Всего ровно 20 WORD: TAG 1 WORD, Length extension TAG 1 WORD, Issuer 1 WORD, номер формата 1 WORD и Payload 16 WORD; используется `LLLL=1110`. descriptor и padding нет.
- Если Payload не равен ровно 16 WORD, запись отвергается.

## Пример

- Компоненты `(0.0, 1.0, 2.0, 3.0)` допустимы, а `(2.0, 1.0, 0.0, 3.0)` — invalid.
