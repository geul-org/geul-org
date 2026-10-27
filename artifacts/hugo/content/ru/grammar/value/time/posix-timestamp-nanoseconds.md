---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS — Value, хранящий число nanosecond от Unix epoch как signed int64 (номер формата Issuer IEEE 0x4000)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS — это число signed nanosecond от Unix epoch `1970-01-01T00:00:00Z`. Как и в POSIX seconds-since-the-Epoch, каждый день считается ровно 86,400 секундами, високосные секунды не учитываются.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, номер формата `0x4000`. Семейство TIME.
- Для обмена промышленными данными используется тот же физический тип signed int64 фиксированной ширины, что и в Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  всего 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
Номер формата     1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Интерпретация и допустимость

- Все 4 WORD Payload читаются как 64-битный signed count в дополнительном коде с порядком WORD big-endian.
- Допустимый диапазон — `-2^63`–`2^63-1` ns, диапазон instant — `1677-09-21 00:12:43.145224192Z`–`2262-04-11 23:47:16.854775807Z`.
- Даже малые значения всегда занимают 4 WORD. Сокращать до минимального целочисленного представления в WORD нельзя.
- Часовой пояс, исходное смещение UTC, метка (label) високосной секунды и таблица leap-second не хранятся.

## Длина

- Всего ровно 7 WORD: 1 WORD TAG, 1 WORD Issuer, 1 WORD номера формата и 4 WORD Payload; используется прямая длина `LLLL=0110`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, значение отклоняется.

## Примеры

- Epoch — Payload `0000 0000 0000 0000`, всего 7 WORD, `LLLL=0110`.
- 1 ns после epoch — Payload `0000 0000 0000 0001`.
- 1 ns до epoch — Payload `ffff ffff ffff ffff`.

## Основание в стандартах

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) определяет члены `time_t tv_sec` и `long tv_nsec`, а также `0 <= tv_nsec < 10^9`. Конкретная ширина и представление `time_t` зависят от среды реализации, а wire format в виде накопленных nanosecond в signed int64, объединяющий оба члена, не определён.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) считает день ровно 86,400 секундами.
- `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` в [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) хранит nanosecond от Unix epoch в одном `int64`. GEUL добавляет к этому физическому типу только TAG и framing 16-битными WORD в порядке big-endian.
