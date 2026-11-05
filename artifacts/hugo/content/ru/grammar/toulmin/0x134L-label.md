---
title: "LABEL (0x134L)"
weight: 308
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LABEL — LINK Codec, записывающий отношение графа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL — LINK Codec, записывающий отношение графа TOULMIN. Значение: узел → TEXT, запись имени.

| Пункт | Значение |
|---|---|
| Имя | `LABEL` (BIND `LABEL` документа спецификации) |
| TAG ID | `0x134L` |
| Codec ID | `0x00001340` |
| Документ спецификации | `0x00000000/codecs/0x00001340/` (объект DECLARE `1340`) |
| Раздел | 9 `1001` (формат Edge TOULMIN), смещение внутри раздела C = 20 |
| Kind | Edge · семейство: формат TOULMIN, раскладка: LINK |
| TAG WORD | `0001 0011 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | узел → TEXT, запись имени |
| Сторона Hugo | `edge/toulmin/link.md` |

## Раскладка {#레이아웃}

Раскладка — [LINK](_index.md#link) (ID, src, dst, flags, условные поля, SPAN).

| Пункт | Значение |
|---|---|
| TANGEUL | имя в обратных кавычках |
| src → dst | узел → TEXT. Запись имени |

- dst — REF записи TEXT. Записывать ли имя в обратных кавычках как Edge-высказывания [LABEL](../edge/0x0A4L-label.md) и [BIND](../edge/0x0A3L-bind.md) — открытая проблема ([TOULMIN](_index.md#열린-문제)).
- F_FORCE не используется (если он включён, запись отклоняется).
- Общие поля (ID, REF, SPAN) и числовые правила следуют [TOULMIN](_index.md#공통-필드).

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1340`). Условные поля раскладки LINK и ширину SPAN, задаваемую SOURCE, нельзя объявить через FIELD, поэтому объявление полей остаётся открытой проблемой ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001340/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000134000000000
BODY
#1 DECLARE 0x1340
#2 BIND #1 "LABEL"
```
