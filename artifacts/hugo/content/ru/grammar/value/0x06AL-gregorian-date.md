---
title: "GREGORIAN-DATE (0x06AL)"
weight: 106
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE — знаковое число дней, где proleptic Gregorian 1970-01-01 принят за day 0."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Параметр | Значение |
|---|---|
| Имя | `GREGORIAN-DATE` (документ спецификации BIND `GREGORIAN-DATE`) |
| TAG ID | `0x06AL` |
| Codec ID | `0x000006A0` |
| Документ спецификации | `0x00000000/codecs/0x000006A0/` (цель DECLARE `06A0`) |
| Раздел | 3 `0011` (Value), смещение внутри раздела C = 10 |
| Kind | Value · семейство: TIME |
| TAG WORD | `0000 0110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание индекса | знаковое число дней от proleptic Gregorian `1970-01-01` |
| На стороне Hugo | `value/time/gregorian-date.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD внутри документа — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `days` | #2 | простое значение, 2 WORD |  |  |

GREGORIAN-DATE — знаковое число дней, где proleptic Gregorian `1970-01-01` принят за day 0. Часовой пояс и время суток не хранятся.

## Раскладка {#레이아웃}

- Код: прямой код Value `0x06AL`. Семейство TIME.
- Используется тот же физический тип — signed int32 фиксированной ширины, что у Arrow Date32 и Parquet `DATE`.

```
TAG WORD          0x06A2 (0000 0110 1010 0010)  всего 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## Интерпретация и действительность {#해석과-유효성}

- Все 2 WORD Payload читаются как 32-битный signed day count в дополнительном коде с порядком WORD big-endian.
- Допустимый диапазон — от `-2^31` до `2^31-1` дней. Отрицательные значения — даты до epoch.
- При обратном вычислении года, месяца и дня по day count используется proleptic Gregorian calendar без исторических переходов между календарями.
- Даже малые значения всегда занимают 2 WORD.

## Длина {#길이}

- Общая длина — ровно 3 WORD (TAG 1 WORD и Payload 2 WORD), используется прямая длина `LLLL=0010`. Length-расширяющего TAG, descriptor и padding нет.
- Если Payload не равен ровно 2 WORD, запись отвергается.

## Пример {#예시}

| Дата | Payload | Общая Length |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `FFFF FFFF` | 3 WORD (`LLLL=0010`) |

## Связь с EDTF {#edtf와의-관계}

- Точность грубее дня, неопределённость или приблизительность и интервалы записываются через [EDTF](0x06EL-edtf.md). Дату, которую можно точно записать в GREGORIAN-DATE, в EDTF не пишут (каноническая форма EDTF).

## Стандартное обоснование {#표준-근거}

- `DATE` в [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) — `int32`, хранящий число дней от Unix epoch 1970-01-01, с упорядочением signed.
- Date32 в [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) и авторитетном [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) хранит число дней от Unix epoch как 32-битное signed целое.
- Обратное вычисление по proleptic Gregorian — профиль календаря GEUL, принятый в этом формате. Смысл int32 day-count из Arrow/Parquet сохраняется, добавляются только TAG и обрамление 16-битными WORD big-endian.

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x000006A0/latest.geul`, прочитанный командой `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006A000000000
BODY
#1 DECLARE 0x06A0
#2 FIELD #1 0x0002
#3 BIND #1 "GREGORIAN-DATE"
#4 BIND #2 "days"
```
