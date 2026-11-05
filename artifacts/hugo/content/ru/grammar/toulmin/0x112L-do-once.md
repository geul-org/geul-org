---
title: "DO-ONCE (0x112L)"
weight: 274
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "DO-ONCE — LINK Codec, записывающий отношение графа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DO-ONCE — LINK Codec, записывающий отношение графа TOULMIN. Значение: действие, выполняемое только один раз даже при повторных попытках.

| Пункт | Значение |
|---|---|
| Имя | `DO-ONCE` (BIND `DO-ONCE` документа спецификации) |
| TAG ID | `0x112L` |
| Codec ID | `0x00001120` |
| Документ спецификации | `0x00000000/codecs/0x00001120/` (объект DECLARE `1120`) |
| Раздел | 8 `1000` (Edge TOULMIN), смещение внутри раздела C = 18 |
| Kind | Edge · семейство: TOULMIN, группа: выполнение, раскладка: LINK |
| TAG WORD | `0001 0001 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | действие, выполняемое только один раз даже при повторных попытках |
| Сторона Hugo | `edge/toulmin/link.md` |

## Раскладка {#레이아웃}

Раскладка — [LINK](_index.md#link) (ID, src, dst, flags, условные поля, SPAN).

| Пункт | Значение |
|---|---|
| TANGEUL | `do fn once when n` |
| src → dst | правило → FuncRef |

- dst — FuncRef. `do … once` выражается этим Codec. F_ONCE в flags не используется (если он включён, запись отклоняется).
- F_FORCE не используется (если он включён, запись отклоняется).
- Общие поля (ID, REF, SPAN) и числовые правила следуют [TOULMIN](_index.md#공통-필드).

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1120`). Условные поля раскладки LINK и ширину SPAN, задаваемую SOURCE, нельзя объявить через FIELD, поэтому объявление полей остаётся открытой проблемой ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001120/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000112000000000
BODY
#1 DECLARE 0x1120
#2 BIND #1 "DO-ONCE"
```
