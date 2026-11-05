---
title: "SQUASHED-FROM (0x1D8L)"
weight: 472
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Указывает хеши содержимого исходных версий, объединённых в одну (git squash)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `SQUASHED-FROM` (BIND документа спецификации `SQUASHED-FROM`) |
| TAG ID | `0x1D8L` |
| Codec ID | `0x00001D80` |
| Документ спецификации | `0x00000000/codecs/0x00001D80/` (цель DECLARE `1D80`) |
| Раздел | 14 `1110` (Meta), смещение в разделе C = 24 |
| Kind | Meta · класс: родословная |
| TAG WORD | `0001 1101 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Хеши содержимого исходных версий, объединённых в одну (git squash) |
| Сторона Hugo | `meta/lineage/squashed-from.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | запись | `07C0` SHA-256-DIGEST |  |

Указывает хеши содержимого исходных версий, объединённых в одну (git squash).

## Раскладка {#레이아웃}

```
TAG WORD          0001 1101 1000 LLLL      Codec 0x1D8L
[Length — расширяющий TAG]
Payload           один SHA-256-DIGEST Value (16 WORD)
```

- Codec: Meta `0x1D8L`, класс родословной
- Payload: встроенный Value ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Количество: может быть несколько (по одному на исходную версию)

## Интерпретация и валидность {#해석과-유효성}

- Формат дайджеста встроен как Value, что оставляет возможность сменить алгоритм хеширования. Сейчас хеш содержимого — только SHA-256.

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001D80/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D8000000000
BODY
#1 DECLARE 0x1D80
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "SQUASHED-FROM"
#4 BIND #2 "digest"
```
