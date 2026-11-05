---
title: "COUNTER-DECLARE (0x104L)"
weight: 260
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "COUNTER-DECLARE — NODE Codec, записывающий узел графа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COUNTER-DECLARE — NODE Codec, записывающий узел графа TOULMIN. Значение: объявление возражения. Атакует, имея собственный вывод. Level по умолчанию — Fail.

| Пункт | Значение |
|---|---|
| Имя | `COUNTER-DECLARE` (BIND `COUNTER-DECLARE` документа спецификации) |
| TAG ID | `0x104L` |
| Codec ID | `0x00001040` |
| Документ спецификации | `0x00000000/codecs/0x00001040/` (объект DECLARE `1040`) |
| Раздел | 8 `1000` (Edge TOULMIN), смещение внутри раздела C = 4 |
| Kind | Edge · семейство: TOULMIN, группа: объявление, раскладка: NODE |
| TAG WORD | `0001 0000 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | объявление возражения. Атакует, имея собственный вывод. Level по умолчанию — Fail |
| Сторона Hugo | `edge/toulmin/node.md` |

## Раскладка {#레이아웃}

Раскладка — [NODE](_index.md#node). Заголовок в 1 WORD задаёт role, level, форму Claim и условные поля.

| Пункт | Значение |
|---|---|
| TANGEUL | counter rule |
| Узел | возражение (Rebuttal) |

- role должен быть 1 (counter). Если level равен 0 (Unset), используется значение движка по умолчанию — Fail.
- Общие поля (ID, REF, SPAN) и числовые правила следуют [TOULMIN](_index.md#공통-필드).

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1040`). Условные поля раскладки NODE и ширину SPAN, задаваемую SOURCE, нельзя объявить через FIELD, поэтому объявление полей остаётся открытой проблемой ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001040/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000104000000000
BODY
#1 DECLARE 0x1040
#2 BIND #1 "COUNTER-DECLARE"
```
