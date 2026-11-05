---
title: "SUPERSEDE-CHAIN (0x10AL)"
weight: 266
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDE-CHAIN — Edge Codec семейства TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDE-CHAIN — Edge Codec семейства TOULMIN. Значение: цепочка приоритетов `A > B > C`. Сокращение попарных SUPERSEDES.

| Пункт | Значение |
|---|---|
| Имя | `SUPERSEDE-CHAIN` (BIND `SUPERSEDE-CHAIN` документа спецификации) |
| TAG ID | `0x10AL` |
| Codec ID | `0x000010A0` |
| Документ спецификации | `0x00000000/codecs/0x000010A0/` (объект DECLARE `10A0`) |
| Раздел | 8 `1000` (Edge TOULMIN), смещение внутри раздела C = 10 |
| Kind | Edge · семейство: TOULMIN, группа: отношение |
| TAG WORD | `0001 0000 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | цепочка приоритетов `A > B > C`. Сокращение попарных SUPERSEDES. Раскладка не определена |
| Сторона Hugo | `edge/toulmin/_index.md` |

## Раскладка {#레이아웃}

Назначен только код, раскладки пока нет ([TOULMIN](_index.md#열린-문제)).

- Сейчас [SUPERSEDES](0x109L-supersedes.md) записывается по одному на каждую пару. Достаточно ли этого для цепочки — открытая проблема.

## Документ Codec {#코덱-문서}

Раскладка не определена. Документ Codec содержит только DECLARE (объект `10A0`). FIELD будет добавлен, когда раскладка определится.

## Связанные страницы {#관련-페이지}

- [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x000010A0/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000010A000000000
BODY
#1 DECLARE 0x10A0
#2 BIND #1 "SUPERSEDE-CHAIN"
```
