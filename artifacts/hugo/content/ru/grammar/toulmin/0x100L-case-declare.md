---
title: "CASE-DECLARE (0x100L)"
weight: 256
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-DECLARE — NODE Codec, записывающий узел графа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-DECLARE — NODE Codec, записывающий узел графа TOULMIN. Значение: объявление дела. Граф вердиктов, содержащий узлы и отношения.

| Пункт | Значение |
|---|---|
| Имя | `CASE-DECLARE` (BIND `CASE-DECLARE` документа спецификации) |
| TAG ID | `0x100L` |
| Codec ID | `0x00001000` |
| Документ спецификации | `0x00000000/codecs/0x00001000/` (объект DECLARE `1000`) |
| Раздел | 8 `1000` (Edge TOULMIN), смещение внутри раздела C = 0 |
| Kind | Edge · семейство: TOULMIN, группа: объявление, раскладка: NODE |
| TAG WORD | `0001 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | объявление дела. Граф вердиктов, содержащий узлы и отношения |
| Сторона Hugo | `edge/toulmin/node.md` |

## Раскладка {#레이아웃}

Раскладка — [NODE](_index.md#node). Заголовок в 1 WORD задаёт role, level, форму Claim и условные поля.

| Пункт | Значение |
|---|---|
| TANGEUL | in case of |
| Узел | дело |

- role должен быть 0.
- Общие поля (ID, REF, SPAN) и числовые правила следуют [TOULMIN](_index.md#공통-필드).

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1000`). Условные поля раскладки NODE и ширину SPAN, задаваемую SOURCE, нельзя объявить через FIELD, поэтому объявление полей остаётся открытой проблемой ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001000/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000100000000000
BODY
#1 DECLARE 0x1000
#2 BIND #1 "CASE-DECLARE"
```
