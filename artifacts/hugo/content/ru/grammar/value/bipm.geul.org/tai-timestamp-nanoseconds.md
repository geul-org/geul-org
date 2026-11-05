---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1021
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDS — число signed nanosecond, отсчитанное от того же epoch TAI 1970-01-01T00:00:00 TAI."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-NANOSECONDS — число signed nanosecond, отсчитанное от того же epoch TAI `1970-01-01T00:00:00 TAI`. Это представление накопленного count не является wire format стандарта BIPM, а представляет собой собственный профиль GEUL, отображающий шкалу времени TAI в signed int64 фиксированной ширины.

## Раскладка {#레이아웃}

- Код: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000013` BIPM, номер Codec `0x00004001`. Семейство TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  всего 9 WORD
Issuer            2 WORD  0x00000013 (BIPM)
Номер Codec       2 WORD  0x00004001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Интерпретация и действительность {#해석과-유효성}

- Все 4 WORD Payload читаются как 64-битный signed count в дополнительном коде в порядке big-endian WORD.
- Допустимый диапазон — от `-2^63` до `2^63-1` ns. Отрицательное значение — момент TAI до epoch, определённого GEUL.
- Даже малые значения всегда занимают 4 WORD. Смещение UTC и таблица leap-second не хранятся.

## Длина {#길이}

- Общая длина — ровно 9 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 4 WORD; используется прямая длина `LLLL=1000`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 4 WORD, значение отклоняется.

## Пример {#예시}

- Epoch TAI в GEUL — Payload `0000 0000 0000 0000`, всего 9 WORD, `LLLL=1000`.
- 1 ns после epoch — Payload `0000 0000 0000 0001`.
- 1 ns до epoch — Payload `FFFF FFFF FFFF FFFF`.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) определяет секунду SI и шкалу времени International Atomic Time (TAI).
- BIPM не определяет ни накопленные signed int64 nanosecond от epoch `1970-01-01 TAI`, ни их wire encoding. Epoch, count по единице, signed int64 и размещение в big-endian WORD — собственное отображение GEUL.
- Int64 фиксированной ширины выбран ради согласованности обмена с другими профилями count семейства TIME; это не означает точного воспроизведения формата BIPM.
