---
title: "POINT2-BINARY64"
weight: 1011
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 — Value двумерной точки из двух компонентов IEEE 754 binary64 в порядке (x, y) (формат Issuer ADHOC 0x050A)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 — двумерная точка из двух компонентов IEEE 754 binary64 в порядке `(x, y)`.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x050A`. Семейство NUMERIC.

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  всего 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## Правила интерпретации

- Каждый компонент читается начиная со старшего WORD; битовые шаблоны NaN payload и signed zero сохраняются.
- CRS, смысл, порядок и единицы осей относятся к внешнему контексту. ABI padding нет.

## Допустимость

- Payload содержит ровно 8 WORD, и каждый участок из 4 WORD — это interchange-биты binary64.

## Стандартная основа и статус формата

- Порядок координат точки `x, y` опирается на axis order Point/WKB из OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html); каждый компонент соответствует [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Этот Payload — компактный профиль GEUL, не содержащий заголовка type/byte-order WKB и заголовка GeoPackage, и не является wire format OGC WKB. CRS, смысл осей и единицы относятся к внешнему контексту.

## Длина

- Всего ровно 11 WORD: TAG 1 WORD, Issuer 1 WORD, номер формата 1 WORD и Payload 8 WORD; используется прямая длина `LLLL=1010`. Length extension TAG, descriptor и padding нет.
- Если Payload не равен ровно 8 WORD, запись отвергается.

## Пример

- Payload `3ff0 0000 0000 0000 4000 0000 0000 0000` — точка `(1.0, 2.0)`.
