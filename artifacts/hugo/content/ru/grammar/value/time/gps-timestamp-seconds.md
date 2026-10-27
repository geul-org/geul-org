---
title: "GPS-TIMESTAMP-SECONDS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-SECONDS — Value, хранящий число signed second от epoch GPS 1980-01-06T00:00:00 GPS (номер формата Issuer GPS 0x4000)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-SECONDS — это число signed second от epoch GPS `1980-01-06T00:00:00 GPS`. Оно не делится на номера недель GPS и не обрезается по ширине week rollover в broadcast-поле.

Это накопительное представление count — не broadcast wire format IS-GPS-200, а собственный profile GEUL, отображающий шкалу времени GPS на signed int64 фиксированной ширины.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0063` GPS, номер формата `0x4000`. Семейство TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  всего 7 WORD
Issuer            1 WORD  0x0063 (GPS)
Номер формата     1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Интерпретация и допустимость

- Все 4 WORD Payload читаются как 64-битный signed count в дополнительном коде с порядком WORD big-endian.
- Допустимый диапазон — `-2^63`–`2^63-1` секунд. Отрицательное значение — instant по времени GPS до epoch GPS.
- count — непрерывное значение, идущее от epoch. Усечение (truncation) и rollover поля номера недели broadcast не применяются.
- Даже малые значения всегда занимают 4 WORD. Параметры перевода в UTC не хранятся.

## Длина

- Всего ровно 7 WORD: 1 WORD TAG, 1 WORD Issuer, 1 WORD номера формата и 4 WORD Payload; используется прямая длина `LLLL=0110`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, значение отклоняется.

## Примеры

- Epoch GPS — Payload `0000 0000 0000 0000`, всего 7 WORD, `LLLL=0110`.
- 1 секунда после epoch — Payload `0000 0000 0000 0001`.
- 1 секунда до epoch — Payload `ffff ffff ffff ffff`.

## Основание в стандартах и статус формата

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) — официальный источник интерфейсных спецификаций GPS.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) определяет время GPS как непрерывную шкалу времени, где неделя 0 начинается в полночь 1980-01-06, и описывает номер недели GPS и broadcast-поля time-of-week/Z-count.
- IS-GPS-200 не определяет действующую wire representation в виде накопленного от epoch signed int64. Непрерывный count без rollover, signed int64 и раскладка big-endian WORD GEUL — собственное отображение GEUL.
