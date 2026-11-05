---
title: "CIVIL-TIME-NANOSECONDS (0x06BL)"
weight: 107
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS представляет гражданское время без даты числом наносекунд после полуночи."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Параметр | Значение |
|---|---|
| Имя | `CIVIL-TIME-NANOSECONDS` (документ спецификации BIND `CIVIL-TIME-NANOSECONDS`) |
| TAG ID | `0x06BL` |
| Codec ID | `0x000006B0` |
| Документ спецификации | `0x00000000/codecs/0x000006B0/` (цель DECLARE `06B0`) |
| Раздел | 3 `0011` (Value), смещение внутри раздела C = 11 |
| Kind | Value · семейство: TIME |
| TAG WORD | `0000 0110 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание индекса | unsigned счётчик наносекунд после полуночи гражданского дня |
| На стороне Hugo | `value/time/civil-time-nanoseconds.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD внутри документа — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | простое значение, 4 WORD |  |  |

CIVIL-TIME-NANOSECONDS представляет гражданское время без даты числом наносекунд после полуночи.

## Раскладка {#레이아웃}

- Код: прямой код Value `0x06BL`. Семейство TIME.
- Используется тот же физический тип — signed int64 фиксированной ширины, что у Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)`.

```
TAG WORD          0x06B4 (0000 0110 1011 0100)  всего 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Интерпретация и действительность {#해석과-유효성}

- Все 4 WORD Payload читаются как 64-битный signed счётчик в дополнительном коде с порядком WORD big-endian.
- Физический тип — signed int64, но допустимый диапазон — `0 <= value < 86,400×10^9` нс. Отрицательные значения и значения не меньше верхней границы отвергаются.
- `24:00` и метка високосной секунды не допускаются. Дата, часовой пояс и смещение UTC тоже не хранятся.
- Даже малые значения всегда занимают 4 WORD.

## Длина {#길이}

- Общая длина — ровно 5 WORD (TAG 1 WORD и Payload 4 WORD), используется прямая длина `LLLL=0100`. Length-расширяющего TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, запись отвергается.

## Пример {#예시}

- Полночь — Payload `0000 0000 0000 0000`, всего 5 WORD, `LLLL=0100`.
- 1 нс после полуночи — Payload `0000 0000 0000 0001`.
- `86,400×10^9` нс равно верхней границе, поэтому недействительно.
- `FFFF FFFF FFFF FFFF` как signed int64 равно -1, поэтому недействительно.

## Стандартное обоснование {#표준-근거}

- `TIME(isAdjustedToUTC=false, unit=NANOS)` в [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) хранит наносекунды после полуночи местного времени в `int64` с упорядочением signed.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html): авторитетный [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) определяет NANOSECOND Time как 64-битное signed целое, ограничивает допустимый диапазон значением менее 86 400 секунд, включая полночь, и не допускает високосных секунд. GEUL добавляет только TAG и обрамление 16-битными WORD big-endian.

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x000006B0/latest.geul`, прочитанный командой `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006B000000000
BODY
#1 DECLARE 0x06B0
#2 FIELD #1 0x0004
#3 BIND #1 "CIVIL-TIME-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
