---
title: "EFFECTIVE-UNTIL (0x1C9L)"
weight: 457
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Объявляет конец срока действия этой версии (временный закон)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `EFFECTIVE-UNTIL` (BIND документа спецификации `EFFECTIVE-UNTIL`) |
| TAG ID | `0x1C9L` |
| Codec ID | `0x00001C90` |
| Документ спецификации | `0x00000000/codecs/0x00001C90/` (цель DECLARE `1C90`) |
| Раздел | 14 `1110` (Meta), смещение в разделе C = 9 |
| Kind | Meta · класс: объявление |
| TAG WORD | `0001 1100 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Конец срока действия этой версии (временный закон). Если нет — до вступления в силу следующей версии |
| Сторона Hugo | `meta/declaration/effective-until.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | запись | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Объявляет конец срока действия этой версии (временный закон). С этого момента эта версия не действует.

## Раскладка {#레이아웃}

```
TAG WORD          0001 1100 1001 LLLL      Codec 0x1C9L
[Length — расширяющий TAG]
Payload           один TIME Value
```

- Codec: Meta `0x1C9L`, класс объявления
- Payload: встроенный Value ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) или [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Количество: не более одного

## Интерпретация и валидность {#해석과-유효성}

- Если записи нет, версия действует до вступления в силу следующей версии.
- По истечении срока действия действующей редакции нет. Прежняя редакция не возвращается.

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001C90/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C9000000000
BODY
#1 DECLARE 0x1C90
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-UNTIL"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
