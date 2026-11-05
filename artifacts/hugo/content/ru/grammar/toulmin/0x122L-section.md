---
title: "SECTION (0x122L)"
weight: 290
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SECTION — запись исходного текста и разбиения документа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SECTION — запись исходного текста и разбиения документа TOULMIN. Значение: начало раздела.

| Пункт | Значение |
|---|---|
| Имя | `SECTION` (BIND `SECTION` документа спецификации) |
| TAG ID | `0x122L` |
| Codec ID | `0x00001220` |
| Документ спецификации | `0x00000000/codecs/0x00001220/` (объект DECLARE `1220`) |
| Раздел | 9 `1001` (формат Edge TOULMIN), смещение внутри раздела C = 2 |
| Kind | Edge · семейство: формат TOULMIN, раскладка: ID, код раздела 1 WORD |
| TAG WORD | `0001 0010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | начало раздела |
| Сторона Hugo | `edge/toulmin/source.md` |

## Раскладка {#레이아웃}

Начало раздела. Код раздела занимает 1 WORD.

```
ID
Код раздела      1 WORD
```

| Код | Раздел | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | правила в виде условных выражений |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` не используется. Разделы объявляются в порядке этих кодов.
- Заголовок раздела — [PROSE](0x125L-prose.md) сразу после SECTION.
- ID — Edge Id, REF — Edge Id записи этого документа ([TOULMIN](_index.md#공통-필드), общие поля). Поля Issuer и номера Codec нет, Payload идёт сразу за TAG.

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1220`). Объявление полей определяется вместе со спецификацией Codec TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [Исходный текст и разбиение](_index.md#source와-구획), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001220/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000122000000000
BODY
#1 DECLARE 0x1220
#2 BIND #1 "SECTION"
```
