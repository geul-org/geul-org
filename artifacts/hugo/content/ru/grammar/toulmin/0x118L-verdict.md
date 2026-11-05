---
title: "VERDICT (0x118L)"
weight: 280
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "VERDICT — Edge Codec семейства TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERDICT — Edge Codec семейства TOULMIN. Значение: результат вердикта узла или записи. Результат (Pass, Review, Fail), значение вердикта, Activated, Excluded, Level.

| Пункт | Значение |
|---|---|
| Имя | `VERDICT` (BIND `VERDICT` документа спецификации) |
| TAG ID | `0x118L` |
| Codec ID | `0x00001180` |
| Документ спецификации | `0x00000000/codecs/0x00001180/` (объект DECLARE `1180`) |
| Раздел | 8 `1000` (Edge TOULMIN), смещение внутри раздела C = 24 |
| Kind | Edge · семейство: TOULMIN, группа: результат |
| TAG WORD | `0001 0001 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | результат вердикта узла или записи. Результат (Pass, Review, Fail), значение вердикта, Activated, Excluded, Level. Раскладка не определена |
| Сторона Hugo | `edge/toulmin/_index.md` |

## Раскладка {#레이아웃}

Назначен только код, раскладки пока нет ([TOULMIN](_index.md#열린-문제)).

- Вердикт всего документа ведёт Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`). Это два разных Codec с разным Kind.
- Результат вердикта хранится в документе, отличном от объекта вердикта ([TOULMIN](_index.md#판정-결과)).

## Документ Codec {#코덱-문서}

Раскладка не определена. Документ Codec содержит только DECLARE (объект `1180`). FIELD будет добавлен, когда раскладка определится.

## Связанные страницы {#관련-페이지}

- [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001180/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000118000000000
BODY
#1 DECLARE 0x1180
#2 BIND #1 "VERDICT"
```
