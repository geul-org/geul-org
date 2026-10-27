---
title: "POINT3-BINARY64"
weight: 1012
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 — Value трёхмерной точки из трёх компонентов IEEE 754 binary64 в порядке (x, y, z) (формат Issuer ADHOC 0x050B)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 — трёхмерная точка из трёх компонентов IEEE 754 binary64 в порядке `(x, y, z)`.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x050B`. Семейство NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length extension TAG   1 WORD  0x0010 (всего 16 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## Правила интерпретации

- Каждый компонент читается начиная со старшего WORD; битовые шаблоны NaN payload и signed zero сохраняются.
- CRS, смысл, порядок и единицы осей относятся к внешнему контексту. ABI padding нет.

## Допустимость

- Payload содержит ровно 12 WORD, и каждый участок из 4 WORD — это interchange-биты binary64.

## Стандартная основа и статус формата

- Порядок координат точки `x, y, z` опирается на axis order Point/WKB из OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html); каждый компонент соответствует [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Этот Payload — компактный профиль GEUL, не содержащий заголовка type/byte-order WKB и заголовка GeoPackage, и не является wire format OGC WKB. CRS, смысл осей и единицы относятся к внешнему контексту.

## Длина

- Всего ровно 16 WORD: TAG 1 WORD, Length extension TAG 1 WORD, Issuer 1 WORD, номер формата 1 WORD и Payload 12 WORD; используется `LLLL=1110`. descriptor и padding нет.
- Если Payload не равен ровно 12 WORD, запись отвергается.

## Пример

- Если три binary64 в Payload равны `1.0, 2.0, 3.0`, это точка `(1.0, 2.0, 3.0)`.
