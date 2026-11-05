---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1032
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS — число signed nanosecond, отсчитанное от эпохи Unix 1970-01-01T00:00:00Z."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS — число signed nanosecond, отсчитанное от эпохи Unix `1970-01-01T00:00:00Z`. Как и в seconds-since-the-Epoch в POSIX, каждый день считается ровно 86 400 секунд, а високосные секунды не учитываются.

## Раскладка {#레이아웃}

- Код: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, номер Codec `0x00004000`. Семейство TIME.
- Для обмена промышленными данными используется тот же физический тип signed int64 фиксированной ширины, что и в Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  всего 9 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Номер Codec       2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Интерпретация и действительность {#해석과-유효성}

- Все 4 WORD Payload читаются как 64-битный signed count в дополнительном коде в порядке big-endian WORD.
- Допустимый диапазон — от `-2^63` до `2^63-1` ns, а диапазон instant — от `1677-09-21 00:12:43.145224192Z` до `2262-04-11 23:47:16.854775807Z`.
- Даже малые значения всегда занимают 4 WORD. Сокращать до минимального целочисленного представления WORD нельзя.
- Часовой пояс, исходное смещение UTC, метка високосной секунды и таблица leap-second не включаются.

## Длина {#길이}

- Общая длина — ровно 9 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 4 WORD; используется прямая длина `LLLL=1000`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 4 WORD, значение отклоняется.

## Пример {#예시}

- Epoch — Payload `0000 0000 0000 0000`, всего 9 WORD, `LLLL=1000`.
- 1 ns после epoch — Payload `0000 0000 0000 0001`.
- 1 ns до epoch — Payload `FFFF FFFF FFFF FFFF`.

## Стандартные основания {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) определяет члены `time_t tv_sec` и `long tv_nsec`, а также `0 <= tv_nsec < 10^9`. Конкретная ширина и представление `time_t` зависят от среды реализации, а wire format накопленных nanosecond в виде signed int64, объединяющего оба члена, не определяется.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) считает день ровно 86 400 секунд.
- `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` в [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) хранит nanosecond от эпохи Unix в одном `int64`. GEUL добавляет к этому физическому типу только TAG и framing в 16-битные big-endian WORD.
