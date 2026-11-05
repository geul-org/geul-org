---
title: "CASE-BEGIN (0x123L)"
weight: 291
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-BEGIN — запись исходного текста и разбиения документа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-BEGIN — запись исходного текста и разбиения документа TOULMIN. Значение: начало области дела.

| Пункт | Значение |
|---|---|
| Имя | `CASE-BEGIN` (BIND `CASE-BEGIN` документа спецификации) |
| TAG ID | `0x123L` |
| Codec ID | `0x00001230` |
| Документ спецификации | `0x00000000/codecs/0x00001230/` (объект DECLARE `1230`) |
| Раздел | 9 `1001` (формат Edge TOULMIN), смещение внутри раздела C = 3 |
| Kind | Edge · семейство: формат TOULMIN, раскладка: ID, REF (дело) |
| TAG WORD | `0001 0010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | начало области дела |
| Сторона Hugo | `edge/toulmin/source.md` |

## Раскладка {#레이아웃}

Начало области дела.

```
ID
Дело             REF(NODE CASE-DECLARE)
```

- Область дела — для одного дела (NODE [CASE-DECLARE](0x100L-case-declare.md)) — участок между CASE-BEGIN и [CASE-END](0x124L-case-end.md), указывающими на это дело.
- ID — Edge Id, REF — Edge Id записи этого документа ([TOULMIN](_index.md#공통-필드), общие поля). Поля Issuer и номера Codec нет, Payload идёт сразу за TAG.

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1230`). Объявление полей определяется вместе со спецификацией Codec TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [Исходный текст и разбиение](_index.md#source와-구획), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001230/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000123000000000
BODY
#1 DECLARE 0x1230
#2 BIND #1 "CASE-BEGIN"
```
