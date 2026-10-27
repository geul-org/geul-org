---
title: "POSIX-TIMESTAMP-SECONDS"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS — Value, хранящий число секунд от Unix epoch как signed int64 (Codec 0x22)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-SECONDS — это число signed секунд от Unix epoch `1970-01-01T00:00:00Z`. Как и в POSIX seconds-since-the-Epoch, каждый день считается ровно 86,400 секундами, високосные секунды не учитываются.

## Раскладка

- Код: прямой код Value `0x22`. Семейство TIME.
- Для обмена промышленными данными используется тот же физический тип signed int64 фиксированной ширины, что и в Arrow `timestamp[s]`.

```
TAG WORD          0x0A22 (0000 1010 0010 0010)  всего 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Интерпретация и допустимость

- Все 4 WORD Payload читаются как 64-битный signed count в дополнительном коде с порядком WORD big-endian.
- Допустимый диапазон — `-2^63`–`2^63-1` секунд. Отрицательное значение — instant до epoch.
- Даже малые значения всегда занимают 4 WORD. Сокращать до минимального целочисленного представления в WORD нельзя.
- Часовой пояс, исходное смещение UTC, метка (label) високосной секунды и таблица leap-second не хранятся.

## Длина

- Всего ровно 5 WORD: 1 WORD TAG и 4 WORD Payload; используется прямая длина `LLLL=0100`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, значение отклоняется.

## Примеры

- Epoch — Payload `0000 0000 0000 0000`, всего 5 WORD, `LLLL=0100`.
- 1 секунда после epoch — Payload `0000 0000 0000 0001`.
- 1 секунда до epoch — Payload `ffff ffff ffff ffff`.

## Основание в стандартах

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) лишь определяет члены `time_t tv_sec` и `long tv_nsec` и не определяет wire format сериализации накопленных секунд в signed int64. Конкретная ширина и представление `time_t` зависят от среды реализации и не совпадают с представлением Payload в GEUL.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) определяет соответствие секунд после epoch календарю и правило 86,400 секунд в сутках.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) и authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) определяют timestamp как 64-битное signed целое от фиксированного epoch, поддерживают единицу SECOND и не учитывают високосные секунды. GEUL добавляет к этому физическому типу только TAG и framing 16-битными WORD в порядке big-endian.
