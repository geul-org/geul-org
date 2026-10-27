---
title: "DURATION-SECONDS"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS — Value, хранящий длительность без epoch как signed int64 секунд (Codec 0x23)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-SECONDS — это длительность в signed секундах без epoch. Это не instant и не календарный период в месяцах и годах.

## Раскладка

- Код: прямой код Value `0x23`. Семейство TIME.
- Используется тот же физический тип signed int64 фиксированной ширины, что и в Arrow `Duration(SECOND)`.

```
TAG WORD          0x0A23 (0000 1010 0010 0011)  всего 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Интерпретация и допустимость

- Все 4 WORD Payload читаются как 64-битный signed count в дополнительном коде с порядком WORD big-endian.
- Допустимый диапазон — `-2^63`–`2^63-1` секунд. Знак задаёт направление отсчёта длительности и не указывает на instant относительно какого-либо epoch.
- Даже малые значения всегда занимают 4 WORD.

## Длина

- Всего ровно 5 WORD: 1 WORD TAG и 4 WORD Payload; используется прямая длина `LLLL=0100`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, значение отклоняется.

## Примеры

- 0 секунд — Payload `0000 0000 0000 0000`, всего 5 WORD, `LLLL=0100`.
- 1 секунда — Payload `0000 0000 0000 0001`.
- -1 секунда — Payload `ffff ffff ffff ffff`.

## Основание в стандартах

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) назначает `Schema.fbs` authoritative source стандартных типов данных Arrow.
- В authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) Arrow `Duration` — абсолютная длительность, не зависящая от календаря; она поддерживает единицу SECOND и всегда представляется 8-байтовым signed целым. GEUL добавляет только TAG и framing 16-битными WORD в порядке big-endian.
