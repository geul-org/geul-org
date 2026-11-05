---
title: "DURATION-SECONDS (0x06DL)"
weight: 109
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS — знаковое прошедшее время в секундах без epoch."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Параметр | Значение |
|---|---|
| Имя | `DURATION-SECONDS` (документ спецификации BIND `DURATION-SECONDS`) |
| TAG ID | `0x06DL` |
| Codec ID | `0x000006D0` |
| Документ спецификации | `0x00000000/codecs/0x000006D0/` (цель DECLARE `06D0`) |
| Раздел | 3 `0011` (Value), смещение внутри раздела C = 13 |
| Kind | Value · семейство: TIME |
| TAG WORD | `0000 0110 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание индекса | знаковое прошедшее время в SI-секундах без epoch |
| На стороне Hugo | `value/time/duration-seconds.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD внутри документа — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | простое значение, 4 WORD |  |  |

DURATION-SECONDS — знаковое прошедшее время в секундах без epoch. Это не instant и не календарный период в месяцах или годах.

## Раскладка {#레이아웃}

- Код: прямой код Value `0x06DL`. Семейство TIME.
- Используется тот же физический тип — signed int64 фиксированной ширины, что у Arrow `Duration(SECOND)`.

```
TAG WORD          0x06D4 (0000 0110 1101 0100)  всего 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Интерпретация и действительность {#해석과-유효성}

- Все 4 WORD Payload читаются как 64-битный signed счётчик в дополнительном коде с порядком WORD big-endian.
- Допустимый диапазон — от `-2^63` до `2^63-1` секунд. Знак — направление отсчёта и не указывает на instant какого-либо конкретного epoch.
- Даже малые значения всегда занимают 4 WORD.

## Длина {#길이}

- Общая длина — ровно 5 WORD (TAG 1 WORD и Payload 4 WORD), используется прямая длина `LLLL=0100`. Length-расширяющего TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, запись отвергается.

## Пример {#예시}

- 0 секунд — Payload `0000 0000 0000 0000`, всего 5 WORD, `LLLL=0100`.
- 1 секунда — Payload `0000 0000 0000 0001`.
- -1 секунда — Payload `FFFF FFFF FFFF FFFF`.

## Стандартное обоснование {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) назначает `Schema.fbs` авторитетным источником стандартных типов данных Arrow.
- В авторитетном [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) Arrow `Duration` — абсолютное прошедшее время, не зависящее от календаря, поддерживает единицу SECOND и всегда представлен 8-байтовым signed целым. GEUL добавляет к нему только TAG и обрамление 16-битными WORD big-endian.

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x000006D0/latest.geul`, прочитанный командой `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006D000000000
BODY
#1 DECLARE 0x06D0
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-SECONDS"
#4 BIND #2 "seconds"
```
