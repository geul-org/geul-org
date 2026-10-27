---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDS — Value, хранящий число signed nanosecond от 1970-01-01T00:00:00 TAI (номер формата Issuer BIPM 0x4001)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-NANOSECONDS — это число signed nanosecond от того же epoch TAI `1970-01-01T00:00:00 TAI`. Это накопительное представление count — не стандартный wire format BIPM, а собственный profile GEUL, отображающий шкалу времени TAI на signed int64 фиксированной ширины.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0060` BIPM, номер формата `0x4001`. Семейство TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  всего 7 WORD
Issuer            1 WORD  0x0060 (BIPM)
Номер формата     1 WORD  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Интерпретация и допустимость

- Все 4 WORD Payload читаются как 64-битный signed count в дополнительном коде с порядком WORD big-endian.
- Допустимый диапазон — `-2^63`–`2^63-1` ns. Отрицательное значение — instant TAI до epoch, заданного GEUL.
- Даже малые значения всегда занимают 4 WORD. Смещение UTC и таблица leap-second не сохраняются.

## Длина

- Всего ровно 7 WORD: 1 WORD TAG, 1 WORD Issuer, 1 WORD номера формата и 4 WORD Payload; используется прямая длина `LLLL=0110`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, значение отклоняется.

## Примеры

- Epoch TAI GEUL — Payload `0000 0000 0000 0000`, всего 7 WORD, `LLLL=0110`.
- 1 ns после epoch — Payload `0000 0000 0000 0001`.
- 1 ns до epoch — Payload `ffff ffff ffff ffff`.

## Основание в стандартах и статус формата

- [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) определяет SI second и шкалу времени International Atomic Time (TAI).
- BIPM не определяет накопленные от epoch `1970-01-01 TAI` nanosecond в signed int64 и их wire encoding. Epoch, count по единицам, signed int64 и раскладка big-endian WORD GEUL — собственное отображение GEUL.
- Int64 фиксированной ширины выбран для согласованности обмена с другими profile count семейства TIME, а не как точное воспроизведение формата BIPM.
