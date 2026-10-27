---
title: "GREGORIAN-DATE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE — Value, хранящий число дней как signed int32, где day 0 — proleptic Gregorian 1970-01-01 (Codec 0x20)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GREGORIAN-DATE — это signed число дней, где day 0 — proleptic Gregorian `1970-01-01`. Часовой пояс и время суток не хранятся.

## Раскладка

- Код: прямой код Value `0x20`. Семейство TIME.
- Используется тот же физический тип signed int32 фиксированной ширины, что и в Arrow Date32 и Parquet `DATE`.

```
TAG WORD          0x0920 (0000 1001 0010 0000)  всего 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## Интерпретация и допустимость

- Оба Payload WORD читаются как 32-битный signed day count в дополнительном коде с порядком WORD big-endian.
- Допустимый диапазон — `-2^31`–`2^31-1` дней. Отрицательное значение — дата до epoch.
- При обратном пересчёте day count в год, месяц и день используется proleptic Gregorian calendar без исторических переходов между календарями.
- Даже малые значения всегда занимают 2 WORD.

## Длина

- Всего ровно 3 WORD: 1 WORD TAG и 2 WORD Payload; используется прямая длина `LLLL=0010`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 2 WORD, значение отклоняется.

## Примеры

| Дата | Payload | Полная Length |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `ffff ffff` | 3 WORD (`LLLL=0010`) |

## Связь с EDTF

- Точность грубее дня, неопределённые и приблизительные даты, а также интервалы записываются как [EDTF](/ru/grammar/value/time/edtf/). Дата, которую можно точно записать как GREGORIAN-DATE, не записывается как EDTF (нормальная форма EDTF).

## Основание в стандартах

- `DATE` в [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) — это `int32`, хранящий число дней от Unix epoch 1970-01-01 с порядком signed.
- Date32 в [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) и в authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) хранит число дней от Unix epoch как 32-битное signed целое.
- Обратный пересчёт по proleptic Gregorian — GEUL calendar profile, принятый этим форматом. Семантика int32 day-count в Arrow/Parquet остаётся прежней, GEUL добавляет только TAG и framing 16-битными WORD в порядке big-endian.
