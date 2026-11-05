---
title: "TEXT (0x121L)"
weight: 289
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TEXT — запись исходного текста и разбиения документа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT — запись исходного текста и разбиения документа TOULMIN. Значение: имя или строка.

| Пункт | Значение |
|---|---|
| Имя | `TEXT` (BIND `TEXT` документа спецификации) |
| TAG ID | `0x121L` |
| Codec ID | `0x00001210` |
| Документ спецификации | `0x00000000/codecs/0x00001210/` (объект DECLARE `1210`) |
| Раздел | 9 `1001` (формат Edge TOULMIN), смещение внутри раздела C = 1 |
| Kind | Edge · семейство: формат TOULMIN, раскладка: ID, UTF8 Value |
| TAG WORD | `0001 0010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | имя или строка |
| Сторона Hugo | `edge/toulmin/source.md` |

## Раскладка {#레이아웃}

Одно имя или строка. На неё по REF указывают списки F_WITH и F_GROUNDS у NODE, а также [LABEL](0x134L-label.md) и [IMPORTED-FROM](0x133L-imported-from.md) у LINK.

```
ID
Строка           запись UTF8-TEXT Value
```

- ID — Edge Id, REF — Edge Id записи этого документа ([TOULMIN](_index.md#공통-필드), общие поля). Поля Issuer и номера Codec нет, Payload идёт сразу за TAG.

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1210`). Объявление полей определяется вместе со спецификацией Codec TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [Исходный текст и разбиение](_index.md#source와-구획), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001210/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000121000000000
BODY
#1 DECLARE 0x1210
#2 BIND #1 "TEXT"
```
