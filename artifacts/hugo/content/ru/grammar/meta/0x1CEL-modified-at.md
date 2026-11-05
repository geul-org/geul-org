---
title: "MODIFIED-AT (0x1CEL)"
weight: 462
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Указывает момент изменения документа."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `MODIFIED-AT` (BIND документа спецификации `MODIFIED-AT`) |
| TAG ID | `0x1CEL` |
| Codec ID | `0x00001CE0` |
| Документ спецификации | `0x00000000/codecs/0x00001CE0/` (цель DECLARE `1CE0`) |
| Раздел | 14 `1110` (Meta), смещение в разделе C = 14 |
| Kind | Meta · класс: происхождение |
| TAG WORD | `0001 1100 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Момент изменения. TIME Value |
| Сторона Hugo | `meta/provenance/modified-at.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | запись | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

Указывает момент изменения документа.

## Раскладка {#레이아웃}

```
TAG WORD          0001 1100 1110 LLLL      Codec 0x1CEL
[Length — расширяющий TAG]
Payload           один TIME Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS и т. д.)
```

- Codec: Meta `0x1CEL`, класс происхождения
- Payload: встроенный Value (семейство TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md) и др.)
- Количество: не более одного

## Интерпретация и валидность {#해석과-유효성}

- Формат выбирается среди Value семейства TIME. Если нужна точность, используется наносекундный формат, определённый Issuer (например, [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001CE0/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CE000000000
BODY
#1 DECLARE 0x1CE0
#2 FIELD #1 record
#3 BIND #1 "MODIFIED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
