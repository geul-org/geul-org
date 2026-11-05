---
title: "MESSAGE (0x1D9L)"
weight: 473
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Указывает причину изменения (git commit message)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `MESSAGE` (BIND документа спецификации `MESSAGE`) |
| TAG ID | `0x1D9L` |
| Codec ID | `0x00001D90` |
| Документ спецификации | `0x00000000/codecs/0x00001D90/` (цель DECLARE `1D90`) |
| Раздел | 14 `1110` (Meta), смещение в разделе C = 25 |
| Kind | Meta · класс: родословная |
| TAG WORD | `0001 1101 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Причина изменения. UTF8-LANGUAGE-TEXT Value, по одному на язык (git commit message) |
| Сторона Hugo | `meta/lineage/message.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `message` | #2 | запись | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Указывает причину изменения (git commit message).

## Раскладка {#레이아웃}

```
TAG WORD          0001 1101 1001 LLLL      Codec 0x1D9L
[Length — расширяющий TAG]
Сообщение         1 UTF8-LANGUAGE-TEXT Value
```

- Codec: Meta `0x1D9L`, класс родословной
- Payload: встроенный Value ([UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md))
- Количество: не более одного на язык

## Интерпретация и валидность {#해석과-유효성}

- Сообщение и язык помещаются в один UTF8-LANGUAGE-TEXT. MESSAGE для одного и того же языка — один.
- В документе спецификации geul.org это записано через [CODEC](../edge/0x0BEL-codec.md) `0780`, `0790`.

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001D90/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D9000000000
BODY
#1 DECLARE 0x1D90
#2 FIELD #1 record
#3 BIND #1 "MESSAGE"
#4 BIND #2 "message"
#5 CODEC #2 0x0780
#6 CODEC #2 0x0790
```
