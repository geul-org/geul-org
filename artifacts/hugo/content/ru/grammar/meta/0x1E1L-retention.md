---
title: "RETENTION (0x1E1L)"
weight: 481
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Указывает срок хранения документа."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `RETENTION` (BIND документа спецификации `RETENTION`) |
| TAG ID | `0x1E1L` |
| Codec ID | `0x00001E10` |
| Документ спецификации | `0x00000000/codecs/0x00001E10/` (цель DECLARE `1E10`) |
| Раздел | 15 `1111` (Meta), смещение в разделе C = 1 |
| Kind | Meta · класс: политика |
| TAG WORD | `0001 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Срок хранения |
| Сторона Hugo | `meta/policy/retention.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `retention` | #2 | запись | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE, `06D0` DURATION-SECONDS |  |

Указывает срок хранения документа.

## Раскладка {#레이아웃}

```
TAG WORD          0001 1110 0001 LLLL      Codec 0x1E1L
[Length — расширяющий TAG]
Payload           момент истечения (GREGORIAN-DATE и т. п.) либо период (DURATION-SECONDS)
```

- Codec: Meta `0x1E1L`, класс политики
- Payload: встроенный Value (семейство TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) и др., либо [DURATION-SECONDS](../value/0x06DL-duration-seconds.md))
- Количество: не более одного

## Интерпретация и валидность {#해석과-유효성}

- Если это период, он отсчитывается от [RECORDED-AT](0x1D0L-recorded-at.md).

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001E10/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E1000000000
BODY
#1 DECLARE 0x1E10
#2 FIELD #1 record
#3 BIND #1 "RETENTION"
#4 BIND #2 "retention"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
#11 CODEC #2 0x06D0
```
