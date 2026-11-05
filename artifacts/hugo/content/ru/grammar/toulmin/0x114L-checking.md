---
title: "CHECKING (0x114L)"
weight: 276
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CHECKING — LINK Codec, записывающий отношение графа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CHECKING — LINK Codec, записывающий отношение графа TOULMIN. Значение: связь, которая только выносит вердикт, без побочных эффектов.

| Пункт | Значение |
|---|---|
| Имя | `CHECKING` (BIND `CHECKING` документа спецификации) |
| TAG ID | `0x114L` |
| Codec ID | `0x00001140` |
| Документ спецификации | `0x00000000/codecs/0x00001140/` (объект DECLARE `1140`) |
| Раздел | 8 `1000` (Edge TOULMIN), смещение внутри раздела C = 20 |
| Kind | Edge · семейство: TOULMIN, группа: выполнение, раскладка: LINK |
| TAG WORD | `0001 0001 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | связь, которая только выносит вердикт, без побочных эффектов |
| Сторона Hugo | `edge/toulmin/link.md` |

## Раскладка {#레이아웃}

Раскладка — [LINK](_index.md#link) (ID, src, dst, flags, условные поля, SPAN).

| Пункт | Значение |
|---|---|
| TANGEUL | `checking c` |
| src → dst | правило → дело. Вердикт без побочных эффектов |

- dst — REF узла.
- F_FORCE не используется (если он включён, запись отклоняется).
- Общие поля (ID, REF, SPAN) и числовые правила следуют [TOULMIN](_index.md#공통-필드).

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1140`). Условные поля раскладки LINK и ширину SPAN, задаваемую SOURCE, нельзя объявить через FIELD, поэтому объявление полей остаётся открытой проблемой ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001140/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000114000000000
BODY
#1 DECLARE 0x1140
#2 BIND #1 "CHECKING"
```
