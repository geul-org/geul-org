---
title: "EFFECTIVE-FROM (0x1C8L)"
weight: 456
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Объявляет дату вступления этой версии в силу."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `EFFECTIVE-FROM` (BIND документа спецификации `EFFECTIVE-FROM`) |
| TAG ID | `0x1C8L` |
| Codec ID | `0x00001C80` |
| Документ спецификации | `0x00000000/codecs/0x00001C80/` (цель DECLARE `1C80`) |
| Раздел | 14 `1110` (Meta), смещение в разделе C = 8 |
| Kind | Meta · класс: объявление |
| TAG WORD | `0001 1100 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Дата вступления этой версии в силу. Value GREGORIAN-DATE или POSIX-TIMESTAMP. Если нет — момент публикации |
| Сторона Hugo | `meta/declaration/effective-from.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | запись | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Объявляет дату вступления этой версии в силу. Дата вступления в силу отличается от момента публикации ([Редакция](../document.md#개정)).

## Раскладка {#레이아웃}

```
TAG WORD          0001 1100 1000 LLLL      Codec 0x1C8L
[Length — расширяющий TAG]
Payload           один TIME Value
```

- Codec: Meta `0x1C8L`, класс объявления
- Payload: встроенный Value ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) или [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Количество: не более одного

## Интерпретация и валидность {#해석과-유효성}

- Если записи нет, версия действует с момента публикации.
- Если есть [EFFECTIVE-UNTIL](0x1C9L-effective-until.md), эта дата должна быть раньше неё.
- Если даты вступления в силу различаются по статьям, они записываются отдельно в Edge соответствующей статьи через QUALIFIER P580 (начало) и P582 (конец) ([SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).
- Это значение читается, когда документ интерпретируется на определённый момент времени.

## Пример {#예시}

- Вступает в силу 1970-01-02: `0x1C83 0x06A2 0x0000 0x0001`

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001C80/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C8000000000
BODY
#1 DECLARE 0x1C80
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-FROM"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
