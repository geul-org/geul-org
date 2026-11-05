---
title: "REVERTS (0x1D6L)"
weight: 470
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Указывает хеш содержимого версии, изменение которой отменено (git revert)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `REVERTS` (BIND документа спецификации `REVERTS`) |
| TAG ID | `0x1D6L` |
| Codec ID | `0x00001D60` |
| Документ спецификации | `0x00000000/codecs/0x00001D60/` (цель DECLARE `1D60`) |
| Раздел | 14 `1110` (Meta), смещение в разделе C = 22 |
| Kind | Meta · класс: родословная |
| TAG WORD | `0001 1101 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Хеш содержимого версии, изменение которой отменено (git revert) |
| Сторона Hugo | `meta/lineage/reverts.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | запись | `07C0` SHA-256-DIGEST |  |

Указывает хеш содержимого версии, изменение которой отменено (git revert).

## Раскладка {#레이아웃}

```
TAG WORD          0001 1101 0110 LLLL      Codec 0x1D6L
[Length — расширяющий TAG]
Payload           один SHA-256-DIGEST Value (16 WORD)
```

- Codec: Meta `0x1D6L`, класс родословной
- Payload: встроенный Value ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Количество: может быть несколько

## Интерпретация и валидность {#해석과-유효성}

- Формат дайджеста встроен как Value, что оставляет возможность сменить алгоритм хеширования. Сейчас хеш содержимого — только SHA-256.

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001D60/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D6000000000
BODY
#1 DECLARE 0x1D60
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "REVERTS"
#4 BIND #2 "digest"
```
