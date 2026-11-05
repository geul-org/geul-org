---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1023
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS — число signed nanosecond, отсчитанное от epoch GPS 1980-01-06T00:00:00 GPS."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS — число signed nanosecond, отсчитанное от epoch GPS `1980-01-06T00:00:00 GPS`. Значение не делится на номера GPS week и не усекается до ширины week rollover в broadcast field.

Это представление накопленного count не является broadcast wire format IS-GPS-200, а представляет собой собственный профиль GEUL, отображающий шкалу времени GPS в signed int64 фиксированной ширины.

## Раскладка {#레이아웃}

- Код: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000016` GPS, номер Codec `0x00004001`. Семейство TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  всего 9 WORD
Issuer            2 WORD  0x00000016 (GPS)
Номер Codec       2 WORD  0x00004001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Интерпретация и действительность {#해석과-유효성}

- Все 4 WORD Payload читаются как 64-битный signed count в дополнительном коде в порядке big-endian WORD.
- Допустимый диапазон — от `-2^63` до `2^63-1` ns. Отрицательное значение — момент времени GPS до epoch GPS.
- count — непрерывное значение, продолжающееся от epoch. Усечение или rollover поля week-number из broadcast не применяется.
- Даже малые значения всегда занимают 4 WORD. Параметры преобразования в UTC не включаются.

## Длина {#길이}

- Общая длина — ровно 9 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 4 WORD; используется прямая длина `LLLL=1000`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 4 WORD, значение отклоняется.

## Пример {#예시}

- Epoch GPS — Payload `0000 0000 0000 0000`, всего 9 WORD, `LLLL=1000`.
- 1 ns после epoch — Payload `0000 0000 0000 0001`.
- 1 ns до epoch — Payload `FFFF FFFF FFFF FFFF`.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) — официальный источник распространения интерфейсных спецификаций GPS.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) определяет время GPS как непрерывную шкалу времени, в которой week 0 начинается в полночь 1980-01-06, а также broadcast field номера GPS week и time-of-week/Z-count.
- IS-GPS-200 не определяет wire representation накопленных nanosecond от epoch в виде signed int64. Непрерывный count в nanosecond без rollover, signed int64 и размещение в big-endian WORD — собственное отображение GEUL.
