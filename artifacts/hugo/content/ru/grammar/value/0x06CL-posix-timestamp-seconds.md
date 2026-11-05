---
title: "POSIX-TIMESTAMP-SECONDS (0x06CL)"
weight: 108
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS — знаковое число секунд от Unix epoch 1970-01-01T00:00:00Z."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Параметр | Значение |
|---|---|
| Имя | `POSIX-TIMESTAMP-SECONDS` (документ спецификации BIND `POSIX-TIMESTAMP-SECONDS`) |
| TAG ID | `0x06CL` |
| Codec ID | `0x000006C0` |
| Документ спецификации | `0x00000000/codecs/0x000006C0/` (цель DECLARE `06C0`) |
| Раздел | 3 `0011` (Value), смещение внутри раздела C = 12 |
| Kind | Value · семейство: TIME |
| TAG WORD | `0000 0110 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание индекса | знаковый счётчик секунд от Unix/POSIX epoch |
| На стороне Hugo | `value/time/posix-timestamp-seconds.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD внутри документа — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | простое значение, 4 WORD |  |  |

POSIX-TIMESTAMP-SECONDS — знаковое число секунд от Unix epoch `1970-01-01T00:00:00Z`. Как и в POSIX seconds-since-the-Epoch, каждый день считается ровно 86 400 секунд, високосные секунды не учитываются.

## Раскладка {#레이아웃}

- Код: прямой код Value `0x06CL`. Семейство TIME.
- Для обмена промышленными данными используется тот же физический тип — signed int64 фиксированной ширины, что у Arrow `timestamp[s]`.

```
TAG WORD          0x06C4 (0000 0110 1100 0100)  всего 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Интерпретация и действительность {#해석과-유효성}

- Все 4 WORD Payload читаются как 64-битный signed счётчик в дополнительном коде с порядком WORD big-endian.
- Допустимый диапазон — от `-2^63` до `2^63-1` секунд. Отрицательные значения — instant до epoch.
- Даже малые значения всегда занимают 4 WORD. Сокращать до целочисленного представления минимальной длины в WORD нельзя.
- timezone, исходное смещение UTC, метка високосной секунды и таблица leap-second не хранятся.

## Длина {#길이}

- Общая длина — ровно 5 WORD (TAG 1 WORD и Payload 4 WORD), используется прямая длина `LLLL=0100`. Length-расширяющего TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, запись отвергается.

## Пример {#예시}

- epoch — Payload `0000 0000 0000 0000`, всего 5 WORD, `LLLL=0100`.
- 1 секунда после epoch — Payload `0000 0000 0000 0001`.
- 1 секунда до epoch — Payload `FFFF FFFF FFFF FFFF`.

## Стандартное обоснование {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) лишь определяет члены `time_t tv_sec` и `long tv_nsec` и не задаёт wire format для сериализации накопленных секунд в signed int64. Конкретная ширина и представление `time_t` зависят от среды реализации и не совпадают с представлением Payload в GEUL.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) определяет соответствие секунд после epoch календарю и правило 86 400 секунд в сутках.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) и авторитетный [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) определяют timestamp как 64-битное signed целое от фиксированного epoch, поддерживают единицу SECOND и не считают високосные секунды. GEUL добавляет к этому физическому типу только TAG и обрамление 16-битными WORD big-endian.

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x000006C0/latest.geul`, прочитанный командой `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006C000000000
BODY
#1 DECLARE 0x06C0
#2 FIELD #1 0x0004
#3 BIND #1 "POSIX-TIMESTAMP-SECONDS"
#4 BIND #2 "seconds"
```
