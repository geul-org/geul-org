---
title: "DURATION-NANOSECONDS (0x081L)"
weight: 129
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS — прошедшее время в signed наносекундах без epoch."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS — прошедшее время в signed наносекундах без epoch. Это не instant и не календарный промежуток в месяцах или годах.

| Пункт | Значение |
|---|---|
| Имя | `DURATION-NANOSECONDS` (BIND в документе спецификации `DURATION-NANOSECONDS`) |
| TAG ID | `0x081L` |
| Codec ID | `0x00000810` |
| Документ спецификации | `0x00000000/codecs/0x00000810/` (цель DECLARE `0810`) |
| Раздел | 4 `0100` (Value), смещение C внутри раздела = 1 |
| Kind | Value · семейство: TIME |
| TAG WORD | `0000 1000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Прошедшее время в signed наносекундах без epoch |
| Сторона Hugo | `value/time/duration-nanoseconds.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | простое значение, 4 WORD |  |  |

## Раскладка {#레이아웃}

- Код: прямой код Value `0x081L`. Семейство TIME.
- Используется тот же физический тип фиксированной ширины signed int64, что и в Arrow `Duration(NANOSECOND)`.

```
TAG WORD          0x0814 (0000 1000 0001 0100)  всего 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Интерпретация и действительность {#해석과-유효성}

- Все 4 WORD Payload читаются как 64-битный signed счётчик в дополнительном коде с порядком WORD big-endian.
- Допустимый диапазон — от `-2^63` до `2^63-1` нс. Знак показывает направление отсчёта и не указывает на instant какого-либо epoch.
- Даже малые значения всегда занимают 4 WORD.

## Длина {#길이}

- Всего — ровно 5 WORD: TAG 1 WORD и Payload 4 WORD; используется прямая длина `LLLL=0100`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, значение отвергается.

## Примеры {#예시}

- 0 нс: Payload `0000 0000 0000 0000`, всего 5 WORD, `LLLL=0100`. Целиком: `0814 0000 0000 0000 0000`.
- 1 нс: Payload `0000 0000 0000 0001`.
- -1 нс: Payload `FFFF FFFF FFFF FFFF`.

## Основание в стандартах {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) назначает `Schema.fbs` авторитетным источником стандартных типов данных Arrow.
- В авторитетном [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) Arrow `Duration` — абсолютное прошедшее время, не зависящее от календаря; поддерживается единица NANOSECOND, и значение всегда представляется 8-byte signed целым. GEUL добавляет лишь TAG и обрамление big-endian 16-битными WORD.

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00000810/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные цифры заглавные).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000081000000000
BODY
#1 DECLARE 0x0810
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
