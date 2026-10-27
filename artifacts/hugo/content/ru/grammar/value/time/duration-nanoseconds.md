---
title: "DURATION-NANOSECONDS"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS — Value, хранящий длительность без epoch как signed int64 nanosecond (номер формата Issuer GEUL 0x4000)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS — это длительность в signed nanosecond без epoch. Это не instant и не календарный период в месяцах и годах.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, номер формата `0x4000`. Семейство TIME.
- Используется тот же физический тип signed int64 фиксированной ширины, что и в Arrow `Duration(NANOSECOND)`.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  всего 7 WORD
Issuer            1 WORD  0x0000 (GEUL)
Номер формата     1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Интерпретация и допустимость

- Все 4 WORD Payload читаются как 64-битный signed count в дополнительном коде с порядком WORD big-endian.
- Допустимый диапазон — `-2^63`–`2^63-1` ns. Знак задаёт направление отсчёта длительности и не указывает на instant относительно какого-либо epoch.
- Даже малые значения всегда занимают 4 WORD.

## Длина

- Всего ровно 7 WORD: 1 WORD TAG, 1 WORD Issuer, 1 WORD номера формата и 4 WORD Payload; используется прямая длина `LLLL=0110`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, значение отклоняется.

## Примеры

- 0 ns — Payload `0000 0000 0000 0000`, всего 7 WORD, `LLLL=0110`.
- 1 ns — Payload `0000 0000 0000 0001`.
- -1 ns — Payload `ffff ffff ffff ffff`.

## Основание в стандартах

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) назначает `Schema.fbs` authoritative source стандартных типов данных Arrow.
- В authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) Arrow `Duration` — абсолютная длительность, не зависящая от календаря; она поддерживает единицу NANOSECOND и всегда представляется 8-байтовым signed целым. GEUL добавляет только TAG и framing 16-битными WORD в порядке big-endian.
