---
title: "CASE-END (0x124L)"
weight: 292
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-END — запись исходного текста и разбиения документа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-END — запись исходного текста и разбиения документа TOULMIN. Значение: конец области дела.

| Пункт | Значение |
|---|---|
| Имя | `CASE-END` (BIND `CASE-END` документа спецификации) |
| TAG ID | `0x124L` |
| Codec ID | `0x00001240` |
| Документ спецификации | `0x00000000/codecs/0x00001240/` (объект DECLARE `1240`) |
| Раздел | 9 `1001` (формат Edge TOULMIN), смещение внутри раздела C = 4 |
| Kind | Edge · семейство: формат TOULMIN, раскладка: ID, REF (дело) |
| TAG WORD | `0001 0010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | конец области дела |
| Сторона Hugo | `edge/toulmin/source.md` |

## Раскладка {#레이아웃}

Конец области дела.

```
ID
Дело             REF(NODE CASE-DECLARE)
```

- Область дела — для одного дела (NODE [CASE-DECLARE](0x100L-case-declare.md)) — участок между [CASE-BEGIN](0x123L-case-begin.md) и CASE-END, указывающими на это дело.
- ID — Edge Id, REF — Edge Id записи этого документа ([TOULMIN](_index.md#공통-필드), общие поля). Поля Issuer и номера Codec нет, Payload идёт сразу за TAG.

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1240`). Объявление полей определяется вместе со спецификацией Codec TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [Исходный текст и разбиение](_index.md#source와-구획), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001240/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000124000000000
BODY
#1 DECLARE 0x1240
#2 BIND #1 "CASE-END"
```
