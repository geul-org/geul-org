---
title: "CIVIL-TIME-NANOSECONDS"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS — Value, хранящий гражданское время без даты как число nanosecond после полуночи (Codec 0x21)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CIVIL-TIME-NANOSECONDS представляет гражданское время без даты как число nanosecond после полуночи.

## Раскладка

- Код: прямой код Value `0x21`. Семейство TIME.
- Используется тот же физический тип signed int64 фиксированной ширины, что и в Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)`.

```
TAG WORD          0x0A21 (0000 1010 0010 0001)  всего 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Интерпретация и допустимость

- Все 4 WORD Payload читаются как 64-битный signed count в дополнительном коде с порядком WORD big-endian.
- Физический тип — signed int64, но допустимый диапазон — `0 <= value < 86,400×10^9` ns. Отрицательные значения и значения от верхней границы и выше отклоняются.
- `24:00` и метка (label) високосной секунды не допускаются. Дата, часовой пояс и смещение UTC тоже не хранятся.
- Даже малые значения всегда занимают 4 WORD.

## Длина

- Всего ровно 5 WORD: 1 WORD TAG и 4 WORD Payload; используется прямая длина `LLLL=0100`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, значение отклоняется.

## Примеры

- Полночь — Payload `0000 0000 0000 0000`, всего 5 WORD, `LLLL=0100`.
- 1 ns после полуночи — Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns равно верхней границе, поэтому недопустимо.
- `ffff ffff ffff ffff` как signed int64 равно -1, поэтому недопустимо.

## Основание в стандартах

- `TIME(isAdjustedToUTC=false, unit=NANOS)` в [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) хранит nanosecond локального времени после полуночи в `int64` с порядком signed.
- Authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) формата [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) определяет Time с единицей NANOSECOND как 64-битное signed целое, ограничивает допустимый диапазон значениями меньше 86,400 секунд, включая полночь, и не допускает високосных секунд. GEUL добавляет только TAG и framing 16-битными WORD в порядке big-endian.
