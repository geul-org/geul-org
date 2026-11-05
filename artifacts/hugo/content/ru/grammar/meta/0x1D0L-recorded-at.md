---
title: "RECORDED-AT (0x1D0L)"
weight: 464
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Указывает момент фиксации документа (git commit date)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `RECORDED-AT` (BIND документа спецификации `RECORDED-AT`) |
| TAG ID | `0x1D0L` |
| Codec ID | `0x00001D00` |
| Документ спецификации | `0x00000000/codecs/0x00001D00/` (цель DECLARE `1D00`) |
| Раздел | 14 `1110` (Meta), смещение в разделе C = 16 |
| Kind | Meta · класс: происхождение |
| TAG WORD | `0001 1101 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Момент фиксации. TIME Value (git commit date) |
| Сторона Hugo | `meta/provenance/recorded-at.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | запись | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

Указывает момент фиксации документа (git commit date).

## Раскладка {#레이아웃}

```
TAG WORD          0001 1101 0000 LLLL      Codec 0x1D0L
[Length — расширяющий TAG]
Payload           один TIME Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS и т. д.)
```

- Codec: Meta `0x1D0L`, класс происхождения
- Payload: встроенный Value (семейство TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md) и др.)
- Количество: не более одного

## Интерпретация и валидность {#해석과-유효성}

- Формат выбирается среди Value семейства TIME. Если нужна точность, используется наносекундный формат, определённый Issuer (например, [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).
- Документ списка версий ([PUBLICATION](../edge/0x0B8L-publication.md)) использует это значение как момент публикации, объявления устаревшим (deprecate) и удаления.

## Открытые проблемы {#열린-문제}

- Meta происхождения входят в хеш содержимого. Допускать ли, что хеш различается, если одно и то же содержимое зафиксировано в разное время.

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001D00/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D0000000000
BODY
#1 DECLARE 0x1D00
#2 FIELD #1 record
#3 BIND #1 "RECORDED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
